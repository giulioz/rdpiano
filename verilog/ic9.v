// 13 instances
module cell_unkj ( // Unknown J
  input wire A,
  input wire B,
  input wire C,
  input wire D,
  input wire E,
  input wire F,
  input wire G,
  input wire H,
  input wire I,
  input wire J,
  input wire K,
  input wire L,
  input wire M,
  input wire N,
  input wire O,
  input wire P,
  output wire X
);
endmodule

// 21 instances
module cell_LT4 ( // 4-bit Data Latch
  input wire G,
  input wire DA,
  input wire DB,
  input wire DC,
  input wire DD,
  output wire NA,
  output wire PA,
  output wire NB,
  output wire PB,
  output wire NC,
  output wire PC,
  output wire ND,
  output wire PD
);
endmodule

// 2 instances
module cell_DE3 ( // 3:8 Decoder
  input wire A,
  input wire B,
  input wire C,
  output wire X0,
  output wire X1,
  output wire X2,
  output wire X3,
  output wire X4,
  output wire X5,
  output wire X6,
  output wire X7
);
endmodule

// 15 instances
module cell_FDQ ( // 4-bit DFF
  input wire CK,
  input wire DA,
  input wire DB,
  input wire DC,
  input wire DD,
  output wire QA,
  output wire QB,
  output wire QC,
  output wire QD
);
endmodule

// 2 instances
module cell_R4N ( // 4-input NOR
  input wire A1,
  input wire A2,
  input wire A3,
  input wire A4,
  output wire X
);
endmodule

// 2 instances
module cell_K3B ( // Gated Clock Buffer
  input wire A1,
  input wire A2,
  output wire X
);
endmodule

// 4 instances
module cell_C43 ( // 4-bit Binary Synchronous Up Counter
  input wire DA,
  input wire EN,
  input wire CI,
  input wire CL,
  input wire DB,
  input wire L,
  input wire CK,
  input wire DC,
  input wire DD,
  output wire QA,
  output wire QB,
  output wire CO,
  output wire QC,
  output wire QD
);
endmodule

// 4 instances
module cell_LT2 ( // 1-bit Data Latch
  input wire G,
  input wire D,
  output wire Q,
  output wire XQ
);
endmodule

// 8 instances
module cell_A4H ( // 4-bit Full Adder
  input wire A1,
  input wire A2,
  input wire B1,
  input wire B2,
  input wire C1,
  input wire C2,
  input wire D1,
  input wire D2,
  input wire CI,
  output wire CO,
  output wire S1,
  output wire S2,
  output wire S3,
  output wire S4
);
endmodule

// 2 instances
module cell_N6B ( // Power 6-input NAND
  input wire A1,
  input wire A2,
  input wire A3,
  input wire A4,
  input wire A5,
  input wire A6,
  output wire X
);
endmodule

// 4 instances
module cell_FDM ( // DFF
  input wire CK,
  input wire D,
  output wire XQ,
  output wire Q
);
endmodule

// 2 instances
module cell_FDN ( // DFF with Set
  input wire CK,
  input wire D,
  input wire S,
  output wire Q,
  output wire XQ
);
endmodule

// 2 instances
module cell_FDO ( // DFF with Reset
  input wire CK,
  input wire D,
  input wire R,
  output wire Q,
  output wire XQ
);
endmodule

assign subclock_1 = SYNC_IN || counter_r61_qd;
assign subclock_2 = SYNC_IN || ~counter_r61_qd;

assign clock_ct0_sc1 = counter_dec_0 || subclock_1;
assign clock_ct1_sc1 = counter_dec_1 || subclock_1;
assign clock_ct2_sc1 = counter_dec_2 || subclock_1;
assign clock_ct3_sc1 = counter_dec_3 || subclock_1;
assign clock_ct4_sc1 = counter_dec_4 || subclock_1;
assign clock_ct5_sc1 = counter_dec_5 || subclock_1;
assign clock_ct6_sc1 = counter_dec_6 || subclock_1;
assign clock_ct7_sc1 = counter_dec_7 || subclock_1;

assign clock_ct0_sc2 = counter_dec_0 || subclock_2;
assign clock_ct1_sc2 = counter_dec_1 || subclock_2;
assign clock_ct2_sc2 = counter_dec_2 || subclock_2;
assign clock_ct3_sc2 = counter_dec_3 || subclock_2;
assign clock_ct4_sc2 = counter_dec_4 || subclock_2;
assign clock_ct5_sc2 = counter_dec_5 || subclock_2;
assign clock_ct6_sc2 = counter_dec_6 || subclock_2;
assign clock_ct7_sc2 = counter_dec_7 || subclock_2;

assign clock_not7_sc1 = ~clock_ct7_sc1;
assign clock_not7_sc2 = ~clock_ct7_sc2;


latch (
  ~(bus2_in_latched_b87 ^ ~(VCC ^ clock_ct0_sc)), // INPUT G A107
  BUS0_IN, // INPUT DA A107
  BUS1_IN, // INPUT DB A107
  BUS2_IN, // INPUT DC A107
  BUS3_IN, // INPUT DD A107
  BUS4_IN, // INPUT DA A61
  BUS5_IN, // INPUT DB A61
  BUS6_IN, // INPUT DC A61
  BUS7_IN, // INPUT DD A61
  ROM_A9_OUT, // OUTPUT PA A107
  ROM_A10_OUT, // OUTPUT PB A107
  ROM_A11_OUT, // OUTPUT PC A107
  ROM_A12_OUT, // OUTPUT PD A107
  bus4_in_latched_a61, // OUTPUT PA A61
  bus5_in_latched_a61, // OUTPUT PB A61
  bus6_in_latched_a61, // OUTPUT PC A61
  bus7_in_latched_a61, // OUTPUT PD A61
);

latch (
  // TODO: GND is unconnected?
  ~(GND ^ ~(GND ^ clock_ct1_sc1)), // INPUT G A76
  BUS0_IN, // INPUT DA A94
  BUS1_IN, // INPUT DB A94
  BUS2_IN, // INPUT DC A94
  BUS3_IN, // INPUT DD A94
  BUS4_IN, // INPUT DA A76
  BUS5_IN, // INPUT DB A76
  BUS6_IN, // INPUT DC A76
  BUS7_IN, // INPUT DD A76
  ROM_A1_OUT, // OUTPUT PA A94
  ROM_A2_OUT, // OUTPUT PB A94
  ROM_A3_OUT, // OUTPUT PC A94
  ROM_A4_OUT, // OUTPUT PD A94
  ROM_A5_OUT, // OUTPUT PA A76
  ROM_A6_OUT, // OUTPUT PB A76
  ROM_A7_OUT, // OUTPUT PC A76
  ROM_A8_OUT, // OUTPUT PD A76
);

