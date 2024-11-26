// =============================================================================
// SYNC generator (XTAL/2)

cell_FDO N109 ( // DFF with Reset
  XTAL_IN, // INPUT CK
  path631, // INPUT D
  UNK34_IN, // INPUT R
  SYNCO_OUT, // OUTPUT Q
  path631, // OUTPUT XQ
);



// =============================================================================
// Internal cycle counter

cell_C45 R61 ( // 4-bit Binary Synchronous Up Counter
  GND, // INPUT DA
  VCC, // INPUT EN
  bus1_cycle3_xor, // INPUT CI
  FSYNC_IN, // INPUT CL
  GND, // INPUT DB
  VCC, // INPUT L
  SYNC_IN, // INPUT CK
  GND, // INPUT DC
  GND, // INPUT DD
  cycle_cnt_a, // OUTPUT QA
  cycle_cnt_b, // OUTPUT QB
  unconnected_R61_CO, // OUTPUT CO
  cycle_cnt_c, // OUTPUT QC
  cycle_cnt_d, // OUTPUT QD
);

cell_DE3 T61 ( // 3:8 Decoder
  cycle_cnt_b, // INPUT B
  cycle_cnt_a, // INPUT A
  cycle_cnt_c, // INPUT C
  cycle_sel_0, // OUTPUT X0
  cycle_sel_1, // OUTPUT X1
  cycle_sel_2, // OUTPUT X2
  cycle_sel_3, // OUTPUT X3
  cycle_sel_4, // OUTPUT X4
  cycle_sel_5, // OUTPUT X5
  cycle_sel_6, // OUTPUT X6
  cycle_sel_7, // OUTPUT X7
);

assign cycle_0 = cycle_sel_0 || SYNC_IN || cycle_cnt_d;
assign cycle_1 = cycle_sel_1 || SYNC_IN || cycle_cnt_d;
assign cycle_2 = cycle_sel_2 || SYNC_IN || cycle_cnt_d;
assign cycle_3 = cycle_sel_3 || SYNC_IN || cycle_cnt_d;
assign cycle_4 = cycle_sel_4 || SYNC_IN || cycle_cnt_d;
assign cycle_5 = cycle_sel_5 || SYNC_IN || cycle_cnt_d;
assign cycle_6 = cycle_sel_6 || SYNC_IN || cycle_cnt_d;
assign cycle_7 = cycle_sel_7 || SYNC_IN || cycle_cnt_d;
assign cycle_8 = cycle_sel_0 || SYNC_IN || ~cycle_cnt_d;
assign cycle_9 = cycle_sel_1 || SYNC_IN || ~cycle_cnt_d;
assign cycle_10 = cycle_sel_2 || SYNC_IN || ~cycle_cnt_d;
assign cycle_11 = cycle_sel_3 || SYNC_IN || ~cycle_cnt_d;
assign cycle_12 = cycle_sel_4 || SYNC_IN || ~cycle_cnt_d;
assign cycle_13 = cycle_sel_5 || SYNC_IN || ~cycle_cnt_d;
assign cycle_14 = cycle_sel_6 || SYNC_IN || ~cycle_cnt_d;
assign cycle_15 = cycle_sel_7 || SYNC_IN || ~cycle_cnt_d;

assign cycle_odd = ~(cycle_1 && cycle_3 && cycle_5 && cycle_7 && cycle_9 && cycle_11 && cycle_13 && cycle_15);
assign cycle_between = ~(~(cycle_0 && cycle_2 && cycle_4 && cycle_6 && cycle_8 && cycle_10 && cycle_12 && cycle_14) || cycle_odd);



// =============================================================================
// Wave Address Generator

assign adder1_and_0 = adder1_o0 && ~path408;
assign adder1_and_1 = adder1_o1 && ~path408;
assign adder1_and_2 = adder1_o2 && ~path408;
assign adder1_and_3 = adder1_o3 && ~path408;
assign adder1_and_4 = adder1_o4 && ~path408;
assign adder1_and_5 = adder1_o5 && ~path408;
assign adder1_and_6 = adder1_o6 && ~path408;
assign adder1_and_7 = adder1_o7 && ~path408;
assign adder1_and_8 = adder1_o8 && ~path408;
assign adder1_and_9 = adder1_o9 && ~path408;
assign adder1_and_o10 = adder1_o10 && ~path408;
assign adder1_and_o11 = adder1_o11 && ~path408;
assign adder1_and_o12 = adder1_o12 && ~path408;
assign adder1_and_o13 = adder1_o13 && ~path408;
assign adder1_and_o14 = adder1_o14 && ~path408;
assign adder1_and_o15 = adder1_o15 && ~path408;

assign adder1_and_o16_0 = ~(~(adder1_o16 && ~g137) && ~(adder2_o0 && g137)) && ~path408;
assign adder1_and_o17_1 = ~(~(adder1_o17 && ~g137) && ~(adder2_o1 && g137)) && ~path408;
assign adder1_and_o18_2 = ~(~(adder1_o18 && g648) && ~(adder2_o2 && g137)) && ~path408;
assign adder1_and_o19_3 = ~(~(adder1_o19 && ~g137) && ~(adder2_o3 && g137)) && ~path408;
assign adder1_and_o20_4 = ~(~(adder1_o20 && ~g137) && ~(adder2_o4 && g137)) && ~path408;
assign adder1_and_o21_5 = ~(~(adder1_o21 && g648) && ~(adder2_o5 && g137)) && ~path408;
assign adder1_and_o22_6 = ~(~(adder1_o22 && g648) && ~(adder2_o6 && g137)) && ~path408;
assign adder1_and_o23_7 = ~(~(adder1_o23 && g648) && ~(adder2_o7 && g137)) && ~path408;

// Latches for wave addr 1 every odd cycle
cell_FDQ R40 ( // 4-bit DFF
  cycle_odd, // INPUT CK
  adder1_and_o11, // INPUT DA
  adder1_and_o10, // INPUT DB
  adder1_and_9, // INPUT DC
  adder1_and_8, // INPUT DD
  wave_ag_a2_tmp1, // OUTPUT QA
  wave_ag_a1_tmp1, // OUTPUT QB
  wave_ag_a0_tmp1, // OUTPUT QC
  path749, // OUTPUT QD
);
cell_FDQ T1 ( // 4-bit DFF
  cycle_odd, // INPUT CK
  adder1_and_o15, // INPUT DA
  adder1_and_o14, // INPUT DB
  adder1_and_o13, // INPUT DC
  adder1_and_o12, // INPUT DD
  wave_ag_a6_tmp1, // OUTPUT QA
  wave_ag_a5_tmp1, // OUTPUT QB
  wave_ag_a4_tmp1, // OUTPUT QC
  wave_ag_a3_tmp1, // OUTPUT QD
);
cell_FDQ M93 ( // 4-bit DFF
  cycle_odd, // INPUT CK
  adder1_and_o19_3, // INPUT DA
  adder1_and_o18_2, // INPUT DB
  adder1_and_o17_1, // INPUT DC
  adder1_and_o16_0, // INPUT DD
  wave_ag_a10_tmp1, // OUTPUT QA
  wave_ag_a9_tmp1, // OUTPUT QB
  wave_ag_a8_tmp1, // OUTPUT QC
  wave_ag_a7_tmp1, // OUTPUT QD
);

