const fs = require("fs");
const lodash = require("lodash");
const { parse } = require("svg-parser");
const {
  generateContrastingColors,
  indexToLetter,
  svgPathToLineSegments,
  sizeParams,
  getPossibleCellTypes,
} = require("./common");

const svgPath =
  "/Users/giuliozausa/personal/programming/rdpiano/ic19_trace copy.svg";

async function process() {
  const rbush = (await import("rbush")).default;

  const colors = generateContrastingColors(40);

  const cellTypes = getPossibleCellTypes();

  const colorPerCellType = Object.fromEntries(
    cellTypes.map((cellType, i) => [cellType, colors[i]])
  );

  const svgContent = fs.readFileSync(svgPath, "utf8");
  const svgContentLines = svgContent.split("\n");
  const svgParsed = parse(svgContent);
  const wiresG = svgParsed.children[0].children[2].children.find(
    (c) => c.properties["inkscape:label"] === "WIRES"
  );
  const cellsG = svgParsed.children[0].children[2].children.find(
    (c) => c.properties["inkscape:label"] === "CELLS"
  );

  const nets = [];
  wiresG.children.forEach((net) => {
    const segments = [];
    if (net.children.length === 0) {
      svgPathToLineSegments(net.properties.d).forEach((segment) => {
        segments.push({
          ...segment,
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
          segments.push({
            ...segment,
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
    nets.push({ id: net.properties.id, segments });
  });

  const cells = [];
  cellTypes.forEach((cellType) => {
    const cellsInType = fs
      .readdirSync(`../ident_cells/${cellType}`)
      .filter((f) => f !== ".DS_Store" && !f.startsWith("specimen"));
    const nCellsVertical = parseFloat(cellType.split("_")[0]);

    cellsInType.forEach((cell) => {
      const [lx, ly] = cell.replace(".jpg", "").split("_").map(parseFloat);
      const color = colorPerCellType[cellType];

      const closestCell = lodash.minBy(cellsG.children, (c) => {
        const { x, y } = c.properties;
        return (
          Math.abs(
            x - (lx * sizeParams.cellWidthWithMargin + sizeParams.cellsStartX)
          ) +
          Math.abs(y - (ly * sizeParams.cellHeight + sizeParams.cellsStartY))
        );
      });

      cells.push({
        lx,
        ly,
        color,
        closestCell,
        cellType,
        minX: lx * sizeParams.cellWidthWithMargin + sizeParams.cellsStartX,
        maxX:
          lx * sizeParams.cellWidthWithMargin +
          sizeParams.cellsStartX +
          sizeParams.cellWidth,
        minY: ly * sizeParams.cellHeight + sizeParams.cellsStartY,
        maxY:
          (ly + nCellsVertical) * sizeParams.cellHeight +
          sizeParams.cellsStartY,
        nets: [],
      });
    });
  });

  const tree = new rbush();
  tree.load(cells);

  nets.forEach((net) => {
    const allCells = [];
    net.segments.forEach((segment) => {
      const foundCells1 = tree.search({
        minX: segment.pt1.x,
        minY: segment.pt1.y,
        maxX: segment.pt1.x,
        maxY: segment.pt1.y,
      });
      const foundCells2 = tree.search({
        minX: segment.pt2.x,
        minY: segment.pt2.y,
        maxX: segment.pt2.x,
        maxY: segment.pt2.y,
      });
      const foundCells3 = tree.search({
        minX: segment.pt3.x,
        minY: segment.pt3.y,
        maxX: segment.pt3.x,
        maxY: segment.pt3.y,
      });
      allCells.push(...foundCells1);
      allCells.push(...foundCells2);
      allCells.push(...foundCells3);
    });
    const cellIds = Array.from(
      new Set(allCells.map((c) => c.closestCell.properties.id))
    );
    cellIds.forEach((cellId) =>
      cells
        .find((c) => c.closestCell.properties.id === cellId)
        .nets.push(net.id)
    );
  });

  fs.writeFileSync(
    "out.json",
    JSON.stringify(
      cells.map((c) => ({
        id: c.closestCell.properties.id,
        nets: c.nets,
      })),
      null,
      2
    )
  );

  cells.forEach((cell) => {
    const closestCellLineI = svgContentLines.findIndex(
      (c) => c === `         id="${cell.closestCell.properties.id}"`
    );

    svgContentLines[closestCellLineI] = `         id="${indexToLetter(
      cell.lx
    )}_${cell.ly + 1}_${cell.cellType}"`;
    svgContentLines[
      closestCellLineI - 1
    ] = `         style="fill:${cell.color};stroke:#ff0000;stroke-width:0;-inkscape-stroke:none;opacity:0.5"`;
  });
  fs.writeFileSync("../ic19_trace.svg", svgContentLines.join("\n"));
}

process();