latch (
  clock_ct7_sc1, // INPUT G M61
  wr_a7_a_dff_m93, // INPUT DA M61
  wr_a8_a_dff_m93, // INPUT DB M61
  wr_a9_a_dff_m93, // INPUT DC M61
  wr_a10_a_dff_m93, // INPUT DD M61
  g56, // INPUT DA Q20
  g854, // INPUT DB Q20
  g467, // INPUT DC Q20
  g753, // INPUT DD Q20
  g751, // INPUT DA Q38
  g195, // INPUT DB Q38
  g856, // INPUT DC Q38
  g970, // INPUT DD Q38
  path640, // INPUT DA G18
  g642, // INPUT DB G18
  g663, // INPUT DC G18
  g336, // INPUT DD G18
  path80, // OUTPUT PA M61
  path79, // OUTPUT PB M61
  path953, // OUTPUT PC M61
  path913, // OUTPUT PD M61
  path54, // OUTPUT PA Q20
  path51, // OUTPUT PB Q20
  path700, // OUTPUT PC Q20
  path701, // OUTPUT PD Q20
  path196, // OUTPUT PA Q38
  path197, // OUTPUT PB Q38
  path198, // OUTPUT PC Q38
  path156, // OUTPUT PD Q38
  path141, // OUTPUT PA G18
  path129, // OUTPUT PB G18
  path742, // OUTPUT PC G18
  path741, // OUTPUT PD G18
);

latch (
  SYNC_IN, // INPUT G Q106
  ipt1_prelatch, // INPUT DA Q106
  ipt2_prelatch, // INPUT DB Q106
  ipt0_prelatch, // INPUT DC Q106
  ipt3_prelatch_unused, // INPUT DD Q106
  IPT1_OUT, // OUTPUT PA Q106
  IPT2_OUT, // OUTPUT PB Q106
  IPT0_OUT, // OUTPUT PC Q106
  unconnected_Q106_PD, // OUTPUT PD Q106
);

latch (
  ~(bus0_in_latched_b87 ^ ~(VCC ^ clock_ct2_sc1)), // INPUT G B61
  BUS0_IN, // INPUT DA B61
  BUS1_IN, // INPUT DB B61
  BUS2_IN, // INPUT DC B61
  BUS3_IN, // INPUT DD B61
  BUS4_IN, // INPUT DA B74
  BUS5_IN, // INPUT DB B74
  BUS6_IN, // INPUT DC B74
  BUS7_IN, // INPUT DD B74
  bus0_in_latched_b61, // OUTPUT NA B61
  bus1_in_latched_b61, // OUTPUT NB B61
  bus2_in_latched_b61, // OUTPUT NC B61
  bus3_in_latched_b61, // OUTPUT ND B61
  bus4_in_latched_b61, // OUTPUT NA B74
  bus5_in_latched_b61, // OUTPUT NB B74
  bus6_in_latched_b61, // OUTPUT NC B74
  bus7_in_latched_b61, // OUTPUT ND B74
);

latch (
  ~(~(clock_ct3_sc1 ^ VCC) ^ VCC), // INPUT G B87
  BUS0_IN, // INPUT DA B87
  BUS1_IN, // INPUT DB B87
  BUS2_IN, // INPUT DC B87
  BUS3_IN, // INPUT DD B87
  bus0_in_latched_b87, // OUTPUT PA B87
  bus1_in_latched_b87, // OUTPUT PB B87
  bus2_in_latched_b87, // OUTPUT PC B87
  bus3_in_latched_b87, // OUTPUT PD B87
);

latch (
  clock_ct3_sc1, // INPUT G D108
  ROM_D0_IN, // INPUT DA E108
  ROM_D1_IN, // INPUT DB E108
  ROM_D2_IN, // INPUT DC E108
  ROM_D3_IN, // INPUT DD E108
  ROM_D4_IN, // INPUT DA D108
  ROM_D5_IN, // INPUT DB D108
  ROM_D6_IN, // INPUT DC D108
  ROM_D7_IN, // INPUT DD D108
  unconnected_E108_NA, // OUTPUT NA E108
  rom_d0_latched_e108, // OUTPUT PA E108
  unconnected_E108_NB, // OUTPUT NB E108
  rom_d1_latched_e108, // OUTPUT PB E108
  unconnected_E108_NC, // OUTPUT NC E108
  rom_d2_latched_e108, // OUTPUT PC E108
  unconnected_E108_ND, // OUTPUT ND E108
  rom_d3_latched_e108, // OUTPUT PD E108
  unconnected_D108_NA, // OUTPUT NA D108
  rom_d4_latched_e108, // OUTPUT PA D108
  rom_d5_latched_e108_inv, // OUTPUT NB D108
  unconnected_D108_PB, // OUTPUT PB D108
  rom_d6_latched_e108_inv, // OUTPUT NC D108
  unconnected_D108_PC, // OUTPUT PC D108
  rom_d7_latched_e108_inv, // OUTPUT ND D108
  unconnected_D108_PD, // OUTPUT PD D108
);

latch (
  clock_ct5_sc1, // INPUT G E90
  ROM_D0_IN, // INPUT DA E90
  ROM_D1_IN, // INPUT DB E90
  ROM_D2_IN, // INPUT DC E90
  ROM_D3_IN, // INPUT DD E90
  rom_d0_latched_e90, // OUTPUT NA E90
  rom_d1_latched_e90, // OUTPUT NB E90
  rom_d2_latched_e90, // OUTPUT NC E90
  rom_d3_latched_e90, // OUTPUT ND E90
);

latch (
  ~(bus0_in_latched_b87 ^ ~(bus2_in_latched_b87 ^ ~(VCC ^ clock_ct0_sc))), // INPUT G F20
  ~RAM_D0_IN, // INPUT DA F20
  RAM_D1_IN, // INPUT DB F20
  RAM_D2_IN, // INPUT DC F20
  ~RAM_D3_IN, // INPUT DD F20
  ~RAM_D4_IN, // INPUT DA H20
  RAM_D5_IN, // INPUT DB H20
  RAM_D6_IN, // INPUT DC H20
  RAM_D7_IN, // INPUT DD H20
  ram_d0_in_latched_f20_inv, // OUTPUT PA F20
  ram_d1_in_latched_f20, // OUTPUT PB F20
  ram_d2_in_latched_f20_inv, // OUTPUT PC F20
  ram_d3_in_latched_f20_inv, // OUTPUT PD F20
  ram_d4_in_latched_f20, // OUTPUT PA H20
  ram_d5_in_latched_f20, // OUTPUT PB H20
  ram_d6_in_latched_f20, // OUTPUT PC H20
  ram_d7_in_latched_f20, // OUTPUT PD H20
);

latch (
  // TODO: check unconnected
  ~(unconnected_F65_A1 ^ ~(unconnected_N96_A1 ^ ~(unconnected_N100_A1 ^ clock_ct1_sc1))), // INPUT G F4
  ~RAM_D0_IN, // INPUT DA F4
  RAM_D1_IN, // INPUT DB F4
  RAM_D2_IN, // INPUT DC F4
  ~RAM_D3_IN, // INPUT DD F4
  ~RAM_D4_IN, // INPUT DA H3
  RAM_D5_IN, // INPUT DB H3
  RAM_D6_IN, // INPUT DC H3
  RAM_D7_IN, // INPUT DD H3
  wr_am1_b_inv, // OUTPUT PA F4
  wr_a0_b, // OUTPUT PB F4
  wr_a1_b, // OUTPUT PC F4
  wr_a2_b_inv, // OUTPUT PD F4
  wr_a3_b_inv, // OUTPUT PA H3
  wr_a4_b, // OUTPUT PB H3
  wr_a5_b, // OUTPUT PC H3
  wr_a6_b, // OUTPUT PD H3
);

