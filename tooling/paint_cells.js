const fs = require("fs");
const lodash = require("lodash");
const { parse } = require("svg-parser");

const svgPath =
  "/Users/giuliozausa/personal/programming/rdpiano/ic19_trace copy.svg";

const totalCellHeight = 6780.243;
const totalCellHeightCount = 120;
const cellWidth = 138;
const cellWidthWithMargin = 349;
const cellsStartX = -3633;
const cellsStartY = -3256.87;
const cellHeight = totalCellHeight / totalCellHeightCount;

function generateContrastingColors(N) {
  const colors = [];

  for (let i = 0; i < N; i++) {
    // Evenly distribute hues on the color wheel
    const hue = ((i * 360) / N) % 360;
    const rgb = hslToRgb(hue, 0.7, 0.5); // Adjust saturation and lightness as needed
    colors.push(rgbToHex(rgb[0], rgb[1], rgb[2]));
  }

  return colors;
}

// Convert HSL to RGB
function hslToRgb(h, s, l) {
  h /= 360;
  let r, g, b;

  if (s === 0) {
    r = g = b = l; // achromatic
  } else {
    const hue2rgb = (p, q, t) => {
      if (t < 0) t += 1;
      if (t > 1) t -= 1;
      if (t < 1 / 6) return p + (q - p) * 6 * t;
      if (t < 1 / 3) return q;
      if (t < 1 / 2) return p + (q - p) * (2 / 3 - t) * 6;
      return p;
    };

    const q = l < 0.5 ? l * (1 + s) : l + s - l * s;
    const p = 2 * l - q;

    r = hue2rgb(p, q, h + 1 / 3);
    g = hue2rgb(p, q, h);
    b = hue2rgb(p, q, h - 1 / 3);
  }

  return [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)];
}

// Convert RGB to Hex
function rgbToHex(r, g, b) {
  return (
    "#" +
    ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1).toUpperCase()
  );
}

function indexToLetter(index) {
  let letter = "";
  while (index >= 0) {
    letter = String.fromCharCode((index % 26) + 65) + letter;
    index = Math.floor(index / 26) - 1;
  }
  return letter;
}

const colors = generateContrastingColors(40);

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

cellTypes.forEach((cellType) => {
  const cellsInType = fs
    .readdirSync(`../ident_cells/${cellType}`)
    .filter((f) => f !== ".DS_Store" && !f.startsWith("specimen"));
  // console.log(cellType, colorPerCellType[cellType], cellsInType);

  cellsInType.forEach((cell) => {
    const [lx, ly] = cell.replace(".jpg", "").split("_").map(parseFloat);
    const color = colorPerCellType[cellType];

    const closestCell = lodash.minBy(cellsG.children, (c) => {
      const { x, y } = c.properties;
      return (
        Math.abs(x - (lx * cellWidthWithMargin + cellsStartX)) +
        Math.abs(y - (ly * cellHeight + cellsStartY))
      );
    });
    // console.log(closestCell, `id="${closestCell.properties.id}"`);

    const closestCellLineI = svgContentLines.findIndex(
      (c) => c === `         id="${closestCell.properties.id}"`
    );

    svgContentLines[closestCellLineI] = `         id="${indexToLetter(lx)}_${
      ly + 1
    }_${cellType}"`;
    svgContentLines[
      closestCellLineI - 1
    ] = `         style="fill:${color};stroke:#ff0000;stroke-width:0;-inkscape-stroke:none;opacity:0.5"`;
    // console.log(svgContentLines[closestCellLineI]);
  });
});

fs.writeFileSync("../ic19_trace.svg", svgContentLines.join("\n"));
