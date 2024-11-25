const fs = require("fs");
const sharp = require("sharp");
const lodash = require("lodash");
const { parse } = require("svg-parser");

// const imgPath =
//   "/Users/giuliozausa/personal/programming/rdpiano/roland_r15229837_mz_nikon20x.jpg";
// const svgPath =
//   "/Users/giuliozausa/personal/programming/rdpiano/ic19_trace.svg";

// const imgPath =
//   "/Users/giuliozausa/personal/programming/rdpiano/roland_r15229838_mz_nikon20x_quick.jpg";
// const svgPath = "/Users/giuliozausa/personal/programming/rdpiano/ic9_trace.svg";

const imgPath =
  "/Users/giuliozausa/personal/programming/rdpiano/roland_r15229839_mz_nikon20x_quick_smaller.jpg";
const svgPath = "/Users/giuliozausa/personal/programming/rdpiano/ic8_trace.svg";

// avg width: 133.4090909090909
// avg dist: 215.47619047619048
// avg total: 349.4761904761905
// const columns = [
//   [-3633, -3500],
//   [-3283, -3150],
//   [-2933, -2800],
//   [-2584, -2450],
//   [-2235, -2100],
//   [-1885, -1752],
//   [-1534, -1400],
//   [-1185, -1053],
//   [-836, -704],
//   [-488, -355],
//   [-140, -4],
//   [210, 343],
//   [559, 694],
//   [909, 1043],
//   [1258, 1392],
//   [1608, 1741],
//   [1957, 2092],
//   [2307, 2441],
//   [2658, 2790],
//   [3006, 3140],
//   [3356, 3488],
//   [3706, 3837],
// ];

// ic19
// const totalCellHeightCount = 120;
// const cellWidth = 138;
// const cellWidthWithMargin = 349;
// const totalCellHeight = 6780.243;
// const cellsStartX = -3633;
// const cellsStartY = -3256.87;
// const cellHeight = 624.845 / 11;

// ic9
// const totalCellWidthMinusOne = 7335;
// const totalCellHeight = 6780;
// const totalCellWidthCount = 22;
// const totalCellHeightCount = 120;
// const cellsStartX = -3642;
// const cellsStartY = -3232;
// const cellWidth = 146;
// const imageSizeX = 30213;
// const imageSizeY = 29706;
// const imageStartX = -5224;
// const imageStartY = -5091;
// const imageEndX = 5433;
// const imageEndY = 5388;

// ic8
const totalCellWidthMinusOne = 5889.6;
const totalCellHeight = 5668;
const totalCellWidthCount = 25;
const totalCellHeightCount = 156;
const cellsStartX = -4062.8;
const cellsStartY = -3902;
const cellWidth = 96.7;
const imageSizeX = 30259;
const imageSizeY = 29895;
const imageStartX = -5067.734;
const imageStartY = -5000;
const imageEndX = 2938.266;
const imageEndY = 2909.7;

const cellHeight = totalCellHeight / totalCellHeightCount;
const cellWidthWithMargin = totalCellWidthMinusOne / (totalCellWidthCount - 1);

function xyToPixelCoord(x, y) {
  // ic9
  const px = Math.round(
    ((x - imageStartX) / (imageEndX - imageStartX)) * imageSizeX
  );
  const py = Math.round(
    ((y - imageStartY) / (imageEndY - imageStartY)) * imageSizeY
  );

  // const px = Math.round(((x + 5224.6 + offsetX) / (5224.6 + 5433.87)) * 30213);
  // const py = Math.round(
  //   ((y + 5122.26 + offsetY) / (5122.26 + 5363.88)) * 29723
  // );
  return [px, py];
}

const svgContent = fs.readFileSync(svgPath, "utf8");
const svgParsed = parse(svgContent);
const wiresG = svgParsed.children[0].children[2].children.find(
  (c) => c.properties["inkscape:label"] === "WIRES"
);
const cellsG = svgParsed.children[0].children[2].children.find(
  (c) => c.properties["inkscape:label"] === "CELLS"
);

const image = sharp(imgPath, { limitInputPixels: false });

cellsG.children.forEach((c, i) => {
  const { x, y, width, height } = c.properties;

  // const closestColumn = lodash.minBy(columns, ([x1, x2]) => Math.abs(x - x1));
  // const closestColumnI = columns.indexOf(closestColumn);

  const closestColumn = Math.round((x - cellsStartX) / cellWidthWithMargin);
  const closestRow = Math.round((y - cellsStartY) / cellHeight);

  const nCells = Math.round(height / cellHeight);

  const [px1, py1] = xyToPixelCoord(
    closestColumn * cellWidthWithMargin + cellsStartX,
    closestRow * cellHeight + cellsStartY
  );
  const [px2, py2] = xyToPixelCoord(
    closestColumn * cellWidthWithMargin + cellWidth + cellsStartX,
    (closestRow + nCells) * cellHeight + cellsStartY
  );

  if (!fs.existsSync(`../unident_cells/`)) {
    fs.mkdirSync(`../unident_cells/`);
  }
  if (!fs.existsSync(`../unident_cells/${nCells}/`)) {
    fs.mkdirSync(`../unident_cells/${nCells}/`);
  }

  image
    .clone()
    .extract({
      left: Math.min(px1, px2),
      top: Math.min(py1, py2),
      width: Math.abs(px2 - px1),
      height: Math.abs(py2 - py1),
    })
    .toFile(
      `../unident_cells/${nCells}/ic8_${closestColumn}_${closestRow}.jpg`
    );
});