// Latches for wave addr 2
cell_LT4 F4 ( // 4-bit Data Latch
  path710, // INPUT G
  ~RAM_D0_IN, // INPUT DA
  RAM_D1_IN, // INPUT DB
  RAM_D2_IN, // INPUT DC
  ~RAM_D3_IN, // INPUT DD
  unconnected_F4_NA, // OUTPUT NA
  path177, // OUTPUT PA
  unconnected_F4_NB, // OUTPUT NB
  wave_ag_a0_tmp2, // OUTPUT PB
  unconnected_F4_NC, // OUTPUT NC
  wave_ag_a1_tmp2, // OUTPUT PC
  unconnected_F4_ND, // OUTPUT ND
  wave_ag_a2_tmp2, // OUTPUT PD
);
cell_LT4 H3 ( // 4-bit Data Latch
  path710, // INPUT G
  ~RAM_D4_IN, // INPUT DA
  RAM_D5_IN, // INPUT DB
  RAM_D6_IN, // INPUT DC
  RAM_D7_IN, // INPUT DD
  unconnected_H3_NA, // OUTPUT NA
  wave_ag_a3_tmp2, // OUTPUT PA
  unconnected_H3_NB, // OUTPUT NB
  wave_ag_a4_tmp2, // OUTPUT PB
  unconnected_H3_NC, // OUTPUT NC
  wave_ag_a5_tmp2, // OUTPUT PC
  unconnected_H3_ND, // OUTPUT ND
  wave_ag_a6_tmp2, // OUTPUT PD
);
cell_LT4 F36 ( // 4-bit Data Latch
  path709, // INPUT G
  ~RAM_D0_IN, // INPUT DA
  RAM_D1_IN, // INPUT DB
  RAM_D2_IN, // INPUT DC
  ~RAM_D3_IN, // INPUT DD
  unconnected_F36_NA, // OUTPUT NA
  wave_ag_a7_tmp2, // OUTPUT PA
  unconnected_F36_NB, // OUTPUT NB
  wave_ag_a8_tmp2, // OUTPUT PB
  unconnected_F36_NC, // OUTPUT NC
  wave_ag_a9_tmp2, // OUTPUT PC
  unconnected_F36_ND, // OUTPUT ND
  wave_ag_a10_tmp2, // OUTPUT PD
);

// 1/2 select
cell_FDN N64 ( // DFF with Set
  cycle_7, // INPUT CK
  RAM_OE_OUT, // INPUT D
  cycle_4, // INPUT S
  path117, // OUTPUT Q
  path118, // OUTPUT XQ
);
cell_FDO N83 ( // DFF with Reset
  cycle_9, // INPUT CK
  RAM_OE_OUT, // INPUT D
  cycle_6, // INPUT R
  path919, // OUTPUT Q
  path920, // OUTPUT XQ
);
assign wave_ag_tmp_1 = path117 || path919;
assign wave_ag_tmp_2 = path118 && path920;

assign WR_A0_OUT = ~(~(wave_ag_a0_tmp1 && wave_ag_tmp_1) && ~(wave_ag_a0_tmp2 && wave_ag_tmp_2));
assign WR_A1_OUT = ~(wave_ag_a1_tmp1 && wave_ag_tmp_1) && ~(wave_ag_a1_tmp2 && wave_ag_tmp_2);
assign WR_A2_OUT = ~(~(wave_ag_a2_tmp1 && wave_ag_tmp_1) && ~(wave_ag_a2_tmp2 && wave_ag_tmp_2));
assign WR_A3_OUT = ~(wave_ag_a3_tmp1 && wave_ag_tmp_1) && ~(wave_ag_a3_tmp2 && wave_ag_tmp_2);
assign WR_A4_OUT = ~(~(wave_ag_a4_tmp1 && wave_ag_tmp_1) && ~(wave_ag_a4_tmp2 && wave_ag_tmp_2));
assign WR_A5_OUT = ~(wave_ag_a5_tmp1 && wave_ag_tmp_1) && ~(wave_ag_a5_tmp2 && wave_ag_tmp_2);
assign WR_A6_OUT = ~(~(wave_ag_a6_tmp1 && wave_ag_tmp_1) && ~(wave_ag_a6_tmp2 && wave_ag_tmp_2));
assign WR_A7_OUT = ~(~(wave_ag_a7_tmp1 && wave_ag_tmp_1) && ~(wave_ag_a7_tmp2 && wave_ag_tmp_2));
assign WR_A8_OUT = ~(wave_ag_a8_tmp1 && wave_ag_tmp_1) && ~(wave_ag_a8_tmp2 && wave_ag_tmp_2);
assign WR_A9_OUT = ~(wave_ag_a9_tmp1 && wave_ag_tmp_1) && ~(wave_ag_a9_tmp2 && wave_ag_tmp_2);
assign WR_A10_OUT = ~(~(wave_ag_a10_tmp1 && wave_ag_tmp_1) && ~(wave_ag_a10_tmp2 && wave_ag_tmp_2));

cell_FDQ V61 ( // 4-bit DFF
  ~cycle_7, // INPUT CK
  bus0_cycle3_xor, // INPUT DA
  bus1_cycle3_xor, // INPUT DB
  bus2_cycle3_xor, // INPUT DC
  bus3_cycle3_xor, // INPUT DD
  WR_A11_OUT, // OUTPUT QA
  WR_A12_OUT, // OUTPUT QB
  WR_A13_OUT, // OUTPUT QC
  WR_A14_OUT, // OUTPUT QD
);
cell_FDM V16 ( // DFF
  cycle_7, // INPUT CK
  path495, // INPUT D
  unconnected_V16_XQ, // OUTPUT XQ
  WR_A15_OUT, // OUTPUT Q
);
cell_FDM V22 ( // DFF
  cycle_7, // INPUT CK
  path449, // INPUT D
  unconnected_V22_XQ, // OUTPUT XQ
  WR_A16_OUT, // OUTPUT Q
);



// =============================================================================
// Signal to interpolator (pins 36/37/38)

assign path693 = ~(~(~(~(path749 && wave_ag_tmp_1) && ~(path177 && wave_ag_tmp_2)) && RAM_A0_OUT) && ~(~(~(g413 && wave_ag_tmp_1) && ~(path998 && wave_ag_tmp_2)) && ~RAM_A0_OUT));
assign path586 = ~(~(~(~(g411 && wave_ag_tmp_1) && ~(path149 && wave_ag_tmp_2)) && RAM_A0_OUT) && ~(~(~(g364 && g820) && ~(~(~(path148 && wave_ag_tmp_1) && ~(path33 && wave_ag_tmp_2)) || ~(~(path962 && wave_ag_tmp_1) && ~(path959 && wave_ag_tmp_2)) || ~(~(path360 && wave_ag_tmp_1) && ~(path706 && wave_ag_tmp_2)) || ~(~(path145 && wave_ag_tmp_1) && ~(path708 && wave_ag_tmp_2))) && ~path408) && ~RAM_A0_OUT));
assign path587 = ~(~(~(~(g268 && wave_ag_tmp_1) && ~(path265 && wave_ag_tmp_2)) && RAM_A0_OUT) && ~((WR_A16_OUT || WR_A15_OUT || WR_A14_OUT || (VCC && wave_addr_upper_dec_0 && wave_addr_upper_dec_1 && wave_addr_upper_dec_2 && wave_addr_upper_dec_3 && wave_addr_upper_dec_4)) && ~RAM_A0_OUT));
assign path219 = ~(~(GND && RAM_A0_OUT) && ~(GND && ~RAM_A0_OUT)); // Unused