latch (
  ~(bus0_in_latched_b87 ^ ~(bus0_in_latched_b87 ^ ~(unconnected_L65_A1 ^ clock_ct2_sc1))), // INPUT G F36
  ~RAM_D0_IN, // INPUT DA F36
  RAM_D1_IN, // INPUT DB F36
  RAM_D2_IN, // INPUT DC F36
  ~RAM_D3_IN, // INPUT DD F36
  ~RAM_D4_IN, // INPUT DA H34
  RAM_D5_IN, // INPUT DB H34
  RAM_D6_IN, // INPUT DC H34
  RAM_D7_IN, // INPUT DD H34
  wr_a7_b_inv, // OUTPUT PA F36
  wr_a8_b, // OUTPUT PB F36
  wr_a9_b, // OUTPUT PC F36
  wr_a10_b_inv, // OUTPUT PD F36
  latch_h34_ram_d4_inv, // OUTPUT PA H34
  latch_h34_ram_d5, // OUTPUT PB H34
  latch_h34_ram_d6, // OUTPUT PC H34
  latch_h34_ram_d7, // OUTPUT PD H34
);

cell_unkj A1 ( // Unknown J
  g794, // INPUT A
  g727, // INPUT B
  g626, // INPUT C
  g829, // INPUT D
  g302, // INPUT E
  g349, // INPUT F
  g848, // INPUT G
  g352, // INPUT H
  g841, // INPUT I
  g734, // INPUT J
  g815, // INPUT K
  g297, // INPUT L
  g296, // INPUT M
  g259, // INPUT N
  g287, // INPUT O
  g322, // INPUT P
  path357, // OUTPUT X
);

cell_unkj A12 ( // Unknown J
  g626, // INPUT A
  g727, // INPUT B
  g302, // INPUT C
  g829, // INPUT D
  g848, // INPUT E
  g349, // INPUT F
  g841, // INPUT G
  g352, // INPUT H
  g815, // INPUT I
  g734, // INPUT J
  g296, // INPUT K
  g297, // INPUT L
  g287, // INPUT M
  g259, // INPUT N
  g66, // INPUT O
  g322, // INPUT P
  path356, // OUTPUT X
);

cell_unkj A23 ( // Unknown J
  g302, // INPUT A
  g727, // INPUT B
  g848, // INPUT C
  g829, // INPUT D
  g841, // INPUT E
  g349, // INPUT F
  g815, // INPUT G
  g352, // INPUT H
  g296, // INPUT I
  g734, // INPUT J
  g287, // INPUT K
  g297, // INPUT L
  g66, // INPUT M
  g259, // INPUT N
  g601, // INPUT O
  g322, // INPUT P
  path378, // OUTPUT X
);

cell_unkj A34 ( // Unknown J
  g848, // INPUT A
  g727, // INPUT B
  g841, // INPUT C
  g829, // INPUT D
  g815, // INPUT E
  g349, // INPUT F
  g296, // INPUT G
  g352, // INPUT H
  g287, // INPUT I
  g734, // INPUT J
  g66, // INPUT K
  g297, // INPUT L
  g601, // INPUT M
  g259, // INPUT N
  g606, // INPUT O
  g322, // INPUT P
  path262, // OUTPUT X
);

cell_unkj A50 ( // Unknown J
  g841, // INPUT A
  g727, // INPUT B
  g815, // INPUT C
  g829, // INPUT D
  g296, // INPUT E
  g349, // INPUT F
  g287, // INPUT G
  g352, // INPUT H
  g66, // INPUT I
  g734, // INPUT J
  g601, // INPUT K
  g297, // INPUT L
  g606, // INPUT M
  g259, // INPUT N
  g864, // INPUT O
  g322, // INPUT P
  path260, // OUTPUT X
);

cell_unkj B1 ( // Unknown J
  unconnected_B1_A, // INPUT A
  g727, // INPUT B
  unconnected_B1_C, // INPUT C
  g829, // INPUT D
  g794, // INPUT E
  g349, // INPUT F
  g626, // INPUT G
  g352, // INPUT H
  g302, // INPUT I
  g734, // INPUT J
  g848, // INPUT K
  g297, // INPUT L
  g841, // INPUT M
  g259, // INPUT N
  g815, // INPUT O
  g322, // INPUT P
  path298, // OUTPUT X
);

cell_unkj B20 ( // Unknown J
  unconnected_B20_A, // INPUT A
  g727, // INPUT B
  g794, // INPUT C
  g829, // INPUT D
  g626, // INPUT E
  g349, // INPUT F
  g302, // INPUT G
  g352, // INPUT H
  g848, // INPUT I
  g734, // INPUT J
  g841, // INPUT K
  g297, // INPUT L
  g815, // INPUT M
  g259, // INPUT N
  g296, // INPUT O
  g322, // INPUT P
  path985, // OUTPUT X
);

cell_unkj C1 ( // Unknown J
  unconnected_C1_A, // INPUT A
  g349, // INPUT B
  g794, // INPUT C
  g352, // INPUT D
  g626, // INPUT E
  g734, // INPUT F
  g302, // INPUT G
  g297, // INPUT H
  g848, // INPUT I
  g259, // INPUT J
  g841, // INPUT K
  g322, // INPUT L
  g815, // INPUT M
  g386, // INPUT N
  g296, // INPUT O
  g252, // INPUT P
  path206, // OUTPUT X
);

cell_unkj C12 ( // Unknown J
  unconnected_C12_A, // INPUT A
  g734, // INPUT B
  g794, // INPUT C
  g297, // INPUT D
  g626, // INPUT E
  g259, // INPUT F
  g302, // INPUT G
  g322, // INPUT H
  g848, // INPUT I
  g386, // INPUT J
  g841, // INPUT K
  g252, // INPUT L
  g815, // INPUT M
  g77, // INPUT N
  g296, // INPUT O
  g75, // INPUT P
  path78, // OUTPUT X
);

cell_unkj C28 ( // Unknown J
  unconnected_C28_A, // INPUT A
  g352, // INPUT B
  g794, // INPUT C
  g734, // INPUT D
  g626, // INPUT E
  g297, // INPUT F
  g302, // INPUT G
  g259, // INPUT H
  g848, // INPUT I
  g322, // INPUT J
  g841, // INPUT K
  g386, // INPUT L
  g815, // INPUT M
  g252, // INPUT N
  g296, // INPUT O
  g77, // INPUT P
  path980, // OUTPUT X
);

cell_unkj C39 ( // Unknown J
  g815, // INPUT A
  g727, // INPUT B
  g296, // INPUT C
  g829, // INPUT D
  g287, // INPUT E
  g349, // INPUT F
  g66, // INPUT G
  g352, // INPUT H
  g601, // INPUT I
  g734, // INPUT J
  g606, // INPUT K
  g297, // INPUT L
  g864, // INPUT M
  g259, // INPUT N
  g866, // INPUT O
  g322, // INPUT P
  path735, // OUTPUT X
);

