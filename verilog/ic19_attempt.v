// RAM address counter

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
  ric12_a0, // OUTPUT QA
  g160_ric12_a1_rd, // OUTPUT QB
  path1005_e7_coverflow, // OUTPUT CO
  g156_ric12_a2_rd, // OUTPUT QC
  ric12_read_stage, // OUTPUT QD
);
assign g384_e7_coverflow_unk74block = path1005_e7_coverflow || ~UNK_74_IN;
cell_C45 B13 ( // 4-bit Binary Synchronous Up Counter
  GND, // INPUT DA
  g384_e7_coverflow_unk74block, // INPUT EN
  g384_e7_coverflow_unk74block, // INPUT CI
  path386, // INPUT CL
  GND, // INPUT DB
  VCC, // INPUT L
  cycle_between, // INPUT CK
  GND, // INPUT DC
  GND, // INPUT DD
  g260_ric12_a3_1, // OUTPUT QA
  path133_ric12_a4_1, // OUTPUT QB
  unconnected_B13_CO, // OUTPUT CO
  path134_ric12_a5_1, // OUTPUT QC
  path379_ric12_a6_1, // OUTPUT QD
);

assign path385 = path379_ric12_a6_1 && g260_ric12_a3_1 && (path1005_e7_coverflow || ~UNK_74_IN);
assign path386 = FSYNC_IN && ~(path379_ric12_a6_1 && g260_ric12_a3_1 && (path1005_e7_coverflow || ~UNK_74_IN));
cell_C45 D13 ( // 4-bit Binary Synchronous Up Counter
  GND, // INPUT DA
  VCC, // INPUT EN
  path385, // INPUT CI
  FSYNC_IN, // INPUT CL
  GND, // INPUT DB
  VCC, // INPUT L
  cycle_between, // INPUT CK
  GND, // INPUT DC
  GND, // INPUT DD
  g1075_ric12_a7_rd, // OUTPUT QA
  path153_ric12_a8_rd, // OUTPUT QB
  unconnected_D13_CO, // OUTPUT CO
  g1142_ric12_a9_rd, // OUTPUT QC
  g893_ric12_a10_rd, // OUTPUT QD
);




// Adders

cell_FDN O16 ( // DFF with Set
  g476_ric13_d_0_clock, // INPUT CK
  ric12_read_stage, // INPUT D
  path1211, // INPUT S
  g1014, // OUTPUT Q
  g1016, // OUTPUT XQ
);
cell_FDO O39 ( // DFF with Reset
  g1034, // INPUT CK
  ric12_read_stage, // INPUT D
  g1039, // INPUT R
  g1012, // OUTPUT Q
  g1018, // OUTPUT XQ
);
assign adder1_sel = g1014 || g1012;

assign adder1_a0  =   ~env_flag_r_0 && ((env_sprev_0 && ~adder1_sel) || (env_fprev_0 && adder1_sel));
assign adder1_a1  =   ~env_flag_r_0 && ((env_sprev_1 && ~adder1_sel) || (env_fprev_1 && adder1_sel));
assign adder1_a2  =   ~env_flag_r_0 && ((env_sprev_2 && ~adder1_sel) || (env_fprev_2 && adder1_sel));
assign adder1_a3  =   ~env_flag_r_0 && ((env_sprev_3 && ~adder1_sel) || (env_fprev_3 && adder1_sel));
assign adder1_a4  =   ~env_flag_r_0 && ((env_sprev_4 && ~adder1_sel) || (env_fprev_4 && adder1_sel));
assign adder1_a5  =   ~env_flag_r_0 && ((env_sprev_5 && ~adder1_sel) || (env_fprev_5 && adder1_sel));
assign adder1_a6  =   ~env_flag_r_0 && ((env_sprev_6 && ~adder1_sel) || (env_fprev_6 && adder1_sel));
assign adder1_a7  =   ~env_flag_r_0 && ((env_sprev_7 && ~adder1_sel) || (env_fprev_7 && adder1_sel));
assign adder1_a8  =   ~env_flag_r_0 && ((env_sprev_8 && ~adder1_sel) || (env_fprev_8 && adder1_sel));
assign adder1_a9  =   ~env_flag_r_0 && ((env_sprev_9 && ~adder1_sel) || (env_fprev_9 && adder1_sel));
assign adder1_a10 =   ~env_flag_r_0 && ((env_sprev_10 && ~adder1_sel) || (env_fprev_10 && adder1_sel));
assign adder1_a11 =   ~env_flag_r_0 && ((env_sprev_11 && ~adder1_sel) || (env_fprev_11 && adder1_sel));
assign adder1_a12 =   ~env_flag_r_0 && ((env_sprev_12 && ~adder1_sel) || (env_fprev_12 && adder1_sel));
assign adder1_a13 =   ~env_flag_r_0 && ((env_sprev_13 && ~adder1_sel) || (env_fprev_13 && adder1_sel));
assign adder1_a14 =   ~env_flag_r_0 && ((env_sprev_14 && ~adder1_sel) || (env_fprev_14 && adder1_sel));
assign adder1_a15 =   ~env_flag_r_0 && ((env_sprev_15 && ~adder1_sel) || (env_fprev_15 && adder1_sel));
assign adder1_a16 =   ~env_flag_r_0 && ((env_sprev_16 && ~adder1_sel) || (env_fprev_16 && adder1_sel));
assign adder1_a17 =   ~env_flag_r_0 && ((env_sprev_17 && ~adder1_sel) || (env_fprev_17 && adder1_sel));
assign adder1_a18 =   ~env_flag_r_0 && ((env_sprev_18 && ~adder1_sel) || (env_fprev_18 && adder1_sel));
assign adder1_a19 =   ~env_flag_r_0 && ((env_sprev_19 && ~adder1_sel) || (env_fprev_19 && adder1_sel));
assign adder1_a20 =   ~env_flag_r_0 && ((env_sprev_20 && ~adder1_sel) || (env_fprev_20 && adder1_sel));
assign adder1_a21 =   ~env_flag_r_0 && ((env_sprev_21 && ~adder1_sel) || (env_fprev_21 && adder1_sel));
assign adder1_a22 =   ~env_flag_r_0 && ((env_sprev_22 && ~adder1_sel) || (env_fprev_22 && adder1_sel));
assign adder1_a23 =   ~env_flag_r_0 && ((env_sprev_23 && ~adder1_sel) || (env_fprev_23 && adder1_sel));
assign adder1_a24 =   ~env_flag_r_0 && ((env_sprev_24 && ~adder1_sel) || (env_fprev_24 && adder1_sel));
assign adder1_a25 =    env_flag_r_0 || ((env_sprev_25 && ~adder1_sel) || (env_fprev_25 && adder1_sel));
assign adder1_a26 =   ~env_flag_r_0 && ((env_sprev_26 && ~adder1_sel) || (env_fprev_26 && adder1_sel));
assign adder1_a27 =   ~env_flag_r_0 && ((env_sprev_27 && ~adder1_sel) || (env_fprev_27 && adder1_sel));

