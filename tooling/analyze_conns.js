const fs = require("fs");
const lodash = require("lodash");
const { parse } = require("svg-parser");
const { sizeParams, getPossibleCellTypes, indexToLetter } = require("./common");
const xml2json = require("xml2json");
const { createCanvas, loadImage } = require("@napi-rs/canvas");

function getNearestY(y) {
  return Math.round(y / 4) * 4;
}

const svgPath =
  "/Users/giuliozausa/personal/programming/rdpiano/ic19_trace.svg";

const cellDefs = JSON.parse(
  xml2json.toJson(fs.readFileSync("celldefs.xml", "utf8"))
).celldefs.cell;

if (!fs.existsSync(`../cells_conn/`)) {
  fs.mkdirSync(`../cells_conn/`);
}

async function process() {
  const rbush = (await import("rbush")).default;

  const cellTypes = getPossibleCellTypes();

  const svgContent = fs.readFileSync(svgPath, "utf8");
  const svgParsed = parse(svgContent);
  const connsG = svgParsed.children[0].children[2].children.find(
    (c) => c.properties["inkscape:label"] === "CONNS"
  );

  const connPoints = connsG.children.map((conn) => ({
    r: conn.properties.r,
    x: conn.properties.cx,
    y: conn.properties.cy,
    minX: conn.properties.cx - conn.properties.r,
    maxX: conn.properties.cx + conn.properties.r,
    minY: conn.properties.cy - conn.properties.r,
    maxY: conn.properties.cy + conn.properties.r,
  }));

  const tree = new rbush();
  tree.load(connPoints);

  const cells = [];
  cellTypes.forEach((cellType) => {
    const cellsInType = fs
      .readdirSync(`../ident_cells/${cellType}`)
      .filter((f) => f !== ".DS_Store" && !f.startsWith("specimen"));
    const nCellsVertical = parseFloat(cellType.split("_")[0]);

    const ioDef = cellDefs.find(
      (cd) =>
        cd.name === cellType.split("_")[1] && cd.size == cellType.split("_")[0]
    );

    cellsInType.forEach((cell) => {
      const [lx, ly] = cell.replace(".jpg", "").split("_").map(parseFloat);

      const minX = lx * sizeParams.cellWidthWithMargin + sizeParams.cellsStartX;
      const maxX =
        lx * sizeParams.cellWidthWithMargin +
        sizeParams.cellsStartX +
        sizeParams.cellWidth;
      const minY = ly * sizeParams.cellHeight + sizeParams.cellsStartY;
      const maxY =
        (ly + nCellsVertical) * sizeParams.cellHeight + sizeParams.cellsStartY;

      cells.push({
        path: `../ident_cells/${cellType}/${cell}`,
        lx,
        ly,
        cellType,
        connPoints: tree.search({ minX, minY, maxX, maxY }),
        minY,
        height: maxY - minY,
        ioDef,
      });
    });
  });

  const cellTypesWithConns = await Promise.all(
    cellTypes.map(async (cellType) => {
      const cellsWithType = cells.filter((c) => c.cellType === cellType);
      if (cellsWithType.length === 0) return null;

      const connLengths = cellsWithType
        .map((c) => c.connPoints.length)
        .filter((n) => n > 0);
      if (connLengths.length === 0) {
        console.log("warning: no conns defined for", cellType);
        return [];
      }
      if (Array.from(new Set(connLengths)).length !== 1) {
        console.log(
          "warning: different number of connections for",
          cellType,
          Array.from(new Set(connLengths))
        );
      }

      const firstCell = lodash.maxBy(cellsWithType, (c) => c.connPoints.length);

      if (!firstCell.ioDef) {
        console.log("warning: no ioDef for", cellType);
      }

      // XML quirks...
      const originalConns = [];
      if (firstCell.ioDef && Array.isArray(firstCell.ioDef.input)) {
        originalConns.push(
          ...firstCell.ioDef.input.map((p) => ({ ...p, io: "input" }))
        );
      } else if (firstCell.ioDef && firstCell.ioDef.input) {
        originalConns.push({ ...firstCell.ioDef.input, io: "input" });
      }
      if (firstCell.ioDef && Array.isArray(firstCell.ioDef.output)) {
        originalConns.push(
          ...firstCell.ioDef.output.map((p) => ({ ...p, io: "output" }))
        );
      } else if (firstCell.ioDef && firstCell.ioDef.output) {
        originalConns.push({ ...firstCell.ioDef.output, io: "output" });
      }
      originalConns.sort((a, b) => parseFloat(a.ypos) - parseFloat(b.ypos));
      if (
        firstCell.ioDef &&
        originalConns.length !== firstCell.connPoints.length
      ) {
        console.log("warning: mismatched pin number", cellType, {
          expected: originalConns.length,
          actual: firstCell.connPoints.length,
        });
      }

      const connYsAll = cellsWithType
        .map((cell) =>
          cell.connPoints.map((cp) => cp.y - cell.minY).sort((a, b) => a - b)
        )
        .filter((c) => c.length === firstCell.connPoints.length);
      const connYs = firstCell.connPoints.map(
        (_, i) =>
          connYsAll.map((c) => c[i]).reduce((a, b) => a + b) / connYsAll.length
      );

      const conns = connYs.map((cy, i) => ({ cy, ...originalConns[i] }));

      // Save cells image example
      const canvas = createCanvas(
        391,
        160 * parseFloat(cellType.split("_")[0])
      );
      const ctx = canvas.getContext("2d");
      ctx.drawImage(await loadImage(fs.readFileSync(firstCell.path)), 0, 0);
      conns.forEach((conn) => {
        const py = Math.round(
          (conn.cy / firstCell.height) * 160 * parseFloat(cellType.split("_")[0])
        );
        const pr = (5.6791458 / (5122.26 + 5363.88)) * 29723;
        if (conn.io === "input") ctx.fillStyle = "#0000FFAA";
        else ctx.fillStyle = "#FF0000AA";
        ctx.fillRect(30, py - pr, 391 - 30, pr * 2);
      });
      const imgData = await canvas.encode("jpeg");
      fs.writeFileSync(`../cells_conn/${cellType.split("_")[1]}.jpg`, imgData);

      return {
        name: cellType.split("_")[1],
        size: parseFloat(cellType.split("_")[0]),
        description: firstCell.ioDef?.description,
        conns,
      };
    })
  );

  // console.log(JSON.stringify(cellTypesWithConns, null, 2));

  fs.writeFileSync(
    "cellsInfo.json",
    JSON.stringify(cellTypesWithConns, null, 2)
  );
}

process();
