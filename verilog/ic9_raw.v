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

// 4 instances
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

cell_LT4 M61 ( // 4-bit Data Latch
  g494, // INPUT G
  g910, // INPUT DA
  g950, // INPUT DB
  g952, // INPUT DC
  g912, // INPUT DD
  unconnected_M61_NA, // OUTPUT NA
  path80, // OUTPUT PA
  unconnected_M61_NB, // OUTPUT NB
  path79, // OUTPUT PB
  unconnected_M61_NC, // OUTPUT NC
  path953, // OUTPUT PC
  unconnected_M61_ND, // OUTPUT ND
  path913, // OUTPUT PD
);

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

cell_LT4 Q20 ( // 4-bit Data Latch
  g494, // INPUT G
  g56, // INPUT DA
  g854, // INPUT DB
  g467, // INPUT DC
  g753, // INPUT DD
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
  g494, // INPUT G
  g751, // INPUT DA
  g195, // INPUT DB
  g856, // INPUT DC
  g970, // INPUT DD
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
  g451, // INPUT G
  BUS0_IN, // INPUT DA
  BUS1_IN, // INPUT DB
  BUS2_IN, // INPUT DC
  BUS3_IN, // INPUT DD
  unconnected_B87_NA, // OUTPUT NA
  g540, // OUTPUT PA
  unconnected_B87_NB, // OUTPUT NB
  g1049, // OUTPUT PB
  unconnected_B87_NC, // OUTPUT NC
  g8, // OUTPUT PC
  unconnected_B87_ND, // OUTPUT ND
  path576, // OUTPUT PD
);

cell_LT4 D108 ( // 4-bit Data Latch
  g215, // INPUT G
  ROM_D4_IN, // INPUT DA
  ROM_D5_IN, // INPUT DB
  ROM_D6_IN, // INPUT DC
  ROM_D7_IN, // INPUT DD
  unconnected_D108_NA, // OUTPUT NA
  path60, // OUTPUT PA
  path305, // OUTPUT NB
  unconnected_D108_PB, // OUTPUT PB
  path304, // OUTPUT NC
  unconnected_D108_PC, // OUTPUT PC
  path871, // OUTPUT ND
  unconnected_D108_PD, // OUTPUT PD
);

cell_LT4 E108 ( // 4-bit Data Latch
  g215, // INPUT G
  ROM_D0_IN, // INPUT DA
  ROM_D1_IN, // INPUT DB
  ROM_D2_IN, // INPUT DC
  ROM_D3_IN, // INPUT DD
  unconnected_E108_NA, // OUTPUT NA
  path867, // OUTPUT PA
  unconnected_E108_NB, // OUTPUT NB
  path277, // OUTPUT PB
  unconnected_E108_NC, // OUTPUT NC
  path276, // OUTPUT PC
  unconnected_E108_ND, // OUTPUT ND
  path278, // OUTPUT PD
);

cell_LT4 E90 ( // 4-bit Data Latch
  g617, // INPUT G
  ROM_D0_IN, // INPUT DA
  ROM_D1_IN, // INPUT DB
  ROM_D2_IN, // INPUT DC
  ROM_D3_IN, // INPUT DD
  path843, // OUTPUT NA
  unconnected_E90_PA, // OUTPUT PA
  path619, // OUTPUT NB
  unconnected_E90_PB, // OUTPUT PB
  path620, // OUTPUT NC
  unconnected_E90_PC, // OUTPUT PC
  path628, // OUTPUT ND
  unconnected_E90_PD, // OUTPUT PD
);

cell_LT4 F20 ( // 4-bit Data Latch
  g131, // INPUT G
  g93, // INPUT DA
  RAM_D1_IN, // INPUT DB
  RAM_D2_IN, // INPUT DC
  g88, // INPUT DD
  unconnected_F20_NA, // OUTPUT NA
  path997, // OUTPUT PA
  unconnected_F20_NB, // OUTPUT NB
  path661, // OUTPUT PB
  unconnected_F20_NC, // OUTPUT NC
  path334, // OUTPUT PC
  unconnected_F20_ND, // OUTPUT ND
  path86, // OUTPUT PD
);

cell_LT4 F4 ( // 4-bit Data Latch
  path710, // INPUT G
  g93, // INPUT DA
  RAM_D1_IN, // INPUT DB
  RAM_D2_IN, // INPUT DC
  g88, // INPUT DD
  unconnected_F4_NA, // OUTPUT NA
  path177, // OUTPUT PA
  unconnected_F4_NB, // OUTPUT NB
  path965, // OUTPUT PB
  unconnected_F4_NC, // OUTPUT NC
  path966, // OUTPUT PC
  unconnected_F4_ND, // OUTPUT ND
  path89, // OUTPUT PD
);

