# RD200 Regression Corpus

Deterministic corpus for trace-equivalence and audio-regression runs.

The active text corpus lives in `librdpiano/testdata/rd200_rom_b/corpus/*.txt` and is consumed by
`librdpiano/test/trace_runner.cpp`.

Each line is one command:

- `render <samples> [auto|20k|32k]`
- `program <index>`
- `note_on <ch> <note> <vel>`
- `note_off <ch> <note> <vel>`
- `cc <ch> <controller> <value>`
- `pc <ch> <program>`
- `raw <status> <data1> <data2>`
- `run <cpu_steps>`
- `tin <0|1>`
- `irq1 <0|1>`

Lines starting with `#` are ignored.
