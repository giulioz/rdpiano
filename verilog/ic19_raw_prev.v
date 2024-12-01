`timescale 1ns/100ps

module IC19 (
  input wire E_NOR_77_IN,
  input wire AL_CT_76_IN,
  input wire UNK_75_IN,
  input wire UNK_74_IN,
  output wire P1_TOVERFLOW,

  input wire FSYNC_IN,
  input wire SYNC_IN,

  input wire E_IN,
  input wire RW_IN,
  output wire IRQ_OUT,
  input wire RESET_IN,
  input wire AS_IN,

  input wire [7:0] CPU_P3_IN,
  output wire [7:0] CPU_P3_OUT,
  output wire CPU_P3_IOM,

  input wire [7:0] CPU_P4_IN,
  input wire [7:0] AL_IN,
  output wire [7:0] AL_OUT,
  output wire AL0_IOM,

  output wire RD_OUT,
  output wire WR_OUT,
  output wire PARAM_ROMCS_OUT,
  output wire RAMCS_OUT,

  input wire [7:0] RIC12_D_IN,
  output wire [7:0] RIC12_D_OUT,
  output wire RIC12_D_IOM,
  output wire [10:0] RIC12_A_OUT,
  output wire RIC12_OE_OUT,
  output wire RIC12_WE_OUT,

  input wire [7:0] RIC13_D_IN,
  output wire [7:0] RIC13_D_OUT,
  output wire RIC13_D_IOM,

  output wire IO2_OUT,
  output wire IO3_OUT,
  output wire IO4_OUT,
  output wire IO5_OUT,
  output wire IO6_OUT,
  output wire IO7_OUT,
  output wire IO8_OUT
);



// =============================================================================
// Verilog glue logic for module I/O
wire VCC, GND;
assign GND = 0;
assign VCC = 1;

wire P37_OUT, P36_OUT, P35_OUT, P34_OUT, P33_OUT, P32_OUT, P31_OUT, P30_OUT;
wire RIC12_D7_OUT, RIC12_D6_OUT, RIC12_D5_OUT, RIC12_D4_OUT, RIC12_D3_OUT, RIC12_D2_OUT, RIC12_D1_OUT, RIC12_D0_OUT;
wire RIC12_A10_OUT, RIC12_A9_OUT, RIC12_A8_OUT, RIC12_A7_OUT, RIC12_A6_OUT, RIC12_A5_OUT, RIC12_A4_OUT, RIC12_A3_OUT, RIC12_A2_OUT, RIC12_A1_OUT, RIC12_A0_OUT;
wire RIC13_D7_OUT, RIC13_D6_OUT, RIC13_D5_OUT, RIC13_D4_OUT, RIC13_D3_OUT, RIC13_D2_OUT, RIC13_D1_OUT, RIC13_D0_OUT;

assign {AL7_IN, AL6_IN, AL5_IN, AL4_IN, AL3_IN, AL2_IN, AL1_IN, AL0_IN} = AL_IN;
assign AL_OUT = {AL7_OUT, AL6_OUT, AL5_OUT, AL4_OUT, AL3_OUT, AL2_OUT, AL1_OUT, AL0_OUT};
assign {P37_IN, P36_IN, P35_IN, P34_IN, P33_IN, P32_IN, P31_IN, P30_IN} = CPU_P3_IN;
assign CPU_P3_OUT = {P37_OUT, P36_OUT, P35_OUT, P34_OUT, P33_OUT, P32_OUT, P31_OUT, P30_OUT};
// P45 seems to have an inverted input!
assign {P47_IN, P46_IN, P45_IN, P44_IN, P43_IN, P42_IN, P41_IN, P40_IN} = CPU_P4_IN;
assign {RIC12_D7_IN, RIC12_D6_IN, RIC12_D5_IN, RIC12_D4_IN, RIC12_D3_IN, RIC12_D2_IN, RIC12_D1_IN, RIC12_D0_IN} = RIC12_D_IN;
assign RIC12_D_OUT = {RIC12_D7_OUT, RIC12_D6_OUT, RIC12_D5_OUT, RIC12_D4_OUT, RIC12_D3_OUT, RIC12_D2_OUT, RIC12_D1_OUT, RIC12_D0_OUT};
assign RIC12_A_OUT = {RIC12_A10_OUT, RIC12_A9_OUT, RIC12_A8_OUT, RIC12_A7_OUT, RIC12_A6_OUT, RIC12_A5_OUT, RIC12_A4_OUT, RIC12_A3_OUT, RIC12_A2_OUT, RIC12_A1_OUT, RIC12_A0_OUT};
assign {RIC13_D7_IN, RIC13_D6_IN, RIC13_D5_IN, RIC13_D4_IN, RIC13_D3_IN, RIC13_D2_IN, RIC13_D1_IN, RIC13_D0_IN} = RIC13_D_IN;
assign RIC13_D_OUT = {RIC13_D7_OUT, RIC13_D6_OUT, RIC13_D5_OUT, RIC13_D4_OUT, RIC13_D3_OUT, RIC13_D2_OUT, RIC13_D1_OUT, RIC13_D0_OUT};



// =============================================================================
// Address Latch & Decoding for CPU

// Probably schmidtt trigger for AS
cell_unkf P28 ( // Unknown F
  AS_IN, // INPUT I
  unconnected_P28_XA, // OUTPUT XA
  as_inv // OUTPUT XB
);
cell_LT4 T4 ( // 4-bit Data Latch
  as_inv, // INPUT G
  P33_IN, // INPUT DA
  P32_IN, // INPUT DB
  P31_IN, // INPUT DC
  P30_IN, // INPUT DD
  unconnected_T4_NA, // OUTPUT NA
  AL3_OUT, // OUTPUT PA
  unconnected_T4_NB, // OUTPUT NB
  AL2_OUT, // OUTPUT PB
  unconnected_T4_NC, // OUTPUT NC
  AL1_OUT, // OUTPUT PC
  unconnected_T4_ND, // OUTPUT ND
  AL0_OUT // OUTPUT PD
);
cell_LT4 V33 ( // 4-bit Data Latch
  as_inv, // INPUT G
  P37_IN, // INPUT DA
  P36_IN, // INPUT DB
  P35_IN, // INPUT DC
  P34_IN, // INPUT DD
  unconnected_V33_NA, // OUTPUT NA
  AL7_OUT, // OUTPUT PA
  unconnected_V33_NB, // OUTPUT NB
  AL6_OUT, // OUTPUT PB
  unconnected_V33_NC, // OUTPUT NC
  AL5_OUT, // OUTPUT PC
  unconnected_V33_ND, // OUTPUT ND
  AL4_OUT // OUTPUT PD
);

assign AL0_IOM = UNK_74_IN && ~AL_CT_76_IN;
// 0x4000-0xbfff
assign PARAM_ROMCS_OUT = ~(P47_IN ^ P46_IN) || RD_OUT;
// 0x0000-0x0fff
assign RAMCS_OUT = ~(~(P47_IN || P46_IN) && P45_IN && ~P44_IN);
assign RD_OUT = ~(RW_IN && E_IN);
assign WR_OUT = ~(~RW_IN && E_IN);



// =============================================================================
// Internal cycles counting

cell_C45 F13 ( // 4-bit Binary Synchronous Up Counter
  VCC, // INPUT DA
  VCC, // INPUT EN
  VCC, // INPUT CI
  FSYNC_IN, // INPUT CL
  VCC, // INPUT DB
  UNK_74_IN, // INPUT L
  SYNC_IN, // INPUT CK
  VCC, // INPUT DC
  VCC, // INPUT DD
  path1288_8dec_in_b, // OUTPUT QA
  path1042_8dec_in_a, // OUTPUT QB
  unconnected_F13_CO, // OUTPUT CO
  path1238_8dec_in_c, // OUTPUT QC
  g300_step_counter_d // OUTPUT QD
);

cell_DE3 N46 ( // 3:8 Decoder
  path1042_8dec_in_a, // INPUT B
  path1288_8dec_in_b, // INPUT A
  path1238_8dec_in_c, // INPUT C
  g1055_8dec_out0, // OUTPUT X0
  g1057_8dec_out1, // OUTPUT X1
  g1041_8dec_out2, // OUTPUT X2
  g1215_8dec_out3, // OUTPUT X3
  g1213_8dec_out4, // OUTPUT X4
  g1049_8dec_out5, // OUTPUT X5
  g1051_8dec_out6, // OUTPUT X6
  g1209_8dec_out7 // OUTPUT X7
);

assign cycle_0 = g1055_8dec_out0 || SYNC_IN || g300_step_counter_d;
assign cycle_1 = g1057_8dec_out1 || SYNC_IN || g300_step_counter_d;
assign cycle_2 = g1041_8dec_out2 || SYNC_IN || g300_step_counter_d;
assign cycle_3 = g1215_8dec_out3 || SYNC_IN || g300_step_counter_d;
assign cycle_4 = g1213_8dec_out4 || SYNC_IN || g300_step_counter_d;
assign cycle_5 = g1049_8dec_out5 || SYNC_IN || g300_step_counter_d;
assign cycle_6 = g1051_8dec_out6 || SYNC_IN || g300_step_counter_d;
assign cycle_7 = g1209_8dec_out7 || SYNC_IN || g300_step_counter_d;
assign cycle_8 = g1055_8dec_out0 || SYNC_IN || ~g300_step_counter_d;
assign cycle_9 = g1057_8dec_out1 || SYNC_IN || ~g300_step_counter_d;
assign cycle_10 = g1041_8dec_out2 || SYNC_IN || ~g300_step_counter_d;
assign cycle_11 = g1215_8dec_out3 || SYNC_IN || ~g300_step_counter_d;
assign cycle_12 = g1213_8dec_out4 || SYNC_IN || ~g300_step_counter_d;
assign cycle_13 = g1049_8dec_out5 || SYNC_IN || ~g300_step_counter_d;
assign cycle_14 = g1051_8dec_out6 || SYNC_IN || ~g300_step_counter_d;
assign cycle_15 = g1209_8dec_out7 || SYNC_IN || ~g300_step_counter_d;

assign cycle_odd = cycle_1 && cycle_3 && cycle_5 && cycle_7 && cycle_9 && cycle_11 && cycle_13 && cycle_15;
assign cycle_even = cycle_0 && cycle_2 && cycle_4 && cycle_6 && cycle_8 && cycle_10 && cycle_12 && cycle_14;
assign cycle_between = cycle_even && cycle_odd;



// =============================================================================
// Latches from CPU for memory R/W (IC12)
// Whenever a 16-bit (STX) write happens in the 0x1000-0x1fff range, the chip latches the data
// and address to be written to IC12 later. The pending write status is saved in a flip flop.

// Detects CPU writes at odd/even bytes at 0x1000-0x1fff
assign wr_1000 = ~(~P47_IN && ~P46_IN && P45_IN && P44_IN && ~(~(AL0_OUT && AL_CT_76_IN) && ~(AL0_IN && ~AL_CT_76_IN)) && ~RW_IN && E_IN);
assign wr_1001 = ~(~P47_IN && ~P46_IN && P45_IN && P44_IN && ~(AL0_OUT && AL_CT_76_IN) && ~(AL0_IN && ~AL_CT_76_IN) && ~RW_IN && E_IN);

// Pending write state, set on wr_1000 and reset when it has be actually written
assign ric12_reset_write_state = ~(ric12_enable_write && ~cycle_9);
cell_FDP G12 ( // DFF with SET and RESET
  wr_1000, // INPUT CK
  E_IN, // INPUT D
  ric12_reset_write_state, // INPUT R
  UNK_74_IN, // INPUT S
  cpu_ric12_write_pending, // OUTPUT Q
  unconnected_G12_XQ // OUTPUT XQ
);
// On cycle 8, check if a write from the cpu is pending
cell_FDM G40 ( // DFF
  ~cycle_8, // INPUT CK
  cpu_ric12_write_pending, // INPUT D
  ric12_not_writing, // OUTPUT XQ
  ric12_enable_write // OUTPUT Q
);

// Latches address bits 2-11
assign path550 = ~(~(AL1_OUT && AL_CT_76_IN) && ~(AL1_IN && ~AL_CT_76_IN));
assign path555 = ~(~(AL2_OUT && AL_CT_76_IN) && ~(AL2_IN && ~AL_CT_76_IN));
assign g352 =    ~(~(AL4_OUT && AL_CT_76_IN) && ~(AL4_IN && ~AL_CT_76_IN));
assign path554 = ~(~(AL5_OUT && AL_CT_76_IN) && ~(AL5_IN && ~AL_CT_76_IN));
assign g350 =    ~(~(AL6_OUT && AL_CT_76_IN) && ~(AL6_IN && ~AL_CT_76_IN));
assign path493 = ~(~(AL7_OUT && AL_CT_76_IN) && ~(AL7_IN && ~AL_CT_76_IN));
cell_LT4 V61 ( // 4-bit Data Latch
  wr_1000, // INPUT G
  P43_IN, // INPUT DA
  P42_IN, // INPUT DB
  P41_IN, // INPUT DC
  P40_IN, // INPUT DD
  unconnected_V61_NA, // OUTPUT NA
  al11_latched_wr_1000, // OUTPUT PA
  unconnected_V61_NB, // OUTPUT NB
  al10_latched_wr_1000, // OUTPUT PB
  unconnected_V61_NC, // OUTPUT NC
  al9_latched_wr_1000, // OUTPUT PC
  unconnected_V61_ND, // OUTPUT ND
  al8_latched_wr_1000 // OUTPUT PD
);
cell_LT4 K34 ( // 4-bit Data Latch
  wr_1000, // INPUT G
  path493, // INPUT DA
  g350, // INPUT DB
  path554, // INPUT DC
  g352, // INPUT DD
  unconnected_K34_NA, // OUTPUT NA
  al7_latched_wr_1000, // OUTPUT PA
  unconnected_K34_NB, // OUTPUT NB
  al6_latched_wr_1000, // OUTPUT PB
  unconnected_K34_NC, // OUTPUT NC
  al5_latched_wr_1000, // OUTPUT PC
  unconnected_K34_ND, // OUTPUT ND
  al4_latched_wr_1000 // OUTPUT PD
);
cell_LT2 K48 ( // 1-bit Data Latch
  wr_1000, // INPUT G
  path555, // INPUT D
  al2_latched_wr_1000, // OUTPUT Q
  unconnected_K48_XQ // OUTPUT XQ
);
cell_LT2 K52 ( // 1-bit Data Latch
  wr_1000, // INPUT G
  path550, // INPUT D
  al1_latched_wr_1000, // OUTPUT Q
  unconnected_K52_XQ // OUTPUT XQ
);

// Latches data (even)
cell_LT4 T33 ( // 4-bit Data Latch
  wr_1000, // INPUT G
  P33_IN, // INPUT DA
  P32_IN, // INPUT DB
  P31_IN, // INPUT DC
  P30_IN, // INPUT DD
  p33_latched_wr_1000, // OUTPUT NA
  unconnected_T33_PA, // OUTPUT PA
  p32_latched_wr_1000, // OUTPUT NB
  unconnected_T33_PB, // OUTPUT PB
  p31_latched_wr_1000, // OUTPUT NC
  unconnected_T33_PC, // OUTPUT PC
  p30_latched_wr_1000, // OUTPUT ND
  unconnected_T33_PD // OUTPUT PD
);
cell_LT4 V48 ( // 4-bit Data Latch
  wr_1000, // INPUT G
  P37_IN, // INPUT DA
  P36_IN, // INPUT DB
  P35_IN, // INPUT DC
  P34_IN, // INPUT DD
  p37_latched_wr_1000, // OUTPUT NA
  unconnected_V48_PA, // OUTPUT PA
  p36_latched_wr_1000, // OUTPUT NB
  unconnected_V48_PB, // OUTPUT PB
  p35_latched_wr_1000, // OUTPUT NC
  unconnected_V48_PC, // OUTPUT PC
  p34_latched_wr_1000, // OUTPUT ND
  unconnected_V48_PD // OUTPUT PD
);

// Latches data (odd)
cell_LT4 T17 ( // 4-bit Data Latch
  wr_1001, // INPUT G
  P33_IN, // INPUT DA
  P32_IN, // INPUT DB
  P31_IN, // INPUT DC
  P30_IN, // INPUT DD
  p33_latched_wr_1001, // OUTPUT NA
  unconnected_T17_PA, // OUTPUT PA
  p32_latched_wr_1001, // OUTPUT NB
  unconnected_T17_PB, // OUTPUT PB
  p31_latched_wr_1001, // OUTPUT NC
  unconnected_T17_PC, // OUTPUT PC
  p30_latched_wr_1001, // OUTPUT ND
  unconnected_T17_PD // OUTPUT PD
);
cell_LT4 U31 ( // 4-bit Data Latch
  wr_1001, // INPUT G
  P37_IN, // INPUT DA
  P36_IN, // INPUT DB
  P35_IN, // INPUT DC
  P34_IN, // INPUT DD
  p37_latched_wr_1001, // OUTPUT NA
  unconnected_U31_PA, // OUTPUT PA
  p36_latched_wr_1001, // OUTPUT NB
  unconnected_U31_PB, // OUTPUT PB
  p35_latched_wr_1001, // OUTPUT NC
  unconnected_U31_PC, // OUTPUT PC
  p34_latched_wr_1001, // OUTPUT ND
  unconnected_U31_PD // OUTPUT PD
);



// =============================================================================
// Controls memory (IC12)
// Generates an address that scans the entire ram, going over 0-7 twice

// Lower 0-7 address (twice)
cell_C45 E7 ( // 4-bit Binary Synchronous Up Counter
  VCC, // INPUT DA
  VCC, // INPUT EN
  VCC, // INPUT CI
  FSYNC_IN, // INPUT CL
  VCC, // INPUT DB
  UNK_74_IN, // INPUT L
  cycle_between, // INPUT CK
  VCC, // INPUT DC
  VCC, // INPUT DD

  ric12_ac_0, // OUTPUT QA
  ric12_ac_1, // OUTPUT QB
  counter_e7_of, // OUTPUT CO
  ric12_ac_2, // OUTPUT QC
  ric12_ac0_stage // OUTPUT QD
);

// Part address, resets on FSYNC or when 9 is reached (0-9)
assign counter_b13_restart = FSYNC_IN && ~(ric12_ac_6 && ric12_ac_3 && (counter_e7_of || ~UNK_74_IN));
cell_C45 B13 ( // 4-bit Binary Synchronous Up Counter
  GND, // INPUT DA
  counter_e7_of || ~UNK_74_IN, // INPUT EN
  counter_e7_of || ~UNK_74_IN, // INPUT CI
  counter_b13_restart, // INPUT CL
  GND, // INPUT DB
  VCC, // INPUT L
  cycle_between, // INPUT CK
  GND, // INPUT DC
  GND, // INPUT DD

  ric12_ac_3, // OUTPUT QA
  ric12_ac_4, // OUTPUT QB
  unconnected_B13_CO, // OUTPUT CO
  ric12_ac_5, // OUTPUT QC
  ric12_ac_6 // OUTPUT QD
);

// Voice address 0-15
assign counter_d13_ci = ric12_ac_6 && ric12_ac_3 && (counter_e7_of || ~UNK_74_IN);
cell_C45 D13 ( // 4-bit Binary Synchronous Up Counter
  GND, // INPUT DA
  VCC, // INPUT EN
  counter_d13_ci, // INPUT CI
  FSYNC_IN, // INPUT CL
  GND, // INPUT DB
  VCC, // INPUT L
  cycle_between, // INPUT CK
  GND, // INPUT DC
  GND, // INPUT DD

  ric12_ac_7, // OUTPUT QA
  ric12_ac_8, // OUTPUT QB
  unconnected_D13_CO, // OUTPUT CO
  ric12_ac_9, // OUTPUT QC
  ric12_ac_10 // OUTPUT QD
);


// Read signal for IC12 from counter E7
assign counter_e7_5 = ~ric12_ac0_stage && ric12_ac_2 && ~ric12_ac_1 && ric12_ac_0; // 5
assign counter_e7_8 = ric12_ac0_stage && ~ric12_ac_2 && ~ric12_ac_1 && ~ric12_ac_0; // 8
assign counter_e7_9 = ric12_ac0_stage && ~ric12_ac_2 && ~ric12_ac_1 && ric12_ac_0; // 9
assign counter_e7_5_8_9 = counter_e7_9 || counter_e7_8 || counter_e7_5;
assign counter_e7_8_9 = counter_e7_9 || counter_e7_8;

cell_FDM C4 ( // DFF
  cycle_between, // INPUT CK
  counter_e7_8_9, // INPUT D
  ric12_rd_ctrl_inv, // OUTPUT XQ
  ric12_rd_ctrl // OUTPUT Q
);
assign RIC12_OE_OUT = ~ric12_rd_ctrl_inv;
assign RIC12_D_IOM = ~ric12_rd_ctrl && UNK_74_IN;
// Writes RIC12 on cycle 9 and 10 if needed
assign RIC12_WE_OUT = ~((~cycle_9 || ~cycle_10) && ric12_enable_write);

// Controls cpu write
assign path991 = counter_e7_9 || ~counter_e7_8 || (al1_latched_wr_1000 && al2_latched_wr_1000);
cell_FDM F7 ( // DFF
  cycle_between, // INPUT CK
  path991, // INPUT D
  ric12_partaddr_fromcpu, // OUTPUT XQ
  unconnected_F7_Q // OUTPUT Q
);
// Use internal part addr on cycles 5/8/9
cell_FDM B1 ( // DFF
  cycle_between, // INPUT CK
  counter_e7_5_8_9, // INPUT D
  unconnected_B1_XQ, // OUTPUT XQ
  ric12_partaddr_internal // OUTPUT Q
);

// (addres read) || (addres cpu)
// 0-7 inside part
assign RIC12_A0_OUT = ~((ric12_ac_0 && ~ric12_rd_ctrl) || (~ric12_ac_0 && RIC12_OE_OUT));
assign RIC12_A1_OUT = ~((ric12_ac_1 && ~ric12_rd_ctrl) || (al1_latched_wr_1000 && RIC12_OE_OUT));
assign RIC12_A2_OUT = ~((ric12_ac_2 && ~ric12_rd_ctrl) || (al2_latched_wr_1000 && RIC12_OE_OUT));
// 0-15 select part
// NOTE: cpu address in 3 is ignored
assign RIC12_A3_OUT = ~(~(ric12_ac_3 && ~ric12_partaddr_internal) && ~(al4_latched_wr_1000 && ~ric12_partaddr_fromcpu));
assign RIC12_A4_OUT = ~(~(ric12_ac_4 && ~ric12_partaddr_internal) && ~(al5_latched_wr_1000 && ~ric12_partaddr_fromcpu));
assign RIC12_A5_OUT = ~(~(ric12_ac_5 && ~ric12_partaddr_internal) && ~(al6_latched_wr_1000 && ~ric12_partaddr_fromcpu));
assign RIC12_A6_OUT = ~(~(ric12_ac_6 && ~ric12_partaddr_internal) && ~(al7_latched_wr_1000 && ~ric12_partaddr_fromcpu));
// 0-15 select voice
assign RIC12_A7_OUT = ~((ric12_ac_7 && ~ric12_rd_ctrl) || (al8_latched_wr_1000 && RIC12_OE_OUT));
assign RIC12_A8_OUT = ~((ric12_ac_8 && ~ric12_rd_ctrl) || (al9_latched_wr_1000 && RIC12_OE_OUT));
assign RIC12_A9_OUT = ~((ric12_ac_9 && ~ric12_rd_ctrl) || (al10_latched_wr_1000 && RIC12_OE_OUT));
assign RIC12_A10_OUT = ~((ric12_ac_10 && ~ric12_rd_ctrl) || (al11_latched_wr_1000 && RIC12_OE_OUT));


// Outputs the data to write from the latch at the right time
assign RIC12_D0_OUT = ~((p30_latched_wr_1000 && ~ric12_ac_0) || (p30_latched_wr_1001 && ric12_ac_0));
assign RIC12_D1_OUT = ~((p31_latched_wr_1000 && ~ric12_ac_0) || (p31_latched_wr_1001 && ric12_ac_0));
assign RIC12_D2_OUT = ~((p32_latched_wr_1000 && ~ric12_ac_0) || (p32_latched_wr_1001 && ric12_ac_0));
assign RIC12_D3_OUT = ~((p33_latched_wr_1000 && ~ric12_ac_0) || (p33_latched_wr_1001 && ric12_ac_0));
assign RIC12_D4_OUT = ~((p34_latched_wr_1000 && ~ric12_ac_0) || (p34_latched_wr_1001 && ric12_ac_0));
assign RIC12_D5_OUT = ~((p35_latched_wr_1000 && ~ric12_ac_0) || (p35_latched_wr_1001 && ric12_ac_0));
assign RIC12_D6_OUT = ~((p36_latched_wr_1000 && ~ric12_ac_0) || (p36_latched_wr_1001 && ric12_ac_0));
assign RIC12_D7_OUT = ~((p37_latched_wr_1000 && ~ric12_ac_0) || (p37_latched_wr_1001 && ric12_ac_0));



// =============================================================================
// Generates P1 (unused) by counting up to 4 with the cpu E clock
cell_C45 C13 ( // 4-bit Binary Synchronous Up Counter
  VCC, // INPUT DA
  VCC, // INPUT EN
  VCC, // INPUT CI
  RESET_IN, // INPUT CL
  VCC, // INPUT DB
  VCC, // INPUT L
  E_IN, // INPUT CK
  VCC, // INPUT DC
  VCC, // INPUT DD
  unconnected_C13_QA, // OUTPUT QA
  unconnected_C13_QB, // OUTPUT QB
  unconnected_C13_CO, // OUTPUT CO
  p1_toverflow_inv, // OUTPUT QC
  unconnected_C13_QD // OUTPUT QD
);
assign P1_TOVERFLOW = ~p1_toverflow_inv;



// =============================================================================
// Controls the output to IC8 (pins 2-8)
// On cycle 7, latch the value from RIC13 and RIC12


cell_FDN O16 ( // DFF with Set
  cycle_7, // INPUT CK
  ric12_ac0_stage, // INPUT D
  cycle_0, // INPUT S
  ric12_ac0_stage_cycle7, // OUTPUT Q
  ric12_ac0_stage_cycle7_x // OUTPUT XQ
);
cell_FDO O39 ( // DFF with Reset
  cycle_9, // INPUT CK
  ric12_ac0_stage, // INPUT D
  cycle_1, // INPUT R
  ric12_ac0_stage_cycle9, // OUTPUT Q
  ric12_ac0_stage_cycle9_x // OUTPUT XQ
);

assign tmp1 = ~ric12_ac0_stage_cycle7 && ~ric12_ac0_stage_cycle9;
assign tmp2 = ric12_ac0_stage_cycle7 || ric12_ac0_stage_cycle9;

// Cycle 7 delayed: latch data from IC13 lower nibble
assign reaching_cycle_7 = cycle_7 ^ VCC ^ VCC;
cell_LT4 O95 ( // 4-bit Data Latch
  reaching_cycle_7, // INPUT G
  RIC13_D3_IN, // INPUT DA
  RIC13_D2_IN, // INPUT DB
  RIC13_D1_IN, // INPUT DC
  RIC13_D0_IN, // INPUT DD
  unconnected_O95_NA, // OUTPUT NA
  ric13_d3_cycle7_2, // OUTPUT PA
  unconnected_O95_NB, // OUTPUT NB
  ric13_d2_cycle7_2, // OUTPUT PB
  unconnected_O95_NC, // OUTPUT NC
  ric13_d1_cycle7_2, // OUTPUT PC
  unconnected_O95_ND, // OUTPUT ND
  ric13_d0_cycle7_2 // OUTPUT PD
);

assign leaving_cycle_7 = ~(~cycle_7 ^ VCC);
cell_FDQ A98 ( // 4-bit DFF
  leaving_cycle_7, // INPUT CK
  RIC12_D7_IN, // INPUT DA
  RIC12_D6_IN, // INPUT DB
  RIC12_D5_IN, // INPUT DC
  RIC12_D4_IN, // INPUT DD
  ric12_d7_cycle7_3, // OUTPUT QA
  ric12_d6_cycle7_3, // OUTPUT QB
  ric12_d5_cycle7_3, // OUTPUT QC
  ric12_d4_cycle7_3 // OUTPUT QD
);
cell_FDQ B100 ( // 4-bit DFF
  leaving_cycle_7, // INPUT CK
  RIC12_D3_IN, // INPUT DA
  RIC12_D2_IN, // INPUT DB
  RIC12_D1_IN, // INPUT DC
  RIC12_D0_IN, // INPUT DD
  ric12_d3_cycle7_3, // OUTPUT QA
  ric12_d2_cycle7_3, // OUTPUT QB
  ric12_d1_cycle7_3, // OUTPUT QC
  ric12_d0_cycle7_3 // OUTPUT QD
);

// leaving cycle 7
cell_FDM K87 ( // DFF
  cycle_7, // INPUT CK
  ric12_d0_cycle6, // INPUT D
  ric12_d0_cycle6_7_x, // OUTPUT XQ
  ric12_d0_cycle6_7 // OUTPUT Q
);

assign adder1_a20 = ~(~ric12_d0_cycle6_7_x || ~((ric13_d4_cycle6 && tmp1) || (adder1_o20_or_prev && tmp2)));
assign adder1_a21 = ~(~ric12_d0_cycle6_7_x || ~((ric13_d5_cycle6 && tmp1) || (adder1_o21_or_prev && tmp2)));
assign adder1_a22 = ~(~ric12_d0_cycle6_7_x || ~((ric13_d6_cycle6 && tmp1) || (adder1_o22_or_prev && tmp2)));
assign adder1_a23 = ~(~ric12_d0_cycle6_7_x || ~((ric13_d7_cycle6 && tmp1) || (adder1_o23_or_prev && tmp2)));
assign adder1_a24 = ~(~ric12_d0_cycle6_7_x || ~((ric13_d0_cycle7_2 && tmp1) || (adder1_o24_or_prev && tmp2)));
assign adder1_a25 = ~(ric12_d0_cycle6_7_x && ~((ric13_d1_cycle7_2 && tmp1) || (adder1_o25_or_prev && tmp2)));
assign adder1_a26 = ~(~ric12_d0_cycle6_7_x || ~((ric13_d2_cycle7_2 && tmp1) || (adder1_o26_or_prev && tmp2)));
assign adder1_a27 = ~(~ric12_d0_cycle6_7_x || ~((ric13_d3_cycle7_2 && tmp1) || (adder1_o27_or_prev && tmp2)));

// 8-bit adder 3, used for output to IC8
cell_A4H C71 ( // 4-bit Full Adder
  adder1_a23, // INPUT A4
  ric12_d3_cycle7_3, // INPUT B4
  adder1_a22, // INPUT A3
  ric12_d2_cycle7_3, // INPUT B3
  adder1_a21, // INPUT A2
  ric12_d1_cycle7_3, // INPUT B2
  adder1_a20, // INPUT A1
  ric12_d0_cycle7_3, // INPUT B1
  VCC, // INPUT CI
  path141, // OUTPUT CO
  adder3_o3, // OUTPUT S4
  adder3_o2, // OUTPUT S3
  adder3_o1, // OUTPUT S2
  adder3_o0 // OUTPUT S1
);
cell_A4H E61 ( // 4-bit Full Adder
  adder1_a27, // INPUT A4
  ric12_d7_cycle7_3, // INPUT B4
  adder1_a26, // INPUT A3
  ric12_d6_cycle7_3, // INPUT B3
  adder1_a25, // INPUT A2
  ric12_d5_cycle7_3, // INPUT B2
  adder1_a24, // INPUT A1
  ric12_d4_cycle7_3, // INPUT B1
  path141, // INPUT CI
  adder3_of, // OUTPUT CO
  adder3_o7, // OUTPUT S4
  adder3_o6, // OUTPUT S3
  adder3_o5, // OUTPUT S2
  adder3_o4 // OUTPUT S1
);

assign path257_io3_out_unsync = ~((adder3_o1 && ric12_ac_0) || (~(~ric12_d0_cycle6_7_x || ~((ric13_d6_cycle5 && tmp1) || (adder1_o14_or_prev && tmp2))) && ~ric12_ac_0));
assign path256_io4_out_unsync = ~((~adder3_o2 && ric12_ac_0) || ((~ric12_d0_cycle6_7_x || ~((ric13_d7_cycle5 && tmp1) || (adder1_o15_or_prev && tmp2))) && ~ric12_ac_0));
assign path255_io5_out_unsync = ~((adder3_o3 && ric12_ac_0) || (~(~ric12_d0_cycle6_7_x || ~((ric13_d0_cycle6 && tmp1) || (adder1_o16_or_prev && tmp2))) && ~ric12_ac_0));
assign path270_io6_out_unsync = ~((~(adder3_of && adder3_o4) && ric12_ac_0) || ((~ric12_d0_cycle6_7_x || ~((ric13_d1_cycle6 && tmp1) || (adder1_o17_or_prev && tmp2))) && ~ric12_ac_0));
assign path269_io8_out_unsync = ~((adder3_of && adder3_o5 && ric12_ac_0) || (~(~ric12_d0_cycle6_7_x || ~((ric13_d2_cycle6 && tmp1) || (adder1_o18_or_prev && tmp2))) && ~ric12_ac_0));
assign path268_io7_out_unsync = ~((adder3_of && adder3_o6 && ric12_ac_0) || (~(~ric12_d0_cycle6_7_x || ~((ric13_d3_cycle6 && tmp1) || (adder1_o18_or_prev && tmp2))) && ~ric12_ac_0));
assign path267_io2_out_unsync = ~((~(adder3_of && adder3_o7) && ric12_ac_0) || (~adder3_o0 && ~ric12_ac_0));

// Outputs IO 2-7 every sync
cell_LT4 A20 ( // 4-bit Data Latch
  SYNC_IN, // INPUT G
  path267_io2_out_unsync, // INPUT DA
  path268_io7_out_unsync, // INPUT DB
  path269_io8_out_unsync, // INPUT DC
  path270_io6_out_unsync, // INPUT DD
  unconnected_A20_NA, // OUTPUT NA
  IO2_OUT, // OUTPUT PA
  unconnected_A20_NB, // OUTPUT NB
  IO7_OUT, // OUTPUT PB
  unconnected_A20_NC, // OUTPUT NC
  IO8_OUT, // OUTPUT PC
  unconnected_A20_ND, // OUTPUT ND
  IO6_OUT // OUTPUT PD
);
cell_LT4 A4 ( // 4-bit Data Latch
  SYNC_IN, // INPUT G
  path255_io5_out_unsync, // INPUT DA
  path256_io4_out_unsync, // INPUT DB
  path257_io3_out_unsync, // INPUT DC
  GND, // INPUT DD
  unconnected_A4_NA, // OUTPUT NA
  IO5_OUT, // OUTPUT PA
  unconnected_A4_NB, // OUTPUT NB
  IO4_OUT, // OUTPUT PB
  unconnected_A4_NC, // OUTPUT NC
  IO3_OUT, // OUTPUT PC
  unconnected_A4_ND, // OUTPUT ND
  unconnected_A4_PD // OUTPUT PD
);



// =============================================================================
// Controls the output to RIC13

// Counter 12
cell_LT4 V78 ( // 4-bit Data Latch
  cycle_7, // INPUT G
  adder1_o7_or, // INPUT DA
  adder1_o6_or, // INPUT DB
  adder1_o5_or, // INPUT DC
  adder1_o4_or, // INPUT DD
  unconnected_V78_NA, // OUTPUT NA
  ric13_d7_out_0, // OUTPUT PA
  unconnected_V78_NB, // OUTPUT NB
  ric13_d6_out_0, // OUTPUT PB
  unconnected_V78_NC, // OUTPUT NC
  ric13_d5_out_0, // OUTPUT PC
  unconnected_V78_ND, // OUTPUT ND
  ric13_d4_out_0 // OUTPUT PD
);
cell_LT4 Q107 ( // 4-bit Data Latch
  cycle_7, // INPUT G
  adder1_o3_or, // INPUT DA
  adder1_o2_or, // INPUT DB
  adder1_o1_or, // INPUT DC
  adder1_o0_or, // INPUT DD
  unconnected_Q107_NA, // OUTPUT NA
  ric13_d3_out_0, // OUTPUT PA
  unconnected_Q107_NB, // OUTPUT NB
  ric13_d2_out_0, // OUTPUT PB
  unconnected_Q107_NC, // OUTPUT NC
  ric13_d1_out_0, // OUTPUT PC
  unconnected_Q107_ND, // OUTPUT ND
  ric13_d0_out_0 // OUTPUT PD
);

// Counter 13
cell_LT4 N61 ( // 4-bit Data Latch
  cycle_7, // INPUT G
  adder1_o23_or, // INPUT DA
  adder1_o22_or, // INPUT DB
  adder1_o21_or, // INPUT DC
  adder1_o20_or, // INPUT DD
  unconnected_N61_NA, // OUTPUT NA
  ric13_d7_out_2, // OUTPUT PA
  unconnected_N61_NB, // OUTPUT NB
  ric13_d6_out_2, // OUTPUT PB
  unconnected_N61_NC, // OUTPUT NC
  ric13_d5_out_2, // OUTPUT PC
  unconnected_N61_ND, // OUTPUT ND
  ric13_d4_out_2 // OUTPUT PD
);
cell_LT4 N77 ( // 4-bit Data Latch
  cycle_7, // INPUT G
  adder1_o19_or, // INPUT DA
  adder1_o18_or, // INPUT DB
  adder1_o17_or, // INPUT DC
  adder1_o16_or, // INPUT DD
  unconnected_N77_NA, // OUTPUT NA
  ric13_d3_out_2, // OUTPUT PA
  unconnected_N77_NB, // OUTPUT NB
  ric13_d2_out_2, // OUTPUT PB
  unconnected_N77_NC, // OUTPUT NC
  ric13_d1_out_2, // OUTPUT PC
  unconnected_N77_ND, // OUTPUT ND
  ric13_d0_out_2 // OUTPUT PD
);

// Counter 14
cell_LT4 R61 ( // 4-bit Data Latch
  cycle_7, // INPUT G
  adder1_o15_or, // INPUT DA
  adder1_o14_or, // INPUT DB
  adder1_o13_or, // INPUT DC
  adder1_o12_or, // INPUT DD
  unconnected_R61_NA, // OUTPUT NA
  ric13_d7_out_1, // OUTPUT PA
  unconnected_R61_NB, // OUTPUT NB
  ric13_d6_out_1, // OUTPUT PB
  unconnected_R61_NC, // OUTPUT NC
  ric13_d5_out_1, // OUTPUT PC
  unconnected_R61_ND, // OUTPUT ND
  ric13_d4_out_1 // OUTPUT PD
);
cell_LT4 P92 ( // 4-bit Data Latch
  cycle_7, // INPUT G
  adder1_o11_or, // INPUT DA
  adder1_o10_or, // INPUT DB
  adder1_o9_or, // INPUT DC
  adder1_o8_or, // INPUT DD
  unconnected_P92_NA, // OUTPUT NA
  ric13_d3_out_1, // OUTPUT PA
  unconnected_P92_NB, // OUTPUT NB
  ric13_d2_out_1, // OUTPUT PB
  unconnected_P92_NC, // OUTPUT NC
  ric13_d1_out_1, // OUTPUT PC
  unconnected_P92_ND, // OUTPUT ND
  ric13_d0_out_1 // OUTPUT PD
);

// Counter 15
cell_LT4 N93 ( // 4-bit Data Latch
  cycle_7, // INPUT G
  adder1_o27_or, // INPUT DA
  adder1_o26_or, // INPUT DB
  adder1_o25_or, // INPUT DC
  adder1_o24_or, // INPUT DD
  unconnected_N93_NA, // OUTPUT NA
  ric13_d3_out_3, // OUTPUT PA
  unconnected_N93_NB, // OUTPUT NB
  ric13_d2_out_3, // OUTPUT PB
  unconnected_N93_NC, // OUTPUT NC
  ric13_d1_out_3, // OUTPUT PC
  unconnected_N93_ND, // OUTPUT ND
  ric13_d0_out_3 // OUTPUT PD
);

// Selects what to output in RIC13
cell_DE2 N115 ( // 2:4 Decoder
  ric12_ac_1, // INPUT A
  ric12_ac_0, // INPUT B
  g461_ric13_d_12, // OUTPUT X0
  g455_ric13_d_14, // OUTPUT X1
  g448_ric13_d_13, // OUTPUT X2
  g444_ric13_d_15 // OUTPUT X3
);

assign RIC13_D0_OUT = ~((ric13_d0_out_0 || g461_ric13_d_12) && (ric13_d0_out_1 || g455_ric13_d_14) && (ric13_d0_out_2 || g448_ric13_d_13) && (ric13_d0_out_3 || g444_ric13_d_15));
assign RIC13_D1_OUT = ~((ric13_d1_out_0 || g461_ric13_d_12) && (ric13_d1_out_1 || g455_ric13_d_14) && (ric13_d1_out_2 || g448_ric13_d_13) && (ric13_d1_out_3 || g444_ric13_d_15));
assign RIC13_D2_OUT = ~((ric13_d2_out_0 || g461_ric13_d_12) && (ric13_d2_out_1 || g455_ric13_d_14) && (ric13_d2_out_2 || g448_ric13_d_13) && (ric13_d2_out_3 || g444_ric13_d_15));
assign RIC13_D3_OUT = ~((ric13_d3_out_0 || g461_ric13_d_12) && (ric13_d3_out_1 || g455_ric13_d_14) && (ric13_d3_out_2 || g448_ric13_d_13) && (ric13_d3_out_3 || g444_ric13_d_15));
assign RIC13_D4_OUT = ~((ric13_d4_out_0 || g461_ric13_d_12) && (ric13_d4_out_1 || g455_ric13_d_14) && (ric13_d4_out_2 || g448_ric13_d_13) && (VCC || g444_ric13_d_15));
assign RIC13_D5_OUT = ~((ric13_d5_out_0 || g461_ric13_d_12) && (ric13_d5_out_1 || g455_ric13_d_14) && (ric13_d5_out_2 || g448_ric13_d_13) && (VCC || g444_ric13_d_15));
assign RIC13_D6_OUT = ~((ric13_d6_out_0 || g461_ric13_d_12) && (ric13_d6_out_1 || g455_ric13_d_14) && (ric13_d6_out_2 || g448_ric13_d_13) && (VCC || g444_ric13_d_15));
assign RIC13_D7_OUT = ~((ric13_d7_out_0 || g461_ric13_d_12) && (ric13_d7_out_1 || g455_ric13_d_14) && (ric13_d7_out_2 || g448_ric13_d_13) && (VCC || g444_ric13_d_15));

// Output on counter 12/13/14/15
assign RIC13_D_IOM = UNK_74_IN && ~(ric12_ac0_stage && ric12_ac_2);



// =============================================================================
// Read IC12 from CPU
// When an IRQ fires (?) the current voice+part index is stored, and it can be read by the CPU

// Latches the b13/d13 counter value on cycle 8 to be outputed to the CPU data bus
cell_LT4 K20 ( // 4-bit Data Latch
  cycle_8, // INPUT G
  ric12_ac_7, // INPUT DA
  ric12_ac_8, // INPUT DB
  ric12_ac_9, // INPUT DC
  ric12_ac_10, // INPUT DD
  unconnected_K20_NA, // OUTPUT NA
  path499_ric12_a7_latch, // OUTPUT PA
  unconnected_K20_NB, // OUTPUT NB
  path498_ric12_a8_latch, // OUTPUT PB
  unconnected_K20_NC, // OUTPUT NC
  path497_ric12_a9_latch, // OUTPUT PC
  unconnected_K20_ND, // OUTPUT ND
  g496_ric12_a10_latch // OUTPUT PD
);
cell_LT4 K3 ( // 4-bit Data Latch
  cycle_8, // INPUT G
  ric12_ac_3, // INPUT DA
  ric12_ac_4, // INPUT DB
  ric12_ac_5, // INPUT DC
  ric12_ac_6, // INPUT DD
  unconnected_K3_NA, // OUTPUT NA
  path701_ric12_a3_latch, // OUTPUT PA
  unconnected_K3_NB, // OUTPUT NB
  g703_ric12_a4_latch, // OUTPUT PB
  unconnected_K3_NC, // OUTPUT NC
  path704_ric12_a5_latch, // OUTPUT PC
  unconnected_K3_ND, // OUTPUT ND
  g706_ric12_a6_latch // OUTPUT PD
);

assign g1291 = ~(~UNK_75_IN || path1078);
cell_FDQ V10 ( // 4-bit DFF
  g1291, // INPUT CK
  path499_ric12_a7_latch, // INPUT DA
  path498_ric12_a8_latch, // INPUT DB
  path497_ric12_a9_latch, // INPUT DC
  g496_ric12_a10_latch, // INPUT DD
  P34_OUT, // OUTPUT QA
  P35_OUT, // OUTPUT QB
  P36_OUT, // OUTPUT QC
  P37_OUT // OUTPUT QD
);
cell_FDQ S10 ( // 4-bit DFF
  g1291, // INPUT CK
  path701_ric12_a3_latch, // INPUT DA
  g703_ric12_a4_latch, // INPUT DB
  path704_ric12_a5_latch, // INPUT DC
  g706_ric12_a6_latch, // INPUT DD
  P30_OUT, // OUTPUT QA
  P31_OUT, // OUTPUT QB
  P32_OUT, // OUTPUT QC
  P33_OUT // OUTPUT QD
);

// CPU data bus becomes output on address 0x1000
assign CPU_P3_IOM = ~(~(P47_IN || P46_IN) && P45_IN && P44_IN && RW_IN && ~(E_IN ^ E_NOR_77_IN)) && UNK_74_IN;



// =============================================================================
// TODO

// Cycle 4: latch data from IC12/13
assign cycle_4_xor = cycle_4 ^ VCC ^ VCC;
cell_LT4 B74 ( // 4-bit Data Latch
  cycle_4_xor, // INPUT G
  RIC12_D3_IN, // INPUT DA
  RIC12_D2_IN, // INPUT DB
  RIC12_D1_IN, // INPUT DC
  RIC12_D0_IN, // INPUT DD
  unconnected_B74_NA, // OUTPUT NA
  ric12_d3_cycle4, // OUTPUT PA
  unconnected_B74_NB, // OUTPUT NB
  ric12_d2_cycle4, // OUTPUT PB
  unconnected_B74_NC, // OUTPUT NC
  ric12_d1_cycle4, // OUTPUT PC
  unconnected_B74_ND, // OUTPUT ND
  ric12_d0_cycle4 // OUTPUT PD
);
cell_LT4 B87 ( // 4-bit Data Latch
  cycle_4_xor, // INPUT G
  RIC12_D7_IN, // INPUT DA
  RIC12_D6_IN, // INPUT DB
  RIC12_D5_IN, // INPUT DC
  RIC12_D4_IN, // INPUT DD
  unconnected_B87_NA, // OUTPUT NA
  ric12_d7_cycle4, // OUTPUT PA
  unconnected_B87_NB, // OUTPUT NB
  ric12_d6_cycle4, // OUTPUT PB
  unconnected_B87_NC, // OUTPUT NC
  ric12_d5_cycle4, // OUTPUT PC
  unconnected_B87_ND, // OUTPUT ND
  ric12_d4_cycle4 // OUTPUT PD
);
cell_LT4 O61 ( // 4-bit Data Latch
  cycle_4_xor, // INPUT G
  RIC13_D3_IN, // INPUT DA
  RIC13_D2_IN, // INPUT DB
  RIC13_D1_IN, // INPUT DC
  RIC13_D0_IN, // INPUT DD
  unconnected_O61_NA, // OUTPUT NA
  ric13_d3_cycle4, // OUTPUT PA
  unconnected_O61_NB, // OUTPUT NB
  ric13_d2_cycle4, // OUTPUT PB
  unconnected_O61_NC, // OUTPUT NC
  ric13_d1_cycle4, // OUTPUT PC
  unconnected_O61_ND, // OUTPUT ND
  ric13_d0_cycle4 // OUTPUT PD
);
cell_LT4 S106 ( // 4-bit Data Latch
  cycle_4_xor, // INPUT G
  RIC13_D7_IN, // INPUT DA
  RIC13_D6_IN, // INPUT DB
  RIC13_D5_IN, // INPUT DC
  RIC13_D4_IN, // INPUT DD
  unconnected_S106_NA, // OUTPUT NA
  ric13_d7_cycle4, // OUTPUT PA
  unconnected_S106_NB, // OUTPUT NB
  ric13_d6_cycle4, // OUTPUT PB
  unconnected_S106_NC, // OUTPUT NC
  ric13_d5_cycle4, // OUTPUT PC
  unconnected_S106_ND, // OUTPUT ND
  ric13_d4_cycle4 // OUTPUT PD
);

// Latches IC12/13 data in on cycle 5
assign cycle_5_delayed = cycle_5 ^ VCC ^ VCC;
cell_LT4 O75 ( // 4-bit Data Latch
  cycle_5_delayed, // INPUT G
  RIC13_D3_IN, // INPUT DA
  RIC13_D2_IN, // INPUT DB
  RIC13_D1_IN, // INPUT DC
  RIC13_D0_IN, // INPUT DD
  unconnected_O75_NA, // OUTPUT NA
  ric13_d3_cycle5, // OUTPUT PA
  unconnected_O75_NB, // OUTPUT NB
  ric13_d2_cycle5, // OUTPUT PB
  unconnected_O75_NC, // OUTPUT NC
  ric13_d1_cycle5, // OUTPUT PC
  unconnected_O75_ND, // OUTPUT ND
  ric13_d0_cycle5 // OUTPUT PD
);
cell_LT4 R93 ( // 4-bit Data Latch
  cycle_5_delayed, // INPUT G
  RIC13_D7_IN, // INPUT DA
  RIC13_D6_IN, // INPUT DB
  RIC13_D5_IN, // INPUT DC
  RIC13_D4_IN, // INPUT DD
  unconnected_R93_NA, // OUTPUT NA
  ric13_d7_cycle5, // OUTPUT PA
  unconnected_R93_NB, // OUTPUT NB
  ric13_d6_cycle5, // OUTPUT PB
  unconnected_R93_NC, // OUTPUT NC
  ric13_d5_cycle5, // OUTPUT PC
  unconnected_R93_ND, // OUTPUT ND
  ric13_d4_cycle5 // OUTPUT PD
);
cell_LT4 A75 ( // 4-bit Data Latch
  cycle_5_delayed, // INPUT G
  RIC12_D7_IN, // INPUT DA
  RIC12_D6_IN, // INPUT DB
  RIC12_D5_IN, // INPUT DC
  RIC12_D4_IN, // INPUT DD
  unconnected_A75_NA, // OUTPUT NA
  ric12_d7_cycle5, // OUTPUT PA
  unconnected_A75_NB, // OUTPUT NB
  ric12_d6_cycle5, // OUTPUT PB
  unconnected_A75_NC, // OUTPUT NC
  ric12_d5_cycle5, // OUTPUT PC
  unconnected_A75_ND, // OUTPUT ND
  ric12_d4_cycle5 // OUTPUT PD
);
cell_LT4 B61 ( // 4-bit Data Latch
  cycle_5_delayed, // INPUT G
  RIC12_D3_IN, // INPUT DA
  RIC12_D2_IN, // INPUT DB
  RIC12_D1_IN, // INPUT DC
  RIC12_D0_IN, // INPUT DD
  unconnected_B61_NA, // OUTPUT NA
  ric12_d3_cycle5, // OUTPUT PA
  unconnected_B61_NB, // OUTPUT NB
  ric12_d2_cycle5, // OUTPUT PB
  unconnected_B61_NC, // OUTPUT NC
  ric12_d1_cycle5, // OUTPUT PC
  unconnected_B61_ND, // OUTPUT ND
  ric12_d0_cycle5 // OUTPUT PD
);

// Cycle 6
assign cycle_6_delayed = cycle_6 ^ VCC ^ VCC;
cell_LT4 O108 ( // 4-bit Data Latch
  cycle_6_delayed, // INPUT G
  RIC13_D3_IN, // INPUT DA
  RIC13_D2_IN, // INPUT DB
  RIC13_D1_IN, // INPUT DC
  RIC13_D0_IN, // INPUT DD
  unconnected_O108_NA, // OUTPUT NA
  ric13_d3_cycle6, // OUTPUT PA
  unconnected_O108_NB, // OUTPUT NB
  ric13_d2_cycle6, // OUTPUT PB
  unconnected_O108_NC, // OUTPUT NC
  ric13_d1_cycle6, // OUTPUT PC
  unconnected_O108_ND, // OUTPUT ND
  ric13_d0_cycle6 // OUTPUT PD
);
cell_LT4 R107 ( // 4-bit Data Latch
  cycle_6_delayed, // INPUT G
  RIC13_D7_IN, // INPUT DA
  RIC13_D6_IN, // INPUT DB
  RIC13_D5_IN, // INPUT DC
  RIC13_D4_IN, // INPUT DD
  unconnected_R107_NA, // OUTPUT NA
  ric13_d7_cycle6, // OUTPUT PA
  unconnected_R107_NB, // OUTPUT NB
  ric13_d6_cycle6, // OUTPUT PB
  unconnected_R107_NC, // OUTPUT NC
  ric13_d5_cycle6, // OUTPUT PC
  unconnected_R107_ND, // OUTPUT ND
  ric13_d4_cycle6 // OUTPUT PD
);
cell_LT2 A69 ( // 1-bit Data Latch
  cycle_6_delayed, // INPUT G
  RIC12_D0_IN, // INPUT D
  unconnected_A69_Q, // OUTPUT Q
  ric12_d0_cycle6 // OUTPUT XQ
);


cell_FDQ D96 ( // 4-bit DFF
  ~cycle_7, // INPUT CK
  ric12_d7_cycle4, // INPUT DA
  ric12_d6_cycle4, // INPUT DB
  ric12_d5_cycle4, // INPUT DC
  ric12_d4_cycle4, // INPUT DD
  ric12_d7_cycle4_7, // OUTPUT QA
  ric12_d6_cycle4_7, // OUTPUT QB
  ric12_d5_cycle4_7, // OUTPUT QC
  ric12_d4_cycle4_7 // OUTPUT QD
);
cell_FDQ F61 ( // 4-bit DFF
  ~cycle_7, // INPUT CK
  ric12_d3_cycle4, // INPUT DA
  ric12_d2_cycle4, // INPUT DB
  ric12_d1_cycle4, // INPUT DC
  ric12_d0_cycle4, // INPUT DD
  ric12_d3_cycle4_7_not, // OUTPUT QA
  ric12_d2_cycle4_7_not, // OUTPUT QB
  ric12_d1_cycle4_7_not, // OUTPUT QC
  ric12_d0_cycle4_7_not // OUTPUT QD
);
cell_FDQ F94 ( // 4-bit DFF
  ~cycle_7, // INPUT CK
  ric12_d7_cycle5, // INPUT DA
  ric12_d6_cycle5, // INPUT DB
  ric12_d5_cycle5, // INPUT DC
  ric12_d4_cycle5, // INPUT DD
  ric12_d7_cycle5_7_not, // OUTPUT QA
  ric12_d6_cycle5_7_not, // OUTPUT QB
  ric12_d5_cycle5_7_not, // OUTPUT QC
  ric12_d4_cycle5_7_not // OUTPUT QD
);
cell_FDQ D66 ( // 4-bit DFF
  ~cycle_7, // INPUT CK
  ric12_d3_cycle5, // INPUT DA
  ric12_d2_cycle5, // INPUT DB
  ric12_d1_cycle5, // INPUT DC
  ric12_d0_cycle5, // INPUT DD
  ric12_d3_cycle5_7_not, // OUTPUT QA
  ric12_d2_cycle5_7_not, // OUTPUT QB
  ric12_d1_cycle5_7_not, // OUTPUT QC
  ric12_d0_cycle5_7_not // OUTPUT QD
);



// 28-bit adder 1
assign tmp_irq_1 = (ric12_d6_cycle5_7_not || ric12_d5_cycle5_7_not || ric12_d4_cycle5_7_not || ric12_d3_cycle5_7_not) && (ric12_d2_cycle5_7_not || ric12_d1_cycle5_7_not || ric12_d0_cycle5_7_not || GND);
assign adder1_ci = tmp_irq_1 && ric12_d7_cycle5_7_not;

assign adder1_a0 = ~(ric12_d0_cycle6_7 || ~((ric13_d0_cycle4 && tmp1) || (adder1_o0_or_prev && tmp2)));
assign adder1_a1 = ~(ric12_d0_cycle6_7 || ~((ric13_d1_cycle4 && tmp1) || (adder1_o1_or_prev && tmp2)));
assign adder1_a2 = ~(ric12_d0_cycle6_7 || ~((ric13_d2_cycle4 && tmp1) || (adder1_o2_or_prev && tmp2)));
assign adder1_a3 = ~(ric12_d0_cycle6_7 || ~((ric13_d3_cycle4 && tmp1) || (adder1_o3_or_prev && tmp2)));
assign adder1_a4 = ~(ric12_d0_cycle6_7 || ~((ric13_d4_cycle4 && tmp1) || (adder1_o4_or_prev && tmp2)));
assign adder1_a5 = ~(ric12_d0_cycle6_7 || ~((ric13_d5_cycle4 && tmp1) || (adder1_o5_or_prev && tmp2)));
assign adder1_a6 = ~(ric12_d0_cycle6_7 || ~((ric13_d6_cycle4 && tmp1) || (adder1_o6_or_prev && tmp2)));
assign adder1_a7 = ~(ric12_d0_cycle6_7 || ~((ric13_d7_cycle4 && tmp1) || (adder1_o7_or_prev && tmp2)));
assign adder1_a8 = ~(ric12_d0_cycle6_7 || ~((ric13_d0_cycle5 && tmp1) || (adder1_o8_or_prev && tmp2)));
assign adder1_a9 = ~(~ric12_d0_cycle6_7_x || ~((ric13_d1_cycle5 && tmp1) || (adder1_o9_or_prev && tmp2)));
assign adder1_a10 = ~(~ric12_d0_cycle6_7_x || ~((ric13_d2_cycle5 && tmp1) || (adder1_o10_or_prev && tmp2)));
assign adder1_a11 = ~(~ric12_d0_cycle6_7_x || ~((ric13_d3_cycle5 && tmp1) || (adder1_o11_or_prev && tmp2)));
assign adder1_a12 = ~(~ric12_d0_cycle6_7_x || ~((ric13_d4_cycle5 && tmp1) || (adder1_o12_or_prev && tmp2)));
assign adder1_a13 = ~(~ric12_d0_cycle6_7_x || ~((ric13_d5_cycle5 && tmp1) || (adder1_o13_or_prev && tmp2)));
assign adder1_a14 = ~(~ric12_d0_cycle6_7_x || ~((ric13_d6_cycle5 && tmp1) || (adder1_o14_or_prev && tmp2)));
assign adder1_a15 = ~(~ric12_d0_cycle6_7_x || ~((ric13_d7_cycle5 && tmp1) || (adder1_o15_or_prev && tmp2)));
assign adder1_a16 = ~(~ric12_d0_cycle6_7_x || ~((ric13_d0_cycle6 && tmp1) || (adder1_o16_or_prev && tmp2)));
assign adder1_a17 = ~(~ric12_d0_cycle6_7_x || ~((ric13_d1_cycle6 && tmp1) || (adder1_o17_or_prev && tmp2)));
assign adder1_a18 = ~(~ric12_d0_cycle6_7_x || ~((ric13_d2_cycle6 && tmp1) || (adder1_o18_or_prev && tmp2)));
assign adder1_a19 = ~(~ric12_d0_cycle6_7_x || ~((ric13_d3_cycle6 && tmp1) || (adder1_o18_or_prev && tmp2)));

assign tmp_adder_1 = ~(~ric12_d2_cycle5_7_not || ric12_d1_cycle5_7_not) || ric12_d0_cycle5_7_not;
assign tmp_adder_2 = (~ric12_d2_cycle5_7_not && ~ric12_d1_cycle5_7_not && ric12_d0_cycle5_7_not) || ~((~ric12_d2_cycle5_7_not && ric12_d0_cycle5_7_not) || ~ric12_d1_cycle5_7_not);
assign tmp_adder_50 = ~(~ric12_d2_cycle5_7_not && ~ric12_d1_cycle5_7_not) && ~ric12_d0_cycle5_7_not;
assign tmp_adder_52 = (ric12_d2_cycle5_7_not && ~ric12_d1_cycle5_7_not && ~ric12_d0_cycle5_7_not) || ~(~ric12_d1_cycle5_7_not || ~ric12_d0_cycle5_7_not);
assign tmp_adder_70 = ric12_d2_cycle5_7_not && ~(~ric12_d1_cycle5_7_not && ~ric12_d0_cycle5_7_not);

assign tmp_adder_sm_1 = ric12_d6_cycle5_7_not && ric12_d5_cycle5_7_not && ric12_d4_cycle5_7_not && ric12_d3_cycle5_7_not;
assign tmp_adder_sm_2 = ric12_d6_cycle5_7_not && ric12_d5_cycle5_7_not && ric12_d4_cycle5_7_not && ~ric12_d3_cycle5_7_not;
assign tmp_adder_sm_3 = ric12_d6_cycle5_7_not && ric12_d5_cycle5_7_not && ~ric12_d4_cycle5_7_not && ric12_d3_cycle5_7_not;
assign tmp_adder_sm_4 = ric12_d6_cycle5_7_not && ric12_d5_cycle5_7_not && ~ric12_d4_cycle5_7_not && ~ric12_d3_cycle5_7_not;
assign tmp_adder_sm_5 = ric12_d6_cycle5_7_not && ~ric12_d5_cycle5_7_not && ric12_d4_cycle5_7_not && ric12_d3_cycle5_7_not;
assign tmp_adder_sm_6 = ric12_d6_cycle5_7_not && ~ric12_d5_cycle5_7_not && ric12_d4_cycle5_7_not && ~ric12_d3_cycle5_7_not;
assign tmp_adder_sm_7 = ric12_d6_cycle5_7_not && ~ric12_d5_cycle5_7_not && ~ric12_d4_cycle5_7_not && ric12_d3_cycle5_7_not;
assign tmp_adder_sm_8 = ric12_d6_cycle5_7_not && ~ric12_d5_cycle5_7_not && ~ric12_d4_cycle5_7_not && ~ric12_d3_cycle5_7_not;
assign tmp_adder_sm_9 = ~ric12_d6_cycle5_7_not && ric12_d5_cycle5_7_not && ric12_d4_cycle5_7_not && ric12_d3_cycle5_7_not;
assign tmp_adder_sm_10 = ~ric12_d6_cycle5_7_not && ric12_d5_cycle5_7_not && ric12_d4_cycle5_7_not && ~ric12_d3_cycle5_7_not;
assign tmp_adder_sm_11 = ~ric12_d6_cycle5_7_not && ric12_d5_cycle5_7_not && ~ric12_d4_cycle5_7_not && ric12_d3_cycle5_7_not;
assign tmp_adder_sm_12 = ~ric12_d6_cycle5_7_not && ric12_d5_cycle5_7_not && ~ric12_d4_cycle5_7_not && ~ric12_d3_cycle5_7_not;
assign tmp_adder_sm_13 = ~ric12_d6_cycle5_7_not && ~ric12_d5_cycle5_7_not && ric12_d4_cycle5_7_not && ric12_d3_cycle5_7_not;
assign tmp_adder_sm_14 = ~ric12_d6_cycle5_7_not && ~ric12_d5_cycle5_7_not && ric12_d4_cycle5_7_not && ~ric12_d3_cycle5_7_not;
assign tmp_adder_sm_15 = ~ric12_d6_cycle5_7_not && ~ric12_d5_cycle5_7_not && ~ric12_d4_cycle5_7_not && ric12_d3_cycle5_7_not;
assign tmp_adder_sm_16 = ~ric12_d6_cycle5_7_not && ~ric12_d5_cycle5_7_not && ~ric12_d4_cycle5_7_not && ~ric12_d3_cycle5_7_not;

assign tmp_adder_3 = tmp_adder_1 && tmp_adder_sm_1;
assign tmp_adder_4 = tmp_adder_1 && tmp_adder_sm_2;
assign tmp_adder_5 = tmp_adder_1 && tmp_adder_sm_3;
assign tmp_adder_6 = tmp_adder_1 && tmp_adder_sm_4;
assign tmp_adder_7 = tmp_adder_1 && tmp_adder_sm_5;
assign tmp_adder_8 = tmp_adder_1 && tmp_adder_sm_6;
assign tmp_adder_9 = tmp_adder_1 && tmp_adder_sm_7;
assign tmp_adder_10 = tmp_adder_1 && tmp_adder_sm_8;
assign tmp_adder_11 = tmp_adder_1 && tmp_adder_sm_9;
assign tmp_adder_12 = tmp_adder_1 && tmp_adder_sm_10;
assign tmp_adder_13 = tmp_adder_1 && tmp_adder_sm_11;
assign tmp_adder_14 = tmp_adder_1 && tmp_adder_sm_12;
assign tmp_adder_15 = tmp_adder_1 && tmp_adder_sm_13;
assign tmp_adder_16 = tmp_adder_1 && tmp_adder_sm_14;
assign tmp_adder_17 = tmp_adder_1 && tmp_adder_sm_15;
assign tmp_adder_18 = tmp_adder_1 && tmp_adder_sm_16;
assign tmp_adder_19 = tmp_adder_2 && tmp_adder_sm_1;
assign tmp_adder_20 = tmp_adder_2 && tmp_adder_sm_2;
assign tmp_adder_21 = tmp_adder_2 && tmp_adder_sm_3;
assign tmp_adder_22 = tmp_adder_2 && tmp_adder_sm_4;
assign tmp_adder_23 = tmp_adder_2 && tmp_adder_sm_5;
assign tmp_adder_24 = tmp_adder_2 && tmp_adder_sm_6;
assign tmp_adder_25 = tmp_adder_2 && tmp_adder_sm_7;
assign tmp_adder_26 = tmp_adder_2 && tmp_adder_sm_8;
assign tmp_adder_27 = tmp_adder_2 && tmp_adder_sm_9;
assign tmp_adder_28 = tmp_adder_2 && tmp_adder_sm_10;
assign tmp_adder_29 = tmp_adder_2 && tmp_adder_sm_11;
assign tmp_adder_30 = tmp_adder_2 && tmp_adder_sm_12;
assign tmp_adder_31 = tmp_adder_2 && tmp_adder_sm_13;
assign tmp_adder_32 = tmp_adder_2 && tmp_adder_sm_14;
assign tmp_adder_33 = tmp_adder_2 && tmp_adder_sm_15;
assign tmp_adder_34 = tmp_adder_2 && tmp_adder_sm_16;
assign tmp_adder_35 = tmp_adder_50 && tmp_adder_sm_1;
assign tmp_adder_36 = tmp_adder_50 && tmp_adder_sm_2;
assign tmp_adder_37 = tmp_adder_50 && tmp_adder_sm_3;
assign tmp_adder_38 = tmp_adder_50 && tmp_adder_sm_4;
assign tmp_adder_39 = tmp_adder_50 && tmp_adder_sm_5;
assign tmp_adder_40 = tmp_adder_50 && tmp_adder_sm_6;
assign tmp_adder_41 = tmp_adder_50 && tmp_adder_sm_7;
assign tmp_adder_42 = tmp_adder_50 && tmp_adder_sm_8;
assign tmp_adder_43 = tmp_adder_50 && tmp_adder_sm_9;
assign tmp_adder_44 = tmp_adder_50 && tmp_adder_sm_10;
assign tmp_adder_45 = tmp_adder_50 && tmp_adder_sm_11;
assign tmp_adder_46 = tmp_adder_50 && tmp_adder_sm_12;
assign tmp_adder_47 = tmp_adder_50 && tmp_adder_sm_13;
assign tmp_adder_48 = tmp_adder_50 && tmp_adder_sm_14;
assign tmp_adder_49 = tmp_adder_50 && tmp_adder_sm_15;
assign tmp_adder_51 = tmp_adder_50 && tmp_adder_sm_16;
assign tmp_adder_53 = tmp_adder_52 && tmp_adder_sm_1;
assign tmp_adder_54 = tmp_adder_52 && tmp_adder_sm_2;
assign tmp_adder_55 = tmp_adder_52 && tmp_adder_sm_3;
assign tmp_adder_56 = tmp_adder_52 && tmp_adder_sm_4;
assign tmp_adder_57 = tmp_adder_52 && tmp_adder_sm_5;
assign tmp_adder_58 = tmp_adder_52 && tmp_adder_sm_6;
assign tmp_adder_59 = tmp_adder_52 && tmp_adder_sm_7;
assign tmp_adder_60 = tmp_adder_52 && tmp_adder_sm_8;
assign tmp_adder_61 = tmp_adder_52 && tmp_adder_sm_9;
assign tmp_adder_62 = tmp_adder_52 && tmp_adder_sm_10;
assign tmp_adder_63 = tmp_adder_52 && tmp_adder_sm_11;
assign tmp_adder_64 = tmp_adder_52 && tmp_adder_sm_12;
assign tmp_adder_65 = tmp_adder_52 && tmp_adder_sm_13;
assign tmp_adder_66 = tmp_adder_52 && tmp_adder_sm_14;
assign tmp_adder_67 = tmp_adder_52 && tmp_adder_sm_15;
assign tmp_adder_68 = tmp_adder_52 && tmp_adder_sm_16;
assign tmp_adder_71 = tmp_adder_70 && tmp_adder_sm_1;
assign tmp_adder_72 = tmp_adder_70 && tmp_adder_sm_2;
assign tmp_adder_73 = tmp_adder_70 && tmp_adder_sm_3;
assign tmp_adder_74 = tmp_adder_70 && tmp_adder_sm_4;
assign tmp_adder_75 = tmp_adder_70 && tmp_adder_sm_5;
assign tmp_adder_76 = tmp_adder_70 && tmp_adder_sm_6;
assign tmp_adder_77 = tmp_adder_70 && tmp_adder_sm_7;
assign tmp_adder_78 = tmp_adder_70 && tmp_adder_sm_8;
assign tmp_adder_79 = tmp_adder_70 && tmp_adder_sm_9;
assign tmp_adder_80 = tmp_adder_70 && tmp_adder_sm_10;
assign tmp_adder_81 = tmp_adder_70 && tmp_adder_sm_11;
assign tmp_adder_82 = tmp_adder_70 && tmp_adder_sm_12;
assign tmp_adder_83 = tmp_adder_70 && tmp_adder_sm_13;
assign tmp_adder_84 = tmp_adder_70 && tmp_adder_sm_14;
assign tmp_adder_85 = tmp_adder_70 && tmp_adder_sm_15;
assign tmp_adder_86 = tmp_adder_70 && tmp_adder_sm_16;
assign tmp_adder_90 = VCC && tmp_adder_sm_4;
assign tmp_adder_92 = VCC && tmp_adder_sm_6;
assign tmp_adder_93 = VCC && tmp_adder_sm_7;
assign tmp_adder_97 = VCC && tmp_adder_sm_11;
assign tmp_adder_98 = VCC && tmp_adder_sm_12;
assign tmp_adder_99 = VCC && tmp_adder_sm_13;
assign tmp_adder_102 = VCC && tmp_adder_sm_16;

assign addr_1 = ~(~(AL6_OUT && AL_CT_76_IN) && ~(AL6_IN && ~AL_CT_76_IN));
assign addr_2 = ~(~(AL4_OUT && AL_CT_76_IN) && ~(AL4_IN && ~AL_CT_76_IN));

assign adder1_b0 = ~((tmp_adder_18 && adder1_ci) || (~(tmp_adder_18) && ~adder1_ci));
assign adder1_b1 = ~(((tmp_adder_17 || tmp_adder_34) && adder1_ci) || (~(tmp_adder_17 || tmp_adder_34) && ~adder1_ci));
assign adder1_b2 = ~(((tmp_adder_99 || tmp_adder_16 || tmp_adder_33 || tmp_adder_51) && adder1_ci) || (~(tmp_adder_99 || tmp_adder_16 || tmp_adder_33 || tmp_adder_51) && ~adder1_ci));
assign adder1_b3 = ~(((tmp_adder_15 || tmp_adder_32 || tmp_adder_49 || tmp_adder_68) && adder1_ci) || (~(tmp_adder_15 || tmp_adder_32 || tmp_adder_49 || tmp_adder_68) && ~adder1_ci));
assign adder1_b4 = ~((((GND && tmp_adder_sm_11) || tmp_adder_14 || tmp_adder_31 || tmp_adder_48 || tmp_adder_67 || tmp_adder_86) && adder1_ci) || (~((GND && tmp_adder_sm_11) || tmp_adder_14 || tmp_adder_31 || tmp_adder_48 || tmp_adder_67 || tmp_adder_86) && ~adder1_ci));
assign adder1_b5 = ~((~(~tmp_irq_1 || ~(tmp_adder_13 || tmp_adder_30 || tmp_adder_47 || tmp_adder_66 || tmp_adder_85 || tmp_adder_102)) && adder1_ci) || ((~tmp_irq_1 || ~(tmp_adder_13 || tmp_adder_30 || tmp_adder_47 || tmp_adder_66 || tmp_adder_85 || tmp_adder_102)) && ~adder1_ci));
assign adder1_b6 = ~(((tmp_adder_12 || tmp_adder_29 || tmp_adder_46 || tmp_adder_65 || tmp_adder_84 || (p30_latched_wr_1001 && tmp_adder_sm_15)) && adder1_ci) || (~(tmp_adder_12 || tmp_adder_29 || tmp_adder_46 || tmp_adder_65 || tmp_adder_84 || (p30_latched_wr_1001 && tmp_adder_sm_15)) && ~adder1_ci));
assign adder1_b7 = ~(((tmp_adder_11 || tmp_adder_28 || tmp_adder_45 || tmp_adder_64 || tmp_adder_83 || (VCC && tmp_adder_sm_14)) && adder1_ci) || (~(tmp_adder_11 || tmp_adder_28 || tmp_adder_45 || tmp_adder_64 || tmp_adder_83 || (VCC && tmp_adder_sm_14)) && ~adder1_ci));
assign adder1_b8 = ~(((tmp_adder_10 || tmp_adder_27 || tmp_adder_44 || tmp_adder_63 || tmp_adder_82 || (VCC && tmp_adder_sm_13)) && adder1_ci) || (~(tmp_adder_10 || tmp_adder_27 || tmp_adder_44 || tmp_adder_63 || tmp_adder_82 || (VCC && tmp_adder_sm_13)) && ~adder1_ci));
assign adder1_b9 = ~(((tmp_adder_9 || tmp_adder_26 || tmp_adder_43 || tmp_adder_62 || tmp_adder_81 || tmp_adder_98) && adder1_ci) || (~(tmp_adder_9 || tmp_adder_26 || tmp_adder_43 || tmp_adder_62 || tmp_adder_81 || tmp_adder_98) && ~adder1_ci));
assign adder1_b10 = ~(((tmp_adder_8 || tmp_adder_25 || tmp_adder_42 || tmp_adder_61 || tmp_adder_80 || tmp_adder_97) && adder1_ci) || (~(tmp_adder_8 || tmp_adder_25 || tmp_adder_42 || tmp_adder_61 || tmp_adder_80 || tmp_adder_97) && ~adder1_ci));
assign adder1_b11 = ~(((tmp_adder_7 || tmp_adder_24 || tmp_adder_41 || tmp_adder_60 || tmp_adder_79 || (VCC && tmp_adder_sm_10)) && adder1_ci) || (~(tmp_adder_7 || tmp_adder_24 || tmp_adder_41 || tmp_adder_60 || tmp_adder_79 || (VCC && tmp_adder_sm_10)) && ~adder1_ci));
assign adder1_b12 = ~(((tmp_adder_6 || tmp_adder_23 || tmp_adder_40 || tmp_adder_59 || tmp_adder_78 || (addr_1 && tmp_adder_sm_9)) && adder1_ci) || (~(tmp_adder_6 || tmp_adder_23 || tmp_adder_40 || tmp_adder_59 || tmp_adder_78 || (addr_1 && tmp_adder_sm_9)) && ~adder1_ci));
assign adder1_b13 = ~(((tmp_adder_5 || tmp_adder_22 || tmp_adder_39 || tmp_adder_58 || tmp_adder_77 || (addr_2 && tmp_adder_sm_8)) && adder1_ci) || (~(tmp_adder_5 || tmp_adder_22 || tmp_adder_39 || tmp_adder_58 || tmp_adder_77 || (addr_2 && tmp_adder_sm_8)) && ~adder1_ci));
assign adder1_b14 = ~(((tmp_adder_4 || tmp_adder_21 || tmp_adder_38 || tmp_adder_57 || tmp_adder_76 || tmp_adder_93) && adder1_ci) || (~(tmp_adder_4 || tmp_adder_21 || tmp_adder_38 || tmp_adder_57 || tmp_adder_76 || tmp_adder_93) && ~adder1_ci));
assign adder1_b15 = ~(((tmp_adder_3 || tmp_adder_20 || tmp_adder_37 || tmp_adder_56 || tmp_adder_75 || tmp_adder_92) && adder1_ci) || (~(tmp_adder_3 || tmp_adder_20 || tmp_adder_37 || tmp_adder_56 || tmp_adder_75 || tmp_adder_92) && ~adder1_ci));
assign adder1_b16 = ~(((tmp_adder_19 || tmp_adder_36 || tmp_adder_55 || tmp_adder_74 || (VCC && tmp_adder_sm_5) || (GND && tmp_adder_sm_6)) && adder1_ci) || (~(tmp_adder_19 || tmp_adder_36 || tmp_adder_55 || tmp_adder_74 || (VCC && tmp_adder_sm_5) || (GND && tmp_adder_sm_6)) && ~adder1_ci));
assign adder1_b17 = ~(((tmp_adder_35 || tmp_adder_54 || tmp_adder_73 || tmp_adder_90) && adder1_ci) || (~(tmp_adder_35 || tmp_adder_54 || tmp_adder_73 || tmp_adder_90) && ~adder1_ci));
assign adder1_b18 = ~(((tmp_adder_53 || tmp_adder_72 || tmp_adder_sm_3) && adder1_ci) || (~(tmp_adder_53 || tmp_adder_72 || tmp_adder_sm_3) && ~adder1_ci));
assign adder1_b19 = ~(((tmp_adder_71 || tmp_adder_sm_2) && adder1_ci) || (~(tmp_adder_71 || tmp_adder_sm_2) && ~adder1_ci));
assign adder1_b20 = ~((tmp_adder_sm_1 && adder1_ci) || (~(tmp_adder_sm_1) && ~adder1_ci));


cell_A4H T69 ( // 4-bit Full Adder
  adder1_a3, // INPUT A4
  adder1_b3, // INPUT B4
  adder1_a2, // INPUT A3
  adder1_b2, // INPUT B3
  adder1_a1, // INPUT A2
  adder1_b1, // INPUT B2
  adder1_a0, // INPUT A1
  adder1_b0, // INPUT B1
  adder1_ci, // INPUT CI
  path636, // OUTPUT CO
  adder1_o3, // OUTPUT S4
  adder1_o2, // OUTPUT S3
  adder1_o1, // OUTPUT S2
  adder1_o0 // OUTPUT S1
);
cell_A4H U69 ( // 4-bit Full Adder
  adder1_a7, // INPUT A4
  adder1_b7, // INPUT B4
  adder1_a6, // INPUT A3
  adder1_b6, // INPUT B3
  adder1_a5, // INPUT A2
  adder1_b5, // INPUT B2
  adder1_a4, // INPUT A1
  adder1_b4, // INPUT B1
  path636, // INPUT CI
  path642, // OUTPUT CO
  adder1_o7, // OUTPUT S4
  adder1_o6, // OUTPUT S3
  adder1_o5, // OUTPUT S2
  adder1_o4 // OUTPUT S1
);
cell_A4H M3 ( // 4-bit Full Adder
  adder1_a11, // INPUT A4
  adder1_b11, // INPUT B4
  adder1_a10, // INPUT A3
  adder1_b10, // INPUT B3
  adder1_a9, // INPUT A2
  adder1_b9, // INPUT B2
  adder1_a8, // INPUT A1
  adder1_b8, // INPUT B1
  path642, // INPUT CI
  path1105_add_m3_co, // OUTPUT CO
  adder1_o11, // OUTPUT S4
  adder1_o10, // OUTPUT S3
  adder1_o9, // OUTPUT S2
  adder1_o8 // OUTPUT S1
);
cell_A4H J6 ( // 4-bit Full Adder
  adder1_a15, // INPUT A4
  adder1_b15, // INPUT B4
  adder1_a14, // INPUT A3
  adder1_b14, // INPUT B3
  adder1_a13, // INPUT A2
  adder1_b13, // INPUT B2
  adder1_a12, // INPUT A1
  adder1_b12, // INPUT B1
  path1105_add_m3_co, // INPUT CI
  path859, // OUTPUT CO
  adder1_o15, // OUTPUT S4
  adder1_o14, // OUTPUT S3
  adder1_o13, // OUTPUT S2
  adder1_o12 // OUTPUT S1
);
cell_A4H H1 ( // 4-bit Full Adder
  adder1_a19, // INPUT A4
  adder1_b19, // INPUT B4
  adder1_a18, // INPUT A3
  adder1_b18, // INPUT B3
  adder1_a17, // INPUT A2
  adder1_b17, // INPUT B2
  adder1_a16, // INPUT A1
  adder1_b16, // INPUT B1
  path859, // INPUT CI
  path1113, // OUTPUT CO
  adder1_o19, // OUTPUT S4
  adder1_o18, // OUTPUT S3
  adder1_o17, // OUTPUT S2
  adder1_o16 // OUTPUT S1
);
cell_A4H J66 ( // 4-bit Full Adder
  adder1_a23, // INPUT A4
  adder1_ci, // INPUT B4
  adder1_a22, // INPUT A3
  adder1_ci, // INPUT B3
  adder1_a21, // INPUT A2
  adder1_ci, // INPUT B2
  adder1_a20, // INPUT A1
  adder1_b20, // INPUT B1
  path1113, // INPUT CI
  path1072, // OUTPUT CO
  adder1_o23, // OUTPUT S4
  adder1_o22, // OUTPUT S3
  adder1_o21, // OUTPUT S2
  adder1_o20 // OUTPUT S1
);
cell_A4H I61 ( // 4-bit Full Adder
  adder1_a27, // INPUT A4
  adder1_ci, // INPUT B4
  adder1_a26, // INPUT A3
  adder1_ci, // INPUT B3
  adder1_a25, // INPUT A2
  adder1_ci, // INPUT B2
  adder1_a24, // INPUT A1
  adder1_ci, // INPUT B1
  path1072, // INPUT CI
  adder1_co, // OUTPUT CO
  adder1_o27, // OUTPUT S4
  adder1_o26, // OUTPUT S3
  adder1_o25, // OUTPUT S2
  adder1_o24 // OUTPUT S1
);



// 8-bit adder 2
assign adder2_b0 = ~ric12_d0_cycle4_7_not;
assign adder2_b1 = ~ric12_d1_cycle4_7_not;
assign adder2_b2 = ~ric12_d2_cycle4_7_not;
assign adder2_b3 = ~ric12_d3_cycle4_7_not;
assign adder2_b4 = ~ric12_d4_cycle4_7;
assign adder2_b5 = ~ric12_d5_cycle4_7;
assign adder2_b6 = ~ric12_d6_cycle4_7;
assign adder2_b7 = ~ric12_d7_cycle4_7;
cell_A4H H69 ( // 4-bit Full Adder
  adder1_o23, // INPUT A4
  adder2_b3, // INPUT B4
  adder1_o22, // INPUT A3
  adder2_b2, // INPUT B3
  adder1_o21, // INPUT A2
  adder2_b1, // INPUT B2
  adder1_o20, // INPUT A1
  adder2_b0, // INPUT B1
  VCC, // INPUT CI
  path1164, // OUTPUT CO
  unconnected_H69_S4, // OUTPUT S4
  unconnected_H69_S3, // OUTPUT S3
  unconnected_H69_S2, // OUTPUT S2
  unconnected_H69_S1 // OUTPUT S1
);
cell_A4H G68 ( // 4-bit Full Adder
  adder1_o27, // INPUT A4
  adder2_b7, // INPUT B4
  adder1_o26, // INPUT A3
  adder2_b6, // INPUT B3
  adder1_o25, // INPUT A2
  adder2_b5, // INPUT B2
  adder1_o24, // INPUT A1
  adder2_b4, // INPUT B1
  path1164, // INPUT CI
  adder2_co, // OUTPUT CO
  unconnected_G68_S4, // OUTPUT S4
  unconnected_G68_S3, // OUTPUT S3
  unconnected_G68_S2, // OUTPUT S2
  unconnected_G68_S1 // OUTPUT S1
);


// Store all the previous adder results
cell_FDM L115 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o22_or, // INPUT D
  adder1_o22_or_prev, // OUTPUT XQ
  unconnected_L115_Q // OUTPUT Q
);
cell_FDM L61 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o20_or, // INPUT D
  adder1_o20_or_prev, // OUTPUT XQ
  unconnected_L61_Q // OUTPUT Q
);
cell_FDM L67 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o16_or, // INPUT D
  adder1_o16_or_prev, // OUTPUT XQ
  unconnected_L67_Q // OUTPUT Q
);
cell_FDM L75 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o17_or, // INPUT D
  adder1_o17_or_prev, // OUTPUT XQ
  unconnected_L75_Q // OUTPUT Q
);
cell_FDM L81 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o18_or, // INPUT D
  adder1_o18_or_prev, // OUTPUT XQ
  unconnected_L81_Q // OUTPUT Q
);
cell_FDM L87 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o19_or, // INPUT D
  adder1_o18_or_prev, // OUTPUT XQ
  unconnected_L87_Q // OUTPUT Q
);
cell_FDM L100 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o21_or, // INPUT D
  adder1_o21_or_prev, // OUTPUT XQ
  unconnected_L100_Q // OUTPUT Q
);
cell_FDM M114 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o26_or, // INPUT D
  adder1_o26_or_prev, // OUTPUT XQ
  unconnected_M114_Q // OUTPUT Q
);
cell_FDM M61 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o14_or, // INPUT D
  adder1_o14_or_prev, // OUTPUT XQ
  unconnected_M61_Q // OUTPUT Q
);
cell_FDM M67 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o15_or, // INPUT D
  adder1_o15_or_prev, // OUTPUT XQ
  unconnected_M67_Q // OUTPUT Q
);
cell_FDM M75 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o23_or, // INPUT D
  adder1_o23_or_prev, // OUTPUT XQ
  unconnected_M75_Q // OUTPUT Q
);
cell_FDM M81 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o24_or, // INPUT D
  adder1_o24_or_prev, // OUTPUT XQ
  unconnected_M81_Q // OUTPUT Q
);
cell_FDM M89 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o25_or, // INPUT D
  adder1_o25_or_prev, // OUTPUT XQ
  unconnected_M89_Q // OUTPUT Q
);
cell_FDM M95 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o27_or, // INPUT D
  adder1_o27_or_prev, // OUTPUT XQ
  unconnected_M95_Q // OUTPUT Q
);
cell_FDM P63 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o9_or, // INPUT D
  adder1_o9_or_prev, // OUTPUT XQ
  unconnected_P63_Q // OUTPUT Q
);
cell_FDM P69 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o10_or, // INPUT D
  adder1_o10_or_prev, // OUTPUT XQ
  unconnected_P69_Q // OUTPUT Q
);
cell_FDM P81 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o11_or, // INPUT D
  adder1_o11_or_prev, // OUTPUT XQ
  unconnected_P81_Q // OUTPUT Q
);
cell_FDM Q63 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o8_or, // INPUT D
  adder1_o8_or_prev, // OUTPUT XQ
  unconnected_Q63_Q // OUTPUT Q
);
cell_FDM Q76 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o2_or, // INPUT D
  adder1_o2_or_prev, // OUTPUT XQ
  unconnected_Q76_Q // OUTPUT Q
);
cell_FDM Q82 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o3_or, // INPUT D
  adder1_o3_or_prev, // OUTPUT XQ
  unconnected_Q82_Q // OUTPUT Q
);
cell_FDM Q93 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o0_or, // INPUT D
  adder1_o0_or_prev, // OUTPUT XQ
  unconnected_Q93_Q // OUTPUT Q
);
cell_FDM Q99 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o1_or, // INPUT D
  adder1_o1_or_prev, // OUTPUT XQ
  unconnected_Q99_Q // OUTPUT Q
);
cell_FDM S61 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o12_or, // INPUT D
  adder1_o12_or_prev, // OUTPUT XQ
  unconnected_S61_Q // OUTPUT Q
);
cell_FDM S67 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o13_or, // INPUT D
  adder1_o13_or_prev, // OUTPUT XQ
  unconnected_S67_Q // OUTPUT Q
);
cell_FDM S73 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o6_or, // INPUT D
  adder1_o6_or_prev, // OUTPUT XQ
  unconnected_S73_Q // OUTPUT Q
);
cell_FDM S85 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o7_or, // INPUT D
  adder1_o7_or_prev, // OUTPUT XQ
  unconnected_S85_Q // OUTPUT Q
);
cell_FDM S99 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o5_or, // INPUT D
  adder1_o5_or_prev, // OUTPUT XQ
  unconnected_S99_Q // OUTPUT Q
);
cell_FDM V99 ( // DFF
  cycle_odd, // INPUT CK
  adder1_o4_or, // INPUT D
  adder1_o4_or_prev, // OUTPUT XQ
  unconnected_V99_Q // OUTPUT Q
);


assign tmp_irq_2 = ~((adder1_co ^ ric12_d7_cycle5_7_not) || (ric12_d7_cycle5_7_not ^ adder2_co));
assign tmp_irq_4 = tmp_irq_1 && ~tmp_irq_2;
assign tmp_irq_3 = UNK_75_IN && tmp_irq_4;

cell_FJD G20 ( // Positive Edge Clocked Power JKFF with CLEAR
  cycle_odd, // INPUT CK
  tmp_irq_4, // INPUT J
  GND, // INPUT K
  ric12_not_writing, // INPUT CL
  path1078, // OUTPUT XQ
  path879 // OUTPUT Q
);
assign IRQ_OUT = ~(tmp_irq_3 && ~(UNK_75_IN && path879));

assign adder1_o20_or = ~((adder1_o20 && ~tmp_irq_3) || (ric12_d0_cycle4_7_not && tmp_irq_3));
assign adder1_o21_or = ~((adder1_o21 && ~tmp_irq_3) || (ric12_d1_cycle4_7_not && tmp_irq_3));
assign adder1_o22_or = ~((adder1_o22 && ~tmp_irq_3) || (ric12_d2_cycle4_7_not && tmp_irq_3));
assign adder1_o23_or = ~((adder1_o23 && ~tmp_irq_3) || (ric12_d3_cycle4_7_not && tmp_irq_3));
assign adder1_o24_or = ~((adder1_o24 && ~tmp_irq_3) || (ric12_d4_cycle4_7 && tmp_irq_3));
assign adder1_o25_or = ~((adder1_o25 && ~tmp_irq_3) || (ric12_d5_cycle4_7 && tmp_irq_3));
assign adder1_o26_or = ~((adder1_o26 && ~tmp_irq_3) || (ric12_d6_cycle4_7 && tmp_irq_3));
assign adder1_o27_or = ~((adder1_o27 && ~tmp_irq_3) || (ric12_d7_cycle4_7 && tmp_irq_3));

assign adder1_o0_or = ~(adder1_o0 && ~tmp_irq_3);
assign adder1_o1_or = ~(adder1_o1 && ~tmp_irq_3);
assign adder1_o2_or = ~(adder1_o2 && ~tmp_irq_3);
assign adder1_o3_or = ~(adder1_o3 && ~tmp_irq_3);
assign adder1_o4_or = ~(adder1_o4 && ~tmp_irq_3);
assign adder1_o5_or = ~(adder1_o5 && ~tmp_irq_3);
assign adder1_o6_or = ~(adder1_o6 && ~tmp_irq_3);
assign adder1_o7_or = ~(adder1_o7 && ~tmp_irq_3);
assign adder1_o8_or = ~(adder1_o8 && ~tmp_irq_3);
assign adder1_o9_or = ~(adder1_o9 && ~tmp_irq_3);
assign adder1_o10_or = ~(adder1_o10 && ~tmp_irq_3);
assign adder1_o11_or = ~(adder1_o11 && ~tmp_irq_3);
assign adder1_o12_or = ~(adder1_o12 && ~tmp_irq_3);
assign adder1_o13_or = ~(adder1_o13 && ~tmp_irq_3);
assign adder1_o14_or = ~(adder1_o14 && ~tmp_irq_3);
assign adder1_o15_or = ~(adder1_o15 && ~tmp_irq_3);
assign adder1_o16_or = ~(adder1_o16 && ~tmp_irq_3);
assign adder1_o17_or = ~(adder1_o17 && ~tmp_irq_3);
assign adder1_o18_or = ~(adder1_o18 && ~tmp_irq_3);
assign adder1_o19_or = ~(adder1_o19 && ~tmp_irq_3);

endmodule