cell_LT4 Q106 ( // 4-bit Data Latch
  SYNC_IN, // INPUT G
  path693, // INPUT DA
  path586, // INPUT DB
  path587, // INPUT DC
  path219, // INPUT DD
  unconnected_Q106_NA, // OUTPUT NA
  IPT1_OUT, // OUTPUT PA
  unconnected_Q106_NB, // OUTPUT NB
  IPT2_OUT, // OUTPUT PB
  unconnected_Q106_NC, // OUTPUT NC
  IPT0_OUT, // OUTPUT PC
  unconnected_Q106_ND, // OUTPUT ND
  unconnected_Q106_PD, // OUTPUT PD
);



// =============================================================================
// Interface with ROM (IC11)

// Address for the ROM comes in two cycles from IC19
cell_LT4 A107 ( // 4-bit Data Latch
  path902, // INPUT G
  BUS0_IN, // INPUT DA
  BUS1_IN, // INPUT DB
  BUS2_IN, // INPUT DC
  BUS3_IN, // INPUT DD
  unconnected_A107_NA, // OUTPUT NA
  ROM_A9_OUT, // OUTPUT PA
  unconnected_A107_NB, // OUTPUT NB
  ROM_A10_OUT, // OUTPUT PB
  unconnected_A107_NC, // OUTPUT NC
  ROM_A11_OUT, // OUTPUT PC
  unconnected_A107_ND, // OUTPUT ND
  ROM_A12_OUT, // OUTPUT PD
);
cell_LT4 A76 ( // 4-bit Data Latch
  path12, // INPUT G
  BUS4_IN, // INPUT DA
  BUS5_IN, // INPUT DB
  BUS6_IN, // INPUT DC
  BUS7_IN, // INPUT DD
  unconnected_A76_NA, // OUTPUT NA
  ROM_A5_OUT, // OUTPUT PA
  unconnected_A76_NB, // OUTPUT NB
  ROM_A6_OUT, // OUTPUT PB
  unconnected_A76_NC, // OUTPUT NC
  ROM_A7_OUT, // OUTPUT PC
  unconnected_A76_ND, // OUTPUT ND
  ROM_A8_OUT, // OUTPUT PD
);
cell_LT4 A94 ( // 4-bit Data Latch
  path12, // INPUT G
  BUS0_IN, // INPUT DA
  BUS1_IN, // INPUT DB
  BUS2_IN, // INPUT DC
  BUS3_IN, // INPUT DD
  unconnected_A94_NA, // OUTPUT NA
  ROM_A1_OUT, // OUTPUT PA
  unconnected_A94_NB, // OUTPUT NB
  ROM_A2_OUT, // OUTPUT PB
  unconnected_A94_NC, // OUTPUT NC
  ROM_A3_OUT, // OUTPUT PC
  unconnected_A94_ND, // OUTPUT ND
  ROM_A4_OUT, // OUTPUT PD
);


// ROM data is readt in cycle 3
cell_LT4 D108 ( // 4-bit Data Latch
  cycle_3, // INPUT G
  ROM_D4_IN, // INPUT DA
  ROM_D5_IN, // INPUT DB
  ROM_D6_IN, // INPUT DC
  ROM_D7_IN, // INPUT DD
  unconnected_D108_NA, // OUTPUT NA
  rom_d4_cycle3, // OUTPUT PA
  rom_d5_cycle3, // OUTPUT NB
  unconnected_D108_PB, // OUTPUT PB
  rom_d6_cycle3, // OUTPUT NC
  unconnected_D108_PC, // OUTPUT PC
  rom_d7_cycle3, // OUTPUT ND
  unconnected_D108_PD, // OUTPUT PD
);
cell_LT4 E108 ( // 4-bit Data Latch
  cycle_3, // INPUT G
  ROM_D0_IN, // INPUT DA
  ROM_D1_IN, // INPUT DB
  ROM_D2_IN, // INPUT DC
  ROM_D3_IN, // INPUT DD
  unconnected_E108_NA, // OUTPUT NA
  rom_d0_cycle3, // OUTPUT PA
  unconnected_E108_NB, // OUTPUT NB
  rom_d1_cycle3, // OUTPUT PB
  unconnected_E108_NC, // OUTPUT NC
  rom_d2_cycle3, // OUTPUT PC
  unconnected_E108_ND, // OUTPUT ND
  rom_d3_cycle3, // OUTPUT PD
);

// ROM data is readt again in cycle 5 (lower 5 bits)
cell_LT4 E90 ( // 4-bit Data Latch
  cycle_5, // INPUT G
  ROM_D0_IN, // INPUT DA
  ROM_D1_IN, // INPUT DB
  ROM_D2_IN, // INPUT DC
  ROM_D3_IN, // INPUT DD
  rom_d0_cycle5, // OUTPUT NA
  unconnected_E90_PA, // OUTPUT PA
  rom_d1_cycle5, // OUTPUT NB
  unconnected_E90_PB, // OUTPUT PB
  rom_d2_cycle5, // OUTPUT NC
  unconnected_E90_PC, // OUTPUT PC
  rom_d3_cycle5, // OUTPUT ND
  unconnected_E90_PD, // OUTPUT PD
);
cell_LT2 E103 ( // 1-bit Data Latch
  cycle_5, // INPUT G
  ROM_D4_IN, // INPUT D
  unconnected_E103_Q, // OUTPUT Q
  rom_d4_cycle5, // OUTPUT XQ
);


// =============================================================================
// TODO

cell_LT4 A61 ( // 4-bit Data Latch
  path902, // INPUT G
  BUS4_IN, // INPUT DA
  BUS5_IN, // INPUT DB
  BUS6_IN, // INPUT DC
  BUS7_IN, // INPUT DD
  unconnected_A61_NA, // OUTPUT NA
  path803, // OUTPUT PA
  unconnected_A61_NB, // OUTPUT NB
  path230, // OUTPUT PB
  unconnected_A61_NC, // OUTPUT NC
  path821, // OUTPUT PC
  unconnected_A61_ND, // OUTPUT ND
  path229, // OUTPUT PD
);

cell_LT4 M61 ( // 4-bit Data Latch
  cycle_7, // INPUT G
  adder1_and_o16_0, // INPUT DA
  adder1_and_o17_1, // INPUT DB
  adder1_and_o18_2, // INPUT DC
  adder1_and_o19_3, // INPUT DD
  unconnected_M61_NA, // OUTPUT NA
  path80, // OUTPUT PA
  unconnected_M61_NB, // OUTPUT NB
  path79, // OUTPUT PB
  unconnected_M61_NC, // OUTPUT NC
  path953, // OUTPUT PC
  unconnected_M61_ND, // OUTPUT ND
  path913, // OUTPUT PD
);

