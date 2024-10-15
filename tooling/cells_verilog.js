const fs = require("fs");
const lodash = require("lodash");
const { parse } = require("svg-parser");

const svgPath =
  "/Users/giuliozausa/personal/programming/rdpiano/ic19_trace.svg";

const totalCellHeight = 6780.243;
const totalCellHeightCount = 120;
const cellWidth = 138;
const cellWidthWithMargin = 349;
const cellsStartX = -3633;
const cellsStartY = -3256.87;
const cellHeight = totalCellHeight / totalCellHeightCount;

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
const svgContentLines = svgContent.split("\n");
const svgParsed = parse(svgContent);
const wiresG = svgParsed.children[0].children[2].children.find(
  (c) => c.properties["inkscape:label"] === "WIRES"
);
const cellsG = svgParsed.children[0].children[2].children.find(
  (c) => c.properties["inkscape:label"] === "CELLS"
);

const lines = [];

cellTypes.forEach((cellType) => {
  const cellsInType = fs
    .readdirSync(`../ident_cells/${cellType}`)
    .filter((f) => f !== ".DS_Store" && !f.startsWith("specimen"));
  // console.log(cellType, colorPerCellType[cellType], cellsInType);

  cellsInType.forEach((cell) => {
    const [lx, ly] = cell.replace(".jpg", "").split("_").map(parseFloat);
    lines.push(
      `${
        "cell_" + cellType.toLowerCase().replaceAll(":", "_")
      } inst_${lx}_${ly} ();`
    );
  });
});

fs.writeFileSync("out.v", lines.join("\n"));
