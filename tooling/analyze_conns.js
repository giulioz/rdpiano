const fs = require("fs");
const lodash = require("lodash");
const { parse } = require("svg-parser");
const { getPossibleCellTypes } = require("./common");
const xml2json = require("xml2json");
const { createCanvas, loadImage } = require("@napi-rs/canvas");

// const ic = "ic19";
// const svgPath =
//   "/Users/giuliozausa/personal/programming/rdpiano/ic19_trace.svg";
// const totalCellWidthMinusOne = 7338;
// const totalCellHeight = 6774;
// const totalCellWidthCount = 22;
// const totalCellHeightCount = 120;
// const cellsStartX = -3640.21;
// const cellsStartY = -3254.92;
// const cellWidth = 147;
// const imageSizeX = 30213;
// const imageSizeY = 29723;
// const imageStartX = -5224.67;
// const imageStartY = -5122.2;
// const imageEndX = 5433.81;
// const imageEndY = 5363.66;
// const cellWidthWithMargin = totalCellWidthMinusOne / (totalCellWidthCount - 1);
// const cellHeight = totalCellHeight / totalCellHeightCount;
// const connRadius = 5.6791458;
// const cellPxWidth = 392;
// const cellPxHeight = (cellHeight / (imageEndY - imageStartY)) * imageSizeY;

const ic = "ic9"
const svgPath =
  "/Users/giuliozausa/personal/programming/rdpiano/ic9_trace.svg";
const totalCellWidthMinusOne = 7335;
const totalCellHeight = 6780;
const totalCellWidthCount = 22;
const totalCellHeightCount = 120;
const cellsStartX = -3642;
const cellsStartY = -3232;
const cellWidth = 146;
const imageSizeX = 30259;
const imageSizeY = 29895;
const imageStartX = -5067.734;
const imageStartY = -5000;
const imageEndX = 5433.70;
const imageEndY = 5388.29;
const cellWidthWithMargin = totalCellWidthMinusOne / (totalCellWidthCount-1);
const cellHeight = totalCellHeight / totalCellHeightCount;
const connRadius = 5.6791458;
const cellPxWidth = 413;
const cellPxHeight = (cellHeight / (imageEndY - imageStartY)) * imageSizeY;

// const ic = "ic8";
// const svgPath = "/Users/giuliozausa/personal/programming/rdpiano/ic8_trace.svg";
// const totalCellWidthMinusOne = 5889.6;
// const totalCellHeight = 5668;
// const totalCellWidthCount = 25;
// const totalCellHeightCount = 156;
// const cellsStartX = -4062.8;
// const cellsStartY = -3902;
// const cellWidth = 96.7;
// const imageSizeX = 30259;
// const imageSizeY = 29895;
// const imageStartX = -5067.734;
// const imageStartY = -5000;
// const imageEndX = 2938.266;
// const imageEndY = 2909.7;
// const cellWidthWithMargin = totalCellWidthMinusOne / (totalCellWidthCount - 1);
// const cellHeight = totalCellHeight / totalCellHeightCount;
// const connRadius = 4;
// const cellPxWidth = 366;
// // const cellPxHeight = 138;
// const cellPxHeight = (cellHeight / (imageEndY - imageStartY)) * imageSizeY;

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
    id: conn.properties["inkscape:label"] ?? conn.properties.id,
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
      const [cic, lx, ly] = cell
        .replace(".jpg", "")
        .split("_")
        .map((a, i) => (i === 0 ? a : parseFloat(a)));
      if (cic !== ic) return;

      const minX = lx * cellWidthWithMargin + cellsStartX;
      const maxX = lx * cellWidthWithMargin + cellsStartX + cellWidth;
      const minY = ly * cellHeight + cellsStartY;
      const maxY = (ly + nCellsVertical) * cellHeight + cellsStartY;

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
        cellPxWidth,
        cellPxHeight * parseFloat(cellType.split("_")[0])
      );
      const ctx = canvas.getContext("2d");
      ctx.drawImage(await loadImage(fs.readFileSync(firstCell.path)), 0, 0);
      conns.forEach((conn) => {
        const py = Math.round(
          (conn.cy / firstCell.height) *
            cellPxHeight *
            parseFloat(cellType.split("_")[0])
        );
        const pr = (connRadius / (imageEndY - imageStartY)) * imageSizeY;
        if (conn.io === "input") ctx.fillStyle = "#0000FFAA";
        else ctx.fillStyle = "#FF0000AA";
        ctx.fillRect(30, py - pr, cellPxWidth - 30, pr * 2);
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
    JSON.stringify(cellTypesWithConns.filter(Boolean), null, 2)
  );
}

process();
