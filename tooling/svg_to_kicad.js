const fs = require("fs");
const lodash = require("lodash");
const { parse } = require("svg-parser");
const { v4: uuidv4 } = require("uuid");

const svgPath =
  "/Users/giuliozausa/personal/programming/rdpiano/ic19_trace copy.svg";

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
schemContentLines.push(`
(kicad_sch
	(version 20231120)
	(generator "eeschema")
	(generator_version "8.0")
	(uuid "63ceb2e0-4444-45f9-852b-5c8aedd47ba6")
	(paper "A4")`);

cellTypes.forEach((cellType) => {
  const cellsInType = fs
    .readdirSync(`../ident_cells/${cellType}`)
    .filter((f) => f !== ".DS_Store" && !f.startsWith("specimen"));
  // console.log(cellType, colorPerCellType[cellType], cellsInType);

  const [cellHeight, cellCode, ...cellRest] = cellType.split("_");
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

    const column = indexToLetter(lx);
    const row = ly + 1;
    const ref = `${column}${row}`.toUpperCase();

    const centerX = lx * 40;
    const centerY = (ly + parseFloat(cellHeight) / 2) * 8;

    schemContentLines.push(`
    (symbol
      (lib_id "ga_fujitsu_av:${cellCode.toUpperCase()}")
      (at ${centerX} ${centerY} 0)
      (unit 1)
      (exclude_from_sim no)
      (in_bom yes)
      (on_board yes)
      (dnp no)
      (fields_autoplaced yes)
      (uuid "${uuidv4()}")
      (property "Reference" "${ref}"
        (at ${centerX} ${centerY} 0)
        (effects
          (font
            (size 1.27 1.27)
          )
        )
      )
      (instances
        (project "schematics"
          (path "/63ceb2e0-4444-45f9-852b-5c8aedd47ba6"
            (reference "${ref}")
            (unit 1)
          )
        )
      )
    )`);
  });
});

schemContentLines.push(`
  (sheet_instances
    (path "/"
      (page "1")
    )
  )
)`);

fs.writeFileSync("schem.out", schemContentLines.join("\n"));
