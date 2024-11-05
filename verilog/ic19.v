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




latch (
  SYNC_IN, // INPUT G A20
  path267_io2_out_unsync, // INPUT DA A20
  path268_io7_out_unsync, // INPUT DB A20
  path269_io8_out_unsync, // INPUT DC A20
  path270_io6_out_unsync, // INPUT DD A20
  path255_io5_out_unsync, // INPUT DA A4
  path256_io4_out_unsync, // INPUT DB A4
  path257_io3_out_unsync, // INPUT DC A4
  unconnected_A4_DD, // INPUT DD A4
  IO2_OUT, // OUTPUT PA A20
  IO7_OUT, // OUTPUT PB A20
  IO8_OUT, // OUTPUT PC A20
  IO6_OUT, // OUTPUT PD A20
  IO5_OUT, // OUTPUT PA A4
  IO4_OUT, // OUTPUT PB A4
  IO3_OUT, // OUTPUT PC A4
  unconnected_A4_PD, // OUTPUT PD A4
);

latch (
  g355_ram_latch_clock, // INPUT G A75
  RIC12_D7_IN, // INPUT DA A75
  RIC12_D6_IN, // INPUT DB A75
  RIC12_D5_IN, // INPUT DC A75
  RIC12_D4_IN, // INPUT DD A75
  RIC13_D3_IN, // INPUT DA O75
  RIC13_D2_IN, // INPUT DB O75
  RIC13_D1_IN, // INPUT DC O75
  RIC13_D0_IN, // INPUT DD O75
  RIC13_D7_IN, // INPUT DA R93
  RIC13_D6_IN, // INPUT DB R93
  RIC13_D5_IN, // INPUT DC R93
  RIC13_D4_IN, // INPUT DD R93
  RIC12_D3_IN, // INPUT DA B61
  RIC12_D2_IN, // INPUT DB B61
  RIC12_D1_IN, // INPUT DC B61
  RIC12_D0_IN, // INPUT DD B61
  path352_ric12_d7_in_unsync, // OUTPUT PA A75
  path351_ric12_d6_in_unsync, // OUTPUT PB A75
  path350_ric12_d5_in_unsync, // OUTPUT PC A75
  path349_ric12_d4_in_unsync, // OUTPUT PD A75
  path1311, // OUTPUT PA O75
  path1310, // OUTPUT PB O75
  path1308, // OUTPUT PC O75
  path1300, // OUTPUT PD O75
  path799, // OUTPUT PA R93
  path798, // OUTPUT PB R93
  path797, // OUTPUT PC R93
  path796, // OUTPUT PD R93
  path132, // OUTPUT PA B61
  path131, // OUTPUT PB B61
  path130, // OUTPUT PC B61
  path129, // OUTPUT PD B61
);

latch (
  tmp8, // INPUT G K20
  g1075_ric12_a7_wr, // INPUT DA K20
  path153_ric12_a8_wr, // INPUT DB K20
  g1142_ric12_a9_wr, // INPUT DC K20
  g893_ric12_a10_wr, // INPUT DD K20
  g260_ric12_a3_1, // INPUT DA K3
  path133_ric12_a4_1, // INPUT DB K3
  path134_ric12_a5_1, // INPUT DC K3
  path379_ric12_a6_1, // INPUT DD K3
  path499_ric12_a7_latch, // OUTPUT PA K20
  path498_ric12_a8_latch, // OUTPUT PB K20
  path497_ric12_a9_latch, // OUTPUT PC K20
  g496_ric12_a10_latch, // OUTPUT PD K20
  path701_ric12_a3_latch, // OUTPUT PA K3
  g703_ric12_a4_latch, // OUTPUT PB K3
  path704_ric12_a5_latch, // OUTPUT PC K3
  g706_ric12_a6_latch, // OUTPUT PD K3
);

latch (
  g487, // INPUT G K34
  path493, // INPUT DA K34
  path507, // INPUT DB K34
  path554, // INPUT DC K34
  path623, // INPUT DD K34
  P33_IN, // INPUT DA T33
  P32_IN, // INPUT DB T33
  P31_IN, // INPUT DC T33
  P30_IN, // INPUT DD T33
  P37_IN, // INPUT DA V48
  P36_IN, // INPUT DB V48
  P35_IN, // INPUT DC V48
  P34_IN, // INPUT DD V48
  P43_IN, // INPUT DA V61
  P42_IN, // INPUT DB V61
  P41_IN, // INPUT DC V61
  P40_IN, // INPUT DD V61
  unconnected_K34_NA, // OUTPUT NA K34
  path1282_ric12_a6_2, // OUTPUT PA K34
  unconnected_K34_NB, // OUTPUT NB K34
  path891_ric12_a5_2, // OUTPUT PB K34
  unconnected_K34_NC, // OUTPUT NC K34
  path1077_ric12_a4_2, // OUTPUT PC K34
  unconnected_K34_ND, // OUTPUT ND K34
  path890_ric12_a3_2, // OUTPUT PD K34
  path348_ric12_d3_1, // OUTPUT NA T33
  unconnected_T33_PA, // OUTPUT PA T33
  path364_ric12_d2_1, // OUTPUT NB T33
  unconnected_T33_PB, // OUTPUT PB T33
  path363_ric12_d1_1, // OUTPUT NC T33
  unconnected_T33_PC, // OUTPUT PC T33
  path365_ric12_d0_1, // OUTPUT ND T33
  unconnected_T33_PD, // OUTPUT PD T33
  path344_ric12_d7_1, // OUTPUT NA V48
  unconnected_V48_PA, // OUTPUT PA V48
  path368_ric12_d6_1, // OUTPUT NB V48
  unconnected_V48_PB, // OUTPUT PB V48
  path346_ric12_d5_1, // OUTPUT NC V48
  unconnected_V48_PC, // OUTPUT PC V48
  path360_ric12_d4_1, // OUTPUT ND V48
  unconnected_V48_PD, // OUTPUT PD V48
  unconnected_V61_NA, // OUTPUT NA V61
  path482_ric12_a10_rd, // OUTPUT PA V61
  unconnected_V61_NB, // OUTPUT NB V61
  path481_ric12_a9_rd, // OUTPUT PB V61
  unconnected_V61_NC, // OUTPUT NC V61
  path154_ric12_a8_rd, // OUTPUT PC V61
  unconnected_V61_ND, // OUTPUT ND V61
  path480_ric12_a7_rd, // OUTPUT PD V61
);