assign adder1_b_invert = (env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7;

assign adder1_b0 = ~(((~(~env_speed_2 || env_speed_1) || env_speed_0) && ~env_speed_6 && ~env_speed_5 && ~env_speed_4 && ~env_speed_3 && (env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7) || (~((~(~env_speed_2 || env_speed_1) || env_speed_0) && ~env_speed_6 && ~env_speed_5 && ~env_speed_4 && ~env_speed_3) && ~((env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7)));
assign adder1_b1 = ~(((((~(~env_speed_2 || env_speed_1) || env_speed_0) && ~env_speed_6 && ~env_speed_5 && ~env_speed_4 && env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && ~env_speed_6 && ~env_speed_5 && ~env_speed_4 && ~env_speed_3)) && (env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7) || (~(((~(~env_speed_2 || env_speed_1) || env_speed_0) && ~env_speed_6 && ~env_speed_5 && ~env_speed_4 && env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && ~env_speed_6 && ~env_speed_5 && ~env_speed_4 && ~env_speed_3)) && ~((env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7)));
assign adder1_b2 = ~((((VCC && ~env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3) || ((~(~env_speed_2 || env_speed_1) || env_speed_0) && ~env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && ~env_speed_6 && ~env_speed_5 && ~env_speed_4 && env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && ~env_speed_6 && ~env_speed_5 && ~env_speed_4 && ~env_speed_3)) && (env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7) || (~((VCC && ~env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3) || ((~(~env_speed_2 || env_speed_1) || env_speed_0) && ~env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && ~env_speed_6 && ~env_speed_5 && ~env_speed_4 && env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && ~env_speed_6 && ~env_speed_5 && ~env_speed_4 && ~env_speed_3)) && ~((env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7)));
assign adder1_b3 = ~(((((~(~env_speed_2 || env_speed_1) || env_speed_0) && ~env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && ~env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && ~env_speed_6 && ~env_speed_5 && ~env_speed_4 && env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && ~env_speed_6 && ~env_speed_5 && ~env_speed_4 && ~env_speed_3)) && (env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7) || (~(((~(~env_speed_2 || env_speed_1) || env_speed_0) && ~env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && ~env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && ~env_speed_6 && ~env_speed_5 && ~env_speed_4 && env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && ~env_speed_6 && ~env_speed_5 && ~env_speed_4 && ~env_speed_3)) && ~((env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7)));
assign adder1_b4 = ~((((GND && ~env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3) || ((~(~env_speed_2 || env_speed_1) || env_speed_0) && ~env_speed_6 && env_speed_5 && ~env_speed_4 && ~env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && ~env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && ~env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && ~env_speed_6 && ~env_speed_5 && ~env_speed_4 && env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && ~env_speed_6 && ~env_speed_5 && ~env_speed_4 && ~env_speed_3)) && (env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7) || (~((GND && ~env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3) || ((~(~env_speed_2 || env_speed_1) || env_speed_0) && ~env_speed_6 && env_speed_5 && ~env_speed_4 && ~env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && ~env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && ~env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && ~env_speed_6 && ~env_speed_5 && ~env_speed_4 && env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && ~env_speed_6 && ~env_speed_5 && ~env_speed_4 && ~env_speed_3)) && ~((env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7)));
assign adder1_b5 = ~((~(~((env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND)) || ~(((~(~env_speed_2 || env_speed_1) || env_speed_0) && ~env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && ~env_speed_6 && env_speed_5 && ~env_speed_4 && ~env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && ~env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && ~env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && ~env_speed_6 && ~env_speed_5 && ~env_speed_4 && env_speed_3) || (VCC && ~env_speed_6 && ~env_speed_5 && ~env_speed_4 && ~env_speed_3))) && (env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7) || ((~((env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND)) || ~(((~(~env_speed_2 || env_speed_1) || env_speed_0) && ~env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && ~env_speed_6 && env_speed_5 && ~env_speed_4 && ~env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && ~env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && ~env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && ~env_speed_6 && ~env_speed_5 && ~env_speed_4 && env_speed_3) || (VCC && ~env_speed_6 && ~env_speed_5 && ~env_speed_4 && ~env_speed_3))) && ~((env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7)));
assign adder1_b6 = ~(((((~(~env_speed_2 || env_speed_1) || env_speed_0) && ~env_speed_6 && env_speed_5 && env_speed_4 && ~env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && ~env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && ~env_speed_6 && env_speed_5 && ~env_speed_4 && ~env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && ~env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && ~env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3) || (VCC && ~env_speed_6 && ~env_speed_5 && ~env_speed_4 && env_speed_3)) && (env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7) || (~(((~(~env_speed_2 || env_speed_1) || env_speed_0) && ~env_speed_6 && env_speed_5 && env_speed_4 && ~env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && ~env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && ~env_speed_6 && env_speed_5 && ~env_speed_4 && ~env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && ~env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && ~env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3) || (VCC && ~env_speed_6 && ~env_speed_5 && ~env_speed_4 && env_speed_3)) && ~((env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7)));
assign adder1_b7 = ~(((((~(~env_speed_2 || env_speed_1) || env_speed_0) && ~env_speed_6 && env_speed_5 && env_speed_4 && env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && ~env_speed_6 && env_speed_5 && env_speed_4 && ~env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && ~env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && ~env_speed_6 && env_speed_5 && ~env_speed_4 && ~env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && ~env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3) || (VCC && ~env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3)) && (env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7) || (~(((~(~env_speed_2 || env_speed_1) || env_speed_0) && ~env_speed_6 && env_speed_5 && env_speed_4 && env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && ~env_speed_6 && env_speed_5 && env_speed_4 && ~env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && ~env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && ~env_speed_6 && env_speed_5 && ~env_speed_4 && ~env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && ~env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3) || (VCC && ~env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3)) && ~((env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7)));
assign adder1_b8 = ~(((((~(~env_speed_2 || env_speed_1) || env_speed_0) && env_speed_6 && ~env_speed_5 && ~env_speed_4 && ~env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && ~env_speed_6 && env_speed_5 && env_speed_4 && env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && ~env_speed_6 && env_speed_5 && env_speed_4 && ~env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && ~env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && ~env_speed_6 && env_speed_5 && ~env_speed_4 && ~env_speed_3) || (VCC && ~env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3)) && (env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7) || (~(((~(~env_speed_2 || env_speed_1) || env_speed_0) && env_speed_6 && ~env_speed_5 && ~env_speed_4 && ~env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && ~env_speed_6 && env_speed_5 && env_speed_4 && env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && ~env_speed_6 && env_speed_5 && env_speed_4 && ~env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && ~env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && ~env_speed_6 && env_speed_5 && ~env_speed_4 && ~env_speed_3) || (VCC && ~env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3)) && ~((env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7)));
assign adder1_b9 = ~(((((~(~env_speed_2 || env_speed_1) || env_speed_0) && env_speed_6 && ~env_speed_5 && ~env_speed_4 && env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && env_speed_6 && ~env_speed_5 && ~env_speed_4 && ~env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && ~env_speed_6 && env_speed_5 && env_speed_4 && env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && ~env_speed_6 && env_speed_5 && env_speed_4 && ~env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && ~env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3) || (VCC && ~env_speed_6 && env_speed_5 && ~env_speed_4 && ~env_speed_3)) && (env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7) || (~(((~(~env_speed_2 || env_speed_1) || env_speed_0) && env_speed_6 && ~env_speed_5 && ~env_speed_4 && env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && env_speed_6 && ~env_speed_5 && ~env_speed_4 && ~env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && ~env_speed_6 && env_speed_5 && env_speed_4 && env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && ~env_speed_6 && env_speed_5 && env_speed_4 && ~env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && ~env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3) || (VCC && ~env_speed_6 && env_speed_5 && ~env_speed_4 && ~env_speed_3)) && ~((env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7)));
assign adder1_b10 = ~(((((~(~env_speed_2 || env_speed_1) || env_speed_0) && env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && env_speed_6 && ~env_speed_5 && ~env_speed_4 && env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && env_speed_6 && ~env_speed_5 && ~env_speed_4 && ~env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && ~env_speed_6 && env_speed_5 && env_speed_4 && env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && ~env_speed_6 && env_speed_5 && env_speed_4 && ~env_speed_3) || (VCC && ~env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3)) && (env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7) || (~(((~(~env_speed_2 || env_speed_1) || env_speed_0) && env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && env_speed_6 && ~env_speed_5 && ~env_speed_4 && env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && env_speed_6 && ~env_speed_5 && ~env_speed_4 && ~env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && ~env_speed_6 && env_speed_5 && env_speed_4 && env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && ~env_speed_6 && env_speed_5 && env_speed_4 && ~env_speed_3) || (VCC && ~env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3)) && ~((env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7)));
assign adder1_b11 = ~(((((~(~env_speed_2 || env_speed_1) || env_speed_0) && env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && env_speed_6 && ~env_speed_5 && ~env_speed_4 && env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && env_speed_6 && ~env_speed_5 && ~env_speed_4 && ~env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && ~env_speed_6 && env_speed_5 && env_speed_4 && env_speed_3) || (VCC && ~env_speed_6 && env_speed_5 && env_speed_4 && ~env_speed_3)) && (env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7) || (~(((~(~env_speed_2 || env_speed_1) || env_speed_0) && env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && env_speed_6 && ~env_speed_5 && ~env_speed_4 && env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && env_speed_6 && ~env_speed_5 && ~env_speed_4 && ~env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && ~env_speed_6 && env_speed_5 && env_speed_4 && env_speed_3) || (VCC && ~env_speed_6 && env_speed_5 && env_speed_4 && ~env_speed_3)) && ~((env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7)));
assign adder1_b12 = ~(((((~(~env_speed_2 || env_speed_1) || env_speed_0) && env_speed_6 && env_speed_5 && ~env_speed_4 && ~env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && env_speed_6 && ~env_speed_5 && ~env_speed_4 && env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && env_speed_6 && ~env_speed_5 && ~env_speed_4 && ~env_speed_3) || (VCC && ~env_speed_6 && env_speed_5 && env_speed_4 && env_speed_3)) && (env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7) || (~(((~(~env_speed_2 || env_speed_1) || env_speed_0) && env_speed_6 && env_speed_5 && ~env_speed_4 && ~env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && env_speed_6 && ~env_speed_5 && ~env_speed_4 && env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && env_speed_6 && ~env_speed_5 && ~env_speed_4 && ~env_speed_3) || (VCC && ~env_speed_6 && env_speed_5 && env_speed_4 && env_speed_3)) && ~((env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7)));
assign adder1_b13 = ~(((((~(~env_speed_2 || env_speed_1) || env_speed_0) && env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && env_speed_6 && env_speed_5 && ~env_speed_4 && ~env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && env_speed_6 && ~env_speed_5 && ~env_speed_4 && env_speed_3) || (VCC && env_speed_6 && ~env_speed_5 && ~env_speed_4 && ~env_speed_3)) && (env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7) || (~(((~(~env_speed_2 || env_speed_1) || env_speed_0) && env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && env_speed_6 && env_speed_5 && ~env_speed_4 && ~env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && env_speed_6 && ~env_speed_5 && ~env_speed_4 && env_speed_3) || (VCC && env_speed_6 && ~env_speed_5 && ~env_speed_4 && ~env_speed_3)) && ~((env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7)));
assign adder1_b14 = ~(((((~(~env_speed_2 || env_speed_1) || env_speed_0) && env_speed_6 && env_speed_5 && env_speed_4 && ~env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && env_speed_6 && env_speed_5 && ~env_speed_4 && ~env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3) || (VCC && env_speed_6 && ~env_speed_5 && ~env_speed_4 && env_speed_3)) && (env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7) || (~(((~(~env_speed_2 || env_speed_1) || env_speed_0) && env_speed_6 && env_speed_5 && env_speed_4 && ~env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && env_speed_6 && env_speed_5 && ~env_speed_4 && ~env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3) || (VCC && env_speed_6 && ~env_speed_5 && ~env_speed_4 && env_speed_3)) && ~((env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7)));
assign adder1_b15 = ~(((((~(~env_speed_2 || env_speed_1) || env_speed_0) && env_speed_6 && env_speed_5 && env_speed_4 && env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && env_speed_6 && env_speed_5 && env_speed_4 && ~env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && env_speed_6 && env_speed_5 && ~env_speed_4 && ~env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3) || (VCC && env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3)) && (env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7) || (~(((~(~env_speed_2 || env_speed_1) || env_speed_0) && env_speed_6 && env_speed_5 && env_speed_4 && env_speed_3) || (((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && env_speed_6 && env_speed_5 && env_speed_4 && ~env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && env_speed_6 && env_speed_5 && ~env_speed_4 && ~env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3) || (VCC && env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3)) && ~((env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7)));
assign adder1_b16 = ~((((((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && env_speed_6 && env_speed_5 && env_speed_4 && env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && env_speed_6 && env_speed_5 && env_speed_4 && ~env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && env_speed_6 && env_speed_5 && ~env_speed_4 && ~env_speed_3) || (VCC && env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3) || (GND && env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3)) && (env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7) || (~((((~env_speed_2 && ~env_speed_1 && env_speed_0) || ~((~env_speed_2 && env_speed_0) || ~env_speed_1)) && env_speed_6 && env_speed_5 && env_speed_4 && env_speed_3) || (~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && env_speed_6 && env_speed_5 && env_speed_4 && ~env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && env_speed_6 && env_speed_5 && ~env_speed_4 && ~env_speed_3) || (VCC && env_speed_6 && ~env_speed_5 && env_speed_4 && env_speed_3) || (GND && env_speed_6 && ~env_speed_5 && env_speed_4 && ~env_speed_3)) && ~((env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7)));
assign adder1_b17 = ~((((~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && env_speed_6 && env_speed_5 && env_speed_4 && env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && env_speed_6 && env_speed_5 && env_speed_4 && ~env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3) || (VCC && env_speed_6 && env_speed_5 && ~env_speed_4 && ~env_speed_3)) && (env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7) || (~((~(~env_speed_2 && ~env_speed_1) && ~env_speed_0 && env_speed_6 && env_speed_5 && env_speed_4 && env_speed_3) || (((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && env_speed_6 && env_speed_5 && env_speed_4 && ~env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3) || (VCC && env_speed_6 && env_speed_5 && ~env_speed_4 && ~env_speed_3)) && ~((env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7)));
assign adder1_b18 = ~((((((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && env_speed_6 && env_speed_5 && env_speed_4 && env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && env_speed_6 && env_speed_5 && env_speed_4 && ~env_speed_3) || (env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3)) && (env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7) || (~((((env_speed_2 && ~env_speed_1 && ~env_speed_0) || ~(~env_speed_1 || ~env_speed_0)) && env_speed_6 && env_speed_5 && env_speed_4 && env_speed_3) || (env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && env_speed_6 && env_speed_5 && env_speed_4 && ~env_speed_3) || (env_speed_6 && env_speed_5 && ~env_speed_4 && env_speed_3)) && ~((env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7)));
assign adder1_b19 = ~((((env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && env_speed_6 && env_speed_5 && env_speed_4 && env_speed_3) || (env_speed_6 && env_speed_5 && env_speed_4 && ~env_speed_3)) && (env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7) || (~((env_speed_2 && ~(~env_speed_1 && ~env_speed_0) && env_speed_6 && env_speed_5 && env_speed_4 && env_speed_3) || (env_speed_6 && env_speed_5 && env_speed_4 && ~env_speed_3)) && ~((env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7)));
assign adder1_b20 = ~((env_speed_6 && env_speed_5 && env_speed_4 && env_speed_3 && (env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7) || (~(env_speed_6 && env_speed_5 && env_speed_4 && env_speed_3) && ~((env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND) && env_speed_7)));

// Adder 1
cell_A4H T69 ( // 4-bit Full Adder
  adder1_a3, // INPUT A4
  adder1_b3, // INPUT B4
  adder1_a2, // INPUT A3
  adder1_b2, // INPUT B3
  adder1_a1, // INPUT A2
  adder1_b1, // INPUT B2
  adder1_a0, // INPUT A1
  adder1_b0, // INPUT B1
  adder1_b_invert, // INPUT CI
  path636, // OUTPUT CO
  path657, // OUTPUT S4
  path655, // OUTPUT S3
  path653, // OUTPUT S2
  path651, // OUTPUT S1
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
  path640, // OUTPUT S4
  path478, // OUTPUT S3
  path426, // OUTPUT S2
  path440, // OUTPUT S1
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
  path1059, // OUTPUT S4
  path1058, // OUTPUT S3
  path1318, // OUTPUT S2
  path1216, // OUTPUT S1
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
  path1284, // OUTPUT S4
  path1283, // OUTPUT S3
  path1076, // OUTPUT S2
  path1106, // OUTPUT S1
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
  path915, // OUTPUT S4
  path1240, // OUTPUT S3
  path1248, // OUTPUT S2
  path860, // OUTPUT S1
);
cell_A4H J66 ( // 4-bit Full Adder
  adder1_a23, // INPUT A4
  adder1_b_invert, // INPUT B4
  adder1_a22, // INPUT A3
  adder1_b_invert, // INPUT B3
  adder1_a21, // INPUT A2
  adder1_b_invert, // INPUT B2
  adder1_a20, // INPUT A1
  adder1_b20, // INPUT B1
  path1113, // INPUT CI
  path1072, // OUTPUT CO
  adder1_o23, // OUTPUT S4
  adder1_o22, // OUTPUT S3
  adder1_o21, // OUTPUT S2
  adder1_o20, // OUTPUT S1
);
cell_A4H I61 ( // 4-bit Full Adder
  adder1_a27, // INPUT A4
  adder1_b_invert, // INPUT B4
  adder1_a26, // INPUT A3
  adder1_b_invert, // INPUT B3
  adder1_a25, // INPUT A2
  adder1_b_invert, // INPUT B2
  adder1_a24, // INPUT A1
  adder1_b_invert, // INPUT B1
  path1072, // INPUT CI
  adder1_of, // OUTPUT CO
  adder1_o27, // OUTPUT S4
  adder1_o26, // OUTPUT S3
  adder1_o25, // OUTPUT S2
  adder1_o24, // OUTPUT S1
);


// Adder 3
cell_A4H C71 ( // 4-bit Full Adder
  adder1_a23, // INPUT A4
  env_offs_r_3, // INPUT B4
  adder1_a22, // INPUT A3
  env_offs_r_2, // INPUT B3
  adder1_a21, // INPUT A2
  env_offs_r_1, // INPUT B2
  adder1_a20, // INPUT A1
  env_offs_r_0, // INPUT B1
  VCC, // INPUT CI
  path141, // OUTPUT CO
  adder3_o3, // OUTPUT S4
  adder3_o2, // OUTPUT S3
  adder3_o1, // OUTPUT S2
  adder3_o0, // OUTPUT S1
);
cell_A4H E61 ( // 4-bit Full Adder
  adder1_a27, // INPUT A4
  env_offs_r_7, // INPUT B4
  adder1_a26, // INPUT A3
  env_offs_r_6, // INPUT B3
  adder1_a25, // INPUT A2
  env_offs_r_5, // INPUT B2
  adder1_a24, // INPUT A1
  env_offs_r_4, // INPUT B1
  path141, // INPUT CI
  adder3_of, // OUTPUT CO
  adder3_o7, // OUTPUT S4
  adder3_o6, // OUTPUT S3
  adder3_o5, // OUTPUT S2
  adder3_o4, // OUTPUT S1
);
assign path267_io2_out_unsync = ric12_a0 ?
    (adder3_of && adder3_o7) :
    adder3_o0;
assign path268_io7_out_unsync = ric12_a0 ?
    ~(adder3_of && adder3_o6) :
    (env_flag_r_0 || ~((env_sprev_19 && ~adder1_sel) || (env_fprev_19 && adder1_sel)));
assign path269_io8_out_unsync = ric12_a0 ?
    ~(adder3_of && adder3_o5) :
    (env_flag_r_0 || ~((env_sprev_18 && ~adder1_sel) || (env_fprev_18 && adder1_sel)));
assign path270_io6_out_unsync = ric12_a0 ?
    (adder3_of && adder3_o4) :
    ~(env_flag_r_0 || ~((env_sprev_17 && ~adder1_sel) || (env_fprev_17 && adder1_sel)));
assign path255_io5_out_unsync = ric12_a0 ?
    ~adder3_o3 :
    (env_flag_r_0 || ~((env_sprev_16 && ~adder1_sel) || (env_fprev_16 && adder1_sel)));
assign path256_io4_out_unsync = ric12_a0 ?
    adder3_o2 :
    ~(env_flag_r_0 || ~((env_sprev_15 && ~adder1_sel) || (env_fprev_15 && adder1_sel)));
assign path257_io3_out_unsync = ric12_a0 ?
    ~adder3_o1 :
    (env_flag_r_0 || ~((env_sprev_14 && ~adder1_sel) || (env_fprev_14 && adder1_sel)));


assign adder2_b0 = ~env_dest_r_0;
assign adder2_b1 = ~env_dest_r_1;
assign adder2_b2 = ~env_dest_r_2;
assign adder2_b3 = ~env_dest_r_3;
assign adder2_b4 = ~env_dest_r_4;
assign adder2_b5 = ~env_dest_r_5;
assign adder2_b6 = ~env_dest_r_6;
assign adder2_b7 = ~env_dest_r_7;
// Adder 2
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
  unconnected_H69_S1, // OUTPUT S1
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
  adder2_of, // OUTPUT CO
  unconnected_G68_S4, // OUTPUT S4
  unconnected_G68_S3, // OUTPUT S3
  unconnected_G68_S2, // OUTPUT S2
  unconnected_G68_S1, // OUTPUT S1
);







// TODO

cell_FDQ D96 ( // 4-bit DFF
  g269, // INPUT CK
  path122, // INPUT DA
  path121, // INPUT DB
  path120, // INPUT DC
  path393, // INPUT DD
  env_dest_r_7, // OUTPUT QA
  env_dest_r_6, // OUTPUT QB
  env_dest_r_5, // OUTPUT QC
  env_dest_r_4, // OUTPUT QD
);
cell_FDQ F61 ( // 4-bit DFF
  g269, // INPUT CK
  path128, // INPUT DA
  path127, // INPUT DB
  path126, // INPUT DC
  path125, // INPUT DD
  env_dest_r_3, // OUTPUT QA
  env_dest_r_2, // OUTPUT QB
  env_dest_r_1, // OUTPUT QC
  env_dest_r_0, // OUTPUT QD
);

cell_LT2 A69 ( // 1-bit Data Latch
  g358_ric13_din_clock_1, // INPUT G
  RIC12_D0_IN, // INPUT D
  unconnected_A69_Q, // OUTPUT Q
  path356, // OUTPUT XQ
);

cell_FDQ B100 ( // 4-bit DFF
  path331, // INPUT CK
  RIC12_D3_IN, // INPUT DA
  RIC12_D2_IN, // INPUT DB
  RIC12_D1_IN, // INPUT DC
  RIC12_D0_IN, // INPUT DD
  env_offs_r_3, // OUTPUT QA
  env_offs_r_2, // OUTPUT QB
  env_offs_r_1, // OUTPUT QC
  env_offs_r_0, // OUTPUT QD
);
cell_FDQ A98 ( // 4-bit DFF
  path331, // INPUT CK
  RIC12_D7_IN, // INPUT DA
  RIC12_D6_IN, // INPUT DB
  RIC12_D5_IN, // INPUT DC
  RIC12_D4_IN, // INPUT DD
  env_offs_r_7, // OUTPUT QA
  env_offs_r_6, // OUTPUT QB
  env_offs_r_5, // OUTPUT QC
  env_offs_r_4, // OUTPUT QD
);

cell_FDM K87 ( // DFF
  g476_ric13_d_0_clock, // INPUT CK
  path356, // INPUT D
  env_flag_0, // OUTPUT XQ
  env_flag_r_0, // OUTPUT Q
);

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
  IO6_OUT, // OUTPUT PD
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
  unconnected_A4_PD, // OUTPUT PD
);

cell_LT4 A75 ( // 4-bit Data Latch
  g355_ram_latch_clock, // INPUT G
  RIC12_D7_IN, // INPUT DA
  RIC12_D6_IN, // INPUT DB
  RIC12_D5_IN, // INPUT DC
  RIC12_D4_IN, // INPUT DD
  unconnected_A75_NA, // OUTPUT NA
  path352_ric12_d7_in_unsync, // OUTPUT PA
  unconnected_A75_NB, // OUTPUT NB
  path351_ric12_d6_in_unsync, // OUTPUT PB
  unconnected_A75_NC, // OUTPUT NC
  path350_ric12_d5_in_unsync, // OUTPUT PC
  unconnected_A75_ND, // OUTPUT ND
  path349_ric12_d4_in_unsync, // OUTPUT PD
);

cell_LT4 K20 ( // 4-bit Data Latch
  g1207_ric12_ad3_10_clock, // INPUT G
  g1075_ric12_a7_rd, // INPUT DA
  path153_ric12_a8_rd, // INPUT DB
  g1142_ric12_a9_rd, // INPUT DC
  g893_ric12_a10_rd, // INPUT DD
  unconnected_K20_NA, // OUTPUT NA
  path499_ric12_a7_latch, // OUTPUT PA
  unconnected_K20_NB, // OUTPUT NB
  path498_ric12_a8_latch, // OUTPUT PB
  unconnected_K20_NC, // OUTPUT NC
  path497_ric12_a9_latch, // OUTPUT PC
  unconnected_K20_ND, // OUTPUT ND
  g496_ric12_a10_latch, // OUTPUT PD
);

cell_LT4 K3 ( // 4-bit Data Latch
  g1207_ric12_ad3_10_clock, // INPUT G
  g260_ric12_a3_1, // INPUT DA
  path133_ric12_a4_1, // INPUT DB
  path134_ric12_a5_1, // INPUT DC
  path379_ric12_a6_1, // INPUT DD
  unconnected_K3_NA, // OUTPUT NA
  path701_ric12_a3_latch, // OUTPUT PA
  unconnected_K3_NB, // OUTPUT NB
  g703_ric12_a4_latch, // OUTPUT PB
  unconnected_K3_NC, // OUTPUT NC
  path704_ric12_a5_latch, // OUTPUT PC
  unconnected_K3_ND, // OUTPUT ND
  g706_ric12_a6_latch, // OUTPUT PD
);

cell_LT4 K34 ( // 4-bit Data Latch
  write_1000_0, // INPUT G
  internal_al7, // INPUT DA
  internal_al6, // INPUT DB
  internal_al5, // INPUT DC
  internal_al4, // INPUT DD
  unconnected_K34_NA, // OUTPUT NA
  path1282_ric12_a6_2, // OUTPUT PA
  unconnected_K34_NB, // OUTPUT NB
  path891_ric12_a5_2, // OUTPUT PB
  unconnected_K34_NC, // OUTPUT NC
  path1077_ric12_a4_2, // OUTPUT PC
  unconnected_K34_ND, // OUTPUT ND
  path890_ric12_a3_2, // OUTPUT PD
);

cell_LT4 N61 ( // 4-bit Data Latch
  g476_ric13_d_0_clock, // INPUT G
  path1232, // INPUT DA
  g1082, // INPUT DB
  g7, // INPUT DC
  path1171, // INPUT DD
  unconnected_N61_NA, // OUTPUT NA
  path803, // OUTPUT PA
  unconnected_N61_NB, // OUTPUT NB
  path643, // OUTPUT PB
  unconnected_N61_NC, // OUTPUT NC
  path805, // OUTPUT PC
  unconnected_N61_ND, // OUTPUT ND
  path450, // OUTPUT PD
);

cell_LT4 N77 ( // 4-bit Data Latch
  g476_ric13_d_0_clock, // INPUT G
  g917, // INPUT DA
  path1241, // INPUT DB
  path1233, // INPUT DC
  path861, // INPUT DD
  unconnected_N77_NA, // OUTPUT NA
  path1313, // OUTPUT PA
  unconnected_N77_NB, // OUTPUT NB
  path862, // OUTPUT PB
  unconnected_N77_NC, // OUTPUT NC
  path1234, // OUTPUT PC
  unconnected_N77_ND, // OUTPUT ND
  path800, // OUTPUT PD
);

cell_LT4 N93 ( // 4-bit Data Latch
  g476_ric13_d_0_clock, // INPUT G
  path1149, // INPUT DA
  path864, // INPUT DB
  path1150, // INPUT DC
  path1242, // INPUT DD
  unconnected_N93_NA, // OUTPUT NA
  path1317, // OUTPUT PA
  unconnected_N93_NB, // OUTPUT NB
  path863, // OUTPUT PB
  unconnected_N93_NC, // OUTPUT NC
  path1315, // OUTPUT PC
  unconnected_N93_ND, // OUTPUT ND
  path789, // OUTPUT PD
);

cell_LT4 O108 ( // 4-bit Data Latch
  g358_ric13_din_clock_1, // INPUT G
  RIC13_D3_IN, // INPUT DA
  RIC13_D2_IN, // INPUT DB
  RIC13_D1_IN, // INPUT DC
  RIC13_D0_IN, // INPUT DD
  unconnected_O108_NA, // OUTPUT NA
  env_sprev_19, // OUTPUT PA
  unconnected_O108_NB, // OUTPUT NB
  env_sprev_18, // OUTPUT PB
  unconnected_O108_NC, // OUTPUT NC
  env_sprev_17, // OUTPUT PC
  unconnected_O108_ND, // OUTPUT ND
  env_sprev_16, // OUTPUT PD
);

cell_LT4 O61 ( // 4-bit Data Latch
  g124_ric13_din_clock_2, // INPUT G
  RIC13_D3_IN, // INPUT DA
  RIC13_D2_IN, // INPUT DB
  RIC13_D1_IN, // INPUT DC
  RIC13_D0_IN, // INPUT DD
  unconnected_O61_NA, // OUTPUT NA
  env_sprev_3, // OUTPUT PA
  unconnected_O61_NB, // OUTPUT NB
  env_sprev_2, // OUTPUT PB
  unconnected_O61_NC, // OUTPUT NC
  env_sprev_1, // OUTPUT PC
  unconnected_O61_ND, // OUTPUT ND
  env_sprev_0, // OUTPUT PD
);

cell_LT4 O75 ( // 4-bit Data Latch
  g355_ram_latch_clock, // INPUT G
  RIC13_D3_IN, // INPUT DA
  RIC13_D2_IN, // INPUT DB
  RIC13_D1_IN, // INPUT DC
  RIC13_D0_IN, // INPUT DD
  unconnected_O75_NA, // OUTPUT NA
  env_sprev_11, // OUTPUT PA
  unconnected_O75_NB, // OUTPUT NB
  env_sprev_10, // OUTPUT PB
  unconnected_O75_NC, // OUTPUT NC
  env_sprev_9, // OUTPUT PC
  unconnected_O75_ND, // OUTPUT ND
  env_sprev_8, // OUTPUT PD
);

cell_LT4 O95 ( // 4-bit Data Latch
  path1175, // INPUT G
  RIC13_D3_IN, // INPUT DA
  RIC13_D2_IN, // INPUT DB
  RIC13_D1_IN, // INPUT DC
  RIC13_D0_IN, // INPUT DD
  unconnected_O95_NA, // OUTPUT NA
  env_sprev_27, // OUTPUT PA
  unconnected_O95_NB, // OUTPUT NB
  env_sprev_26, // OUTPUT PB
  unconnected_O95_NC, // OUTPUT NC
  env_sprev_25, // OUTPUT PC
  unconnected_O95_ND, // OUTPUT ND
  env_sprev_24, // OUTPUT PD
);

cell_LT4 P92 ( // 4-bit Data Latch
  g476_ric13_d_0_clock, // INPUT G
  g1174, // INPUT DA
  g1224, // INPUT DB
  g1218, // INPUT DC
  g1237, // INPUT DD
  unconnected_P92_NA, // OUTPUT NA
  path1312, // OUTPUT PA
  unconnected_P92_NB, // OUTPUT NB
  path1222, // OUTPUT PB
  unconnected_P92_NC, // OUTPUT NC
  path1235, // OUTPUT PC
  unconnected_P92_ND, // OUTPUT ND
  path788, // OUTPUT PD
);

cell_LT4 Q107 ( // 4-bit Data Latch
  g476_ric13_d_0_clock, // INPUT G
  g362, // INPUT DA
  g1260, // INPUT DB
  g1220, // INPUT DC
  g1305, // INPUT DD
  unconnected_Q107_NA, // OUTPUT NA
  path1258_ric13_d3_0, // OUTPUT PA
  unconnected_Q107_NB, // OUTPUT NB
  path1221_ric13_d2_0, // OUTPUT PB
  unconnected_Q107_NC, // OUTPUT NC
  path1306_ric13_d1_0, // OUTPUT PC
  unconnected_Q107_ND, // OUTPUT ND
  path787_ric13_d0_0, // OUTPUT PD
);

cell_LT4 R107 ( // 4-bit Data Latch
  g358_ric13_din_clock_1, // INPUT G
  RIC13_D7_IN, // INPUT DA
  RIC13_D6_IN, // INPUT DB
  RIC13_D5_IN, // INPUT DC
  RIC13_D4_IN, // INPUT DD
  unconnected_R107_NA, // OUTPUT NA
  env_sprev_23, // OUTPUT PA
  unconnected_R107_NB, // OUTPUT NB
  env_sprev_22, // OUTPUT PB
  unconnected_R107_NC, // OUTPUT NC
  env_sprev_21, // OUTPUT PC
  unconnected_R107_ND, // OUTPUT ND
  env_sprev_20, // OUTPUT PD
);

cell_LT4 R61 ( // 4-bit Data Latch
  g476_ric13_d_0_clock, // INPUT G
  path808, // INPUT DA
  path807, // INPUT DB
  path757, // INPUT DC
  g755, // INPUT DD
  unconnected_R61_NA, // OUTPUT NA
  path804, // OUTPUT PA
  unconnected_R61_NB, // OUTPUT NB
  path644, // OUTPUT PB
  unconnected_R61_NC, // OUTPUT NC
  path806, // OUTPUT PC
  unconnected_R61_ND, // OUTPUT ND
  path456, // OUTPUT PD
);

cell_LT4 R93 ( // 4-bit Data Latch
  g355_ram_latch_clock, // INPUT G
  RIC13_D7_IN, // INPUT DA
  RIC13_D6_IN, // INPUT DB
  RIC13_D5_IN, // INPUT DC
  RIC13_D4_IN, // INPUT DD
  unconnected_R93_NA, // OUTPUT NA
  env_sprev_15, // OUTPUT PA
  unconnected_R93_NB, // OUTPUT NB
  env_sprev_14, // OUTPUT PB
  unconnected_R93_NC, // OUTPUT NC
  env_sprev_13, // OUTPUT PC
  unconnected_R93_ND, // OUTPUT ND
  env_sprev_12, // OUTPUT PD
);

cell_LT4 S106 ( // 4-bit Data Latch
  g124_ric13_din_clock_2, // INPUT G
  RIC13_D7_IN, // INPUT DA
  RIC13_D6_IN, // INPUT DB
  RIC13_D5_IN, // INPUT DC
  RIC13_D4_IN, // INPUT DD
  unconnected_S106_NA, // OUTPUT NA
  env_sprev_7, // OUTPUT PA
  unconnected_S106_NB, // OUTPUT NB
  env_sprev_6, // OUTPUT PB
  unconnected_S106_NC, // OUTPUT NC
  env_sprev_5, // OUTPUT PC
  unconnected_S106_ND, // OUTPUT ND
  env_sprev_4, // OUTPUT PD
);

cell_LT4 T17 ( // 4-bit Data Latch
  write_1000_1, // INPUT G
  P33_IN, // INPUT DA
  P32_IN, // INPUT DB
  P31_IN, // INPUT DC
  P30_IN, // INPUT DD
  path347_ric12_d3_2, // OUTPUT NA
  unconnected_T17_PA, // OUTPUT PA
  path361_ric12_d2_2, // OUTPUT NB
  unconnected_T17_PB, // OUTPUT PB
  path362_ric12_d1_2, // OUTPUT NC
  unconnected_T17_PC, // OUTPUT PC
  g846_ric12_d0_2, // OUTPUT ND
  unconnected_T17_PD, // OUTPUT PD
);

cell_LT4 T4 ( // 4-bit Data Latch
  g491_address_strobe_synced, // INPUT G
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
  AL0_OUT, // OUTPUT PD
);

cell_LT4 T33 ( // 4-bit Data Latch
  write_1000_0, // INPUT G
  P33_IN, // INPUT DA
  P32_IN, // INPUT DB
  P31_IN, // INPUT DC
  P30_IN, // INPUT DD
  path348_ric12_d3_1, // OUTPUT NA
  unconnected_T33_PA, // OUTPUT PA
  path364_ric12_d2_1, // OUTPUT NB
  unconnected_T33_PB, // OUTPUT PB
  path363_ric12_d1_1, // OUTPUT NC
  unconnected_T33_PC, // OUTPUT PC
  path365_ric12_d0_1, // OUTPUT ND
  unconnected_T33_PD, // OUTPUT PD
);

cell_LT4 B61 ( // 4-bit Data Latch
  g355_ram_latch_clock, // INPUT G
  RIC12_D3_IN, // INPUT DA
  RIC12_D2_IN, // INPUT DB
  RIC12_D1_IN, // INPUT DC
  RIC12_D0_IN, // INPUT DD
  unconnected_B61_NA, // OUTPUT NA
  path132, // OUTPUT PA
  unconnected_B61_NB, // OUTPUT NB
  path131, // OUTPUT PB
  unconnected_B61_NC, // OUTPUT NC
  path130, // OUTPUT PC
  unconnected_B61_ND, // OUTPUT ND
  path129, // OUTPUT PD
);

cell_LT4 B74 ( // 4-bit Data Latch
  g124_ric13_din_clock_2, // INPUT G
  RIC12_D3_IN, // INPUT DA
  RIC12_D2_IN, // INPUT DB
  RIC12_D1_IN, // INPUT DC
  RIC12_D0_IN, // INPUT DD
  unconnected_B74_NA, // OUTPUT NA
  path128, // OUTPUT PA
  unconnected_B74_NB, // OUTPUT NB
  path127, // OUTPUT PB
  unconnected_B74_NC, // OUTPUT NC
  path126, // OUTPUT PC
  unconnected_B74_ND, // OUTPUT ND
  path125, // OUTPUT PD
);

cell_LT4 B87 ( // 4-bit Data Latch
  g124_ric13_din_clock_2, // INPUT G
  RIC12_D7_IN, // INPUT DA
  RIC12_D6_IN, // INPUT DB
  RIC12_D5_IN, // INPUT DC
  RIC12_D4_IN, // INPUT DD
  unconnected_B87_NA, // OUTPUT NA
  path122, // OUTPUT PA
  unconnected_B87_NB, // OUTPUT NB
  path121, // OUTPUT PB
  unconnected_B87_NC, // OUTPUT NC
  path120, // OUTPUT PC
  unconnected_B87_ND, // OUTPUT ND
  path393, // OUTPUT PD
);

cell_LT4 U31 ( // 4-bit Data Latch
  write_1000_1, // INPUT G
  P37_IN, // INPUT DA
  P36_IN, // INPUT DB
  P35_IN, // INPUT DC
  P34_IN, // INPUT DD
  path333_ric12_d7_2, // OUTPUT NA
  unconnected_U31_PA, // OUTPUT PA
  path367_ric12_d6_2, // OUTPUT NB
  unconnected_U31_PB, // OUTPUT PB
  path345_ric12_d5_2, // OUTPUT NC
  unconnected_U31_PC, // OUTPUT PC
  g385_ric12_d4_2, // OUTPUT ND
  unconnected_U31_PD, // OUTPUT PD
);

cell_LT4 V33 ( // 4-bit Data Latch
  g491_address_strobe_synced, // INPUT G
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
  AL4_OUT, // OUTPUT PD
);

cell_LT4 V48 ( // 4-bit Data Latch
  write_1000_0, // INPUT G
  P37_IN, // INPUT DA
  P36_IN, // INPUT DB
  P35_IN, // INPUT DC
  P34_IN, // INPUT DD
  path344_ric12_d7_1, // OUTPUT NA
  unconnected_V48_PA, // OUTPUT PA
  g345_ric12_d6_1, // OUTPUT NB
  unconnected_V48_PB, // OUTPUT PB
  path346_ric12_d5_1, // OUTPUT NC
  unconnected_V48_PC, // OUTPUT PC
  path360_ric12_d4_1, // OUTPUT ND
  unconnected_V48_PD, // OUTPUT PD
);

cell_LT4 V61 ( // 4-bit Data Latch
  write_1000_0, // INPUT G
  P43_IN, // INPUT DA
  P42_IN, // INPUT DB
  P41_IN, // INPUT DC
  P40_IN, // INPUT DD
  unconnected_V61_NA, // OUTPUT NA
  path482_ric12_a10_wr, // OUTPUT PA
  unconnected_V61_NB, // OUTPUT NB
  path481_ric12_a9_wr, // OUTPUT PB
  unconnected_V61_NC, // OUTPUT NC
  path154_ric12_a8_wr, // OUTPUT PC
  unconnected_V61_ND, // OUTPUT ND
  path480_ric12_a7_wr, // OUTPUT PD
);

cell_LT4 V78 ( // 4-bit Data Latch
  g476_ric13_d_0_clock, // INPUT G
  g469, // INPUT DA
  g466, // INPUT DB
  g425, // INPUT DC
  g429, // INPUT DD
  unconnected_V78_NA, // OUTPUT NA
  path467_ric13_d7_0, // OUTPUT PA
  unconnected_V78_NB, // OUTPUT NB
  path464_ric13_d6_0, // OUTPUT PB
  unconnected_V78_NC, // OUTPUT NC
  path463_ric13_d5_0, // OUTPUT PC
  unconnected_V78_ND, // OUTPUT ND
  path462_ric13_d4_0, // OUTPUT PD
);

assign g1291 = ~(~UNK_75_IN || path1078);
cell_FDQ S10 ( // 4-bit DFF
  g1291, // INPUT CK
  path701_ric12_a3_latch, // INPUT DA
  g703_ric12_a4_latch, // INPUT DB
  path704_ric12_a5_latch, // INPUT DC
  g706_ric12_a6_latch, // INPUT DD
  P30_OUT, // OUTPUT QA
  P31_OUT, // OUTPUT QB
  P32_OUT, // OUTPUT QC
  P33_OUT, // OUTPUT QD
);

cell_FDQ V10 ( // 4-bit DFF
  g1291, // INPUT CK
  path499_ric12_a7_latch, // INPUT DA
  path498_ric12_a8_latch, // INPUT DB
  path497_ric12_a9_latch, // INPUT DC
  g496_ric12_a10_latch, // INPUT DD
  P34_OUT, // OUTPUT QA
  P35_OUT, // OUTPUT QB
  P36_OUT, // OUTPUT QC
  P37_OUT, // OUTPUT QD
);

cell_FDQ D66 ( // 4-bit DFF
  g269, // INPUT CK
  path132, // INPUT DA
  path131, // INPUT DB
  path130, // INPUT DC
  path129, // INPUT DD
  env_speed_3, // OUTPUT QA
  env_speed_2, // OUTPUT QB
  env_speed_1, // OUTPUT QC
  env_speed_0, // OUTPUT QD
);

cell_FDQ F94 ( // 4-bit DFF
  g269, // INPUT CK
  path352_ric12_d7_in_unsync, // INPUT DA
  path351_ric12_d6_in_unsync, // INPUT DB
  path350_ric12_d5_in_unsync, // INPUT DC
  path349_ric12_d4_in_unsync, // INPUT DD
  env_speed_7, // OUTPUT QA
  env_speed_6, // OUTPUT QB
  env_speed_5, // OUTPUT QC
  env_speed_4, // OUTPUT QD
);


// Useless counter
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
  io1_inv, // OUTPUT QC
  unconnected_C13_QD, // OUTPUT QD
);


cell_LT2 K48 ( // 1-bit Data Latch
  write_1000_0, // INPUT G
  internal_al2, // INPUT D
  g158_ric12_a2_rd, // OUTPUT Q
  unconnected_K48_XQ, // OUTPUT XQ
);

cell_LT2 K52 ( // 1-bit Data Latch
  write_1000_0, // INPUT G
  internal_al1, // INPUT D
  g162_ric12_a1_rd, // OUTPUT Q
  unconnected_K52_XQ, // OUTPUT XQ
);

cell_FDM L115 ( // DFF
  g1227, // INPUT CK
  g1082, // INPUT D
  env_fprev_22, // OUTPUT XQ
  unconnected_L115_Q, // OUTPUT Q
);

cell_FDM L61 ( // DFF
  g1227, // INPUT CK
  path1171, // INPUT D
  env_fprev_20, // OUTPUT XQ
  unconnected_L61_Q, // OUTPUT Q
);

cell_FDM L67 ( // DFF
  g1227, // INPUT CK
  path861, // INPUT D
  env_fprev_16, // OUTPUT XQ
  unconnected_L67_Q, // OUTPUT Q
);

cell_FDM L75 ( // DFF
  g1227, // INPUT CK
  path1233, // INPUT D
  env_fprev_17, // OUTPUT XQ
  unconnected_L75_Q, // OUTPUT Q
);

cell_FDM L81 ( // DFF
  g1227, // INPUT CK
  path1241, // INPUT D
  env_fprev_18, // OUTPUT XQ
  unconnected_L81_Q, // OUTPUT Q
);

cell_FDM L87 ( // DFF
  g1227, // INPUT CK
  g917, // INPUT D
  env_fprev_19, // OUTPUT XQ
  unconnected_L87_Q, // OUTPUT Q
);

cell_FDM L100 ( // DFF
  g1227, // INPUT CK
  g7, // INPUT D
  env_fprev_21, // OUTPUT XQ
  unconnected_L100_Q, // OUTPUT Q
);

cell_FDM M114 ( // DFF
  g1227, // INPUT CK
  path864, // INPUT D
  env_fprev_26, // OUTPUT XQ
  unconnected_M114_Q, // OUTPUT Q
);

cell_FDM M61 ( // DFF
  g1227, // INPUT CK
  path807, // INPUT D
  env_fprev_14, // OUTPUT XQ
  unconnected_M61_Q, // OUTPUT Q
);

cell_FDM M67 ( // DFF
  g1227, // INPUT CK
  path808, // INPUT D
  env_fprev_15, // OUTPUT XQ
  unconnected_M67_Q, // OUTPUT Q
);

cell_FDM M75 ( // DFF
  g1227, // INPUT CK
  path1232, // INPUT D
  env_fprev_23, // OUTPUT XQ
  unconnected_M75_Q, // OUTPUT Q
);

cell_FDM M81 ( // DFF
  g1227, // INPUT CK
  path1242, // INPUT D
  env_fprev_24, // OUTPUT XQ
  unconnected_M81_Q, // OUTPUT Q
);

cell_FDM M89 ( // DFF
  g1227, // INPUT CK
  path1150, // INPUT D
  env_fprev_25, // OUTPUT XQ
  unconnected_M89_Q, // OUTPUT Q
);

cell_FDM M95 ( // DFF
  g1227, // INPUT CK
  path1149, // INPUT D
  env_fprev_27, // OUTPUT XQ
  unconnected_M95_Q, // OUTPUT Q
);

cell_FDM P63 ( // DFF
  g439, // INPUT CK
  g1218, // INPUT D
  env_fprev_9, // OUTPUT XQ
  unconnected_P63_Q, // OUTPUT Q
);

cell_FDM P69 ( // DFF
  g439, // INPUT CK
  g1224, // INPUT D
  env_fprev_10, // OUTPUT XQ
  unconnected_P69_Q, // OUTPUT Q
);

cell_FDM P81 ( // DFF
  g439, // INPUT CK
  g1174, // INPUT D
  env_fprev_11, // OUTPUT XQ
  unconnected_P81_Q, // OUTPUT Q
);

cell_FDM Q63 ( // DFF
  g439, // INPUT CK
  g1237, // INPUT D
  env_fprev_8, // OUTPUT XQ
  unconnected_Q63_Q, // OUTPUT Q
);

cell_FDM Q76 ( // DFF
  g439, // INPUT CK
  g1260, // INPUT D
  env_fprev_2, // OUTPUT XQ
  unconnected_Q76_Q, // OUTPUT Q
);

cell_FDM Q82 ( // DFF
  g439, // INPUT CK
  g362, // INPUT D
  env_fprev_3, // OUTPUT XQ
  unconnected_Q82_Q, // OUTPUT Q
);

cell_FDM Q93 ( // DFF
  g439, // INPUT CK
  g1305, // INPUT D
  env_fprev_0, // OUTPUT XQ
  unconnected_Q93_Q, // OUTPUT Q
);

cell_FDM Q99 ( // DFF
  g439, // INPUT CK
  g1220, // INPUT D
  env_fprev_1, // OUTPUT XQ
  unconnected_Q99_Q, // OUTPUT Q
);

cell_FDM S61 ( // DFF
  g439, // INPUT CK
  g755, // INPUT D
  env_fprev_12, // OUTPUT XQ
  unconnected_S61_Q, // OUTPUT Q
);

cell_FDM S67 ( // DFF
  g439, // INPUT CK
  path757, // INPUT D
  env_fprev_13, // OUTPUT XQ
  unconnected_S67_Q, // OUTPUT Q
);

cell_FDM S73 ( // DFF
  g439, // INPUT CK
  g466, // INPUT D
  env_fprev_6, // OUTPUT XQ
  unconnected_S73_Q, // OUTPUT Q
);

cell_FDM S85 ( // DFF
  g439, // INPUT CK
  g469, // INPUT D
  env_fprev_7, // OUTPUT XQ
  unconnected_S85_Q, // OUTPUT Q
);

cell_FDM S99 ( // DFF
  g439, // INPUT CK
  g425, // INPUT D
  env_fprev_5, // OUTPUT XQ
  unconnected_S99_Q, // OUTPUT Q
);

cell_FDM V99 ( // DFF
  g439, // INPUT CK
  g429, // INPUT D
  env_fprev_4, // OUTPUT XQ
  unconnected_V99_Q, // OUTPUT Q
);

cell_FDM G40 ( // DFF
  path883, // INPUT CK
  path881, // INPUT D
  path880, // OUTPUT XQ
  g1116, // OUTPUT Q
);

cell_unkf P28 ( // Unknown F
  AS_IN, // INPUT I
  unconnected_P28_XA, // OUTPUT XA
  g491_address_strobe_synced, // OUTPUT XB
);

cell_FDP G12 ( // DFF with SET and RESET
  write_1000_0, // INPUT CK
  E_IN, // INPUT D
  path914, // INPUT R
  UNK_74_IN, // INPUT S
  path881, // OUTPUT Q
  unconnected_G12_XQ, // OUTPUT XQ
);

assign irq_should = ~(~((env_speed_6 || env_speed_5 || env_speed_4 || env_speed_3) && (env_speed_2 || env_speed_1 || env_speed_0 || GND)) || ~((adder1_of ^ env_speed_7) || (env_speed_7 ^ adder2_of)));

assign g878 = irq_should;
cell_FJD G20 ( // Positive Edge Clocked Power JKFF with CLEAR
  path882, // INPUT CK
  g878, // INPUT J
  GND, // INPUT K
  path880, // INPUT CL
  path1078, // OUTPUT Q
  path879, // OUTPUT XQ
);
assign IRQ_OUT = ~(~(~irq_should) && ~(~path1078));

assign path1171 = ~((adder1_o20 && ~irq_should) || (env_dest_r_0 && irq_should));
assign g7 = ~((adder1_o21 && ~irq_should) || (env_dest_r_1 && irq_should));
assign g1082 = ~((adder1_o22 && ~irq_should) || (env_dest_r_2 && irq_should));
assign path1232 = ~((adder1_o23 && ~irq_should) || (env_dest_r_3 && irq_should));
assign path1242 = ~((adder1_o24 && ~irq_should) || (env_dest_r_4 && irq_should));
assign path1150 = ~((adder1_o25 && ~irq_should) || (env_dest_r_5 && irq_should));
assign path864 = ~((adder1_o26 && ~irq_should) || (env_dest_r_6 && irq_should));
assign path1149 = ~((adder1_o27 && ~irq_should) || (env_dest_r_7 && irq_should));

assign g1174 = ~(path1059 && ~irq_should);
assign g1218 = ~(path1318 && ~irq_should);
assign g1220 = ~(path653 && ~irq_should);
assign g1224 = ~(path1058 && ~irq_should);
assign g1237 = ~(path1216 && ~irq_should);
assign g1260 = ~(path655 && ~irq_should);
assign g1305 = ~(path651 && ~irq_should);
assign g362 = ~(path657 && ~irq_should);
assign g425 = ~(path426 && ~irq_should);
assign g429 = ~(path440 && ~irq_should);
assign g466 = ~(path478 && ~irq_should);
assign g469 = ~(path640 && ~irq_should);
assign g755 = ~(path1106 && ~irq_should);
assign g917 = ~(path915 && ~irq_should);
assign path1233 = ~(path1248 && ~irq_should);
assign path1241 = ~(path1240 && ~irq_should);
assign path757 = ~(path1076 && ~irq_should);
assign path807 = ~(path1283 && ~irq_should);
assign path808 = ~(path1284 && ~irq_should);
assign path861 = ~(path860 && ~irq_should);


assign AL0_IOM = UNK_74_IN && ~AL_CT_76_IN;
assign IO1_OUT = ~io1_inv;
assign P32_IOM = ~(~(P47_IN || P46_IN) && P45_IN && P44_IN && RW_IN && ~(E_IN ^ E_NOR_77_IN)) && UNK_74_IN;
assign PARAM_ROMCS_OUT = ~(P47_IN ^ P46_IN) || RD_OUT;
assign RAMCS_OUT = ~(~(P47_IN || P46_IN) && P45_IN && ~P44_IN);
assign RD_OUT = ~(RW_IN && E_IN);
assign WR_OUT = ~(~RW_IN && E_IN);


assign tmp_st_0 = ~(ric12_read_stage && ~g156_ric12_a2_rd && ~g160_ric12_a1_rd && ric12_a0);  // 0b1001 1
assign tmp_st_1 = ~(ric12_read_stage && ~g156_ric12_a2_rd && ~g160_ric12_a1_rd && ~ric12_a0); // 0b1000 0
assign tmp_st_2 = ~(~ric12_read_stage && g156_ric12_a2_rd && ~g160_ric12_a1_rd && ric12_a0);  // 0b0101 5

// all but 0/1w and 5r
assign path378 = tmp_st_0 && tmp_st_1 && tmp_st_2;
cell_FDM B1 ( // DFF
  cycle_between, // INPUT CK
  path378, // INPUT D
  unconnected_B1_XQ, // OUTPUT XQ
  ric12_read_part, // OUTPUT Q
);

// not on 1w, if the address sub is 6 or 7
assign w_addr_6_7 = g162_ric12_a1_rd && g158_ric12_a2_rd;
assign path991 = ~(tmp_st_0 && (tmp_st_1 || w_addr_6_7));
cell_FDM F7 ( // DFF
  cycle_between, // INPUT CK
  path991, // INPUT D
  nconnected_F7_XQ, // OUTPUT XQ
  ric12_write_part, // OUTPUT Q
);

// sub
assign RIC12_A0_OUT = ~((ric12_a0 && ~path852_ric12_rd_1) || (~ric12_a0 && RIC12_OE_OUT));
assign RIC12_A1_OUT = ~((g160_ric12_a1_rd && ~path852_ric12_rd_1) || (g162_ric12_a1_rd && RIC12_OE_OUT));
assign RIC12_A2_OUT = ~((g156_ric12_a2_rd && ~path852_ric12_rd_1) || (g158_ric12_a2_rd && RIC12_OE_OUT));
// part
assign RIC12_A3_OUT = (g260_ric12_a3_1 && ric12_read_part) || (path890_ric12_a3_2 && ric12_write_part);
assign RIC12_A4_OUT = (path133_ric12_a4_1 && ric12_read_part) || (path1077_ric12_a4_2 && ric12_write_part);
assign RIC12_A5_OUT = (path134_ric12_a5_1 && ric12_read_part) || (path891_ric12_a5_2 && ric12_write_part);
assign RIC12_A6_OUT = (path379_ric12_a6_1 && ric12_read_part) || (path1282_ric12_a6_2 && ric12_write_part);
// voice
assign RIC12_A7_OUT = ~((g1075_ric12_a7_rd && ~path852_ric12_rd_1) || (path480_ric12_a7_wr && RIC12_OE_OUT));
assign RIC12_A8_OUT = ~((path153_ric12_a8_rd && ~path852_ric12_rd_1) || (path154_ric12_a8_wr && RIC12_OE_OUT));
assign RIC12_A9_OUT = ~((g1142_ric12_a9_rd && ~path852_ric12_rd_1) || (path481_ric12_a9_wr && RIC12_OE_OUT));
assign RIC12_A10_OUT = ~((g893_ric12_a10_rd && ~path852_ric12_rd_1) || (path482_ric12_a10_wr && RIC12_OE_OUT));

assign RIC12_D0_OUT = ~((path365_ric12_d0_1 && ~ric12_a0) || (g846_ric12_d0_2 && ric12_a0));
assign RIC12_D1_OUT = ~((path363_ric12_d1_1 && ~ric12_a0) || (path362_ric12_d1_2 && ric12_a0));
assign RIC12_D2_OUT = ~((path364_ric12_d2_1 && ~ric12_a0) || (path361_ric12_d2_2 && ric12_a0));
assign RIC12_D3_OUT = ~((path348_ric12_d3_1 && ~ric12_a0) || (path347_ric12_d3_2 && ric12_a0));
assign RIC12_D4_OUT = ~((path360_ric12_d4_1 && ~ric12_a0) || (g385_ric12_d4_2 && ric12_a0));
assign RIC12_D5_OUT = ~((path346_ric12_d5_1 && ~ric12_a0) || (path345_ric12_d5_2 && ric12_a0));
assign RIC12_D6_OUT = ~((g345_ric12_d6_1 && ~ric12_a0) || (path367_ric12_d6_2 && ric12_a0));
assign RIC12_D7_IOM = ~path852_ric12_rd_1 && UNK_74_IN;
assign RIC12_D7_OUT = ~((path344_ric12_d7_1 && ~ric12_a0) || (path333_ric12_d7_2 && ric12_a0));

assign ram12_write_mode = ~(tmp_st_0 && tmp_st_1);
cell_FDM C4 ( // DFF
  cycle_between, // INPUT CK
  ram12_write_mode, // INPUT D
  path145_ric12_oe_inv, // OUTPUT XQ
  path852_ric12_rd_1, // OUTPUT Q
);
assign RIC12_OE_OUT = ~path145_ric12_oe_inv;
assign RIC12_WE_OUT = ~(~((g1057_8dec_out1 || SYNC_IN || ~g300_step_counter_d) && (g1041_8dec_out2 || SYNC_IN || ~g300_step_counter_d)) && g1116);

cell_DE2 N115 ( // 2:4 Decoder
  g160_ric12_a1_rd, // INPUT A
  ric12_a0, // INPUT B
  g461_ric13_d_0, // OUTPUT X0
  g455_ric13_d_1, // OUTPUT X1
  g448_ric13_d_2, // OUTPUT X2
  g444_ric13_d_3, // OUTPUT X3
);
assign RIC13_D0_OUT = (~path787_ric13_d0_0 && ~g461_ric13_d_0) || (~path788 && ~g455_ric13_d_1) || (~path800 && ~g448_ric13_d_2) || (~path789 && ~g444_ric13_d_3);
assign RIC13_D1_OUT = (~path1306_ric13_d1_0 && ~g461_ric13_d_0) || (~path1235 && ~g455_ric13_d_1) || (~path1234 && ~g448_ric13_d_2) || (~path1315 && ~g444_ric13_d_3);
assign RIC13_D2_OUT = (~path1221_ric13_d2_0 && ~g461_ric13_d_0) || (~path1222 && ~g455_ric13_d_1) || (~path862 && ~g448_ric13_d_2) || (~path863 && ~g444_ric13_d_3);
assign RIC13_D3_OUT = (~path1258_ric13_d3_0 && ~g461_ric13_d_0) || (~path1312 && ~g455_ric13_d_1) || (~path1313 && ~g448_ric13_d_2) || (~path1317 && ~g444_ric13_d_3);
assign RIC13_D4_OUT = (~path462_ric13_d4_0 && ~g461_ric13_d_0) || (~path456 && ~g455_ric13_d_1) || (~path450 && ~g448_ric13_d_2) || (~VCC && ~g444_ric13_d_3);
assign RIC13_D5_OUT = (~path463_ric13_d5_0 && ~g461_ric13_d_0) || (~path806 && ~g455_ric13_d_1) || (~path805 && ~g448_ric13_d_2) || (~VCC && ~g444_ric13_d_3);
assign RIC13_D6_OUT = (~path464_ric13_d6_0 && ~g461_ric13_d_0) || (~path644 && ~g455_ric13_d_1) || (~path643 && ~g448_ric13_d_2) || (~VCC && ~g444_ric13_d_3);
assign RIC13_D7_OUT = (~path467_ric13_d7_0 && ~g461_ric13_d_0) || (~path804 && ~g455_ric13_d_1) || (~path803 && ~g448_ric13_d_2) || (~VCC && ~g444_ric13_d_3);

assign RIC13_D4_IOM = UNK_74_IN && ~(ric12_read_stage && g156_ric12_a2_rd);


// Cycle counter
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
  g300_step_counter_d, // OUTPUT QD
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
  g1209_8dec_out7, // OUTPUT X7
);
assign g1207_ric12_ad3_10_clock = g1055_8dec_out0 || SYNC_IN || ~g300_step_counter_d;
assign g1034 = g1057_8dec_out1 || SYNC_IN || ~g300_step_counter_d;
assign g1039 = g1057_8dec_out1 || SYNC_IN || g300_step_counter_d;
assign g1227 = (g1057_8dec_out1 || SYNC_IN || g300_step_counter_d) && (g1215_8dec_out3 || SYNC_IN || g300_step_counter_d) && (g1049_8dec_out5 || SYNC_IN || g300_step_counter_d) && (g1209_8dec_out7 || SYNC_IN || g300_step_counter_d) && (g1057_8dec_out1 || SYNC_IN || ~g300_step_counter_d) && (g1215_8dec_out3 || SYNC_IN || ~g300_step_counter_d) && (g1049_8dec_out5 || SYNC_IN || ~g300_step_counter_d) && (g1209_8dec_out7 || SYNC_IN || ~g300_step_counter_d);
assign g439 = (g1057_8dec_out1 || SYNC_IN || g300_step_counter_d) && (g1215_8dec_out3 || SYNC_IN || g300_step_counter_d) && (g1049_8dec_out5 || SYNC_IN || g300_step_counter_d) && (g1209_8dec_out7 || SYNC_IN || g300_step_counter_d) && (g1057_8dec_out1 || SYNC_IN || ~g300_step_counter_d) && (g1215_8dec_out3 || SYNC_IN || ~g300_step_counter_d) && (g1049_8dec_out5 || SYNC_IN || ~g300_step_counter_d) && (g1209_8dec_out7 || SYNC_IN || ~g300_step_counter_d);
assign path882 = (g1057_8dec_out1 || SYNC_IN || g300_step_counter_d) && (g1215_8dec_out3 || SYNC_IN || g300_step_counter_d) && (g1049_8dec_out5 || SYNC_IN || g300_step_counter_d) && (g1209_8dec_out7 || SYNC_IN || g300_step_counter_d) && (g1057_8dec_out1 || SYNC_IN || ~g300_step_counter_d) && (g1215_8dec_out3 || SYNC_IN || ~g300_step_counter_d) && (g1049_8dec_out5 || SYNC_IN || ~g300_step_counter_d) && (g1209_8dec_out7 || SYNC_IN || ~g300_step_counter_d);
assign path914 = ~(g1116 && ~(g1057_8dec_out1 || SYNC_IN || ~g300_step_counter_d));
assign g124_ric13_din_clock_2 = (g1213_8dec_out4 || SYNC_IN || g300_step_counter_d) ^ VCC ^ VCC;
assign g269 = ~(g1209_8dec_out7 || SYNC_IN || g300_step_counter_d);
assign g355_ram_latch_clock = (g1049_8dec_out5 || SYNC_IN || g300_step_counter_d) ^ VCC ^ VCC;
assign g358_ric13_din_clock_1 = (g1051_8dec_out6 || SYNC_IN || g300_step_counter_d) ^ VCC ^ VCC;
assign g476_ric13_d_0_clock = g1209_8dec_out7 || SYNC_IN || g300_step_counter_d;
assign path1175 = (g1209_8dec_out7 || SYNC_IN || g300_step_counter_d) ^ VCC ^ VCC;
assign path1211 = g1055_8dec_out0 || SYNC_IN || g300_step_counter_d;
assign path331 = ~(~(g1209_8dec_out7 || SYNC_IN || g300_step_counter_d) ^ VCC);
assign path883 = ~(g1055_8dec_out0 || SYNC_IN || ~g300_step_counter_d);
assign cycle_between = ~(~((g1055_8dec_out0 || SYNC_IN || g300_step_counter_d) && (g1041_8dec_out2 || SYNC_IN || g300_step_counter_d) && (g1213_8dec_out4 || SYNC_IN || g300_step_counter_d) && (g1051_8dec_out6 || SYNC_IN || g300_step_counter_d) && (g1055_8dec_out0 || SYNC_IN || ~g300_step_counter_d) && (g1041_8dec_out2 || SYNC_IN || ~g300_step_counter_d) && (g1213_8dec_out4 || SYNC_IN || ~g300_step_counter_d) && (g1051_8dec_out6 || SYNC_IN || ~g300_step_counter_d)) || ~((g1057_8dec_out1 || SYNC_IN || g300_step_counter_d) && (g1215_8dec_out3 || SYNC_IN || g300_step_counter_d) && (g1049_8dec_out5 || SYNC_IN || g300_step_counter_d) && (g1209_8dec_out7 || SYNC_IN || g300_step_counter_d) && (g1057_8dec_out1 || SYNC_IN || ~g300_step_counter_d) && (g1215_8dec_out3 || SYNC_IN || ~g300_step_counter_d) && (g1049_8dec_out5 || SYNC_IN || ~g300_step_counter_d) && (g1209_8dec_out7 || SYNC_IN || ~g300_step_counter_d)));


assign internal_al1 = ~(~(AL1_OUT && AL_CT_76_IN) && ~(AL1_IN && ~AL_CT_76_IN));
assign internal_al2 = ~(~(AL2_OUT && AL_CT_76_IN) && ~(AL2_IN && ~AL_CT_76_IN));
assign internal_al4 = ~(~(AL4_OUT && AL_CT_76_IN) && ~(AL4_IN && ~AL_CT_76_IN));
assign internal_al5 = ~(~(AL5_OUT && AL_CT_76_IN) && ~(AL5_IN && ~AL_CT_76_IN));
assign internal_al6 = ~(~(AL6_OUT && AL_CT_76_IN) && ~(AL6_IN && ~AL_CT_76_IN));
assign internal_al7 = ~(~(AL7_OUT && AL_CT_76_IN) && ~(AL7_IN && ~AL_CT_76_IN));

assign write_1000_0 = ~(~(P47_IN || P46_IN) && P45_IN && P44_IN && ~(~(AL0_OUT && AL_CT_76_IN) && ~(AL0_IN && ~AL_CT_76_IN)) && ~RW_IN && E_IN);
assign write_1000_1 = ~(~(P47_IN || P46_IN) && P45_IN && P44_IN && ~(AL0_OUT && AL_CT_76_IN) && ~(AL0_IN && ~AL_CT_76_IN) && ~RW_IN && E_IN);