cell_unkj C50 ( // Unknown J
  g296, // INPUT A
  g727, // INPUT B
  g287, // INPUT C
  g829, // INPUT D
  g66, // INPUT E
  g349, // INPUT F
  g601, // INPUT G
  g352, // INPUT H
  g606, // INPUT I
  g734, // INPUT J
  g864, // INPUT K
  g297, // INPUT L
  g866, // INPUT M
  g259, // INPUT N
  unconnected_C50_O, // INPUT O
  g322, // INPUT P
  path83, // OUTPUT X
);

cell_unkj D22 ( // Unknown J
  unconnected_D22_A, // INPUT A
  g734, // INPUT B
  unconnected_D22_C, // INPUT C
  g297, // INPUT D
  g794, // INPUT E
  g259, // INPUT F
  g626, // INPUT G
  g322, // INPUT H
  g302, // INPUT I
  g386, // INPUT J
  g848, // INPUT K
  g252, // INPUT L
  g841, // INPUT M
  g77, // INPUT N
  g815, // INPUT O
  g75, // INPUT P
  path849, // OUTPUT X
);

cell_DE3 T61 ( // 3:8 Decoder
  counter_r61_qa, // INPUT A
  counter_r61_qb, // INPUT B
  counter_r61_qc, // INPUT C
  counter_dec_0, // OUTPUT X0
  counter_dec_1, // OUTPUT X1
  counter_dec_2, // OUTPUT X2
  counter_dec_3, // OUTPUT X3
  counter_dec_4, // OUTPUT X4
  counter_dec_5, // OUTPUT X5
  counter_dec_6, // OUTPUT X6
  counter_dec_7, // OUTPUT X7
);

cell_DE3 V91 ( // 3:8 Decoder
  WR_A11_OUT, // INPUT A
  WR_A12_OUT, // INPUT B
  WR_A13_OUT, // INPUT C
  wr_a11_13_000, // OUTPUT X0
  wr_a11_13_001, // OUTPUT X1
  wr_a11_13_010, // OUTPUT X2
  wr_a11_13_011, // OUTPUT X3
  wr_a11_13_100, // OUTPUT X4
  unconnected_V91_X5, // OUTPUT X5
  unconnected_V91_X6, // OUTPUT X6
  unconnected_V91_X7, // OUTPUT X7
);

assign dff_ck_wr1 = ~(clock_ct1_sc1 && clock_ct3_sc1 && clock_ct5_sc1 && clock_ct0_sc1 && clock_ct1_sc2 && clock_ct3_sc2 && clock_ct5_sc2 && clock_ct7_sc2);

cell_FDQ M93 ( // 4-bit DFF
  dff_ck_wr1, // INPUT CK
  wr_a10_a_dff_m93, // INPUT DA
  wr_a9_a_dff_m93, // INPUT DB
  wr_a8_a_dff_m93, // INPUT DC
  wr_a7_a_dff_m93, // INPUT DD
  wr_a10_a, // OUTPUT QA
  wr_a9_a, // OUTPUT QB
  wr_a8_a, // OUTPUT QC
  wr_a7_a, // OUTPUT QD
);

cell_FDQ O4 ( // 4-bit DFF
  dff_ck_wr1, // INPUT CK
  path916, // INPUT DA
  path917, // INPUT DB
  path760, // INPUT DC
  path687, // INPUT DD
  g915, // OUTPUT QA
  g558, // OUTPUT QB
  g738, // OUTPUT QC
  g658, // OUTPUT QD
);

cell_FDQ R40 ( // 4-bit DFF
  dff_ck_wr1, // INPUT CK
  g970, // INPUT DA
  g856, // INPUT DB
  path973, // INPUT DC
  g751, // INPUT DD
  wr_a2_a, // OUTPUT QA
  wr_a1_a, // OUTPUT QB
  wr_a0_a, // OUTPUT QC
  path749, // OUTPUT QD
);

cell_FDQ T1 ( // 4-bit DFF
  dff_ck_wr1, // INPUT CK
  g753, // INPUT DA
  g467, // INPUT DB
  g854, // INPUT DC
  g56, // INPUT DD
  wr_a6_a, // OUTPUT QA
  wr_a5_a, // OUTPUT QB
  wr_a4_a, // OUTPUT QC
  wr_a3_a, // OUTPUT QD
);

cell_FDQ T40 ( // 4-bit DFF
  clock_not7_sc2, // INPUT CK
  counter_s66_qa, // INPUT DA
  counter_s66_qb, // INPUT DB
  counter_s66_qc, // INPUT DC
  counter_s66_qd, // INPUT DD
  counter_s66_qa_dff_t40, // OUTPUT QA
  counter_s66_qb_dff_t40, // OUTPUT QB
  counter_s66_qc_dff_t40, // OUTPUT QC
  counter_s66_qd_dff_t40, // OUTPUT QD
);

cell_FDQ B100 ( // 4-bit DFF
  clock_not7_sc1, // INPUT CK
  bus4_in_latched_a61, // INPUT DA
  bus5_in_latched_a61, // INPUT DB
  bus6_in_latched_a61, // INPUT DC
  bus7_in_latched_a61, // INPUT DD
  bus4_in_latched_a61_b100, // OUTPUT QA
  bus5_in_latched_a61_b100, // OUTPUT QB
  bus6_in_latched_a61_b100, // OUTPUT QC
  bus7_in_latched_a61_b100, // OUTPUT QD
);

cell_FDQ V32 ( // 4-bit DFF
  clock_not7_sc2, // INPUT CK
  counter_u73_qa, // INPUT DA
  counter_u73_qb, // INPUT DB
  counter_u73_qc, // INPUT DC
  path536, // INPUT DD
  path527, // OUTPUT QA
  path499, // OUTPUT QB
  path500, // OUTPUT QC
  path452, // OUTPUT QD
);

cell_FDQ V61 ( // 4-bit DFF
  clock_not7_sc1, // INPUT CK
  bus0_in_latched_b87, // INPUT DA
  bus1_in_latched_b87, // INPUT DB
  bus2_in_latched_b87, // INPUT DC
  bus3_in_latched_b87, // INPUT DD
  WR_A11_OUT, // OUTPUT QA
  WR_A12_OUT, // OUTPUT QB
  WR_A13_OUT, // OUTPUT QC
  WR_A14_OUT, // OUTPUT QD
);

cell_FDQ C67 ( // 4-bit DFF
  clock_not7_sc1, // INPUT CK
  bus4_in_latched_b61, // INPUT DA
  bus5_in_latched_b61, // INPUT DB
  bus6_in_latched_b61, // INPUT DC
  bus7_in_latched_b61, // INPUT DD
  path882, // OUTPUT QA
  path390, // OUTPUT QB
  path389, // OUTPUT QC
  path783, // OUTPUT QD
);

cell_FDQ C100 ( // 4-bit DFF
  clock_not7_sc1, // INPUT CK
  bus0_in_latched_b61, // INPUT DA
  bus1_in_latched_b61, // INPUT DB
  bus2_in_latched_b61, // INPUT DC
  bus3_in_latched_b61, // INPUT DD
  path226, // OUTPUT QA
  path225, // OUTPUT QB
  path59, // OUTPUT QC
  path337, // OUTPUT QD
);

