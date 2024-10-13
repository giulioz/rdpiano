const fs = require("fs");
const sharp = require("sharp");
const lodash = require("lodash");
const { parse } = require("svg-parser");
// const PImage = require("pureimage");
// const { createCanvas, loadImage } = require("canvas");
const sizeOf = require("image-size");

const imgPath =
  "/Users/giuliozausa/personal/programming/rdpiano/roland_r15229837_mz_nikon20x.jpg";
const svgPath =
  "/Users/giuliozausa/personal/programming/rdpiano/ic19_trace copy.svg";

const totalCellHeight = 6780.243;
const totalCellHeightCount = 120;
const cellWidth = 138;
const cellWidthWithMargin = 349;
const cellsStartX = -3633;
const cellsStartY = -3256.87;
const cellHeight = totalCellHeight / totalCellHeightCount;

function findIndices(array, callback) {
  const res = [];
  for (let i = 0; i < array.length; i++)
    if (callback(array[i], i, array)) res.push(i);
  return res;
}

// function getRandomColor() {
//   var letters = "0123456789ABCDEF";
//   var color = "#";
//   for (var i = 0; i < 6; i++) {
//     color += letters[Math.floor(Math.random() * 16)];
//   }
//   return color;
// }

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

const colors = generateContrastingColors(40);

function xyToPixelCoord(x, y) {
  const px = Math.round(((x + 5224.6) / (5224.6 + 5433.87)) * 30213);
  const py = Math.round(((y + 5122.26) / (5122.26 + 5363.88)) * 29723);
  return [px, py];
}

const cellTypes = fs
  .readdirSync("../ident_cells/")
  .filter((f) => f !== ".DS_Store");

const colorPerCellType = Object.fromEntries(
  // cellTypes.map((cellType) => [cellType, getRandomColor()])
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

// const img = PImage.make(30213, 29723);
// const img = createCanvas(30213, 29723);
// const ctx = img.getContext("2d");
// ctx.drawImage(img, 0, 0);

cellTypes.forEach((cellType) => {
  const cellsInType = fs
    .readdirSync(`../ident_cells/${cellType}`)
    .filter((f) => f !== ".DS_Store");
  // console.log(cellType, colorPerCellType[cellType], cellsInType);

  cellsInType.forEach((cell) => {
    const imageSize = sizeOf(`../ident_cells/${cellType}/${cell}`);
    const [lx, ly] = cell.replace(".jpg", "").split("_").map(parseFloat);
    const nCells = Math.round(imageSize.height / cellHeight);
    const [px1, py1] = xyToPixelCoord(
      lx * cellWidthWithMargin + cellsStartX,
      ly * cellHeight + cellsStartY
    );
    const [px2, py2] = xyToPixelCoord(
      lx * cellWidthWithMargin + cellWidth + cellsStartX,
      (ly + nCells) * cellHeight + cellsStartY
    );
    const color = colorPerCellType[cellType];

    const closestCell = lodash.minBy(cellsG.children, (c) => {
      const { x, y } = c.properties;
      return (
        Math.abs(x - (lx * cellWidthWithMargin + cellsStartX)) +
        Math.abs(y - (ly * cellHeight + cellsStartY))
      );
    });
    // console.log(closestCell, `id="${closestCell.properties.id}"`);

    const closestCellLineIs = findIndices(
      svgContentLines,
      (c) => c === `         id="${closestCell.properties.id}"`
    );
    if (closestCellLineIs.length > 1) {
      console.log("ERROR", closestCell);
    }
    const closestCellLineI = closestCellLineIs[0];
    // console.log(closestCellLineI, svgContentLines[closestCellLineI]);

    svgContentLines[closestCellLineI] = `         id="${lx}_${ly}_${cellType}"`;
    svgContentLines[
      closestCellLineI - 1
    ] = `         style="fill:${color};stroke:#ff0000;stroke-width:0;-inkscape-stroke:none;opacity:0.5"`;
    // console.log(svgContentLines[closestCellLineI - 1]);

    // ctx.fillStyle = color;
    // ctx.fillRect(
    //   Math.min(px1, px2),
    //   Math.min(py1, py2),
    //   Math.abs(px2 - px1),
    //   Math.abs(py2 - py1)
    // );
  });
});

// PImage.encodePNGToStream(img, fs.createWriteStream("out.png"));

// const out = fs.createWriteStream("out.jpg");
// const stream = canvas.createJPEGStream();
// stream.pipe(out);

fs.writeFileSync("../ic19_trace.svg", svgContentLines.join("\n"));