latch (
  g358_ric13_din_clock_1, // INPUT G O108
  RIC13_D3_IN, // INPUT DA O108
  RIC13_D2_IN, // INPUT DB O108
  RIC13_D1_IN, // INPUT DC O108
  RIC13_D0_IN, // INPUT DD O108
  RIC13_D7_IN, // INPUT DA R107
  RIC13_D6_IN, // INPUT DB R107
  RIC13_D5_IN, // INPUT DC R107
  RIC13_D4_IN, // INPUT DD R107
  path944, // OUTPUT PA O108
  path933, // OUTPUT PB O108
  path934, // OUTPUT PC O108
  path982, // OUTPUT PD O108
  path795, // OUTPUT PA R107
  path794, // OUTPUT PB R107
  path793, // OUTPUT PC R107
  path792, // OUTPUT PD R107
);

latch (
  g124_ric13_din_clock_2, // INPUT G O61
  RIC13_D3_IN, // INPUT DA O61
  RIC13_D2_IN, // INPUT DB O61
  RIC13_D1_IN, // INPUT DC O61
  RIC13_D0_IN, // INPUT DD O61
  RIC13_D7_IN, // INPUT DA S106
  RIC13_D6_IN, // INPUT DB S106
  RIC13_D5_IN, // INPUT DC S106
  RIC13_D4_IN, // INPUT DD S106
  RIC12_D3_IN, // INPUT DA B74
  RIC12_D2_IN, // INPUT DB B74
  RIC12_D1_IN, // INPUT DC B74
  RIC12_D0_IN, // INPUT DD B74
  RIC12_D7_IN, // INPUT DA B87
  RIC12_D6_IN, // INPUT DB B87
  RIC12_D5_IN, // INPUT DC B87
  RIC12_D4_IN, // INPUT DD B87
  path1261, // OUTPUT PA O61
  path1301, // OUTPUT PB O61
  path1262, // OUTPUT PC O61
  path1178, // OUTPUT PD O61
  path772, // OUTPUT PA S106
  path760, // OUTPUT PB S106
  path785, // OUTPUT PC S106
  path790, // OUTPUT PD S106
  path128, // OUTPUT PA B74
  path127, // OUTPUT PB B74
  path126, // OUTPUT PC B74
  path125, // OUTPUT PD B74
  path122, // OUTPUT PA B87
  path121, // OUTPUT PB B87
  path120, // OUTPUT PC B87
  path393, // OUTPUT PD B87
);

latch (
  path1175, // INPUT G O95
  RIC13_D3_IN, // INPUT DA O95
  RIC13_D2_IN, // INPUT DB O95
  RIC13_D1_IN, // INPUT DC O95
  RIC13_D0_IN, // INPUT DD O95
  path1255, // OUTPUT PA O95
  path1257, // OUTPUT PB O95
  path1256, // OUTPUT PC O95
  path945, // OUTPUT PD O95
);

latch (
  g607, // INPUT G T17
  P33_IN, // INPUT DA T17
  P32_IN, // INPUT DB T17
  P31_IN, // INPUT DC T17
  P30_IN, // INPUT DD T17
  P37_IN, // INPUT DA U31
  P36_IN, // INPUT DB U31
  P35_IN, // INPUT DC U31
  P34_IN, // INPUT DD U31
  path347_ric12_d3_2, // OUTPUT NA T17
  path361_ric12_d2_2, // OUTPUT NB T17
  path362_ric12_d1_2, // OUTPUT NC T17
  g846_ric12_d0_2, // OUTPUT ND T17
  path333_ric12_d7_2, // OUTPUT NA U31
  path367_ric12_d6_2, // OUTPUT NB U31
  path345_ric12_d5_2, // OUTPUT NC U31
  g385_ric12_d4_2, // OUTPUT ND U31
);

cell_FJD G20 ( // Positive Edge Clocked Power JKFF with CLEAR
  path882, // INPUT CK
  g878, // INPUT J
  unconnected_G20_K, // INPUT K
  path880, // INPUT CL
  path1078, // OUTPUT XQ
  path879, // OUTPUT Q
);

cell_DE3 N46 ( // 3:8 Decoder
  path1042_8dec_in_a, // INPUT A
  path1288_8dec_in_b, // INPUT B
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
  g1124, // INPUT CK
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
  g1124, // INPUT CK
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
  g1124, // INPUT CK
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
  g1124, // INPUT CK
  path352_ric12_d7_in_unsync, // INPUT DA
  path351_ric12_d6_in_unsync, // INPUT DB
  path350_ric12_d5_in_unsync, // INPUT DC
  path349_ric12_d4_in_unsync, // INPUT DD
  path977_f97_ric12_d7, // OUTPUT QA
  path1165_f97_ric12_d6, // OUTPUT QB
  path1114_f97_ric12_d5, // OUTPUT QC
  path1250_f97_ric12_d4, // OUTPUT QD
);

cell_C43 B13 ( // 4-bit Binary Synchronous Up Counter
  unconnected_B13_DA, // INPUT DA
  g384_e7_coverflow_unk74block, // INPUT EN
  g384_e7_coverflow_unk74block, // INPUT CI
  path386, // INPUT CL
  g851, // INPUT DB
  g851, // INPUT L
  g377, // INPUT CK
  g374, // INPUT DC
  unconnected_B13_DD, // INPUT DD
  g260_ric12_a3_1, // OUTPUT QA
  path133_ric12_a4_1, // OUTPUT QB
  unconnected_B13_CO, // OUTPUT CO
  path134_ric12_a5_1, // OUTPUT QC
  path379_ric12_a6_1, // OUTPUT QD
);