cell_LT4 Q20 ( // 4-bit Data Latch
  cycle_7, // INPUT G
  adder1_and_o12, // INPUT DA
  adder1_and_o13, // INPUT DB
  adder1_and_o14, // INPUT DC
  adder1_and_o15, // INPUT DD
  unconnected_Q20_NA, // OUTPUT NA
  path54, // OUTPUT PA
  unconnected_Q20_NB, // OUTPUT NB
  path51, // OUTPUT PB
  unconnected_Q20_NC, // OUTPUT NC
  path700, // OUTPUT PC
  unconnected_Q20_ND, // OUTPUT ND
  path701, // OUTPUT PD
);

cell_LT4 Q38 ( // 4-bit Data Latch
  cycle_7, // INPUT G
  adder1_and_8, // INPUT DA
  g195, // INPUT DB
  adder1_and_o10, // INPUT DC
  adder1_and_o11, // INPUT DD
  unconnected_Q38_NA, // OUTPUT NA
  path196, // OUTPUT PA
  unconnected_Q38_NB, // OUTPUT NB
  path197, // OUTPUT PB
  unconnected_Q38_NC, // OUTPUT NC
  path198, // OUTPUT PC
  unconnected_Q38_ND, // OUTPUT ND
  path156, // OUTPUT PD
);

cell_LT4 B61 ( // 4-bit Data Latch
  path231, // INPUT G
  BUS0_IN, // INPUT DA
  BUS1_IN, // INPUT DB
  BUS2_IN, // INPUT DC
  BUS3_IN, // INPUT DD
  path223, // OUTPUT NA
  unconnected_B61_PA, // OUTPUT PA
  path224, // OUTPUT NB
  unconnected_B61_PB, // OUTPUT PB
  path804, // OUTPUT NC
  unconnected_B61_PC, // OUTPUT PC
  path338, // OUTPUT ND
  unconnected_B61_PD, // OUTPUT PD
);

cell_LT4 B74 ( // 4-bit Data Latch
  path231, // INPUT G
  BUS4_IN, // INPUT DA
  BUS5_IN, // INPUT DB
  BUS6_IN, // INPUT DC
  BUS7_IN, // INPUT DD
  path883, // OUTPUT NA
  unconnected_B74_PA, // OUTPUT PA
  path391, // OUTPUT NB
  unconnected_B74_PB, // OUTPUT PB
  path339, // OUTPUT NC
  unconnected_B74_PC, // OUTPUT PC
  path784, // OUTPUT ND
  unconnected_B74_PD, // OUTPUT PD
);

cell_LT4 B87 ( // 4-bit Data Latch
  cycle_3_xor, // INPUT G
  BUS0_IN, // INPUT DA
  BUS1_IN, // INPUT DB
  BUS2_IN, // INPUT DC
  BUS3_IN, // INPUT DD
  unconnected_B87_NA, // OUTPUT NA
  bus0_cycle3_xor, // OUTPUT PA
  unconnected_B87_NB, // OUTPUT NB
  bus1_cycle3_xor, // OUTPUT PB
  unconnected_B87_NC, // OUTPUT NC
  bus2_cycle3_xor, // OUTPUT PC
  unconnected_B87_ND, // OUTPUT ND
  bus3_cycle3_xor, // OUTPUT PD
);

cell_LT4 F20 ( // 4-bit Data Latch
  g131, // INPUT G
  ~RAM_D0_IN, // INPUT DA
  RAM_D1_IN, // INPUT DB
  RAM_D2_IN, // INPUT DC
  ~RAM_D3_IN, // INPUT DD
  unconnected_F20_NA, // OUTPUT NA
  path997, // OUTPUT PA
  unconnected_F20_NB, // OUTPUT NB
  path661, // OUTPUT PB
  unconnected_F20_NC, // OUTPUT NC
  path334, // OUTPUT PC
  unconnected_F20_ND, // OUTPUT ND
  path86, // OUTPUT PD
);

cell_LT4 G18 ( // 4-bit Data Latch
  cycle_7, // INPUT G
  adder1_and_o20_4, // INPUT DA
  adder1_and_o21_5, // INPUT DB
  adder1_and_o22_6, // INPUT DC
  adder1_and_o23_7, // INPUT DD
  unconnected_G18_NA, // OUTPUT NA
  path141, // OUTPUT PA
  unconnected_G18_NB, // OUTPUT NB
  path129, // OUTPUT PB
  unconnected_G18_NC, // OUTPUT NC
  path742, // OUTPUT PC
  unconnected_G18_ND, // OUTPUT ND
  path741, // OUTPUT PD
);

cell_LT4 H20 ( // 4-bit Data Latch
  g131, // INPUT G
  ~RAM_D4_IN, // INPUT DA
  RAM_D5_IN, // INPUT DB
  RAM_D6_IN, // INPUT DC
  RAM_D7_IN, // INPUT DD
  unconnected_H20_NA, // OUTPUT NA
  path142, // OUTPUT PA
  unconnected_H20_NB, // OUTPUT NB
  path998, // OUTPUT PB
  unconnected_H20_NC, // OUTPUT NC
  path265, // OUTPUT PC
  unconnected_H20_ND, // OUTPUT ND
  path149, // OUTPUT PD
);

cell_LT4 H34 ( // 4-bit Data Latch
  path709, // INPUT G
  ~RAM_D4_IN, // INPUT DA
  RAM_D5_IN, // INPUT DB
  RAM_D6_IN, // INPUT DC
  RAM_D7_IN, // INPUT DD
  unconnected_H34_NA, // OUTPUT NA
  path708, // OUTPUT PA
  unconnected_H34_NB, // OUTPUT NB
  path706, // OUTPUT PB
  unconnected_H34_NC, // OUTPUT NC
  path959, // OUTPUT PC
  unconnected_H34_ND, // OUTPUT ND
  path33, // OUTPUT PD
);

cell_FDQ O4 ( // 4-bit DFF
  cycle_odd, // INPUT CK
  adder1_and_3, // INPUT DA
  adder1_and_2, // INPUT DB
  adder1_and_1, // INPUT DC
  adder1_and_0, // INPUT DD
  g915, // OUTPUT QA
  g558, // OUTPUT QB
  g738, // OUTPUT QC
  g658, // OUTPUT QD
);

cell_FDQ T40 ( // 4-bit DFF
  ~cycle_15, // INPUT CK
  path482, // INPUT DA
  path548, // INPUT DB
  path102, // INPUT DC
  path57, // INPUT DD
  path851, // OUTPUT QA
  path484, // OUTPUT QB
  path183, // OUTPUT QC
  path184, // OUTPUT QD
);

cell_FDQ B100 ( // 4-bit DFF
  ~cycle_7, // INPUT CK
  path803, // INPUT DA
  path230, // INPUT DB
  path821, // INPUT DC
  path229, // INPUT DD
  g377, // OUTPUT QA
  g995, // OUTPUT QB
  g820, // OUTPUT QC
  g364, // OUTPUT QD
);