cell_FDQ D61 ( // 4-bit DFF
  clock_not7_sc1, // INPUT CK
  rom_d0_latched_e108, // INPUT DA
  rom_d1_latched_e108, // INPUT DB
  rom_d2_latched_e108, // INPUT DC
  rom_d3_latched_e108, // INPUT DD
  g866, // OUTPUT QA
  g864, // OUTPUT QB
  g606, // OUTPUT QC
  g601, // OUTPUT QD
);

cell_FDQ D87 ( // 4-bit DFF
  clock_not7_sc1, // INPUT CK
  rom_d4_latched_e108, // INPUT DA
  rom_d5_latched_e108_inv, // INPUT DB
  rom_d6_latched_e108_inv, // INPUT DC
  rom_d7_latched_e108_inv, // INPUT DD
  g66, // OUTPUT QA
  path802, // OUTPUT QB
  path303, // OUTPUT QC
  path227, // OUTPUT QD
);

cell_FDQ E61 ( // 4-bit DFF
  clock_not7_sc1, // INPUT CK
  rom_d0_latched_e90, // INPUT DA
  rom_d1_latched_e90, // INPUT DB
  rom_d2_latched_e90, // INPUT DC
  rom_d3_latched_e90, // INPUT DD
  path842, // OUTPUT QA
  path618, // OUTPUT QB
  path621, // OUTPUT QC
  path627, // OUTPUT QD
);

cell_FDQ G38 ( // 4-bit DFF
  dff_ck_wr1, // INPUT CK
  g336, // INPUT DA
  g663, // INPUT DB
  g642, // INPUT DC
  path640, // INPUT DD
  path148, // OUTPUT QA
  path962, // OUTPUT QB
  path360, // OUTPUT QC
  path145, // OUTPUT QD
);

cell_FDQ J40 ( // 4-bit DFF
  dff_ck_wr1, // INPUT CK
  path409, // INPUT DA
  path208, // INPUT DB
  path553, // INPUT DC
  path171, // INPUT DD
  g411, // OUTPUT QA
  g268, // OUTPUT QB
  g413, // OUTPUT QC
  path170, // OUTPUT QD
);

assign counters_clock = ~(
  ~(
    clock_ct0_sc  && clock_ct0_sc2 &&
    clock_ct2_sc1 && clock_ct2_sc2 &&
    clock_ct4_sc1 && clock_ct4_sc2 &&
    clock_ct6_sc1 && clock_ct6_sc2
  )
    ||
  ~(
    clock_ct0_sc1 &&
    clock_ct1_sc1 && clock_ct1_sc2 &&
    clock_ct3_sc2 && clock_ct3_sc1 &&
    clock_ct5_sc2 && clock_ct5_sc1 &&
    clock_ct7_sc2
  )
);

// Cycle counter?
cell_C43 R61 ( // 4-bit Binary Synchronous Up Counter
  unconnected_R61_L, // INPUT L
  unconnected_R61_DA, // INPUT DA
  unconnected_R61_DB, // INPUT DB
  unconnected_R61_DC, // INPUT DC
  unconnected_R61_DD, // INPUT DD

  unconnected_R61_EN, // INPUT EN
  unconnected_R61_CI, // INPUT CI
  FSYNC_IN, // INPUT CL
  SYNC_IN, // INPUT CK
  
  counter_r61_qa, // OUTPUT QA
  counter_r61_qb, // OUTPUT QB
  counter_r61_qc, // OUTPUT QC
  counter_r61_qd, // OUTPUT QD

  unconnected_R61_CO, // OUTPUT CO
);

cell_C43 P13 ( // 4-bit Binary Synchronous Up Counter
  unconnected_P13_L, // INPUT L
  unconnected_P13_DA, // INPUT DA
  unconnected_P13_DB, // INPUT DB
  unconnected_P13_DC, // INPUT DC
  unconnected_P13_DD, // INPUT DD

  unconnected_P13_EN, // INPUT EN
  unconnected_P13_CI, // INPUT CI
  FSYNC_IN, // INPUT CL
  counters_clock, // INPUT CK
  
  RAM_A0_OUT, // OUTPUT QA
  RAM_A1_OUT, // OUTPUT QB
  RAM_A2_ROM_A0_OUT, // OUTPUT QC
  RAM_OE_OUT, // OUTPUT QD

  counter_p13_of, // OUTPUT CO
);
cell_C43 S66 ( // 4-bit Binary Synchronous Up Counter
  counter_dec_1 || subclock_2, // INPUT L
  unconnected_S66_DA, // INPUT DA
  counter_dec_1 || subclock_2, // INPUT DB
  unconnected_S66_DC, // INPUT DC
  unconnected_S66_DD, // INPUT DD

  unconnected_S66_EN, // INPUT EN
  counter_u73_qd && counter_u73_qa && (counter_p13_of || ~UNK34_IN), // INPUT CI
  FSYNC_IN, // INPUT CL
  counters_clock, // INPUT CK
  
  counter_s66_qa, // OUTPUT QA
  counter_s66_qb, // OUTPUT QB
  counter_s66_qc, // OUTPUT QC
  counter_s66_qd, // OUTPUT QD

  unconnected_S66_CO, // OUTPUT CO
);

cell_C43 U73 ( // 4-bit Binary Synchronous Up Counter
  unconnected_U73_L, // INPUT L
  unconnected_U73_DA, // INPUT DA
  unconnected_U73_DB, // INPUT DB
  unconnected_U73_DC, // INPUT DC
  unconnected_U73_DD, // INPUT DD

  counter_p13_of || ~UNK34_IN, // INPUT EN
  unconnected_U73_CI, // INPUT CI
  FSYNC_IN && ~(counter_u73_qd && counter_u73_qa && (counter_p13_of || ~UNK34_IN)), // INPUT CL
  counters_clock, // INPUT CK

  counter_u73_qa, // OUTPUT QA
  counter_u73_qb, // OUTPUT QB
  counter_u73_qc, // OUTPUT QC
  counter_u73_qd, // OUTPUT QD

  unconnected_U73_CO, // OUTPUT CO
);

cell_LT2 A89 ( // 1-bit Data Latch
  ~(~(clock_ct3_sc1 ^ VCC) ^ VCC), // INPUT G
  BUS4_IN, // INPUT D
  bus4_in_ct3sc1, // OUTPUT Q
  unconnected_A89_XQ, // OUTPUT XQ
);

cell_LT2 C63 ( // 1-bit Data Latch
  ~(~(clock_ct3_sc1 ^ VCC) ^ VCC), // INPUT G
  BUS5_IN, // INPUT D
  bus5_in_ct3sc1, // OUTPUT Q
  unconnected_C63_XQ, // OUTPUT XQ
);

cell_LT2 C91 ( // 1-bit Data Latch
  ~(~(clock_ct6_sc1 ^ VCC) ^ VCC), // INPUT G
  BUS1_IN, // INPUT D
  bus1_in_ct6sc1, // OUTPUT Q
  unconnected_C91_XQ, // OUTPUT XQ
);

