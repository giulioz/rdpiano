const fs = require("fs");
const lodash = require("lodash");
const { parse } = require("svg-parser");
const {
  indexToLetter,
  svgPathToLineSegments,
  getPossibleCellTypes,
  lineIntersectsCircle,
} = require("./common");

const ic = "ic19";
const svgPath =
  "/Users/giuliozausa/personal/programming/rdpiano/ic19_trace.svg";
const totalCellWidthMinusOne = 7338;
const totalCellHeight = 6774;
const totalCellWidthCount = 22;
const totalCellHeightCount = 120;
const cellsStartX = -3640.21;
const cellsStartY = -3254.92;
const cellWidth = 147;
const imageSizeX = 30213;
const imageSizeY = 29723;
const imageStartX = -5224.67;
const imageStartY = -5122.2;
const imageEndX = 5433.81;
const imageEndY = 5363.66;
const cellWidthWithMargin = totalCellWidthMinusOne / (totalCellWidthCount - 1);
const cellHeight = totalCellHeight / totalCellHeightCount;
const connRadius = 5.6791458;
const cellPxWidth = 392;
const cellPxHeight = (cellHeight / (imageEndY - imageStartY)) * imageSizeY;

// const ic = "ic9"
// const svgPath =
//   "/Users/giuliozausa/personal/programming/rdpiano/ic9_trace.svg";
// const totalCellWidthMinusOne = 7335;
// const totalCellHeight = 6780;
// const totalCellWidthCount = 22;
// const totalCellHeightCount = 120;
// const cellsStartX = -3642;
// const cellsStartY = -3232;
// const cellWidth = 146;
// const imageSizeX = 30259;
// const imageSizeY = 29895;
// const imageStartX = -5067.734;
// const imageStartY = -5000;
// const imageEndX = 5433.70;
// const imageEndY = 5388.29;
// const cellWidthWithMargin = totalCellWidthMinusOne / (totalCellWidthCount-1);
// const cellHeight = totalCellHeight / totalCellHeightCount;
// const connRadius = 5.6791458;
// const cellPxWidth = 413;
// const cellPxHeight = (cellHeight / (imageEndY - imageStartY)) * imageSizeY;

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

function astToString(ast, notRoot = false, lastOp = null) {
  if (ast.type === "ident") {
    return ast.value;
  } else if (ast.type === "op") {
    const values = ast.values
      .map((a) => astToString(a, true, ast.op))
      .join(" " + ast.op + " ");
    if (lastOp === ast.op) return values;
    else if (notRoot) return `(${values})`;
    else return values;
  } else if (ast.type === "neg") {
    return `~${astToString(ast.value, true)}`;
  }
}

function astHasIdent(ast, ident) {
  if (ast.type === "ident" && ast.value === ident) {
    return true;
  } else if (ast.type === "op") {
    return ast.values.some((v) => astHasIdent(v, ident));
  } else if (ast.type === "neg") {
    return astHasIdent(ast.value, ident);
  }
  return false;
}

function fixAst(ast, ident, fn, substRef) {
  if (ast.type === "ident" && ast.value === ident) {
    substRef.subst = true;
    return fn(ast);
  } else if (ast.type === "op") {
    return {
      type: "op",
      op: ast.op,
      values: ast.values.map((a) => fixAst(a, ident, fn, substRef)),
    };
  } else if (ast.type === "neg") {
    return { type: "neg", value: fixAst(ast.value, ident, fn, substRef) };
  }
  return ast;
}

