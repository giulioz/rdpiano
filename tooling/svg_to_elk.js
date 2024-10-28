const fs = require("fs");
const lodash = require("lodash");
const { parse } = require("svg-parser");
const {
  indexToLetter,
  svgPathToLineSegments,
  sizeParams,
  getPossibleCellTypes,
  lineIntersectsCircle,
} = require("./common");

const svgPath =
  "/Users/giuliozausa/personal/programming/rdpiano/ic19_trace.svg";

const totalCellHeight = 6780.243;
const totalCellHeightCount = 120;
const cellWidth = 138;
const cellWidthWithMargin = 349;
const cellsStartX = -3633;
const cellsStartY = -3256.87;
const cellHeight = totalCellHeight / totalCellHeightCount;

async function process() {
  const rbush = (await import("rbush")).default;

  const cellTypes = getPossibleCellTypes();

  const cellsInfo = JSON.parse(fs.readFileSync("cellsInfo.json", "utf8"));

  const svgContent = fs.readFileSync(svgPath, "utf8");
  const svgParsed = parse(svgContent);
  const wiresG = svgParsed.children[0].children[2].children.find(
    (c) => c.properties["inkscape:label"] === "WIRES"
  );
  const cellsG = svgParsed.children[0].children[2].children.find(
    (c) => c.properties["inkscape:label"] === "CELLS"
  );

  const schemContentLines = [];

  const allSegments = wiresG.children.flatMap((net) => {
    const netSegments = [];
    if (net.children.length === 0) {
      svgPathToLineSegments(net.properties.d).forEach((segment) => {
        netSegments.push({
          ...segment,
          netId: net.properties.id,
          pt1: { x: segment.x1, y: segment.y1 },
          pt2: {
            x: (segment.x1 + segment.x2) / 2,
            y: (segment.y1 + segment.y2) / 2,
          },
          pt3: { x: segment.x2, y: segment.y2 },
          minX: Math.min(segment.x1, segment.x2),
          minY: Math.min(segment.y1, segment.y2),
          maxX: Math.max(segment.x1, segment.x2),
          maxY: Math.max(segment.y1, segment.y2),
        });
      });
    } else {
      net.children.forEach((path) => {
        svgPathToLineSegments(path.properties.d).forEach((segment) => {
          netSegments.push({
            ...segment,
            netId: net.properties.id,
            pt1: { x: segment.x1, y: segment.y1 },
            pt2: {
              x: (segment.x1 + segment.x2) / 2,
              y: (segment.y1 + segment.y2) / 2,
            },
            pt3: { x: segment.x2, y: segment.y2 },
            minX: Math.min(segment.x1, segment.x2),
            minY: Math.min(segment.y1, segment.y2),
            maxX: Math.max(segment.x1, segment.x2),
            maxY: Math.max(segment.y1, segment.y2),
          });
        });
      });
    }
    return netSegments;
  });

  const segmentsTree = new rbush();
  segmentsTree.load(allSegments);

  const netsPerCells = [];
  const netsCellsMap = {};

  cellTypes.forEach((cellType) => {
    const cellsInType = fs
      .readdirSync(`../ident_cells/${cellType}`)
      .filter((f) => f !== ".DS_Store" && !f.startsWith("specimen"));

    const [cellsHeight, cellCode, ...cellRest] = cellType.split("_");
    const cellKnown = cellCode.toUpperCase() === cellCode;
    if (!cellKnown) {
      console.log("Unknown cell type", cellType);
      // return;
    }

    const cellInfo = cellsInfo.find((ci) => ci.name === cellCode);
    if (!cellInfo) {
      console.log("No cell info for", cellType);
      return;
    }

    cellsInType.forEach((cell) => {
      const [lx, ly] = cell.replace(".jpg", "").split("_").map(parseFloat);

      const column = indexToLetter(lx);
      const row = ly + 1;
      const ref = `${column}${row}`.toUpperCase();

      const inputPorts = cellInfo.conns.filter((c) => c.io === "input");
      const outputPorts = cellInfo.conns.filter((c) => c.io === "output");

      schemContentLines.push(
        `node ${ref} {
          layout [ size: 50, ${
            10 + Math.max(inputPorts.length * 20, outputPorts.length * 20)
          } ]
          portConstraints: FIXED_SIDE
          label "${cellCode.toUpperCase()}"
          ${inputPorts
            .map((p, i) => `port pi${i} { ^port.side: WEST }`)
            .join("\n")}
          ${outputPorts
            .map((p, i) => `port po${i} { ^port.side: EAST }`)
            .join("\n")}
        }`
      );

      const netsPerCell = cellInfo.conns.map((conn) => {
        const foundNet = allSegments.find((sg) =>
          lineIntersectsCircle(
            sg.x1,
            sg.y1,
            sg.x2,
            sg.y2,
            lx * cellWidthWithMargin + cellsStartX + cellWidth / 2,
            ly * sizeParams.cellHeight + sizeParams.cellsStartY + conn.cy,
            5.6791458
          )
        )?.netId;
        return { conn, netId: foundNet };
      });
      netsPerCells.push({ ref, netsPerCell });

      netsPerCell.forEach(({ netId, conn }) => {
        if (!netId) return;
        if (!netsCellsMap[netId]) netsCellsMap[netId] = [];
        netsCellsMap[netId].push({ ref, io: conn.io });
      });
    });
  });

  Object.entries(netsCellsMap).forEach(([netId, cells]) => {
    const outputs = cells.filter((c) => c.io === "output");
    if (outputs.length > 1) {
      console.log("too many outputs", netId, cells);
    }
    if (outputs.length === 0) {
      console.log("no output", netId, cells);
      return;
    }
    cells
      .filter((c) => c.io === "input")
      .forEach((cell) => {
        schemContentLines.push(`edge ${outputs[0].ref} -> ${cell.ref}`);
      });
  });

  fs.writeFileSync("schem.elk", schemContentLines.join("\n"));
}

process();