cell_LT2 E103 ( // 1-bit Data Latch
  clock_ct5_sc1, // INPUT G
  ROM_D4_IN, // INPUT D
  unconnected_E103_Q, // OUTPUT Q
  rom_d4_ct5sc1_inv, // OUTPUT XQ
);

cell_A4H N11 ( // 4-bit Full Adder
  unconnected_N11_CI, // INPUT CI

  path932, // INPUT A1 N11
  path393, // INPUT B1 N11
  path332, // INPUT C1 N11
  path119, // INPUT D1 N11
  path583, // INPUT A1 I7
  path264, // INPUT B1 I7
  path209, // INPUT C1 I7
  path358, // INPUT D1 I7
  path688, // INPUT A1 S3
  path979, // INPUT B1 S3
  path207, // INPUT C1 S3
  path857, // INPUT D1 S3
  path580, // INPUT A1 U1
  path582, // INPUT B1 U1
  path594, // INPUT C1 U1
  path850, // INPUT D1 U1
  GND, // INPUT A1 P68
  g75, // INPUT B1 P68
  path942, // INPUT C1 P68
  path214, // INPUT D1 P68
  unconnected_H69_A1, // INPUT A1 H69
  unconnected_H69_B1, // INPUT B1 H69
  unconnected_H69_C1, // INPUT C1 H69
  unconnected_H69_D1, // INPUT D1 H69

  path931,   // INPUT A2 N11
  path685,   // INPUT B2 N11
  path165,   // INPUT C2 N11
  path758,   // INPUT D2 N11
  path584,   // INPUT A2 I7
  path139,   // INPUT B2 I7
  g928,      // INPUT C2 I7
  path655,   // INPUT D2 I7
  WR_A2_OUT, // INPUT A2 S3
  path549,   // INPUT B2 S3
  WR_A0_OUT, // INPUT C2 S3
  g691,      // INPUT D2 S3
  WR_A6_OUT, // INPUT A2 U1
  path463,   // INPUT B2 U1
  WR_A4_OUT, // INPUT C2 U1
  path531,   // INPUT D2 U1
  WR_A10_OUT, // INPUT A2 P68
  counter_s66_qd3, // INPUT B2 P68
  path418, // INPUT C2 P68
  WR_A7_OUT, // INPUT D2 P68
  path31, // INPUT A2 H69
  path668, // INPUT B2 H69
  g35, // INPUT C2 H69
  path146, // INPUT D2 H69

  path167, // OUTPUT S1 N11
  path686, // OUTPUT S2 N11
  path166, // OUTPUT S3 N11
  path759, // OUTPUT S4 N11
  path414, // OUTPUT S1 I7
  path269, // OUTPUT S2 I7
  path266, // OUTPUT S3 I7
  path46,  // OUTPUT S4 I7
  path550, // OUTPUT S1 S3
  path972, // OUTPUT S2 S3
  path978, // OUTPUT S3 S3
  path468, // OUTPUT S4 S3
  path581, // OUTPUT S1 U1
  path2,   // OUTPUT S2 U1
  path593, // OUTPUT S3 U1
  path182, // OUTPUT S4 U1
  g947, // OUTPUT S1 P68
  path221, // OUTPUT S2 P68
  path943, // OUTPUT S3 P68
  counter_s66_qd5, // OUTPUT S4 P68
  g782, // OUTPUT S1 H69
  g667, // OUTPUT S2 H69
  path881, // OUTPUT S3 H69
  path807, // OUTPUT S4 H69

  unconnected_H69_CO, // OUTPUT CO
);

cell_A4H I61 ( // 4-bit Full Adder
  unconnected_I61_CI, // INPUT CI

  g947, // INPUT A1 I61
  path221, // INPUT B1 I61
  path943, // INPUT C1 I61
  counter_s66_qd5, // INPUT D1 I61
  g782, // INPUT A1 F71
  g667, // INPUT B1 F71
  path881, // INPUT C1 F71
  path807, // INPUT D1 F71
  
  path337, // INPUT A2 I61
  path59, // INPUT B2 I61
  path225, // INPUT C2 I61
  path226, // INPUT D2 I61
  path783, // INPUT A2 F71
  path389, // INPUT B2 F71
  path390, // INPUT C2 F71
  path882, // INPUT D2 F71
  
  path30, // OUTPUT S1 I61
  path58, // OUTPUT S2 I61
  path944, // OUTPUT S3 I61
  path36, // OUTPUT S4 I61
  path879, // OUTPUT S1 F71
  path801, // OUTPUT S2 F71
  path880, // OUTPUT S3 F71
  path653, // OUTPUT S4 F71
  
  adder_i61_carry, // OUTPUT CO
);

cell_FDM K84 ( // DFF
  clock_ct7_sc1, // INPUT CK
  rom_d4_ct5sc1_inv, // INPUT D
  unconnected_K84_XQ, // OUTPUT XQ
  path795, // OUTPUT Q
);

cell_FDM L91 ( // DFF
  clock_ct7_sc1, // INPUT CK
  bus1_in_ct6sc1, // INPUT D
  path408, // OUTPUT XQ
  unconnected_L91_Q, // OUTPUT Q
);

cell_FDM V16 ( // DFF
  clock_ct7_sc1, // INPUT CK
  bus4_in_ct3sc1, // INPUT D
  unconnected_V16_XQ, // OUTPUT XQ
  WR_A15_OUT, // OUTPUT Q
);

cell_FDM V22 ( // DFF
  clock_ct7_sc1, // INPUT CK
  bus5_in_ct3sc1, // INPUT D
  unconnected_V22_XQ, // OUTPUT XQ
  WR_A16_OUT, // OUTPUT Q
);

cell_FDN N64 ( // DFF with Set
  clock_ct7_sc1, // INPUT CK
  RAM_OE_OUT, // INPUT D
  clock_ct4_sc1, // INPUT S
  path117, // OUTPUT Q
  path118, // OUTPUT XQ
);

cell_FDN Q77 ( // DFF with Set
  clock_ct7_sc2 && clock_ct0_sc1, // INPUT CK
  RAM_OE_OUT, // INPUT D
  FSYNC_IN, // INPUT S
  ram_ad_ct2, // OUTPUT Q
  ram_ad_ct1, // OUTPUT XQ
);

// Clock divider xtal => sync
cell_FDO N109 ( // DFF with Reset
  XTAL_IN, // INPUT CK
  clock_div_feedback, // INPUT D
  UNK34_IN, // INPUT R
  SYNCO_OUT, // OUTPUT Q
  clock_div_feedback, // OUTPUT XQ
);

cell_FDO N83 ( // DFF with Reset
  counter_dec_1 || subclock_2, // INPUT CK
  RAM_OE_OUT, // INPUT D
  clock_ct6_sc1, // INPUT R
  dff_n83_q, // OUTPUT Q
  dff_n83_xq, // OUTPUT XQ
);