function fixDoubleNeg(ast) {
  if (ast.type === "ident") {
    return ast;
  } else if (ast.type === "op") {
    return {
      type: "op",
      op: ast.op,
      values: ast.values.map((a) => fixDoubleNeg(a)),
    };
  } else if (ast.type === "neg" && ast.value.type === "neg") {
    return fixDoubleNeg(ast.value.value);
  } else if (ast.type === "neg") {
    return { type: "neg", value: fixDoubleNeg(ast.value) };
  }
  return ast;
}

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

  const allSegments = wiresG.children.flatMap((net) => {
    const netSegments = [];
    if (net.children.length === 0) {
      svgPathToLineSegments(net.properties.d).forEach((segment) => {
        netSegments.push({
          ...segment,
          netId: net.properties["inkscape:label"] ?? net.properties.id,
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
            netId: net.properties["inkscape:label"] ?? net.properties.id,
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

  const items = [];
  const nets = {};

  // Build netlist and cell list
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

    const inputPorts = cellInfo.conns.filter((c) => c.io === "input");
    const outputPorts = cellInfo.conns.filter((c) => c.io === "output");
    const unkPorts = cellInfo.conns.filter((c) => !c.io);

    cellsInType.forEach((cell) => {
      const [cellIc, lx, ly] = cell
        .replace(".jpg", "")
        .split("_")
        .map((a, i) => (i === 0 ? a : parseFloat(a)));
      if (cellIc !== ic) return;

      const column = indexToLetter(lx);
      const row = ly + 1;
      const ref = `${column}${row}`.toUpperCase();

      const netsPerCell = cellInfo.conns.map((conn, i) => {
        const foundNets = allSegments.filter((sg) =>
          lineIntersectsCircle(
            sg.x1,
            sg.y1,
            sg.x2,
            sg.y2,
            lx * cellWidthWithMargin + cellsStartX + cellWidth / 2,
            ly * cellHeight + cellsStartY + conn.cy,
            connRadius
          )
        );
        const foundNetsIds = Array.from(new Set(foundNets.map((n) => n.netId)));
        if (foundNetsIds.length > 1) {
          console.log(
            "ERROR: too many nets on a single pin",
            ref,
            conn.name ?? i,
            foundNets
          );
        }
        if (foundNetsIds.length === 0 && conn.io === "input") {
          console.log(
            "Unconnected input",
            `unconnected_${ref}_${conn.name ?? i}`
          );
        }
        const foundNet = foundNets[0]?.netId;
        return {
          conn,
          netId: foundNet ?? `unconnected_${ref}_${conn.name ?? i}`,
        };
      });

      netsPerCell.forEach((net) => {
        if (net && net.conn.io === "output") {
          nets[net.netId] = nets[net.netId] ?? {};
          nets[net.netId].outputs = nets[net.netId].outputs ?? [];
          nets[net.netId].outputs.push(`${ref}_${net.conn.name}`);
        }
        if (net && net.conn.io === "input") {
          nets[net.netId] = nets[net.netId] ?? {};
          nets[net.netId].inputs = nets[net.netId].inputs ?? [];
          nets[net.netId].inputs.push(`${ref}_${net.conn.name}`);
        }
      });

      const params = [
        ...inputPorts.map((c, i) => ({
          type: "input",
          name: c.name ?? i,
          expr: {
            type: "ident",
            value: netsPerCell.find((n) => n.conn.name === c.name).netId,
          },
        })),
        ...outputPorts.map((c, i) => ({
          type: "output",
          name: c.name ?? i,
          expr: {
            type: "ident",
            value: netsPerCell.find((n) => n.conn.name === c.name).netId,
          },
        })),
        ...unkPorts.map((c, i) => ({
          type: "unknown",
          name: c.name ?? i,
          expr: {
            type: "ident",
            value: netsPerCell.find((n, j) =>
              n.conn.name ? n.conn.name === c.name : i === j
            ).netId,
          },
        })),
      ];
      items.push({
        type: "cell",
        cellCode,
        ref,
        cellDescription: cellInfo.description ?? "Unknown",
        params,
      });
    });
  });

  // console.log(nets);

  // Sanity check nets
  Object.entries(nets).forEach((net) => {
    if ((net[1].outputs ?? []).length > 1) {
      console.log("ERROR: Too many outputs!", net);
    }
    if (
      (net[1].inputs ?? []).length === 0 &&
      !net[0].endsWith("_OUT") &&
      !net[0].endsWith("_IOM")
      // && !net[0].startsWith("unconnected_")
    ) {
      console.log("WARNING: Output with no inputs!", net);
    }
  });

  // Convert some cells to assigns
  items.forEach((item) => {
    if (item.type !== "cell") return;
    const input = item.params.find((p) => p.type === "input");
    const inputsExpr = item.params
      .filter((p) => p.type === "input")
      .map((p) => p.expr);
    const output = item.params.find((p) => p.type === "output");
    if (output.expr.type !== "ident") {
      console.log("Output is not an ident", output);
      return;
    }

    if (
      item.cellCode === "K1B" || // Clock Buffer
      item.cellCode === "K2B" || // Power Clock Buffer
      item.cellCode === "KCB" // Block Clock Buffer (Non-inverting)
    ) {
      item.type = "assign";
      item.name = output.expr.value;
      item.value = input.expr;
    } else if (item.cellCode === "V1N" || item.cellCode === "V2B") {
      // Inverter
      // Power Inverter
      item.type = "assign";
      item.name = output.expr.value;
      item.value = { type: "neg", value: input.expr };
    } else if (
      item.cellCode === "K3B" || // Gated Clock (AND) Buffer
      item.cellCode === "N2P" || // Power 2-input AND
      item.cellCode === "N3P" || // Power 3-input AND
      item.cellCode === "N4P" // Power 4-input AND
    ) {
      item.type = "assign";
      item.name = output.expr.value;
      item.value = { type: "op", op: "&&", values: inputsExpr };
    } else if (
      item.cellCode === "N2N" || // 2-input NAND
      item.cellCode === "N3N" || // 3-input NAND
      item.cellCode === "N4N" || // 4-input NAND
      item.cellCode === "N4B" || // Power 4-input NAND
      item.cellCode === "N6B" || // Power 6-input NAND
      item.cellCode === "N8B" // Power 8-input NAND
    ) {
      item.type = "assign";
      item.name = output.expr.value;
      item.value = {
        type: "neg",
        value: { type: "op", op: "&&", values: inputsExpr },
      };
    } else if (
      item.cellCode === "R2P" || // Power 2-input OR
      item.cellCode === "R4P" || // Power 4-input OR
      item.cellCode === "K4B" // Gated Clock (OR) Buffer
    ) {
      item.type = "assign";
      item.name = output.expr.value;
      item.value = { type: "op", op: "||", values: inputsExpr };
    } else if (
      item.cellCode === "R2N" || // 2-input NOR
      item.cellCode === "R4N" || // 4-input NOR
      item.cellCode === "R2B" || // Power 2-input NOR
      item.cellCode === "R3B" || // Power 3-input NOR
      item.cellCode === "R8B" // Power 8-input NOR
    ) {
      item.type = "assign";
      item.name = output.expr.value;
      item.value = {
        type: "neg",
        value: { type: "op", op: "||", values: inputsExpr },
      };
    } else if (
      item.cellCode === "X2B" // Power EOR
    ) {
      item.type = "assign";
      item.name = output.expr.value;
      item.value = { type: "op", op: "^", values: inputsExpr };
    } else if (
      item.cellCode === "X1B" // Power EXNOR
    ) {
      item.type = "assign";
      item.name = output.expr.value;
      item.value = {
        type: "neg",
        value: { type: "op", op: "^", values: inputsExpr },
      };
    } else if (
      item.cellCode === "D14" // 2-wide 3-AND 4-input AOI
    ) {
      item.type = "assign";
      item.name = output.expr.value;
      const A1 = item.params.find(
        (p) => p.type === "input" && p.name === "A1"
      )?.expr;
      const A2 = item.params.find(
        (p) => p.type === "input" && p.name === "A2"
      )?.expr;
      const A3 = item.params.find(
        (p) => p.type === "input" && p.name === "A3"
      )?.expr;
      const B = item.params.find(
        (p) => p.type === "input" && p.name === "B"
      )?.expr;
      item.value = {
        type: "neg",
        value: {
          type: "op",
          op: "||",
          values: [{ type: "op", op: "&&", values: [A1, A2, A3] }, B],
        },
      };
    } else if (
      item.cellCode === "D23" // 2-wide 2-AND 3-input AOI
    ) {
      item.type = "assign";
      item.name = output.expr.value;
      const A1 = item.params.find(
        (p) => p.type === "input" && p.name === "A1"
      )?.expr;
      const A2 = item.params.find(
        (p) => p.type === "input" && p.name === "A2"
      )?.expr;
      const B = item.params.find(
        (p) => p.type === "input" && p.name === "B"
      )?.expr;
      item.value = {
        type: "neg",
        value: {
          type: "op",
          op: "||",
          values: [{ type: "op", op: "&&", values: [A1, A2] }, B],
        },
      };
    } else if (
      item.cellCode === "D24" // 2-wide 2-AND 4-input AND-OR-Inverter
    ) {
      item.type = "assign";
      item.name = output.expr.value;
      const A1 = item.params.find(
        (p) => p.type === "input" && p.name === "A1"
      )?.expr;
      const A2 = item.params.find(
        (p) => p.type === "input" && p.name === "A2"
      )?.expr;
      const B1 = item.params.find(
        (p) => p.type === "input" && p.name === "B1"
      )?.expr;
      const B2 = item.params.find(
        (p) => p.type === "input" && p.name === "B2"
      )?.expr;
      item.value = {
        type: "neg",
        value: {
          type: "op",
          op: "||",
          values: [
            { type: "op", op: "&&", values: [A1, A2] },
            { type: "op", op: "&&", values: [B1, B2] },
          ],
        },
      };
    } else if (
      item.cellCode === "D34" // 3-wide 2-AND 4-input AOI
    ) {
      item.type = "assign";
      item.name = output.expr.value;
      const A1 = item.params.find(
        (p) => p.type === "input" && p.name === "A1"
      )?.expr;
      const A2 = item.params.find(
        (p) => p.type === "input" && p.name === "A2"
      )?.expr;
      const B1 = item.params.find(
        (p) => p.type === "input" && p.name === "B1"
      )?.expr;
      const B2 = item.params.find(
        (p) => p.type === "input" && p.name === "B2"
      )?.expr;
      item.value = {
        type: "neg",
        value: {
          type: "op",
          op: "||",
          values: [{ type: "op", op: "&&", values: [A1, A2] }, B1, B2],
        },
      };
    } else if (
      item.cellCode === "U24" // Power 2-OR 4-wide Multiplexer
    ) {
      item.type = "assign";
      item.name = output.expr.value;
      const A1 = item.params.find(
        (p) => p.type === "input" && p.name === "A1"
      )?.expr;
      const A2 = item.params.find(
        (p) => p.type === "input" && p.name === "A2"
      )?.expr;
      const B1 = item.params.find(
        (p) => p.type === "input" && p.name === "B1"
      )?.expr;
      const B2 = item.params.find(
        (p) => p.type === "input" && p.name === "B2"
      )?.expr;
      const C1 = item.params.find(
        (p) => p.type === "input" && p.name === "C1"
      )?.expr;
      const C2 = item.params.find(
        (p) => p.type === "input" && p.name === "C2"
      )?.expr;
      const D1 = item.params.find(
        (p) => p.type === "input" && p.name === "D1"
      )?.expr;
      const D2 = item.params.find(
        (p) => p.type === "input" && p.name === "D2"
      )?.expr;
      item.value = {
        type: "neg",
        value: {
          type: "op",
          op: "&&",
          values: [
            { type: "op", op: "||", values: [A1, A2] },
            { type: "op", op: "||", values: [B1, B2] },
            { type: "op", op: "||", values: [C1, C2] },
            { type: "op", op: "||", values: [D1, D2] },
          ],
        },
      };
    } else if (
      item.cellCode === "T24" // Power 2-AND 4-wide Multiplexer
    ) {
      item.type = "assign";
      item.name = output.expr.value;
      const A1 = item.params.find(
        (p) => p.type === "input" && p.name === "A1"
      )?.expr;
      const A2 = item.params.find(
        (p) => p.type === "input" && p.name === "A2"
      )?.expr;
      const B1 = item.params.find(
        (p) => p.type === "input" && p.name === "B1"
      )?.expr;
      const B2 = item.params.find(
        (p) => p.type === "input" && p.name === "B2"
      )?.expr;
      const C1 = item.params.find(
        (p) => p.type === "input" && p.name === "C1"
      )?.expr;
      const C2 = item.params.find(
        (p) => p.type === "input" && p.name === "C2"
      )?.expr;
      const D1 = item.params.find(
        (p) => p.type === "input" && p.name === "D1"
      )?.expr;
      const D2 = item.params.find(
        (p) => p.type === "input" && p.name === "D2"
      )?.expr;
      item.value = {
        type: "neg",
        value: {
          type: "op",
          op: "||",
          values: [
            { type: "op", op: "&&", values: [A1, A2] },
            { type: "op", op: "&&", values: [B1, B2] },
            { type: "op", op: "&&", values: [C1, C2] },
            { type: "op", op: "&&", values: [D1, D2] },
          ],
        },
      };
    } else if (
      item.cellCode === "T26" // Power 2-AND 6-wide Multiplexer
    ) {
      item.type = "assign";
      item.name = output.expr.value;
      const A1 = item.params.find(
        (p) => p.type === "input" && p.name === "A1"
      )?.expr;
      const A2 = item.params.find(
        (p) => p.type === "input" && p.name === "A2"
      )?.expr;
      const B1 = item.params.find(
        (p) => p.type === "input" && p.name === "B1"
      )?.expr;
      const B2 = item.params.find(
        (p) => p.type === "input" && p.name === "B2"
      )?.expr;
      const C1 = item.params.find(
        (p) => p.type === "input" && p.name === "C1"
      )?.expr;
      const C2 = item.params.find(
        (p) => p.type === "input" && p.name === "C2"
      )?.expr;
      const D1 = item.params.find(
        (p) => p.type === "input" && p.name === "D1"
      )?.expr;
      const D2 = item.params.find(
        (p) => p.type === "input" && p.name === "D2"
      )?.expr;
      const E1 = item.params.find(
        (p) => p.type === "input" && p.name === "E1"
      )?.expr;
      const E2 = item.params.find(
        (p) => p.type === "input" && p.name === "E2"
      )?.expr;
      const F1 = item.params.find(
        (p) => p.type === "input" && p.name === "F1"
      )?.expr;
      const F2 = item.params.find(
        (p) => p.type === "input" && p.name === "F2"
      )?.expr;
      item.value = {
        type: "neg",
        value: {
          type: "op",
          op: "||",
          values: [
            { type: "op", op: "&&", values: [A1, A2] },
            { type: "op", op: "&&", values: [B1, B2] },
            { type: "op", op: "&&", values: [C1, C2] },
            { type: "op", op: "&&", values: [D1, D2] },
            { type: "op", op: "&&", values: [E1, E2] },
            { type: "op", op: "&&", values: [F1, F2] },
          ],
        },
      };
    } else if (
      item.cellCode === "T28" // Power 2-AND 8-wide Multiplexer
    ) {
      item.type = "assign";
      item.name = output.expr.value;
      const A1 = item.params.find(
        (p) => p.type === "input" && p.name === "A1"
      )?.expr;
      const A2 = item.params.find(
        (p) => p.type === "input" && p.name === "A2"
      )?.expr;
      const B1 = item.params.find(
        (p) => p.type === "input" && p.name === "B1"
      )?.expr;
      const B2 = item.params.find(
        (p) => p.type === "input" && p.name === "B2"
      )?.expr;
      const C1 = item.params.find(
        (p) => p.type === "input" && p.name === "C1"
      )?.expr;
      const C2 = item.params.find(
        (p) => p.type === "input" && p.name === "C2"
      )?.expr;
      const D1 = item.params.find(
        (p) => p.type === "input" && p.name === "D1"
      )?.expr;
      const D2 = item.params.find(
        (p) => p.type === "input" && p.name === "D2"
      )?.expr;
      const E1 = item.params.find(
        (p) => p.type === "input" && p.name === "E1"
      )?.expr;
      const E2 = item.params.find(
        (p) => p.type === "input" && p.name === "E2"
      )?.expr;
      const F1 = item.params.find(
        (p) => p.type === "input" && p.name === "F1"
      )?.expr;
      const F2 = item.params.find(
        (p) => p.type === "input" && p.name === "F2"
      )?.expr;
      const G1 = item.params.find(
        (p) => p.type === "input" && p.name === "G1"
      )?.expr;
      const G2 = item.params.find(
        (p) => p.type === "input" && p.name === "G2"
      )?.expr;
      const H1 = item.params.find(
        (p) => p.type === "input" && p.name === "H1"
      )?.expr;
      const H2 = item.params.find(
        (p) => p.type === "input" && p.name === "H2"
      )?.expr;
      item.value = {
        type: "neg",
        value: {
          type: "op",
          op: "||",
          values: [
            { type: "op", op: "&&", values: [A1, A2] },
            { type: "op", op: "&&", values: [B1, B2] },
            { type: "op", op: "&&", values: [C1, C2] },
            { type: "op", op: "&&", values: [D1, D2] },
            { type: "op", op: "&&", values: [E1, E2] },
            { type: "op", op: "&&", values: [F1, F2] },
            { type: "op", op: "&&", values: [G1, G2] },
            { type: "op", op: "&&", values: [H1, H2] },
          ],
        },
      };
    } else if (
      item.cellCode === "U42" // Power 4-OR 2-wide Multiplexer
    ) {
      item.type = "assign";
      item.name = output.expr.value;
      const A1 = item.params.find(
        (p) => p.type === "input" && p.name === "A1"
      )?.expr;
      const A2 = item.params.find(
        (p) => p.type === "input" && p.name === "A2"
      )?.expr;
      const A3 = item.params.find(
        (p) => p.type === "input" && p.name === "A3"
      )?.expr;
      const A4 = item.params.find(
        (p) => p.type === "input" && p.name === "A4"
      )?.expr;
      const B1 = item.params.find(
        (p) => p.type === "input" && p.name === "B1"
      )?.expr;
      const B2 = item.params.find(
        (p) => p.type === "input" && p.name === "B2"
      )?.expr;
      const B3 = item.params.find(
        (p) => p.type === "input" && p.name === "B3"
      )?.expr;
      const B4 = item.params.find(
        (p) => p.type === "input" && p.name === "B4"
      )?.expr;
      item.value = {
        type: "neg",
        value: {
          type: "op",
          op: "&&",
          values: [
            { type: "op", op: "||", values: [A1, A2, A3, A4] },
            { type: "op", op: "||", values: [B1, B2, B3, B4] },
          ],
        },
      };
    }
  });

  // Simplify assigns
  const assigns = items.filter((i) => i.type === "assign");
  assigns.forEach((assign) => {
    const isProtected =
      assign.name.endsWith("_IN") ||
      assign.name.endsWith("_OUT") ||
      assign.name.endsWith("_IOM") ||
      assign.name.endsWith("VCC") ||
      assign.name.endsWith("GND");
    if (isProtected) return;

    const shouldAvoidRef = { subst: false };
    items.forEach((item) => {
      if (item.type === "cell") {
        item.params
          .filter((p) => p.type === "input" && p.expr)
          .forEach((param) => {
            param.expr = fixAst(
              param.expr,
              assign.name,
              (ast) => ast,
              // (ast) => assign.value,
              shouldAvoidRef
            );
          });
      }
    });
    const substRef = { subst: false };
    items.forEach((item) => {
      if (item.type === "assign") {
        item.value = fixAst(
          item.value,
          assign.name,
          (ast) => assign.value,
          substRef
        );
      }
    });
    if (substRef.subst && !substRef.subst) {
      // assign.used = true;
    }
  });

  // Simplify further by removing double negations
  assigns.forEach((assign) => {
    assign.value = fixDoubleNeg(assign.value);
  });

  // Remove all unused assigns
  items.forEach((item) => {
    // item.used = true;

    item.used = false;

    const isProtected =
      item.type === "assign" &&
      (item.name.endsWith("_IN") ||
        item.name.endsWith("_OUT") ||
        item.name.endsWith("_IOM") ||
        item.name.endsWith("VCC") ||
        item.name.endsWith("GND"));
    if (item.type === "cell" || isProtected) {
      item.used = true;
      return;
    }

    if (item.type === "assign") {
      const used = items.find((item2) => {
        const isCell = item2.type === "cell";
        const isProtectedAssign =
          item2.type === "assign" &&
          (item2.name?.endsWith("_IN") ||
            item2.name?.endsWith("_OUT") ||
            item2.name?.endsWith("_IOM") ||
            item2.name?.endsWith("VCC") ||
            item2.name?.endsWith("GND"));
        return isCell
          ? item2.params.some((p) => astHasIdent(p.expr, item.name))
          : isProtectedAssign
          ? astHasIdent(item2.value, item.name)
          : false;
      });
      item.used |= Boolean(used);
    }
  });

  // Merge latches
  // items.forEach((item) => {
  //   if (item.cellCode === "LT4") item.used = false;
  // });
  // const latchesPerClock = lodash.groupBy(
  //   items.filter((i) => i.type === "cell" && i.cellCode === "LT4"),
  //   (i) => i.params.find((p) => p.type === "input" && p.name === "G").expr.value
  // );

  const codeLines = [];

  // Emit cells module templates
  cellTypes.forEach((cellType) => {
    const [cellsHeight, cellCode, ...cellRest] = cellType.split("_");
    const cellInfo = cellsInfo.find((ci) => ci.name === cellCode);
    if (!cellInfo) {
      console.log("No cell info for", cellType);
      return;
    }

    if (!items.find((c) => c.type === "cell" && c.cellCode === cellCode)) {
      return;
    }

    const inputPorts = cellInfo.conns.filter((c) => c.io === "input");
    const outputPorts = cellInfo.conns.filter((c) => c.io === "output");
    const unkPorts = cellInfo.conns.filter((c) => !c.io);
    const inputPortsLines = inputPorts.map(
      (ip) => `input wire ${ip.name},\n  `
    );
    const outputPortsLines = outputPorts.map(
      (ip) => `output wire ${ip.name},\n  `
    );
    const unkPortsLines = unkPorts.map(
      (ip, i) => `unk wire ${ip.name ?? `p_${i}`},\n  `
    );
    const params = [
      inputPortsLines.join(""),
      outputPortsLines.join(""),
      unkPortsLines.join(""),
    ]
      .join("")
      .slice(0, -4);

    codeLines.push(
      `// ${items.filter((i) => i.cellCode === cellCode).length} instances
module cell_${cellCode} ( // ${
        cellInfo.description ?? "Unknown"
      }\n  ${params}\n);\nendmodule\n`
    );
  });

  codeLines.push(`\n\n`);

  // Emit latches
  // Object.entries(latchesPerClock).forEach(([_clockNet, latches]) => {
  //   const clocks = latches.flatMap((l) =>
  //     l.params
  //       .filter((p) => p.type === "input" && p.name === "G")
  //       .map((p) => [l.ref, p])
  //   );
  //   const inputs = latches.flatMap((l) =>
  //     l.params
  //       .filter((p) => p.type === "input" && p.name !== "G")
  //       .map((p) => [l.ref, p])
  //   );
  //   const outputs = latches.flatMap((l) =>
  //     l.params.filter((p) => p.type === "output").map((p) => [l.ref, p])
  //   );
  //   const usePos =
  //     outputs
  //       .filter((p) => p[1].name.startsWith("P"))
  //       .filter((p) => !p[1].expr.value.startsWith("unconnected")).length === 0;
  //   const useNeg =
  //     outputs
  //       .filter((p) => p[1].name.startsWith("N"))
  //       .filter((p) => !p[1].expr.value.startsWith("unconnected")).length === 0;
  //   const outputsFilt =
  //     (usePos && useNeg) || (!usePos && !useNeg)
  //       ? outputs
  //       : outputs.filter((p) => p[1].name.startsWith(usePos ? "N" : "P"));
  //   if ((usePos && useNeg) || (!usePos && !useNeg)) {
  //     console.log("Mixed!", outputs);
  //   }
  //   const params = [clocks[0], ...inputs, ...outputsFilt]
  //     .map(
  //       (param) =>
  //         `  ${astToString(param[1].expr)}, // ${param[1].type.toUpperCase()} ${
  //           param[1].name
  //         } ${param[0]}\n`
  //     )
  //     .join("")
  //     .slice(0, -1);
  //   codeLines.push(`latch (\n${params}\n);\n`);
  // });

  // Emit cells code
  items
    .filter((i) => i.type === "cell" && i.used)
    .forEach((cell) => {
      const params = cell.params
        .map(
          (param) =>
            `  ${astToString(param.expr)}, // ${param.type.toUpperCase()} ${
              param.name
            }\n`
        )
        .join("")
        .slice(0, -1);
      codeLines.push(
        `cell_${cell.cellCode} ${cell.ref} ( // ${cell.cellDescription}\n${params}\n);\n`
      );
    });
  items
    .filter((i) => i.type === "assign" && i.used)
    .sort((a, b) => {
      const aIsUpper = a.name[0] === a.name[0].toUpperCase();
      const bIsUpper = b.name[0] === b.name[0].toUpperCase();

      // If one is uppercase and the other is lowercase, place the uppercase first
      if (aIsUpper && !bIsUpper) return -1;
      if (!aIsUpper && bIsUpper) return 1;

      // Otherwise, sort lexicographically
      return a.name.localeCompare(b.name);
    })
    .forEach((assign) => {
      codeLines.push(`assign ${assign.name} = ${astToString(assign.value)};`);
    });

  fs.writeFileSync("out.v", codeLines.join("\n"));
}

process();