cell_C43 C13 ( // 4-bit Binary Synchronous Up Counter
  unconnected_C13_DA, // INPUT DA
  unconnected_C13_EN, // INPUT EN
  unconnected_C13_CI, // INPUT CI
  RESET_IN, // INPUT CL
  g851, // INPUT DB
  g851, // INPUT L
  E_IN, // INPUT CK
  g374, // INPUT DC
  g124_ric13_din_clock_2, // INPUT DD
  unconnected_C13_QA, // OUTPUT QA
  unconnected_C13_QB, // OUTPUT QB
  unconnected_C13_CO, // OUTPUT CO
  io1_inv, // OUTPUT QC
  unconnected_C13_QD, // OUTPUT QD
);

cell_C43 D13 ( // 4-bit Binary Synchronous Up Counter
  unconnected_D13_EN, // INPUT EN
  FSYNC_IN, // INPUT CL
  unconnected_D13_L, // INPUT L
  g377, // INPUT CK
  path385, // INPUT CI
  g1127, // INPUT DA
  unconnected_D13_DB, // INPUT DB
  g374, // INPUT DC
  unconnected_D13_DD, // INPUT DD
  g1075_ric12_a7_wr, // OUTPUT QA
  path153_ric12_a8_wr, // OUTPUT QB
  g1142_ric12_a9_wr, // OUTPUT QC
  g893_ric12_a10_wr, // OUTPUT QD
  unconnected_D13_CO, // OUTPUT CO
);

cell_C43 E7 ( // 4-bit Binary Synchronous Up Counter
  unconnected_E7_EN, // INPUT EN
  FSYNC_IN, // INPUT CL
  UNK_74_IN, // INPUT L
  g377, // INPUT CK
  GND, // INPUT CI
  unconnected_E7_DA, // INPUT DA
  unconnected_E7_DB, // INPUT DB
  VCC, // INPUT DC
  unconnected_E7_DD, // INPUT DD
  path152_ric12_a0, // OUTPUT QA
  g160_ric12_a1_wr, // OUTPUT QB
  g156_ric12_a2_wr, // OUTPUT QC
  path1006, // OUTPUT QD
  path1005_e7_coverflow, // OUTPUT CO
);

cell_C43 F13 ( // 4-bit Binary Synchronous Up Counter
  unconnected_F13_EN, // INPUT EN
  FSYNC_IN, // INPUT CL
  UNK_74_IN, // INPUT L
  SYNC_IN, // INPUT CK
  unconnected_F13_CI, // INPUT CI
  g1127, // INPUT DA
  unconnected_F13_DB, // INPUT DB
  g374, // INPUT DC
  g124_ric13_din_clock_2, // INPUT DD
  path1288_8dec_in_b, // OUTPUT QA
  path1042_8dec_in_a, // OUTPUT QB
  path1238_8dec_in_c, // OUTPUT QC
  g300_step_counter_d, // OUTPUT QD
  unconnected_F13_CO, // OUTPUT CO
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
  path1097_add_m3_a1, // INPUT A1
  path1060_add_m3_a2, // INPUT A2
  path1181, // INPUT B1
  path1107, // INPUT B2
  path1095, // INPUT C1
  path1096, // INPUT C2
  path1026, // INPUT D1
  path1027, // INPUT D2
  path642, // INPUT CI
  path1105_add_m3_co, // OUTPUT CO
  path1059, // OUTPUT S1
  path1058, // OUTPUT S2
  path1318, // OUTPUT S3
  path1216, // OUTPUT S4
);

cell_A4H T69 ( // 4-bit Full Adder
  path658, // INPUT A1
  path545, // INPUT A2
  path656, // INPUT B1
  path571, // INPUT B2
  path654, // INPUT C1
  path601, // INPUT C2
  path652, // INPUT D1
  path547, // INPUT D2
  g650, // INPUT CI
  path636, // OUTPUT CO
  path657, // OUTPUT S1
  path655, // OUTPUT S2
  path653, // OUTPUT S3
  path651, // OUTPUT S4
);

cell_A4H U69 ( // 4-bit Full Adder
  path641, // INPUT A1
  path605, // INPUT A2
  path639, // INPUT B1
  path631, // INPUT B2
  path638, // INPUT C1
  path627, // INPUT C2
  path637, // INPUT D1
  path635, // INPUT D2
  path636, // INPUT CI
  path642, // OUTPUT CO
  path640, // OUTPUT S1
  path478, // OUTPUT S2
  path426, // OUTPUT S3
  path440, // OUTPUT S4
);

cell_A4H C71 ( // 4-bit Full Adder
  path140, // INPUT A1
  path392, // INPUT A2
  path139, // INPUT B1
  path391, // INPUT B2
  path138, // INPUT C1
  path390, // INPUT C2
  path137, // INPUT D1
  path389, // INPUT D2
  unconnected_C71_CI, // INPUT CI
  path141, // OUTPUT CO
  path371, // OUTPUT S1
  path319, // OUTPUT S2
  path271, // OUTPUT S3
  path320, // OUTPUT S4
);

cell_A4H E61 ( // 4-bit Full Adder
  path1089, // INPUT A1
  path330, // INPUT A2
  path976, // INPUT B1
  path329, // INPUT B2
  path1088, // INPUT C1
  path328, // INPUT C2
  path1084, // INPUT D1
  path327, // INPUT D2
  path141, // INPUT CI
  g999, // OUTPUT CO
  path1000, // OUTPUT S1
  path1122, // OUTPUT S2
  path1087, // OUTPUT S3
  path1085, // OUTPUT S4
);