assign RAM_A3_OUT = ~(~(counter_u73_qa && ~ram_ad_ct1) && ~(path527 && ~ram_ad_ct2));
assign RAM_A4_OUT = ~(~(counter_u73_qb && ~ram_ad_ct1) && ~(path499 && ~ram_ad_ct2));
assign RAM_A5_OUT = ~(~(counter_u73_qc && ~ram_ad_ct1) && ~(path500 && ~ram_ad_ct2));
assign RAM_A6_OUT = ~(~(counter_u73_qd && ~ram_ad_ct1) && ~(path452 && ~ram_ad_ct2));
assign RAM_A7_OUT = ~(~(counter_s66_qa && ~ram_ad_ct1) && ~(counter_s66_qa_dff_t40 && ~ram_ad_ct2));
assign RAM_A8_OUT = ~(~(counter_s66_qb && ~ram_ad_ct1) && ~(counter_s66_qb_dff_t40 && ~ram_ad_ct2));
assign RAM_A9_OUT = ~(~(counter_s66_qc && ~ram_ad_ct1) && ~(counter_s66_qc_dff_t40 && ~ram_ad_ct2));
assign RAM_A10_OUT = ~(~(counter_s66_qd && ~ram_ad_ct1) && ~(counter_s66_qd_dff_t40 && ~ram_ad_ct2));

assign ram_addr_00 = ~RAM_A0_OUT && ~RAM_A1_OUT;
assign ram_addr_01 = ~RAM_A0_OUT && RAM_A1_OUT;
assign ram_addr_10 = RAM_A0_OUT && ~RAM_A1_OUT;

assign RAM_D0_OUT = ~(g658 && ram_addr_00) && ~(path196 && ram_addr_10) && ~(path80 && ram_addr_01);
assign RAM_D1_OUT = ~(~(g738 && ram_addr_00) && ~(path197 && ram_addr_10) && ~(path79 && ram_addr_01));
assign RAM_D2_OUT = ~(~(g558 && ram_addr_00) && ~(path198 && ram_addr_10) && ~(path953 && ram_addr_01));
assign RAM_D3_OUT = ~(g915 && ram_addr_00) && ~(path156 && ram_addr_10) && ~(path913 && ram_addr_01);
assign RAM_D4_OUT = ~(path170 && ram_addr_00) && ~(path54 && ram_addr_10) && ~(path141 && ram_addr_01);
assign RAM_D5_OUT = ~(~(g413 && ram_addr_00) && ~(path51 && ram_addr_10) && ~(path129 && ram_addr_01));
assign RAM_D6_OUT = ~(~(g268 && ram_addr_00) && ~(path700 && ram_addr_10) && ~(path742 && ram_addr_01));
assign RAM_D7_OUT = ~(~(g411 && ram_addr_00) && ~(path701 && ram_addr_10) && ~(path741 && ram_addr_01));
assign RAM_D_OE = UNK34_IN && ~(~RAM_A2_ROM_A0_OUT && RAM_OE_OUT);

assign RAM_WR_OUT = clock_ct0_sc2 &&
                    clock_ct1_sc2 &&
                    clock_ct2_sc2 &&
                    clock_ct4_sc2 &&
                    clock_ct5_sc2 &&
                    clock_ct6_sc2 &&
                    clock_ct7_sc2 &&
                    unconnected_T91_A8;

assign wr_ad_clock_1 = path117 || dff_n83_q;
assign wr_ad_clock_2 = path118 && dff_n83_xq;

assign WR_A0_OUT = ~(~(wr_a0_a && wr_ad_clock_1) && ~(wr_a0_b && wr_ad_clock_2));
assign WR_A1_OUT = ~(wr_a1_a && wr_ad_clock_1) && ~(wr_a1_b && wr_ad_clock_2);
assign WR_A2_OUT = ~(~(wr_a2_a && wr_ad_clock_1) && ~(wr_a2_b_inv && wr_ad_clock_2));
assign WR_A3_OUT = ~(wr_a3_a && wr_ad_clock_1) && ~(wr_a3_b_inv && wr_ad_clock_2);
assign WR_A4_OUT = ~(~(wr_a4_a && wr_ad_clock_1) && ~(wr_a4_b && wr_ad_clock_2));
assign WR_A5_OUT = ~(wr_a5_a && wr_ad_clock_1) && ~(wr_a5_b && wr_ad_clock_2);
assign WR_A6_OUT = ~(~(wr_a6_a && wr_ad_clock_1) && ~(wr_a6_b && wr_ad_clock_2));
assign WR_A7_OUT = ~(~(wr_a7_a && wr_ad_clock_1) && ~(wr_a7_b_inv && wr_ad_clock_2));
assign WR_A8_OUT = ~(wr_a8_a && wr_ad_clock_1) && ~(wr_a8_b && wr_ad_clock_2);
assign WR_A9_OUT = ~(wr_a9_a && wr_ad_clock_1) && ~(wr_a9_b && wr_ad_clock_2);
assign WR_A10_OUT = ~(~(wr_a10_a && wr_ad_clock_1) && ~(wr_a10_b_inv && wr_ad_clock_2));

assign ipt0_prelatch = (~(~(g268 && wr_ad_clock_1) && ~(ram_d6_in_latched_f20 && wr_ad_clock_2)) && RAM_A0_OUT)
                    || (~bus1_in_ct6sc10 && ~RAM_A0_OUT);
assign ipt2_prelatch = (~(~(g411 && wr_ad_clock_1) && ~(ram_d7_in_latched_f20 && wr_ad_clock_2)) && RAM_A0_OUT)
                    || (~(~(bus7_in_latched_a61_b100 && bus6_in_latched_a61_b100) && path669 && ~path408) && ~RAM_A0_OUT);
assign ipt1_prelatch = (~(~(path749 && wr_ad_clock_1) && ~(wr_am1_b_inv && wr_ad_clock_2)) && RAM_A0_OUT)
                    || (~(~(g413 && wr_ad_clock_1) && ~(ram_d5_in_latched_f20 && wr_ad_clock_2)) && ~RAM_A0_OUT);
assign ipt3_prelatch_unused = (unconnected_Q94_A1 && RAM_A0_OUT) || (unconnected_Q98_A1 && ~RAM_A0_OUT);




