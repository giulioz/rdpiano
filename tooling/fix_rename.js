const fs = require("fs");

const types = fs
  .readdirSync("../ident_cells")
  .filter((f) => !f.startsWith(".DS_Store"));
let count = 0;
types.forEach((type) => {
  const instances = fs
    .readdirSync(`../ident_cells/${type}`)
    .filter((f) => f !== ".DS_Store" && !f.startsWith("specimen"));
  count += instances.length;
  instances.forEach((instance) => {
    console.log(`../ident_cells/${type}/${instance}`, `../ident_cells/${type}/ic19_${instance}`);
    fs.renameSync(`../ident_cells/${type}/${instance}`, `../ident_cells/${type}/ic19_${instance}`);
  });
});
console.log(count);