cell_LT4 F36 ( // 4-bit Data Latch
  path709, // INPUT G
  g93, // INPUT DA
  RAM_D1_IN, // INPUT DB
  RAM_D2_IN, // INPUT DC
  g88, // INPUT DD
  unconnected_F36_NA, // OUTPUT NA
  path94, // OUTPUT PA
  unconnected_F36_NB, // OUTPUT NB
  path798, // OUTPUT PB
  unconnected_F36_NC, // OUTPUT NC
  path799, // OUTPUT PC
  unconnected_F36_ND, // OUTPUT ND
  path392, // OUTPUT PD
);

cell_LT4 G18 ( // 4-bit Data Latch
  g494, // INPUT G
  path640, // INPUT DA
  g642, // INPUT DB
  g663, // INPUT DC
  g336, // INPUT DD
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
  g1000, // INPUT DA
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

cell_LT4 H3 ( // 4-bit Data Latch
  path710, // INPUT G
  g1000, // INPUT DA
  RAM_D5_IN, // INPUT DB
  RAM_D6_IN, // INPUT DC
  RAM_D7_IN, // INPUT DD
  unconnected_H3_NA, // OUTPUT NA
  path996, // OUTPUT PA
  unconnected_H3_NB, // OUTPUT NB
  path505, // OUTPUT PB
  unconnected_H3_NC, // OUTPUT NC
  path506, // OUTPUT PC
  unconnected_H3_ND, // OUTPUT ND
  path90, // OUTPUT PD
);

cell_LT4 H34 ( // 4-bit Data Latch
  path709, // INPUT G
  g1000, // INPUT DA
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

cell_DE3 T61 ( // 3:8 Decoder
  path185, // INPUT B
  path186, // INPUT A
  path194, // INPUT C
  g160, // OUTPUT X0
  g162, // OUTPUT X1
  g188, // OUTPUT X2
  g193, // OUTPUT X3
  g330, // OUTPUT X4
  g191, // OUTPUT X5
  g328, // OUTPUT X6
  g100, // OUTPUT X7
);

cell_DE3 V91 ( // 3:8 Decoder
  WR_A12_OUT, // INPUT B
  WR_A11_OUT, // INPUT A
  WR_A13_OUT, // INPUT C
  path567, // OUTPUT X0
  path568, // OUTPUT X1
  path569, // OUTPUT X2
  path570, // OUTPUT X3
  path571, // OUTPUT X4
  unconnected_V91_X5, // OUTPUT X5
  unconnected_V91_X6, // OUTPUT X6
  unconnected_V91_X7, // OUTPUT X7
);

cell_FDQ M93 ( // 4-bit DFF
  g563, // INPUT CK
  g912, // INPUT DA
  g952, // INPUT DB
  g950, // INPUT DC
  g910, // INPUT DD
  path123, // OUTPUT QA
  path272, // OUTPUT QB
  path275, // OUTPUT QC
  path273, // OUTPUT QD
);

cell_FDQ O4 ( // 4-bit DFF
  g563, // INPUT CK
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
  g563, // INPUT CK
  g970, // INPUT DA
  g856, // INPUT DB
  path973, // INPUT DC
  g751, // INPUT DD
  path977, // OUTPUT QA
  path971, // OUTPUT QB
  path974, // OUTPUT QC
  path749, // OUTPUT QD
);

cell_FDQ T1 ( // 4-bit DFF
  g563, // INPUT CK
  g753, // INPUT DA
  g467, // INPUT DB
  g854, // INPUT DC
  g56, // INPUT DD
  path754, // OUTPUT QA
  path465, // OUTPUT QB
  path852, // OUTPUT QC
  path533, // OUTPUT QD
);

cell_FDQ T40 ( // 4-bit DFF
  g502, // INPUT CK
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
  g579, // INPUT CK
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
  g502, // INPUT CK
  g526, // INPUT DA
  g530, // INPUT DB
  g535, // INPUT DC
  path536, // INPUT DD
  path527, // OUTPUT QA
  path499, // OUTPUT QB
  path500, // OUTPUT QC
  path452, // OUTPUT QD
);

cell_FDQ V61 ( // 4-bit DFF
  g579, // INPUT CK
  g540, // INPUT DA
  g1049, // INPUT DB
  g8, // INPUT DC
  path576, // INPUT DD
  WR_A11_OUT, // OUTPUT QA
  WR_A12_OUT, // OUTPUT QB
  WR_A13_OUT, // OUTPUT QC
  WR_A14_OUT, // OUTPUT QD
);

cell_FDQ C67 ( // 4-bit DFF
  g579, // INPUT CK
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
  g579, // INPUT CK
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
  g579, // INPUT CK
  path867, // INPUT DA
  path277, // INPUT DB
  path276, // INPUT DC
  path278, // INPUT DD
  g866, // OUTPUT QA
  g864, // OUTPUT QB
  g606, // OUTPUT QC
  g601, // OUTPUT QD
);

cell_FDQ D87 ( // 4-bit DFF
  g579, // INPUT CK
  path60, // INPUT DA
  path305, // INPUT DB
  path304, // INPUT DC
  path871, // INPUT DD
  g66, // OUTPUT QA
  path802, // OUTPUT QB
  path303, // OUTPUT QC
  path227, // OUTPUT QD
);

cell_FDQ E61 ( // 4-bit DFF
  g579, // INPUT CK
  path843, // INPUT DA
  path619, // INPUT DB
  path620, // INPUT DC
  path628, // INPUT DD
  path842, // OUTPUT QA
  path618, // OUTPUT QB
  path621, // OUTPUT QC
  path627, // OUTPUT QD
);

cell_FDQ G38 ( // 4-bit DFF
  g563, // INPUT CK
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
  g563, // INPUT CK
  path409, // INPUT DA
  path208, // INPUT DB
  path553, // INPUT DC
  path171, // INPUT DD
  g411, // OUTPUT QA
  g268, // OUTPUT QB
  g413, // OUTPUT QC
  path170, // OUTPUT QD
);

cell_R4N V53 ( // 4-input NOR
  WR_A16_OUT, // INPUT A1
  WR_A15_OUT, // INPUT A2
  WR_A14_OUT, // INPUT A3
  path547, // INPUT A4
  path440, // OUTPUT X
);

cell_R4N J61 ( // 4-input NOR
  path31, // INPUT A1
  path668, // INPUT A2
  g35, // INPUT A3
  path146, // INPUT A4
  path669, // OUTPUT X
);

cell_C45 P13 ( // 4-bit Binary Synchronous Up Counter
  VCC, // INPUT DA
  g1028, // INPUT EN
  VCC, // INPUT CI
  FSYNC_IN, // INPUT CL
  VCC, // INPUT DB
  VCC, // INPUT L
  path175, // INPUT CK
  g1031, // INPUT DC
  VCC, // INPUT DD
  RAM_A0_OUT, // OUTPUT QA
  RAM_A1_OUT, // OUTPUT QB
  path22, // OUTPUT CO
  RAM_A2_ROM_A0_OUT, // OUTPUT QC
  RAM_OE_OUT, // OUTPUT QD
);

cell_C45 R61 ( // 4-bit Binary Synchronous Up Counter
  GND, // INPUT DA
  VCC, // INPUT EN
  g1049, // INPUT CI
  FSYNC_IN, // INPUT CL
  GND, // INPUT DB
  VCC, // INPUT L
  SYNC_IN, // INPUT CK
  GND, // INPUT DC
  GND, // INPUT DD
  path186, // OUTPUT QA
  path185, // OUTPUT QB
  unconnected_R61_CO, // OUTPUT CO
  path194, // OUTPUT QC
  path220, // OUTPUT QD
);

cell_C45 S66 ( // 4-bit Binary Synchronous Up Counter
  VCC, // INPUT DA
  VCC, // INPUT EN
  path323, // INPUT CI
  FSYNC_IN, // INPUT CL
  g592, // INPUT DB
  g592, // INPUT L
  path175, // INPUT CK
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
  path608, // INPUT CL
  GND, // INPUT DB
  VCC, // INPUT L
  path175, // INPUT CK
  GND, // INPUT DC
  GND, // INPUT DD
  g526, // OUTPUT QA
  g530, // OUTPUT QB
  unconnected_U73_CO, // OUTPUT CO
  g535, // OUTPUT QC
  g488, // OUTPUT QD
);

cell_LT2 A89 ( // 1-bit Data Latch
  g451, // INPUT G
  BUS4_IN, // INPUT D
  path495, // OUTPUT Q
  unconnected_A89_XQ, // OUTPUT XQ
);

cell_LT2 C63 ( // 1-bit Data Latch
  g451, // INPUT G
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

cell_LT2 E103 ( // 1-bit Data Latch
  g617, // INPUT G
  ROM_D4_IN, // INPUT D
  unconnected_E103_Q, // OUTPUT Q
  path878, // OUTPUT XQ
);

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
  path167, // OUTPUT S4
  path686, // OUTPUT S3
  path166, // OUTPUT S2
  path759, // OUTPUT S1
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
  g947, // OUTPUT S4
  path221, // OUTPUT S3
  path943, // OUTPUT S2
  path575, // OUTPUT S1
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
  path550, // OUTPUT S4
  path972, // OUTPUT S3
  path978, // OUTPUT S2
  path468, // OUTPUT S1
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
  path581, // OUTPUT S4
  path2, // OUTPUT S3
  path593, // OUTPUT S2
  path182, // OUTPUT S1
);

cell_A4H F71 ( // 4-bit Full Adder
  g782, // INPUT A4
  path783, // INPUT B4
  g667, // INPUT A3
  path389, // INPUT B3
  path881, // INPUT A2
  path390, // INPUT B2
  path807, // INPUT A1
  path882, // INPUT B1
  path654, // INPUT CI
  g137, // OUTPUT CO
  path879, // OUTPUT S4
  path801, // OUTPUT S3
  path880, // OUTPUT S2
  path653, // OUTPUT S1
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
  g782, // OUTPUT S4
  g667, // OUTPUT S3
  path881, // OUTPUT S2
  path807, // OUTPUT S1
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
  path414, // OUTPUT S4
  path269, // OUTPUT S3
  path266, // OUTPUT S2
  path46, // OUTPUT S1
);

cell_A4H I61 ( // 4-bit Full Adder
  g947, // INPUT A4
  path337, // INPUT B4
  path221, // INPUT A3
  path59, // INPUT B3
  path943, // INPUT A2
  path225, // INPUT B2
  path575, // INPUT A1
  path226, // INPUT B1
  VCC, // INPUT CI
  path654, // OUTPUT CO
  path30, // OUTPUT S4
  path58, // OUTPUT S3
  path944, // OUTPUT S2
  path36, // OUTPUT S1
);

cell_FDM K84 ( // DFF
  g494, // INPUT CK
  path878, // INPUT D
  unconnected_K84_XQ, // OUTPUT XQ
  path795, // OUTPUT Q
);

cell_FDM L91 ( // DFF
  g494, // INPUT CK
  path44, // INPUT D
  path408, // OUTPUT XQ
  unconnected_L91_Q, // OUTPUT Q
);

cell_FDM V16 ( // DFF
  g494, // INPUT CK
  path495, // INPUT D
  unconnected_V16_XQ, // OUTPUT XQ
  WR_A15_OUT, // OUTPUT Q
);

cell_FDM V22 ( // DFF
  g494, // INPUT CK
  path449, // INPUT D
  unconnected_V22_XQ, // OUTPUT XQ
  WR_A16_OUT, // OUTPUT Q
);

cell_FDN N64 ( // DFF with Set
  g494, // INPUT CK
  g115, // INPUT D
  g164, // INPUT S
  path117, // OUTPUT Q
  path118, // OUTPUT XQ
);

cell_FDN Q77 ( // DFF with Set
  path544, // INPUT CK
  g115, // INPUT D
  FSYNC_IN, // INPUT S
  path545, // OUTPUT Q
  path546, // OUTPUT XQ
);

cell_FDO N109 ( // DFF with Reset
  XTAL_IN, // INPUT CK
  path631, // INPUT D
  UNK34_IN, // INPUT R
  SYNCO_OUT, // OUTPUT Q
  path631, // OUTPUT XQ
);

cell_FDO N83 ( // DFF with Reset
  g592, // INPUT CK
  g115, // INPUT D
  path173, // INPUT R
  path919, // OUTPUT Q
  path920, // OUTPUT XQ
);

assign RAM_A10_OUT = ~(~(path57 && ~path546) && ~(path184 && ~path545));
assign RAM_A3_OUT = ~(~(g526 && ~path546) && ~(path527 && ~path545));
assign RAM_A4_OUT = ~(~(g530 && ~path546) && ~(path499 && ~path545));
assign RAM_A5_OUT = ~(~(g535 && ~path546) && ~(path500 && ~path545));
assign RAM_A6_OUT = ~(~(g488 && ~path546) && ~(path452 && ~path545));
assign RAM_A7_OUT = ~(~(path482 && ~path546) && ~(path851 && ~path545));
assign RAM_A8_OUT = ~(~(path548 && ~path546) && ~(path484 && ~path545));
assign RAM_A9_OUT = ~(~(path102 && ~path546) && ~(path183 && ~path545));
assign RAM_D_IOM = UNK34_IN && ~(~RAM_A2_ROM_A0_OUT && RAM_OE_OUT);
assign RAM_D0_OUT = ~(g658 && ~RAM_A0_OUT && ~RAM_A1_OUT) && ~(path196 && RAM_A0_OUT && ~RAM_A1_OUT) && ~(path80 && ~RAM_A0_OUT && RAM_A1_OUT);
assign RAM_D1_OUT = ~(~(g738 && ~RAM_A0_OUT && ~RAM_A1_OUT) && ~(path197 && RAM_A0_OUT && ~RAM_A1_OUT) && ~(path79 && ~RAM_A0_OUT && RAM_A1_OUT));
assign RAM_D2_OUT = ~(~(g558 && ~RAM_A0_OUT && ~RAM_A1_OUT) && ~(path198 && RAM_A0_OUT && ~RAM_A1_OUT) && ~(path953 && ~RAM_A0_OUT && RAM_A1_OUT));
assign RAM_D3_OUT = ~(g915 && ~RAM_A0_OUT && ~RAM_A1_OUT) && ~(path156 && RAM_A0_OUT && ~RAM_A1_OUT) && ~(path913 && ~RAM_A0_OUT && RAM_A1_OUT);
assign RAM_D4_OUT = ~(path170 && ~RAM_A0_OUT && ~RAM_A1_OUT) && ~(path54 && RAM_A0_OUT && ~RAM_A1_OUT) && ~(path141 && ~RAM_A0_OUT && RAM_A1_OUT);
assign RAM_D5_OUT = ~(~(g413 && ~RAM_A0_OUT && ~RAM_A1_OUT) && ~(path51 && RAM_A0_OUT && ~RAM_A1_OUT) && ~(path129 && ~RAM_A0_OUT && RAM_A1_OUT));
assign RAM_D6_OUT = ~(~(g268 && ~RAM_A0_OUT && ~RAM_A1_OUT) && ~(path700 && RAM_A0_OUT && ~RAM_A1_OUT) && ~(path742 && ~RAM_A0_OUT && RAM_A1_OUT));
assign RAM_D7_OUT = ~(~(g411 && ~RAM_A0_OUT && ~RAM_A1_OUT) && ~(path701 && RAM_A0_OUT && ~RAM_A1_OUT) && ~(path741 && ~RAM_A0_OUT && RAM_A1_OUT));
assign RAM_WR_OUT = (g160 || SYNC_IN || ~path220) && (g162 || SYNC_IN || ~path220) && (g188 || SYNC_IN || ~path220) && (g330 || SYNC_IN || ~path220) && (g191 || SYNC_IN || ~path220) && (g328 || SYNC_IN || ~path220) && (g100 || SYNC_IN || ~path220) && VCC;
assign WR_A0_OUT = ~(~(path974 && (path117 || path919)) && ~(path965 && path118 && path920));
assign WR_A1_OUT = ~(path971 && (path117 || path919)) && ~(path966 && path118 && path920);
assign WR_A10_OUT = ~(~(path123 && (path117 || path919)) && ~(path392 && path118 && path920));
assign WR_A2_OUT = ~(~(path977 && (path117 || path919)) && ~(path89 && path118 && path920));
assign WR_A3_OUT = ~(path533 && (path117 || path919)) && ~(path996 && path118 && path920);
assign WR_A4_OUT = ~(~(path852 && (path117 || path919)) && ~(path505 && path118 && path920));
assign WR_A5_OUT = ~(path465 && (path117 || path919)) && ~(path506 && path118 && path920);
assign WR_A6_OUT = ~(~(path754 && (path117 || path919)) && ~(path90 && path118 && path920));
assign WR_A7_OUT = ~(~(path273 && (path117 || path919)) && ~(path94 && path118 && path920));
assign WR_A8_OUT = ~(path275 && (path117 || path919)) && ~(path798 && path118 && path920);
assign WR_A9_OUT = ~(path272 && (path117 || path919)) && ~(path799 && path118 && path920);
assign g1000 = ~RAM_D4_IN;
assign g1028 = ~(~((VCC && g377 && g995 && ~g820 && ~g364) || (~path795 && ~g377 && ~g995 && g820 && ~g364) || (~path627 && g377 && ~g995 && g820 && ~g364) || (~path621 && ~g377 && g995 && g820 && ~g364) || (~path618 && g377 && g995 && g820 && ~g364) || (~path842 && ~g377 && ~g995 && ~g820 && g364) || (~path227 && g377 && ~g995 && ~g820 && g364) || (~path303 && ~g377 && g995 && ~g820 && g364)) && ~(~path802 && g377 && g995 && ~g820 && g364));
assign g1044 = path22 || ~UNK34_IN;
assign g115 = RAM_OE_OUT;
assign g131 = ~(g540 ^ ~(g8 ^ ~(VCC ^ (g160 || SYNC_IN || path220))));
assign g164 = g330 || SYNC_IN || path220;
assign g215 = g193 || SYNC_IN || path220;
assign g336 = ~(~(g782 && g648) && ~(path879 && g137)) && ~path408;
assign g35 = ~(~(path360 && (path117 || path919)) && ~(path706 && path118 && path920));
assign g451 = ~(~((g193 || SYNC_IN || path220) ^ VCC) ^ VCC);
assign g467 = path2 && ~path408;
assign g494 = g100 || SYNC_IN || path220;
assign g502 = ~(g100 || SYNC_IN || ~path220);
assign g56 = path182 && ~path408;
assign g563 = ~((g162 || SYNC_IN || path220) && (g193 || SYNC_IN || path220) && (g191 || SYNC_IN || path220) && (g100 || SYNC_IN || path220) && (g162 || SYNC_IN || ~path220) && (g193 || SYNC_IN || ~path220) && (g191 || SYNC_IN || ~path220) && (g100 || SYNC_IN || ~path220));
assign g579 = ~(g100 || SYNC_IN || path220);
assign g592 = g162 || SYNC_IN || ~path220;
assign g617 = g191 || SYNC_IN || path220;
assign g642 = ~(~(path881 && g648) && ~(path880 && g137)) && ~path408;
assign g663 = ~(~(g667 && g648) && ~(path801 && g137)) && ~path408;
assign g691 = ~(~(path749 && (path117 || path919)) && ~(path177 && path118 && path920));
assign g75 = g377 && g995 && ~g820 && g364;
assign g751 = path468 && ~path408;
assign g753 = path581 && ~path408;
assign g854 = path593 && ~path408;
assign g856 = path972 && ~path408;
assign g88 = ~RAM_D3_IN;
assign g910 = ~(~(path575 && ~g137) && ~(path36 && g137)) && ~path408;
assign g912 = ~(~(g947 && ~g137) && ~(path30 && g137)) && ~path408;
assign g928 = ~(~(g413 && (path117 || path919)) && ~(path998 && path118 && path920));
assign g93 = ~RAM_D0_IN;
assign g950 = ~(~(path943 && ~g137) && ~(path944 && g137)) && ~path408;
assign g952 = ~(~(path221 && g648) && ~(path58 && g137)) && ~path408;
assign g970 = path550 && ~path408;
assign path119 = (~path303 && ~g377 && ~g995 && ~g820 && ~g364) || (~path802 && g377 && ~g995 && ~g820 && ~g364) || (g66 && ~g377 && g995 && ~g820 && ~g364) || (g601 && g377 && g995 && ~g820 && ~g364) || (g606 && ~g377 && ~g995 && g820 && ~g364) || (g864 && g377 && ~g995 && g820 && ~g364) || (g866 && ~g377 && g995 && g820 && ~g364) || (g377 && ~g995 && ~g820 && g364 && g377 && g995 && g820 && ~g364);
assign path12 = ~(UNK_VCC? ^ ~(VCC ^ (g162 || SYNC_IN || path220)));
assign path139 = ~(~(g268 && (path117 || path919)) && ~(path265 && path118 && path920));
assign path146 = ~(~(path145 && (path117 || path919)) && ~(path708 && path118 && path920));
assign path165 = ~(~(g738 && (path117 || path919)) && ~(path661 && path118 && path920));
assign path171 = path46 && ~path408;
assign path173 = g328 || SYNC_IN || path220;
assign path175 = ~(~((g160 || SYNC_IN || path220) && (g188 || SYNC_IN || path220) && (g330 || SYNC_IN || path220) && (g328 || SYNC_IN || path220) && (g160 || SYNC_IN || ~path220) && (g188 || SYNC_IN || ~path220) && (g330 || SYNC_IN || ~path220) && (g328 || SYNC_IN || ~path220)) || ~((g162 || SYNC_IN || path220) && (g193 || SYNC_IN || path220) && (g191 || SYNC_IN || path220) && (g100 || SYNC_IN || path220) && (g162 || SYNC_IN || ~path220) && (g193 || SYNC_IN || ~path220) && (g191 || SYNC_IN || ~path220) && (g100 || SYNC_IN || ~path220)));
assign path207 = ~(~((VCC && ~g377 && g995 && ~g820 && ~g364) || (~path795 && g377 && g995 && ~g820 && ~g364) || (~path627 && ~g377 && ~g995 && g820 && ~g364) || (~path621 && g377 && ~g995 && g820 && ~g364) || (~path618 && ~g377 && g995 && g820 && ~g364) || (~path842 && g377 && g995 && g820 && ~g364) || (~path227 && ~g377 && ~g995 && ~g820 && g364) || (~path303 && g377 && ~g995 && ~g820 && g364)) && ~((~path802 && ~g377 && g995 && ~g820 && g364) || (g66 && g377 && g995 && ~g820 && g364)));
assign path208 = path269 && ~path408;
assign path209 = ~(~((~path627 && ~g377 && ~g995 && ~g820 && ~g364) || (~path621 && g377 && ~g995 && ~g820 && ~g364) || (~path618 && ~g377 && g995 && ~g820 && ~g364) || (~path842 && g377 && g995 && ~g820 && ~g364) || (~path227 && ~g377 && ~g995 && g820 && ~g364) || (~path303 && g377 && ~g995 && g820 && ~g364) || (~path802 && ~g377 && g995 && g820 && ~g364) || (g66 && g377 && g995 && g820 && ~g364)) && ~((g601 && ~g377 && ~g995 && ~g820 && g364) || (g606 && g377 && ~g995 && ~g820 && g364) || (g864 && ~g377 && g995 && ~g820 && g364) || (g866 && g377 && g995 && ~g820 && g364)));
assign path214 = ~(~(g377 && ~g995 && ~g820 && g364) && ~(~path795 && ~g377 && g995 && ~g820 && g364) && ~(~path627 && g377 && g995 && ~g820 && g364));
assign path219 = ~(~(GND && RAM_A0_OUT) && ~(GND && ~RAM_A0_OUT));
assign path231 = ~(g540 ^ ~(VCC ^ (g188 || SYNC_IN || path220)));
assign path264 = ~(~((~path795 && ~g377 && ~g995 && ~g820 && ~g364) || (~path627 && g377 && ~g995 && ~g820 && ~g364) || (~path621 && ~g377 && g995 && ~g820 && ~g364) || (~path618 && g377 && g995 && ~g820 && ~g364) || (~path842 && ~g377 && ~g995 && g820 && ~g364) || (~path227 && g377 && ~g995 && g820 && ~g364) || (~path303 && ~g377 && g995 && g820 && ~g364) || (~path802 && g377 && g995 && g820 && ~g364)) && ~((g66 && ~g377 && ~g995 && ~g820 && g364) || (g601 && g377 && ~g995 && ~g820 && g364) || (g606 && ~g377 && g995 && ~g820 && g364) || (g864 && g377 && g995 && ~g820 && g364)));
assign path31 = ~(~(path148 && (path117 || path919)) && ~(path33 && path118 && path920));
assign path323 = g488 && g526 && (path22 || ~UNK34_IN);
assign path332 = (~path227 && ~g377 && ~g995 && ~g820 && ~g364) || (~path303 && g377 && ~g995 && ~g820 && ~g364) || (~path802 && ~g377 && g995 && ~g820 && ~g364) || (g66 && g377 && g995 && ~g820 && ~g364) || (g601 && ~g377 && ~g995 && g820 && ~g364) || (g606 && g377 && ~g995 && g820 && ~g364) || (g864 && ~g377 && g995 && g820 && ~g364) || (g866 && g377 && g995 && g820 && ~g364);
assign path358 = ~(~((~path621 && ~g377 && ~g995 && ~g820 && ~g364) || (~path618 && g377 && ~g995 && ~g820 && ~g364) || (~path842 && ~g377 && g995 && ~g820 && ~g364) || (~path227 && g377 && g995 && ~g820 && ~g364) || (~path303 && ~g377 && ~g995 && g820 && ~g364) || (~path802 && g377 && ~g995 && g820 && ~g364) || (g66 && ~g377 && g995 && g820 && ~g364) || (g601 && g377 && g995 && g820 && ~g364)) && ~((g606 && ~g377 && ~g995 && ~g820 && g364) || (g864 && g377 && ~g995 && ~g820 && g364) || (g866 && ~g377 && g995 && ~g820 && g364) || (GND && g377 && g995 && ~g820 && g364)));
assign path393 = ~(~((~path842 && ~g377 && ~g995 && ~g820 && ~g364) || (~path227 && g377 && ~g995 && ~g820 && ~g364) || (~path303 && ~g377 && g995 && ~g820 && ~g364) || (~path802 && g377 && g995 && ~g820 && ~g364) || (g66 && ~g377 && ~g995 && g820 && ~g364) || (g601 && g377 && ~g995 && g820 && ~g364) || (g606 && ~g377 && g995 && g820 && ~g364) || (g864 && g377 && g995 && g820 && ~g364)) && ~(g866 && ~g377 && ~g995 && ~g820 && g364));
assign path409 = path414 && ~path408;
assign path418 = ~(~(path275 && (path117 || path919)) && ~(path798 && path118 && path920));
assign path463 = ~(~(path465 && (path117 || path919)) && ~(path506 && path118 && path920));
assign path531 = ~(~(path533 && (path117 || path919)) && ~(path996 && path118 && path920));
assign path544 = (g100 || SYNC_IN || ~path220) && (g100 || SYNC_IN || path220);
assign path547 = VCC && path567 && path568 && path569 && path570 && path571;
assign path549 = ~(~(path971 && (path117 || path919)) && ~(path966 && path118 && path920));
assign path553 = path266 && ~path408;
assign path573 = ~(~(path272 && (path117 || path919)) && ~(path799 && path118 && path920));
assign path580 = ~(~(~g377 && ~g995 && ~g820 && g364) && ~(~path795 && g377 && ~g995 && ~g820 && g364) && ~(~path627 && ~g377 && g995 && ~g820 && g364) && ~(~path621 && g377 && g995 && ~g820 && g364));
assign path582 = ~(VCC && ~(VCC && g377 && g995 && g820 && ~g364) && ~(~path795 && ~g377 && ~g995 && ~g820 && g364) && ~(~path627 && g377 && ~g995 && ~g820 && g364) && ~(~path621 && ~g377 && g995 && ~g820 && g364) && ~(~path618 && g377 && g995 && ~g820 && g364));
assign path583 = ~(~((VCC && ~g377 && ~g995 && ~g820 && ~g364) || (~path795 && g377 && ~g995 && ~g820 && ~g364) || (~path627 && ~g377 && g995 && ~g820 && ~g364) || (~path621 && g377 && g995 && ~g820 && ~g364) || (~path618 && ~g377 && ~g995 && g820 && ~g364) || (~path842 && g377 && ~g995 && g820 && ~g364) || (~path227 && ~g377 && g995 && g820 && ~g364) || (~path303 && g377 && g995 && g820 && ~g364)) && ~((~path802 && ~g377 && ~g995 && ~g820 && g364) || (g66 && g377 && ~g995 && ~g820 && g364) || (g601 && ~g377 && g995 && ~g820 && g364) || (g606 && g377 && g995 && ~g820 && g364)));
assign path584 = ~(~(g411 && (path117 || path919)) && ~(path149 && path118 && path920));
assign path586 = ~(~(~(~(g411 && (path117 || path919)) && ~(path149 && path118 && path920)) && RAM_A0_OUT) && ~(~(~(g364 && g820) && path669 && ~path408) && ~RAM_A0_OUT));
assign path587 = ~(~(~(~(g268 && (path117 || path919)) && ~(path265 && path118 && path920)) && RAM_A0_OUT) && ~(~path440 && ~RAM_A0_OUT));
assign path594 = (VCC && ~g377 && g995 && g820 && ~g364) || (~path795 && g377 && g995 && g820 && ~g364) || (~path627 && ~g377 && ~g995 && ~g820 && g364) || (~path621 && g377 && ~g995 && ~g820 && g364) || (~path618 && ~g377 && g995 && ~g820 && g364) || (~path842 && g377 && g995 && ~g820 && g364);
assign path608 = FSYNC_IN && ~(g488 && g526 && (path22 || ~UNK34_IN));
assign path640 = ~(~(path807 && ~g137) && ~(path653 && g137)) && ~path408;
assign path655 = ~(~(path170 && (path117 || path919)) && ~(path142 && path118 && path920));
assign path668 = ~(~(path962 && (path117 || path919)) && ~(path959 && path118 && path920));
assign path685 = ~(~(g558 && (path117 || path919)) && ~(path334 && path118 && path920));
assign path687 = path759 && ~path408;
assign path688 = (VCC && ~g377 && ~g995 && g820 && ~g364) || (~path795 && g377 && ~g995 && g820 && ~g364) || (~path627 && ~g377 && g995 && g820 && ~g364) || (~path621 && g377 && g995 && g820 && ~g364) || (~path618 && ~g377 && ~g995 && ~g820 && g364) || (~path842 && g377 && ~g995 && ~g820 && g364) || (~path227 && ~g377 && g995 && ~g820 && g364) || (~path303 && g377 && g995 && ~g820 && g364);
assign path693 = ~(~(~(~(path749 && (path117 || path919)) && ~(path177 && path118 && path920)) && RAM_A0_OUT) && ~(~(~(g413 && (path117 || path919)) && ~(path998 && path118 && path920)) && ~RAM_A0_OUT));
assign path709 = ~(g540 ^ ~(g540 ^ ~(VCC ^ (g188 || SYNC_IN || path220))));
assign path710 = ~(~path795 ^ ~(UNK_VCC? ^ ~(VCC ^ (g162 || SYNC_IN || path220))));
assign path758 = ~(~(g658 && (path117 || path919)) && ~(path997 && path118 && path920));
assign path760 = path166 && ~path408;
assign path808 = ~(~((g328 || SYNC_IN || path220) ^ VCC) ^ VCC);
assign path850 = (GND && ~g377 && ~g995 && g820 && ~g364) || (VCC && g377 && ~g995 && g820 && ~g364) || (~path795 && ~g377 && g995 && g820 && ~g364) || (~path627 && g377 && g995 && g820 && ~g364) || (~path621 && ~g377 && ~g995 && ~g820 && g364) || (~path618 && g377 && ~g995 && ~g820 && g364) || (~path842 && ~g377 && g995 && ~g820 && g364) || (~path227 && g377 && g995 && ~g820 && g364);
assign path857 = ~(~((GND && ~g377 && ~g995 && ~g820 && ~g364) || (VCC && g377 && ~g995 && ~g820 && ~g364) || (~path795 && ~g377 && g995 && ~g820 && ~g364) || (~path627 && g377 && g995 && ~g820 && ~g364) || (~path621 && ~g377 && ~g995 && g820 && ~g364) || (~path618 && g377 && ~g995 && g820 && ~g364) || (~path842 && ~g377 && g995 && g820 && ~g364) || (~path227 && g377 && g995 && g820 && ~g364)) && ~((~path303 && ~g377 && ~g995 && ~g820 && g364) || (~path802 && g377 && ~g995 && ~g820 && g364) || (g66 && ~g377 && g995 && ~g820 && g364) || (g601 && g377 && g995 && ~g820 && g364)));
assign path902 = ~(g8 ^ ~(VCC ^ (g160 || SYNC_IN || path220)));
assign path916 = path167 && ~path408;
assign path917 = path686 && ~path408;
assign path931 = ~(~(g915 && (path117 || path919)) && ~(path86 && path118 && path920));
assign path932 = ~(~((~path618 && ~g377 && ~g995 && ~g820 && ~g364) || (~path842 && g377 && ~g995 && ~g820 && ~g364) || (~path227 && ~g377 && g995 && ~g820 && ~g364) || (~path303 && g377 && g995 && ~g820 && ~g364) || (~path802 && ~g377 && ~g995 && g820 && ~g364) || (g66 && g377 && ~g995 && g820 && ~g364) || (g601 && ~g377 && g995 && g820 && ~g364) || (g606 && g377 && g995 && g820 && ~g364)) && ~((g864 && ~g377 && ~g995 && ~g820 && g364) || (g866 && g377 && ~g995 && ~g820 && g364)));
assign path942 = ~(~(~g377 && g995 && ~g820 && g364) && ~(~path795 && g377 && g995 && ~g820 && g364));
assign path973 = path978 && ~path408;