cell_FDQ V32 ( // 4-bit DFF
  ~cycle_15, // INPUT CK
  g526, // INPUT DA
  g530, // INPUT DB
  g535, // INPUT DC
  path536, // INPUT DD
  path527, // OUTPUT QA
  path499, // OUTPUT QB
  path500, // OUTPUT QC
  path452, // OUTPUT QD
);

cell_FDQ C67 ( // 4-bit DFF
  ~cycle_7, // INPUT CK
  path883, // INPUT DA
  path391, // INPUT DB
  path339, // INPUT DC
  path784, // INPUT DD
  path882, // OUTPUT QA
  path390, // OUTPUT QB
  path389, // OUTPUT QC
  path783, // OUTPUT QD
);

cell_FDQ C100 ( // 4-bit DFF
  ~cycle_7, // INPUT CK
  path223, // INPUT DA
  path224, // INPUT DB
  path804, // INPUT DC
  path338, // INPUT DD
  path226, // OUTPUT QA
  path225, // OUTPUT QB
  path59, // OUTPUT QC
  path337, // OUTPUT QD
);

cell_FDQ D61 ( // 4-bit DFF
  ~cycle_7, // INPUT CK
  rom_d0_cycle3, // INPUT DA
  rom_d1_cycle3, // INPUT DB
  rom_d2_cycle3, // INPUT DC
  rom_d3_cycle3, // INPUT DD
  g866, // OUTPUT QA
  g864, // OUTPUT QB
  g606, // OUTPUT QC
  g601, // OUTPUT QD
);

cell_FDQ D87 ( // 4-bit DFF
  ~cycle_7, // INPUT CK
  rom_d4_cycle3, // INPUT DA
  rom_d5_cycle3, // INPUT DB
  rom_d6_cycle3, // INPUT DC
  rom_d7_cycle3, // INPUT DD
  g66, // OUTPUT QA
  path802, // OUTPUT QB
  path303, // OUTPUT QC
  path227, // OUTPUT QD
);

cell_FDQ E61 ( // 4-bit DFF
  ~cycle_7, // INPUT CK
  rom_d0_cycle5, // INPUT DA
  rom_d1_cycle5, // INPUT DB
  rom_d2_cycle5, // INPUT DC
  rom_d3_cycle5, // INPUT DD
  path842, // OUTPUT QA
  path618, // OUTPUT QB
  path621, // OUTPUT QC
  path627, // OUTPUT QD
);

cell_FDQ G38 ( // 4-bit DFF
  cycle_odd, // INPUT CK
  adder1_and_o23_7, // INPUT DA
  adder1_and_o22_6, // INPUT DB
  adder1_and_o21_5, // INPUT DC
  adder1_and_o20_4, // INPUT DD
  path148, // OUTPUT QA
  path962, // OUTPUT QB
  path360, // OUTPUT QC
  path145, // OUTPUT QD
);

cell_FDQ J40 ( // 4-bit DFF
  cycle_odd, // INPUT CK
  adder1_and_7, // INPUT DA
  adder1_and_6, // INPUT DB
  adder1_and_5, // INPUT DC
  adder1_and_4, // INPUT DD
  g411, // OUTPUT QA
  g268, // OUTPUT QB
  g413, // OUTPUT QC
  path170, // OUTPUT QD
);

cell_C45 P13 ( // 4-bit Binary Synchronous Up Counter
  VCC, // INPUT DA
  g1028, // INPUT EN
  VCC, // INPUT CI
  FSYNC_IN, // INPUT CL
  VCC, // INPUT DB
  VCC, // INPUT L
  cycle_between, // INPUT CK
  g1031, // INPUT DC
  VCC, // INPUT DD
  RAM_A0_OUT, // OUTPUT QA
  RAM_A1_OUT, // OUTPUT QB
  path22, // OUTPUT CO
  RAM_A2_ROM_A0_OUT, // OUTPUT QC
  RAM_OE_OUT, // OUTPUT QD
);

cell_C45 S66 ( // 4-bit Binary Synchronous Up Counter
  VCC, // INPUT DA
  VCC, // INPUT EN
  path323, // INPUT CI
  FSYNC_IN, // INPUT CL
  cycle_9, // INPUT DB
  cycle_9, // INPUT L
  cycle_between, // INPUT CK
  GND, // INPUT DC
  GND, // INPUT DD
  path482, // OUTPUT QA
  path548, // OUTPUT QB
  unconnected_S66_CO, // OUTPUT CO
  path102, // OUTPUT QC
  path57, // OUTPUT QD
);

cell_C45 U73 ( // 4-bit Binary Synchronous Up Counter
  GND, // INPUT DA
  g1044, // INPUT EN
  g1044, // INPUT CI
  rom_d4_cycle38, // INPUT CL
  GND, // INPUT DB
  VCC, // INPUT L
  cycle_between, // INPUT CK
  GND, // INPUT DC
  GND, // INPUT DD
  g526, // OUTPUT QA
  g530, // OUTPUT QB
  unconnected_U73_CO, // OUTPUT CO
  g535, // OUTPUT QC
  g488, // OUTPUT QD
);

cell_LT2 A89 ( // 1-bit Data Latch
  cycle_3_xor, // INPUT G
  BUS4_IN, // INPUT D
  path495, // OUTPUT Q
  unconnected_A89_XQ, // OUTPUT XQ
);

cell_LT2 C63 ( // 1-bit Data Latch
  cycle_3_xor, // INPUT G
  BUS5_IN, // INPUT D
  path449, // OUTPUT Q
  unconnected_C63_XQ, // OUTPUT XQ
);

cell_LT2 C91 ( // 1-bit Data Latch
  path808, // INPUT G
  BUS1_IN, // INPUT D
  path44, // OUTPUT Q
  unconnected_C91_XQ, // OUTPUT XQ
);


