A bunch of custom scripts used to reverse engineer Fujitsu VH/AV gate arrays.

## Pipeline
1. **extract_cells.js**: crops in an image all cells found in an svg trace, exporting a bunch of jpgs grouped by cell size
2. Once all cells are exported, you can identify them and divide them by type manually into ident_cells
3. **analyze_conns.js**: uses the connection points defined in an svg trace and the celldefs.xml file to generate a cell info json file
4. **svg_to_verilog.js**: uses all the data previously generated to export a verilog file

## Other stuff
- paint_cells.js: used to color the cells in an svg file by type
- svg_to_elk.js: failed experiment to use the ELK algorithm to automatically layout a schematic
- svg_to_kicad.js: failed experiment to automatically export a kicad schematic file
- find_cells: experiment to use opencv to identify cells
