# Baseline Traces

Interpreter baseline traces for the deterministic MIDI corpus.

One JSONL file per corpus input, encoded using `librdpiano/docs/rd200_trace_schema.md`.

Suggested generation command:

`tools/rd200_lift/run_trace_suite.py --runtime interpreter --corpus-dir librdpiano/testdata/rd200_rom_b/corpus --out-dir librdpiano/testdata/rd200_rom_b/baseline_traces --rom-dir roms --trace-runner /tmp/rdpiano-build/rd200_trace_runner`
