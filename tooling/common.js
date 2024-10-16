const { parseSVG } = require("svg-path-parser");
const fs = require("fs");

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

function svgPathToLineSegments(pathString) {
  const segments = [];
  let currentPoint = { x: 0, y: 0 }; // Track current position for relative commands

  const commands = parseSVG(pathString);

  commands.forEach((command) => {
    switch (command.code) {
      case "M": // Move to absolute
        currentPoint = { x: command.x, y: command.y };
        break;
      case "L": // Line to absolute
        segments.push({
          x1: currentPoint.x,
          y1: currentPoint.y,
          x2: command.x,
          y2: command.y,
        });
        currentPoint = { x: command.x, y: command.y }; // Update current position
        break;
      case "m": // Move to relative
        currentPoint = {
          x: currentPoint.x + command.x,
          y: currentPoint.y + command.y,
        };
        break;
      case "l": // Line to relative
        const x2 = currentPoint.x + command.x;
        const y2 = currentPoint.y + command.y;
        segments.push({ x1: currentPoint.x, y1: currentPoint.y, x2, y2 });
        currentPoint = { x: x2, y: y2 }; // Update current position
        break;
      case "H": // Horizontal line to absolute
        segments.push({
          x1: currentPoint.x,
          y1: currentPoint.y,
          x2: command.x,
          y2: currentPoint.y,
        });
        currentPoint.x = command.x; // Update current position
        break;
      case "h": // Horizontal line to relative
        segments.push({
          x1: currentPoint.x,
          y1: currentPoint.y,
          x2: currentPoint.x + command.x,
          y2: currentPoint.y,
        });
        currentPoint.x += command.x;
        break;
      case "V": // Vertical line to absolute
        segments.push({
          x1: currentPoint.x,
          y1: currentPoint.y,
          x2: currentPoint.x,
          y2: command.y,
        });
        currentPoint.y = command.y; // Update current position
        break;
      case "v": // Vertical line to relative
        segments.push({
          x1: currentPoint.x,
          y1: currentPoint.y,
          x2: currentPoint.x,
          y2: currentPoint.y + command.y,
        });
        currentPoint.y += command.y;
        break;
      // Handle additional commands if necessary (e.g., curves, arcs)
      default:
        console.log("unknown path command", command);
        break;
    }
  });

  return segments;
}

function getPossibleCellTypes() {
  const cellTypes = fs
    .readdirSync("../ident_cells/")
    .filter(
      (f) =>
        f !== ".DS_Store" &&
        fs
          .readdirSync(`../ident_cells/${f}`)
          .filter((f) => f !== ".DS_Store" && !f.startsWith("specimen"))
          .length > 0
    );
  return cellTypes;
}

const totalCellHeight = 6780.243;
const totalCellHeightCount = 120;
const cellWidth = 138;
const cellWidthWithMargin = 349;
const cellsStartX = -3633;
const cellsStartY = -3256.87;
const cellHeight = totalCellHeight / totalCellHeightCount;
const sizeParams = {
  totalCellHeight,
  totalCellHeightCount,
  cellWidth,
  cellWidthWithMargin,
  cellsStartX,
  cellsStartY,
  cellHeight,
};

module.exports = {
  generateContrastingColors,
  indexToLetter,
  svgPathToLineSegments,
  sizeParams,
  getPossibleCellTypes,
};