assign bus1_in_ct6sc10 = ~(WR_A16_OUT || WR_A15_OUT || WR_A14_OUT || path547)
assign path669 = ~(path31 || path668 || g35 || path146)
assign counter_s66_qd2 = VCC && wr_a11_13_000 && wr_a11_13_001 && wr_a11_13_010 && wr_a11_13_011 && wr_a11_13_100;
assign path582 = unconnected_D13_A1 && path984 && path981 && path76 && path983 && path982;
assign g252 = bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100;
assign g259 = ~bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && bus6_in_latched_a61_b100 && ~bus7_in_latched_a61_b100;
assign g287 = ~path802;
assign g296 = ~path303;
assign g297 = bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && bus6_in_latched_a61_b100 && ~bus7_in_latched_a61_b100;
assign g302 = ~path621;
assign g322 = bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && bus6_in_latched_a61_b100 && ~bus7_in_latched_a61_b100;
assign g336 = ~(~(g782 && g648) && ~(path879 && adder_i61_carry)) && ~path408;
assign g349 = ~bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && ~bus7_in_latched_a61_b100;
assign g35 = ~(~(path360 && wr_ad_clock_1) && ~(latch_h34_ram_d5 && wr_ad_clock_2));
assign g352 = bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && ~bus7_in_latched_a61_b100;
assign g386 = ~bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100;
assign g467 = path2 && ~path408;
assign g56 = path182 && ~path408;
assign g626 = ~path627;
assign g642 = ~(~(path881 && g648) && ~(path880 && adder_i61_carry)) && ~path408;
assign g663 = ~(~(g667 && g648) && ~(path801 && adder_i61_carry)) && ~path408;
assign g691 = ~(~(path749 && wr_ad_clock_1) && ~(wr_am1_b_inv && wr_ad_clock_2));
assign g727 = ~bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && ~bus7_in_latched_a61_b100;
assign g734 = ~bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && bus6_in_latched_a61_b100 && ~bus7_in_latched_a61_b100;
assign g75 = bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100;
assign g751 = path468 && ~path408;
assign g753 = path581 && ~path408;
assign g77 = ~bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100;
assign g794 = ~path795;
assign g815 = ~path227;
assign g829 = bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && ~bus7_in_latched_a61_b100;
assign g841 = ~path842;
assign g848 = ~path618;
assign g854 = path593 && ~path408;
assign g856 = path972 && ~path408;
assign wr_a7_a_dff_m93 = ~(~(counter_s66_qd5 && ~adder_i61_carry) && ~(path36 && adder_i61_carry)) && ~path408;
assign wr_a10_a_dff_m93 = ~(~(g947 && ~adder_i61_carry) && ~(path30 && adder_i61_carry)) && ~path408;
assign g928 = ~(~(g413 && wr_ad_clock_1) && ~(ram_d5_in_latched_f20 && wr_ad_clock_2));
assign wr_a8_a_dff_m93 = ~(~(path943 && ~adder_i61_carry) && ~(path944 && adder_i61_carry)) && ~path408;
assign wr_a9_a_dff_m93 = ~(~(path221 && g648) && ~(path58 && adder_i61_carry)) && ~path408;
assign g970 = path550 && ~path408;
assign path119 = ~path83;
assign path139 = ~(~(g268 && wr_ad_clock_1) && ~(ram_d6_in_latched_f20 && wr_ad_clock_2));
assign path146 = ~(~(path145 && wr_ad_clock_1) && ~(latch_h34_ram_d4_inv && wr_ad_clock_2));
assign path165 = ~(~(g738 && wr_ad_clock_1) && ~(ram_d1_in_latched_f20 && wr_ad_clock_2));
assign path171 = path46 && ~path408;
assign path207 = ~(path206 && ~((~path802 && ~bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) || (g66 && bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100)));
assign path208 = path269 && ~path408;
assign path209 = ~(path356 && ~((g601 && ~bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) || (g606 && bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) || (g864 && ~bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) || (g866 && bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100)));
assign path214 = ~(~(bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) && ~(~path795 && ~bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) && ~(~path627 && bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100));
assign path264 = ~(path357 && ~((g66 && ~bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) || (g601 && bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) || (g606 && ~bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) || (g864 && bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100)));
assign path31 = ~(~(path148 && wr_ad_clock_1) && ~(latch_h34_ram_d7 && wr_ad_clock_2));
assign path332 = ~path735;
assign path358 = ~(path378 && ~((g606 && ~bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) || (g864 && bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) || (g866 && ~bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) || (unconnected_E49_D1 && bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100)));
assign path393 = ~(path260 && ~(g866 && ~bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100));
assign path409 = path414 && ~path408;
assign path418 = ~(~(wr_a8_a && wr_ad_clock_1) && ~(wr_a8_b && wr_ad_clock_2));
assign path463 = ~(~(wr_a5_a && wr_ad_clock_1) && ~(wr_a5_b && wr_ad_clock_2));
assign path531 = ~(~(wr_a3_a && wr_ad_clock_1) && ~(wr_a3_b_inv && wr_ad_clock_2));
assign path547 = ~counter_s66_qd2;
assign path549 = ~(~(wr_a1_a && wr_ad_clock_1) && ~(wr_a1_b && wr_ad_clock_2));
assign path553 = path266 && ~path408;
assign counter_s66_qd3 = ~(~(wr_a9_a && wr_ad_clock_1) && ~(wr_a9_b && wr_ad_clock_2));
assign path580 = ~(~(~bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) && ~(~path795 && bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) && ~(~path627 && ~bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) && ~(~path621 && bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100));
assign path583 = ~(path985 && ~((~path802 && ~bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) || (g66 && bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) || (g601 && ~bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) || (g606 && bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100)));
assign path584 = ~(~(g411 && wr_ad_clock_1) && ~(ram_d7_in_latched_f20 && wr_ad_clock_2));
assign path594 = (unconnected_D38_A1 && ~bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && bus6_in_latched_a61_b100 && ~bus7_in_latched_a61_b100) || (~path795 && bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && bus6_in_latched_a61_b100 && ~bus7_in_latched_a61_b100) || (~path627 && ~bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) || (~path621 && bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) || (~path618 && ~bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) || (~path842 && bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100);
assign path640 = ~(~(path807 && ~adder_i61_carry) && ~(path653 && adder_i61_carry)) && ~path408;
assign path655 = ~(~(path170 && wr_ad_clock_1) && ~(ram_d4_in_latched_f20 && wr_ad_clock_2));
assign path668 = ~(~(path962 && wr_ad_clock_1) && ~(latch_h34_ram_d6 && wr_ad_clock_2));
assign path685 = ~(~(g558 && wr_ad_clock_1) && ~(ram_d2_in_latched_f20_inv && wr_ad_clock_2));
assign path687 = path759 && ~path408;
assign path688 = ~path78;
assign path758 = ~(~(g658 && wr_ad_clock_1) && ~(ram_d0_in_latched_f20_inv && wr_ad_clock_2));
assign path76 = ~(~path627 && bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100);
assign path760 = path166 && ~path408;
assign path850 = ~path849;
assign path857 = ~(path298 && ~((~path303 && ~bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) || (~path802 && bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) || (g66 && ~bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) || (g601 && bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100)));
assign path916 = path167 && ~path408;
assign path917 = path686 && ~path408;
assign path931 = ~(~(g915 && wr_ad_clock_1) && ~(ram_d3_in_latched_f20_inv && wr_ad_clock_2));
assign path932 = ~(path262 && ~((g864 && ~bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) || (g866 && bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100)));
assign path942 = ~(~(~bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100) && ~(~path795 && bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100));
assign path973 = path978 && ~path408;
assign path979 = ~(path980 && ~(~path802 && bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100));
assign path981 = ~(~path795 && ~bus4_in_latched_a61_b100 && ~bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100);
assign path982 = ~(~path618 && bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100);
assign path983 = ~(~path621 && ~bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && ~bus6_in_latched_a61_b100 && bus7_in_latched_a61_b100);
assign path984 = ~(unconnected_D19_A1 && bus4_in_latched_a61_b100 && bus5_in_latched_a61_b100 && bus6_in_latched_a61_b100 && ~bus7_in_latched_a61_b100);