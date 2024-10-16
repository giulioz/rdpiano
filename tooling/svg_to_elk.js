const fs = require("fs");
const lodash = require("lodash");
const { parse } = require("svg-parser");
const { v4: uuidv4 } = require("uuid");

const svgPath =
  "/Users/giuliozausa/personal/programming/rdpiano/ic19_trace.svg";

const totalCellHeight = 6780.243;
const totalCellHeightCount = 120;
const cellWidth = 138;
const cellWidthWithMargin = 349;
const cellsStartX = -3633;
const cellsStartY = -3256.87;
const cellHeight = totalCellHeight / totalCellHeightCount;

function indexToLetter(index) {
  let letter = "";
  while (index >= 0) {
    letter = String.fromCharCode((index % 26) + 65) + letter;
    index = Math.floor(index / 26) - 1;
  }
  return letter;
}

const cellTypes = fs
  .readdirSync("../ident_cells/")
  .filter(
    (f) =>
      f !== ".DS_Store" &&
      fs
        .readdirSync(`../ident_cells/${f}`)
        .filter((f) => f !== ".DS_Store" && !f.startsWith("specimen")).length >
        0
  );

const svgContent = fs.readFileSync(svgPath, "utf8");
const svgParsed = parse(svgContent);
const wiresG = svgParsed.children[0].children[2].children.find(
  (c) => c.properties["inkscape:label"] === "WIRES"
);
const cellsG = svgParsed.children[0].children[2].children.find(
  (c) => c.properties["inkscape:label"] === "CELLS"
);

const schemContentLines = [];

cellTypes.forEach((cellType) => {
  const cellsInType = fs
    .readdirSync(`../ident_cells/${cellType}`)
    .filter((f) => f !== ".DS_Store" && !f.startsWith("specimen"));
  // console.log(cellType, colorPerCellType[cellType], cellsInType);

  const [cellsHeight, cellCode, ...cellRest] = cellType.split("_");
  const cellKnown = cellCode.toUpperCase() === cellCode;
  if (!cellKnown) {
    console.log("Unknown cell type", cellType);
    // return;
  }

  cellsInType.forEach((cell) => {
    const [lx, ly] = cell.replace(".jpg", "").split("_").map(parseFloat);

    const closestCell = lodash.minBy(cellsG.children, (c) => {
      const { x, y } = c.properties;
      return (
        Math.abs(x - (lx * cellWidthWithMargin + cellsStartX)) +
        Math.abs(y - (ly * cellHeight + cellsStartY))
      );
    });

    const ioNets =
      closestCell.children[0]?.children[0]?.value.split("\n") ?? [];
    console.log(
      ioNets.map((netId) =>
        wiresG.children.find((w) => w.properties.id === netId)
      )
    );

    const column = indexToLetter(lx);
    const row = ly + 1;
    const ref = `${column}${row}`.toUpperCase();

    schemContentLines.push(`node ${ref} { label "${cellCode.toUpperCase()}" }`);
  });
});

fs.writeFileSync("schem.elk", schemContentLines.join("\n"));
