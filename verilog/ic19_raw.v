// 1 instances
module cell_FJD ( // Positive Edge Clocked Power JKFF with CLEAR
  input wire CK,
  input wire J,
  input wire K,
  input wire CL,
  output wire XQ,
  output wire Q
);
endmodule

// 30 instances
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

// 1 instances
module cell_DE3 ( // 3:8 Decoder
  input wire B,
  input wire A,
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

// 8 instances
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

// 5 instances
module cell_C45 ( // 4-bit Binary Synchronous Up Counter
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

// 3 instances
module cell_LT2 ( // 1-bit Data Latch
  input wire G,
  input wire D,
  output wire Q,
  output wire XQ
);
endmodule

// 11 instances
module cell_A4H ( // 4-bit Full Adder
  input wire A4,
  input wire B4,
  input wire A3,
  input wire B3,
  input wire A2,
  input wire B2,
  input wire A1,
  input wire B1,
  input wire CI,
  output wire CO,
  output wire S4,
  output wire S3,
  output wire S2,
  output wire S1
);
endmodule

// 1 instances
module cell_DE2 ( // 2:4 Decoder
  input wire A,
  input wire B,
  output wire X0,
  output wire X1,
  output wire X2,
  output wire X3
);
endmodule

// 33 instances
module cell_FDM ( // DFF
  input wire CK,
  input wire D,
  output wire XQ,
  output wire Q
);
endmodule

// 1 instances
module cell_FDN ( // DFF with Set
  input wire CK,
  input wire D,
  input wire S,
  output wire Q,
  output wire XQ
);
endmodule

// 1 instances
module cell_FDO ( // DFF with Reset
  input wire CK,
  input wire D,
  input wire R,
  output wire Q,
  output wire XQ
);
endmodule

// 1 instances
module cell_unkf ( // Unknown F
  input wire I,
  output wire XA,
  output wire XB
);
endmodule

// 1 instances
module cell_FDP ( // DFF with SET and RESET
  input wire CK,
  input wire D,
  input wire R,
  input wire S,
  output wire Q,
  output wire XQ
);
endmodule




cell_FJD G20 ( // Positive Edge Clocked Power JKFF with CLEAR
  path882, // INPUT CK
  g878, // INPUT J
  GND, // INPUT K
  path880, // INPUT CL
  path1078, // OUTPUT XQ
  path879, // OUTPUT Q
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
  g1075_ric12_a7_wr, // INPUT DA
  path153_ric12_a8_wr, // INPUT DB
  g1142_ric12_a9_wr, // INPUT DC
  g893_ric12_a10_wr, // INPUT DD
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
  g487, // INPUT G
  path493, // INPUT DA
  g350, // INPUT DB
  path554, // INPUT DC
  g352, // INPUT DD
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
  path1170, // INPUT DC
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
  path944, // OUTPUT PA
  unconnected_O108_NB, // OUTPUT NB
  path933, // OUTPUT PB
  unconnected_O108_NC, // OUTPUT NC
  path934, // OUTPUT PC
  unconnected_O108_ND, // OUTPUT ND
  path982, // OUTPUT PD
);

cell_LT4 O61 ( // 4-bit Data Latch
  g124_ric13_din_clock_2, // INPUT G
  RIC13_D3_IN, // INPUT DA
  RIC13_D2_IN, // INPUT DB
  RIC13_D1_IN, // INPUT DC
  RIC13_D0_IN, // INPUT DD
  unconnected_O61_NA, // OUTPUT NA
  path1261, // OUTPUT PA
  unconnected_O61_NB, // OUTPUT NB
  path1301, // OUTPUT PB
  unconnected_O61_NC, // OUTPUT NC
  path1262, // OUTPUT PC
  unconnected_O61_ND, // OUTPUT ND
  path1178, // OUTPUT PD
);

cell_LT4 O75 ( // 4-bit Data Latch
  g355_ram_latch_clock, // INPUT G
  RIC13_D3_IN, // INPUT DA
  RIC13_D2_IN, // INPUT DB
  RIC13_D1_IN, // INPUT DC
  RIC13_D0_IN, // INPUT DD
  unconnected_O75_NA, // OUTPUT NA
  path1311, // OUTPUT PA
  unconnected_O75_NB, // OUTPUT NB
  path1310, // OUTPUT PB
  unconnected_O75_NC, // OUTPUT NC
  path1308, // OUTPUT PC
  unconnected_O75_ND, // OUTPUT ND
  path1300, // OUTPUT PD
);

cell_LT4 O95 ( // 4-bit Data Latch
  path1175, // INPUT G
  RIC13_D3_IN, // INPUT DA
  RIC13_D2_IN, // INPUT DB
  RIC13_D1_IN, // INPUT DC
  RIC13_D0_IN, // INPUT DD
  unconnected_O95_NA, // OUTPUT NA
  path1255, // OUTPUT PA
  unconnected_O95_NB, // OUTPUT NB
  path1257, // OUTPUT PB
  unconnected_O95_NC, // OUTPUT NC
  path1256, // OUTPUT PC
  unconnected_O95_ND, // OUTPUT ND
  path945, // OUTPUT PD
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
  path795, // OUTPUT PA
  unconnected_R107_NB, // OUTPUT NB
  path794, // OUTPUT PB
  unconnected_R107_NC, // OUTPUT NC
  path793, // OUTPUT PC
  unconnected_R107_ND, // OUTPUT ND
  path792, // OUTPUT PD
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
  path799, // OUTPUT PA
  unconnected_R93_NB, // OUTPUT NB
  path798, // OUTPUT PB
  unconnected_R93_NC, // OUTPUT NC
  path797, // OUTPUT PC
  unconnected_R93_ND, // OUTPUT ND
  path796, // OUTPUT PD
);

cell_LT4 S106 ( // 4-bit Data Latch
  g124_ric13_din_clock_2, // INPUT G
  RIC13_D7_IN, // INPUT DA
  RIC13_D6_IN, // INPUT DB
  RIC13_D5_IN, // INPUT DC
  RIC13_D4_IN, // INPUT DD
  unconnected_S106_NA, // OUTPUT NA
  path772, // OUTPUT PA
  unconnected_S106_NB, // OUTPUT NB
  path760, // OUTPUT PB
  unconnected_S106_NC, // OUTPUT NC
  path785, // OUTPUT PC
  unconnected_S106_ND, // OUTPUT ND
  path790, // OUTPUT PD
);

cell_LT4 T17 ( // 4-bit Data Latch
  g607, // INPUT G
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
  g487, // INPUT G
  P33_IN, // INPUT DA
  P32_IN, // INPUT DB
  P31_IN, // INPUT DC
  P30_IN, // INPUT DD
  path348_ric12_d3_1, // OUTPUT NA
  unconnected_T33_PA, // OUTPUT PA
  unconnected_T33_NB, // OUTPUT NB
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
  g607, // INPUT G
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
  g487, // INPUT G
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
  g487, // INPUT G
  P43_IN, // INPUT DA
  P42_IN, // INPUT DB
  P41_IN, // INPUT DC
  P40_IN, // INPUT DD
  unconnected_V61_NA, // OUTPUT NA
  path482_ric12_a10_rd, // OUTPUT PA
  unconnected_V61_NB, // OUTPUT NB
  path481_ric12_a9_rd, // OUTPUT PB
  unconnected_V61_NC, // OUTPUT NC
  path154_ric12_a8_rd, // OUTPUT PC
  unconnected_V61_ND, // OUTPUT ND
  path480_ric12_a7_rd, // OUTPUT PD
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

cell_FDQ A98 ( // 4-bit DFF
  path331, // INPUT CK
  RIC12_D7_IN, // INPUT DA
  RIC12_D6_IN, // INPUT DB
  RIC12_D5_IN, // INPUT DC
  RIC12_D4_IN, // INPUT DD
  path330, // OUTPUT QA
  path329, // OUTPUT QB
  path328, // OUTPUT QC
  path327, // OUTPUT QD
);

cell_FDQ S10 ( // 4-bit DFF
  g1291, // INPUT CK
  path701_ric12_a3_latch, // INPUT DA
  g703_ric12_a4_latch, // INPUT DB
  path704_ric12_a5_latch, // INPUT DC
  g706_ric12_a6_latch, // INPUT DD
  g5, // OUTPUT QA
  P31_OUT, // OUTPUT QB
  P32_OUT, // OUTPUT QC
  P33_OUT, // OUTPUT QD
);

cell_FDQ B100 ( // 4-bit DFF
  path331, // INPUT CK
  RIC12_D3_IN, // INPUT DA
  RIC12_D2_IN, // INPUT DB
  RIC12_D1_IN, // INPUT DC
  RIC12_D0_IN, // INPUT DD
  path392, // OUTPUT QA
  path391, // OUTPUT QB
  path390, // OUTPUT QC
  path389, // OUTPUT QD
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
  path1287, // OUTPUT QA
  g1004, // OUTPUT QB
  g1201, // OUTPUT QC
  g1094, // OUTPUT QD
);

cell_FDQ D96 ( // 4-bit DFF
  g269, // INPUT CK
  path122, // INPUT DA
  path121, // INPUT DB
  path120, // INPUT DC
  path393, // INPUT DD
  g1148, // OUTPUT QA
  g897, // OUTPUT QB
  path1121, // OUTPUT QC
  path1243, // OUTPUT QD
);

cell_FDQ F61 ( // 4-bit DFF
  g269, // INPUT CK
  path128, // INPUT DA
  path127, // INPUT DB
  path126, // INPUT DC
  path125, // INPUT DD
  path1140, // OUTPUT QA
  path1324, // OUTPUT QB
  g1163, // OUTPUT QC
  path1319, // OUTPUT QD
);

cell_FDQ F94 ( // 4-bit DFF
  g269, // INPUT CK
  path352_ric12_d7_in_unsync, // INPUT DA
  path351_ric12_d6_in_unsync, // INPUT DB
  path350_ric12_d5_in_unsync, // INPUT DC
  path349_ric12_d4_in_unsync, // INPUT DD
  path977, // OUTPUT QA
  path1165, // OUTPUT QB
  path1114, // OUTPUT QC
  path1250, // OUTPUT QD
);

cell_C45 B13 ( // 4-bit Binary Synchronous Up Counter
  GND, // INPUT DA
  g384_e7_coverflow_unk74block, // INPUT EN
  g384_e7_coverflow_unk74block, // INPUT CI
  path386, // INPUT CL
  g267, // INPUT DB
  g267, // INPUT L
  g377, // INPUT CK
  g374, // INPUT DC
  GND, // INPUT DD
  g260_ric12_a3_1, // OUTPUT QA
  path133_ric12_a4_1, // OUTPUT QB
  unconnected_B13_CO, // OUTPUT CO
  path134_ric12_a5_1, // OUTPUT QC
  path379_ric12_a6_1, // OUTPUT QD
);

cell_C45 C13 ( // 4-bit Binary Synchronous Up Counter
  VCC, // INPUT DA
  VCC, // INPUT EN
  VCC, // INPUT CI
  RESET_IN, // INPUT CL
  g267, // INPUT DB
  g267, // INPUT L
  E_IN, // INPUT CK
  g374, // INPUT DC
  g124_ric13_din_clock_2, // INPUT DD
  unconnected_C13_QA, // OUTPUT QA
  unconnected_C13_QB, // OUTPUT QB
  unconnected_C13_CO, // OUTPUT CO
  io1_inv, // OUTPUT QC
  unconnected_C13_QD, // OUTPUT QD
);

cell_C45 D13 ( // 4-bit Binary Synchronous Up Counter
  g1127, // INPUT DA
  VCC, // INPUT EN
  path385, // INPUT CI
  FSYNC_IN, // INPUT CL
  g267, // INPUT DB
  g267, // INPUT L
  g377, // INPUT CK
  g374, // INPUT DC
  g124_ric13_din_clock_2, // INPUT DD
  g1075_ric12_a7_wr, // OUTPUT QA
  path153_ric12_a8_wr, // OUTPUT QB
  unconnected_D13_CO, // OUTPUT CO
  g1142_ric12_a9_wr, // OUTPUT QC
  g893_ric12_a10_wr, // OUTPUT QD
);

cell_C45 E7 ( // 4-bit Binary Synchronous Up Counter
  VCC, // INPUT DA
  VCC, // INPUT EN
  GND, // INPUT CI
  FSYNC_IN, // INPUT CL
  VCC, // INPUT DB
  UNK_74_IN, // INPUT L
  g377, // INPUT CK
  VCC, // INPUT DC
  g345_ric12_d6_1, // INPUT DD
  path152_ric12_a0, // OUTPUT QA
  g160_ric12_a1_wr, // OUTPUT QB
  path1005_e7_coverflow, // OUTPUT CO
  g156_ric12_a2_wr, // OUTPUT QC
  path1006, // OUTPUT QD
);

cell_C45 F13 ( // 4-bit Binary Synchronous Up Counter
  g1127, // INPUT DA
  g1075_ric12_a7_wr, // INPUT EN
  VCC, // INPUT CI
  FSYNC_IN, // INPUT CL
  g267, // INPUT DB
  UNK_74_IN, // INPUT L
  SYNC_IN, // INPUT CK
  g374, // INPUT DC
  g124_ric13_din_clock_2, // INPUT DD
  path1288_8dec_in_b, // OUTPUT QA
  path1042_8dec_in_a, // OUTPUT QB
  unconnected_F13_CO, // OUTPUT CO
  path1238_8dec_in_c, // OUTPUT QC
  g300_step_counter_d, // OUTPUT QD
);

cell_LT2 A69 ( // 1-bit Data Latch
  g358_ric13_din_clock_1, // INPUT G
  RIC12_D0_IN, // INPUT D
  unconnected_A69_Q, // OUTPUT Q
  path356, // OUTPUT XQ
);

cell_LT2 K48 ( // 1-bit Data Latch
  g487, // INPUT G
  path555, // INPUT D
  g158_ric12_a2_rd, // OUTPUT Q
  unconnected_K48_XQ, // OUTPUT XQ
);

cell_LT2 K52 ( // 1-bit Data Latch
  g487, // INPUT G
  path550, // INPUT D
  g162_ric12_a1_rd, // OUTPUT Q
  unconnected_K52_XQ, // OUTPUT XQ
);

cell_A4H M3 ( // 4-bit Full Adder
  path1097_add_m3_a1, // INPUT A4
  path1060_add_m3_a2, // INPUT B4
  path1181, // INPUT A3
  path1107, // INPUT B3
  path1095, // INPUT A2
  path1096, // INPUT B2
  path1026, // INPUT A1
  path1027, // INPUT B1
  path642, // INPUT CI
  path1105_add_m3_co, // OUTPUT CO
  path1059, // OUTPUT S4
  path1058, // OUTPUT S3
  path1318, // OUTPUT S2
  path1216, // OUTPUT S1
);

cell_A4H T69 ( // 4-bit Full Adder
  path658, // INPUT A4
  path545, // INPUT B4
  path656, // INPUT A3
  path571, // INPUT B3
  path654, // INPUT A2
  path601, // INPUT B2
  path652, // INPUT A1
  path547, // INPUT B1
  g650, // INPUT CI
  path636, // OUTPUT CO
  path657, // OUTPUT S4
  path655, // OUTPUT S3
  path653, // OUTPUT S2
  path651, // OUTPUT S1
);

cell_A4H U69 ( // 4-bit Full Adder
  path641, // INPUT A4
  path605, // INPUT B4
  path639, // INPUT A3
  path631, // INPUT B3
  path638, // INPUT A2
  path627, // INPUT B2
  path637, // INPUT A1
  path635, // INPUT B1
  path636, // INPUT CI
  path642, // OUTPUT CO
  path640, // OUTPUT S4
  path478, // OUTPUT S3
  path426, // OUTPUT S2
  path440, // OUTPUT S1
);

cell_A4H C71 ( // 4-bit Full Adder
  path140, // INPUT A4
  path392, // INPUT B4
  path139, // INPUT A3
  path391, // INPUT B3
  path138, // INPUT A2
  path390, // INPUT B2
  path137, // INPUT A1
  path389, // INPUT B1
  VCC, // INPUT CI
  path141, // OUTPUT CO
  path371, // OUTPUT S4
  path319, // OUTPUT S3
  path271, // OUTPUT S2
  path320, // OUTPUT S1
);

cell_A4H E61 ( // 4-bit Full Adder
  path1089, // INPUT A4
  path330, // INPUT B4
  path976, // INPUT A3
  path329, // INPUT B3
  path1088, // INPUT A2
  path328, // INPUT B2
  path1084, // INPUT A1
  path327, // INPUT B1
  path141, // INPUT CI
  g999, // OUTPUT CO
  path1000, // OUTPUT S4
  path1122, // OUTPUT S3
  path1087, // OUTPUT S2
  path1085, // OUTPUT S1
);

cell_A4H G68 ( // 4-bit Full Adder
  g1247, // INPUT A4
  path1146, // INPUT B4
  g1160, // INPUT A3
  path901, // INPUT B3
  g899, // INPUT A2
  path900, // INPUT B2
  path1103, // INPUT A1
  path1102, // INPUT B1
  path1164, // INPUT CI
  path1145, // OUTPUT CO
  unconnected_G68_S4, // OUTPUT S4
  unconnected_G68_S3, // OUTPUT S3
  unconnected_G68_S2, // OUTPUT S2
  unconnected_G68_S1, // OUTPUT S1
);

cell_A4H H1 ( // 4-bit Full Adder
  g325, // INPUT A4
  path1136, // INPUT B4
  g374, // INPUT A3
  path1245, // INPUT B3
  path1202, // INPUT A2
  path1281, // INPUT B2
  path369, // INPUT A1
  path1239, // INPUT B1
  path859, // INPUT CI
  path1113, // OUTPUT CO
  path915, // OUTPUT S4
  path1240, // OUTPUT S3
  path1248, // OUTPUT S2
  path860, // OUTPUT S1
);

cell_A4H H69 ( // 4-bit Full Adder
  path1139, // INPUT A4
  path1138, // INPUT B4
  path1161, // INPUT A3
  path1320, // INPUT B3
  path983, // INPUT A2
  path1244, // INPUT B2
  path1172, // INPUT A1
  path1144, // INPUT B1
  VCC, // INPUT CI
  path1164, // OUTPUT CO
  unconnected_H69_S4, // OUTPUT S4
  unconnected_H69_S3, // OUTPUT S3
  unconnected_H69_S2, // OUTPUT S2
  unconnected_H69_S1, // OUTPUT S1
);

cell_A4H I61 ( // 4-bit Full Adder
  path1089, // INPUT A4
  g650, // INPUT B4
  path976, // INPUT A3
  g650, // INPUT B3
  path1088, // INPUT A2
  g650, // INPUT B2
  path1084, // INPUT A1
  g650, // INPUT B1
  path1072, // INPUT CI
  path872, // OUTPUT CO
  g1247, // OUTPUT S4
  g1160, // OUTPUT S3
  g899, // OUTPUT S2
  path1103, // OUTPUT S1
);

cell_A4H J6 ( // 4-bit Full Adder
  g1101, // INPUT A4
  path1099, // INPUT B4
  path290, // INPUT A3
  path1112, // INPUT B3
  path888, // INPUT A2
  path887, // INPUT B2
  path889, // INPUT A1
  path1070, // INPUT B1
  path1105_add_m3_co, // INPUT CI
  path859, // OUTPUT CO
  path1284, // OUTPUT S4
  path1283, // OUTPUT S3
  path1076, // OUTPUT S2
  path1106, // OUTPUT S1
);

cell_A4H J66 ( // 4-bit Full Adder
  path140, // INPUT A4
  g650, // INPUT B4
  path139, // INPUT A3
  g650, // INPUT B3
  path138, // INPUT A2
  g650, // INPUT B2
  path137, // INPUT A1
  path1071, // INPUT B1
  path1113, // INPUT CI
  path1072, // OUTPUT CO
  path1139, // OUTPUT S4
  path1161, // OUTPUT S3
  path983, // OUTPUT S2
  path1172, // OUTPUT S1
);

cell_DE2 N115 ( // 2:4 Decoder
  path986_g160_ric12_a1_wr, // INPUT A
  g288_path152_ric12_a0, // INPUT B
  g461_ric13_d_0, // OUTPUT X0
  g455, // OUTPUT X1
  g448, // OUTPUT X2
  g444, // OUTPUT X3
);

cell_FDM K87 ( // DFF
  g476_ric13_d_0_clock, // INPUT CK
  path356, // INPUT D
  g979, // OUTPUT XQ
  g668, // OUTPUT Q
);

cell_FDM L115 ( // DFF
  g1227, // INPUT CK
  g1082, // INPUT D
  path1104, // OUTPUT XQ
  unconnected_L115_Q, // OUTPUT Q
);

cell_FDM L61 ( // DFF
  g1227, // INPUT CK
  path1171, // INPUT D
  path974, // OUTPUT XQ
  unconnected_L61_Q, // OUTPUT Q
);

cell_FDM L67 ( // DFF
  g1227, // INPUT CK
  path861, // INPUT D
  path1168, // OUTPUT XQ
  unconnected_L67_Q, // OUTPUT Q
);

cell_FDM L75 ( // DFF
  g1227, // INPUT CK
  path1233, // INPUT D
  path1169, // OUTPUT XQ
  unconnected_L75_Q, // OUTPUT Q
);

cell_FDM L81 ( // DFF
  g1227, // INPUT CK
  path1241, // INPUT D
  path918, // OUTPUT XQ
  unconnected_L81_Q, // OUTPUT Q
);

cell_FDM L87 ( // DFF
  g1227, // INPUT CK
  g917, // INPUT D
  path919, // OUTPUT XQ
  unconnected_L87_Q, // OUTPUT Q
);

cell_FDM L100 ( // DFF
  g1227, // INPUT CK
  g1286, // INPUT D
  path1253, // OUTPUT XQ
  unconnected_L100_Q, // OUTPUT Q
);

cell_FDM M114 ( // DFF
  g1227, // INPUT CK
  path864, // INPUT D
  path1316, // OUTPUT XQ
  unconnected_M114_Q, // OUTPUT Q
);

cell_FDM M61 ( // DFF
  g1227, // INPUT CK
  path807, // INPUT D
  path1309, // OUTPUT XQ
  unconnected_M61_Q, // OUTPUT Q
);

cell_FDM M67 ( // DFF
  g1227, // INPUT CK
  path808, // INPUT D
  path1231, // OUTPUT XQ
  unconnected_M67_Q, // OUTPUT Q
);

cell_FDM M75 ( // DFF
  g1227, // INPUT CK
  path1232, // INPUT D
  path965, // OUTPUT XQ
  unconnected_M75_Q, // OUTPUT Q
);

cell_FDM M81 ( // DFF
  g1227, // INPUT CK
  path1242, // INPUT D
  path1167, // OUTPUT XQ
  unconnected_M81_Q, // OUTPUT Q
);

cell_FDM M89 ( // DFF
  g1227, // INPUT CK
  path1150, // INPUT D
  path920, // OUTPUT XQ
  unconnected_M89_Q, // OUTPUT Q
);

cell_FDM M95 ( // DFF
  g1227, // INPUT CK
  path1149, // INPUT D
  path921, // OUTPUT XQ
  unconnected_M95_Q, // OUTPUT Q
);

cell_FDM P63 ( // DFF
  g439, // INPUT CK
  g1218, // INPUT D
  path1109, // OUTPUT XQ
  unconnected_P63_Q, // OUTPUT Q
);

cell_FDM P69 ( // DFF
  g439, // INPUT CK
  g1224, // INPUT D
  path1179, // OUTPUT XQ
  unconnected_P69_Q, // OUTPUT Q
);

cell_FDM P81 ( // DFF
  g439, // INPUT CK
  g1174, // INPUT D
  path1228, // OUTPUT XQ
  unconnected_P81_Q, // OUTPUT Q
);

cell_FDM Q63 ( // DFF
  g439, // INPUT CK
  g1237, // INPUT D
  path1299, // OUTPUT XQ
  unconnected_Q63_Q, // OUTPUT Q
);

cell_FDM Q76 ( // DFF
  g439, // INPUT CK
  g1260, // INPUT D
  path1302, // OUTPUT XQ
  unconnected_Q76_Q, // OUTPUT Q
);

cell_FDM Q82 ( // DFF
  g439, // INPUT CK
  g362, // INPUT D
  path1263, // OUTPUT XQ
  unconnected_Q82_Q, // OUTPUT Q
);

cell_FDM Q93 ( // DFF
  g439, // INPUT CK
  g1305, // INPUT D
  path1307, // OUTPUT XQ
  unconnected_Q93_Q, // OUTPUT Q
);

cell_FDM Q99 ( // DFF
  g439, // INPUT CK
  g1220, // INPUT D
  path1303, // OUTPUT XQ
  unconnected_Q99_Q, // OUTPUT Q
);

cell_FDM S61 ( // DFF
  g439, // INPUT CK
  g755, // INPUT D
  path756, // OUTPUT XQ
  unconnected_S61_Q, // OUTPUT Q
);

cell_FDM S67 ( // DFF
  g439, // INPUT CK
  path757, // INPUT D
  path758, // OUTPUT XQ
  unconnected_S67_Q, // OUTPUT Q
);

cell_FDM S73 ( // DFF
  g439, // INPUT CK
  g466, // INPUT D
  path759, // OUTPUT XQ
  unconnected_S73_Q, // OUTPUT Q
);

cell_FDM S85 ( // DFF
  g439, // INPUT CK
  g469, // INPUT D
  path784, // OUTPUT XQ
  unconnected_S85_Q, // OUTPUT Q
);

cell_FDM S99 ( // DFF
  g439, // INPUT CK
  g425, // INPUT D
  path786, // OUTPUT XQ
  unconnected_S99_Q, // OUTPUT Q
);

cell_FDM B1 ( // DFF
  g377, // INPUT CK
  path378, // INPUT D
  unconnected_B1_XQ, // OUTPUT XQ
  path266_ric12_a3456_ctrl1, // OUTPUT Q
);

cell_FDM V99 ( // DFF
  g439, // INPUT CK
  g429, // INPUT D
  path427, // OUTPUT XQ
  unconnected_V99_Q, // OUTPUT Q
);

cell_FDM C4 ( // DFF
  g377, // INPUT CK
  path144, // INPUT D
  path145_ric12_oe_inv, // OUTPUT XQ
  path852_ric12_wr_1, // OUTPUT Q
);

cell_FDM F7 ( // DFF
  g377, // INPUT CK
  path991, // INPUT D
  path1133_ric12_a3456_ctrl2, // OUTPUT XQ
  unconnected_F7_Q, // OUTPUT Q
);

cell_FDM G40 ( // DFF
  path883, // INPUT CK
  path881, // INPUT D
  path880, // OUTPUT XQ
  g1116, // OUTPUT Q
);

cell_FDN O16 ( // DFF with Set
  g476_ric13_d_0_clock, // INPUT CK
  g990, // INPUT D
  path1211, // INPUT S
  g1014, // OUTPUT Q
  g1016, // OUTPUT XQ
);

cell_FDO O39 ( // DFF with Reset
  g1034, // INPUT CK
  g990, // INPUT D
  g1039, // INPUT R
  g1012, // OUTPUT Q
  g1018, // OUTPUT XQ
);

cell_unkf P28 ( // Unknown F
  AS_IN, // INPUT I
  unconnected_P28_XA, // OUTPUT XA
  g491_address_strobe_synced, // OUTPUT XB
);

cell_FDP G12 ( // DFF with SET and RESET
  g487, // INPUT CK
  E_IN, // INPUT D
  path914, // INPUT R
  UNK_74_IN, // INPUT S
  path881, // OUTPUT Q
  unconnected_G12_XQ, // OUTPUT XQ
);

assign AL0_IOM = UNK_74_IN && ~AL_CT_76_IN;
assign IO1_OUT = ~io1_inv;
assign IRQ_OUT = ~(~(~UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))) && ~(UNK_75_IN && path879));
assign P32_IOM = ~(~(P47_IN || P46_IN) && P45_IN && P44_IN && RW_IN && ~(E_IN ^ E_NOR_77_IN)) && UNK_74_IN;
assign PARAM_ROMCS_OUT = ~(P47_IN ^ P46_IN) || RD_OUT;
assign RAMCS_OUT = ~(~(P47_IN || P46_IN) && P45_IN && ~P44_IN);
assign RD_OUT = ~(RW_IN && E_IN);
assign RIC12_A0_OUT = ~((path152_ric12_a0 && ~path852_ric12_wr_1) || (~path152_ric12_a0 && RIC12_OE_OUT));
assign RIC12_A1_OUT = ~((g160_ric12_a1_wr && ~path852_ric12_wr_1) || (g162_ric12_a1_rd && RIC12_OE_OUT));
assign RIC12_A10_OUT = ~((g893_ric12_a10_wr && ~path852_ric12_wr_1) || (path482_ric12_a10_rd && RIC12_OE_OUT));
assign RIC12_A2_OUT = ~((g156_ric12_a2_wr && ~path852_ric12_wr_1) || (g158_ric12_a2_rd && RIC12_OE_OUT));
assign RIC12_A3_OUT = ~(~(g260_ric12_a3_1 && ~path266_ric12_a3456_ctrl1) && ~(path890_ric12_a3_2 && ~path1133_ric12_a3456_ctrl2));
assign RIC12_A4_OUT = ~(~(path133_ric12_a4_1 && ~path266_ric12_a3456_ctrl1) && ~(path1077_ric12_a4_2 && ~path1133_ric12_a3456_ctrl2));
assign RIC12_A5_OUT = ~(~(path134_ric12_a5_1 && ~path266_ric12_a3456_ctrl1) && ~(path891_ric12_a5_2 && ~path1133_ric12_a3456_ctrl2));
assign RIC12_A6_OUT = ~(~(path379_ric12_a6_1 && ~path266_ric12_a3456_ctrl1) && ~(path1282_ric12_a6_2 && ~path1133_ric12_a3456_ctrl2));
assign RIC12_A7_OUT = ~((g1075_ric12_a7_wr && ~path852_ric12_wr_1) || (path480_ric12_a7_rd && RIC12_OE_OUT));
assign RIC12_A8_OUT = ~((path153_ric12_a8_wr && ~path852_ric12_wr_1) || (path154_ric12_a8_rd && RIC12_OE_OUT));
assign RIC12_A9_OUT = ~((g1142_ric12_a9_wr && ~path852_ric12_wr_1) || (path481_ric12_a9_rd && RIC12_OE_OUT));
assign RIC12_D0_OUT = ~((path365_ric12_d0_1 && ~path152_ric12_a0) || (g846_ric12_d0_2 && path152_ric12_a0));
assign RIC12_D1_OUT = ~((path363_ric12_d1_1 && ~path152_ric12_a0) || (path362_ric12_d1_2 && path152_ric12_a0));
assign RIC12_D2_OUT = ~((path364_ric12_d2_1 && ~path152_ric12_a0) || (path361_ric12_d2_2 && path152_ric12_a0));
assign RIC12_D3_OUT = ~((path348_ric12_d3_1 && ~path152_ric12_a0) || (path347_ric12_d3_2 && path152_ric12_a0));
assign RIC12_D4_OUT = ~((path360_ric12_d4_1 && ~path152_ric12_a0) || (g385_ric12_d4_2 && path152_ric12_a0));
assign RIC12_D5_OUT = ~((path346_ric12_d5_1 && ~path152_ric12_a0) || (path345_ric12_d5_2 && path152_ric12_a0));
assign RIC12_D6_OUT = ~((g345_ric12_d6_1 && ~path152_ric12_a0) || (path367_ric12_d6_2 && path152_ric12_a0));
assign RIC12_D7_IOM = ~path852_ric12_wr_1 && UNK_74_IN;
assign RIC12_D7_OUT = ~((path344_ric12_d7_1 && ~path152_ric12_a0) || (path333_ric12_d7_2 && path152_ric12_a0));
assign RIC12_OE_OUT = ~path145_ric12_oe_inv;
assign RIC12_WE_OUT = ~(~((g1057_8dec_out1 || SYNC_IN || ~g300_step_counter_d) && (g1041_8dec_out2 || SYNC_IN || ~g300_step_counter_d)) && g1116);
assign RIC13_D0_OUT = ~((path787_ric13_d0_0 || g461_ric13_d_0) && (path788 || g455) && (path800 || g448) && (path789 || g444));
assign RIC13_D1_OUT = ~((path1306_ric13_d1_0 || g461_ric13_d_0) && (path1235 || g455) && (path1234 || g448) && (path1315 || g444));
assign RIC13_D2_OUT = ~((path1221_ric13_d2_0 || g461_ric13_d_0) && (path1222 || g455) && (path862 || g448) && (path863 || g444));
assign RIC13_D3_OUT = ~((path1258_ric13_d3_0 || g461_ric13_d_0) && (path1312 || g455) && (path1313 || g448) && (path1317 || g444));
assign RIC13_D4_IOM = UNK_74_IN && ~(path1006 && g156_ric12_a2_wr);
assign RIC13_D4_OUT = ~((path462_ric13_d4_0 || g461_ric13_d_0) && (path456 || g455) && (path450 || g448) && (VCC || g444));
assign RIC13_D5_OUT = ~((path463_ric13_d5_0 || g461_ric13_d_0) && (path806 || g455) && (path805 || g448) && (VCC || g444));
assign RIC13_D6_OUT = ~((path464_ric13_d6_0 || g461_ric13_d_0) && (path644 || g455) && (path643 || g448) && (VCC || g444));
assign RIC13_D7_OUT = ~((path467_ric13_d7_0 || g461_ric13_d_0) && (path804 || g455) && (path803 || g448) && (VCC || g444));
assign WR_OUT = ~(~RW_IN && E_IN);
assign g1034 = g1057_8dec_out1 || SYNC_IN || ~g300_step_counter_d;
assign g1039 = g1057_8dec_out1 || SYNC_IN || g300_step_counter_d;
assign g1082 = ~((path1161 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145))))) || (path1324 && UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign g1101 = ~(~g979 || ~((path799 && g1016 && g1018) || (path1231 && (g1014 || g1012))));
assign g1127 = ~(path379_ric12_a6_1 && ~path266_ric12_a3456_ctrl1);
assign g1174 = ~(path1059 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign g1207_ric12_ad3_10_clock = g1055_8dec_out0 || SYNC_IN || ~g300_step_counter_d;
assign g1218 = ~(path1318 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign g1220 = ~(path653 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign g1224 = ~(path1058 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign g1227 = (g1057_8dec_out1 || SYNC_IN || g300_step_counter_d) && (g1215_8dec_out3 || SYNC_IN || g300_step_counter_d) && (g1049_8dec_out5 || SYNC_IN || g300_step_counter_d) && (g1209_8dec_out7 || SYNC_IN || g300_step_counter_d) && (g1057_8dec_out1 || SYNC_IN || ~g300_step_counter_d) && (g1215_8dec_out3 || SYNC_IN || ~g300_step_counter_d) && (g1049_8dec_out5 || SYNC_IN || ~g300_step_counter_d) && (g1209_8dec_out7 || SYNC_IN || ~g300_step_counter_d);
assign g1237 = ~(path1216 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign g124_ric13_din_clock_2 = (g1213_8dec_out4 || SYNC_IN || g300_step_counter_d) ^ VCC ^ VCC;
assign g1260 = ~(path655 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign g1286 = ~((path983 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145))))) || (g1163 && UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign g1291 = ~(~UNK_75_IN || path1078);
assign g1305 = ~(path651 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign g267 = ~(path890_ric12_a3_2 && ~path1133_ric12_a3456_ctrl2);
assign g269 = ~(g1209_8dec_out7 || SYNC_IN || g300_step_counter_d);
assign g288_path152_ric12_a0 = path152_ric12_a0;
assign g325 = ~(~g979 || ~((path944 && g1016 && g1018) || (path919 && (g1014 || g1012))));
assign g350 = ~(~(AL6_OUT && AL_CT_76_IN) && ~(AL6_IN && ~AL_CT_76_IN));
assign g352 = ~(~(AL4_OUT && AL_CT_76_IN) && ~(AL4_IN && ~AL_CT_76_IN));
assign g355_ram_latch_clock = (g1049_8dec_out5 || SYNC_IN || g300_step_counter_d) ^ g496_ric12_a10_latch ^ VCC;
assign g358_ric13_din_clock_1 = (g1051_8dec_out6 || SYNC_IN || g300_step_counter_d) ^ ~(~UNK_75_IN || path1078) ^ g5;
assign g362 = ~(path657 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign g374 = ~(~g979 || ~((path933 && g1016 && g1018) || (path918 && (g1014 || g1012))));
assign g377 = ~(~((g1055_8dec_out0 || SYNC_IN || g300_step_counter_d) && (g1041_8dec_out2 || SYNC_IN || g300_step_counter_d) && (g1213_8dec_out4 || SYNC_IN || g300_step_counter_d) && (g1051_8dec_out6 || SYNC_IN || g300_step_counter_d) && (g1055_8dec_out0 || SYNC_IN || ~g300_step_counter_d) && (g1041_8dec_out2 || SYNC_IN || ~g300_step_counter_d) && (g1213_8dec_out4 || SYNC_IN || ~g300_step_counter_d) && (g1051_8dec_out6 || SYNC_IN || ~g300_step_counter_d)) || ~((g1057_8dec_out1 || SYNC_IN || g300_step_counter_d) && (g1215_8dec_out3 || SYNC_IN || g300_step_counter_d) && (g1049_8dec_out5 || SYNC_IN || g300_step_counter_d) && (g1209_8dec_out7 || SYNC_IN || g300_step_counter_d) && (g1057_8dec_out1 || SYNC_IN || ~g300_step_counter_d) && (g1215_8dec_out3 || SYNC_IN || ~g300_step_counter_d) && (g1049_8dec_out5 || SYNC_IN || ~g300_step_counter_d) && (g1209_8dec_out7 || SYNC_IN || ~g300_step_counter_d)));
assign g384_e7_coverflow_unk74block = path1005_e7_coverflow || ~UNK_74_IN;
assign g425 = ~(path426 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign g429 = ~(path440 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign g439 = (g1057_8dec_out1 || SYNC_IN || g300_step_counter_d) && (g1215_8dec_out3 || SYNC_IN || g300_step_counter_d) && (g1049_8dec_out5 || SYNC_IN || g300_step_counter_d) && (g1209_8dec_out7 || SYNC_IN || g300_step_counter_d) && (g1057_8dec_out1 || SYNC_IN || ~g300_step_counter_d) && (g1215_8dec_out3 || SYNC_IN || ~g300_step_counter_d) && (g1049_8dec_out5 || SYNC_IN || ~g300_step_counter_d) && (g1209_8dec_out7 || SYNC_IN || ~g300_step_counter_d);
assign g466 = ~(path478 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign g469 = ~(path640 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign g476_ric13_d_0_clock = g1209_8dec_out7 || SYNC_IN || g300_step_counter_d;
assign g487 = ~(~(P47_IN || P46_IN) && P45_IN && P44_IN && ~(~(AL0_OUT && AL_CT_76_IN) && ~(AL0_IN && ~AL_CT_76_IN)) && ~RW_IN && E_IN);
assign g607 = ~(~(P47_IN || P46_IN) && P45_IN && P44_IN && ~(AL0_OUT && AL_CT_76_IN) && ~(AL0_IN && ~AL_CT_76_IN) && ~RW_IN && E_IN);
assign g650 = (path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977;
assign g755 = ~(path1106 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign g878 = ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)));
assign g917 = ~(path915 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign g990 = path1006;
assign path1026 = ~(g668 || ~((path1300 && g1016 && g1018) || (path1299 && (g1014 || g1012))));
assign path1027 = ~(((((~(~g1004 || g1201) || g1094) && path1165 && ~path1114 && ~path1250 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165 && path1114 && path1250 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165 && path1114 && path1250 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165 && path1114 && ~path1250 && path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165 && path1114 && ~path1250 && ~path1287) || (~(~UNK_75_IN || path1078) && ~path1165 && ~path1114 && path1250 && path1287)) && (path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977) || (~(((~(~g1004 || g1201) || g1094) && path1165 && ~path1114 && ~path1250 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165 && path1114 && path1250 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165 && path1114 && path1250 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165 && path1114 && ~path1250 && path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165 && path1114 && ~path1250 && ~path1287) || (~(~UNK_75_IN || path1078) && ~path1165 && ~path1114 && path1250 && path1287)) && ~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977)));
assign path1060_add_m3_a2 = ~(((((~(~g1004 || g1201) || g1094) && path1165 && ~path1114 && path1250 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165 && ~path1114 && path1250 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165 && ~path1114 && ~path1250 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165 && ~path1114 && ~path1250 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165 && path1114 && path1250 && path1287) || (g706_ric12_a6_latch && ~path1165 && path1114 && path1250 && ~path1287)) && (path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977) || (~(((~(~g1004 || g1201) || g1094) && path1165 && ~path1114 && path1250 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165 && ~path1114 && path1250 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165 && ~path1114 && ~path1250 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165 && ~path1114 && ~path1250 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165 && path1114 && path1250 && path1287) || (g706_ric12_a6_latch && ~path1165 && path1114 && path1250 && ~path1287)) && ~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977)));
assign path1070 = ~(((((~(~g1004 || g1201) || g1094) && path1165 && path1114 && ~path1250 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165 && ~path1114 && path1250 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165 && ~path1114 && path1250 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165 && ~path1114 && ~path1250 && path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165 && ~path1114 && ~path1250 && ~path1287) || (~(~(AL6_OUT && AL_CT_76_IN) && ~(AL6_IN && ~AL_CT_76_IN)) && ~path1165 && path1114 && path1250 && path1287)) && (path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977) || (~(((~(~g1004 || g1201) || g1094) && path1165 && path1114 && ~path1250 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165 && ~path1114 && path1250 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165 && ~path1114 && path1250 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165 && ~path1114 && ~path1250 && path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165 && ~path1114 && ~path1250 && ~path1287) || (~(~(AL6_OUT && AL_CT_76_IN) && ~(AL6_IN && ~AL_CT_76_IN)) && ~path1165 && path1114 && path1250 && path1287)) && ~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977)));
assign path1071 = ~((path1165 && path1114 && path1250 && path1287 && (path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977) || (~(path1165 && path1114 && path1250 && path1287) && ~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977)));
assign path1084 = ~(~g979 || ~((path945 && g1016 && g1018) || (path1167 && (g1014 || g1012))));
assign path1088 = ~(g979 && ~((path1256 && g1016 && g1018) || (path920 && (g1014 || g1012))));
assign path1089 = ~(~g979 || ~((path1255 && g1016 && g1018) || (path921 && (g1014 || g1012))));
assign path1095 = ~(~g979 || ~((path1308 && g1016 && g1018) || (path1109 && (g1014 || g1012))));
assign path1096 = ~(((((~(~g1004 || g1201) || g1094) && path1165 && ~path1114 && ~path1250 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165 && ~path1114 && ~path1250 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165 && path1114 && path1250 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165 && path1114 && path1250 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165 && path1114 && ~path1250 && path1287) || (VCC && ~path1165 && path1114 && ~path1250 && ~path1287)) && (path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977) || (~(((~(~g1004 || g1201) || g1094) && path1165 && ~path1114 && ~path1250 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165 && ~path1114 && ~path1250 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165 && path1114 && path1250 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165 && path1114 && path1250 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165 && path1114 && ~path1250 && path1287) || (VCC && ~path1165 && path1114 && ~path1250 && ~path1287)) && ~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977)));
assign path1097_add_m3_a1 = ~(~g979 || ~((path1311 && g1016 && g1018) || (path1228 && (g1014 || g1012))));
assign path1099 = ~(((((~(~g1004 || g1201) || g1094) && path1165 && path1114 && path1250 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165 && path1114 && path1250 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165 && path1114 && ~path1250 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165 && path1114 && ~path1250 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165 && ~path1114 && path1250 && path1287) || (VCC && path1165 && ~path1114 && path1250 && ~path1287)) && (path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977) || (~(((~(~g1004 || g1201) || g1094) && path1165 && path1114 && path1250 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165 && path1114 && path1250 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165 && path1114 && ~path1250 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165 && path1114 && ~path1250 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165 && ~path1114 && path1250 && path1287) || (VCC && path1165 && ~path1114 && path1250 && ~path1287)) && ~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977)));
assign path1102 = ~path1243;
assign path1107 = ~(((((~(~g1004 || g1201) || g1094) && path1165 && ~path1114 && path1250 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165 && ~path1114 && ~path1250 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165 && ~path1114 && ~path1250 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165 && path1114 && path1250 && path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165 && path1114 && path1250 && ~path1287) || (VCC && ~path1165 && path1114 && ~path1250 && path1287)) && (path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977) || (~(((~(~g1004 || g1201) || g1094) && path1165 && ~path1114 && path1250 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165 && ~path1114 && ~path1250 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165 && ~path1114 && ~path1250 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165 && path1114 && path1250 && path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165 && path1114 && path1250 && ~path1287) || (VCC && ~path1165 && path1114 && ~path1250 && path1287)) && ~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977)));
assign path1112 = ~(((((~(~g1004 || g1201) || g1094) && path1165 && path1114 && path1250 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165 && path1114 && ~path1250 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165 && path1114 && ~path1250 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165 && ~path1114 && path1250 && path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165 && ~path1114 && path1250 && ~path1287) || (VCC && path1165 && ~path1114 && ~path1250 && path1287)) && (path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977) || (~(((~(~g1004 || g1201) || g1094) && path1165 && path1114 && path1250 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165 && path1114 && ~path1250 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165 && path1114 && ~path1250 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165 && ~path1114 && path1250 && path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165 && ~path1114 && path1250 && ~path1287) || (VCC && path1165 && ~path1114 && ~path1250 && path1287)) && ~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977)));
assign path1136 = ~((((g1004 && ~(~g1201 && ~g1094) && path1165 && path1114 && path1250 && path1287) || (path1165 && path1114 && path1250 && ~path1287)) && (path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977) || (~((g1004 && ~(~g1201 && ~g1094) && path1165 && path1114 && path1250 && path1287) || (path1165 && path1114 && path1250 && ~path1287)) && ~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977)));
assign path1138 = ~path1140;
assign path1144 = ~path1319;
assign path1146 = ~g1148;
assign path1149 = ~((g1247 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145))))) || (g1148 && UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign path1150 = ~((g899 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145))))) || (path1121 && UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign path1171 = ~((path1172 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145))))) || (path1319 && UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign path1175 = (g1209_8dec_out7 || SYNC_IN || g300_step_counter_d) ^ VCC ^ VCC;
assign path1181 = ~(~g979 || ~((path1310 && g1016 && g1018) || (path1179 && (g1014 || g1012))));
assign path1202 = ~(~g979 || ~((path934 && g1016 && g1018) || (path1169 && (g1014 || g1012))));
assign path1211 = g1055_8dec_out0 || SYNC_IN || g300_step_counter_d;
assign path1232 = ~((path1139 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145))))) || (path1140 && UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign path1233 = ~(path1248 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign path1239 = ~((((((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165 && path1114 && path1250 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165 && path1114 && path1250 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165 && path1114 && ~path1250 && path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165 && path1114 && ~path1250 && ~path1287) || (g703_ric12_a4_latch && path1165 && ~path1114 && path1250 && path1287) || (GND && path1165 && ~path1114 && path1250 && ~path1287)) && (path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977) || (~((((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165 && path1114 && path1250 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165 && path1114 && path1250 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165 && path1114 && ~path1250 && path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165 && path1114 && ~path1250 && ~path1287) || (g703_ric12_a4_latch && path1165 && ~path1114 && path1250 && path1287) || (GND && path1165 && ~path1114 && path1250 && ~path1287)) && ~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977)));
assign path1241 = ~(path1240 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign path1242 = ~((path1103 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145))))) || (path1243 && UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign path1244 = ~g1163;
assign path1245 = ~((((((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165 && path1114 && path1250 && path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165 && path1114 && path1250 && ~path1287) || (path1165 && path1114 && ~path1250 && path1287)) && (path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977) || (~((((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165 && path1114 && path1250 && path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165 && path1114 && path1250 && ~path1287) || (path1165 && path1114 && ~path1250 && path1287)) && ~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977)));
assign path1281 = ~((((~(~g1004 && ~g1201) && ~g1094 && path1165 && path1114 && path1250 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165 && path1114 && path1250 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165 && path1114 && ~path1250 && path1287) || (VCC && path1165 && path1114 && ~path1250 && ~path1287)) && (path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977) || (~((~(~g1004 && ~g1201) && ~g1094 && path1165 && path1114 && path1250 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165 && path1114 && path1250 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165 && path1114 && ~path1250 && path1287) || (VCC && path1165 && path1114 && ~path1250 && ~path1287)) && ~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977)));
assign path1320 = ~path1324;
assign path137 = ~(~g979 || ~((path792 && g1016 && g1018) || (path974 && (g1014 || g1012))));
assign path138 = ~(~g979 || ~((path793 && g1016 && g1018) || (path1253 && (g1014 || g1012))));
assign path139 = ~(~g979 || ~((path794 && g1016 && g1018) || (path1104 && (g1014 || g1012))));
assign path140 = ~(~g979 || ~((path795 && g1016 && g1018) || (path965 && (g1014 || g1012))));
assign path144 = ~(~(path1006 && ~g156_ric12_a2_wr && ~g160_ric12_a1_wr && path152_ric12_a0) && ~(path1006 && ~g156_ric12_a2_wr && ~g160_ric12_a1_wr && ~path152_ric12_a0));
assign path255_io5_out_unsync = ~((path371 && path152_ric12_a0) || (~(~g979 || ~((path982 && g1016 && g1018) || (path1168 && (g1014 || g1012)))) && ~path152_ric12_a0));
assign path256_io4_out_unsync = ~((~path319 && path152_ric12_a0) || ((~g979 || ~((path799 && g1016 && g1018) || (path1231 && (g1014 || g1012)))) && ~path152_ric12_a0));
assign path257_io3_out_unsync = ~((path271 && path152_ric12_a0) || (~(~g979 || ~((path798 && g1016 && g1018) || (path1309 && (g1014 || g1012)))) && ~path152_ric12_a0));
assign path267_io2_out_unsync = ~((~(g999 && path1000) && path152_ric12_a0) || (~path320 && ~path152_ric12_a0));
assign path268_io7_out_unsync = ~((g999 && path1122 && path152_ric12_a0) || (~(~g979 || ~((path944 && g1016 && g1018) || (path919 && (g1014 || g1012)))) && ~path152_ric12_a0));
assign path269_io8_out_unsync = ~((g999 && path1087 && path152_ric12_a0) || (~(~g979 || ~((path933 && g1016 && g1018) || (path918 && (g1014 || g1012)))) && ~path152_ric12_a0));
assign path270_io6_out_unsync = ~((~(g999 && path1085) && path152_ric12_a0) || ((~g979 || ~((path934 && g1016 && g1018) || (path1169 && (g1014 || g1012)))) && ~path152_ric12_a0));
assign path290 = ~(~g979 || ~((path798 && g1016 && g1018) || (path1309 && (g1014 || g1012))));
assign path331 = ~(~(g1209_8dec_out7 || SYNC_IN || g300_step_counter_d) ^ ~(g1209_8dec_out7 || SYNC_IN || g300_step_counter_d));
assign path369 = ~(~g979 || ~((path982 && g1016 && g1018) || (path1168 && (g1014 || g1012))));
assign path378 = ~(~(path1006 && ~g156_ric12_a2_wr && ~g160_ric12_a1_wr && path152_ric12_a0) && ~(path1006 && ~g156_ric12_a2_wr && ~g160_ric12_a1_wr && ~path152_ric12_a0) && ~(~path1006 && g156_ric12_a2_wr && ~g160_ric12_a1_wr && path152_ric12_a0));
assign path385 = path379_ric12_a6_1 && g260_ric12_a3_1 && (path1005_e7_coverflow || ~UNK_74_IN);
assign path386 = FSYNC_IN && ~(path379_ric12_a6_1 && g260_ric12_a3_1 && (path1005_e7_coverflow || ~UNK_74_IN));
assign path493 = ~(~(AL7_OUT && AL_CT_76_IN) && ~(AL7_IN && ~AL_CT_76_IN));
assign path545 = ~(((((~(~g1004 || g1201) || g1094) && ~path1165 && ~path1114 && path1250 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165 && ~path1114 && path1250 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165 && ~path1114 && ~path1250 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165 && ~path1114 && ~path1250 && ~path1287)) && (path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977) || (~(((~(~g1004 || g1201) || g1094) && ~path1165 && ~path1114 && path1250 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165 && ~path1114 && path1250 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165 && ~path1114 && ~path1250 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165 && ~path1114 && ~path1250 && ~path1287)) && ~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977)));
assign path547 = ~(((~(~g1004 || g1201) || g1094) && ~path1165 && ~path1114 && ~path1250 && ~path1287 && (path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977) || (~((~(~g1004 || g1201) || g1094) && ~path1165 && ~path1114 && ~path1250 && ~path1287) && ~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977)));
assign path550 = ~(~(AL1_OUT && AL_CT_76_IN) && ~(AL1_IN && ~AL_CT_76_IN));
assign path554 = ~(~(AL5_OUT && AL_CT_76_IN) && ~(AL5_IN && ~AL_CT_76_IN));
assign path555 = ~(~(AL2_OUT && AL_CT_76_IN) && ~(AL2_IN && ~AL_CT_76_IN));
assign path571 = ~((((VCC && ~path1165 && ~path1114 && path1250 && path1287) || ((~(~g1004 || g1201) || g1094) && ~path1165 && ~path1114 && path1250 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165 && ~path1114 && ~path1250 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165 && ~path1114 && ~path1250 && ~path1287)) && (path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977) || (~((VCC && ~path1165 && ~path1114 && path1250 && path1287) || ((~(~g1004 || g1201) || g1094) && ~path1165 && ~path1114 && path1250 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165 && ~path1114 && ~path1250 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165 && ~path1114 && ~path1250 && ~path1287)) && ~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977)));
assign path601 = ~(((((~(~g1004 || g1201) || g1094) && ~path1165 && ~path1114 && ~path1250 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165 && ~path1114 && ~path1250 && ~path1287)) && (path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977) || (~(((~(~g1004 || g1201) || g1094) && ~path1165 && ~path1114 && ~path1250 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165 && ~path1114 && ~path1250 && ~path1287)) && ~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977)));
assign path605 = ~(((((~(~g1004 || g1201) || g1094) && ~path1165 && path1114 && path1250 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165 && path1114 && path1250 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165 && path1114 && ~path1250 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165 && path1114 && ~path1250 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165 && ~path1114 && path1250 && path1287) || (g706_ric12_a6_latch && ~path1165 && ~path1114 && path1250 && ~path1287)) && (path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977) || (~(((~(~g1004 || g1201) || g1094) && ~path1165 && path1114 && path1250 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165 && path1114 && path1250 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165 && path1114 && ~path1250 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165 && path1114 && ~path1250 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165 && ~path1114 && path1250 && path1287) || (g706_ric12_a6_latch && ~path1165 && ~path1114 && path1250 && ~path1287)) && ~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977)));
assign path627 = ~((~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~(((~(~g1004 || g1201) || g1094) && ~path1165 && path1114 && ~path1250 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165 && path1114 && ~path1250 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165 && ~path1114 && path1250 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165 && ~path1114 && path1250 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165 && ~path1114 && ~path1250 && path1287) || (VCC && ~path1165 && ~path1114 && ~path1250 && ~path1287))) && (path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977) || ((~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~(((~(~g1004 || g1201) || g1094) && ~path1165 && path1114 && ~path1250 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165 && path1114 && ~path1250 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165 && ~path1114 && path1250 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165 && ~path1114 && path1250 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165 && ~path1114 && ~path1250 && path1287) || (VCC && ~path1165 && ~path1114 && ~path1250 && ~path1287))) && ~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977)));
assign path631 = ~(((((~(~g1004 || g1201) || g1094) && ~path1165 && path1114 && path1250 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165 && path1114 && ~path1250 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165 && path1114 && ~path1250 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165 && ~path1114 && path1250 && path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165 && ~path1114 && path1250 && ~path1287) || (g846_ric12_d0_2 && ~path1165 && ~path1114 && ~path1250 && path1287)) && (path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977) || (~(((~(~g1004 || g1201) || g1094) && ~path1165 && path1114 && path1250 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165 && path1114 && ~path1250 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165 && path1114 && ~path1250 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165 && ~path1114 && path1250 && path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165 && ~path1114 && path1250 && ~path1287) || (g846_ric12_d0_2 && ~path1165 && ~path1114 && ~path1250 && path1287)) && ~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977)));
assign path635 = ~((((GND && ~path1165 && path1114 && ~path1250 && path1287) || ((~(~g1004 || g1201) || g1094) && ~path1165 && path1114 && ~path1250 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165 && ~path1114 && path1250 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165 && ~path1114 && path1250 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165 && ~path1114 && ~path1250 && path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165 && ~path1114 && ~path1250 && ~path1287)) && (path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977) || (~((GND && ~path1165 && path1114 && ~path1250 && path1287) || ((~(~g1004 || g1201) || g1094) && ~path1165 && path1114 && ~path1250 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165 && ~path1114 && path1250 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165 && ~path1114 && path1250 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165 && ~path1114 && ~path1250 && path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165 && ~path1114 && ~path1250 && ~path1287)) && ~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977)));
assign path637 = ~(g668 || ~((path790 && g1016 && g1018) || (path427 && (g1014 || g1012))));
assign path638 = ~(g668 || ~((path785 && g1016 && g1018) || (path786 && (g1014 || g1012))));
assign path639 = ~(g668 || ~((path760 && g1016 && g1018) || (path759 && (g1014 || g1012))));
assign path641 = ~(g668 || ~((path772 && g1016 && g1018) || (path784 && (g1014 || g1012))));
assign path652 = ~(g668 || ~((path1178 && g1016 && g1018) || (path1307 && (g1014 || g1012))));
assign path654 = ~(g668 || ~((path1262 && g1016 && g1018) || (path1303 && (g1014 || g1012))));
assign path656 = ~(g668 || ~((path1301 && g1016 && g1018) || (path1302 && (g1014 || g1012))));
assign path658 = ~(g668 || ~((path1261 && g1016 && g1018) || (path1263 && (g1014 || g1012))));
assign path757 = ~(path1076 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign path807 = ~(path1283 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign path808 = ~(path1284 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign path861 = ~(path860 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign path864 = ~((g1160 && ~(UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145))))) || (g897 && UNK_75_IN && ~(~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2)) || ~((path872 ^ path977) || (path977 ^ path1145)))));
assign path882 = (g1057_8dec_out1 || SYNC_IN || g300_step_counter_d) && (g1215_8dec_out3 || SYNC_IN || g300_step_counter_d) && (g1049_8dec_out5 || SYNC_IN || g300_step_counter_d) && (g1209_8dec_out7 || SYNC_IN || g300_step_counter_d) && (g1057_8dec_out1 || SYNC_IN || ~g300_step_counter_d) && (g1215_8dec_out3 || SYNC_IN || ~g300_step_counter_d) && (g1049_8dec_out5 || SYNC_IN || ~g300_step_counter_d) && (g1209_8dec_out7 || SYNC_IN || ~g300_step_counter_d);
assign path883 = ~(g1055_8dec_out0 || SYNC_IN || ~g300_step_counter_d);
assign path887 = ~(((((~(~g1004 || g1201) || g1094) && path1165 && path1114 && ~path1250 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165 && path1114 && ~path1250 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165 && ~path1114 && path1250 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165 && ~path1114 && path1250 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165 && ~path1114 && ~path1250 && path1287) || (~(~(AL4_OUT && AL_CT_76_IN) && ~(AL4_IN && ~AL_CT_76_IN)) && path1165 && ~path1114 && ~path1250 && ~path1287)) && (path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977) || (~(((~(~g1004 || g1201) || g1094) && path1165 && path1114 && ~path1250 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165 && path1114 && ~path1250 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165 && ~path1114 && path1250 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165 && ~path1114 && path1250 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165 && ~path1114 && ~path1250 && path1287) || (~(~(AL4_OUT && AL_CT_76_IN) && ~(AL4_IN && ~AL_CT_76_IN)) && path1165 && ~path1114 && ~path1250 && ~path1287)) && ~((path1165 || path1114 || path1250 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2) && path977)));
assign path888 = ~(~g979 || ~((path797 && g1016 && g1018) || (path758 && (g1014 || g1012))));
assign path889 = ~(~g979 || ~((path796 && g1016 && g1018) || (path756 && (g1014 || g1012))));
assign path900 = ~path1121;
assign path901 = ~g897;
assign path914 = ~(g1116 && ~(g1057_8dec_out1 || SYNC_IN || ~g300_step_counter_d));
assign path976 = ~(~g979 || ~((path1257 && g1016 && g1018) || (path1316 && (g1014 || g1012))));
assign path986_g160_ric12_a1_wr = g160_ric12_a1_wr;
assign path991 = ~(~(path1006 && ~g156_ric12_a2_wr && ~g160_ric12_a1_wr && path152_ric12_a0) && (~(path1006 && ~g156_ric12_a2_wr && ~g160_ric12_a1_wr && ~path152_ric12_a0) || (g162_ric12_a1_rd && g158_ric12_a2_rd)));