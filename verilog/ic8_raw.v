`timescale 1ns/100ps

module IC8 (
  input wire SYNC_IN,
  input wire FSYNC_IN,
  output wire FSYNC_OUT,

  input wire SR_SEL_IN, // 4, maybe inverted
  input wire MPX1_IN, // test mode load data?
  output wire MPX1_OUT,
  output wire MPX2_OUT,
  input wire MPX1_IOM, // 72, maybe inverted, so always 0 (test mode?)

  input wire AG1_IN, // 71
  input wire AG2_IN, // 70
  input wire AG3_IN, // 69

  input wire IC19_1_IN, // 3
  input wire IC19_2_IN, // 2
  input wire IC19_3_IN, // 1
  input wire IC19_4_IN, // 80
  input wire IC19_5_IN, // 79
  input wire IC19_6_IN, // 78
  input wire IC19_7_IN, // 77

  input wire [7:0] R5_D_IN,
  input wire [7:0] R6_D_IN,
  input wire [7:0] R7_D_IN,

  input wire [7:0] R10_D_IN,
  output wire [10:0] R10_A_OUT,

  output wire [15:0] DAC_OUT
);

assign GND = 0;
assign VCC = 1;

assign {R10_D7_IN, R10_D6_IN, R10_D5_IN, R10_D4_IN, R10_D3_IN, R10_D2_IN, R10_D1_IN, R10_D0_IN} = R10_D_IN;
assign R10_A_OUT = {R10_A10_OUT, R10_A9_OUT, R10_A8_OUT, R10_A7_OUT, R10_A6_OUT, R10_A5_OUT, R10_A4_OUT, R10_A3_OUT, R10_A2_OUT, R10_A1_OUT, R10_A0_OUT};

assign DAC_OUT = {DAC16_OUT, DAC15_OUT, DAC14_OUT, DAC13_OUT, DAC12_OUT, DAC11_OUT, DAC10_OUT, DAC9_OUT, DAC8_OUT, DAC7_OUT, DAC6_OUT, DAC5_OUT, DAC4_OUT, DAC3_OUT, DAC2_OUT, DAC1_OUT};

assign {R5_D7_IN, R5_D6_IN, R5_D5_IN, R5_D4_IN, R5_D3_IN, R5_D2_IN, R5_D1_IN, R5_D0_IN} = R5_D_IN;
assign {R6_D7_IN, R6_D6_IN, R6_D5_IN, R6_D4_IN, R6_D3_IN, R6_D2_IN, R6_D1_IN, R6_D0_IN} = R6_D_IN;
assign {R7_D7_IN, R7_D6_IN, R7_D5_IN, R7_D4_IN, R7_D3_IN, R7_D2_IN, R7_D1_IN, R7_D0_IN} = R7_D_IN;


// ==============================================================================
// Test mode variables?

// On MPX, constantly 0?
cell_FDR A117 ( // 4-bit DFF with CLEAR
  MPX1_IOM, // INPUT CL
  MPX1_IN, // INPUT CK
  R10_D7_IN, // INPUT DA
  R10_D6_IN, // INPUT DB
  R10_D5_IN, // INPUT DC
  R10_D4_IN, // INPUT DD
  test_mode_mpx, // OUTPUT QA
  test_mode_dac_out, // OUTPUT QB
  test_mode_inv_waverom, // OUTPUT QC
  test_mode_sr_counter // OUTPUT QD
);
cell_FDR A77 ( // 4-bit DFF with CLEAR
  MPX1_IOM, // INPUT CL
  MPX1_IN, // INPUT CK
  R10_D3_IN, // INPUT DA
  R10_D2_IN, // INPUT DB
  R10_D1_IN, // INPUT DC
  R10_D0_IN, // INPUT DD
  test_mode_outp_dac_latch, // OUTPUT QA
  test_mode_2, // OUTPUT QB
  test_mode_dac_dec_sel, // OUTPUT QC
  test_mode_0 // OUTPUT QD
);


// ==============================================================================
// Internal cycle counter

cell_C45 I16 ( // 4-bit Binary Synchronous Up Counter
  GND, // INPUT DA
  VCC, // INPUT EN
  VCC, // INPUT CI
  FSYNC_IN, // INPUT CL
  GND, // INPUT DB
  VCC, // INPUT L
  SYNC_IN, // INPUT CK
  GND, // INPUT DC
  GND, // INPUT DD
  cnt_i16_qa, // OUTPUT QA
  cnt_i16_qb, // OUTPUT QB
  unconnected_I16_CO, // OUTPUT CO
  cnt_i16_qc, // OUTPUT QC
  cnt_i16_qd // OUTPUT QD
);
cell_DE3 D62 ( // 3:8 Decoder
  cnt_i16_qb, // INPUT B
  cnt_i16_qa, // INPUT A
  cnt_i16_qc, // INPUT C
  cycle_cnt_0, // OUTPUT X0
  cycle_cnt_1, // OUTPUT X1
  cycle_cnt_2, // OUTPUT X2
  cycle_cnt_3, // OUTPUT X3
  cycle_cnt_4, // OUTPUT X4
  cycle_cnt_5, // OUTPUT X5
  cycle_cnt_6, // OUTPUT X6
  cycle_cnt_7 // OUTPUT X7
);

assign cycle_0 =  cycle_cnt_0 || SYNC_IN || cnt_i16_qd;
assign cycle_1 =  cycle_cnt_1 || SYNC_IN || cnt_i16_qd;
assign cycle_2 =  cycle_cnt_2 || SYNC_IN || cnt_i16_qd;
assign cycle_3 =  cycle_cnt_3 || SYNC_IN || cnt_i16_qd;
assign cycle_4 =  cycle_cnt_4 || SYNC_IN || cnt_i16_qd;
assign cycle_5 =  cycle_cnt_5 || SYNC_IN || cnt_i16_qd;
assign cycle_6 =  cycle_cnt_6 || SYNC_IN || cnt_i16_qd;
assign cycle_7 =  cycle_cnt_7 || SYNC_IN || cnt_i16_qd;
assign cycle_8 =  cycle_cnt_0 || SYNC_IN || ~cnt_i16_qd;
assign cycle_9 =  cycle_cnt_1 || SYNC_IN || ~cnt_i16_qd;
assign cycle_10 = cycle_cnt_2 || SYNC_IN || ~cnt_i16_qd;
assign cycle_11 = cycle_cnt_3 || SYNC_IN || ~cnt_i16_qd;
assign cycle_12 = cycle_cnt_4 || SYNC_IN || ~cnt_i16_qd;
assign cycle_13 = cycle_cnt_5 || SYNC_IN || ~cnt_i16_qd;
assign cycle_14 = cycle_cnt_6 || SYNC_IN || ~cnt_i16_qd;
assign cycle_15 = cycle_cnt_7 || SYNC_IN || ~cnt_i16_qd;

assign cycle_odd = ~(cycle_15 && cycle_13 && cycle_11 && cycle_9 && cycle_7 && cycle_5 && cycle_3 && cycle_1);
assign cycle_even = ~(cycle_14 && cycle_12 && cycle_10 && cycle_8 && cycle_6 && cycle_4 && cycle_2 && cycle_0);
assign cycle_even_pos = cycle_14 && cycle_12 && cycle_10 && cycle_8 && cycle_6 && cycle_4 && cycle_2 && cycle_0;
assign cycle_between = cycle_odd || cycle_even;
assign cycle_between_inv = ~(cycle_odd || cycle_even);



// ==============================================================================
// Counters, FSYNC generation

// Counts up to 10 (restarts on low FSYNC and c1=9)
// Current part?
// For 32 KHz?
assign cnt_c1_clear = FSYNC_IN && ~(cnt_c1_d && cnt_c1_a);
cell_C45 C1 ( // 4-bit Binary Synchronous Up Counter
  GND, // INPUT DA
  VCC, // INPUT EN
  VCC, // INPUT CI
  cnt_c1_clear, // INPUT CL
  GND, // INPUT DB
  VCC, // INPUT L
  cycle_between_inv, // INPUT CK
  GND, // INPUT DC
  GND, // INPUT DD
  cnt_c1_a, // OUTPUT QA
  unconnected_C1_QB, // OUTPUT QB
  unconnected_C1_CO, // OUTPUT CO
  unconnected_C1_QC, // OUTPUT QC
  cnt_c1_d // OUTPUT QD
);

// Clears on FSYNC, counts up to 16
// Current voice?
// For 20 KHz?
assign g29_da = ~cnt_g29_a;
assign g29_load = ~test_mode_dac_out;
cell_C45 G29 ( // 4-bit Binary Synchronous Up Counter
  g29_da, // INPUT DA
  VCC, // INPUT EN
  VCC, // INPUT CI
  FSYNC_IN, // INPUT CL
  GND, // INPUT DB
  g29_load, // INPUT L
  cycle_between_inv, // INPUT CK
  GND, // INPUT DC
  GND, // INPUT DD
  cnt_g29_a, // OUTPUT QA
  cnt_g29_b, // OUTPUT QB
  cnt_g29_c, // OUTPUT CO
  cnt_g29_of, // OUTPUT QC
  cnt_g29_d // OUTPUT QD
);

assign voices_end_cnt = ~(~(
  (cnt_c1_d && cnt_c1_a && SR_SEL_IN) ||  // 10 voices (32 KHz)
  (cnt_g29_c && ~SR_SEL_IN)               // 16 voices (20 KHz)
) && ~test_mode_sr_counter);


// When 9 is reached
assign cnt_d1_cnt9 = cnt_d1_d && cnt_d1_a && voices_end_cnt;

// Counts which sample to output at a given time
// Each FSYNC produces a new group
cell_C45 H1 ( // 4-bit Binary Synchronous Up Counter
  GND, // INPUT DA
  cnt_d1_cnt9, // INPUT EN
  VCC, // INPUT CI
  FSYNC_IN, // INPUT CL
  GND, // INPUT DB
  VCC, // INPUT L
  cycle_between_inv, // INPUT CK
  GND, // INPUT DC
  GND, // INPUT DD
  cnt_samplegroup_a_enable, // OUTPUT QA
  cnt_samplegroup_b, // OUTPUT QB
  cnt_samplegroup_of, // OUTPUT CO
  cnt_samplegroup_c, // OUTPUT QC
  cnt_samplegroup_d // OUTPUT QD
);

assign FSYNC_OUT = ~(cnt_samplegroup_of && cnt_d1_cnt9);
assign MPX1_OUT = cnt_samplegroup_a_enable;
assign MPX2_OUT = ~(
  // Test mode?
  (((~adder2_b0_pre && cycle_between_inv) || ((cycle_odd || cycle_even) && ~adder2_b16_pre)) && test_mode_mpx) ||
  // Normal mode?
  (cnt_samplegroup_a_enable && ~test_mode_mpx)
);


// +1 every 10/16 cycles
assign cnt_d1_clear = FSYNC_IN && ~cnt_d1_cnt9;
cell_C45 D1 ( // 4-bit Binary Synchronous Up Counter
  GND, // INPUT DA
  voices_end_cnt, // INPUT EN
  VCC, // INPUT CI
  cnt_d1_clear, // INPUT CL
  GND, // INPUT DB
  VCC, // INPUT L
  cycle_between_inv, // INPUT CK
  GND, // INPUT DC
  GND, // INPUT DD
  cnt_d1_a, // OUTPUT QA
  cnt_d1_b, // OUTPUT QB
  unconnected_D1_CO, // OUTPUT CO
  cnt_d1_c, // OUTPUT QC
  cnt_d1_d // OUTPUT QD
);

assign not_first_sample = ~(
  ((~SR_SEL_IN && cnt_d1_a) || cnt_d1_b || cnt_d1_c || cnt_d1_d) &&
  (cnt_samplegroup_a_enable || cnt_samplegroup_b || cnt_samplegroup_c || cnt_samplegroup_d)
);
cell_FDM A17 ( // DFF
  ~cycle_11, // INPUT CK
  not_first_sample, // INPUT D
  unconnected_A17_XQ, // OUTPUT XQ
  path1329 // OUTPUT Q
);
assign not_first_sample_cycle_11 = ~test_mode_outp_dac_latch && ~path1329;



// ==============================================================================
// Adders

assign adder1_b0       = (wavein_b0  && ~cnt_g29_a) || (GND       && cnt_g29_a);
assign adder1_b1       = (wavein_b1  && ~cnt_g29_a) || (GND       && cnt_g29_a);
assign adder1_b2       = (wavein_b2  && ~cnt_g29_a) || (GND       && cnt_g29_a);
assign adder1_b3       = (wavein_b3  && ~cnt_g29_a) || (GND       && cnt_g29_a);
assign adder1_b4       = (wavein_b4  && ~cnt_g29_a) || (GND       && cnt_g29_a);
assign adder1_b5       = (wavein_b5  && ~cnt_g29_a) || (adder3_o0 && cnt_g29_a);
assign adder1_b6       = (wavein_b6  && ~cnt_g29_a) || (adder3_o1 && cnt_g29_a);
assign adder1_b7       = (wavein_b7  && ~cnt_g29_a) || (adder3_o2 && cnt_g29_a);
assign adder1_b8       = (wavein_b8  && ~cnt_g29_a) || (adder3_o3 && cnt_g29_a);
assign adder1_b9       = (wavein_b9  && ~cnt_g29_a) || (adder3_o4 && cnt_g29_a);
assign adder1_b10      = (wavein_b10 && ~cnt_g29_a) || ((adder3_o5 || adder3_of) && cnt_g29_a);
assign adder1_b11      = (wavein_b11 && ~cnt_g29_a) || ((adder3_o6 || adder3_of) && cnt_g29_a);

assign adder1_a12      = (wavein_b12 && ~cnt_g29_a) || ((adder3_o7 || adder3_of) && cnt_g29_a);
assign adder1_a13      = (wavein_b13 && ~cnt_g29_a) || ((adder3_o8 || adder3_of) && cnt_g29_a);

// Adder 1 (14 bit): gens address for ROM IC10 and some part of DAC out
// A: IC19 volume (multiple stages)
// B: Wave ROM (0-14) or Adder 3
cell_A4H N5 ( // 4-bit Full Adder
  adder1_a3, // INPUT A4
  adder1_b3, // INPUT B4
  adder1_a2, // INPUT A3
  adder1_b2, // INPUT B3
  adder1_a1, // INPUT A2
  adder1_b1, // INPUT B2
  adder1_a0, // INPUT A1
  adder1_b0, // INPUT B1
  GND, // INPUT CI
  path2590, // OUTPUT CO
  r10_ff_a4, // OUTPUT S4
  r10_ff_a3, // OUTPUT S3
  r10_ff_a2, // OUTPUT S2
  r10_ff_a1 // OUTPUT S1
);
cell_A4H J27 ( // 4-bit Full Adder
  adder1_a7, // INPUT A4
  adder1_b7, // INPUT B4
  adder1_a6, // INPUT A3
  adder1_b6, // INPUT B3
  adder1_a5, // INPUT A2
  adder1_b5, // INPUT B2
  adder1_a4, // INPUT A1
  adder1_b4, // INPUT B1
  path2590, // INPUT CI
  path2137, // OUTPUT CO
  r10_ff_a8, // OUTPUT S4
  r10_ff_a7, // OUTPUT S3
  r10_ff_a6, // OUTPUT S2
  r10_ff_a5 // OUTPUT S1
);
cell_A4H L27 ( // 4-bit Full Adder
  adder1_a11, // INPUT A4
  adder1_b11, // INPUT B4
  adder1_a10, // INPUT A3
  adder1_b10, // INPUT B3
  adder1_a9, // INPUT A2
  adder1_b9, // INPUT B2
  adder1_a8, // INPUT A1
  adder1_b8, // INPUT B1
  path2137, // INPUT CI
  path2252, // OUTPUT CO
  r10_adder_o12, // OUTPUT S4
  r10_adder_o11, // OUTPUT S3
  r10_ff_a10, // OUTPUT S2
  r10_ff_a9 // OUTPUT S1
);
cell_A2N L2 ( // 2-bit Full Adder
  adder1_b13, // INPUT B2
  adder1_a13, // INPUT A2
  adder1_b12, // INPUT B1
  adder1_a12, // INPUT A1
  path2252, // INPUT CI
  r10_adder_co, // OUTPUT CO
  r10_adder_o14, // OUTPUT S2
  r10_adder_o13 // OUTPUT S1
);

assign adder1_o11_or_15 = r10_adder_o11 || r10_adder_co;
assign adder1_o12_or_15 = r10_adder_o12 || r10_adder_co;
assign adder1_o13_or_15 = r10_adder_o13 || r10_adder_co;
assign adder1_o14_or_15 = r10_adder_o14 || r10_adder_co;


// Adder 3 (9 bit) aux for adder 1
// A: exp(sub-phase)
// B: Wave ROM (smaller part)
// LUT exp decay
assign adder3_a0 = ~(~(~ag_adder_b8_phase_b8 && ~ag_adder_b7_phase_b7 && ag_adder_b6_phase_b6 && ag_adder_b5_phase_b5) && ~(~ag_adder_b8_phase_b8 && ag_adder_b7_phase_b7 && ag_adder_b6_phase_b6 && ~ag_adder_b5_phase_b5) && ~(ag_adder_b8_phase_b8 && ~ag_adder_b7_phase_b7 && ~ag_adder_b6_phase_b6 && ag_adder_b5_phase_b5) && ~(ag_adder_b8_phase_b8 && ~ag_adder_b7_phase_b7 && ag_adder_b6_phase_b6 && ag_adder_b5_phase_b5) && ~(ag_adder_b8_phase_b8 && ag_adder_b7_phase_b7 && ~ag_adder_b6_phase_b6 && ~ag_adder_b5_phase_b5) && ~(ag_adder_b8_phase_b8 && ag_adder_b7_phase_b7 && ag_adder_b6_phase_b6 && ag_adder_b5_phase_b5));
assign adder3_a1 = ~(VCC && ~(~ag_adder_b8_phase_b8 && ag_adder_b7_phase_b7 && ~ag_adder_b6_phase_b6 && ag_adder_b5_phase_b5) && ~(~ag_adder_b8_phase_b8 && ag_adder_b7_phase_b7 && ag_adder_b6_phase_b6 && ag_adder_b5_phase_b5) && ~(ag_adder_b8_phase_b8 && ~ag_adder_b7_phase_b7 && ~ag_adder_b6_phase_b6 && ag_adder_b5_phase_b5) && ~(ag_adder_b8_phase_b8 && ~ag_adder_b7_phase_b7 && ag_adder_b6_phase_b6 && ~ag_adder_b5_phase_b5) && ~(ag_adder_b8_phase_b8 && ag_adder_b7_phase_b7 && ~ag_adder_b6_phase_b6 && ag_adder_b5_phase_b5) && ~(ag_adder_b8_phase_b8 && ag_adder_b7_phase_b7 && ag_adder_b6_phase_b6 && ~ag_adder_b5_phase_b5) && ~(ag_adder_b8_phase_b8 && ag_adder_b7_phase_b7 && ag_adder_b6_phase_b6 && ag_adder_b5_phase_b5));
assign adder3_a2 = ~(VCC && ~(~ag_adder_b8_phase_b8 && ~ag_adder_b7_phase_b7 && ag_adder_b6_phase_b6 && ag_adder_b5_phase_b5) && ~(~ag_adder_b8_phase_b8 && ag_adder_b7_phase_b7 && ~ag_adder_b6_phase_b6 && ag_adder_b5_phase_b5) && ~(~ag_adder_b8_phase_b8 && ag_adder_b7_phase_b7 && ag_adder_b6_phase_b6 && ~ag_adder_b5_phase_b5) && ~(~ag_adder_b8_phase_b8 && ag_adder_b7_phase_b7 && ag_adder_b6_phase_b6 && ag_adder_b5_phase_b5) && ~(ag_adder_b8_phase_b8 && ~ag_adder_b7_phase_b7 && ag_adder_b6_phase_b6 && ~ag_adder_b5_phase_b5) && ~(ag_adder_b8_phase_b8 && ag_adder_b7_phase_b7 && ~ag_adder_b6_phase_b6 && ~ag_adder_b5_phase_b5) && ~(ag_adder_b8_phase_b8 && ag_adder_b7_phase_b7 && ag_adder_b6_phase_b6 && ~ag_adder_b5_phase_b5));
assign adder3_a3 = ~(VCC && ~(~ag_adder_b8_phase_b8 && ~ag_adder_b7_phase_b7 && ag_adder_b6_phase_b6 && ag_adder_b5_phase_b5) && ~(~ag_adder_b8_phase_b8 && ag_adder_b7_phase_b7 && ag_adder_b6_phase_b6 && ~ag_adder_b5_phase_b5) && ~(ag_adder_b8_phase_b8 && ~ag_adder_b7_phase_b7 && ~ag_adder_b6_phase_b6 && ag_adder_b5_phase_b5) && ~(ag_adder_b8_phase_b8 && ag_adder_b7_phase_b7 && ~ag_adder_b6_phase_b6 && ~ag_adder_b5_phase_b5) && ~(ag_adder_b8_phase_b8 && ag_adder_b7_phase_b7 && ~ag_adder_b6_phase_b6 && ag_adder_b5_phase_b5));
assign adder3_a4 = ~(~(~ag_adder_b8_phase_b8 && ag_adder_b7_phase_b7 && ~ag_adder_b6_phase_b6 && ag_adder_b5_phase_b5) && ~(ag_adder_b8_phase_b8 && ~ag_adder_b7_phase_b7 && ~ag_adder_b6_phase_b6 && ag_adder_b5_phase_b5) && ~(ag_adder_b8_phase_b8 && ~ag_adder_b7_phase_b7 && ag_adder_b6_phase_b6 && ~ag_adder_b5_phase_b5) && ~(ag_adder_b8_phase_b8 && ~ag_adder_b7_phase_b7 && ag_adder_b6_phase_b6 && ag_adder_b5_phase_b5));
assign adder3_a5 = ~(~(~ag_adder_b8_phase_b8 && ~ag_adder_b7_phase_b7 && ~ag_adder_b6_phase_b6 && ~ag_adder_b5_phase_b5) && ~(~ag_adder_b8_phase_b8 && ~ag_adder_b7_phase_b7 && ag_adder_b6_phase_b6 && ~ag_adder_b5_phase_b5) && ~(~ag_adder_b8_phase_b8 && ag_adder_b7_phase_b7 && ~ag_adder_b6_phase_b6 && ag_adder_b5_phase_b5) && ~(~ag_adder_b8_phase_b8 && ag_adder_b7_phase_b7 && ag_adder_b6_phase_b6 && ~ag_adder_b5_phase_b5) && ~(~ag_adder_b8_phase_b8 && ag_adder_b7_phase_b7 && ag_adder_b6_phase_b6 && ag_adder_b5_phase_b5) && ~(ag_adder_b8_phase_b8 && ~ag_adder_b7_phase_b7 && ~ag_adder_b6_phase_b6 && ~ag_adder_b5_phase_b5));
assign adder3_a6 = ~(~(~ag_adder_b8_phase_b8 && ~ag_adder_b7_phase_b7 && ~ag_adder_b6_phase_b6 && ~ag_adder_b5_phase_b5) && ~(~ag_adder_b8_phase_b8 && ~ag_adder_b7_phase_b7 && ag_adder_b6_phase_b6 && ~ag_adder_b5_phase_b5) && ~(~ag_adder_b8_phase_b8 && ~ag_adder_b7_phase_b7 && ag_adder_b6_phase_b6 && ag_adder_b5_phase_b5) && ~(~ag_adder_b8_phase_b8 && ag_adder_b7_phase_b7 && ~ag_adder_b6_phase_b6 && ~ag_adder_b5_phase_b5));
assign adder3_a7 = ~(~(~ag_adder_b8_phase_b8 && ~ag_adder_b7_phase_b7 && ~ag_adder_b6_phase_b6 && ~ag_adder_b5_phase_b5) && ~(~ag_adder_b8_phase_b8 && ~ag_adder_b7_phase_b7 && ~ag_adder_b6_phase_b6 && ag_adder_b5_phase_b5));
assign adder3_a8 = ~ag_adder_b8_phase_b8 && ~ag_adder_b7_phase_b7 && ~ag_adder_b6_phase_b6 && ~ag_adder_b5_phase_b5;
cell_A4H W1 ( // 4-bit Full Adder
  adder3_a3, // INPUT A4
  adder3_b3, // INPUT B4
  adder3_a2, // INPUT A3
  adder3_b2, // INPUT B3
  adder3_a1, // INPUT A2
  adder3_b1, // INPUT B2
  adder3_a0, // INPUT A1
  adder3_b0, // INPUT B1
  GND, // INPUT CI
  path1997, // OUTPUT CO
  adder3_o3, // OUTPUT S4
  adder3_o2, // OUTPUT S3
  adder3_o1, // OUTPUT S2
  adder3_o0 // OUTPUT S1
);
cell_A4H V4 ( // 4-bit Full Adder
  adder3_a7, // INPUT A4
  adder3_b7, // INPUT B4
  adder3_a6, // INPUT A3
  adder3_b6, // INPUT B3
  adder3_a5, // INPUT A2
  adder3_b5, // INPUT B2
  adder3_a4, // INPUT A1
  adder3_b4, // INPUT B1
  path1997, // INPUT CI
  path1597, // OUTPUT CO
  adder3_o7, // OUTPUT S4
  adder3_o6, // OUTPUT S3
  adder3_o5, // OUTPUT S2
  adder3_o4 // OUTPUT S1
);
cell_A1N V69 ( // 1-bit Full Adder
  adder3_a8, // INPUT A
  adder3_b8, // INPUT B
  path1597, // INPUT CI
  adder3_of, // OUTPUT CO
  adder3_o8 // OUTPUT S
);



// ==============================================================================
// Control from IC9

cell_LT2 O9 ( // 1-bit Data Latch
  cycle_even_pos, // INPUT G
  AG1_IN, // INPUT D
  ag1_phase_hi, // OUTPUT Q
  unconnected_O9_XQ // OUTPUT XQ
);

// sub phase bits 5/6/7/8
cell_LT2 O5 ( // 1-bit Data Latch
  cycle_even_pos, // INPUT G
  AG2_IN, // INPUT D
  ag2_latched, // OUTPUT Q
  unconnected_O5_XQ // OUTPUT XQ
);
cell_FDQ O16 ( // 4-bit DFF
  cycle_odd, // INPUT CK
  AG2_IN, // INPUT DA
  AG1_IN, // INPUT DB
  AG3_IN, // INPUT DC
  ag2_latched, // INPUT DD
  ag_adder_b8_phase_b8, // OUTPUT QA
  ag_adder_b7_phase_b7, // OUTPUT QB
  ag_adder_b6_phase_b6, // OUTPUT QC
  ag_adder_b5_phase_b5 // OUTPUT QD
);



// ==============================================================================
// Envelope control from IC19

assign ic19_1_or = ~((~IC19_1_IN && test_mode_inv_waverom) || (IC19_1_IN && ~test_mode_inv_waverom));
assign ic19_3_or = ~((~IC19_3_IN && test_mode_inv_waverom) || (IC19_3_IN && ~test_mode_inv_waverom));
assign ic19_5_or = ~((~IC19_5_IN && test_mode_inv_waverom) || (IC19_5_IN && ~test_mode_inv_waverom));
cell_LT4 I3 ( // 4-bit Data Latch
  cycle_even_pos, // INPUT G
  AG3_IN, // INPUT DA
  ic19_1_or, // INPUT DB
  IC19_6_IN, // INPUT DC
  IC19_7_IN, // INPUT DD
  unconnected_I3_NA, // OUTPUT NA
  ag3_sel_sample_type, // OUTPUT PA
  unconnected_I3_NB, // OUTPUT NB
  ic19_1_or_latch_even, // OUTPUT PB
  unconnected_I3_NC, // OUTPUT NC
  ic19_6_latch_even, // OUTPUT PC
  unconnected_I3_ND, // OUTPUT ND
  ic19_7_latch_even // OUTPUT PD
);
cell_LT4 B1 ( // 4-bit Data Latch
  cycle_even_pos, // INPUT G
  ic19_5_or, // INPUT DA
  IC19_4_IN, // INPUT DB
  ic19_3_or, // INPUT DC
  IC19_2_IN, // INPUT DD
  unconnected_B1_NA, // OUTPUT NA
  ic19_5_or_latch_even, // OUTPUT PA
  unconnected_B1_NB, // OUTPUT NB
  ic19_4_latch_even, // OUTPUT PB
  unconnected_B1_NC, // OUTPUT NC
  ic19_3_or_latch_even, // OUTPUT PC
  unconnected_B1_ND, // OUTPUT ND
  ic19_2_latch_even // OUTPUT PD
);


assign path2420 = ic19_1_or || ag1_phase_hi;
assign g2784 = IC19_6_IN || ag1_phase_hi;
assign path2131 = IC19_7_IN || ag1_phase_hi;
assign path2321 = ic19_5_or || ag1_phase_hi;
cell_FDQ K50 ( // 4-bit DFF
  cycle_odd, // INPUT CK
  GND, // INPUT DA
  path2420, // INPUT DB
  g2784, // INPUT DC
  path2131, // INPUT DD
  unconnected_K50_QA, // OUTPUT QA
  adder1_b13, // OUTPUT QB
  adder1_b12, // OUTPUT QC
  adder1_a11 // OUTPUT QD
);
cell_FDQ B16 ( // 4-bit DFF
  cycle_odd, // INPUT CK
  path2321, // INPUT DA
  IC19_4_IN, // INPUT DB
  ic19_3_or, // INPUT DC
  IC19_2_IN, // INPUT DD
  adder1_a10, // OUTPUT QA
  adder1_a9, // OUTPUT QB
  adder1_a8, // OUTPUT QC
  adder1_a7 // OUTPUT QD
);
cell_FDQ J1 ( // 4-bit DFF
  cycle_odd, // INPUT CK
  ic19_1_or_latch_even, // INPUT DA
  ic19_6_latch_even, // INPUT DB
  ic19_7_latch_even, // INPUT DC
  ic19_5_or_latch_even, // INPUT DD
  adder1_a6, // OUTPUT QA
  adder1_a5, // OUTPUT QB
  adder1_a4, // OUTPUT QC
  adder1_a3 // OUTPUT QD
);



// ==============================================================================
// R10 ROM


// Read LSB (A0=1)
assign path2452 = cycle_between_inv;
cell_LT4 A104 ( // 4-bit Data Latch
  path2452, // INPUT G
  R10_D1_IN, // INPUT DA
  R10_D0_IN, // INPUT DB
  R10_D7_IN, // INPUT DC
  R10_D6_IN, // INPUT DD
  unconnected_A104_NA, // OUTPUT NA
  r10_d1_cybtwn, // OUTPUT PA
  unconnected_A104_NB, // OUTPUT NB
  r10_d0_cybtwn, // OUTPUT PB
  r10_d7_not_cybtwn, // OUTPUT NC
  unconnected_A104_PC, // OUTPUT PC
  r10_d6_not_cybtwn, // OUTPUT ND
  unconnected_A104_PD // OUTPUT PD
);
cell_LT4 A144 ( // 4-bit Data Latch
  path2452, // INPUT G
  R10_D5_IN, // INPUT DA
  R10_D4_IN, // INPUT DB
  R10_D3_IN, // INPUT DC
  R10_D2_IN, // INPUT DD
  r10_d5_not_cybtwn, // OUTPUT NA
  unconnected_A144_PA, // OUTPUT PA
  r10_d4_not_cybtwn, // OUTPUT NB
  unconnected_A144_PB, // OUTPUT PB
  r10_d3_not_cybtwn, // OUTPUT NC
  unconnected_A144_PC, // OUTPUT PC
  unconnected_A144_ND, // OUTPUT ND
  r10_d2_cybtwn // OUTPUT PD
);

// Read MSB (A0=0)
assign path2106 = ~cycle_between_inv;
cell_LT4 B84 ( // 4-bit Data Latch
  path2106, // INPUT G
  R10_D1_IN, // INPUT DA
  R10_D0_IN, // INPUT DB
  VCC, // INPUT DC
  VCC, // INPUT DD
  unconnected_B84_NA, // OUTPUT NA
  r10_d1_ncybtwn, // OUTPUT PA
  unconnected_B84_NB, // OUTPUT NB
  r10_d0_ncybtwn, // OUTPUT PB
  unconnected_B84_NC, // OUTPUT NC
  unconnected_B84_PC, // OUTPUT PC
  unconnected_B84_ND, // OUTPUT ND
  unconnected_B84_PD // OUTPUT PD
);

cell_LT4 H57 ( // 4-bit Data Latch
  cycle_between_inv, // INPUT G
  path2763, // INPUT DA
  VCC, // INPUT DB
  r10_d1_ncybtwn, // INPUT DC
  r10_d0_ncybtwn, // INPUT DD
  ~h57_adder1_o11_or_15, // OUTPUT NA
  h57_adder1_o11_or_15, // OUTPUT PA
  unconnected_H57_NB, // OUTPUT NB
  unconnected_H57_PB, // OUTPUT PB
  unconnected_H57_NC, // OUTPUT NC
  h57_r10_d1_ncybtwn, // OUTPUT PC
  unconnected_H57_ND, // OUTPUT ND
  h57_r10_d0_ncybtwn // OUTPUT PD
);


// Address flip flops
assign R10_A0_OUT = ~cycle_between_inv;
cell_FDM A51 ( // DFF
  cycle_between_inv, // INPUT CK
  r10_ff_a1, // INPUT D
  unconnected_A51_XQ, // OUTPUT XQ
  R10_A1_OUT // OUTPUT Q
);
cell_FDM C77 ( // DFF
  cycle_between_inv, // INPUT CK
  r10_ff_a2, // INPUT D
  unconnected_C77_XQ, // OUTPUT XQ
  R10_A2_OUT // OUTPUT Q
);
cell_FDM B77 ( // DFF
  cycle_between_inv, // INPUT CK
  r10_ff_a3, // INPUT D
  unconnected_B77_XQ, // OUTPUT XQ
  R10_A3_OUT // OUTPUT Q
);
cell_FDM A45 ( // DFF
  cycle_between_inv, // INPUT CK
  r10_ff_a4, // INPUT D
  unconnected_A45_XQ, // OUTPUT XQ
  R10_A4_OUT // OUTPUT Q
);
cell_FDM A29 ( // DFF
  cycle_between_inv, // INPUT CK
  r10_ff_a5, // INPUT D
  unconnected_A29_XQ, // OUTPUT XQ
  R10_A5_OUT // OUTPUT Q
);
cell_FDM B98 ( // DFF
  cycle_between_inv, // INPUT CK
  r10_ff_a6, // INPUT D
  unconnected_B98_XQ, // OUTPUT XQ
  R10_A6_OUT // OUTPUT Q
);
cell_FDM A71 ( // DFF
  cycle_between_inv, // INPUT CK
  r10_ff_a7, // INPUT D
  unconnected_A71_XQ, // OUTPUT XQ
  R10_A7_OUT // OUTPUT Q
);
cell_FDM A23 ( // DFF
  cycle_between_inv, // INPUT CK
  r10_ff_a8, // INPUT D
  unconnected_A23_XQ, // OUTPUT XQ
  R10_A8_OUT // OUTPUT Q
);
cell_FDM E116 ( // DFF
  cycle_between_inv, // INPUT CK
  r10_ff_a9, // INPUT D
  unconnected_E116_XQ, // OUTPUT XQ
  R10_A9_OUT // OUTPUT Q
);
cell_FDM A2 ( // DFF
  cycle_between_inv, // INPUT CK
  r10_ff_a10, // INPUT D
  unconnected_A2_XQ, // OUTPUT XQ
  R10_A10_OUT // OUTPUT Q
);



// ==============================================================================
// WaveRom read


// assign r5_d1_and = ~((~R5_D1_IN && test_mode_inv_waverom) || (R5_D1_IN && ~test_mode_inv_waverom));
// assign r5_d5_and = ~((~R5_D5_IN && test_mode_inv_waverom) || (R5_D5_IN && ~test_mode_inv_waverom));
// assign r5_d6_and = ~((~R5_D6_IN && test_mode_inv_waverom) || (R5_D6_IN && ~test_mode_inv_waverom));
// assign r6_d0_and = ~((~R6_D0_IN && test_mode_inv_waverom) || (R6_D0_IN && ~test_mode_inv_waverom));
// assign r6_d3_and = ~((~R6_D3_IN && test_mode_inv_waverom) || (R6_D3_IN && ~test_mode_inv_waverom));
// assign r6_d7_and = ~((R6_D7_IN && ~test_mode_inv_waverom) || ~(R6_D7_IN || ~test_mode_inv_waverom) || ag3_sel_sample_type);
// assign r6_d7_and_2 = ~((R6_D7_IN && ~test_mode_inv_waverom) || ~(R6_D7_IN || ~test_mode_inv_waverom) || ~ag3_sel_sample_type);
// assign r7_d3_and = ~((~R7_D3_IN && test_mode_inv_waverom) || (R7_D3_IN && ~test_mode_inv_waverom));
// assign r7_d6_and = ~((~R7_D6_IN && test_mode_inv_waverom) || (R7_D6_IN && ~test_mode_inv_waverom));

assign r5_d1_and    = ~(R5_D1_IN && ~test_mode_inv_waverom);
assign r5_d5_and    = ~(R5_D5_IN && ~test_mode_inv_waverom);
assign r5_d6_and    = ~(R5_D6_IN && ~test_mode_inv_waverom);
assign r6_d0_and    = ~(R6_D0_IN && ~test_mode_inv_waverom);
assign r6_d3_and    = ~(R6_D3_IN && ~test_mode_inv_waverom);
assign r6_d7_and    = ~(R6_D7_IN && ~test_mode_inv_waverom) && ~ag3_sel_sample_type;
assign r6_d7_and_2  = ~(R6_D7_IN && ~test_mode_inv_waverom) && ag3_sel_sample_type;
assign r7_d3_and    = ~(R7_D3_IN && ~test_mode_inv_waverom);
assign r7_d6_and    = ~(R7_D6_IN && ~test_mode_inv_waverom);

// G1: 15 bit (LSB is r6_d7, r7_d3 is sign)
// G2: 9 bit (LSB is r6_d7, shared?)
// G3: R6_D1_IN? sign?

cell_FDQ Y2 ( // 4-bit DFF
  cycle_odd, // INPUT CK
  r7_d3_and, // INPUT DA
  R5_D0_IN, // INPUT DB
  R6_D4_IN, // INPUT DC
  R7_D4_IN, // INPUT DD
  wavein_b14_sign, // OUTPUT QA
  wavein_b13, // OUTPUT QB
  wavein_b12, // OUTPUT QC
  wavein_b11 // OUTPUT QD
);
cell_FDQ U56 ( // 4-bit DFF
  cycle_odd, // INPUT CK
  r6_d0_and, // INPUT DA
  R7_D7_IN, // INPUT DB
  R5_D7_IN, // INPUT DC
  r5_d5_and, // INPUT DD
  wavein_b10, // OUTPUT QA
  wavein_b9, // OUTPUT QB
  wavein_b8, // OUTPUT QC
  wavein_b7 // OUTPUT QD
);
cell_FDQ X17 ( // 4-bit DFF
  cycle_odd, // INPUT CK
  R6_D2_IN, // INPUT DA
  R7_D2_IN, // INPUT DB
  R7_D1_IN, // INPUT DC
  r5_d1_and, // INPUT DD
  wavein_b6, // OUTPUT QA
  wavein_b5, // OUTPUT QB
  wavein_b4, // OUTPUT QC
  wavein_b3 // OUTPUT QD
);
cell_FDQ Y56 ( // 4-bit DFF
  cycle_odd, // INPUT CK
  R5_D3_IN, // INPUT DA
  R6_D5_IN, // INPUT DB
  r6_d7_and, // INPUT DC
  r6_d7_and_2, // INPUT DD
  wavein_b2, // OUTPUT QA
  wavein_b1, // OUTPUT QB
  wavein_b0, // OUTPUT QC
  adder3_b0 // OUTPUT QD
);

cell_FDQ Y35 ( // 4-bit DFF
  cycle_odd, // INPUT CK
  r7_d6_and, // INPUT DA
  R5_D4_IN, // INPUT DB
  R7_D0_IN, // INPUT DC
  r6_d3_and, // INPUT DD
  adder3_b8, // OUTPUT QA
  adder3_b7, // OUTPUT QB
  adder3_b6, // OUTPUT QC
  adder3_b5 // OUTPUT QD
);
cell_FDQ X56 ( // 4-bit DFF
  cycle_odd, // INPUT CK
  R5_D2_IN, // INPUT DA
  r5_d6_and, // INPUT DB
  R6_D6_IN, // INPUT DC
  R7_D5_IN, // INPUT DD
  adder3_b4, // OUTPUT QA
  adder3_b3, // OUTPUT QB
  adder3_b2, // OUTPUT QC
  adder3_b1 // OUTPUT QD
);

cell_FDQ O56 ( // 4-bit DFF
  cycle_odd, // INPUT CK
  ic19_4_latch_even, // INPUT DA
  ic19_3_or_latch_even, // INPUT DB
  ic19_2_latch_even, // INPUT DC
  R6_D1_IN, // INPUT DD
  adder1_a2, // OUTPUT QA
  adder1_a1, // OUTPUT QB
  adder1_a0, // OUTPUT QC
  wavein_r6d1_sign // OUTPUT QD
);




// ==============================================================================
// Adder for audio output (18 bit)

assign wavein_sign = (wavein_b14_sign && ~cnt_g29_a) || (wavein_r6d1_sign && cnt_g29_a);

cell_FDQ M44 ( // 4-bit DFF
  cycle_between, // INPUT CK
  adder1_o12_or_15, // INPUT DA
  adder1_o11_or_15, // INPUT DB
  GND, // INPUT DC
  GND, // INPUT DD
  path2406, // OUTPUT QA
  path2763, // OUTPUT QB
  unconnected_M44_QC, // OUTPUT QC
  unconnected_M44_QD // OUTPUT QD
);
cell_FDQ N56 ( // 4-bit DFF
  cycle_between, // INPUT CK
  GND, // INPUT DA
  wavein_sign, // INPUT DB
  adder1_o13_or_15, // INPUT DC
  adder1_o14_or_15, // INPUT DD
  unconnected_N56_QA, // OUTPUT QA
  path2403, // OUTPUT QB
  g2256, // OUTPUT QC
  path2180 // OUTPUT QD
);

cell_LT4 P32 ( // 4-bit Data Latch
  cycle_between_inv, // INPUT G
  path2403, // INPUT DA
  g2256, // INPUT DB
  path2180, // INPUT DC
  path2406, // INPUT DD
  unconnected_P32_NA, // OUTPUT NA
  p32_wavein_sign, // OUTPUT PA
  ~p32_adder1_o13_or_15, // OUTPUT NB
  p32_adder1_o13_or_15, // OUTPUT PB
  ~p32_adder1_o14_or_15, // OUTPUT NC
  p32_adder1_o14_or_15, // OUTPUT PC
  ~p32_adder1_o12_or_15, // OUTPUT ND
  p32_adder1_o12_or_15 // OUTPUT PD
);

// LUT
// Inputs:
// p32 (wavein_sign, adder1_o12/14_or_15)
// h57_adder1_o11_or_15 (adder1_o11_or_15)
// r10_d (r10 lsb?)
// h57_r10_d1_ncybtwn (r10_d1_ncybtwn msb?)
// h57_r10_d0_ncybtwn (r10_d0_ncybtwn msb?)
assign adder2_lut_a13 = ~((~(~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) && ~p32_wavein_sign) || (~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15 && p32_wavein_sign));
assign adder2_lut_a12 = ~((((~r10_d7_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15)) && p32_wavein_sign) || (~((~r10_d7_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15)) && ~p32_wavein_sign));
assign adder2_lut_a11 = ~((((~r10_d6_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d7_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15)) && p32_wavein_sign) || (~((~r10_d6_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d7_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15)) && ~p32_wavein_sign));
assign adder2_lut_a10 = ~((((~r10_d5_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d6_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d7_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (VCC && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15)) && p32_wavein_sign) || (~((~r10_d5_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d6_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d7_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (VCC && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15)) && ~p32_wavein_sign));
assign adder2_lut_a9 = ~((~((~r10_d7_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d6_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d5_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d4_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15)) && ~(~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) && ~p32_wavein_sign) || (~(~((~r10_d7_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d6_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d5_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d4_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15)) && ~(~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15)) && p32_wavein_sign));
assign adder2_lut_a8 = ~((((VCC && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d7_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d6_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d5_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d4_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d3_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15)) && p32_wavein_sign) || (~((VCC && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d7_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d6_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d5_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d4_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d3_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15)) && ~p32_wavein_sign));
assign adder2_lut_a7 = ~((((VCC && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d7_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d6_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d5_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d4_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d3_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (r10_d2_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (VCC && GND)) && p32_wavein_sign) || (~((VCC && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d7_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d6_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d5_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d4_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d3_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (r10_d2_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (VCC && GND)) && ~p32_wavein_sign));
assign adder2_lut_a6 = ~((((VCC && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d7_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d6_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d5_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d4_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d3_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (r10_d2_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (r10_d1_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15)) && p32_wavein_sign) || (~((VCC && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d7_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d6_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d5_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d4_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d3_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (r10_d2_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (r10_d1_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15)) && ~p32_wavein_sign));
assign adder2_lut_a5 = ~((~((VCC && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d7_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d6_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d5_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d4_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d3_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (r10_d2_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (r10_d1_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15)) && ~(r10_d0_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) && ~p32_wavein_sign) || (~(~((VCC && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d7_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d6_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d5_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d4_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d3_not_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (r10_d2_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (r10_d1_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15)) && ~(r10_d0_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15)) && p32_wavein_sign));
assign adder2_lut_a4 = ~((~((~r10_d7_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d6_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d5_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d4_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d3_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (r10_d2_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (r10_d1_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (r10_d0_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15)) && ~((h57_r10_d1_ncybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15)) && ~p32_wavein_sign) || (~(~((~r10_d7_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d6_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d5_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d4_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d3_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (r10_d2_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (r10_d1_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (r10_d0_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15)) && ~((h57_r10_d1_ncybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15))) && p32_wavein_sign));
assign adder2_lut_a3 = ~((~((h57_r10_d0_ncybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (h57_r10_d1_ncybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (r10_d0_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (r10_d1_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (r10_d2_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d3_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d4_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d5_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15)) && ~((~r10_d6_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d7_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15)) && ~p32_wavein_sign) || (~(~((h57_r10_d0_ncybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (h57_r10_d1_ncybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (r10_d0_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (r10_d1_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (r10_d2_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d3_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d4_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d5_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15)) && ~((~r10_d6_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d7_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15))) && p32_wavein_sign));
assign adder2_lut_a2 = ~((~((h57_r10_d0_ncybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (h57_r10_d1_ncybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (r10_d0_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (r10_d1_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (r10_d2_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d3_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d4_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d5_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15)) && ~((~r10_d6_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d7_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15)) && ~p32_wavein_sign) || (~(~((h57_r10_d0_ncybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (h57_r10_d1_ncybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (r10_d0_cybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (r10_d1_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (r10_d2_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d3_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d4_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d5_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15)) && ~((~r10_d6_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d7_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15))) && p32_wavein_sign));
assign adder2_lut_a1 = ~((~((h57_r10_d0_ncybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (h57_r10_d1_ncybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (r10_d0_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (r10_d1_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (r10_d2_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d3_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d4_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d5_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15)) && ~((~r10_d6_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d7_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15)) && ~p32_wavein_sign) || (~(~((h57_r10_d0_ncybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (h57_r10_d1_ncybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (r10_d0_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (r10_d1_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (r10_d2_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d3_not_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d4_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d5_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15)) && ~((~r10_d6_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d7_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15))) && p32_wavein_sign));
assign adder2_lut_a0 = ~((~((h57_r10_d0_ncybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (h57_r10_d1_ncybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (r10_d0_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (r10_d1_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (r10_d2_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d3_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d4_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d5_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15)) && ~((~r10_d6_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d7_not_cybtwn && p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15)) && ~p32_wavein_sign) || (~(~((h57_r10_d0_ncybtwn && ~p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (h57_r10_d1_ncybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (r10_d0_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (r10_d1_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (r10_d2_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d3_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d4_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d5_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15)) && ~((~r10_d6_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d7_not_cybtwn && p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15))) && p32_wavein_sign));
assign adder2_lut_ci = ~((~((h57_r10_d0_ncybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (h57_r10_d1_ncybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (r10_d0_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (r10_d1_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (r10_d2_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d3_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d4_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d5_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15)) && ~((~r10_d6_not_cybtwn && p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d7_not_cybtwn && p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15)) && ~p32_wavein_sign) || (~(~((h57_r10_d0_ncybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (h57_r10_d1_ncybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (r10_d0_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (r10_d1_cybtwn && ~p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (r10_d2_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d3_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (~r10_d4_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d5_not_cybtwn && p32_adder1_o13_or_15 && ~p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && h57_adder1_o11_or_15)) && ~((~r10_d6_not_cybtwn && p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15) || (~r10_d7_not_cybtwn && p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && ~p32_adder1_o12_or_15 && h57_adder1_o11_or_15) || (p32_adder1_o13_or_15 && p32_adder1_o14_or_15 && p32_adder1_o12_or_15 && ~h57_adder1_o11_or_15))) && p32_wavein_sign));
cell_LT4 R64 ( // 4-bit Data Latch
  cycle_between, // INPUT G
  p32_wavein_sign, // INPUT DA
  adder2_lut_a13, // INPUT DB
  adder2_lut_a12, // INPUT DC
  adder2_lut_a11, // INPUT DD
  unconnected_R64_NA, // OUTPUT NA
  adder2_a14_15_16_17, // OUTPUT PA
  unconnected_R64_NB, // OUTPUT NB
  adder2_a13, // OUTPUT PB
  unconnected_R64_NC, // OUTPUT NC
  adder2_a12, // OUTPUT PC
  unconnected_R64_ND, // OUTPUT ND
  adder2_a11 // OUTPUT PD
);
cell_LT4 T45 ( // 4-bit Data Latch
  cycle_between, // INPUT G
  adder2_lut_a10, // INPUT DA
  adder2_lut_a9, // INPUT DB
  adder2_lut_a8, // INPUT DC
  adder2_lut_a7, // INPUT DD
  unconnected_T45_NA, // OUTPUT NA
  adder2_a10, // OUTPUT PA
  unconnected_T45_NB, // OUTPUT NB
  adder2_a9, // OUTPUT PB
  unconnected_T45_NC, // OUTPUT NC
  adder2_a8, // OUTPUT PC
  unconnected_T45_ND, // OUTPUT ND
  adder2_a7 // OUTPUT PD
);
cell_LT4 P61 ( // 4-bit Data Latch
  cycle_between, // INPUT G
  adder2_lut_a6, // INPUT DA
  adder2_lut_a5, // INPUT DB
  adder2_lut_a4, // INPUT DC
  adder2_lut_a3, // INPUT DD
  unconnected_P61_NA, // OUTPUT NA
  adder2_a6, // OUTPUT PA
  unconnected_P61_NB, // OUTPUT NB
  adder2_a5, // OUTPUT PB
  unconnected_P61_NC, // OUTPUT NC
  adder2_a4, // OUTPUT PC
  unconnected_P61_ND, // OUTPUT ND
  adder2_a3 // OUTPUT PD
);
cell_LT4 U77 ( // 4-bit Data Latch
  cycle_between, // INPUT G
  adder2_lut_a2, // INPUT DA
  adder2_lut_a1, // INPUT DB
  adder2_lut_a0, // INPUT DC
  adder2_lut_ci, // INPUT DD
  unconnected_U77_NA, // OUTPUT NA
  adder2_a2, // OUTPUT PA
  unconnected_U77_NB, // OUTPUT NB
  adder2_a1, // OUTPUT PB
  unconnected_U77_NC, // OUTPUT NC
  adder2_a0, // OUTPUT PC
  unconnected_U77_ND, // OUTPUT ND
  adder2_ci // OUTPUT PD
);

assign adder2_b_sel = ~(not_first_sample_cycle_11 || cnt_g29_a) || test_mode_0;

assign adder2_b0 =  adder2_b0_pre && ~adder2_b_sel;
assign adder2_b1 =  adder2_b1_pre && ~adder2_b_sel;
assign adder2_b2 =  adder2_b2_pre && ~adder2_b_sel;
assign adder2_b3 =  adder2_b3_pre && ~adder2_b_sel;
assign adder2_b4 =  adder2_b4_pre && ~adder2_b_sel;
assign adder2_b5 =  adder2_b5_pre && ~adder2_b_sel;
assign adder2_b6 =  adder2_b6_pre && ~adder2_b_sel;
assign adder2_b7 =  adder2_b7_pre && ~adder2_b_sel;
assign adder2_b8 =  adder2_b8_pre && ~adder2_b_sel;
assign adder2_b9 =  adder2_b9_pre && ~adder2_b_sel;
assign adder2_b10 = adder2_b10_pre && ~adder2_b_sel;
assign adder2_b11 = adder2_b11_pre && ~adder2_b_sel;
assign adder2_b12 = adder2_b12_pre && ~adder2_b_sel;
assign adder2_b13 = adder2_b13_pre && ~adder2_b_sel;
assign adder2_b14 = adder2_b14_pre && ~adder2_b_sel;
assign adder2_b15 = adder2_b15_pre && ~adder2_b_sel;
assign adder2_b16 = adder2_b16_pre && ~adder2_b_sel;
assign adder2_b17 = adder2_b17_pre && ~adder2_b_sel;


// Adder 2 (18 bit) generates DAC out
// A: lut(r10, adder1)
// B: prev value or 0
cell_A4H U107 ( // 4-bit Full Adder
  adder2_a3, // INPUT A4
  adder2_b3, // INPUT B4
  adder2_a2, // INPUT A3
  adder2_b2, // INPUT B3
  adder2_a1, // INPUT A2
  adder2_b1, // INPUT B2
  adder2_a0, // INPUT A1
  adder2_b0, // INPUT B1
  adder2_ci, // INPUT CI
  path1509, // OUTPUT CO
  adder2_o3, // OUTPUT S4
  adder2_o2, // OUTPUT S3
  adder2_o1, // OUTPUT S2
  adder2_o0 // OUTPUT S1
);
cell_A4H P98 ( // 4-bit Full Adder
  adder2_a7, // INPUT A4
  adder2_b7, // INPUT B4
  adder2_a6, // INPUT A3
  adder2_b6, // INPUT B3
  adder2_a5, // INPUT A2
  adder2_b5, // INPUT B2
  adder2_a4, // INPUT A1
  adder2_b4, // INPUT B1
  path1509, // INPUT CI
  path1883, // OUTPUT CO
  adder2_o7, // OUTPUT S4
  adder2_o6, // OUTPUT S3
  adder2_o5, // OUTPUT S2
  adder2_o4 // OUTPUT S1
);
cell_A4H S3 ( // 4-bit Full Adder
  adder2_a11, // INPUT A4
  adder2_b11, // INPUT B4
  adder2_a10, // INPUT A3
  adder2_b10, // INPUT B3
  adder2_a9, // INPUT A2
  adder2_b9, // INPUT B2
  adder2_a8, // INPUT A1
  adder2_b8, // INPUT B1
  path1883, // INPUT CI
  path2203, // OUTPUT CO
  adder2_o11, // OUTPUT S4
  adder2_o10, // OUTPUT S3
  adder2_o9, // OUTPUT S2
  adder2_o8 // OUTPUT S1
);
cell_A4H R4 ( // 4-bit Full Adder
  adder2_a14_15_16_17, // INPUT A4
  adder2_b15, // INPUT B4
  adder2_a14_15_16_17, // INPUT A3
  adder2_b14, // INPUT B3
  adder2_a13, // INPUT A2
  adder2_b13, // INPUT B2
  adder2_a12, // INPUT A1
  adder2_b12, // INPUT B1
  path2203, // INPUT CI
  path2202, // OUTPUT CO
  adder2_o15, // OUTPUT S4
  adder2_o14, // OUTPUT S3
  adder2_o13, // OUTPUT S2
  adder2_o12 // OUTPUT S1
);
cell_A2N Q61 ( // 2-bit Full Adder
  adder2_a14_15_16_17, // INPUT B2
  adder2_b17, // INPUT A2
  adder2_a14_15_16_17, // INPUT B1
  adder2_b16, // INPUT A1
  path2202, // INPUT CI
  unconnected_Q61_CO, // OUTPUT CO
  adder2_o17, // OUTPUT S2
  adder2_o16 // OUTPUT S1
);



// ==============================================================================
// 18 bit latches/flip flops for audio out, value that is being accumulated

// Saves the current sample
cell_FDQ O117 ( // 4-bit DFF
  cycle_between, // INPUT CK
  adder2_o7, // INPUT DA
  adder2_o6, // INPUT DB
  adder2_o5, // INPUT DC
  adder2_o4, // INPUT DD
  unklatch_in_7, // OUTPUT QA
  unklatch_in_6, // OUTPUT QB
  unklatch_in_5, // OUTPUT QC
  unklatch_in_4 // OUTPUT QD
);
cell_FDQ S56 ( // 4-bit DFF
  cycle_between, // INPUT CK
  adder2_o15, // INPUT DA
  adder2_o14, // INPUT DB
  adder2_o13, // INPUT DC
  adder2_o12, // INPUT DD
  unklatch_in_15, // OUTPUT QA
  unklatch_in_14, // OUTPUT QB
  unklatch_in_13, // OUTPUT QC
  unklatch_in_12 // OUTPUT QD
);
cell_FDQ T2 ( // 4-bit DFF
  cycle_between, // INPUT CK
  adder2_o11, // INPUT DA
  adder2_o10, // INPUT DB
  adder2_o9, // INPUT DC
  adder2_o8, // INPUT DD
  unklatch_in_11, // OUTPUT QA
  unklatch_in_10, // OUTPUT QB
  unklatch_in_9, // OUTPUT QC
  unklatch_in_8 // OUTPUT QD
);
cell_FDQ V136 ( // 4-bit DFF
  cycle_between, // INPUT CK
  adder2_o3, // INPUT DA
  adder2_o2, // INPUT DB
  adder2_o1, // INPUT DC
  adder2_o0, // INPUT DD
  unklatch_in_3, // OUTPUT QA
  unklatch_in_2, // OUTPUT QB
  unklatch_in_1, // OUTPUT QC
  unklatch_in_0 // OUTPUT QD
);
cell_FDM P51 ( // DFF
  cycle_between_inv, // INPUT CK
  adder2_o17, // INPUT D
  unklatch_in_17_inv, // OUTPUT XQ
  unconnected_P51_Q // OUTPUT Q
);
cell_FDM Q42 ( // DFF
  cycle_between_inv, // INPUT CK
  adder2_o16, // INPUT D
  unklatch_in_16_inv, // OUTPUT XQ
  unconnected_Q42_Q // OUTPUT Q
);


cell_FDQ M77 ( // 4-bit DFF
  cycle_even_pos, // INPUT CK
  cnt_g29_d, // INPUT DA
  cnt_g29_of, // INPUT DB
  cnt_g29_b, // INPUT DC
  GND, // INPUT DD
  unk_dec_ic, // OUTPUT QA
  unk_dec_ib, // OUTPUT QB
  unk_dec_ia, // OUTPUT QC
  unconnected_M77_QD // OUTPUT QD
);
cell_DE3 M103 ( // 3:8 Decoder
  unk_dec_ib, // INPUT B
  unk_dec_ia, // INPUT A
  unk_dec_ic, // INPUT C
  unk_dec_o0, // OUTPUT X0
  unk_dec_o1, // OUTPUT X1
  unk_dec_o2, // OUTPUT X2
  unk_dec_o3, // OUTPUT X3
  unk_dec_o4, // OUTPUT X4
  unk_dec_o5, // OUTPUT X5
  unk_dec_o6, // OUTPUT X6
  unk_dec_o7 // OUTPUT X7
);
assign sample_write_0 = unk_dec_o0 || cycle_odd || cycle_even;
assign sample_write_1 = unk_dec_o1 || cycle_odd || cycle_even;
assign sample_write_2 = unk_dec_o2 || cycle_odd || cycle_even;
assign sample_write_3 = unk_dec_o3 || cycle_odd || cycle_even;
assign sample_write_4 = unk_dec_o4 || cycle_odd || cycle_even;
assign sample_write_5 = unk_dec_o5 || cycle_odd || cycle_even;
assign sample_write_6 = unk_dec_o6 || cycle_odd || cycle_even;
assign sample_write_7 = unk_dec_o7 || cycle_odd || cycle_even;


cell_LT4 T77 ( // 4-bit Data Latch
  sample_write_0, // INPUT G
  unklatch_in_15, // INPUT DA
  unklatch_in_14, // INPUT DB
  unklatch_in_13, // INPUT DC
  unklatch_in_12, // INPUT DD
  unconnected_T77_NA, // OUTPUT NA
  unklatch0_out_15, // OUTPUT PA
  unconnected_T77_NB, // OUTPUT NB
  unklatch0_out_14, // OUTPUT PB
  unconnected_T77_NC, // OUTPUT NC
  unklatch0_out_13, // OUTPUT PC
  unconnected_T77_ND, // OUTPUT ND
  unklatch0_out_12 // OUTPUT PD
);
cell_LT4 R90 ( // 4-bit Data Latch
  sample_write_0, // INPUT G
  unklatch_in_7, // INPUT DA
  unklatch_in_6, // INPUT DB
  unklatch_in_5, // INPUT DC
  unklatch_in_4, // INPUT DD
  unconnected_R90_NA, // OUTPUT NA
  unklatch0_out_7, // OUTPUT PA
  unconnected_R90_NB, // OUTPUT NB
  unklatch0_out_6, // OUTPUT PB
  unconnected_R90_NC, // OUTPUT NC
  unklatch0_out_5, // OUTPUT PC
  unconnected_R90_ND, // OUTPUT ND
  unklatch0_out_4 // OUTPUT PD
);
cell_LT4 Y130 ( // 4-bit Data Latch
  sample_write_0, // INPUT G
  unklatch_in_3, // INPUT DA
  unklatch_in_2, // INPUT DB
  unklatch_in_1, // INPUT DC
  unklatch_in_0, // INPUT DD
  unconnected_Y130_NA, // OUTPUT NA
  unklatch0_out_3, // OUTPUT PA
  unconnected_Y130_NB, // OUTPUT NB
  unklatch0_out_2, // OUTPUT PB
  unconnected_Y130_NC, // OUTPUT NC
  unklatch0_out_1, // OUTPUT PC
  unconnected_Y130_ND, // OUTPUT ND
  unklatch0_out_0 // OUTPUT PD
);
cell_LT4 Y77 ( // 4-bit Data Latch
  sample_write_0, // INPUT G
  unklatch_in_11, // INPUT DA
  unklatch_in_10, // INPUT DB
  unklatch_in_9, // INPUT DC
  unklatch_in_8, // INPUT DD
  unconnected_Y77_NA, // OUTPUT NA
  unklatch0_out_11, // OUTPUT PA
  unconnected_Y77_NB, // OUTPUT NB
  unklatch0_out_10, // OUTPUT PB
  unconnected_Y77_NC, // OUTPUT NC
  unklatch0_out_9, // OUTPUT PC
  unconnected_Y77_ND, // OUTPUT ND
  unklatch0_out_8 // OUTPUT PD
);
cell_LT2 N81 ( // 1-bit Data Latch
  sample_write_0, // INPUT G
  ~unklatch_in_17_inv, // INPUT D
  unklatch0_out_17_inv, // OUTPUT Q
  unconnected_N81_XQ // OUTPUT XQ
);
cell_LT2 R137 ( // 1-bit Data Latch
  sample_write_0, // INPUT G
  ~unklatch_in_16_inv, // INPUT D
  unklatch0_out_16_inv, // OUTPUT Q
  unconnected_R137_XQ // OUTPUT XQ
);


cell_LT4 O80 ( // 4-bit Data Latch
  sample_write_1, // INPUT G
  unklatch_in_7, // INPUT DA
  unklatch_in_6, // INPUT DB
  unklatch_in_5, // INPUT DC
  unklatch_in_4, // INPUT DD
  unconnected_O80_NA, // OUTPUT NA
  path2736, // OUTPUT PA
  unconnected_O80_NB, // OUTPUT NB
  path1969, // OUTPUT PB
  unconnected_O80_NC, // OUTPUT NC
  path2316, // OUTPUT PC
  unconnected_O80_ND, // OUTPUT ND
  path2317 // OUTPUT PD
);
cell_LT4 S77 ( // 4-bit Data Latch
  sample_write_1, // INPUT G
  unklatch_in_15, // INPUT DA
  unklatch_in_14, // INPUT DB
  unklatch_in_13, // INPUT DC
  unklatch_in_12, // INPUT DD
  unconnected_S77_NA, // OUTPUT NA
  path2299, // OUTPUT PA
  unconnected_S77_NB, // OUTPUT NB
  path2298, // OUTPUT PB
  unconnected_S77_NC, // OUTPUT NC
  path2661, // OUTPUT PC
  unconnected_S77_ND, // OUTPUT ND
  path2680 // OUTPUT PD
);
cell_LT4 V123 ( // 4-bit Data Latch
  sample_write_1, // INPUT G
  unklatch_in_11, // INPUT DA
  unklatch_in_10, // INPUT DB
  unklatch_in_9, // INPUT DC
  unklatch_in_8, // INPUT DD
  unconnected_V123_NA, // OUTPUT NA
  path2644, // OUTPUT PA
  unconnected_V123_NB, // OUTPUT NB
  path2787, // OUTPUT PB
  unconnected_V123_NC, // OUTPUT NC
  path2480, // OUTPUT PC
  unconnected_V123_ND, // OUTPUT ND
  path2635 // OUTPUT PD
);
cell_LT4 W103 ( // 4-bit Data Latch
  sample_write_1, // INPUT G
  unklatch_in_3, // INPUT DA
  unklatch_in_2, // INPUT DB
  unklatch_in_1, // INPUT DC
  unklatch_in_0, // INPUT DD
  unconnected_W103_NA, // OUTPUT NA
  path2640, // OUTPUT PA
  unconnected_W103_NB, // OUTPUT NB
  path2473, // OUTPUT PB
  unconnected_W103_NC, // OUTPUT NC
  path2660, // OUTPUT PC
  unconnected_W103_ND, // OUTPUT ND
  path2724 // OUTPUT PD
);
cell_LT2 N85 ( // 1-bit Data Latch
  sample_write_1, // INPUT G
  ~unklatch_in_17_inv, // INPUT D
  path1867, // OUTPUT Q
  unconnected_N85_XQ // OUTPUT XQ
);
cell_LT2 R121 ( // 1-bit Data Latch
  sample_write_1, // INPUT G
  ~unklatch_in_16_inv, // INPUT D
  path2050, // OUTPUT Q
  unconnected_R121_XQ // OUTPUT XQ
);


cell_LT4 R104 ( // 4-bit Data Latch
  sample_write_2, // INPUT G
  unklatch_in_7, // INPUT DA
  unklatch_in_6, // INPUT DB
  unklatch_in_5, // INPUT DC
  unklatch_in_4, // INPUT DD
  unconnected_R104_NA, // OUTPUT NA
  path2278, // OUTPUT PA
  unconnected_R104_NB, // OUTPUT NB
  path1971, // OUTPUT PB
  unconnected_R104_NC, // OUTPUT NC
  path1972, // OUTPUT PC
  unconnected_R104_ND, // OUTPUT ND
  path2291 // OUTPUT PD
);
cell_LT4 S118 ( // 4-bit Data Latch
  sample_write_2, // INPUT G
  unklatch_in_15, // INPUT DA
  unklatch_in_14, // INPUT DB
  unklatch_in_13, // INPUT DC
  unklatch_in_12, // INPUT DD
  unconnected_S118_NA, // OUTPUT NA
  path2750, // OUTPUT PA
  unconnected_S118_NB, // OUTPUT NB
  path2302, // OUTPUT PB
  unconnected_S118_NC, // OUTPUT NC
  path2292, // OUTPUT PC
  unconnected_S118_ND, // OUTPUT ND
  path1904 // OUTPUT PD
);
cell_LT4 Y117 ( // 4-bit Data Latch
  sample_write_2, // INPUT G
  unklatch_in_3, // INPUT DA
  unklatch_in_2, // INPUT DB
  unklatch_in_1, // INPUT DC
  unklatch_in_0, // INPUT DD
  unconnected_Y117_NA, // OUTPUT NA
  path2649, // OUTPUT PA
  unconnected_Y117_NB, // OUTPUT NB
  path2650, // OUTPUT PB
  unconnected_Y117_NC, // OUTPUT NC
  path2639, // OUTPUT PC
  unconnected_Y117_ND, // OUTPUT ND
  path2225 // OUTPUT PD
);
cell_LT4 X93 ( // 4-bit Data Latch
  sample_write_2, // INPUT G
  unklatch_in_11, // INPUT DA
  unklatch_in_10, // INPUT DB
  unklatch_in_9, // INPUT DC
  unklatch_in_8, // INPUT DD
  unconnected_X93_NA, // OUTPUT NA
  path2215, // OUTPUT PA
  unconnected_X93_NB, // OUTPUT NB
  path2429, // OUTPUT PB
  unconnected_X93_NC, // OUTPUT NC
  path2430, // OUTPUT PC
  unconnected_X93_ND, // OUTPUT ND
  path2646 // OUTPUT PD
);
cell_LT2 N109 ( // 1-bit Data Latch
  sample_write_2, // INPUT G
  ~unklatch_in_17_inv, // INPUT D
  path2233, // OUTPUT Q
  unconnected_N109_XQ // OUTPUT XQ
);
cell_LT2 R141 ( // 1-bit Data Latch
  sample_write_2, // INPUT G
  ~unklatch_in_16_inv, // INPUT D
  path2052, // OUTPUT Q
  unconnected_R141_XQ // OUTPUT XQ
);


cell_LT4 Q141 ( // 4-bit Data Latch
  sample_write_3, // INPUT G
  unklatch_in_7, // INPUT DA
  unklatch_in_6, // INPUT DB
  unklatch_in_5, // INPUT DC
  unklatch_in_4, // INPUT DD
  unconnected_Q141_NA, // OUTPUT NA
  path2277, // OUTPUT PA
  unconnected_Q141_NB, // OUTPUT NB
  path2771, // OUTPUT PB
  unconnected_Q141_NC, // OUTPUT NC
  path2274, // OUTPUT PC
  unconnected_Q141_ND, // OUTPUT ND
  path2275 // OUTPUT PD
);
cell_LT4 T144 ( // 4-bit Data Latch
  sample_write_3, // INPUT G
  unklatch_in_15, // INPUT DA
  unklatch_in_14, // INPUT DB
  unklatch_in_13, // INPUT DC
  unklatch_in_12, // INPUT DD
  unconnected_T144_NA, // OUTPUT NA
  path2304, // OUTPUT PA
  unconnected_T144_NB, // OUTPUT NB
  path2294, // OUTPUT PB
  unconnected_T144_NC, // OUTPUT NC
  path2293, // OUTPUT PC
  unconnected_T144_ND, // OUTPUT ND
  path1398 // OUTPUT PD
);
cell_LT4 W144 ( // 4-bit Data Latch
  sample_write_3, // INPUT G
  unklatch_in_3, // INPUT DA
  unklatch_in_2, // INPUT DB
  unklatch_in_1, // INPUT DC
  unklatch_in_0, // INPUT DD
  unconnected_W144_NA, // OUTPUT NA
  path2648, // OUTPUT PA
  unconnected_W144_NB, // OUTPUT NB
  path1474, // OUTPUT PB
  unconnected_W144_NC, // OUTPUT NC
  path2638, // OUTPUT PC
  unconnected_W144_ND, // OUTPUT ND
  path2228 // OUTPUT PD
);
cell_LT4 W90 ( // 4-bit Data Latch
  sample_write_3, // INPUT G
  unklatch_in_11, // INPUT DA
  unklatch_in_10, // INPUT DB
  unklatch_in_9, // INPUT DC
  unklatch_in_8, // INPUT DD
  unconnected_W90_NA, // OUTPUT NA
  path2214, // OUTPUT PA
  unconnected_W90_NB, // OUTPUT NB
  path2428, // OUTPUT PB
  unconnected_W90_NC, // OUTPUT NC
  path2427, // OUTPUT PC
  unconnected_W90_ND, // OUTPUT ND
  path2647 // OUTPUT PD
);
cell_LT2 N113 ( // 1-bit Data Latch
  sample_write_3, // INPUT G
  ~unklatch_in_17_inv, // INPUT D
  path2232, // OUTPUT Q
  unconnected_N113_XQ // OUTPUT XQ
);
cell_LT2 R153 ( // 1-bit Data Latch
  sample_write_3, // INPUT G
  ~unklatch_in_16_inv, // INPUT D
  path2053, // OUTPUT Q
  unconnected_R153_XQ // OUTPUT XQ
);


cell_LT4 Q128 ( // 4-bit Data Latch
  sample_write_4, // INPUT G
  unklatch_in_7, // INPUT DA
  unklatch_in_6, // INPUT DB
  unklatch_in_5, // INPUT DC
  unklatch_in_4, // INPUT DD
  unconnected_Q128_NA, // OUTPUT NA
  path1973, // OUTPUT PA
  unconnected_Q128_NB, // OUTPUT NB
  path2770, // OUTPUT PB
  unconnected_Q128_NC, // OUTPUT NC
  path2273, // OUTPUT PC
  unconnected_Q128_ND, // OUTPUT ND
  path2276 // OUTPUT PD
);
cell_LT4 S131 ( // 4-bit Data Latch
  sample_write_4, // INPUT G
  unklatch_in_15, // INPUT DA
  unklatch_in_14, // INPUT DB
  unklatch_in_13, // INPUT DC
  unklatch_in_12, // INPUT DD
  unconnected_S131_NA, // OUTPUT NA
  path2303, // OUTPUT PA
  unconnected_S131_NB, // OUTPUT NB
  path2775, // OUTPUT PB
  unconnected_S131_NC, // OUTPUT NC
  path2678, // OUTPUT PC
  unconnected_S131_ND, // OUTPUT ND
  path2677 // OUTPUT PD
);
cell_LT4 X144 ( // 4-bit Data Latch
  sample_write_4, // INPUT G
  unklatch_in_11, // INPUT DA
  unklatch_in_10, // INPUT DB
  unklatch_in_9, // INPUT DC
  unklatch_in_8, // INPUT DD
  unconnected_X144_NA, // OUTPUT NA
  path2211, // OUTPUT PA
  unconnected_X144_NB, // OUTPUT NB
  path2208, // OUTPUT PB
  unconnected_X144_NC, // OUTPUT NC
  path2217, // OUTPUT PC
  unconnected_X144_ND, // OUTPUT ND
  path2229 // OUTPUT PD
);
cell_LT4 Y143 ( // 4-bit Data Latch
  sample_write_4, // INPUT G
  unklatch_in_3, // INPUT DA
  unklatch_in_2, // INPUT DB
  unklatch_in_1, // INPUT DC
  unklatch_in_0, // INPUT DD
  unconnected_Y143_NA, // OUTPUT NA
  path1644, // OUTPUT PA
  unconnected_Y143_NB, // OUTPUT NB
  path1484, // OUTPUT PB
  unconnected_Y143_NC, // OUTPUT NC
  path2426, // OUTPUT PC
  unconnected_Y143_ND, // OUTPUT ND
  path2227 // OUTPUT PD
);
cell_LT2 N122 ( // 1-bit Data Latch
  sample_write_4, // INPUT G
  ~unklatch_in_17_inv, // INPUT D
  path2764, // OUTPUT Q
  unconnected_N122_XQ // OUTPUT XQ
);
cell_LT2 R145 ( // 1-bit Data Latch
  sample_write_4, // INPUT G
  ~unklatch_in_16_inv, // INPUT D
  path2051, // OUTPUT Q
  unconnected_R145_XQ // OUTPUT XQ
);


cell_LT4 P80 ( // 4-bit Data Latch
  sample_write_5, // INPUT G
  unklatch_in_7, // INPUT DA
  unklatch_in_6, // INPUT DB
  unklatch_in_5, // INPUT DC
  unklatch_in_4, // INPUT DD
  unconnected_P80_NA, // OUTPUT NA
  unklatch5_out_7, // OUTPUT PA
  unconnected_P80_NB, // OUTPUT NB
  unklatch5_out_6, // OUTPUT PB
  unconnected_P80_NC, // OUTPUT NC
  unklatch5_out_5, // OUTPUT PC
  unconnected_P80_ND, // OUTPUT ND
  unklatch5_out_4 // OUTPUT PD
);
cell_LT4 T90 ( // 4-bit Data Latch
  sample_write_5, // INPUT G
  unklatch_in_15, // INPUT DA
  unklatch_in_14, // INPUT DB
  unklatch_in_13, // INPUT DC
  unklatch_in_12, // INPUT DD
  unconnected_T90_NA, // OUTPUT NA
  unklatch5_out_15, // OUTPUT PA
  unconnected_T90_NB, // OUTPUT NB
  unklatch5_out_14, // OUTPUT PB
  unconnected_T90_NC, // OUTPUT NC
  unklatch5_out_13, // OUTPUT PC
  unconnected_T90_ND, // OUTPUT ND
  unklatch5_out_12 // OUTPUT PD
);
cell_LT4 W116 ( // 4-bit Data Latch
  sample_write_5, // INPUT G
  unklatch_in_3, // INPUT DA
  unklatch_in_2, // INPUT DB
  unklatch_in_1, // INPUT DC
  unklatch_in_0, // INPUT DD
  unconnected_W116_NA, // OUTPUT NA
  unklatch5_out_3, // OUTPUT PA
  unconnected_W116_NB, // OUTPUT NB
  unklatch5_out_2, // OUTPUT PB
  unconnected_W116_NC, // OUTPUT NC
  unklatch5_out_1, // OUTPUT PC
  unconnected_W116_ND, // OUTPUT ND
  unklatch5_out_0 // OUTPUT PD
);
cell_LT4 W77 ( // 4-bit Data Latch
  sample_write_5, // INPUT G
  unklatch_in_11, // INPUT DA
  unklatch_in_10, // INPUT DB
  unklatch_in_9, // INPUT DC
  unklatch_in_8, // INPUT DD
  unconnected_W77_NA, // OUTPUT NA
  unklatch5_out_11, // OUTPUT PA
  unconnected_W77_NB, // OUTPUT NB
  unklatch5_out_10, // OUTPUT PB
  unconnected_W77_NC, // OUTPUT NC
  unklatch5_out_9, // OUTPUT PC
  unconnected_W77_ND, // OUTPUT ND
  unklatch5_out_8 // OUTPUT PD
);
cell_LT2 N89 ( // 1-bit Data Latch
  sample_write_5, // INPUT G
  ~unklatch_in_17_inv, // INPUT D
  unklatch5_out_17_inv, // OUTPUT Q
  unconnected_N89_XQ // OUTPUT XQ
);
cell_LT2 R117 ( // 1-bit Data Latch
  sample_write_5, // INPUT G
  ~unklatch_in_16_inv, // INPUT D
  unklatch5_out_16_inv, // OUTPUT Q
  unconnected_R117_XQ // OUTPUT XQ
);


cell_LT4 R77 ( // 4-bit Data Latch
  sample_write_6, // INPUT G
  unklatch_in_7, // INPUT DA
  unklatch_in_6, // INPUT DB
  unklatch_in_5, // INPUT DC
  unklatch_in_4, // INPUT DD
  unconnected_R77_NA, // OUTPUT NA
  unklatch6_out_7, // OUTPUT PA
  unconnected_R77_NB, // OUTPUT NB
  unklatch6_out_6, // OUTPUT PB
  unconnected_R77_NC, // OUTPUT NC
  unklatch6_out_5, // OUTPUT PC
  unconnected_R77_ND, // OUTPUT ND
  unklatch6_out_4 // OUTPUT PD
);
cell_LT4 T131 ( // 4-bit Data Latch
  sample_write_6, // INPUT G
  unklatch_in_15, // INPUT DA
  unklatch_in_14, // INPUT DB
  unklatch_in_13, // INPUT DC
  unklatch_in_12, // INPUT DD
  unconnected_T131_NA, // OUTPUT NA
  unklatch6_out_15, // OUTPUT PA
  unconnected_T131_NB, // OUTPUT NB
  unklatch6_out_14, // OUTPUT PB
  unconnected_T131_NC, // OUTPUT NC
  unklatch6_out_13, // OUTPUT PC
  unconnected_T131_ND, // OUTPUT ND
  unklatch6_out_12 // OUTPUT PD
);
cell_LT4 Y104 ( // 4-bit Data Latch
  sample_write_6, // INPUT G
  unklatch_in_3, // INPUT DA
  unklatch_in_2, // INPUT DB
  unklatch_in_1, // INPUT DC
  unklatch_in_0, // INPUT DD
  unconnected_Y104_NA, // OUTPUT NA
  unklatch6_out_3, // OUTPUT PA
  unconnected_Y104_NB, // OUTPUT NB
  unklatch6_out_2, // OUTPUT PB
  unconnected_Y104_NC, // OUTPUT NC
  unklatch6_out_1, // OUTPUT PC
  unconnected_Y104_ND, // OUTPUT ND
  unklatch6_out_0 // OUTPUT PD
);
cell_LT4 Y91 ( // 4-bit Data Latch
  sample_write_6, // INPUT G
  unklatch_in_11, // INPUT DA
  unklatch_in_10, // INPUT DB
  unklatch_in_9, // INPUT DC
  unklatch_in_8, // INPUT DD
  unconnected_Y91_NA, // OUTPUT NA
  unklatch6_out_11, // OUTPUT PA
  unconnected_Y91_NB, // OUTPUT NB
  unklatch6_out_10, // OUTPUT PB
  unconnected_Y91_NC, // OUTPUT NC
  unklatch6_out_9, // OUTPUT PC
  unconnected_Y91_ND, // OUTPUT ND
  unklatch6_out_8 // OUTPUT PD
);
cell_LT2 N77 ( // 1-bit Data Latch
  sample_write_6, // INPUT G
  ~unklatch_in_17_inv, // INPUT D
  unklatch6_out_17_inv, // OUTPUT Q
  unconnected_N77_XQ // OUTPUT XQ
);
cell_LT2 S102 ( // 1-bit Data Latch
  sample_write_6, // INPUT G
  ~unklatch_in_16_inv, // INPUT D
  unklatch6_out_16_inv, // OUTPUT Q
  unconnected_S102_XQ // OUTPUT XQ
);


cell_LT4 O96 ( // 4-bit Data Latch
  sample_write_7, // INPUT G
  unklatch_in_7, // INPUT DA
  unklatch_in_6, // INPUT DB
  unklatch_in_5, // INPUT DC
  unklatch_in_4, // INPUT DD
  unconnected_O96_NA, // OUTPUT NA
  unklatch7_out_7, // OUTPUT PA
  unconnected_O96_NB, // OUTPUT NB
  unklatch7_out_6, // OUTPUT PB
  unconnected_O96_NC, // OUTPUT NC
  unklatch7_out_5, // OUTPUT PC
  unconnected_O96_ND, // OUTPUT ND
  unklatch7_out_4 // OUTPUT PD
);
cell_LT4 S144 ( // 4-bit Data Latch
  sample_write_7, // INPUT G
  unklatch_in_15, // INPUT DA
  unklatch_in_14, // INPUT DB
  unklatch_in_13, // INPUT DC
  unklatch_in_12, // INPUT DD
  unconnected_S144_NA, // OUTPUT NA
  unklatch7_out_15, // OUTPUT PA
  unconnected_S144_NB, // OUTPUT NB
  unklatch7_out_14, // OUTPUT PB
  unconnected_S144_NC, // OUTPUT NC
  unklatch7_out_13, // OUTPUT PC
  unconnected_S144_ND, // OUTPUT ND
  unklatch7_out_12 // OUTPUT PD
);
cell_LT4 V110 ( // 4-bit Data Latch
  sample_write_7, // INPUT G
  unklatch_in_11, // INPUT DA
  unklatch_in_10, // INPUT DB
  unklatch_in_9, // INPUT DC
  unklatch_in_8, // INPUT DD
  unconnected_V110_NA, // OUTPUT NA
  unklatch7_out_11, // OUTPUT PA
  unconnected_V110_NB, // OUTPUT NB
  unklatch7_out_10, // OUTPUT PB
  unconnected_V110_NC, // OUTPUT NC
  unklatch7_out_9, // OUTPUT PC
  unconnected_V110_ND, // OUTPUT ND
  unklatch7_out_8 // OUTPUT PD
);
cell_LT4 W131 ( // 4-bit Data Latch
  sample_write_7, // INPUT G
  unklatch_in_3, // INPUT DA
  unklatch_in_2, // INPUT DB
  unklatch_in_1, // INPUT DC
  unklatch_in_0, // INPUT DD
  unconnected_W131_NA, // OUTPUT NA
  unklatch7_out_3, // OUTPUT PA
  unconnected_W131_NB, // OUTPUT NB
  unklatch7_out_2, // OUTPUT PB
  unconnected_W131_NC, // OUTPUT NC
  unklatch7_out_1, // OUTPUT PC
  unconnected_W131_ND, // OUTPUT ND
  unklatch7_out_0 // OUTPUT PD
);
cell_LT2 R149 ( // 1-bit Data Latch
  sample_write_7, // INPUT G
  ~unklatch_in_16_inv, // INPUT D
  unklatch7_out_16_inv, // OUTPUT Q
  unconnected_R149_XQ // OUTPUT XQ
);
cell_LT2 N126 ( // 1-bit Data Latch
  sample_write_7, // INPUT G
  ~unklatch_in_17_inv, // INPUT D
  unklatch7_out_17_inv, // OUTPUT Q
  unconnected_N126_XQ // OUTPUT XQ
);



// ==============================================================================
// 16 bit audio value to save into the output latches


assign au_st_a0 = ~cnt_g29_of && ~cnt_g29_d && ~cnt_g29_b;
assign au_st_a1 = ~cnt_g29_of && ~cnt_g29_d && cnt_g29_b;
assign au_st_a2 = ~cnt_g29_of && cnt_g29_d && ~cnt_g29_b;
assign au_st_a3 = ~cnt_g29_of && cnt_g29_d && cnt_g29_b;
assign au_st_a4 = cnt_g29_of && ~cnt_g29_d && ~cnt_g29_b;
assign au_st_a5 = cnt_g29_of && ~cnt_g29_d && cnt_g29_b;
assign au_st_a6 = cnt_g29_of && cnt_g29_d && ~cnt_g29_b;
assign au_st_a7 = cnt_g29_of && cnt_g29_d && cnt_g29_b;

assign adder2_b0_pre  = (unklatch5_out_0  && au_st_a3) || (path2225 && au_st_a2) || (path2228 && au_st_a5) || (path2227 && au_st_a4) || (path2724 && au_st_a1) || (unklatch0_out_0 && au_st_a0) || (unklatch7_out_0 && au_st_a7) || (unklatch6_out_0 && au_st_a6);
assign adder2_b1_pre  = (unklatch5_out_1  && au_st_a3) || (path2426 && au_st_a2) || (path2638 && au_st_a5) || (path2639 && au_st_a4) || (path2660 && au_st_a1) || (unklatch0_out_1 && au_st_a0) || (unklatch7_out_1 && au_st_a7) || (unklatch6_out_1 && au_st_a6);
assign adder2_b2_pre  = (unklatch5_out_2  && au_st_a3) || (path1484 && au_st_a2) || (path1474 && au_st_a5) || (path2650 && au_st_a4) || (path2473 && au_st_a1) || (unklatch0_out_2 && au_st_a0) || (unklatch7_out_2 && au_st_a7) || (unklatch6_out_2 && au_st_a6);
assign adder2_b3_pre  = (unklatch5_out_3  && au_st_a3) || (path1644 && au_st_a2) || (path2648 && au_st_a5) || (path2649 && au_st_a4) || (path2640 && au_st_a1) || (unklatch0_out_3 && au_st_a0) || (unklatch7_out_3 && au_st_a7) || (unklatch6_out_3 && au_st_a6);
assign adder2_b4_pre  = (unklatch5_out_4  && au_st_a3) || (path2276 && au_st_a2) || (path2275 && au_st_a5) || (path2291 && au_st_a4) || (path2317 && au_st_a1) || (unklatch0_out_4 && au_st_a0) || (unklatch7_out_4 && au_st_a7) || (unklatch6_out_4 && au_st_a6);
assign adder2_b5_pre  = (unklatch5_out_5  && au_st_a3) || (path2273 && au_st_a2) || (path2274 && au_st_a5) || (path1972 && au_st_a4) || (path2316 && au_st_a1) || (unklatch0_out_5 && au_st_a0) || (unklatch7_out_5 && au_st_a7) || (unklatch6_out_5 && au_st_a6);
assign adder2_b6_pre  = (unklatch5_out_6  && au_st_a3) || (path2770 && au_st_a2) || (path2771 && au_st_a5) || (path1971 && au_st_a4) || (path1969 && au_st_a1) || (unklatch0_out_6 && au_st_a0) || (unklatch7_out_6 && au_st_a7) || (unklatch6_out_6 && au_st_a6);
assign adder2_b7_pre  = (unklatch5_out_7  && au_st_a3) || (path1973 && au_st_a2) || (path2277 && au_st_a5) || (path2278 && au_st_a4) || (path2736 && au_st_a1) || (unklatch0_out_7 && au_st_a0) || (unklatch7_out_7 && au_st_a7) || (unklatch6_out_7 && au_st_a6);
assign adder2_b8_pre  = (unklatch5_out_8  && au_st_a3) || (path2229 && au_st_a2) || (path2647 && au_st_a5) || (path2646 && au_st_a4) || (path2635 && au_st_a1) || (unklatch0_out_8 && au_st_a0) || (unklatch7_out_8 && au_st_a7) || (unklatch6_out_8 && au_st_a6);
assign adder2_b9_pre  = (unklatch5_out_9  && au_st_a3) || (path2217 && au_st_a2) || (path2427 && au_st_a5) || (path2430 && au_st_a4) || (path2480 && au_st_a1) || (unklatch0_out_9 && au_st_a0) || (unklatch7_out_9 && au_st_a7) || (unklatch6_out_9 && au_st_a6);
assign adder2_b10_pre = (unklatch5_out_10 && au_st_a3) || (path2208 && au_st_a2) || (path2428 && au_st_a5) || (path2429 && au_st_a4) || (path2787 && au_st_a1) || (unklatch0_out_10 && au_st_a0) || (unklatch7_out_10 && au_st_a7) || (unklatch6_out_10 && au_st_a6);
assign adder2_b11_pre = (unklatch5_out_11 && au_st_a3) || (path2211 && au_st_a2) || (path2214 && au_st_a5) || (path2215 && au_st_a4) || (path2644 && au_st_a1) || (unklatch0_out_11 && au_st_a0) || (unklatch7_out_11 && au_st_a7) || (unklatch6_out_11 && au_st_a6);
assign adder2_b12_pre = (unklatch5_out_12 && au_st_a3) || (path2677 && au_st_a2) || (path1398 && au_st_a5) || (path1904 && au_st_a4) || (path2680 && au_st_a1) || (unklatch0_out_12 && au_st_a0) || (unklatch7_out_12 && au_st_a7) || (unklatch6_out_12 && au_st_a6);
assign adder2_b13_pre = (unklatch5_out_13 && au_st_a3) || (path2678 && au_st_a2) || (path2293 && au_st_a5) || (path2292 && au_st_a4) || (path2661 && au_st_a1) || (unklatch0_out_13 && au_st_a0) || (unklatch7_out_13 && au_st_a7) || (unklatch6_out_13 && au_st_a6);
assign adder2_b14_pre = (unklatch5_out_14 && au_st_a3) || (path2775 && au_st_a2) || (path2294 && au_st_a5) || (path2302 && au_st_a4) || (path2298 && au_st_a1) || (unklatch0_out_14 && au_st_a0) || (unklatch7_out_14 && au_st_a7) || (unklatch6_out_14 && au_st_a6);
assign adder2_b15_pre = (unklatch5_out_15 && au_st_a3) || (path2303 && au_st_a2) || (path2304 && au_st_a5) || (path2750 && au_st_a4) || (path2299 && au_st_a1) || (unklatch0_out_15 && au_st_a0) || (unklatch7_out_15 && au_st_a7) || (unklatch6_out_15 && au_st_a6);
assign adder2_b16_pre = (unklatch5_out_16_inv && au_st_a3) || (path2051 && au_st_a2) || (path2053 && au_st_a5) || (path2052 && au_st_a4) || (path2050 && au_st_a1) || (unklatch0_out_16_inv && au_st_a0) || (unklatch7_out_16_inv && au_st_a7) || (unklatch6_out_16_inv && au_st_a6);
assign adder2_b17_pre = (unklatch5_out_17_inv && au_st_a3) || (path2764 && au_st_a2) || (path2232 && au_st_a5) || (path2233 && au_st_a4) || (path1867 && au_st_a1) || (unklatch0_out_17_inv && au_st_a0) || (unklatch7_out_17_inv && au_st_a7) || (unklatch6_out_17_inv && au_st_a6);


assign adder2_p16_n17_01 = adder2_b16_pre && ~adder2_b17_pre && ~test_mode_mpx; // 01
assign adder2_n16_p17_10 = adder2_b17_pre && ~adder2_b16_pre && ~test_mode_mpx; // 10


assign g2235 = ~adder2_b15_pre;
assign path1659 = ~(adder2_b14_pre && ~adder2_n16_p17_10) && ~adder2_p16_n17_01;
assign path2270 = ~(adder2_b13_pre && ~adder2_n16_p17_10) && ~adder2_p16_n17_01;
assign path2468 = ~(adder2_b12_pre && ~adder2_n16_p17_10) && ~adder2_p16_n17_01;
assign path1789 = ~(adder2_b11_pre && ~adder2_n16_p17_10) && ~adder2_p16_n17_01;
assign path1788 = ~(adder2_b11_pre && ~adder2_n16_p17_10) && ~adder2_p16_n17_01;
assign path1960 = ~(adder2_b10_pre && ~adder2_n16_p17_10) && ~adder2_p16_n17_01;
assign path1680 = ~(adder2_b9_pre && ~adder2_n16_p17_10) && ~adder2_p16_n17_01;
assign path1906 = ~(adder2_b8_pre && ~adder2_n16_p17_10) && ~adder2_p16_n17_01;
assign path1514 = ~(adder2_b7_pre && ~adder2_n16_p17_10) && ~adder2_p16_n17_01;
assign path1907 = ~(adder2_b6_pre && ~adder2_n16_p17_10) && ~adder2_p16_n17_01;
assign path2467 = ~(adder2_b5_pre && ~adder2_n16_p17_10) && ~adder2_p16_n17_01;
assign path1911 = ~(adder2_b4_pre && ~adder2_n16_p17_10) && ~adder2_p16_n17_01;
assign path2469 = ~(adder2_b3_pre && ~adder2_n16_p17_10) && ~adder2_p16_n17_01;
assign path2365 = ~(adder2_b2_pre && ~adder2_n16_p17_10) && ~adder2_p16_n17_01;
assign path1672 = ~(adder2_b1_pre && ~adder2_n16_p17_10) && ~adder2_p16_n17_01;

// Every sync, latches the current audio output value
cell_LT4 K77 ( // 4-bit Data Latch
  SYNC_IN, // INPUT G
  g2235, // INPUT DA
  path1659, // INPUT DB
  path2270, // INPUT DC
  path2468, // INPUT DD
  unconnected_K77_NA, // OUTPUT NA
  dac16_glob, // OUTPUT PA
  unconnected_K77_NB, // OUTPUT NB
  dac15_glob, // OUTPUT PB
  unconnected_K77_NC, // OUTPUT NC
  dac14_glob, // OUTPUT PC
  unconnected_K77_ND, // OUTPUT ND
  dac13_glob // OUTPUT PD
);
cell_LT4 K101 ( // 4-bit Data Latch
  SYNC_IN, // INPUT G
  path1789, // INPUT DA
  path1788, // INPUT DB
  path1960, // INPUT DC
  path1680, // INPUT DD
  unconnected_K101_NA, // OUTPUT NA
  dac12_glob, // OUTPUT PA
  unconnected_K101_NB, // OUTPUT NB
  dac11_glob, // OUTPUT PB
  unconnected_K101_NC, // OUTPUT NC
  dac10_glob, // OUTPUT PC
  unconnected_K101_ND, // OUTPUT ND
  dac9_glob // OUTPUT PD
);
cell_LT4 K137 ( // 4-bit Data Latch
  SYNC_IN, // INPUT G
  path1906, // INPUT DA
  path1514, // INPUT DB
  path1907, // INPUT DC
  path2467, // INPUT DD
  unconnected_K137_NA, // OUTPUT NA
  dac8_glob, // OUTPUT PA
  unconnected_K137_NB, // OUTPUT NB
  dac7_glob, // OUTPUT PB
  unconnected_K137_NC, // OUTPUT NC
  dac6_glob, // OUTPUT PC
  unconnected_K137_ND, // OUTPUT ND
  dac5_glob // OUTPUT PD
);
cell_LT4 K117 ( // 4-bit Data Latch
  SYNC_IN, // INPUT G
  path1911, // INPUT DA
  path2469, // INPUT DB
  path2365, // INPUT DC
  path1672, // INPUT DD
  unconnected_K117_NA, // OUTPUT NA
  dac4_glob, // OUTPUT PA
  unconnected_K117_NB, // OUTPUT NB
  dac3_glob, // OUTPUT PB
  unconnected_K117_NC, // OUTPUT NC
  dac2_glob, // OUTPUT PC
  unconnected_K117_ND, // OUTPUT ND
  dac1_glob // OUTPUT PD
);



// ==============================================================================
// DAC Audio Latches and Output
// Stores 8 16-bit samples in latches to then output them in order, while the next ones are being generated

// Which sample to output
cell_FDQ E37 ( // 4-bit DFF
  cycle_15, // INPUT CK
  cnt_samplegroup_b, // INPUT DA
  cnt_samplegroup_c, // INPUT DB
  cnt_samplegroup_d, // INPUT DC
  VCC, // INPUT DD
  path2703, // OUTPUT QA
  path2704, // OUTPUT QB
  path2705, // OUTPUT QC
  unconnected_E37_QD // OUTPUT QD
);
assign dac_dec_ia = (test_mode_dac_dec_sel && cnt_g29_b) || (~test_mode_dac_dec_sel && path2703);
assign dac_dec_ib = (test_mode_dac_dec_sel && cnt_g29_of) || (~test_mode_dac_dec_sel && path2704);
assign dac_dec_ic = (test_mode_dac_dec_sel && cnt_g29_d) || (~test_mode_dac_dec_sel && path2705);
cell_DE3 L120 ( // 3:8 Decoder
  dac_dec_ib, // INPUT B
  dac_dec_ia, // INPUT A
  dac_dec_ic, // INPUT C
  dac_dec_o0, // OUTPUT X0
  dac_dec_o1, // OUTPUT X1
  dac_dec_o2, // OUTPUT X2
  dac_dec_o3, // OUTPUT X3
  dac_dec_o4, // OUTPUT X4
  dac_dec_o5, // OUTPUT X5
  dac_dec_o6, // OUTPUT X6
  dac_dec_o7 // OUTPUT X7
);


assign dac1_glob_n  = ~dac1_glob;
assign dac2_glob_n  = ~dac2_glob;
assign dac3_glob_n  = ~dac3_glob;
assign dac4_glob_n  = ~dac4_glob;
assign dac5_glob_n  = ~dac5_glob;
assign dac6_glob_n  = ~dac6_glob;
assign dac7_glob_n  = ~dac7_glob;
assign dac8_glob_n  = ~dac8_glob;
assign dac9_glob_n  = ~dac9_glob;
assign dac10_glob_n = ~dac10_glob;
assign dac11_glob_n = ~dac11_glob;
assign dac12_glob_n = ~dac12_glob;
assign dac13_glob_n = ~dac13_glob;
assign dac14_glob_n = ~dac14_glob;
assign dac15_glob_n = ~dac15_glob;
assign dac16_glob_n = ~dac16_glob;

assign latch_dacout_01 =   ~((~cycle_1  && test_mode_outp_dac_latch) || (~cycle_0  && ~not_first_sample_cycle_11));
assign latch_dacout_23 =   ~((~cycle_3  && test_mode_outp_dac_latch) || (~cycle_2  && ~not_first_sample_cycle_11));
assign latch_dacout_45 =   ~((~cycle_5  && test_mode_outp_dac_latch) || (~cycle_4  && ~not_first_sample_cycle_11));
assign latch_dacout_67 =   ~((~cycle_7  && test_mode_outp_dac_latch) || (~cycle_6  && ~not_first_sample_cycle_11));
assign latch_dacout_89 =   ~((~cycle_9  && test_mode_outp_dac_latch) || (~cycle_8  && ~not_first_sample_cycle_11));
assign latch_dacout_1011 = ~((~cycle_11 && test_mode_outp_dac_latch) || (~cycle_10 && ~not_first_sample_cycle_11));
assign latch_dacout_1213 = ~((~cycle_13 && test_mode_outp_dac_latch) || (~cycle_12 && ~not_first_sample_cycle_11) || test_mode_dac_out);
assign latch_dacout_1415 = ~((~cycle_15 && test_mode_outp_dac_latch) || (~cycle_14 && ~not_first_sample_cycle_11));

// Latches A
cell_LT4 F77 ( // 4-bit Data Latch
  latch_dacout_01, // INPUT G
  dac12_glob_n, // INPUT DA
  dac11_glob_n, // INPUT DB
  dac10_glob_n, // INPUT DC
  dac9_glob_n, // INPUT DD
  path2741, // OUTPUT NA
  unconnected_F77_PA, // OUTPUT PA
  path1525, // OUTPUT NB
  unconnected_F77_PB, // OUTPUT PB
  path1524, // OUTPUT NC
  unconnected_F77_PC, // OUTPUT PC
  path2399, // OUTPUT ND
  unconnected_F77_PD // OUTPUT PD
);
cell_LT4 B104 ( // 4-bit Data Latch
  latch_dacout_01, // INPUT G
  dac16_glob_n, // INPUT DA
  dac15_glob_n, // INPUT DB
  dac14_glob_n, // INPUT DC
  dac13_glob_n, // INPUT DD
  path2164, // OUTPUT NA
  unconnected_B104_PA, // OUTPUT PA
  path2149, // OUTPUT NB
  unconnected_B104_PB, // OUTPUT PB
  path2148, // OUTPUT NC
  unconnected_B104_PC, // OUTPUT PC
  path2165, // OUTPUT ND
  unconnected_B104_PD // OUTPUT PD
);
cell_LT4 D104 ( // 4-bit Data Latch
  latch_dacout_01, // INPUT G
  dac4_glob_n, // INPUT DA
  dac3_glob_n, // INPUT DB
  dac2_glob_n, // INPUT DC
  dac1_glob_n, // INPUT DD
  path2376, // OUTPUT NA
  unconnected_D104_PA, // OUTPUT PA
  path2063, // OUTPUT NB
  unconnected_D104_PB, // OUTPUT PB
  path2173, // OUTPUT NC
  unconnected_D104_PC, // OUTPUT PC
  path2758, // OUTPUT ND
  unconnected_D104_PD // OUTPUT PD
);
cell_LT4 J127 ( // 4-bit Data Latch
  latch_dacout_01, // INPUT G
  dac8_glob_n, // INPUT DA
  dac7_glob_n, // INPUT DB
  dac6_glob_n, // INPUT DC
  dac5_glob_n, // INPUT DD
  path2192, // OUTPUT NA
  unconnected_J127_PA, // OUTPUT PA
  path1965, // OUTPUT NB
  unconnected_J127_PB, // OUTPUT PB
  path2762, // OUTPUT NC
  unconnected_J127_PC, // OUTPUT PC
  path2097, // OUTPUT ND
  unconnected_J127_PD // OUTPUT PD
);

// Latches B
cell_LT4 C83 ( // 4-bit Data Latch
  latch_dacout_23, // INPUT G
  dac16_glob_n, // INPUT DA
  dac15_glob_n, // INPUT DB
  dac14_glob_n, // INPUT DC
  dac13_glob_n, // INPUT DD
  path2163, // OUTPUT NA
  unconnected_C83_PA, // OUTPUT PA
  path2146, // OUTPUT NB
  unconnected_C83_PB, // OUTPUT PB
  path2147, // OUTPUT NC
  unconnected_C83_PC, // OUTPUT PC
  path2755, // OUTPUT ND
  unconnected_C83_PD // OUTPUT PD
);
cell_LT4 D77 ( // 4-bit Data Latch
  latch_dacout_23, // INPUT G
  dac4_glob_n, // INPUT DA
  dac3_glob_n, // INPUT DB
  dac2_glob_n, // INPUT DC
  dac1_glob_n, // INPUT DD
  path2580, // OUTPUT NA
  unconnected_D77_PA, // OUTPUT PA
  path2752, // OUTPUT NB
  unconnected_D77_PB, // OUTPUT PB
  path2389, // OUTPUT NC
  unconnected_D77_PC, // OUTPUT PC
  path2390, // OUTPUT ND
  unconnected_D77_PD // OUTPUT PD
);
cell_LT4 G77 ( // 4-bit Data Latch
  latch_dacout_23, // INPUT G
  dac12_glob_n, // INPUT DA
  dac11_glob_n, // INPUT DB
  dac10_glob_n, // INPUT DC
  dac9_glob_n, // INPUT DD
  path2743, // OUTPUT NA
  unconnected_G77_PA, // OUTPUT PA
  path2159, // OUTPUT NB
  unconnected_G77_PB, // OUTPUT PB
  path2783, // OUTPUT NC
  unconnected_G77_PC, // OUTPUT PC
  path2400, // OUTPUT ND
  unconnected_G77_PD // OUTPUT PD
);
cell_LT4 H83 ( // 4-bit Data Latch
  latch_dacout_23, // INPUT G
  dac8_glob_n, // INPUT DA
  dac7_glob_n, // INPUT DB
  dac6_glob_n, // INPUT DC
  dac5_glob_n, // INPUT DD
  path2490, // OUTPUT NA
  unconnected_H83_PA, // OUTPUT PA
  path2495, // OUTPUT NB
  unconnected_H83_PB, // OUTPUT PB
  path2501, // OUTPUT NC
  unconnected_H83_PC, // OUTPUT PC
  path2096, // OUTPUT ND
  unconnected_H83_PD // OUTPUT PD
);

// Latches C
cell_LT4 B117 ( // 4-bit Data Latch
  latch_dacout_45, // INPUT G
  dac16_glob_n, // INPUT DA
  dac15_glob_n, // INPUT DB
  dac14_glob_n, // INPUT DC
  dac13_glob_n, // INPUT DD
  path13, // OUTPUT NA
  unconnected_B117_PA, // OUTPUT PA
  path2754, // OUTPUT NB
  unconnected_B117_PB, // OUTPUT PB
  path2753, // OUTPUT NC
  unconnected_B117_PC, // OUTPUT PC
  path2166, // OUTPUT ND
  unconnected_B117_PD // OUTPUT PD
);
cell_LT4 D117 ( // 4-bit Data Latch
  latch_dacout_45, // INPUT G
  dac4_glob_n, // INPUT DA
  dac3_glob_n, // INPUT DB
  dac2_glob_n, // INPUT DC
  dac1_glob_n, // INPUT DD
  path1615, // OUTPUT NA
  unconnected_D117_PA, // OUTPUT PA
  path1616, // OUTPUT NB
  unconnected_D117_PB, // OUTPUT PB
  path2067, // OUTPUT NC
  unconnected_D117_PC, // OUTPUT PC
  path2066, // OUTPUT ND
  unconnected_D117_PD // OUTPUT PD
);
cell_LT4 F90 ( // 4-bit Data Latch
  latch_dacout_45, // INPUT G
  dac12_glob_n, // INPUT DA
  dac11_glob_n, // INPUT DB
  dac10_glob_n, // INPUT DC
  dac9_glob_n, // INPUT DD
  path2535, // OUTPUT NA
  unconnected_F90_PA, // OUTPUT PA
  path2536, // OUTPUT NB
  unconnected_F90_PB, // OUTPUT PB
  path2103, // OUTPUT NC
  unconnected_F90_PC, // OUTPUT PC
  path2104, // OUTPUT ND
  unconnected_F90_PD // OUTPUT PD
);
cell_LT4 J112 ( // 4-bit Data Latch
  latch_dacout_45, // INPUT G
  dac8_glob_n, // INPUT DA
  dac7_glob_n, // INPUT DB
  dac6_glob_n, // INPUT DC
  dac5_glob_n, // INPUT DD
  path1771, // OUTPUT NA
  unconnected_J112_PA, // OUTPUT PA
  path2504, // OUTPUT NB
  unconnected_J112_PB, // OUTPUT PB
  path2505, // OUTPUT NC
  unconnected_J112_PC, // OUTPUT PC
  path2489, // OUTPUT ND
  unconnected_J112_PD // OUTPUT PD
);

// Latches D
cell_LT4 C96 ( // 4-bit Data Latch
  latch_dacout_67, // INPUT G
  dac16_glob_n, // INPUT DA
  dac15_glob_n, // INPUT DB
  dac14_glob_n, // INPUT DC
  dac13_glob_n, // INPUT DD
  path2074, // OUTPUT NA
  unconnected_C96_PA, // OUTPUT PA
  path2075, // OUTPUT NB
  unconnected_C96_PB, // OUTPUT PB
  path2756, // OUTPUT NC
  unconnected_C96_PC, // OUTPUT PC
  path2761, // OUTPUT ND
  unconnected_C96_PD // OUTPUT PD
);
cell_LT4 D90 ( // 4-bit Data Latch
  latch_dacout_67, // INPUT G
  dac4_glob_n, // INPUT DA
  dac3_glob_n, // INPUT DB
  dac2_glob_n, // INPUT DC
  dac1_glob_n, // INPUT DD
  path2760, // OUTPUT NA
  unconnected_D90_PA, // OUTPUT PA
  path2531, // OUTPUT NB
  unconnected_D90_PB, // OUTPUT PB
  path2532, // OUTPUT NC
  unconnected_D90_PC, // OUTPUT PC
  path2759, // OUTPUT ND
  unconnected_D90_PD // OUTPUT PD
);
cell_LT4 G90 ( // 4-bit Data Latch
  latch_dacout_67, // INPUT G
  dac12_glob_n, // INPUT DA
  dac11_glob_n, // INPUT DB
  dac10_glob_n, // INPUT DC
  dac9_glob_n, // INPUT DD
  path2534, // OUTPUT NA
  unconnected_G90_PA, // OUTPUT PA
  path2095, // OUTPUT NB
  unconnected_G90_PB, // OUTPUT PB
  path2539, // OUTPUT NC
  unconnected_G90_PC, // OUTPUT PC
  path2105, // OUTPUT ND
  unconnected_G90_PD // OUTPUT PD
);
cell_LT4 H101 ( // 4-bit Data Latch
  latch_dacout_67, // INPUT G
  dac8_glob_n, // INPUT DA
  dac7_glob_n, // INPUT DB
  dac6_glob_n, // INPUT DC
  dac5_glob_n, // INPUT DD
  path1772, // OUTPUT NA
  unconnected_H101_PA, // OUTPUT PA
  path2496, // OUTPUT NB
  unconnected_H101_PB, // OUTPUT PB
  path2492, // OUTPUT NC
  unconnected_H101_PC, // OUTPUT PC
  path2493, // OUTPUT ND
  unconnected_H101_PD // OUTPUT PD
);

// Latches E
cell_LT4 B130 ( // 4-bit Data Latch
  latch_dacout_89, // INPUT G
  dac16_glob_n, // INPUT DA
  dac15_glob_n, // INPUT DB
  dac14_glob_n, // INPUT DC
  dac13_glob_n, // INPUT DD
  path2079, // OUTPUT NA
  unconnected_B130_PA, // OUTPUT PA
  path2076, // OUTPUT NB
  unconnected_B130_PB, // OUTPUT PB
  path2089, // OUTPUT NC
  unconnected_B130_PC, // OUTPUT PC
  path2153, // OUTPUT ND
  unconnected_B130_PD // OUTPUT PD
);
cell_LT4 D131 ( // 4-bit Data Latch
  latch_dacout_89, // INPUT G
  dac4_glob_n, // INPUT DA
  dac3_glob_n, // INPUT DB
  dac2_glob_n, // INPUT DC
  dac1_glob_n, // INPUT DD
  path1919, // OUTPUT NA
  unconnected_D131_PA, // OUTPUT PA
  path2064, // OUTPUT NB
  unconnected_D131_PB, // OUTPUT PB
  path1617, // OUTPUT NC
  unconnected_D131_PC, // OUTPUT PC
  path2065, // OUTPUT ND
  unconnected_D131_PD // OUTPUT PD
);
cell_LT4 F142 ( // 4-bit Data Latch
  latch_dacout_89, // INPUT G
  dac12_glob_n, // INPUT DA
  dac11_glob_n, // INPUT DB
  dac10_glob_n, // INPUT DC
  dac9_glob_n, // INPUT DD
  path1610, // OUTPUT NA
  unconnected_F142_PA, // OUTPUT PA
  path2094, // OUTPUT NB
  unconnected_F142_PB, // OUTPUT PB
  path2093, // OUTPUT NC
  unconnected_F142_PC, // OUTPUT PC
  path2397, // OUTPUT ND
  unconnected_F142_PD // OUTPUT PD
);
cell_LT4 J140 ( // 4-bit Data Latch
  latch_dacout_89, // INPUT G
  dac8_glob_n, // INPUT DA
  dac7_glob_n, // INPUT DB
  dac6_glob_n, // INPUT DC
  dac5_glob_n, // INPUT DD
  path1768, // OUTPUT NA
  unconnected_J140_PA, // OUTPUT PA
  path1964, // OUTPUT NB
  unconnected_J140_PB, // OUTPUT PB
  path1769, // OUTPUT NC
  unconnected_J140_PC, // OUTPUT PC
  path1770, // OUTPUT ND
  unconnected_J140_PD // OUTPUT PD
);

// Latches F
cell_LT4 G106 ( // 4-bit Data Latch
  latch_dacout_1011, // INPUT G
  dac12_glob_n, // INPUT DA
  dac11_glob_n, // INPUT DB
  dac10_glob_n, // INPUT DC
  dac9_glob_n, // INPUT DD
  path1611, // OUTPUT NA
  unconnected_G106_PA, // OUTPUT PA
  path2537, // OUTPUT NB
  unconnected_G106_PB, // OUTPUT PB
  path2092, // OUTPUT NC
  unconnected_G106_PC, // OUTPUT PC
  path2398, // OUTPUT ND
  unconnected_G106_PD // OUTPUT PD
);
cell_LT4 C109 ( // 4-bit Data Latch
  latch_dacout_1011, // INPUT G
  dac16_glob_n, // INPUT DA
  dac15_glob_n, // INPUT DB
  dac14_glob_n, // INPUT DC
  dac13_glob_n, // INPUT DD
  path2086, // OUTPUT NA
  unconnected_C109_PA, // OUTPUT PA
  path2087, // OUTPUT NB
  unconnected_C109_PB, // OUTPUT PB
  path2088, // OUTPUT NC
  unconnected_C109_PC, // OUTPUT PC
  path2152, // OUTPUT ND
  unconnected_C109_PD // OUTPUT PD
);
cell_LT4 E77 ( // 4-bit Data Latch
  latch_dacout_1011, // INPUT G
  dac4_glob_n, // INPUT DA
  dac3_glob_n, // INPUT DB
  dac2_glob_n, // INPUT DC
  dac1_glob_n, // INPUT DD
  path1918, // OUTPUT NA
  unconnected_E77_PA, // OUTPUT PA
  path2530, // OUTPUT NB
  unconnected_E77_PB, // OUTPUT PB
  path2068, // OUTPUT NC
  unconnected_E77_PC, // OUTPUT PC
  path2069, // OUTPUT ND
  unconnected_E77_PD // OUTPUT PD
);
cell_LT4 I77 ( // 4-bit Data Latch
  latch_dacout_1011, // INPUT G
  dac8_glob_n, // INPUT DA
  dac7_glob_n, // INPUT DB
  dac6_glob_n, // INPUT DC
  dac5_glob_n, // INPUT DD
  path2100, // OUTPUT NA
  unconnected_I77_PA, // OUTPUT PA
  path1758, // OUTPUT NB
  unconnected_I77_PB, // OUTPUT PB
  path2491, // OUTPUT NC
  unconnected_I77_PC, // OUTPUT PC
  path2494, // OUTPUT ND
  unconnected_I77_PD // OUTPUT PD
);

// Latches G
cell_LT4 B143 ( // 4-bit Data Latch
  latch_dacout_1213, // INPUT G
  dac16_glob_n, // INPUT DA
  dac15_glob_n, // INPUT DB
  dac14_glob_n, // INPUT DC
  dac13_glob_n, // INPUT DD
  path2078, // OUTPUT NA
  unconnected_B143_PA, // OUTPUT PA
  path2151, // OUTPUT NB
  unconnected_B143_PB, // OUTPUT PB
  path2395, // OUTPUT NC
  unconnected_B143_PC, // OUTPUT PC
  path2396, // OUTPUT ND
  unconnected_B143_PD // OUTPUT PD
);
cell_LT4 D144 ( // 4-bit Data Latch
  latch_dacout_1213, // INPUT G
  dac4_glob_n, // INPUT DA
  dac3_glob_n, // INPUT DB
  dac2_glob_n, // INPUT DC
  dac1_glob_n, // INPUT DD
  path2757, // OUTPUT NA
  unconnected_D144_PA, // OUTPUT PA
  path2371, // OUTPUT NB
  unconnected_D144_PB, // OUTPUT PB
  path2374, // OUTPUT NC
  unconnected_D144_PC, // OUTPUT PC
  path2375, // OUTPUT ND
  unconnected_D144_PD // OUTPUT PD
);
cell_LT4 F128 ( // 4-bit Data Latch
  latch_dacout_1213, // INPUT G
  dac12_glob_n, // INPUT DA
  dac11_glob_n, // INPUT DB
  dac10_glob_n, // INPUT DC
  dac9_glob_n, // INPUT DD
  path2742, // OUTPUT NA
  unconnected_F128_PA, // OUTPUT PA
  path2102, // OUTPUT NB
  unconnected_F128_PB, // OUTPUT PB
  path2101, // OUTPUT NC
  unconnected_F128_PC, // OUTPUT PC
  path1609, // OUTPUT ND
  unconnected_F128_PD // OUTPUT PD
);
cell_LT4 H116 ( // 4-bit Data Latch
  latch_dacout_1213, // INPUT G
  dac8_glob_n, // INPUT DA
  dac7_glob_n, // INPUT DB
  dac6_glob_n, // INPUT DC
  dac5_glob_n, // INPUT DD
  path2193, // OUTPUT NA
  unconnected_H116_PA, // OUTPUT PA
  path2498, // OUTPUT NB
  unconnected_H116_PB, // OUTPUT PB
  path1523, // OUTPUT NC
  unconnected_H116_PC, // OUTPUT PC
  path2497, // OUTPUT ND
  unconnected_H116_PD // OUTPUT PD
);

// Latches H
cell_LT4 C144 ( // 4-bit Data Latch
  latch_dacout_1415, // INPUT G
  dac16_glob_n, // INPUT DA
  dac15_glob_n, // INPUT DB
  dac14_glob_n, // INPUT DC
  dac13_glob_n, // INPUT DD
  path2077, // OUTPUT NA
  unconnected_C144_PA, // OUTPUT PA
  path2150, // OUTPUT NB
  unconnected_C144_PB, // OUTPUT PB
  path2394, // OUTPUT NC
  unconnected_C144_PC, // OUTPUT PC
  path2533, // OUTPUT ND
  unconnected_C144_PD // OUTPUT PD
);
cell_LT4 E90 ( // 4-bit Data Latch
  latch_dacout_1415, // INPUT G
  dac4_glob_n, // INPUT DA
  dac3_glob_n, // INPUT DB
  dac2_glob_n, // INPUT DC
  dac1_glob_n, // INPUT DD
  path2581, // OUTPUT NA
  unconnected_E90_PA, // OUTPUT PA
  path2372, // OUTPUT NB
  unconnected_E90_PB, // OUTPUT PB
  path2373, // OUTPUT NC
  unconnected_E90_PC, // OUTPUT PC
  path2391, // OUTPUT ND
  unconnected_E90_PD // OUTPUT PD
);
cell_LT4 G143 ( // 4-bit Data Latch
  latch_dacout_1415, // INPUT G
  dac12_glob_n, // INPUT DA
  dac11_glob_n, // INPUT DB
  dac10_glob_n, // INPUT DC
  dac9_glob_n, // INPUT DD
  path2157, // OUTPUT NA
  unconnected_G143_PA, // OUTPUT PA
  path2158, // OUTPUT NB
  unconnected_G143_PB, // OUTPUT PB
  path2538, // OUTPUT NC
  unconnected_G143_PC, // OUTPUT PC
  path1608, // OUTPUT ND
  unconnected_G143_PD // OUTPUT PD
);
cell_LT4 I90 ( // 4-bit Data Latch
  latch_dacout_1415, // INPUT G
  dac8_glob_n, // INPUT DA
  dac7_glob_n, // INPUT DB
  dac6_glob_n, // INPUT DC
  dac5_glob_n, // INPUT DD
  path2502, // OUTPUT NA
  unconnected_I90_PA, // OUTPUT PA
  path2499, // OUTPUT NB
  unconnected_I90_PB, // OUTPUT PB
  path2500, // OUTPUT NC
  unconnected_I90_PC, // OUTPUT PC
  path2785, // OUTPUT ND
  unconnected_I90_PD // OUTPUT PD
);


// assign DAC1_OUT = ~(~(not_first_sample && test_mode_2) &&
//                  ~(~((path2375 && ~dac_dec_o0) || (path2391 && ~dac_dec_o1) || (path2758 && ~dac_dec_o2) || (path2390 && ~dac_dec_o3) || (path2066 && ~dac_dec_o4) || (path2759 && ~dac_dec_o5) || (path2065 && ~dac_dec_o6) || (path2069 && ~dac_dec_o7)) && ~test_mode_2));
// assign DAC2_OUT = ~(~(adder2_b_sel && test_mode_2) &&
//                  ~(~((path2374 && ~dac_dec_o0) || (path2373 && ~dac_dec_o1) || (path2173 && ~dac_dec_o2) || (path2389 && ~dac_dec_o3) || (path2067 && ~dac_dec_o4) || (path2532 && ~dac_dec_o5) || (path1617 && ~dac_dec_o6) || (path2068 && ~dac_dec_o7)) && ~test_mode_2));
// assign DAC3_OUT = ~(~(~adder2_b0_pre && test_mode_2) &&
//                  ~(~((path2371 && ~dac_dec_o0) || (path2372 && ~dac_dec_o1) || (path2063 && ~dac_dec_o2) || (path2752 && ~dac_dec_o3) || (path1616 && ~dac_dec_o4) || (path2531 && ~dac_dec_o5) || (path2064 && ~dac_dec_o6) || (path2530 && ~dac_dec_o7)) && ~test_mode_2));
// assign DAC4_OUT = ~(~(~adder2_b16_pre && test_mode_2) &&
//                  ~(~((path2757 && ~dac_dec_o0) || (path2581 && ~dac_dec_o1) || (path2376 && ~dac_dec_o2) || (path2580 && ~dac_dec_o3) || (path1615 && ~dac_dec_o4) || (path2760 && ~dac_dec_o5) || (path1919 && ~dac_dec_o6) || (path1918 && ~dac_dec_o7)) && ~test_mode_2));
// assign DAC5_OUT = ~(~(path2763 && test_mode_2) &&
//                  ~(~((path2497 && ~dac_dec_o0) || (path2785 && ~dac_dec_o1) || (path2097 && ~dac_dec_o2) || (path2096 && ~dac_dec_o3) || (path2489 && ~dac_dec_o4) || (path2493 && ~dac_dec_o5) || (path1770 && ~dac_dec_o6) || (path2494 && ~dac_dec_o7)) && ~test_mode_2));
// assign DAC6_OUT = ~(~(path2406 && test_mode_2) &&
//                  ~(~((path1523 && ~dac_dec_o0) || (path2500 && ~dac_dec_o1) || (path2762 && ~dac_dec_o2) || (path2501 && ~dac_dec_o3) || (path2505 && ~dac_dec_o4) || (path2492 && ~dac_dec_o5) || (path1769 && ~dac_dec_o6) || (path2491 && ~dac_dec_o7)) && ~test_mode_2));
// assign DAC7_OUT = ~(~(path2180 && test_mode_2) &&
//                  ~(~((path2498 && ~dac_dec_o0) || (path2499 && ~dac_dec_o1) || (path1965 && ~dac_dec_o2) || (path2495 && ~dac_dec_o3) || (path2504 && ~dac_dec_o4) || (path2496 && ~dac_dec_o5) || (path1964 && ~dac_dec_o6) || (path1758 && ~dac_dec_o7)) && ~test_mode_2));
// assign DAC8_OUT = ~(~(g2256    && test_mode_2) &&
//                  ~(~((path2193 && ~dac_dec_o0) || (path2502 && ~dac_dec_o1) || (path2192 && ~dac_dec_o2) || (path2490 && ~dac_dec_o3) || (path1771 && ~dac_dec_o4) || (path1772 && ~dac_dec_o5) || (path1768 && ~dac_dec_o6) || (path2100 && ~dac_dec_o7)) && ~test_mode_2));
// assign DAC9_OUT = ~(~(path2403 && test_mode_2) &&
//                  ~(~((path1609 && ~dac_dec_o0) || (path1608 && ~dac_dec_o1) || (path2399 && ~dac_dec_o2) || (path2400 && ~dac_dec_o3) || (path2104 && ~dac_dec_o4) || (path2105 && ~dac_dec_o5) || (path2397 && ~dac_dec_o6) || (path2398 && ~dac_dec_o7)) && ~test_mode_2));

assign DAC1_OUT  = ~((path2375 && ~dac_dec_o0) || (path2391 && ~dac_dec_o1) || (path2758 && ~dac_dec_o2) || (path2390 && ~dac_dec_o3) || (path2066 && ~dac_dec_o4) || (path2759 && ~dac_dec_o5) || (path2065 && ~dac_dec_o6) || (path2069 && ~dac_dec_o7));
assign DAC2_OUT  = ~((path2374 && ~dac_dec_o0) || (path2373 && ~dac_dec_o1) || (path2173 && ~dac_dec_o2) || (path2389 && ~dac_dec_o3) || (path2067 && ~dac_dec_o4) || (path2532 && ~dac_dec_o5) || (path1617 && ~dac_dec_o6) || (path2068 && ~dac_dec_o7));
assign DAC3_OUT  = ~((path2371 && ~dac_dec_o0) || (path2372 && ~dac_dec_o1) || (path2063 && ~dac_dec_o2) || (path2752 && ~dac_dec_o3) || (path1616 && ~dac_dec_o4) || (path2531 && ~dac_dec_o5) || (path2064 && ~dac_dec_o6) || (path2530 && ~dac_dec_o7));
assign DAC4_OUT  = ~((path2757 && ~dac_dec_o0) || (path2581 && ~dac_dec_o1) || (path2376 && ~dac_dec_o2) || (path2580 && ~dac_dec_o3) || (path1615 && ~dac_dec_o4) || (path2760 && ~dac_dec_o5) || (path1919 && ~dac_dec_o6) || (path1918 && ~dac_dec_o7));
assign DAC5_OUT  = ~((path2497 && ~dac_dec_o0) || (path2785 && ~dac_dec_o1) || (path2097 && ~dac_dec_o2) || (path2096 && ~dac_dec_o3) || (path2489 && ~dac_dec_o4) || (path2493 && ~dac_dec_o5) || (path1770 && ~dac_dec_o6) || (path2494 && ~dac_dec_o7));
assign DAC6_OUT  = ~((path1523 && ~dac_dec_o0) || (path2500 && ~dac_dec_o1) || (path2762 && ~dac_dec_o2) || (path2501 && ~dac_dec_o3) || (path2505 && ~dac_dec_o4) || (path2492 && ~dac_dec_o5) || (path1769 && ~dac_dec_o6) || (path2491 && ~dac_dec_o7));
assign DAC7_OUT  = ~((path2498 && ~dac_dec_o0) || (path2499 && ~dac_dec_o1) || (path1965 && ~dac_dec_o2) || (path2495 && ~dac_dec_o3) || (path2504 && ~dac_dec_o4) || (path2496 && ~dac_dec_o5) || (path1964 && ~dac_dec_o6) || (path1758 && ~dac_dec_o7));
assign DAC8_OUT  = ~((path2193 && ~dac_dec_o0) || (path2502 && ~dac_dec_o1) || (path2192 && ~dac_dec_o2) || (path2490 && ~dac_dec_o3) || (path1771 && ~dac_dec_o4) || (path1772 && ~dac_dec_o5) || (path1768 && ~dac_dec_o6) || (path2100 && ~dac_dec_o7));
assign DAC9_OUT  = ~((path1609 && ~dac_dec_o0) || (path1608 && ~dac_dec_o1) || (path2399 && ~dac_dec_o2) || (path2400 && ~dac_dec_o3) || (path2104 && ~dac_dec_o4) || (path2105 && ~dac_dec_o5) || (path2397 && ~dac_dec_o6) || (path2398 && ~dac_dec_o7));
assign DAC10_OUT = ~((path2101 && ~dac_dec_o0) || (path2538 && ~dac_dec_o1) || (path1524 && ~dac_dec_o2) || (path2783 && ~dac_dec_o3) || (path2103 && ~dac_dec_o4) || (path2539 && ~dac_dec_o5) || (path2093 && ~dac_dec_o6) || (path2092 && ~dac_dec_o7));
assign DAC11_OUT = ~((path2102 && ~dac_dec_o0) || (path2158 && ~dac_dec_o1) || (path1525 && ~dac_dec_o2) || (path2159 && ~dac_dec_o3) || (path2536 && ~dac_dec_o4) || (path2095 && ~dac_dec_o5) || (path2094 && ~dac_dec_o6) || (path2537 && ~dac_dec_o7));
assign DAC12_OUT = ~((path2742 && ~dac_dec_o0) || (path2157 && ~dac_dec_o1) || (path2741 && ~dac_dec_o2) || (path2743 && ~dac_dec_o3) || (path2535 && ~dac_dec_o4) || (path2534 && ~dac_dec_o5) || (path1610 && ~dac_dec_o6) || (path1611 && ~dac_dec_o7));
assign DAC13_OUT = ~((path2396 && ~dac_dec_o0) || (path2533 && ~dac_dec_o1) || (path2165 && ~dac_dec_o2) || (path2755 && ~dac_dec_o3) || (path2166 && ~dac_dec_o4) || (path2761 && ~dac_dec_o5) || (path2153 && ~dac_dec_o6) || (path2152 && ~dac_dec_o7));
assign DAC14_OUT = ~((path2395 && ~dac_dec_o0) || (path2394 && ~dac_dec_o1) || (path2148 && ~dac_dec_o2) || (path2147 && ~dac_dec_o3) || (path2753 && ~dac_dec_o4) || (path2756 && ~dac_dec_o5) || (path2089 && ~dac_dec_o6) || (path2088 && ~dac_dec_o7));
assign DAC15_OUT = ~((path2151 && ~dac_dec_o0) || (path2150 && ~dac_dec_o1) || (path2149 && ~dac_dec_o2) || (path2146 && ~dac_dec_o3) || (path2754 && ~dac_dec_o4) || (path2075 && ~dac_dec_o5) || (path2076 && ~dac_dec_o6) || (path2087 && ~dac_dec_o7));
assign DAC16_OUT =   (path2078 && ~dac_dec_o0) || (path2077 && ~dac_dec_o1) || (path2164 && ~dac_dec_o2) || (path2163 && ~dac_dec_o3) || (path13 && ~dac_dec_o4)   || (path2074 && ~dac_dec_o5) || (path2079 && ~dac_dec_o6) || (path2086 && ~dac_dec_o7);


endmodule