// Adder 1 (24 bit)
cell_A4H N11 ( // 4-bit Full Adder
  path932, // INPUT A4
  path931, // INPUT B4
  path393, // INPUT A3
  path685, // INPUT B3
  path332, // INPUT A2
  path165, // INPUT B2
  path119, // INPUT A1
  path758, // INPUT B1
  GND, // INPUT CI
  path656, // OUTPUT CO
  adder1_o3, // OUTPUT S4
  adder1_o2, // OUTPUT S3
  adder1_o1, // OUTPUT S2
  adder1_o0, // OUTPUT S1
);
cell_A4H I7 ( // 4-bit Full Adder
  path583, // INPUT A4
  path584, // INPUT B4
  path264, // INPUT A3
  path139, // INPUT B3
  path209, // INPUT A2
  g928, // INPUT B2
  path358, // INPUT A1
  path655, // INPUT B1
  path656, // INPUT CI
  g1031, // OUTPUT CO
  adder1_o7, // OUTPUT S4
  adder1_o6, // OUTPUT S3
  adder1_o5, // OUTPUT S2
  adder1_o4, // OUTPUT S1
);
cell_A4H S3 ( // 4-bit Full Adder
  path688, // INPUT A4
  WR_A2_OUT, // INPUT B4
  g1028, // INPUT A3
  path549, // INPUT B3
  path207, // INPUT A2
  WR_A0_OUT, // INPUT B2
  path857, // INPUT A1
  g691, // INPUT B1
  g1031, // INPUT CI
  path181, // OUTPUT CO
  adder1_o11, // OUTPUT S4
  adder1_o10, // OUTPUT S3
  adder1_o9, // OUTPUT S2
  adder1_o8, // OUTPUT S1
);
cell_A4H U1 ( // 4-bit Full Adder
  path580, // INPUT A4
  WR_A6_OUT, // INPUT B4
  path582, // INPUT A3
  path463, // INPUT B3
  path594, // INPUT A2
  WR_A4_OUT, // INPUT B2
  path850, // INPUT A1
  path531, // INPUT B1
  path181, // INPUT CI
  path574, // OUTPUT CO
  adder1_o15, // OUTPUT S4
  adder1_o14, // OUTPUT S3
  adder1_o13, // OUTPUT S2
  adder1_o12, // OUTPUT S1
);
cell_A4H P68 ( // 4-bit Full Adder
  GND, // INPUT A4
  WR_A10_OUT, // INPUT B4
  g75, // INPUT A3
  path573, // INPUT B3
  path942, // INPUT A2
  path418, // INPUT B2
  path214, // INPUT A1
  WR_A7_OUT, // INPUT B1
  path574, // INPUT CI
  path138, // OUTPUT CO
  adder1_o19, // OUTPUT S4
  adder1_o18, // OUTPUT S3
  adder1_o17, // OUTPUT S2
  adder1_o16, // OUTPUT S1
);
cell_A4H H69 ( // 4-bit Full Adder
  GND, // INPUT A4
  path31, // INPUT B4
  GND, // INPUT A3
  path668, // INPUT B3
  GND, // INPUT A2
  g35, // INPUT B2
  GND, // INPUT A1
  path146, // INPUT B1
  path138, // INPUT CI
  unconnected_H69_CO, // OUTPUT CO
  adder1_o23, // OUTPUT S4
  adder1_o22, // OUTPUT S3
  adder1_o21, // OUTPUT S2
  adder1_o20, // OUTPUT S1
);


// Adder 2 (8 bit)
cell_A4H I61 ( // 4-bit Full Adder
  adder1_o19, // INPUT A4
  path337, // INPUT B4
  adder1_o18, // INPUT A3
  path59, // INPUT B3
  adder1_o17, // INPUT A2
  path225, // INPUT B2
  adder1_o16, // INPUT A1
  path226, // INPUT B1
  VCC, // INPUT CI
  path654, // OUTPUT CO
  adder2_o3, // OUTPUT S4
  adder2_o2, // OUTPUT S3
  adder2_o1, // OUTPUT S2
  adder2_o0, // OUTPUT S1
);
cell_A4H F71 ( // 4-bit Full Adder
  adder1_o23, // INPUT A4
  path783, // INPUT B4
  adder1_o22, // INPUT A3
  path389, // INPUT B3
  adder1_o21, // INPUT A2
  path390, // INPUT B2
  adder1_o20, // INPUT A1
  path882, // INPUT B1
  path654, // INPUT CI
  g137, // OUTPUT CO
  adder2_o7, // OUTPUT S4
  adder2_o6, // OUTPUT S3
  adder2_o5, // OUTPUT S2
  adder2_o4, // OUTPUT S1
);


cell_FDM K84 ( // DFF
  cycle_7, // INPUT CK
  rom_d4_cycle5, // INPUT D
  unconnected_K84_XQ, // OUTPUT XQ
  path795, // OUTPUT Q
);

cell_FDM L91 ( // DFF
  cycle_7, // INPUT CK
  path44, // INPUT D
  path408, // OUTPUT XQ
  unconnected_L91_Q, // OUTPUT Q
);

cell_DE3 V91 ( // 3:8 Decoder
  WR_A12_OUT, // INPUT B
  WR_A11_OUT, // INPUT A
  WR_A13_OUT, // INPUT C
  wave_addr_upper_dec_0, // OUTPUT X0
  wave_addr_upper_dec_1, // OUTPUT X1
  wave_addr_upper_dec_2, // OUTPUT X2
  wave_addr_upper_dec_3, // OUTPUT X3
  wave_addr_upper_dec_4, // OUTPUT X4
  unconnected_V91_X5, // OUTPUT X5
  unconnected_V91_X6, // OUTPUT X6
  unconnected_V91_X7, // OUTPUT X7
);

cell_FDN Q77 ( // DFF with Set
  path544, // INPUT CK
  RAM_OE_OUT, // INPUT D
  FSYNC_IN, // INPUT S
  path545, // OUTPUT Q
  path546, // OUTPUT XQ
);

assign RAM_A3_OUT = ~(~(g526 && ~path546) && ~(path527 && ~path545));
assign RAM_A4_OUT = ~(~(g530 && ~path546) && ~(path499 && ~path545));
assign RAM_A5_OUT = ~(~(g535 && ~path546) && ~(path500 && ~path545));
assign RAM_A6_OUT = ~(~(g488 && ~path546) && ~(path452 && ~path545));
assign RAM_A7_OUT = ~(~(path482 && ~path546) && ~(path851 && ~path545));
assign RAM_A8_OUT = ~(~(path548 && ~path546) && ~(path484 && ~path545));
assign RAM_A9_OUT = ~(~(path102 && ~path546) && ~(path183 && ~path545));
assign RAM_A10_OUT = ~(~(path57 && ~path546) && ~(path184 && ~path545));

assign RAM_D_IOM = UNK34_IN && ~(~RAM_A2_ROM_A0_OUT && RAM_OE_OUT);
assign RAM_D0_OUT = ~(g658 && ~RAM_A0_OUT && ~RAM_A1_OUT) && ~(path196 && RAM_A0_OUT && ~RAM_A1_OUT) && ~(path80 && ~RAM_A0_OUT && RAM_A1_OUT);
assign RAM_D1_OUT = ~(~(g738 && ~RAM_A0_OUT && ~RAM_A1_OUT) && ~(path197 && RAM_A0_OUT && ~RAM_A1_OUT) && ~(path79 && ~RAM_A0_OUT && RAM_A1_OUT));
assign RAM_D2_OUT = ~(~(g558 && ~RAM_A0_OUT && ~RAM_A1_OUT) && ~(path198 && RAM_A0_OUT && ~RAM_A1_OUT) && ~(path953 && ~RAM_A0_OUT && RAM_A1_OUT));
assign RAM_D3_OUT = ~(g915 && ~RAM_A0_OUT && ~RAM_A1_OUT) && ~(path156 && RAM_A0_OUT && ~RAM_A1_OUT) && ~(path913 && ~RAM_A0_OUT && RAM_A1_OUT);
assign RAM_D4_OUT = ~(path170 && ~RAM_A0_OUT && ~RAM_A1_OUT) && ~(path54 && RAM_A0_OUT && ~RAM_A1_OUT) && ~(path141 && ~RAM_A0_OUT && RAM_A1_OUT);
assign RAM_D5_OUT = ~(~(g413 && ~RAM_A0_OUT && ~RAM_A1_OUT) && ~(path51 && RAM_A0_OUT && ~RAM_A1_OUT) && ~(path129 && ~RAM_A0_OUT && RAM_A1_OUT));
assign RAM_D6_OUT = ~(~(g268 && ~RAM_A0_OUT && ~RAM_A1_OUT) && ~(path700 && RAM_A0_OUT && ~RAM_A1_OUT) && ~(path742 && ~RAM_A0_OUT && RAM_A1_OUT));
assign RAM_D7_OUT = ~(~(g411 && ~RAM_A0_OUT && ~RAM_A1_OUT) && ~(path701 && RAM_A0_OUT && ~RAM_A1_OUT) && ~(path741 && ~RAM_A0_OUT && RAM_A1_OUT));
assign RAM_WR_OUT = cycle_8 && cycle_9 && cycle_10 && cycle_12 && cycle_13 && cycle_14 && cycle_15 && VCC;

