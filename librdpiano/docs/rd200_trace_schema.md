# RD200 Trace Schema (JSONL)

Each line is one JSON object. Baseline and candidate runs must use the same schema and ordering.

Common fields:

- `seq`: monotonic event sequence number
- `kind`: event type
- `pc`: CPU program counter at event time

Event kinds:

1. `mmio_read`
- `addr`
- `value`

2. `mmio_write`
- `addr`
- `value`

3. `irq_enter`
- `vector`
- `name`

4. `rti`
- `cc`
- `a`
- `b`
- `x`
- `s`
- `pc_state`

5. `state_snapshot`
- `cc`
- `a`
- `b`
- `x`
- `s`
- `pc_state`
- `tcsr`

Normalization rules:

- Hex values are serialized as integers, not strings.
- Only include events for traced address ranges and IRQ/RTI boundaries.
- No timestamps; order is established only by `seq`.
