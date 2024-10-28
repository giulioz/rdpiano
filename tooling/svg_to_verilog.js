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

// function convertCellsToExpr(cells, assigns, cellCode, fn) {
//   const cellsToRemove = [];
//   cells.forEach((cell) => {
//     if (cell.cellCode === cellCode) {
//       const inputs = cell.params.filter((p) => p.type === "input");
//       const output = cell.params.find((p) => p.type === "output");
//       assigns.push([output.netId, fn({ inputs })]);
//       cellsToRemove.push(cell.ref);
//     }
//   });
//   cellsToRemove.forEach((ctr) =>
//     [].splice(
//       cells.findIndex((c) => c.ref === ctr),
//       1
//     )
//   );
// }

// function simplifyAssigns(cells, assigns) {
//   assigns.forEach((assign) => {
//   })
//   const assignsToRemove = [];
//   cells.forEach((cell) => {
//     const inputs = cell.params.filter((p) => p.type === "input");
//     inputs.forEach((input) => {
//       assigns.forEach((assign) => {
//         if (input.netId === assign[0]) {
//           input.netId = assign[1];
//           assignsToRemove.push(input.netId);
//         }
//       });
//     });
//   });
// }

function astToString(ast) {
  if (ast.type === "ident") {
    return ast.value;
  } else if (ast.type === "op") {
    return `(${ast.values
      .map((a) => astToString(a))
      .join(" " + ast.op + " ")})`;
  } else if (ast.type === "neg") {
    return `~(${astToString(ast.value)})`;
  }
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

  let items = [];

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
      const [lx, ly] = cell.replace(".jpg", "").split("_").map(parseFloat);

      const column = indexToLetter(lx);
      const row = ly + 1;
      const ref = `${column}${row}`.toUpperCase();

      const netsPerCell = cellInfo.conns.map((conn, i) => {
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
        return {
          conn,
          netId: foundNet ?? `unconnected_${ref}_${conn.name ?? i}`,
        };
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

    if (item.cellCode === "K1B" || item.cellCode === "K2B") {
      // Clock Buffer
      // Power Clock Buffer
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
      item.cellCode === "N2P" || // Power 2-input AND
      item.cellCode === "N3P" || // Power 3-input AND
      item.cellCode === "N4B" // Power 4-input AND
    ) {
      item.type = "assign";
      item.name = output.expr.value;
      item.value = { type: "op", op: "&&", values: inputsExpr };
    } else if (
      item.cellCode === "N2N" || // 2-input NAND
      item.cellCode === "N3N" || // 3-input NAND
      item.cellCode === "N4N" || // 4-input NAND
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
      item.cellCode === "R2B" // Power 2-input NOR
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
      assign.used = true;
    }
  });

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
      `module cell_${cellCode} ( // ${
        cellInfo.description ?? "Unknown"
      }\n  ${params}\n);\nendmodule\n`
    );
  });

  codeLines.push(`\n\n`);

  // Emit cells code
  items
    .filter((i) => i.type === "cell")
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
    .filter((i) => i.type === "assign" && !i.used)
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