cell_A4H G68 ( // 4-bit Full Adder
  g1247, // INPUT A1
  path1146, // INPUT A2
  g1160, // INPUT B1
  path901, // INPUT B2
  g899, // INPUT C1
  path900, // INPUT C2
  path1103, // INPUT D1
  path1102, // INPUT D2
  path1164, // INPUT CI
  path1145, // OUTPUT CO
  unconnected_G68_S1, // OUTPUT S1
  unconnected_G68_S2, // OUTPUT S2
  unconnected_G68_S3, // OUTPUT S3
  unconnected_G68_S4, // OUTPUT S4
);

cell_A4H H1 ( // 4-bit Full Adder
  g325, // INPUT A1
  path1136, // INPUT A2
  g374, // INPUT B1
  path1245, // INPUT B2
  path1202, // INPUT C1
  path1281, // INPUT C2
  path369, // INPUT D1
  path1239, // INPUT D2
  path859, // INPUT CI
  path1113, // OUTPUT CO
  path915, // OUTPUT S1
  path1240, // OUTPUT S2
  path1248, // OUTPUT S3
  path860, // OUTPUT S4
);

cell_A4H H69 ( // 4-bit Full Adder
  path1139, // INPUT A1
  path1138, // INPUT A2
  path1161, // INPUT B1
  path1320, // INPUT B2
  path983, // INPUT C1
  path1244, // INPUT C2
  path1172, // INPUT D1
  path1144, // INPUT D2
  unconnected_H69_CI, // INPUT CI
  path1164, // OUTPUT CO
  unconnected_H69_S1, // OUTPUT S1
  unconnected_H69_S2, // OUTPUT S2
  unconnected_H69_S3, // OUTPUT S3
  unconnected_H69_S4, // OUTPUT S4
);

cell_A4H I61 ( // 4-bit Full Adder
  path1089, // INPUT A1
  g650, // INPUT A2
  path976, // INPUT B1
  g650, // INPUT B2
  path1088, // INPUT C1
  g650, // INPUT C2
  path1084, // INPUT D1
  g650, // INPUT D2
  path1072, // INPUT CI
  path872, // OUTPUT CO
  g1247, // OUTPUT S1
  g1160, // OUTPUT S2
  g899, // OUTPUT S3
  path1103, // OUTPUT S4
);

cell_A4H J6 ( // 4-bit Full Adder
  g1101, // INPUT A1
  path1099, // INPUT A2
  path290, // INPUT B1
  path1112, // INPUT B2
  path888, // INPUT C1
  path887, // INPUT C2
  path889, // INPUT D1
  path1070, // INPUT D2
  path1105_add_m3_co, // INPUT CI
  path859, // OUTPUT CO
  path1284, // OUTPUT S1
  path1283, // OUTPUT S2
  path1076, // OUTPUT S3
  path1106, // OUTPUT S4
);