assign g35 = ~(~(path360 && wave_ag_tmp_1) && ~(path706 && wave_ag_tmp_2));
assign g691 = ~(~(path749 && wave_ag_tmp_1) && ~(path177 && wave_ag_tmp_2));
assign g928 = ~(~(g413 && wave_ag_tmp_1) && ~(path998 && wave_ag_tmp_2));
assign path139 = ~(~(g268 && wave_ag_tmp_1) && ~(path265 && wave_ag_tmp_2));
assign path146 = ~(~(path145 && wave_ag_tmp_1) && ~(path708 && wave_ag_tmp_2));
assign path165 = ~(~(g738 && wave_ag_tmp_1) && ~(path661 && wave_ag_tmp_2));
assign path31 = ~(~(path148 && wave_ag_tmp_1) && ~(path33 && wave_ag_tmp_2));
assign path418 = ~(~(wave_ag_a8_tmp1 && wave_ag_tmp_1) && ~(wave_ag_a8_tmp2 && wave_ag_tmp_2));
assign path463 = ~(~(wave_ag_a5_tmp1 && wave_ag_tmp_1) && ~(wave_ag_a5_tmp2 && wave_ag_tmp_2));
assign path531 = ~(~(wave_ag_a3_tmp1 && wave_ag_tmp_1) && ~(wave_ag_a3_tmp2 && wave_ag_tmp_2));
assign path549 = ~(~(wave_ag_a1_tmp1 && wave_ag_tmp_1) && ~(wave_ag_a1_tmp2 && wave_ag_tmp_2));
assign path573 = ~(~(wave_ag_a9_tmp1 && wave_ag_tmp_1) && ~(wave_ag_a9_tmp2 && wave_ag_tmp_2));
assign path584 = ~(~(g411 && wave_ag_tmp_1) && ~(path149 && wave_ag_tmp_2));
assign path655 = ~(~(path170 && wave_ag_tmp_1) && ~(path142 && wave_ag_tmp_2));
assign path668 = ~(~(path962 && wave_ag_tmp_1) && ~(path959 && wave_ag_tmp_2));
assign path685 = ~(~(g558 && wave_ag_tmp_1) && ~(path334 && wave_ag_tmp_2));
assign path758 = ~(~(g658 && wave_ag_tmp_1) && ~(path997 && wave_ag_tmp_2));
assign path931 = ~(~(g915 && wave_ag_tmp_1) && ~(path86 && wave_ag_tmp_2));

assign path902 = ~(bus2_cycle3_xor ^ ~(VCC ^ cycle_0));
assign g131 = ~(bus0_cycle3_xor ^ path902);
assign cycle_3_xor = ~(~(cycle_3 ^ VCC) ^ VCC);
assign path12 = ~(UNK_VCC? ^ ~(VCC ^ cycle_1));
assign path231 = ~(bus0_cycle3_xor ^ ~(VCC ^ cycle_2));
assign path544 = cycle_15 && cycle_7;
assign path709 = ~(bus0_cycle3_xor ^ ~(bus0_cycle3_xor ^ ~(VCC ^ cycle_2)));
assign path710 = ~(~path795 ^ ~(UNK_VCC? ^ ~(VCC ^ cycle_1)));
assign path808 = ~(~(cycle_6 ^ VCC) ^ VCC);

assign g1028 = ~(~((VCC && g377 && g995 && ~g820 && ~g364) || (~path795 && ~g377 && ~g995 && g820 && ~g364) || (~path627 && g377 && ~g995 && g820 && ~g364) || (~path621 && ~g377 && g995 && g820 && ~g364) || (~path618 && g377 && g995 && g820 && ~g364) || (~path842 && ~g377 && ~g995 && ~g820 && g364) || (~path227 && g377 && ~g995 && ~g820 && g364) || (~path303 && ~g377 && g995 && ~g820 && g364)) && ~(~path802 && g377 && g995 && ~g820 && g364));
assign path119 = (~path303 && ~g377 && ~g995 && ~g820 && ~g364) || (~path802 && g377 && ~g995 && ~g820 && ~g364) || (g66 && ~g377 && g995 && ~g820 && ~g364) || (g601 && g377 && g995 && ~g820 && ~g364) || (g606 && ~g377 && ~g995 && g820 && ~g364) || (g864 && g377 && ~g995 && g820 && ~g364) || (g866 && ~g377 && g995 && g820 && ~g364) || (g377 && ~g995 && ~g820 && g364 && g377 && g995 && g820 && ~g364);
assign path207 = ~(~((VCC && ~g377 && g995 && ~g820 && ~g364) || (~path795 && g377 && g995 && ~g820 && ~g364) || (~path627 && ~g377 && ~g995 && g820 && ~g364) || (~path621 && g377 && ~g995 && g820 && ~g364) || (~path618 && ~g377 && g995 && g820 && ~g364) || (~path842 && g377 && g995 && g820 && ~g364) || (~path227 && ~g377 && ~g995 && ~g820 && g364) || (~path303 && g377 && ~g995 && ~g820 && g364)) && ~((~path802 && ~g377 && g995 && ~g820 && g364) || (g66 && g377 && g995 && ~g820 && g364)));
assign path209 = ~(~((~path627 && ~g377 && ~g995 && ~g820 && ~g364) || (~path621 && g377 && ~g995 && ~g820 && ~g364) || (~path618 && ~g377 && g995 && ~g820 && ~g364) || (~path842 && g377 && g995 && ~g820 && ~g364) || (~path227 && ~g377 && ~g995 && g820 && ~g364) || (~path303 && g377 && ~g995 && g820 && ~g364) || (~path802 && ~g377 && g995 && g820 && ~g364) || (g66 && g377 && g995 && g820 && ~g364)) && ~((g601 && ~g377 && ~g995 && ~g820 && g364) || (g606 && g377 && ~g995 && ~g820 && g364) || (g864 && ~g377 && g995 && ~g820 && g364) || (g866 && g377 && g995 && ~g820 && g364)));
assign path214 = ~(~(g377 && ~g995 && ~g820 && g364) && ~(~path795 && ~g377 && g995 && ~g820 && g364) && ~(~path627 && g377 && g995 && ~g820 && g364));
assign path264 = ~(~((~path795 && ~g377 && ~g995 && ~g820 && ~g364) || (~path627 && g377 && ~g995 && ~g820 && ~g364) || (~path621 && ~g377 && g995 && ~g820 && ~g364) || (~path618 && g377 && g995 && ~g820 && ~g364) || (~path842 && ~g377 && ~g995 && g820 && ~g364) || (~path227 && g377 && ~g995 && g820 && ~g364) || (~path303 && ~g377 && g995 && g820 && ~g364) || (~path802 && g377 && g995 && g820 && ~g364)) && ~((g66 && ~g377 && ~g995 && ~g820 && g364) || (g601 && g377 && ~g995 && ~g820 && g364) || (g606 && ~g377 && g995 && ~g820 && g364) || (g864 && g377 && g995 && ~g820 && g364)));
assign path332 = (~path227 && ~g377 && ~g995 && ~g820 && ~g364) || (~path303 && g377 && ~g995 && ~g820 && ~g364) || (~path802 && ~g377 && g995 && ~g820 && ~g364) || (g66 && g377 && g995 && ~g820 && ~g364) || (g601 && ~g377 && ~g995 && g820 && ~g364) || (g606 && g377 && ~g995 && g820 && ~g364) || (g864 && ~g377 && g995 && g820 && ~g364) || (g866 && g377 && g995 && g820 && ~g364);
assign path358 = ~(~((~path621 && ~g377 && ~g995 && ~g820 && ~g364) || (~path618 && g377 && ~g995 && ~g820 && ~g364) || (~path842 && ~g377 && g995 && ~g820 && ~g364) || (~path227 && g377 && g995 && ~g820 && ~g364) || (~path303 && ~g377 && ~g995 && g820 && ~g364) || (~path802 && g377 && ~g995 && g820 && ~g364) || (g66 && ~g377 && g995 && g820 && ~g364) || (g601 && g377 && g995 && g820 && ~g364)) && ~((g606 && ~g377 && ~g995 && ~g820 && g364) || (g864 && g377 && ~g995 && ~g820 && g364) || (g866 && ~g377 && g995 && ~g820 && g364) || (GND && g377 && g995 && ~g820 && g364)));
assign path393 = ~(~((~path842 && ~g377 && ~g995 && ~g820 && ~g364) || (~path227 && g377 && ~g995 && ~g820 && ~g364) || (~path303 && ~g377 && g995 && ~g820 && ~g364) || (~path802 && g377 && g995 && ~g820 && ~g364) || (g66 && ~g377 && ~g995 && g820 && ~g364) || (g601 && g377 && ~g995 && g820 && ~g364) || (g606 && ~g377 && g995 && g820 && ~g364) || (g864 && g377 && g995 && g820 && ~g364)) && ~(g866 && ~g377 && ~g995 && ~g820 && g364));
assign path580 = ~(~(~g377 && ~g995 && ~g820 && g364) && ~(~path795 && g377 && ~g995 && ~g820 && g364) && ~(~path627 && ~g377 && g995 && ~g820 && g364) && ~(~path621 && g377 && g995 && ~g820 && g364));
assign path582 = ~(VCC && ~(VCC && g377 && g995 && g820 && ~g364) && ~(~path795 && ~g377 && ~g995 && ~g820 && g364) && ~(~path627 && g377 && ~g995 && ~g820 && g364) && ~(~path621 && ~g377 && g995 && ~g820 && g364) && ~(~path618 && g377 && g995 && ~g820 && g364));
assign path583 = ~(~((VCC && ~g377 && ~g995 && ~g820 && ~g364) || (~path795 && g377 && ~g995 && ~g820 && ~g364) || (~path627 && ~g377 && g995 && ~g820 && ~g364) || (~path621 && g377 && g995 && ~g820 && ~g364) || (~path618 && ~g377 && ~g995 && g820 && ~g364) || (~path842 && g377 && ~g995 && g820 && ~g364) || (~path227 && ~g377 && g995 && g820 && ~g364) || (~path303 && g377 && g995 && g820 && ~g364)) && ~((~path802 && ~g377 && ~g995 && ~g820 && g364) || (g66 && g377 && ~g995 && ~g820 && g364) || (g601 && ~g377 && g995 && ~g820 && g364) || (g606 && g377 && g995 && ~g820 && g364)));
assign path594 = (VCC && ~g377 && g995 && g820 && ~g364) || (~path795 && g377 && g995 && g820 && ~g364) || (~path627 && ~g377 && ~g995 && ~g820 && g364) || (~path621 && g377 && ~g995 && ~g820 && g364) || (~path618 && ~g377 && g995 && ~g820 && g364) || (~path842 && g377 && g995 && ~g820 && g364);
assign path688 = (VCC && ~g377 && ~g995 && g820 && ~g364) || (~path795 && g377 && ~g995 && g820 && ~g364) || (~path627 && ~g377 && g995 && g820 && ~g364) || (~path621 && g377 && g995 && g820 && ~g364) || (~path618 && ~g377 && ~g995 && ~g820 && g364) || (~path842 && g377 && ~g995 && ~g820 && g364) || (~path227 && ~g377 && g995 && ~g820 && g364) || (~path303 && g377 && g995 && ~g820 && g364);
assign path850 = (GND && ~g377 && ~g995 && g820 && ~g364) || (VCC && g377 && ~g995 && g820 && ~g364) || (~path795 && ~g377 && g995 && g820 && ~g364) || (~path627 && g377 && g995 && g820 && ~g364) || (~path621 && ~g377 && ~g995 && ~g820 && g364) || (~path618 && g377 && ~g995 && ~g820 && g364) || (~path842 && ~g377 && g995 && ~g820 && g364) || (~path227 && g377 && g995 && ~g820 && g364);
assign path857 = ~(~((GND && ~g377 && ~g995 && ~g820 && ~g364) || (VCC && g377 && ~g995 && ~g820 && ~g364) || (~path795 && ~g377 && g995 && ~g820 && ~g364) || (~path627 && g377 && g995 && ~g820 && ~g364) || (~path621 && ~g377 && ~g995 && g820 && ~g364) || (~path618 && g377 && ~g995 && g820 && ~g364) || (~path842 && ~g377 && g995 && g820 && ~g364) || (~path227 && g377 && g995 && g820 && ~g364)) && ~((~path303 && ~g377 && ~g995 && ~g820 && g364) || (~path802 && g377 && ~g995 && ~g820 && g364) || (g66 && ~g377 && g995 && ~g820 && g364) || (g601 && g377 && g995 && ~g820 && g364)));
assign path932 = ~(~((~path618 && ~g377 && ~g995 && ~g820 && ~g364) || (~path842 && g377 && ~g995 && ~g820 && ~g364) || (~path227 && ~g377 && g995 && ~g820 && ~g364) || (~path303 && g377 && g995 && ~g820 && ~g364) || (~path802 && ~g377 && ~g995 && g820 && ~g364) || (g66 && g377 && ~g995 && g820 && ~g364) || (g601 && ~g377 && g995 && g820 && ~g364) || (g606 && g377 && g995 && g820 && ~g364)) && ~((g864 && ~g377 && ~g995 && ~g820 && g364) || (g866 && g377 && ~g995 && ~g820 && g364)));

assign g75 = g377 && g995 && ~g820 && g364;
assign path942 = ~(~(~g377 && g995 && ~g820 && g364) && ~(~path795 && g377 && g995 && ~g820 && g364));

assign g1044 = path22 || ~UNK34_IN;
assign path323 = g488 && g526 && (path22 || ~UNK34_IN);
assign rom_d4_cycle38 = FSYNC_IN && ~(path323);