cell_A4H J66 ( // 4-bit Full Adder
  path140, // INPUT A1
  g650, // INPUT A2
  path139, // INPUT B1
  g650, // INPUT B2
  path138, // INPUT C1
  g650, // INPUT C2
  path137, // INPUT D1
  path1071, // INPUT D2
  path1113, // INPUT CI
  path1072, // OUTPUT CO
  path1139, // OUTPUT S1
  path1161, // OUTPUT S2
  path983, // OUTPUT S3
  path1172, // OUTPUT S4
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
  path1177, // INPUT D
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

cell_FDO O39 ( // DFF with Reset
  tmp4, // INPUT CK
  g990, // INPUT D
  tmp5, // INPUT R
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

assign tmp1 = (path1165_f97_ric12_d6 || path1114_f97_ric12_d5 || path1250_f97_ric12_d4 || path1287) && (g1004 || g1201 || g1094 || g385_ric12_d4_2);
assign tmp2 = ~((path872 ^ path977_f97_ric12_d7) || (path977_f97_ric12_d7 ^ path1145));
assign tmp3 = ~(~g1004 || g1201) || g1094;

assign tmp17 = g1055_8dec_out0 || SYNC_IN || g300_step_counter_d;
assign tmp8 =  g1055_8dec_out0 || SYNC_IN || ~g300_step_counter_d;
assign tmp5 =  g1057_8dec_out1 || SYNC_IN || g300_step_counter_d;
assign tmp4 =  g1057_8dec_out1 || SYNC_IN || ~g300_step_counter_d;
assign tmp18 = g1041_8dec_out2 || SYNC_IN || g300_step_counter_d;
assign tmp11 = g1215_8dec_out3 || SYNC_IN || g300_step_counter_d;
assign tmp7 =  g1041_8dec_out2 || SYNC_IN || ~g300_step_counter_d;
assign tmp12 = g1215_8dec_out3 || SYNC_IN || ~g300_step_counter_d;
assign tmp10 = g1213_8dec_out4 || SYNC_IN || g300_step_counter_d;
assign tmp9 =  g1049_8dec_out5 || SYNC_IN || g300_step_counter_d;
assign tmp13 = g1049_8dec_out5 || SYNC_IN || ~g300_step_counter_d;
assign tmp16 = g1051_8dec_out6 || SYNC_IN || g300_step_counter_d;
assign tmp6 =  g1209_8dec_out7 || SYNC_IN || g300_step_counter_d;
assign tmp14 = g1209_8dec_out7 || SYNC_IN || ~g300_step_counter_d;

assign tmp15 = UNK_75_IN && ~(~tmp1 || tmp2);


assign IO1_OUT = ~io1_inv;
assign IRQ_OUT = ~(~(~tmp15) && ~(UNK_75_IN && path879));
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
assign RIC12_D6_OUT = ~((path368_ric12_d6_1 && ~path152_ric12_a0) || (path367_ric12_d6_2 && path152_ric12_a0));
assign RIC12_D7_OE = ~path852_ric12_wr_1 && UNK_74_IN;
assign RIC12_D7_OUT = ~((path344_ric12_d7_1 && ~path152_ric12_a0) || (path333_ric12_d7_2 && path152_ric12_a0));
assign RIC12_OE_OUT = ~path145_ric12_oe_inv;
assign RIC12_WE_OUT = ~(~(tmp4 && tmp7) && g1116);

assign g1082 = ~((path1161 && ~tmp15) || (path1324 && tmp15));
assign g1101 = ~(~g979 || ~((path799 && g1016 && g1018) || (path1231 && (g1014 || g1012))));
assign g1124 = ~tmp6;
assign g1127 = ~(path379_ric12_a6_1 && ~path266_ric12_a3456_ctrl1);
assign g1174 = ~(path1059 && ~tmp15);
assign g1218 = ~(path1318 && ~tmp15);
assign g1220 = ~(path653 && ~tmp15);
assign g1224 = ~(path1058 && ~tmp15);
assign g1227 = tmp5 && tmp11 && tmp9 && tmp6 && tmp4 && tmp12 && tmp13 && tmp14;
assign g1237 = ~(path1216 && ~tmp15);
assign g124_ric13_din_clock_2 = (tmp10) ^ unconnected_N5_A2 ^ unconnected_N9_A2;
assign g1260 = ~(path655 && ~tmp15);
assign g1286 = ~((path983 && ~tmp15) || (g1163 && tmp15));
assign g1291 = ~(~UNK_75_IN || path1078);
assign g1305 = ~(path651 && ~tmp15);
assign g325 = ~(~g979 || ~((path944 && g1016 && g1018) || (path919 && (g1014 || g1012))));
assign g355_ram_latch_clock = tmp9 ^ g496_ric12_a10_latch ^ unconnected_O3_A2;
assign g358_ric13_din_clock_1 = (tmp16) ^ ~(~UNK_75_IN || path1078) ^ g5;
assign g374 = ~(~g979 || ~((path933 && g1016 && g1018) || (path918 && (g1014 || g1012))));
assign g377 = ~(~((tmp17) && (tmp18) && (tmp10) && (tmp16) && (g1055_8dec_out0 || SYNC_IN || ~g300_step_counter_d) && tmp7 && (g1213_8dec_out4 || SYNC_IN || ~g300_step_counter_d) && (g1051_8dec_out6 || SYNC_IN || ~g300_step_counter_d)) || ~(tmp5 && tmp11 && tmp9 && tmp6 && tmp4 && tmp12 && tmp13 && tmp14));
assign g384_e7_coverflow_unk74block = path1005_e7_coverflow || ~UNK_74_IN;
assign g425 = ~(path426 && ~tmp15);
assign g429 = ~(path440 && ~tmp15);
assign g439 = tmp5 && tmp11 && tmp9 && tmp6 && tmp4 && tmp12 && tmp13 && tmp14;
assign g466 = ~(path478 && ~tmp15);
assign g469 = ~(path640 && ~tmp15);
assign g487 = ~(~(P47_IN || P46_IN) && P45_IN && P44_IN && ~(~(AL0_OUT && AL_CT_76_IN) && ~(AL0_IN && ~AL_CT_76_IN)) && ~RW_IN && E_IN);
assign g607 = ~(~(P47_IN || P46_IN) && P45_IN && P44_IN && ~(AL0_OUT && AL_CT_76_IN) && ~(AL0_IN && ~AL_CT_76_IN) && ~RW_IN && E_IN);
assign g650 = tmp1 && path977_f97_ric12_d7;
assign g755 = ~(path1106 && ~tmp15);
assign g851 = ~(path890_ric12_a3_2 && ~path1133_ric12_a3456_ctrl2);
assign g878 = ~(~tmp1 || tmp2);
assign g917 = ~(path915 && ~tmp15);
assign g990 = path1006;
assign path1026 = ~(g668 || ~((path1300 && g1016 && g1018) || (path1299 && (g1014 || g1012))));
assign path1027 = ~((((tmp3 && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (~(~UNK_75_IN || path1078) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287)) && tmp1 && path977_f97_ric12_d7) || (~((tmp3 && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (~(~UNK_75_IN || path1078) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287)) && ~(tmp1 && path977_f97_ric12_d7)));
assign path1060_add_m3_a2 = ~((((tmp3 && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (unconnected_Q17_F1 && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287)) && tmp1 && path977_f97_ric12_d7) || (~((tmp3 && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (unconnected_Q17_F1 && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287)) && ~(tmp1 && path977_f97_ric12_d7)));
assign path1070 = ~((((tmp3 && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (unconnected_P1_F1 && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287)) && tmp1 && path977_f97_ric12_d7) || (~((tmp3 && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (unconnected_P1_F1 && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287)) && ~(tmp1 && path977_f97_ric12_d7)));
assign path1071 = ~((path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287 && tmp1 && path977_f97_ric12_d7) || (~(path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) && ~(tmp1 && path977_f97_ric12_d7)));
assign path1084 = ~(~g979 || ~((path945 && g1016 && g1018) || (path1167 && (g1014 || g1012))));
assign path1088 = ~(g979 && ~((path1256 && g1016 && g1018) || (path920 && (g1014 || g1012))));
assign path1089 = ~(~g979 || ~((path1255 && g1016 && g1018) || (path921 && (g1014 || g1012))));
assign path1095 = ~(~g979 || ~((path1308 && g1016 && g1018) || (path1109 && (g1014 || g1012))));
assign path1096 = ~((((tmp3 && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (unconnected_Q52_F1 && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287)) && tmp1 && path977_f97_ric12_d7) || (~((tmp3 && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (unconnected_Q52_F1 && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287)) && ~(tmp1 && path977_f97_ric12_d7)));
assign path1097_add_m3_a1 = ~(~g979 || ~((path1311 && g1016 && g1018) || (path1228 && (g1014 || g1012))));
assign path1099 = ~((((tmp3 && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (VCC && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287)) && tmp1 && path977_f97_ric12_d7) || (~((tmp3 && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (VCC && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287)) && ~(tmp1 && path977_f97_ric12_d7)));
assign path1102 = ~path1243;
assign path1107 = ~((((tmp3 && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (unconnected_Q36_F1 && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287)) && tmp1 && path977_f97_ric12_d7) || (~((tmp3 && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (unconnected_Q36_F1 && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287)) && ~(tmp1 && path977_f97_ric12_d7)));
assign path1112 = ~((((tmp3 && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (unconnected_P52_F1 && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287)) && tmp1 && path977_f97_ric12_d7) || (~((tmp3 && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (unconnected_P52_F1 && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287)) && ~(tmp1 && path977_f97_ric12_d7)));
assign path1136 = ~((((g1004 && ~(~g1201 && ~g1094) && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287)) && tmp1 && path977_f97_ric12_d7) || (~((g1004 && ~(~g1201 && ~g1094) && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287)) && ~(tmp1 && path977_f97_ric12_d7)));
assign path1138 = ~path1140;
assign path1144 = ~path1319;
assign path1146 = ~g1148;
assign path1149 = ~((g1247 && ~tmp15) || (g1148 && tmp15));
assign path1150 = ~((g899 && ~tmp15) || (path1121 && tmp15));
assign path1171 = ~((path1172 && ~tmp15) || (path1319 && tmp15));
assign path1175 = tmp6 ^ unconnected_P116_A2 ^ unconnected_P112_A2;
assign path1177 = ~(path657 && ~tmp15);
assign path1181 = ~(~g979 || ~((path1310 && g1016 && g1018) || (path1179 && (g1014 || g1012))));
assign path1202 = ~(~g979 || ~((path934 && g1016 && g1018) || (path1169 && (g1014 || g1012))));
assign path1211 = tmp17;
assign path1232 = ~((path1139 && ~tmp15) || (path1140 && tmp15));
assign path1233 = ~(path1248 && ~tmp15);
assign path1239 = ~((((((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (g703_ric12_a4_latch && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (unconnected_P10_F1 && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287)) && tmp1 && path977_f97_ric12_d7) || (~((((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (g703_ric12_a4_latch && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (unconnected_P10_F1 && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287)) && ~(tmp1 && path977_f97_ric12_d7)));
assign path1241 = ~(path1240 && ~tmp15);
assign path1242 = ~((path1103 && ~tmp15) || (path1243 && tmp15));
assign path1244 = ~g1163;
assign path1245 = ~((((((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287)) && tmp1 && path977_f97_ric12_d7) || (~((((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287)) && ~(tmp1 && path977_f97_ric12_d7)));
assign path1281 = ~((((~(~g1004 && ~g1201) && ~g1094 && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (unconnected_P46_D1 && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287)) && tmp1 && path977_f97_ric12_d7) || (~((~(~g1004 && ~g1201) && ~g1094 && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (unconnected_P46_D1 && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287)) && ~(tmp1 && path977_f97_ric12_d7)));
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
assign path331 = ~(~tmp6 ^ unconnected_D91_A2);
assign path369 = ~(~g979 || ~((path982 && g1016 && g1018) || (path1168 && (g1014 || g1012))));
assign path378 = ~(~(path1006 && ~g156_ric12_a2_wr && ~g160_ric12_a1_wr && path152_ric12_a0) && ~(path1006 && ~g156_ric12_a2_wr && ~g160_ric12_a1_wr && ~path152_ric12_a0) && ~(~path1006 && g156_ric12_a2_wr && ~g160_ric12_a1_wr && path152_ric12_a0));
assign path385 = path379_ric12_a6_1 && g260_ric12_a3_1 && (path1005_e7_coverflow || ~UNK_74_IN);
assign path386 = FSYNC_IN && ~(path379_ric12_a6_1 && g260_ric12_a3_1 && (path1005_e7_coverflow || ~UNK_74_IN));
assign path493 = ~(~(AL7_OUT && AL_CT_76_IN) && ~(AL7_IN && ~AL_CT_76_IN));
assign path507 = ~(~(AL6_OUT && AL_CT_76_IN) && ~(AL6_IN && ~AL_CT_76_IN));
assign path545 = ~((((tmp3 && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287)) && tmp1 && path977_f97_ric12_d7) || (~((tmp3 && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287)) && ~(tmp1 && path977_f97_ric12_d7)));
assign path547 = ~((tmp3 && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287 && tmp1 && path977_f97_ric12_d7) || (~(tmp3 && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) && ~(tmp1 && path977_f97_ric12_d7)));
assign path550 = ~(~(AL1_OUT && AL_CT_76_IN) && ~(AL1_IN && ~AL_CT_76_IN));
assign path554 = ~(~(AL5_OUT && AL_CT_76_IN) && ~(AL5_IN && ~AL_CT_76_IN));
assign path555 = ~(~(AL2_OUT && AL_CT_76_IN) && ~(AL2_IN && ~AL_CT_76_IN));
assign path571 = ~((((VCC && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (tmp3 && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287)) && tmp1 && path977_f97_ric12_d7) || (~((VCC && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (tmp3 && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287)) && ~(tmp1 && path977_f97_ric12_d7)));
assign path601 = ~((((tmp3 && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287)) && tmp1 && path977_f97_ric12_d7) || (~((tmp3 && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287)) && ~(tmp1 && path977_f97_ric12_d7)));
assign path605 = ~((((tmp3 && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && unconnected_R17_B2) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (g706_ric12_a6_latch && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287)) && tmp1 && path977_f97_ric12_d7) || (~((tmp3 && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && unconnected_R17_B2) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (g706_ric12_a6_latch && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287)) && ~(tmp1 && path977_f97_ric12_d7)));
assign path623 = ~(~(AL4_OUT && AL_CT_76_IN) && ~(AL4_IN && ~AL_CT_76_IN));
assign path627 = ~((~(~tmp1 || ~((tmp3 && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (unconnected_R52_F1 && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287))) && tmp1 && path977_f97_ric12_d7) || ((~tmp1 || ~((tmp3 && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (unconnected_R52_F1 && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287))) && ~(tmp1 && path977_f97_ric12_d7)));
assign path631 = ~((((tmp3 && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (g846_ric12_d0_2 && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287)) && tmp1 && path977_f97_ric12_d7) || (~((tmp3 && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (g846_ric12_d0_2 && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287)) && ~(tmp1 && path977_f97_ric12_d7)));
assign path635 = ~((((GND && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (tmp3 && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287)) && tmp1 && path977_f97_ric12_d7) || (~((GND && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (tmp3 && ~path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (~(~g1004 && ~g1201) && ~g1094 && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (g1004 && ~(~g1201 && ~g1094) && ~path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287)) && ~(tmp1 && path977_f97_ric12_d7)));
assign path637 = ~(g668 || ~((path790 && g1016 && g1018) || (path427 && (g1014 || g1012))));
assign path638 = ~(g668 || ~((path785 && g1016 && g1018) || (path786 && (g1014 || g1012))));
assign path639 = ~(g668 || ~((path760 && g1016 && g1018) || (path759 && (g1014 || g1012))));
assign path641 = ~(g668 || ~((path772 && g1016 && g1018) || (path784 && (g1014 || g1012))));
assign path652 = ~(g668 || ~((path1178 && g1016 && g1018) || (path1307 && (g1014 || g1012))));
assign path654 = ~(g668 || ~((path1262 && g1016 && g1018) || (path1303 && (g1014 || g1012))));
assign path656 = ~(g668 || ~((path1301 && g1016 && g1018) || (path1302 && (g1014 || g1012))));
assign path658 = ~(g668 || ~((path1261 && g1016 && g1018) || (path1263 && (g1014 || g1012))));
assign path757 = ~(path1076 && ~tmp15);
assign path807 = ~(path1283 && ~tmp15);
assign path808 = ~(path1284 && ~tmp15);
assign path861 = ~(path860 && ~tmp15);
assign path864 = ~((g1160 && ~tmp15) || (g897 && tmp15));
assign path882 = tmp5 && tmp11 && tmp9 && tmp6 && tmp4 && tmp12 && tmp13 && tmp14;
assign path883 = ~(g1055_8dec_out0 || SYNC_IN || ~g300_step_counter_d);
assign path887 = ~((((tmp3 && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (unconnected_P35_F1 && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287)) && tmp1 && path977_f97_ric12_d7) || (~((tmp3 && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (((~g1004 && ~g1201 && g1094) || ~((~g1004 && g1094) || ~g1201)) && path1165_f97_ric12_d6 && path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287) || (~(~g1004 && ~g1201) && ~g1094 && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && path1287) || (((g1004 && ~g1201 && ~g1094) || ~(~g1201 || ~g1094)) && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && path1250_f97_ric12_d4 && ~path1287) || (g1004 && ~(~g1201 && ~g1094) && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && path1287) || (unconnected_P35_F1 && path1165_f97_ric12_d6 && ~path1114_f97_ric12_d5 && ~path1250_f97_ric12_d4 && ~path1287)) && ~(tmp1 && path977_f97_ric12_d7)));
assign path888 = ~(~g979 || ~((path797 && g1016 && g1018) || (path758 && (g1014 || g1012))));
assign path889 = ~(~g979 || ~((path796 && g1016 && g1018) || (path756 && (g1014 || g1012))));
assign path900 = ~path1121;
assign path901 = ~g897;
assign path914 = ~(g1116 && ~tmp4);
assign path976 = ~(~g979 || ~((path1257 && g1016 && g1018) || (path1316 && (g1014 || g1012))));
assign path991 = ~(~(path1006 && ~g156_ric12_a2_wr && ~g160_ric12_a1_wr && path152_ric12_a0) && (~(path1006 && ~g156_ric12_a2_wr && ~g160_ric12_a1_wr && ~path152_ric12_a0) || (g162_ric12_a1_rd && g158_ric12_a2_rd)));






//
// CPU logic, address decoding and latch
assign PARAM_ROMCS_OUT = ~(P47_IN ^ P46_IN) || RD_OUT;
assign RAMCS_OUT = ~(~(P47_IN || P46_IN) && P45_IN && ~P44_IN);

assign RD_OUT = ~(RW_IN && E_IN);
assign WR_OUT = ~(~RW_IN && E_IN);
assign P32_OE = ~(~(P47_IN || P46_IN) && P45_IN && P44_IN && RW_IN && ~(E_IN ^ E_NOR_77_IN)) && UNK_74_IN;

assign AL_OE = UNK_74_IN && ~AL_CT_76_IN;
latch8b cpu_address_latch (
  ~AS_IN,
  P33_IN,  P32_IN,  P31_IN,  P30_IN,  P37_IN,  P36_IN,  P35_IN,  P34_IN,
  AL3_OUT, AL2_OUT, AL1_OUT, AL0_OUT, AL7_OUT, AL6_OUT, AL5_OUT, AL4_OUT,
);


//
// Connection bus out to IC9
assign g476_ric13_d_0_clock = tmp6;

cell_FDM K87 ( // DFF
  g476_ric13_d_0_clock, // INPUT CK
  path356, // INPUT D
  g979, // OUTPUT XQ
  g668, // OUTPUT Q
);
cell_FDN O16 ( // DFF with Set
  g476_ric13_d_0_clock, // INPUT CK
  g990, // INPUT D
  path1211, // INPUT S
  g1014, // OUTPUT Q
  g1016, // OUTPUT XQ
);

latch (
  g476_ric13_d_0_clock, // INPUT G N61

  path1232, // INPUT DA N61
  g1082, // INPUT DB N61
  path1170, // INPUT DC N61
  path1171, // INPUT DD N61
  g917, // INPUT DA N77
  path1241, // INPUT DB N77
  path1233, // INPUT DC N77
  path861, // INPUT DD N77
  path1149, // INPUT DA N93
  path864, // INPUT DB N93
  path1150, // INPUT DC N93
  path1242, // INPUT DD N93
  g1174, // INPUT DA P92
  g1224, // INPUT DB P92
  g1218, // INPUT DC P92
  g1237, // INPUT DD P92
  unconnected_Q107_DA, // INPUT DA Q107
  g1260, // INPUT DB Q107
  g1220, // INPUT DC Q107
  g1305, // INPUT DD Q107
  path808, // INPUT DA R61
  path807, // INPUT DB R61
  path757, // INPUT DC R61
  g755, // INPUT DD R61
  g469, // INPUT DA V78
  g466, // INPUT DB V78
  g425, // INPUT DC V78
  g429, // INPUT DD V78

  path803_ric13_d7_2, // OUTPUT PA N61
  path643_ric13_d6_2, // OUTPUT PB N61
  path805_ric13_d5_2, // OUTPUT PC N61
  path450_ric13_d4_2, // OUTPUT PD N61
  path1313_ric13_d3_2, // OUTPUT PA N77
  path862_ric13_d2_2, // OUTPUT PB N77
  path1234_ric13_d1_2, // OUTPUT PC N77
  path800_ric13_d0_2, // OUTPUT PD N77
  path1317_ric13_d3_3, // OUTPUT PA N93
  path863_ric13_d2_3, // OUTPUT PB N93
  path1315_ric13_d1_3, // OUTPUT PC N93
  path789_ric13_d0_3, // OUTPUT PD N93
  path1312_ric13_d3_1, // OUTPUT PA P92
  path1222_ric13_d2_1, // OUTPUT PB P92
  path1235_ric13_d1_1, // OUTPUT PC P92
  path788_ric13_d0_1, // OUTPUT PD P92
  path1258_ric13_d3_0, // OUTPUT PA Q107
  path1221_ric13_d2_0, // OUTPUT PB Q107
  path1306_ric13_d1_0, // OUTPUT PC Q107
  path787_ric13_d0_0, // OUTPUT PD Q107
  path804_ric13_d7_1, // OUTPUT PA R61
  path644_ric13_d6_1, // OUTPUT PB R61
  path806_ric13_d5_1, // OUTPUT PC R61
  path456_ric13_d4_1, // OUTPUT PD R61
  path467_ric13_d7_0, // OUTPUT PA V78
  path464_ric13_d6_0, // OUTPUT PB V78
  path463_ric13_d5_0, // OUTPUT PC V78
  path462_ric13_d4_0, // OUTPUT PD V78
);

cell_DE2 N115 ( // 2:4 Decoder
  g160_ric12_a1_wr, // INPUT A
  path152_ric12_a0, // INPUT B
  g461_ric13_d_0, // OUTPUT X0
  g455_ric13_d_1, // OUTPUT X1
  g448_ric13_d_2, // OUTPUT X2
  g444_ric13_d_3, // OUTPUT X3
);

assign RIC13_D0_OUT = ~(path787_ric13_d0_0 || g461_ric13_d_0) || ~(path788_ric13_d0_1 || g455_ric13_d_1) || ~(path800_ric13_d0_2 || g448_ric13_d_2) || ~(path789_ric13_d0_3 || g444_ric13_d_3);
assign RIC13_D1_OUT = ~(path1306_ric13_d1_0 || g461_ric13_d_0) || ~(path1235_ric13_d1_1 || g455_ric13_d_1) || ~(path1234_ric13_d1_2 || g448_ric13_d_2) || ~(path1315_ric13_d1_3 || g444_ric13_d_3);
assign RIC13_D2_OUT = ~(path1221_ric13_d2_0 || g461_ric13_d_0) || ~(path1222_ric13_d2_1 || g455_ric13_d_1) || ~(path862_ric13_d2_2 || g448_ric13_d_2) || ~(path863_ric13_d2_3 || g444_ric13_d_3);
assign RIC13_D3_OUT = ~(path1258_ric13_d3_0 || g461_ric13_d_0) || ~(path1312_ric13_d3_1 || g455_ric13_d_1) || ~(path1313_ric13_d3_2 || g448_ric13_d_2) || ~(path1317_ric13_d3_3 || g444_ric13_d_3);
assign RIC13_D4_OUT = ~(path462_ric13_d4_0 || g461_ric13_d_0) || ~(path456_ric13_d4_1 || g455_ric13_d_1) || ~(path450_ric13_d4_2 || g448_ric13_d_2) || ~(unconnected_V91_D1 || g444_ric13_d_3);
assign RIC13_D5_OUT = ~(path463_ric13_d5_0 || g461_ric13_d_0) || ~(path806_ric13_d5_1 || g455_ric13_d_1) || ~(path805_ric13_d5_2 || g448_ric13_d_2) || ~(unconnected_R76_D1 || g444_ric13_d_3);
assign RIC13_D6_OUT = ~(path464_ric13_d6_0 || g461_ric13_d_0) || ~(path644_ric13_d6_1 || g455_ric13_d_1) || ~(path643_ric13_d6_2 || g448_ric13_d_2) || ~(VCC || g444_ric13_d_3);
assign RIC13_D7_OUT = ~(path467_ric13_d7_0 || g461_ric13_d_0) || ~(path804_ric13_d7_1 || g455_ric13_d_1) || ~(path803_ric13_d7_2 || g448_ric13_d_2) || ~(VCC || g444_ric13_d_3);
assign RIC13_OE = UNK_74_IN && ~(path1006 && g156_ric12_a2_wr);

