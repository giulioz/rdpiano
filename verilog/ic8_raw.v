`timescale 1ns/100ps

module IC8 (
  input wire SYNC_IN,
  input wire FSYNC_IN,
  output wire FSYNC_OUT,

  input wire SR_SEL_IN, // 4, maybe inverted
  input wire MPX1_IN,
  output wire MPX1_OUT,
  output wire MPX2_OUT,
  input wire MPX1_IOM, // 72, maybe inverted

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



cell_LT4 A104 ( // 4-bit Data Latch
  path2452, // INPUT G
  R10_D1_IN, // INPUT DA
  R10_D0_IN, // INPUT DB
  R10_D7_IN, // INPUT DC
  R10_D6_IN, // INPUT DD
  unconnected_A104_NA, // OUTPUT NA
  g2511, // OUTPUT PA
  unconnected_A104_NB, // OUTPUT NB
  g1994, // OUTPUT PB
  path2508, // OUTPUT NC
  unconnected_A104_PC, // OUTPUT PC
  path2507, // OUTPUT ND
  unconnected_A104_PD // OUTPUT PD
);

cell_LT4 A144 ( // 4-bit Data Latch
  path2452, // INPUT G
  R10_D5_IN, // INPUT DA
  R10_D4_IN, // INPUT DB
  R10_D3_IN, // INPUT DC
  R10_D2_IN, // INPUT DD
  path1300, // OUTPUT NA
  unconnected_A144_PA, // OUTPUT PA
  path2335, // OUTPUT NB
  unconnected_A144_PB, // OUTPUT PB
  path2336, // OUTPUT NC
  unconnected_A144_PC, // OUTPUT PC
  unconnected_A144_ND, // OUTPUT ND
  g1341 // OUTPUT PD
);

cell_LT4 K101 ( // 4-bit Data Latch
  SYNC_IN, // INPUT G
  path1789, // INPUT DA
  path1788, // INPUT DB
  path1960, // INPUT DC
  path1680, // INPUT DD
  unconnected_K101_NA, // OUTPUT NA
  path1684, // OUTPUT PA
  unconnected_K101_NB, // OUTPUT NB
  path1683, // OUTPUT PB
  unconnected_K101_NC, // OUTPUT NC
  path1682, // OUTPUT PC
  unconnected_K101_ND, // OUTPUT ND
  path1681 // OUTPUT PD
);

cell_LT4 K117 ( // 4-bit Data Latch
  SYNC_IN, // INPUT G
  path1911, // INPUT DA
  path2469, // INPUT DB
  path2365, // INPUT DC
  path1672, // INPUT DD
  unconnected_K117_NA, // OUTPUT NA
  path1912, // OUTPUT PA
  unconnected_K117_NB, // OUTPUT NB
  path2366, // OUTPUT PB
  unconnected_K117_NC, // OUTPUT NC
  path2367, // OUTPUT PC
  unconnected_K117_ND, // OUTPUT ND
  path2368 // OUTPUT PD
);

cell_LT4 K137 ( // 4-bit Data Latch
  SYNC_IN, // INPUT G
  path1906, // INPUT DA
  path1514, // INPUT DB
  path1907, // INPUT DC
  path2467, // INPUT DD
  unconnected_K137_NA, // OUTPUT NA
  path2098, // OUTPUT PA
  unconnected_K137_NB, // OUTPUT NB
  path1515, // OUTPUT PB
  unconnected_K137_NC, // OUTPUT NC
  path1517, // OUTPUT PC
  unconnected_K137_ND, // OUTPUT ND
  path1516 // OUTPUT PD
);

cell_LT4 K77 ( // 4-bit Data Latch
  SYNC_IN, // INPUT G
  g2235, // INPUT DA
  path1659, // INPUT DB
  path2270, // INPUT DC
  path2468, // INPUT DD
  unconnected_K77_NA, // OUTPUT NA
  path1645, // OUTPUT PA
  unconnected_K77_NB, // OUTPUT NB
  path1656, // OUTPUT PB
  unconnected_K77_NC, // OUTPUT NC
  path1657, // OUTPUT PC
  unconnected_K77_ND, // OUTPUT ND
  path1658 // OUTPUT PD
);

cell_LT4 O80 ( // 4-bit Data Latch
  g1731, // INPUT G
  g1981, // INPUT DA
  g2280, // INPUT DB
  g2282, // INPUT DC
  g2261, // INPUT DD
  unconnected_O80_NA, // OUTPUT NA
  path2736, // OUTPUT PA
  unconnected_O80_NB, // OUTPUT NB
  path1969, // OUTPUT PB
  unconnected_O80_NC, // OUTPUT NC
  path2316, // OUTPUT PC
  unconnected_O80_ND, // OUTPUT ND
  path2317 // OUTPUT PD
);

cell_LT4 O96 ( // 4-bit Data Latch
  g1976, // INPUT G
  g1981, // INPUT DA
  g2280, // INPUT DB
  g2282, // INPUT DC
  g2261, // INPUT DD
  unconnected_O96_NA, // OUTPUT NA
  path1968, // OUTPUT PA
  unconnected_O96_NB, // OUTPUT NB
  path2267, // OUTPUT PB
  unconnected_O96_NC, // OUTPUT NC
  path2268, // OUTPUT PC
  unconnected_O96_ND, // OUTPUT ND
  path2262 // OUTPUT PD
);

cell_LT4 P32 ( // 4-bit Data Latch
  r10_ff_clock, // INPUT G
  path2403, // INPUT DA
  g2256, // INPUT DB
  path2180, // INPUT DC
  path2406, // INPUT DD
  unconnected_P32_NA, // OUTPUT NA
  path2404, // OUTPUT PA
  path2734, // OUTPUT NB
  path2181, // OUTPUT PB
  path2733, // OUTPUT NC
  path2735, // OUTPUT PC
  path2732, // OUTPUT ND
  path2405 // OUTPUT PD
);

cell_LT4 P61 ( // 4-bit Data Latch
  g44, // INPUT G
  path1781, // INPUT DA
  path1742, // INPUT DB
  path2058, // INPUT DC
  path1393, // INPUT DD
  unconnected_P61_NA, // OUTPUT NA
  path1782, // OUTPUT PA
  unconnected_P61_NB, // OUTPUT NB
  path1741, // OUTPUT PB
  unconnected_P61_NC, // OUTPUT NC
  path2319, // OUTPUT PC
  unconnected_P61_ND, // OUTPUT ND
  path1394 // OUTPUT PD
);

cell_LT4 P80 ( // 4-bit Data Latch
  g2048, // INPUT G
  g1981, // INPUT DA
  g2280, // INPUT DB
  g2282, // INPUT DC
  g2261, // INPUT DD
  unconnected_P80_NA, // OUTPUT NA
  path2772, // OUTPUT PA
  unconnected_P80_NB, // OUTPUT NB
  path2769, // OUTPUT PB
  unconnected_P80_NC, // OUTPUT NC
  path1939, // OUTPUT PC
  unconnected_P80_ND, // OUTPUT ND
  path2290 // OUTPUT PD
);

cell_LT4 Q128 ( // 4-bit Data Latch
  g1643, // INPUT G
  g1981, // INPUT DA
  g2280, // INPUT DB
  g2282, // INPUT DC
  g2261, // INPUT DD
  unconnected_Q128_NA, // OUTPUT NA
  path1973, // OUTPUT PA
  unconnected_Q128_NB, // OUTPUT NB
  path2770, // OUTPUT PB
  unconnected_Q128_NC, // OUTPUT NC
  path2273, // OUTPUT PC
  unconnected_Q128_ND, // OUTPUT ND
  path2276 // OUTPUT PD
);

cell_LT4 Q141 ( // 4-bit Data Latch
  path2231, // INPUT G
  g1981, // INPUT DA
  g2280, // INPUT DB
  g2282, // INPUT DC
  g2261, // INPUT DD
  unconnected_Q141_NA, // OUTPUT NA
  path2277, // OUTPUT PA
  unconnected_Q141_NB, // OUTPUT NB
  path2771, // OUTPUT PB
  unconnected_Q141_NC, // OUTPUT NC
  path2274, // OUTPUT PC
  unconnected_Q141_ND, // OUTPUT ND
  path2275 // OUTPUT PD
);

cell_LT4 R104 ( // 4-bit Data Latch
  g2043, // INPUT G
  g1981, // INPUT DA
  g2280, // INPUT DB
  g2282, // INPUT DC
  g2261, // INPUT DD
  unconnected_R104_NA, // OUTPUT NA
  path2278, // OUTPUT PA
  unconnected_R104_NB, // OUTPUT NB
  path1971, // OUTPUT PB
  unconnected_R104_NC, // OUTPUT NC
  path1972, // OUTPUT PC
  unconnected_R104_ND, // OUTPUT ND
  path2291 // OUTPUT PD
);

cell_LT4 R64 ( // 4-bit Data Latch
  g44, // INPUT G
  g1462, // INPUT DA
  path1366, // INPUT DB
  path1361, // INPUT DC
  path2201, // INPUT DD
  unconnected_R64_NA, // OUTPUT NA
  path2408, // OUTPUT PA
  unconnected_R64_NB, // OUTPUT NB
  path1365, // OUTPUT PB
  unconnected_R64_NC, // OUTPUT NC
  path1362, // OUTPUT PC
  unconnected_R64_ND, // OUTPUT ND
  path1729 // OUTPUT PD
);

cell_LT4 R77 ( // 4-bit Data Latch
  g2436, // INPUT G
  g1981, // INPUT DA
  g2280, // INPUT DB
  g2282, // INPUT DC
  g2261, // INPUT DD
  unconnected_R77_NA, // OUTPUT NA
  path2265, // OUTPUT PA
  unconnected_R77_NB, // OUTPUT NB
  path2266, // OUTPUT PB
  unconnected_R77_NC, // OUTPUT NC
  path2768, // OUTPUT PC
  unconnected_R77_ND, // OUTPUT ND
  path2263 // OUTPUT PD
);

cell_LT4 R90 ( // 4-bit Data Latch
  g1865, // INPUT G
  g1981, // INPUT DA
  g2280, // INPUT DB
  g2282, // INPUT DC
  g2261, // INPUT DD
  unconnected_R90_NA, // OUTPUT NA
  path2264, // OUTPUT PA
  unconnected_R90_NB, // OUTPUT NB
  path1970, // OUTPUT PB
  unconnected_R90_NC, // OUTPUT NC
  path2315, // OUTPUT PC
  unconnected_R90_ND, // OUTPUT ND
  path2314 // OUTPUT PD
);

cell_LT4 S118 ( // 4-bit Data Latch
  g2043, // INPUT G
  g2773, // INPUT DA
  path2238, // INPUT DB
  path2239, // INPUT DC
  path2240, // INPUT DD
  unconnected_S118_NA, // OUTPUT NA
  path2750, // OUTPUT PA
  unconnected_S118_NB, // OUTPUT NB
  path2302, // OUTPUT PB
  unconnected_S118_NC, // OUTPUT NC
  path2292, // OUTPUT PC
  unconnected_S118_ND, // OUTPUT ND
  path1904 // OUTPUT PD
);

cell_LT4 S131 ( // 4-bit Data Latch
  g1643, // INPUT G
  g2773, // INPUT DA
  path2238, // INPUT DB
  path2239, // INPUT DC
  path2240, // INPUT DD
  unconnected_S131_NA, // OUTPUT NA
  path2303, // OUTPUT PA
  unconnected_S131_NB, // OUTPUT NB
  path2775, // OUTPUT PB
  unconnected_S131_NC, // OUTPUT NC
  path2678, // OUTPUT PC
  unconnected_S131_ND, // OUTPUT ND
  path2677 // OUTPUT PD
);

cell_LT4 S144 ( // 4-bit Data Latch
  g1976, // INPUT G
  g2773, // INPUT DA
  path2238, // INPUT DB
  path2239, // INPUT DC
  path2240, // INPUT DD
  unconnected_S144_NA, // OUTPUT NA
  path2632, // OUTPUT PA
  unconnected_S144_NB, // OUTPUT NB
  path2237, // OUTPUT PB
  unconnected_S144_NC, // OUTPUT NC
  path2305, // OUTPUT PC
  unconnected_S144_ND, // OUTPUT ND
  path1397 // OUTPUT PD
);

cell_LT4 S77 ( // 4-bit Data Latch
  g1731, // INPUT G
  g2773, // INPUT DA
  path2238, // INPUT DB
  path2239, // INPUT DC
  path2240, // INPUT DD
  unconnected_S77_NA, // OUTPUT NA
  path2299, // OUTPUT PA
  unconnected_S77_NB, // OUTPUT NB
  path2298, // OUTPUT PB
  unconnected_S77_NC, // OUTPUT NC
  path2661, // OUTPUT PC
  unconnected_S77_ND, // OUTPUT ND
  path2680 // OUTPUT PD
);

cell_LT4 T131 ( // 4-bit Data Latch
  g2436, // INPUT G
  g2773, // INPUT DA
  path2238, // INPUT DB
  path2239, // INPUT DC
  path2240, // INPUT DD
  unconnected_T131_NA, // OUTPUT NA
  path2631, // OUTPUT PA
  unconnected_T131_NB, // OUTPUT NB
  path2679, // OUTPUT PB
  unconnected_T131_NC, // OUTPUT NC
  path2774, // OUTPUT PC
  unconnected_T131_ND, // OUTPUT ND
  path1903 // OUTPUT PD
);

cell_LT4 T144 ( // 4-bit Data Latch
  path2231, // INPUT G
  g2773, // INPUT DA
  path2238, // INPUT DB
  path2239, // INPUT DC
  path2240, // INPUT DD
  unconnected_T144_NA, // OUTPUT NA
  path2304, // OUTPUT PA
  unconnected_T144_NB, // OUTPUT NB
  path2294, // OUTPUT PB
  unconnected_T144_NC, // OUTPUT NC
  path2293, // OUTPUT PC
  unconnected_T144_ND, // OUTPUT ND
  path1398 // OUTPUT PD
);

cell_LT4 T45 ( // 4-bit Data Latch
  g44, // INPUT G
  path1697, // INPUT DA
  path1700, // INPUT DB
  path2665, // INPUT DC
  path1698, // INPUT DD
  unconnected_T45_NA, // OUTPUT NA
  path1699, // OUTPUT PA
  unconnected_T45_NB, // OUTPUT NB
  path2666, // OUTPUT PB
  unconnected_T45_NC, // OUTPUT NC
  path2242, // OUTPUT PC
  unconnected_T45_ND, // OUTPUT ND
  path1891 // OUTPUT PD
);

cell_LT4 T77 ( // 4-bit Data Latch
  g1865, // INPUT G
  g2773, // INPUT DA
  path2238, // INPUT DB
  path2239, // INPUT DC
  path2240, // INPUT DD
  unconnected_T77_NA, // OUTPUT NA
  path2300, // OUTPUT PA
  unconnected_T77_NB, // OUTPUT NB
  path2301, // OUTPUT PB
  unconnected_T77_NC, // OUTPUT NC
  path2295, // OUTPUT PC
  unconnected_T77_ND, // OUTPUT ND
  path1531 // OUTPUT PD
);

cell_LT4 T90 ( // 4-bit Data Latch
  g2048, // INPUT G
  g2773, // INPUT DA
  path2238, // INPUT DB
  path2239, // INPUT DC
  path2240, // INPUT DD
  unconnected_T90_NA, // OUTPUT NA
  path1530, // OUTPUT PA
  unconnected_T90_NB, // OUTPUT NB
  path2751, // OUTPUT PB
  unconnected_T90_NC, // OUTPUT NC
  path2789, // OUTPUT PC
  unconnected_T90_ND, // OUTPUT ND
  path2306 // OUTPUT PD
);

cell_LT4 B1 ( // 4-bit Data Latch
  g2564, // INPUT G
  path2576, // INPUT DA
  IC19_4_IN, // INPUT DB
  g2417, // INPUT DC
  IC19_2_IN, // INPUT DD
  unconnected_B1_NA, // OUTPUT NA
  path2575, // OUTPUT PA
  unconnected_B1_NB, // OUTPUT NB
  path38, // OUTPUT PB
  unconnected_B1_NC, // OUTPUT NC
  path1374, // OUTPUT PC
  unconnected_B1_ND, // OUTPUT ND
  path2320 // OUTPUT PD
);

cell_LT4 B104 ( // 4-bit Data Latch
  g1750, // INPUT G
  g1650, // INPUT DA
  g1655, // INPUT DB
  g2586, // INPUT DC
  g2588, // INPUT DD
  path2164, // OUTPUT NA
  unconnected_B104_PA, // OUTPUT PA
  path2149, // OUTPUT NB
  unconnected_B104_PB, // OUTPUT PB
  path2148, // OUTPUT NC
  unconnected_B104_PC, // OUTPUT PC
  path2165, // OUTPUT ND
  unconnected_B104_PD // OUTPUT PD
);

cell_LT4 B117 ( // 4-bit Data Latch
  path1752, // INPUT G
  g1650, // INPUT DA
  g1655, // INPUT DB
  g2586, // INPUT DC
  g2588, // INPUT DD
  path13, // OUTPUT NA
  unconnected_B117_PA, // OUTPUT PA
  path2754, // OUTPUT NB
  unconnected_B117_PB, // OUTPUT PB
  path2753, // OUTPUT NC
  unconnected_B117_PC, // OUTPUT PC
  path2166, // OUTPUT ND
  unconnected_B117_PD // OUTPUT PD
);

cell_LT4 B130 ( // 4-bit Data Latch
  path1607, // INPUT G
  g1650, // INPUT DA
  g1655, // INPUT DB
  g2586, // INPUT DC
  g2588, // INPUT DD
  path2079, // OUTPUT NA
  unconnected_B130_PA, // OUTPUT PA
  path2076, // OUTPUT NB
  unconnected_B130_PB, // OUTPUT PB
  path2089, // OUTPUT NC
  unconnected_B130_PC, // OUTPUT PC
  path2153, // OUTPUT ND
  unconnected_B130_PD // OUTPUT PD
);

cell_LT4 B143 ( // 4-bit Data Latch
  g1691, // INPUT G
  g1650, // INPUT DA
  g1655, // INPUT DB
  g2586, // INPUT DC
  g2588, // INPUT DD
  path2078, // OUTPUT NA
  unconnected_B143_PA, // OUTPUT PA
  path2151, // OUTPUT NB
  unconnected_B143_PB, // OUTPUT PB
  path2395, // OUTPUT NC
  unconnected_B143_PC, // OUTPUT PC
  path2396, // OUTPUT ND
  unconnected_B143_PD // OUTPUT PD
);

cell_LT4 B84 ( // 4-bit Data Latch
  path2106, // INPUT G
  R10_D1_IN, // INPUT DA
  R10_D0_IN, // INPUT DB
  VCC, // INPUT DC
  VCC, // INPUT DD
  unconnected_B84_NA, // OUTPUT NA
  path2162, // OUTPUT PA
  unconnected_B84_NB, // OUTPUT NB
  path2740, // OUTPUT PB
  unconnected_B84_NC, // OUTPUT NC
  unconnected_B84_PC, // OUTPUT PC
  unconnected_B84_ND, // OUTPUT ND
  unconnected_B84_PD // OUTPUT PD
);

cell_LT4 U77 ( // 4-bit Data Latch
  g44, // INPUT G
  path1411, // INPUT DA
  path1723, // INPUT DB
  path1464, // INPUT DC
  path1724, // INPUT DD
  unconnected_U77_NA, // OUTPUT NA
  path1410, // OUTPUT PA
  unconnected_U77_NB, // OUTPUT NB
  path1465, // OUTPUT PB
  unconnected_U77_NC, // OUTPUT NC
  path1785, // OUTPUT PC
  unconnected_U77_ND, // OUTPUT ND
  path1678 // OUTPUT PD
);

cell_LT4 V110 ( // 4-bit Data Latch
  g1976, // INPUT G
  g2213, // INPUT DA
  g2656, // INPUT DB
  g2207, // INPUT DC
  g2219, // INPUT DD
  unconnected_V110_NA, // OUTPUT NA
  path2483, // OUTPUT PA
  unconnected_V110_NB, // OUTPUT NB
  path2641, // OUTPUT PB
  unconnected_V110_NC, // OUTPUT NC
  path2481, // OUTPUT PC
  unconnected_V110_ND, // OUTPUT ND
  path2482 // OUTPUT PD
);

cell_LT4 V123 ( // 4-bit Data Latch
  g1731, // INPUT G
  g2213, // INPUT DA
  g2656, // INPUT DB
  g2207, // INPUT DC
  g2219, // INPUT DD
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
  g1731, // INPUT G
  g2788, // INPUT DA
  g1491, // INPUT DB
  g1473, // INPUT DC
  path2425, // INPUT DD
  unconnected_W103_NA, // OUTPUT NA
  path2640, // OUTPUT PA
  unconnected_W103_NB, // OUTPUT NB
  path2473, // OUTPUT PB
  unconnected_W103_NC, // OUTPUT NC
  path2660, // OUTPUT PC
  unconnected_W103_ND, // OUTPUT ND
  path2724 // OUTPUT PD
);

cell_LT4 W116 ( // 4-bit Data Latch
  g2048, // INPUT G
  g2788, // INPUT DA
  g1491, // INPUT DB
  g1473, // INPUT DC
  path2425, // INPUT DD
  unconnected_W116_NA, // OUTPUT NA
  path2284, // OUTPUT PA
  unconnected_W116_NB, // OUTPUT NB
  path2285, // OUTPUT PB
  unconnected_W116_NC, // OUTPUT NC
  path1679, // OUTPUT PC
  unconnected_W116_ND, // OUTPUT ND
  path2645 // OUTPUT PD
);

cell_LT4 W131 ( // 4-bit Data Latch
  g1976, // INPUT G
  g2788, // INPUT DA
  g1491, // INPUT DB
  g1473, // INPUT DC
  path2425, // INPUT DD
  unconnected_W131_NA, // OUTPUT NA
  path2723, // OUTPUT PA
  unconnected_W131_NB, // OUTPUT NB
  path2474, // OUTPUT PB
  unconnected_W131_NC, // OUTPUT NC
  path2478, // OUTPUT PC
  unconnected_W131_ND, // OUTPUT ND
  path2472 // OUTPUT PD
);

cell_LT4 W144 ( // 4-bit Data Latch
  path2231, // INPUT G
  g2788, // INPUT DA
  g1491, // INPUT DB
  g1473, // INPUT DC
  path2425, // INPUT DD
  unconnected_W144_NA, // OUTPUT NA
  path2648, // OUTPUT PA
  unconnected_W144_NB, // OUTPUT NB
  path1474, // OUTPUT PB
  unconnected_W144_NC, // OUTPUT NC
  path2638, // OUTPUT PC
  unconnected_W144_ND, // OUTPUT ND
  path2228 // OUTPUT PD
);

cell_LT4 W77 ( // 4-bit Data Latch
  g2048, // INPUT G
  g2213, // INPUT DA
  g2656, // INPUT DB
  g2207, // INPUT DC
  g2219, // INPUT DD
  unconnected_W77_NA, // OUTPUT NA
  path2210, // OUTPUT PA
  unconnected_W77_NB, // OUTPUT NB
  path2209, // OUTPUT PB
  unconnected_W77_NC, // OUTPUT NC
  path2216, // OUTPUT PC
  unconnected_W77_ND, // OUTPUT ND
  path2230 // OUTPUT PD
);

cell_LT4 W90 ( // 4-bit Data Latch
  path2231, // INPUT G
  g2213, // INPUT DA
  g2656, // INPUT DB
  g2207, // INPUT DC
  g2219, // INPUT DD
  unconnected_W90_NA, // OUTPUT NA
  path2214, // OUTPUT PA
  unconnected_W90_NB, // OUTPUT NB
  path2428, // OUTPUT PB
  unconnected_W90_NC, // OUTPUT NC
  path2427, // OUTPUT PC
  unconnected_W90_ND, // OUTPUT ND
  path2647 // OUTPUT PD
);

cell_LT4 X144 ( // 4-bit Data Latch
  g1643, // INPUT G
  g2213, // INPUT DA
  g2656, // INPUT DB
  g2207, // INPUT DC
  g2219, // INPUT DD
  unconnected_X144_NA, // OUTPUT NA
  path2211, // OUTPUT PA
  unconnected_X144_NB, // OUTPUT NB
  path2208, // OUTPUT PB
  unconnected_X144_NC, // OUTPUT NC
  path2217, // OUTPUT PC
  unconnected_X144_ND, // OUTPUT ND
  path2229 // OUTPUT PD
);

cell_LT4 X93 ( // 4-bit Data Latch
  g2043, // INPUT G
  g2213, // INPUT DA
  g2656, // INPUT DB
  g2207, // INPUT DC
  g2219, // INPUT DD
  unconnected_X93_NA, // OUTPUT NA
  path2215, // OUTPUT PA
  unconnected_X93_NB, // OUTPUT NB
  path2429, // OUTPUT PB
  unconnected_X93_NC, // OUTPUT NC
  path2430, // OUTPUT PC
  unconnected_X93_ND, // OUTPUT ND
  path2646 // OUTPUT PD
);

cell_LT4 Y104 ( // 4-bit Data Latch
  g2436, // INPUT G
  g2788, // INPUT DA
  g1491, // INPUT DB
  g1473, // INPUT DC
  path2425, // INPUT DD
  unconnected_Y104_NA, // OUTPUT NA
  path2226, // OUTPUT PA
  unconnected_Y104_NB, // OUTPUT NB
  path2652, // OUTPUT PB
  unconnected_Y104_NC, // OUTPUT NC
  path2477, // OUTPUT PC
  unconnected_Y104_ND, // OUTPUT ND
  path1738 // OUTPUT PD
);

cell_LT4 Y117 ( // 4-bit Data Latch
  g2043, // INPUT G
  g2788, // INPUT DA
  g1491, // INPUT DB
  g1473, // INPUT DC
  path2425, // INPUT DD
  unconnected_Y117_NA, // OUTPUT NA
  path2649, // OUTPUT PA
  unconnected_Y117_NB, // OUTPUT NB
  path2650, // OUTPUT PB
  unconnected_Y117_NC, // OUTPUT NC
  path2639, // OUTPUT PC
  unconnected_Y117_ND, // OUTPUT ND
  path2225 // OUTPUT PD
);

cell_LT4 Y130 ( // 4-bit Data Latch
  g1865, // INPUT G
  g2788, // INPUT DA
  g1491, // INPUT DB
  g1473, // INPUT DC
  path2425, // INPUT DD
  unconnected_Y130_NA, // OUTPUT NA
  path2651, // OUTPUT PA
  unconnected_Y130_NB, // OUTPUT NB
  path2475, // OUTPUT PB
  unconnected_Y130_NC, // OUTPUT NC
  path2659, // OUTPUT PC
  unconnected_Y130_ND, // OUTPUT ND
  path2476 // OUTPUT PD
);

cell_LT4 Y143 ( // 4-bit Data Latch
  g1643, // INPUT G
  g2788, // INPUT DA
  g1491, // INPUT DB
  g1473, // INPUT DC
  path2425, // INPUT DD
  unconnected_Y143_NA, // OUTPUT NA
  path1644, // OUTPUT PA
  unconnected_Y143_NB, // OUTPUT NB
  path1484, // OUTPUT PB
  unconnected_Y143_NC, // OUTPUT NC
  path2426, // OUTPUT PC
  unconnected_Y143_ND, // OUTPUT ND
  path2227 // OUTPUT PD
);

cell_LT4 Y77 ( // 4-bit Data Latch
  g1865, // INPUT G
  g2213, // INPUT DA
  g2656, // INPUT DB
  g2207, // INPUT DC
  g2219, // INPUT DD
  unconnected_Y77_NA, // OUTPUT NA
  path2643, // OUTPUT PA
  unconnected_Y77_NB, // OUTPUT NB
  path2642, // OUTPUT PB
  unconnected_Y77_NC, // OUTPUT NC
  path2431, // OUTPUT PC
  unconnected_Y77_ND, // OUTPUT ND
  path2432 // OUTPUT PD
);

cell_LT4 Y91 ( // 4-bit Data Latch
  g2436, // INPUT G
  g2213, // INPUT DA
  g2656, // INPUT DB
  g2207, // INPUT DC
  g2219, // INPUT DD
  unconnected_Y91_NA, // OUTPUT NA
  path2484, // OUTPUT PA
  unconnected_Y91_NB, // OUTPUT NB
  path2485, // OUTPUT PB
  unconnected_Y91_NC, // OUTPUT NC
  path2653, // OUTPUT PC
  unconnected_Y91_ND, // OUTPUT ND
  path2433 // OUTPUT PD
);

cell_LT4 C109 ( // 4-bit Data Latch
  g1614, // INPUT G
  g1650, // INPUT DA
  g1655, // INPUT DB
  g2586, // INPUT DC
  g2588, // INPUT DD
  path2086, // OUTPUT NA
  unconnected_C109_PA, // OUTPUT PA
  path2087, // OUTPUT NB
  unconnected_C109_PB, // OUTPUT PB
  path2088, // OUTPUT NC
  unconnected_C109_PC, // OUTPUT PC
  path2152, // OUTPUT ND
  unconnected_C109_PD // OUTPUT PD
);

cell_LT4 C144 ( // 4-bit Data Latch
  g2156, // INPUT G
  g1650, // INPUT DA
  g1655, // INPUT DB
  g2586, // INPUT DC
  g2588, // INPUT DD
  path2077, // OUTPUT NA
  unconnected_C144_PA, // OUTPUT PA
  path2150, // OUTPUT NB
  unconnected_C144_PB, // OUTPUT PB
  path2394, // OUTPUT NC
  unconnected_C144_PC, // OUTPUT PC
  path2533, // OUTPUT ND
  unconnected_C144_PD // OUTPUT PD
);

cell_LT4 C83 ( // 4-bit Data Latch
  path2540, // INPUT G
  g1650, // INPUT DA
  g1655, // INPUT DB
  g2586, // INPUT DC
  g2588, // INPUT DD
  path2163, // OUTPUT NA
  unconnected_C83_PA, // OUTPUT PA
  path2146, // OUTPUT NB
  unconnected_C83_PB, // OUTPUT PB
  path2147, // OUTPUT NC
  unconnected_C83_PC, // OUTPUT PC
  path2755, // OUTPUT ND
  unconnected_C83_PD // OUTPUT PD
);

cell_LT4 C96 ( // 4-bit Data Latch
  path1773, // INPUT G
  g1650, // INPUT DA
  g1655, // INPUT DB
  g2586, // INPUT DC
  g2588, // INPUT DD
  path2074, // OUTPUT NA
  unconnected_C96_PA, // OUTPUT PA
  path2075, // OUTPUT NB
  unconnected_C96_PB, // OUTPUT PB
  path2756, // OUTPUT NC
  unconnected_C96_PC, // OUTPUT PC
  path2761, // OUTPUT ND
  unconnected_C96_PD // OUTPUT PD
);

cell_LT4 D104 ( // 4-bit Data Latch
  g1750, // INPUT G
  g1917, // INPUT DA
  g2370, // INPUT DB
  g2584, // INPUT DC
  g2393, // INPUT DD
  path2376, // OUTPUT NA
  unconnected_D104_PA, // OUTPUT PA
  path2063, // OUTPUT NB
  unconnected_D104_PB, // OUTPUT PB
  path2173, // OUTPUT NC
  unconnected_D104_PC, // OUTPUT PC
  path2758, // OUTPUT ND
  unconnected_D104_PD // OUTPUT PD
);

cell_LT4 D117 ( // 4-bit Data Latch
  path1752, // INPUT G
  g1917, // INPUT DA
  g2370, // INPUT DB
  g2584, // INPUT DC
  g2393, // INPUT DD
  path1615, // OUTPUT NA
  unconnected_D117_PA, // OUTPUT PA
  path1616, // OUTPUT NB
  unconnected_D117_PB, // OUTPUT PB
  path2067, // OUTPUT NC
  unconnected_D117_PC, // OUTPUT PC
  path2066, // OUTPUT ND
  unconnected_D117_PD // OUTPUT PD
);

cell_LT4 D131 ( // 4-bit Data Latch
  path1607, // INPUT G
  g1917, // INPUT DA
  g2370, // INPUT DB
  g2584, // INPUT DC
  g2393, // INPUT DD
  path1919, // OUTPUT NA
  unconnected_D131_PA, // OUTPUT PA
  path2064, // OUTPUT NB
  unconnected_D131_PB, // OUTPUT PB
  path1617, // OUTPUT NC
  unconnected_D131_PC, // OUTPUT PC
  path2065, // OUTPUT ND
  unconnected_D131_PD // OUTPUT PD
);

cell_LT4 D144 ( // 4-bit Data Latch
  g1691, // INPUT G
  g1917, // INPUT DA
  g2370, // INPUT DB
  g2584, // INPUT DC
  g2393, // INPUT DD
  path2757, // OUTPUT NA
  unconnected_D144_PA, // OUTPUT PA
  path2371, // OUTPUT NB
  unconnected_D144_PB, // OUTPUT PB
  path2374, // OUTPUT NC
  unconnected_D144_PC, // OUTPUT PC
  path2375, // OUTPUT ND
  unconnected_D144_PD // OUTPUT PD
);

cell_LT4 D77 ( // 4-bit Data Latch
  path2540, // INPUT G
  g1917, // INPUT DA
  g2370, // INPUT DB
  g2584, // INPUT DC
  g2393, // INPUT DD
  path2580, // OUTPUT NA
  unconnected_D77_PA, // OUTPUT PA
  path2752, // OUTPUT NB
  unconnected_D77_PB, // OUTPUT PB
  path2389, // OUTPUT NC
  unconnected_D77_PC, // OUTPUT PC
  path2390, // OUTPUT ND
  unconnected_D77_PD // OUTPUT PD
);

cell_LT4 D90 ( // 4-bit Data Latch
  path1773, // INPUT G
  g1917, // INPUT DA
  g2370, // INPUT DB
  g2584, // INPUT DC
  g2393, // INPUT DD
  path2760, // OUTPUT NA
  unconnected_D90_PA, // OUTPUT PA
  path2531, // OUTPUT NB
  unconnected_D90_PB, // OUTPUT PB
  path2532, // OUTPUT NC
  unconnected_D90_PC, // OUTPUT PC
  path2759, // OUTPUT ND
  unconnected_D90_PD // OUTPUT PD
);

cell_LT4 E77 ( // 4-bit Data Latch
  g1614, // INPUT G
  g1917, // INPUT DA
  g2370, // INPUT DB
  g2584, // INPUT DC
  g2393, // INPUT DD
  path1918, // OUTPUT NA
  unconnected_E77_PA, // OUTPUT PA
  path2530, // OUTPUT NB
  unconnected_E77_PB, // OUTPUT PB
  path2068, // OUTPUT NC
  unconnected_E77_PC, // OUTPUT PC
  path2069, // OUTPUT ND
  unconnected_E77_PD // OUTPUT PD
);

cell_LT4 E90 ( // 4-bit Data Latch
  g2156, // INPUT G
  g1917, // INPUT DA
  g2370, // INPUT DB
  g2584, // INPUT DC
  g2393, // INPUT DD
  path2581, // OUTPUT NA
  unconnected_E90_PA, // OUTPUT PA
  path2372, // OUTPUT NB
  unconnected_E90_PB, // OUTPUT PB
  path2373, // OUTPUT NC
  unconnected_E90_PC, // OUTPUT PC
  path2391, // OUTPUT ND
  unconnected_E90_PD // OUTPUT PD
);

cell_LT4 F128 ( // 4-bit Data Latch
  g1691, // INPUT G
  g1689, // INPUT DA
  g2669, // INPUT DB
  g2671, // INPUT DC
  g2673, // INPUT DD
  path2742, // OUTPUT NA
  unconnected_F128_PA, // OUTPUT PA
  path2102, // OUTPUT NB
  unconnected_F128_PB, // OUTPUT PB
  path2101, // OUTPUT NC
  unconnected_F128_PC, // OUTPUT PC
  path1609, // OUTPUT ND
  unconnected_F128_PD // OUTPUT PD
);

cell_LT4 F142 ( // 4-bit Data Latch
  path1607, // INPUT G
  g1689, // INPUT DA
  g2669, // INPUT DB
  g2671, // INPUT DC
  g2673, // INPUT DD
  path1610, // OUTPUT NA
  unconnected_F142_PA, // OUTPUT PA
  path2094, // OUTPUT NB
  unconnected_F142_PB, // OUTPUT PB
  path2093, // OUTPUT NC
  unconnected_F142_PC, // OUTPUT PC
  path2397, // OUTPUT ND
  unconnected_F142_PD // OUTPUT PD
);

cell_LT4 F77 ( // 4-bit Data Latch
  g1750, // INPUT G
  g1689, // INPUT DA
  g2669, // INPUT DB
  g2671, // INPUT DC
  g2673, // INPUT DD
  path2741, // OUTPUT NA
  unconnected_F77_PA, // OUTPUT PA
  path1525, // OUTPUT NB
  unconnected_F77_PB, // OUTPUT PB
  path1524, // OUTPUT NC
  unconnected_F77_PC, // OUTPUT PC
  path2399, // OUTPUT ND
  unconnected_F77_PD // OUTPUT PD
);

cell_LT4 F90 ( // 4-bit Data Latch
  path1752, // INPUT G
  g1689, // INPUT DA
  g2669, // INPUT DB
  g2671, // INPUT DC
  g2673, // INPUT DD
  path2535, // OUTPUT NA
  unconnected_F90_PA, // OUTPUT PA
  path2536, // OUTPUT NB
  unconnected_F90_PB, // OUTPUT PB
  path2103, // OUTPUT NC
  unconnected_F90_PC, // OUTPUT PC
  path2104, // OUTPUT ND
  unconnected_F90_PD // OUTPUT PD
);

cell_LT4 G106 ( // 4-bit Data Latch
  g1614, // INPUT G
  g1689, // INPUT DA
  g2669, // INPUT DB
  g2671, // INPUT DC
  g2673, // INPUT DD
  path1611, // OUTPUT NA
  unconnected_G106_PA, // OUTPUT PA
  path2537, // OUTPUT NB
  unconnected_G106_PB, // OUTPUT PB
  path2092, // OUTPUT NC
  unconnected_G106_PC, // OUTPUT PC
  path2398, // OUTPUT ND
  unconnected_G106_PD // OUTPUT PD
);

cell_LT4 G143 ( // 4-bit Data Latch
  g2156, // INPUT G
  g1689, // INPUT DA
  g2669, // INPUT DB
  g2671, // INPUT DC
  g2673, // INPUT DD
  path2157, // OUTPUT NA
  unconnected_G143_PA, // OUTPUT PA
  path2158, // OUTPUT NB
  unconnected_G143_PB, // OUTPUT PB
  path2538, // OUTPUT NC
  unconnected_G143_PC, // OUTPUT PC
  path1608, // OUTPUT ND
  unconnected_G143_PD // OUTPUT PD
);

cell_LT4 G77 ( // 4-bit Data Latch
  path2540, // INPUT G
  g1689, // INPUT DA
  g2669, // INPUT DB
  g2671, // INPUT DC
  g2673, // INPUT DD
  path2743, // OUTPUT NA
  unconnected_G77_PA, // OUTPUT PA
  path2159, // OUTPUT NB
  unconnected_G77_PB, // OUTPUT PB
  path2783, // OUTPUT NC
  unconnected_G77_PC, // OUTPUT PC
  path2400, // OUTPUT ND
  unconnected_G77_PD // OUTPUT PD
);

cell_LT4 G90 ( // 4-bit Data Latch
  path1773, // INPUT G
  g1689, // INPUT DA
  g2669, // INPUT DB
  g2671, // INPUT DC
  g2673, // INPUT DD
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
  path1773, // INPUT G
  g1757, // INPUT DA
  path2099, // INPUT DB
  g1522, // INPUT DC
  g2488, // INPUT DD
  path1772, // OUTPUT NA
  unconnected_H101_PA, // OUTPUT PA
  path2496, // OUTPUT NB
  unconnected_H101_PB, // OUTPUT PB
  path2492, // OUTPUT NC
  unconnected_H101_PC, // OUTPUT PC
  path2493, // OUTPUT ND
  unconnected_H101_PD // OUTPUT PD
);

cell_LT4 H116 ( // 4-bit Data Latch
  g1691, // INPUT G
  g1757, // INPUT DA
  path2099, // INPUT DB
  g1522, // INPUT DC
  g2488, // INPUT DD
  path2193, // OUTPUT NA
  unconnected_H116_PA, // OUTPUT PA
  path2498, // OUTPUT NB
  unconnected_H116_PB, // OUTPUT PB
  path1523, // OUTPUT NC
  unconnected_H116_PC, // OUTPUT PC
  path2497, // OUTPUT ND
  unconnected_H116_PD // OUTPUT PD
);

cell_LT4 H57 ( // 4-bit Data Latch
  r10_ff_clock, // INPUT G
  path2763, // INPUT DA
  VCC, // INPUT DB
  path2160, // INPUT DC
  path2161, // INPUT DD
  path2708, // OUTPUT NA
  path2707, // OUTPUT PA
  unconnected_H57_NB, // OUTPUT NB
  unconnected_H57_PB, // OUTPUT PB
  unconnected_H57_NC, // OUTPUT NC
  g1387, // OUTPUT PC
  unconnected_H57_ND, // OUTPUT ND
  path2512 // OUTPUT PD
);

cell_LT4 H83 ( // 4-bit Data Latch
  path2540, // INPUT G
  g1757, // INPUT DA
  path2099, // INPUT DB
  g1522, // INPUT DC
  g2488, // INPUT DD
  path2490, // OUTPUT NA
  unconnected_H83_PA, // OUTPUT PA
  path2495, // OUTPUT NB
  unconnected_H83_PB, // OUTPUT PB
  path2501, // OUTPUT NC
  unconnected_H83_PC, // OUTPUT PC
  path2096, // OUTPUT ND
  unconnected_H83_PD // OUTPUT PD
);

cell_LT4 I3 ( // 4-bit Data Latch
  g2564, // INPUT G
  AG3_IN, // INPUT DA
  g7, // INPUT DB
  IC19_6_IN, // INPUT DC
  IC19_7_IN, // INPUT DD
  unconnected_I3_NA, // OUTPUT NA
  g1921, // OUTPUT PA
  unconnected_I3_NB, // OUTPUT NB
  path2112, // OUTPUT PB
  unconnected_I3_NC, // OUTPUT NC
  path1841, // OUTPUT PC
  unconnected_I3_ND, // OUTPUT ND
  path1840 // OUTPUT PD
);

cell_LT4 I77 ( // 4-bit Data Latch
  g1614, // INPUT G
  g1757, // INPUT DA
  path2099, // INPUT DB
  g1522, // INPUT DC
  g2488, // INPUT DD
  path2100, // OUTPUT NA
  unconnected_I77_PA, // OUTPUT PA
  path1758, // OUTPUT NB
  unconnected_I77_PB, // OUTPUT PB
  path2491, // OUTPUT NC
  unconnected_I77_PC, // OUTPUT PC
  path2494, // OUTPUT ND
  unconnected_I77_PD // OUTPUT PD
);

cell_LT4 I90 ( // 4-bit Data Latch
  g2156, // INPUT G
  g1757, // INPUT DA
  path2099, // INPUT DB
  g1522, // INPUT DC
  g2488, // INPUT DD
  path2502, // OUTPUT NA
  unconnected_I90_PA, // OUTPUT PA
  path2499, // OUTPUT NB
  unconnected_I90_PB, // OUTPUT PB
  path2500, // OUTPUT NC
  unconnected_I90_PC, // OUTPUT PC
  path2785, // OUTPUT ND
  unconnected_I90_PD // OUTPUT PD
);

cell_LT4 J112 ( // 4-bit Data Latch
  path1752, // INPUT G
  g1757, // INPUT DA
  path2099, // INPUT DB
  g1522, // INPUT DC
  g2488, // INPUT DD
  path1771, // OUTPUT NA
  unconnected_J112_PA, // OUTPUT PA
  path2504, // OUTPUT NB
  unconnected_J112_PB, // OUTPUT PB
  path2505, // OUTPUT NC
  unconnected_J112_PC, // OUTPUT PC
  path2489, // OUTPUT ND
  unconnected_J112_PD // OUTPUT PD
);

cell_LT4 J127 ( // 4-bit Data Latch
  g1750, // INPUT G
  g1757, // INPUT DA
  path2099, // INPUT DB
  g1522, // INPUT DC
  g2488, // INPUT DD
  path2192, // OUTPUT NA
  unconnected_J127_PA, // OUTPUT PA
  path1965, // OUTPUT NB
  unconnected_J127_PB, // OUTPUT PB
  path2762, // OUTPUT NC
  unconnected_J127_PC, // OUTPUT PC
  path2097, // OUTPUT ND
  unconnected_J127_PD // OUTPUT PD
);

cell_LT4 J140 ( // 4-bit Data Latch
  path1607, // INPUT G
  g1757, // INPUT DA
  path2099, // INPUT DB
  g1522, // INPUT DC
  g2488, // INPUT DD
  path1768, // OUTPUT NA
  unconnected_J140_PA, // OUTPUT PA
  path1964, // OUTPUT NB
  unconnected_J140_PB, // OUTPUT PB
  path1769, // OUTPUT NC
  unconnected_J140_PC, // OUTPUT PC
  path1770, // OUTPUT ND
  unconnected_J140_PD // OUTPUT PD
);

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
  path2438, // OUTPUT X6
  path2439 // OUTPUT X7
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

cell_A2N L2 ( // 2-bit Full Adder
  path2421, // INPUT B2
  path2246, // INPUT A2
  path2423, // INPUT B1
  path2692, // INPUT A1
  path2252, // INPUT CI
  path2422, // OUTPUT CO
  path2693, // OUTPUT S2
  path2253 // OUTPUT S1
);

cell_A2N Q61 ( // 2-bit Full Adder
  path2408, // INPUT B2
  path2592, // INPUT A2
  path2408, // INPUT B1
  path2407, // INPUT A1
  path2202, // INPUT CI
  unconnected_Q61_CO, // OUTPUT CO
  path2767, // OUTPUT S2
  path2525 // OUTPUT S1
);

cell_FDQ K50 ( // 4-bit DFF
  g1590, // INPUT CK
  GND, // INPUT DA
  path2420, // INPUT DB
  g2784, // INPUT DC
  path2131, // INPUT DD
  unconnected_K50_QA, // OUTPUT QA
  path2421, // OUTPUT QB
  path2423, // OUTPUT QC
  path2411 // OUTPUT QD
);

cell_FDQ M44 ( // 4-bit DFF
  g44, // INPUT CK
  path1844, // INPUT DA
  path1845, // INPUT DB
  path2744, // INPUT DC
  GND, // INPUT DD
  path2406, // OUTPUT QA
  path2763, // OUTPUT QB
  unconnected_M44_QC, // OUTPUT QC
  unconnected_M44_QD // OUTPUT QD
);

cell_FDQ M77 ( // 4-bit DFF
  g2564, // INPUT CK
  path2455, // INPUT DA
  path2675, // INPUT DB
  g2446, // INPUT DC
  GND, // INPUT DD
  unk_dec_ic, // OUTPUT QA
  unk_dec_ib, // OUTPUT QB
  unk_dec_ia, // OUTPUT QC
  unconnected_M77_QD // OUTPUT QD
);

cell_FDQ N56 ( // 4-bit DFF
  g44, // INPUT CK
  GND, // INPUT DA
  path1440, // INPUT DB
  path1846, // INPUT DC
  path2254, // INPUT DD
  unconnected_N56_QA, // OUTPUT QA
  path2403, // OUTPUT QB
  g2256, // OUTPUT QC
  path2180 // OUTPUT QD
);

cell_FDQ O117 ( // 4-bit DFF
  g44, // INPUT CK
  path1848, // INPUT DA
  path2737, // INPUT DB
  path1894, // INPUT DC
  path1893, // INPUT DD
  path1982, // OUTPUT QA
  path2738, // OUTPUT QB
  path1895, // OUTPUT QC
  path1896 // OUTPUT QD
);

cell_FDQ O16 ( // 4-bit DFF
  g1590, // INPUT CK
  AG2_IN, // INPUT DA
  AG1_IN, // INPUT DB
  AG3_IN, // INPUT DC
  ag2_latched, // INPUT DD
  path2776, // OUTPUT QA
  g37, // OUTPUT QB
  g2034, // OUTPUT QC
  path2602 // OUTPUT QD
);

cell_FDQ O56 ( // 4-bit DFF
  g1590, // INPUT CK
  path38, // INPUT DA
  path1374, // INPUT DB
  path2320, // INPUT DC
  R6_D1_IN, // INPUT DD
  path2766, // OUTPUT QA
  path1373, // OUTPUT QB
  path2524, // OUTPUT QC
  path2258 // OUTPUT QD
);

cell_FDQ S56 ( // 4-bit DFF
  g44, // INPUT CK
  path2729, // INPUT DA
  path2686, // INPUT DB
  path2664, // INPUT DC
  path2204, // INPUT DD
  path1890, // OUTPUT QA
  path2629, // OUTPUT QB
  path2663, // OUTPUT QC
  path2662 // OUTPUT QD
);

cell_FDQ T2 ( // 4-bit DFF
  g44, // INPUT CK
  path2681, // INPUT DA
  path2683, // INPUT DB
  path1887, // INPUT DC
  path1884, // INPUT DD
  path2682, // OUTPUT QA
  path2684, // OUTPUT QB
  path1886, // OUTPUT QC
  path1885 // OUTPUT QD
);

cell_FDQ B16 ( // 4-bit DFF
  g1590, // INPUT CK
  path2321, // INPUT DA
  IC19_4_IN, // INPUT DB
  g2417, // INPUT DC
  IC19_2_IN, // INPUT DD
  path2322, // OUTPUT QA
  path2424, // OUTPUT QB
  path2416, // OUTPUT QC
  path1601 // OUTPUT QD
);

cell_FDQ U56 ( // 4-bit DFF
  g1590, // INPUT CK
  r6_d0_and, // INPUT DA
  R7_D7_IN, // INPUT DB
  R5_D7_IN, // INPUT DC
  r5_d5_and, // INPUT DD
  path2717, // OUTPUT QA
  path2716, // OUTPUT QB
  path2715, // OUTPUT QC
  path2714 // OUTPUT QD
);

cell_FDQ V136 ( // 4-bit DFF
  g44, // INPUT CK
  path2634, // INPUT DA
  path2633, // INPUT DB
  path1676, // INPUT DC
  path1677, // INPUT DD
  path2479, // OUTPUT QA
  path2636, // OUTPUT QB
  path1675, // OUTPUT QC
  path2637 // OUTPUT QD
);

cell_FDQ X17 ( // 4-bit DFF
  g1590, // INPUT CK
  R6_D2_IN, // INPUT DA
  R7_D2_IN, // INPUT DB
  R7_D1_IN, // INPUT DC
  r5_d1_and, // INPUT DD
  path2018, // OUTPUT QA
  path2572, // OUTPUT QB
  path2711, // OUTPUT QC
  path2521 // OUTPUT QD
);

cell_FDQ X56 ( // 4-bit DFF
  g1590, // INPUT CK
  R5_D2_IN, // INPUT DA
  r5_d6_and, // INPUT DB
  R6_D6_IN, // INPUT DC
  R7_D5_IN, // INPUT DD
  path1421, // OUTPUT QA
  path2616, // OUTPUT QB
  path2712, // OUTPUT QC
  path2624 // OUTPUT QD
);

cell_FDQ Y2 ( // 4-bit DFF
  g1590, // INPUT CK
  r7_d3_and, // INPUT DA
  R5_D0_IN, // INPUT DB
  R6_D4_IN, // INPUT DC
  R7_D4_IN, // INPUT DD
  g2621, // OUTPUT QA
  path1591, // OUTPUT QB
  path2726, // OUTPUT QC
  path2720 // OUTPUT QD
);

cell_FDQ Y35 ( // 4-bit DFF
  g1590, // INPUT CK
  r7_d6_and, // INPUT DA
  R5_D4_IN, // INPUT DB
  R7_D0_IN, // INPUT DC
  r6_d3_and, // INPUT DD
  path2568, // OUTPUT QA
  path1504, // OUTPUT QB
  path2015, // OUTPUT QC
  path2014 // OUTPUT QD
);

cell_FDQ Y56 ( // 4-bit DFF
  g1590, // INPUT CK
  R5_D3_IN, // INPUT DA
  R6_D5_IN, // INPUT DB
  r6_d7_and, // INPUT DC
  r6_d7_and_2, // INPUT DD
  path2727, // OUTPUT QA
  path2713, // OUTPUT QB
  path1450, // OUTPUT QC
  path2625 // OUTPUT QD
);

cell_FDQ E37 ( // 4-bit DFF
  path2702, // INPUT CK
  g25, // INPUT DA
  path2780, // INPUT DB
  path2781, // INPUT DC
  VCC, // INPUT DD
  path2703, // OUTPUT QA
  path2704, // OUTPUT QB
  path2705, // OUTPUT QC
  unconnected_E37_QD // OUTPUT QD
);

cell_FDQ J1 ( // 4-bit DFF
  g1590, // INPUT CK
  path2112, // INPUT DA
  path1841, // INPUT DB
  path1840, // INPUT DC
  path2575, // INPUT DD
  path2113, // OUTPUT QA
  path1839, // OUTPUT QB
  path2574, // OUTPUT QC
  path1842 // OUTPUT QD
);

cell_FDR A117 ( // 4-bit DFF with CLEAR
  MPX1_IOM, // INPUT CL
  MPX1_IN, // INPUT CK
  R10_D7_IN, // INPUT DA
  R10_D6_IN, // INPUT DB
  R10_D5_IN, // INPUT DC
  R10_D4_IN, // INPUT DD
  r10_ff_a117_d7, // OUTPUT QA
  r10_ff_a117_d6, // OUTPUT QB
  r10_ff_a117_d5, // OUTPUT QC
  r10_ff_a117_d4 // OUTPUT QD
);

cell_FDR A77 ( // 4-bit DFF with CLEAR
  MPX1_IOM, // INPUT CL
  MPX1_IN, // INPUT CK
  R10_D3_IN, // INPUT DA
  R10_D2_IN, // INPUT DB
  R10_D1_IN, // INPUT DC
  R10_D0_IN, // INPUT DD
  r10_ff_a77_d3, // OUTPUT QA
  r10_ff_a77_d2, // OUTPUT QB
  r10_ff_a77_d1, // OUTPUT QC
  r10_ff_a77_d0 // OUTPUT QD
);

cell_C45 D1 ( // 4-bit Binary Synchronous Up Counter
  GND, // INPUT DA
  path2108, // INPUT EN
  VCC, // INPUT CI
  path2323, // INPUT CL
  GND, // INPUT DB
  VCC, // INPUT L
  r10_ff_clock, // INPUT CK
  g2136, // INPUT DC
  GND, // INPUT DD
  g107, // OUTPUT QA
  path1987, // OUTPUT QB
  unconnected_D1_CO, // OUTPUT CO
  path2362, // OUTPUT QC
  g2361 // OUTPUT QD
);

assign path1986 = FSYNC_IN && ~(path1984 && path2696);
cell_C45 C1 ( // 4-bit Binary Synchronous Up Counter
  GND, // INPUT DA
  VCC, // INPUT EN
  VCC, // INPUT CI
  path1986, // INPUT CL
  GND, // INPUT DB
  VCC, // INPUT L
  r10_ff_clock, // INPUT CK
  GND, // INPUT DC
  GND, // INPUT DD
  path2696, // OUTPUT QA
  unconnected_C1_QB, // OUTPUT QB
  unconnected_C1_CO, // OUTPUT CO
  unconnected_C1_QC, // OUTPUT QC
  path1984 // OUTPUT QD
);
cell_C45 G29 ( // 4-bit Binary Synchronous Up Counter
  path1715, // INPUT DA
  VCC, // INPUT EN
  VCC, // INPUT CI
  FSYNC_IN, // INPUT CL
  GND, // INPUT DB
  path1791, // INPUT L
  r10_ff_clock, // INPUT CK
  GND, // INPUT DC
  GND, // INPUT DD
  g1720, // OUTPUT QA
  g2446, // OUTPUT QB
  clock_low_sr, // OUTPUT CO
  path2675, // OUTPUT QC
  path2455 // OUTPUT QD
);

assign path1988 = g2361 && g107 && ~(~((path1984 && path2696 && SR_SEL_IN) || (clock_low_sr && ~SR_SEL_IN)) && ~r10_ff_a117_d4);
cell_C45 H1 ( // 4-bit Binary Synchronous Up Counter
  GND, // INPUT DA
  path1988, // INPUT EN
  VCC, // INPUT CI
  FSYNC_IN, // INPUT CL
  GND, // INPUT DB
  VCC, // INPUT L
  r10_ff_clock, // INPUT CK
  GND, // INPUT DC
  GND, // INPUT DD
  MPX1_OUT, // OUTPUT QA
  g25, // OUTPUT QB
  path2109, // OUTPUT CO
  path2780, // OUTPUT QC
  path2781 // OUTPUT QD
);

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

cell_LT2 N109 ( // 1-bit Data Latch
  g2043, // INPUT G
  path2035, // INPUT D
  path2233, // OUTPUT Q
  unconnected_N109_XQ // OUTPUT XQ
);

cell_LT2 N113 ( // 1-bit Data Latch
  path2231, // INPUT G
  path2035, // INPUT D
  path2232, // OUTPUT Q
  unconnected_N113_XQ // OUTPUT XQ
);

cell_LT2 N122 ( // 1-bit Data Latch
  g1643, // INPUT G
  path2035, // INPUT D
  path2764, // OUTPUT Q
  unconnected_N122_XQ // OUTPUT XQ
);

cell_LT2 N126 ( // 1-bit Data Latch
  g1976, // INPUT G
  path2035, // INPUT D
  path2223, // OUTPUT Q
  unconnected_N126_XQ // OUTPUT XQ
);

cell_LT2 N77 ( // 1-bit Data Latch
  g2436, // INPUT G
  path2035, // INPUT D
  path2222, // OUTPUT Q
  unconnected_N77_XQ // OUTPUT XQ
);

cell_LT2 N81 ( // 1-bit Data Latch
  g1865, // INPUT G
  path2035, // INPUT D
  path1866, // OUTPUT Q
  unconnected_N81_XQ // OUTPUT XQ
);

cell_LT2 N85 ( // 1-bit Data Latch
  g1731, // INPUT G
  path2035, // INPUT D
  path1867, // OUTPUT Q
  unconnected_N85_XQ // OUTPUT XQ
);

cell_LT2 N89 ( // 1-bit Data Latch
  g2048, // INPUT G
  path2035, // INPUT D
  path2765, // OUTPUT Q
  unconnected_N89_XQ // OUTPUT XQ
);

cell_LT2 O5 ( // 1-bit Data Latch
  g2564, // INPUT G
  AG2_IN, // INPUT D
  ag2_latched, // OUTPUT Q
  unconnected_O5_XQ // OUTPUT XQ
);

cell_LT2 O9 ( // 1-bit Data Latch
  g2564, // INPUT G
  AG1_IN, // INPUT D
  ag1_latched, // OUTPUT Q
  unconnected_O9_XQ // OUTPUT XQ
);

cell_LT2 R117 ( // 1-bit Data Latch
  g2048, // INPUT G
  path2055, // INPUT D
  path2049, // OUTPUT Q
  unconnected_R117_XQ // OUTPUT XQ
);

cell_LT2 R121 ( // 1-bit Data Latch
  g1731, // INPUT G
  path2055, // INPUT D
  path2050, // OUTPUT Q
  unconnected_R121_XQ // OUTPUT XQ
);

cell_LT2 R137 ( // 1-bit Data Latch
  g1865, // INPUT G
  path2055, // INPUT D
  path1528, // OUTPUT Q
  unconnected_R137_XQ // OUTPUT XQ
);

cell_LT2 R141 ( // 1-bit Data Latch
  g2043, // INPUT G
  path2055, // INPUT D
  path2052, // OUTPUT Q
  unconnected_R141_XQ // OUTPUT XQ
);

cell_LT2 R145 ( // 1-bit Data Latch
  g1643, // INPUT G
  path2055, // INPUT D
  path2051, // OUTPUT Q
  unconnected_R145_XQ // OUTPUT XQ
);

cell_LT2 R149 ( // 1-bit Data Latch
  g1976, // INPUT G
  path2055, // INPUT D
  path2054, // OUTPUT Q
  unconnected_R149_XQ // OUTPUT XQ
);

cell_LT2 R153 ( // 1-bit Data Latch
  path2231, // INPUT G
  path2055, // INPUT D
  path2053, // OUTPUT Q
  unconnected_R153_XQ // OUTPUT XQ
);

cell_LT2 S102 ( // 1-bit Data Latch
  g2436, // INPUT G
  path2055, // INPUT D
  path1529, // OUTPUT Q
  unconnected_S102_XQ // OUTPUT XQ
);

cell_A4H L27 ( // 4-bit Full Adder
  path2411, // INPUT A4
  path2410, // INPUT B4
  path2322, // INPUT A3
  path2249, // INPUT B3
  path2424, // INPUT A2
  path2412, // INPUT B2
  path2416, // INPUT A1
  path2415, // INPUT B1
  path2137, // INPUT CI
  path2252, // OUTPUT CO
  path2251, // OUTPUT S4
  path2250, // OUTPUT S3
  r10_ff_a10, // OUTPUT S2
  r10_ff_a9 // OUTPUT S1
);

cell_A4H N5 ( // 4-bit Full Adder
  path1842, // INPUT A4
  path1843, // INPUT B4
  path2766, // INPUT A3
  path2566, // INPUT B3
  path1373, // INPUT A2
  path1372, // INPUT B2
  path2524, // INPUT A1
  path1414, // INPUT B1
  GND, // INPUT CI
  path2590, // OUTPUT CO
  r10_ff_a4, // OUTPUT S4
  r10_ff_a3, // OUTPUT S3
  r10_ff_a2, // OUTPUT S2
  path1 // OUTPUT S1
);

cell_A4H P98 ( // 4-bit Full Adder
  path1891, // INPUT A4
  path1892, // INPUT B4
  path1782, // INPUT A3
  path1783, // INPUT B3
  path1741, // INPUT A2
  path1740, // INPUT B2
  path2319, // INPUT A1
  path2318, // INPUT B1
  path1509, // INPUT CI
  path1883, // OUTPUT CO
  path1848, // OUTPUT S4
  path2737, // OUTPUT S3
  path1894, // OUTPUT S2
  path1893 // OUTPUT S1
);

cell_A4H R4 ( // 4-bit Full Adder
  path2408, // INPUT A4
  path2409, // INPUT B4
  path2408, // INPUT A3
  path2730, // INPUT B3
  path1365, // INPUT A2
  path1364, // INPUT B2
  path1362, // INPUT A1
  path1363, // INPUT B1
  path2203, // INPUT CI
  path2202, // OUTPUT CO
  path2729, // OUTPUT S4
  path2686, // OUTPUT S3
  path2664, // OUTPUT S2
  path2204 // OUTPUT S1
);

cell_A4H S3 ( // 4-bit Full Adder
  path1729, // INPUT A4
  path1728, // INPUT B4
  path1699, // INPUT A3
  path2243, // INPUT B3
  path2666, // INPUT A2
  path2728, // INPUT B2
  path2242, // INPUT A1
  path2241, // INPUT B1
  path1883, // INPUT CI
  path2203, // OUTPUT CO
  path2681, // OUTPUT S4
  path2683, // OUTPUT S3
  path1887, // OUTPUT S2
  path1884 // OUTPUT S1
);

cell_A4H U107 ( // 4-bit Full Adder
  path1394, // INPUT A4
  path2307, // INPUT B4
  path1410, // INPUT A3
  path1409, // INPUT B3
  path1465, // INPUT A2
  path1466, // INPUT B2
  path1785, // INPUT A1
  path1784, // INPUT B1
  path1678, // INPUT CI
  path1509, // OUTPUT CO
  path2634, // OUTPUT S4
  path2633, // OUTPUT S3
  path1676, // OUTPUT S2
  path1677 // OUTPUT S1
);

cell_A4H V4 ( // 4-bit Full Adder
  path2603, // INPUT A4
  path1504, // INPUT B4
  path2614, // INPUT A3
  path2015, // INPUT B3
  path2013, // INPUT A2
  path2014, // INPUT B2
  path1420, // INPUT A1
  path1421, // INPUT B1
  path1997, // INPUT CI
  path1597, // OUTPUT CO
  path2604, // OUTPUT S4
  path2749, // OUTPUT S3
  path1598, // OUTPUT S2
  path2017 // OUTPUT S1
);

cell_A4H W1 ( // 4-bit Full Adder
  path2009, // INPUT A4
  path2616, // INPUT B4
  path2571, // INPUT A3
  path2712, // INPUT B3
  path2786, // INPUT A2
  path2624, // INPUT B2
  path2622, // INPUT A1
  path2625, // INPUT B1
  GND, // INPUT CI
  path1997, // OUTPUT CO
  path2615, // OUTPUT S4
  path2016, // OUTPUT S3
  path2520, // OUTPUT S2
  path2626 // OUTPUT S1
);

cell_A4H J27 ( // 4-bit Full Adder
  path1601, // INPUT A4
  path1600, // INPUT B4
  path2113, // INPUT A3
  path2523, // INPUT B3
  path1839, // INPUT A2
  path2573, // INPUT B2
  path2574, // INPUT A1
  path2709, // INPUT B1
  path2590, // INPUT CI
  path2137, // OUTPUT CO
  r10_ff_a8, // OUTPUT S4
  r10_ff_a7, // OUTPUT S3
  r10_ff_a6, // OUTPUT S2
  r10_ff_a5 // OUTPUT S1
);

cell_FDM A2 ( // DFF
  r10_ff_clock, // INPUT CK
  r10_ff_a10, // INPUT D
  unconnected_A2_XQ, // OUTPUT XQ
  R10_A10_OUT // OUTPUT Q
);

cell_FDM A17 ( // DFF
  path1330, // INPUT CK
  path1328, // INPUT D
  unconnected_A17_XQ, // OUTPUT XQ
  path1329 // OUTPUT Q
);

cell_FDM A23 ( // DFF
  r10_ff_clock, // INPUT CK
  r10_ff_a8, // INPUT D
  unconnected_A23_XQ, // OUTPUT XQ
  R10_A8_OUT // OUTPUT Q
);

cell_FDM A29 ( // DFF
  r10_ff_clock, // INPUT CK
  r10_ff_a5, // INPUT D
  unconnected_A29_XQ, // OUTPUT XQ
  R10_A5_OUT // OUTPUT Q
);

cell_FDM A45 ( // DFF
  r10_ff_clock, // INPUT CK
  r10_ff_a4, // INPUT D
  unconnected_A45_XQ, // OUTPUT XQ
  R10_A4_OUT // OUTPUT Q
);

cell_FDM A51 ( // DFF
  r10_ff_clock, // INPUT CK
  path1, // INPUT D
  unconnected_A51_XQ, // OUTPUT XQ
  R10_A1_OUT // OUTPUT Q
);

cell_FDM A71 ( // DFF
  r10_ff_clock, // INPUT CK
  r10_ff_a7, // INPUT D
  unconnected_A71_XQ, // OUTPUT XQ
  R10_A7_OUT // OUTPUT Q
);

cell_FDM P51 ( // DFF
  path2184, // INPUT CK
  path2767, // INPUT D
  path2591, // OUTPUT XQ
  unconnected_P51_Q // OUTPUT Q
);

cell_FDM Q42 ( // DFF
  path2184, // INPUT CK
  path2525, // INPUT D
  path2056, // OUTPUT XQ
  unconnected_Q42_Q // OUTPUT Q
);

cell_FDM B77 ( // DFF
  r10_ff_clock, // INPUT CK
  r10_ff_a3, // INPUT D
  unconnected_B77_XQ, // OUTPUT XQ
  R10_A3_OUT // OUTPUT Q
);

cell_FDM B98 ( // DFF
  r10_ff_clock, // INPUT CK
  r10_ff_a6, // INPUT D
  unconnected_B98_XQ, // OUTPUT XQ
  R10_A6_OUT // OUTPUT Q
);

cell_FDM C77 ( // DFF
  r10_ff_clock, // INPUT CK
  r10_ff_a2, // INPUT D
  unconnected_C77_XQ, // OUTPUT XQ
  R10_A2_OUT // OUTPUT Q
);

cell_FDM E116 ( // DFF
  r10_ff_clock, // INPUT CK
  r10_ff_a9, // INPUT D
  unconnected_E116_XQ, // OUTPUT XQ
  R10_A9_OUT // OUTPUT Q
);

cell_A1N V69 ( // 1-bit Full Adder
  path2002, // INPUT A
  path2568, // INPUT B
  path1597, // INPUT CI
  path2605, // OUTPUT CO
  path1596 // OUTPUT S
);


assign DAC1_OUT = ~(~(~(((~SR_SEL_IN && g107) || path1987 || path2362 || g2361) && (MPX1_OUT || g25 || path2780 || path2781)) && r10_ff_a77_d2) && ~(~((path2375 && ~dac_dec_o0) || (path2391 && ~dac_dec_o1) || (path2758 && ~dac_dec_o2) || (path2390 && ~dac_dec_o3) || (path2066 && ~dac_dec_o4) || (path2759 && ~dac_dec_o5) || (path2065 && ~dac_dec_o6) || (path2069 && ~dac_dec_o7)) && ~r10_ff_a77_d2));
assign DAC2_OUT = ~(~((~(~(r10_ff_a77_d3 || path1329) || g1720) || r10_ff_a77_d0) && r10_ff_a77_d2) && ~(~((path2374 && ~dac_dec_o0) || (path2373 && ~dac_dec_o1) || (path2173 && ~dac_dec_o2) || (path2389 && ~dac_dec_o3) || (path2067 && ~dac_dec_o4) || (path2532 && ~dac_dec_o5) || (path1617 && ~dac_dec_o6) || (path2068 && ~dac_dec_o7)) && ~r10_ff_a77_d2));
assign DAC3_OUT = ~(~(~((path2645 && path2455 && ~path2675 && g2446) || (path2225 && path2455 && ~path2675 && ~g2446) || (path2228 && ~path2455 && path2675 && g2446) || (path2227 && ~path2455 && path2675 && ~g2446) || (path2724 && ~path2455 && ~path2675 && g2446) || (path2476 && ~path2455 && ~path2675 && ~g2446) || (path2472 && path2455 && path2675 && g2446) || (path1738 && path2455 && path2675 && ~g2446)) && r10_ff_a77_d2) && ~(~((path2371 && ~dac_dec_o0) || (path2372 && ~dac_dec_o1) || (path2063 && ~dac_dec_o2) || (path2752 && ~dac_dec_o3) || (path1616 && ~dac_dec_o4) || (path2531 && ~dac_dec_o5) || (path2064 && ~dac_dec_o6) || (path2530 && ~dac_dec_o7)) && ~r10_ff_a77_d2));
assign DAC4_OUT = ~(~(~((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && r10_ff_a77_d2) && ~(~((path2757 && ~dac_dec_o0) || (path2581 && ~dac_dec_o1) || (path2376 && ~dac_dec_o2) || (path2580 && ~dac_dec_o3) || (path1615 && ~dac_dec_o4) || (path2760 && ~dac_dec_o5) || (path1919 && ~dac_dec_o6) || (path1918 && ~dac_dec_o7)) && ~r10_ff_a77_d2));
assign DAC5_OUT = ~(~(path2763 && r10_ff_a77_d2) && ~(~((path2497 && ~dac_dec_o0) || (path2785 && ~dac_dec_o1) || (path2097 && ~dac_dec_o2) || (path2096 && ~dac_dec_o3) || (path2489 && ~dac_dec_o4) || (path2493 && ~dac_dec_o5) || (path1770 && ~dac_dec_o6) || (path2494 && ~dac_dec_o7)) && ~r10_ff_a77_d2));
assign DAC6_OUT = ~(~(path2406 && r10_ff_a77_d2) && ~(~((path1523 && ~dac_dec_o0) || (path2500 && ~dac_dec_o1) || (path2762 && ~dac_dec_o2) || (path2501 && ~dac_dec_o3) || (path2505 && ~dac_dec_o4) || (path2492 && ~dac_dec_o5) || (path1769 && ~dac_dec_o6) || (path2491 && ~dac_dec_o7)) && ~r10_ff_a77_d2));
assign DAC7_OUT = ~(~(path2180 && r10_ff_a77_d2) && ~(~((path2498 && ~dac_dec_o0) || (path2499 && ~dac_dec_o1) || (path1965 && ~dac_dec_o2) || (path2495 && ~dac_dec_o3) || (path2504 && ~dac_dec_o4) || (path2496 && ~dac_dec_o5) || (path1964 && ~dac_dec_o6) || (path1758 && ~dac_dec_o7)) && ~r10_ff_a77_d2));
assign DAC8_OUT = ~(~(g2256 && r10_ff_a77_d2) && ~(~((path2193 && ~dac_dec_o0) || (path2502 && ~dac_dec_o1) || (path2192 && ~dac_dec_o2) || (path2490 && ~dac_dec_o3) || (path1771 && ~dac_dec_o4) || (path1772 && ~dac_dec_o5) || (path1768 && ~dac_dec_o6) || (path2100 && ~dac_dec_o7)) && ~r10_ff_a77_d2));
assign DAC9_OUT = ~(~(path2403 && r10_ff_a77_d2) && ~(~((path1609 && ~dac_dec_o0) || (path1608 && ~dac_dec_o1) || (path2399 && ~dac_dec_o2) || (path2400 && ~dac_dec_o3) || (path2104 && ~dac_dec_o4) || (path2105 && ~dac_dec_o5) || (path2397 && ~dac_dec_o6) || (path2398 && ~dac_dec_o7)) && ~r10_ff_a77_d2));
assign DAC10_OUT = ~((path2101 && ~dac_dec_o0) || (path2538 && ~dac_dec_o1) || (path1524 && ~dac_dec_o2) || (path2783 && ~dac_dec_o3) || (path2103 && ~dac_dec_o4) || (path2539 && ~dac_dec_o5) || (path2093 && ~dac_dec_o6) || (path2092 && ~dac_dec_o7));
assign DAC11_OUT = ~((path2102 && ~dac_dec_o0) || (path2158 && ~dac_dec_o1) || (path1525 && ~dac_dec_o2) || (path2159 && ~dac_dec_o3) || (path2536 && ~dac_dec_o4) || (path2095 && ~dac_dec_o5) || (path2094 && ~dac_dec_o6) || (path2537 && ~dac_dec_o7));
assign DAC12_OUT = ~((path2742 && ~dac_dec_o0) || (path2157 && ~dac_dec_o1) || (path2741 && ~dac_dec_o2) || (path2743 && ~dac_dec_o3) || (path2535 && ~dac_dec_o4) || (path2534 && ~dac_dec_o5) || (path1610 && ~dac_dec_o6) || (path1611 && ~dac_dec_o7));
assign DAC13_OUT = ~((path2396 && ~dac_dec_o0) || (path2533 && ~dac_dec_o1) || (path2165 && ~dac_dec_o2) || (path2755 && ~dac_dec_o3) || (path2166 && ~dac_dec_o4) || (path2761 && ~dac_dec_o5) || (path2153 && ~dac_dec_o6) || (path2152 && ~dac_dec_o7));
assign DAC14_OUT = ~((path2395 && ~dac_dec_o0) || (path2394 && ~dac_dec_o1) || (path2148 && ~dac_dec_o2) || (path2147 && ~dac_dec_o3) || (path2753 && ~dac_dec_o4) || (path2756 && ~dac_dec_o5) || (path2089 && ~dac_dec_o6) || (path2088 && ~dac_dec_o7));
assign DAC15_OUT = ~((path2151 && ~dac_dec_o0) || (path2150 && ~dac_dec_o1) || (path2149 && ~dac_dec_o2) || (path2146 && ~dac_dec_o3) || (path2754 && ~dac_dec_o4) || (path2075 && ~dac_dec_o5) || (path2076 && ~dac_dec_o6) || (path2087 && ~dac_dec_o7));
assign DAC16_OUT = (path2078 && ~dac_dec_o0) || (path2077 && ~dac_dec_o1) || (path2164 && ~dac_dec_o2) || (path2163 && ~dac_dec_o3) || (path13 && ~dac_dec_o4) || (path2074 && ~dac_dec_o5) || (path2079 && ~dac_dec_o6) || (path2086 && ~dac_dec_o7);

assign R10_A0_OUT = (~((cycle_cnt_7 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_7 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || cnt_i16_qd)) || ~((cycle_cnt_6 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_6 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || cnt_i16_qd))) && VCC;

assign FSYNC_OUT = ~(path2109 && g2361 && g107 && ~(~((path1984 && path2696 && SR_SEL_IN) || (clock_low_sr && ~SR_SEL_IN)) && ~r10_ff_a117_d4));
assign MPX2_OUT = ~((((~((path2645 && path2455 && ~path2675 && g2446) || (path2225 && path2455 && ~path2675 && ~g2446) || (path2228 && ~path2455 && path2675 && g2446) || (path2227 && ~path2455 && path2675 && ~g2446) || (path2724 && ~path2455 && ~path2675 && g2446) || (path2476 && ~path2455 && ~path2675 && ~g2446) || (path2472 && path2455 && path2675 && g2446) || (path1738 && path2455 && path2675 && ~g2446)) && ~(~((cycle_cnt_7 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_7 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || cnt_i16_qd)) || ~((cycle_cnt_6 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_6 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || cnt_i16_qd)))) || ((~((cycle_cnt_7 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_7 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || cnt_i16_qd)) || ~((cycle_cnt_6 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_6 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || cnt_i16_qd))) && ~((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)))) && r10_ff_a117_d7) || (MPX1_OUT && ~r10_ff_a117_d7));


assign g1590 = ~((cycle_cnt_7 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_7 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || cnt_i16_qd));
assign g1614 = ~(~(cycle_cnt_3 || SYNC_IN || ~cnt_i16_qd || ~r10_ff_a77_d3) || ~(cycle_cnt_2 || SYNC_IN || ~cnt_i16_qd || ~(r10_ff_a77_d3 || path1329)));
assign g1643 = unk_dec_o4 || ~((cycle_cnt_7 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_7 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || cnt_i16_qd)) || ~((cycle_cnt_6 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_6 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || cnt_i16_qd));
assign g1691 = ~(~(cycle_cnt_5 || SYNC_IN || ~cnt_i16_qd || ~r10_ff_a77_d3) || ~(cycle_cnt_4 || SYNC_IN || ~cnt_i16_qd || ~(r10_ff_a77_d3 || path1329)) || r10_ff_a117_d6);
assign g1731 = unk_dec_o1 || ~((cycle_cnt_7 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_7 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || cnt_i16_qd)) || ~((cycle_cnt_6 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_6 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || cnt_i16_qd));
assign g1750 = ~(~(cycle_cnt_1 || SYNC_IN || cnt_i16_qd || ~r10_ff_a77_d3) || ~(cycle_cnt_0 || SYNC_IN || cnt_i16_qd || ~(r10_ff_a77_d3 || path1329)));
assign g1865 = unk_dec_o0 || ~((cycle_cnt_7 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_7 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || cnt_i16_qd)) || ~((cycle_cnt_6 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_6 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || cnt_i16_qd));
assign g1976 = path2439 || ~((cycle_cnt_7 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_7 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || cnt_i16_qd)) || ~((cycle_cnt_6 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_6 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || cnt_i16_qd));
assign g2043 = unk_dec_o2 || ~((cycle_cnt_7 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_7 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || cnt_i16_qd)) || ~((cycle_cnt_6 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_6 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || cnt_i16_qd));
assign g2048 = unk_dec_o5 || ~((cycle_cnt_7 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_7 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || cnt_i16_qd)) || ~((cycle_cnt_6 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_6 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || cnt_i16_qd));
assign g2136 = SYNC_IN || cnt_i16_qd;
assign g2156 = ~(~(cycle_cnt_7 || SYNC_IN || ~cnt_i16_qd || ~r10_ff_a77_d3) || ~(cycle_cnt_6 || SYNC_IN || ~cnt_i16_qd || ~(r10_ff_a77_d3 || path1329)));
assign g2436 = path2438 || ~((cycle_cnt_7 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_7 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || cnt_i16_qd)) || ~((cycle_cnt_6 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_6 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || cnt_i16_qd));
assign g2564 = (cycle_cnt_6 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_6 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || cnt_i16_qd);
assign g44 = ~((cycle_cnt_7 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_7 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || cnt_i16_qd)) || ~((cycle_cnt_6 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_6 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || cnt_i16_qd));
assign path1330 = ~(cycle_cnt_3 || SYNC_IN || ~cnt_i16_qd);
assign path1607 = ~(~(cycle_cnt_1 || SYNC_IN || ~cnt_i16_qd || ~r10_ff_a77_d3) || ~(cycle_cnt_0 || SYNC_IN || ~cnt_i16_qd || ~(r10_ff_a77_d3 || path1329)));
assign path1752 = ~(~(cycle_cnt_5 || SYNC_IN || cnt_i16_qd || ~r10_ff_a77_d3) || ~(cycle_cnt_4 || SYNC_IN || cnt_i16_qd || ~(r10_ff_a77_d3 || path1329)));
assign path1773 = ~(~(cycle_cnt_7 || SYNC_IN || cnt_i16_qd || ~r10_ff_a77_d3) || ~(cycle_cnt_6 || SYNC_IN || cnt_i16_qd || ~(r10_ff_a77_d3 || path1329)));
assign path1781 = ~((((~(~((cycle_cnt_7 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_7 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || cnt_i16_qd)) || ~((cycle_cnt_6 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_6 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || cnt_i16_qd))) && ~path2181 && ~path2733 && ~path2732 && ~path2708) || (~path2508 && ~path2181 && ~path2733 && ~path2732 && ~path2707) || (~path2507 && ~path2181 && ~path2733 && ~path2405 && ~path2708) || (~path1300 && ~path2181 && ~path2733 && ~path2405 && ~path2707) || (~path2335 && ~path2181 && ~path2735 && ~path2732 && ~path2708) || (~path2336 && ~path2181 && ~path2735 && ~path2732 && ~path2707) || (g1341 && ~path2181 && ~path2735 && ~path2405 && ~path2708) || (g2511 && ~path2181 && ~path2735 && ~path2405 && ~path2707)) && path2404) || (~((~(~((cycle_cnt_7 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_7 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || cnt_i16_qd)) || ~((cycle_cnt_6 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_6 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || cnt_i16_qd))) && ~path2181 && ~path2733 && ~path2732 && ~path2708) || (~path2508 && ~path2181 && ~path2733 && ~path2732 && ~path2707) || (~path2507 && ~path2181 && ~path2733 && ~path2405 && ~path2708) || (~path1300 && ~path2181 && ~path2733 && ~path2405 && ~path2707) || (~path2335 && ~path2181 && ~path2735 && ~path2732 && ~path2708) || (~path2336 && ~path2181 && ~path2735 && ~path2732 && ~path2707) || (g1341 && ~path2181 && ~path2735 && ~path2405 && ~path2708) || (g2511 && ~path2181 && ~path2735 && ~path2405 && ~path2707)) && ~path2404));
assign path2106 = ~(~(~((cycle_cnt_7 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_7 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || cnt_i16_qd)) || ~((cycle_cnt_6 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_6 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || cnt_i16_qd))) && VCC);
assign path2184 = ~(~((cycle_cnt_7 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_7 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || cnt_i16_qd)) || ~((cycle_cnt_6 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_6 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || cnt_i16_qd)));
assign path2231 = unk_dec_o3 || ~((cycle_cnt_7 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_7 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || cnt_i16_qd)) || ~((cycle_cnt_6 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_6 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || cnt_i16_qd));
assign path2452 = ~(~((cycle_cnt_7 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_7 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || cnt_i16_qd)) || ~((cycle_cnt_6 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_6 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || cnt_i16_qd))) && VCC;
assign path2540 = ~(~(cycle_cnt_3 || SYNC_IN || cnt_i16_qd || ~r10_ff_a77_d3) || ~(cycle_cnt_2 || SYNC_IN || cnt_i16_qd || ~(r10_ff_a77_d3 || path1329)));
assign path2702 = cycle_cnt_7 || SYNC_IN || ~cnt_i16_qd;
assign r10_ff_clock = ~(~((cycle_cnt_7 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_7 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_5 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_3 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_1 || SYNC_IN || cnt_i16_qd)) || ~((cycle_cnt_6 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || ~cnt_i16_qd) && (cycle_cnt_6 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_4 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_2 || SYNC_IN || cnt_i16_qd) && (cycle_cnt_0 || SYNC_IN || cnt_i16_qd)));


assign dac_dec_ia = (r10_ff_a77_d1 && g2446) || (~r10_ff_a77_d1 && path2703);
assign dac_dec_ib = (r10_ff_a77_d1 && path2675) || (~r10_ff_a77_d1 && path2704);
assign dac_dec_ic = (r10_ff_a77_d1 && path2455) || (~r10_ff_a77_d1 && path2705);


assign g2784 = IC19_6_IN || ag1_latched;
assign path2131 = IC19_7_IN || ag1_latched;
assign path2321 = ~((~IC19_5_IN && r10_ff_a117_d5) || (IC19_5_IN && ~r10_ff_a117_d5)) || ag1_latched;
assign path2420 = ~((~IC19_1_IN && r10_ff_a117_d5) || (IC19_1_IN && ~r10_ff_a117_d5)) || ag1_latched;


assign path1514 = ~(~(~((path2772 && path2455 && ~path2675 && g2446) || (path1973 && path2455 && ~path2675 && ~g2446) || (path2277 && ~path2455 && path2675 && g2446) || (path2278 && ~path2455 && path2675 && ~g2446) || (path2736 && ~path2455 && ~path2675 && g2446) || (path2264 && ~path2455 && ~path2675 && ~g2446) || (path1968 && path2455 && path2675 && g2446) || (path2265 && path2455 && path2675 && ~g2446)) || (((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7)) || (((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7));
assign path1659 = ~(~(~((path1530 && path2455 && ~path2675 && g2446) || (path2303 && path2455 && ~path2675 && ~g2446) || (path2304 && ~path2455 && path2675 && g2446) || (path2750 && ~path2455 && path2675 && ~g2446) || (path2299 && ~path2455 && ~path2675 && g2446) || (path2300 && ~path2455 && ~path2675 && ~g2446) || (path2632 && path2455 && path2675 && g2446) || (path2631 && path2455 && path2675 && ~g2446)) || (((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7)) || (((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7));
assign path1672 = ~(~(~((path1679 && path2455 && ~path2675 && g2446) || (path2426 && path2455 && ~path2675 && ~g2446) || (path2638 && ~path2455 && path2675 && g2446) || (path2639 && ~path2455 && path2675 && ~g2446) || (path2660 && ~path2455 && ~path2675 && g2446) || (path2659 && ~path2455 && ~path2675 && ~g2446) || (path2478 && path2455 && path2675 && g2446) || (path2477 && path2455 && path2675 && ~g2446)) || (((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7)) || (((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7));
assign path1680 = ~(~(~((path2216 && path2455 && ~path2675 && g2446) || (path2217 && path2455 && ~path2675 && ~g2446) || (path2427 && ~path2455 && path2675 && g2446) || (path2430 && ~path2455 && path2675 && ~g2446) || (path2480 && ~path2455 && ~path2675 && g2446) || (path2431 && ~path2455 && ~path2675 && ~g2446) || (path2481 && path2455 && path2675 && g2446) || (path2653 && path2455 && path2675 && ~g2446)) || (((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7)) || (((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7));
assign path1788 = ~(~(~((path2210 && path2455 && ~path2675 && g2446) || (path2211 && path2455 && ~path2675 && ~g2446) || (path2214 && ~path2455 && path2675 && g2446) || (path2215 && ~path2455 && path2675 && ~g2446) || (path2644 && ~path2455 && ~path2675 && g2446) || (path2643 && ~path2455 && ~path2675 && ~g2446) || (path2483 && path2455 && path2675 && g2446) || (path2484 && path2455 && path2675 && ~g2446)) || (((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7)) || (((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7));
assign path1789 = ~(~(~((path2306 && path2455 && ~path2675 && g2446) || (path2677 && path2455 && ~path2675 && ~g2446) || (path1398 && ~path2455 && path2675 && g2446) || (path1904 && ~path2455 && path2675 && ~g2446) || (path2680 && ~path2455 && ~path2675 && g2446) || (path1531 && ~path2455 && ~path2675 && ~g2446) || (path1397 && path2455 && path2675 && g2446) || (path1903 && path2455 && path2675 && ~g2446)) || (((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7)) || (((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7));
assign path1906 = ~(~(~((path2230 && path2455 && ~path2675 && g2446) || (path2229 && path2455 && ~path2675 && ~g2446) || (path2647 && ~path2455 && path2675 && g2446) || (path2646 && ~path2455 && path2675 && ~g2446) || (path2635 && ~path2455 && ~path2675 && g2446) || (path2432 && ~path2455 && ~path2675 && ~g2446) || (path2482 && path2455 && path2675 && g2446) || (path2433 && path2455 && path2675 && ~g2446)) || (((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7)) || (((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7));
assign path1907 = ~(~(~((path2769 && path2455 && ~path2675 && g2446) || (path2770 && path2455 && ~path2675 && ~g2446) || (path2771 && ~path2455 && path2675 && g2446) || (path1971 && ~path2455 && path2675 && ~g2446) || (path1969 && ~path2455 && ~path2675 && g2446) || (path1970 && ~path2455 && ~path2675 && ~g2446) || (path2267 && path2455 && path2675 && g2446) || (path2266 && path2455 && path2675 && ~g2446)) || (((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7)) || (((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7));
assign path1911 = ~(~(~((path2290 && path2455 && ~path2675 && g2446) || (path2276 && path2455 && ~path2675 && ~g2446) || (path2275 && ~path2455 && path2675 && g2446) || (path2291 && ~path2455 && path2675 && ~g2446) || (path2317 && ~path2455 && ~path2675 && g2446) || (path2314 && ~path2455 && ~path2675 && ~g2446) || (path2262 && path2455 && path2675 && g2446) || (path2263 && path2455 && path2675 && ~g2446)) || (((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7)) || (((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7));
assign path1960 = ~(~(~((path2209 && path2455 && ~path2675 && g2446) || (path2208 && path2455 && ~path2675 && ~g2446) || (path2428 && ~path2455 && path2675 && g2446) || (path2429 && ~path2455 && path2675 && ~g2446) || (path2787 && ~path2455 && ~path2675 && g2446) || (path2642 && ~path2455 && ~path2675 && ~g2446) || (path2641 && path2455 && path2675 && g2446) || (path2485 && path2455 && path2675 && ~g2446)) || (((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7)) || (((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7));
assign path2270 = ~(~(~((path2751 && path2455 && ~path2675 && g2446) || (path2775 && path2455 && ~path2675 && ~g2446) || (path2294 && ~path2455 && path2675 && g2446) || (path2302 && ~path2455 && path2675 && ~g2446) || (path2298 && ~path2455 && ~path2675 && g2446) || (path2301 && ~path2455 && ~path2675 && ~g2446) || (path2237 && path2455 && path2675 && g2446) || (path2679 && path2455 && path2675 && ~g2446)) || (((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7)) || (((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7));
assign path2365 = ~(~(~((path2285 && path2455 && ~path2675 && g2446) || (path1484 && path2455 && ~path2675 && ~g2446) || (path1474 && ~path2455 && path2675 && g2446) || (path2650 && ~path2455 && path2675 && ~g2446) || (path2473 && ~path2455 && ~path2675 && g2446) || (path2475 && ~path2455 && ~path2675 && ~g2446) || (path2474 && path2455 && path2675 && g2446) || (path2652 && path2455 && path2675 && ~g2446)) || (((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7)) || (((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7));
assign path2467 = ~(~(~((path1939 && path2455 && ~path2675 && g2446) || (path2273 && path2455 && ~path2675 && ~g2446) || (path2274 && ~path2455 && path2675 && g2446) || (path1972 && ~path2455 && path2675 && ~g2446) || (path2316 && ~path2455 && ~path2675 && g2446) || (path2315 && ~path2455 && ~path2675 && ~g2446) || (path2268 && path2455 && path2675 && g2446) || (path2768 && path2455 && path2675 && ~g2446)) || (((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7)) || (((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7));
assign path2468 = ~(~(~((path2789 && path2455 && ~path2675 && g2446) || (path2678 && path2455 && ~path2675 && ~g2446) || (path2293 && ~path2455 && path2675 && g2446) || (path2292 && ~path2455 && path2675 && ~g2446) || (path2661 && ~path2455 && ~path2675 && g2446) || (path2295 && ~path2455 && ~path2675 && ~g2446) || (path2305 && path2455 && path2675 && g2446) || (path2774 && path2455 && path2675 && ~g2446)) || (((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7)) || (((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7));
assign path2469 = ~(~(~((path2284 && path2455 && ~path2675 && g2446) || (path1644 && path2455 && ~path2675 && ~g2446) || (path2648 && ~path2455 && path2675 && g2446) || (path2649 && ~path2455 && path2675 && ~g2446) || (path2640 && ~path2455 && ~path2675 && g2446) || (path2651 && ~path2455 && ~path2675 && ~g2446) || (path2723 && path2455 && path2675 && g2446) || (path2226 && path2455 && path2675 && ~g2446)) || (((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7)) || (((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) && ~((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) && ~r10_ff_a117_d7));


assign g2417 = ~((~IC19_3_IN && r10_ff_a117_d5) || (IC19_3_IN && ~r10_ff_a117_d5));

assign r5_d1_and = ~((~R5_D1_IN && r10_ff_a117_d5) || (R5_D1_IN && ~r10_ff_a117_d5));
assign r5_d5_and = ~((~R5_D5_IN && r10_ff_a117_d5) || (R5_D5_IN && ~r10_ff_a117_d5));
assign r5_d6_and = ~((~R5_D6_IN && r10_ff_a117_d5) || (R5_D6_IN && ~r10_ff_a117_d5));
assign r6_d0_and = ~((~R6_D0_IN && r10_ff_a117_d5) || (R6_D0_IN && ~r10_ff_a117_d5));
assign r6_d3_and = ~((~R6_D3_IN && r10_ff_a117_d5) || (R6_D3_IN && ~r10_ff_a117_d5));
assign r6_d7_and = ~((R6_D7_IN && ~r10_ff_a117_d5) || ~(R6_D7_IN || ~r10_ff_a117_d5) || g1921);
assign r6_d7_and_2 = ~((R6_D7_IN && ~r10_ff_a117_d5) || ~(R6_D7_IN || ~r10_ff_a117_d5) || ~g1921);
assign r7_d3_and = ~((~R7_D3_IN && r10_ff_a117_d5) || (R7_D3_IN && ~r10_ff_a117_d5));
assign r7_d6_and = ~((~R7_D6_IN && r10_ff_a117_d5) || (R7_D6_IN && ~r10_ff_a117_d5));

assign g1462 = path2404;
assign g1473 = path1675;
assign g1491 = path2636;
assign g1522 = ~path1517;
assign g1650 = ~path1645;
assign g1655 = ~path1656;
assign g1689 = ~path1684;
assign g1757 = ~path2098;
assign g1917 = ~path1912;
assign g1981 = path1982;
assign g2207 = path1886;
assign g2213 = path2682;
assign g2219 = path1885;
assign g2235 = ~((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446));
assign g2261 = path1896;
assign g2280 = path2738;
assign g2282 = path1895;
assign g2370 = ~path2366;
assign g2393 = ~path2368;
assign g2488 = ~path1516;
assign g2584 = ~path2367;
assign g2586 = ~path1657;
assign g2588 = ~path1658;
assign g2656 = path2684;
assign g2669 = ~path1683;
assign g2671 = ~path1682;
assign g2673 = ~path1681;
assign g2773 = path1890;
assign g2788 = path2479;
assign g7 = ~((~IC19_1_IN && r10_ff_a117_d5) || (IC19_1_IN && ~r10_ff_a117_d5));
assign path1328 = ~(((~SR_SEL_IN && g107) || path1987 || path2362 || g2361) && (MPX1_OUT || g25 || path2780 || path2781));
assign path1361 = ~((((~path2508 && ~path2181 && ~path2735 && ~path2405 && ~path2707) || (~path2181 && ~path2735 && ~path2405 && ~path2708)) && path2404) || (~((~path2508 && ~path2181 && ~path2735 && ~path2405 && ~path2707) || (~path2181 && ~path2735 && ~path2405 && ~path2708)) && ~path2404));
assign path1363 = ~(~((path2306 && path2455 && ~path2675 && g2446) || (path2677 && path2455 && ~path2675 && ~g2446) || (path1398 && ~path2455 && path2675 && g2446) || (path1904 && ~path2455 && path2675 && ~g2446) || (path2680 && ~path2455 && ~path2675 && g2446) || (path1531 && ~path2455 && ~path2675 && ~g2446) || (path1397 && path2455 && path2675 && g2446) || (path1903 && path2455 && path2675 && ~g2446)) || ~(~(r10_ff_a77_d3 || path1329) || g1720) || r10_ff_a77_d0);
assign path1364 = ~(~((path2789 && path2455 && ~path2675 && g2446) || (path2678 && path2455 && ~path2675 && ~g2446) || (path2293 && ~path2455 && path2675 && g2446) || (path2292 && ~path2455 && path2675 && ~g2446) || (path2661 && ~path2455 && ~path2675 && g2446) || (path2295 && ~path2455 && ~path2675 && ~g2446) || (path2305 && path2455 && path2675 && g2446) || (path2774 && path2455 && path2675 && ~g2446)) || ~(~(r10_ff_a77_d3 || path1329) || g1720) || r10_ff_a77_d0);
assign path1366 = ~((~(~path2181 && ~path2735 && ~path2405 && ~path2707) && ~path2404) || (~path2181 && ~path2735 && ~path2405 && ~path2707 && path2404));
assign path1372 = ~(~(path2713 && ~g1720) && ~(GND && g1720));
assign path1393 = ~((~((path2512 && ~path2181 && ~path2735 && ~path2405 && ~path2707) || (g1387 && ~path2181 && ~path2735 && ~path2405 && ~path2708) || (g1994 && ~path2181 && ~path2735 && ~path2732 && ~path2707) || (g2511 && ~path2181 && ~path2735 && ~path2732 && ~path2708) || (g1341 && ~path2181 && ~path2733 && ~path2405 && ~path2707) || (~path2336 && ~path2181 && ~path2733 && ~path2405 && ~path2708) || (~path2335 && ~path2181 && ~path2733 && ~path2732 && ~path2707) || (~path1300 && ~path2181 && ~path2733 && ~path2732 && ~path2708)) && ~((~path2507 && ~path2734 && ~path2735 && ~path2405 && ~path2707) || (~path2508 && ~path2734 && ~path2735 && ~path2405 && ~path2708) || (~path2734 && ~path2735 && ~path2732 && ~path2707)) && ~path2404) || (~(~((path2512 && ~path2181 && ~path2735 && ~path2405 && ~path2707) || (g1387 && ~path2181 && ~path2735 && ~path2405 && ~path2708) || (g1994 && ~path2181 && ~path2735 && ~path2732 && ~path2707) || (g2511 && ~path2181 && ~path2735 && ~path2732 && ~path2708) || (g1341 && ~path2181 && ~path2733 && ~path2405 && ~path2707) || (~path2336 && ~path2181 && ~path2733 && ~path2405 && ~path2708) || (~path2335 && ~path2181 && ~path2733 && ~path2732 && ~path2707) || (~path1300 && ~path2181 && ~path2733 && ~path2732 && ~path2708)) && ~((~path2507 && ~path2734 && ~path2735 && ~path2405 && ~path2707) || (~path2508 && ~path2734 && ~path2735 && ~path2405 && ~path2708) || (~path2734 && ~path2735 && ~path2732 && ~path2707))) && path2404));
assign path1409 = ~(~((path2285 && path2455 && ~path2675 && g2446) || (path1484 && path2455 && ~path2675 && ~g2446) || (path1474 && ~path2455 && path2675 && g2446) || (path2650 && ~path2455 && path2675 && ~g2446) || (path2473 && ~path2455 && ~path2675 && g2446) || (path2475 && ~path2455 && ~path2675 && ~g2446) || (path2474 && path2455 && path2675 && g2446) || (path2652 && path2455 && path2675 && ~g2446)) || ~(~(r10_ff_a77_d3 || path1329) || g1720) || r10_ff_a77_d0);
assign path1411 = ~((~((path2512 && ~path2181 && ~path2735 && ~path2405 && ~path2708) || (g1387 && ~path2181 && ~path2735 && ~path2732 && ~path2707) || (g1994 && ~path2181 && ~path2735 && ~path2732 && ~path2708) || (g2511 && ~path2181 && ~path2733 && ~path2405 && ~path2707) || (g1341 && ~path2181 && ~path2733 && ~path2405 && ~path2708) || (~path2336 && ~path2181 && ~path2733 && ~path2732 && ~path2707) || (~path2335 && ~path2181 && ~path2733 && ~path2732 && ~path2708) || (~path1300 && ~path2734 && ~path2735 && ~path2405 && ~path2707)) && ~((~path2507 && ~path2734 && ~path2735 && ~path2405 && ~path2708) || (~path2508 && ~path2734 && ~path2735 && ~path2732 && ~path2707) || (~path2734 && ~path2735 && ~path2732 && ~path2708)) && ~path2404) || (~(~((path2512 && ~path2181 && ~path2735 && ~path2405 && ~path2708) || (g1387 && ~path2181 && ~path2735 && ~path2732 && ~path2707) || (g1994 && ~path2181 && ~path2735 && ~path2732 && ~path2708) || (g2511 && ~path2181 && ~path2733 && ~path2405 && ~path2707) || (g1341 && ~path2181 && ~path2733 && ~path2405 && ~path2708) || (~path2336 && ~path2181 && ~path2733 && ~path2732 && ~path2707) || (~path2335 && ~path2181 && ~path2733 && ~path2732 && ~path2708) || (~path1300 && ~path2734 && ~path2735 && ~path2405 && ~path2707)) && ~((~path2507 && ~path2734 && ~path2735 && ~path2405 && ~path2708) || (~path2508 && ~path2734 && ~path2735 && ~path2732 && ~path2707) || (~path2734 && ~path2735 && ~path2732 && ~path2708))) && path2404));
assign path1414 = ~(~(path1450 && ~g1720) && ~(GND && g1720));
assign path1420 = ~(~(~path2776 && g37 && ~g2034 && path2602) && ~(path2776 && ~g37 && ~g2034 && path2602) && ~(path2776 && ~g37 && g2034 && ~path2602) && ~(path2776 && ~g37 && g2034 && path2602));
assign path1440 = ~(~(g2621 && ~g1720) && ~(path2258 && g1720));
assign path1464 = ~((~((path2512 && ~path2181 && ~path2735 && ~path2732 && ~path2708) || (g1387 && ~path2181 && ~path2733 && ~path2405 && ~path2707) || (g1994 && ~path2181 && ~path2733 && ~path2405 && ~path2708) || (g2511 && ~path2181 && ~path2733 && ~path2732 && ~path2707) || (g1341 && ~path2181 && ~path2733 && ~path2732 && ~path2708) || (~path2336 && ~path2734 && ~path2735 && ~path2405 && ~path2707) || (~path2335 && ~path2734 && ~path2735 && ~path2405 && ~path2708) || (~path1300 && ~path2734 && ~path2735 && ~path2732 && ~path2707)) && ~((~path2507 && ~path2734 && ~path2735 && ~path2732 && ~path2708) || (~path2508 && ~path2734 && ~path2733 && ~path2405 && ~path2707) || (~path2734 && ~path2733 && ~path2405 && ~path2708)) && ~path2404) || (~(~((path2512 && ~path2181 && ~path2735 && ~path2732 && ~path2708) || (g1387 && ~path2181 && ~path2733 && ~path2405 && ~path2707) || (g1994 && ~path2181 && ~path2733 && ~path2405 && ~path2708) || (g2511 && ~path2181 && ~path2733 && ~path2732 && ~path2707) || (g1341 && ~path2181 && ~path2733 && ~path2732 && ~path2708) || (~path2336 && ~path2734 && ~path2735 && ~path2405 && ~path2707) || (~path2335 && ~path2734 && ~path2735 && ~path2405 && ~path2708) || (~path1300 && ~path2734 && ~path2735 && ~path2732 && ~path2707)) && ~((~path2507 && ~path2734 && ~path2735 && ~path2732 && ~path2708) || (~path2508 && ~path2734 && ~path2733 && ~path2405 && ~path2707) || (~path2734 && ~path2733 && ~path2405 && ~path2708))) && path2404));
assign path1466 = ~(~((path1679 && path2455 && ~path2675 && g2446) || (path2426 && path2455 && ~path2675 && ~g2446) || (path2638 && ~path2455 && path2675 && g2446) || (path2639 && ~path2455 && path2675 && ~g2446) || (path2660 && ~path2455 && ~path2675 && g2446) || (path2659 && ~path2455 && ~path2675 && ~g2446) || (path2478 && path2455 && path2675 && g2446) || (path2477 && path2455 && path2675 && ~g2446)) || ~(~(r10_ff_a77_d3 || path1329) || g1720) || r10_ff_a77_d0);
assign path1600 = ~(~(path2714 && ~g1720) && ~(path2016 && g1720));
assign path1697 = ~((((~path1300 && ~path2181 && ~path2735 && ~path2405 && ~path2707) || (~path2507 && ~path2181 && ~path2735 && ~path2405 && ~path2708) || (~path2508 && ~path2181 && ~path2735 && ~path2732 && ~path2707) || (VCC && ~path2181 && ~path2735 && ~path2732 && ~path2708)) && path2404) || (~((~path1300 && ~path2181 && ~path2735 && ~path2405 && ~path2707) || (~path2507 && ~path2181 && ~path2735 && ~path2405 && ~path2708) || (~path2508 && ~path2181 && ~path2735 && ~path2732 && ~path2707) || (VCC && ~path2181 && ~path2735 && ~path2732 && ~path2708)) && ~path2404));
assign path1698 = ~((((VCC && ~path2181 && ~path2733 && ~path2732 && ~path2707) || (~path2508 && ~path2181 && ~path2733 && ~path2405 && ~path2708) || (~path2507 && ~path2181 && ~path2733 && ~path2405 && ~path2707) || (~path1300 && ~path2181 && ~path2735 && ~path2732 && ~path2708) || (~path2335 && ~path2181 && ~path2735 && ~path2732 && ~path2707) || (~path2336 && ~path2181 && ~path2735 && ~path2405 && ~path2708) || (g1341 && ~path2181 && ~path2735 && ~path2405 && ~path2707) || (VCC && GND)) && path2404) || (~((VCC && ~path2181 && ~path2733 && ~path2732 && ~path2707) || (~path2508 && ~path2181 && ~path2733 && ~path2405 && ~path2708) || (~path2507 && ~path2181 && ~path2733 && ~path2405 && ~path2707) || (~path1300 && ~path2181 && ~path2735 && ~path2732 && ~path2708) || (~path2335 && ~path2181 && ~path2735 && ~path2732 && ~path2707) || (~path2336 && ~path2181 && ~path2735 && ~path2405 && ~path2708) || (g1341 && ~path2181 && ~path2735 && ~path2405 && ~path2707) || (VCC && GND)) && ~path2404));
assign path1700 = ~((~((~path2508 && ~path2181 && ~path2735 && ~path2732 && ~path2708) || (~path2507 && ~path2181 && ~path2735 && ~path2732 && ~path2707) || (~path1300 && ~path2181 && ~path2735 && ~path2405 && ~path2708) || (~path2335 && ~path2181 && ~path2735 && ~path2405 && ~path2707)) && ~(~path2181 && ~path2733 && ~path2405 && ~path2707) && ~path2404) || (~(~((~path2508 && ~path2181 && ~path2735 && ~path2732 && ~path2708) || (~path2507 && ~path2181 && ~path2735 && ~path2732 && ~path2707) || (~path1300 && ~path2181 && ~path2735 && ~path2405 && ~path2708) || (~path2335 && ~path2181 && ~path2735 && ~path2405 && ~path2707)) && ~(~path2181 && ~path2733 && ~path2405 && ~path2707)) && path2404));
assign path1715 = ~g1720;
assign path1723 = ~((~((path2512 && ~path2181 && ~path2735 && ~path2732 && ~path2707) || (g1387 && ~path2181 && ~path2735 && ~path2732 && ~path2708) || (g1994 && ~path2181 && ~path2733 && ~path2405 && ~path2707) || (g2511 && ~path2181 && ~path2733 && ~path2405 && ~path2708) || (g1341 && ~path2181 && ~path2733 && ~path2732 && ~path2707) || (~path2336 && ~path2181 && ~path2733 && ~path2732 && ~path2708) || (~path2335 && ~path2734 && ~path2735 && ~path2405 && ~path2707) || (~path1300 && ~path2734 && ~path2735 && ~path2405 && ~path2708)) && ~((~path2507 && ~path2734 && ~path2735 && ~path2732 && ~path2707) || (~path2508 && ~path2734 && ~path2735 && ~path2732 && ~path2708) || (~path2734 && ~path2733 && ~path2405 && ~path2707)) && ~path2404) || (~(~((path2512 && ~path2181 && ~path2735 && ~path2732 && ~path2707) || (g1387 && ~path2181 && ~path2735 && ~path2732 && ~path2708) || (g1994 && ~path2181 && ~path2733 && ~path2405 && ~path2707) || (g2511 && ~path2181 && ~path2733 && ~path2405 && ~path2708) || (g1341 && ~path2181 && ~path2733 && ~path2732 && ~path2707) || (~path2336 && ~path2181 && ~path2733 && ~path2732 && ~path2708) || (~path2335 && ~path2734 && ~path2735 && ~path2405 && ~path2707) || (~path1300 && ~path2734 && ~path2735 && ~path2405 && ~path2708)) && ~((~path2507 && ~path2734 && ~path2735 && ~path2732 && ~path2707) || (~path2508 && ~path2734 && ~path2735 && ~path2732 && ~path2708) || (~path2734 && ~path2733 && ~path2405 && ~path2707))) && path2404));
assign path1724 = ~((~((path2512 && ~path2181 && ~path2733 && ~path2405 && ~path2707) || (g1387 && ~path2181 && ~path2733 && ~path2405 && ~path2708) || (g1994 && ~path2181 && ~path2733 && ~path2732 && ~path2707) || (g2511 && ~path2181 && ~path2733 && ~path2732 && ~path2708) || (g1341 && ~path2734 && ~path2735 && ~path2405 && ~path2707) || (~path2336 && ~path2734 && ~path2735 && ~path2405 && ~path2708) || (~path2335 && ~path2734 && ~path2735 && ~path2732 && ~path2707) || (~path1300 && ~path2734 && ~path2735 && ~path2732 && ~path2708)) && ~((~path2507 && ~path2734 && ~path2733 && ~path2405 && ~path2707) || (~path2508 && ~path2734 && ~path2733 && ~path2405 && ~path2708) || (~path2734 && ~path2733 && ~path2732 && ~path2707)) && ~path2404) || (~(~((path2512 && ~path2181 && ~path2733 && ~path2405 && ~path2707) || (g1387 && ~path2181 && ~path2733 && ~path2405 && ~path2708) || (g1994 && ~path2181 && ~path2733 && ~path2732 && ~path2707) || (g2511 && ~path2181 && ~path2733 && ~path2732 && ~path2708) || (g1341 && ~path2734 && ~path2735 && ~path2405 && ~path2707) || (~path2336 && ~path2734 && ~path2735 && ~path2405 && ~path2708) || (~path2335 && ~path2734 && ~path2735 && ~path2732 && ~path2707) || (~path1300 && ~path2734 && ~path2735 && ~path2732 && ~path2708)) && ~((~path2507 && ~path2734 && ~path2733 && ~path2405 && ~path2707) || (~path2508 && ~path2734 && ~path2733 && ~path2405 && ~path2708) || (~path2734 && ~path2733 && ~path2732 && ~path2707))) && path2404));
assign path1728 = ~(~((path2210 && path2455 && ~path2675 && g2446) || (path2211 && path2455 && ~path2675 && ~g2446) || (path2214 && ~path2455 && path2675 && g2446) || (path2215 && ~path2455 && path2675 && ~g2446) || (path2644 && ~path2455 && ~path2675 && g2446) || (path2643 && ~path2455 && ~path2675 && ~g2446) || (path2483 && path2455 && path2675 && g2446) || (path2484 && path2455 && path2675 && ~g2446)) || ~(~(r10_ff_a77_d3 || path1329) || g1720) || r10_ff_a77_d0);
assign path1740 = ~(~((path1939 && path2455 && ~path2675 && g2446) || (path2273 && path2455 && ~path2675 && ~g2446) || (path2274 && ~path2455 && path2675 && g2446) || (path1972 && ~path2455 && path2675 && ~g2446) || (path2316 && ~path2455 && ~path2675 && g2446) || (path2315 && ~path2455 && ~path2675 && ~g2446) || (path2268 && path2455 && path2675 && g2446) || (path2768 && path2455 && path2675 && ~g2446)) || ~(~(r10_ff_a77_d3 || path1329) || g1720) || r10_ff_a77_d0);
assign path1742 = ~((~((g25 && ~path2734 && ~path2735 && ~path2405 && ~path2707) || (~path2508 && ~path2181 && ~path2733 && ~path2732 && ~path2708) || (~path2507 && ~path2181 && ~path2733 && ~path2732 && ~path2707) || (~path1300 && ~path2181 && ~path2733 && ~path2405 && ~path2708) || (~path2335 && ~path2181 && ~path2733 && ~path2405 && ~path2707) || (~path2336 && ~path2181 && ~path2735 && ~path2732 && ~path2708) || (g1341 && ~path2181 && ~path2735 && ~path2732 && ~path2707) || (g2511 && ~path2181 && ~path2735 && ~path2405 && ~path2708)) && ~(g1994 && ~path2181 && ~path2735 && ~path2405 && ~path2707) && ~path2404) || (~(~((g25 && ~path2734 && ~path2735 && ~path2405 && ~path2707) || (~path2508 && ~path2181 && ~path2733 && ~path2732 && ~path2708) || (~path2507 && ~path2181 && ~path2733 && ~path2732 && ~path2707) || (~path1300 && ~path2181 && ~path2733 && ~path2405 && ~path2708) || (~path2335 && ~path2181 && ~path2733 && ~path2405 && ~path2707) || (~path2336 && ~path2181 && ~path2735 && ~path2732 && ~path2708) || (g1341 && ~path2181 && ~path2735 && ~path2732 && ~path2707) || (g2511 && ~path2181 && ~path2735 && ~path2405 && ~path2708)) && ~(g1994 && ~path2181 && ~path2735 && ~path2405 && ~path2707)) && path2404));
assign path1783 = ~(~((path2769 && path2455 && ~path2675 && g2446) || (path2770 && path2455 && ~path2675 && ~g2446) || (path2771 && ~path2455 && path2675 && g2446) || (path1971 && ~path2455 && path2675 && ~g2446) || (path1969 && ~path2455 && ~path2675 && g2446) || (path1970 && ~path2455 && ~path2675 && ~g2446) || (path2267 && path2455 && path2675 && g2446) || (path2266 && path2455 && path2675 && ~g2446)) || ~(~(r10_ff_a77_d3 || path1329) || g1720) || r10_ff_a77_d0);
assign path1784 = ~(~((path2645 && path2455 && ~path2675 && g2446) || (path2225 && path2455 && ~path2675 && ~g2446) || (path2228 && ~path2455 && path2675 && g2446) || (path2227 && ~path2455 && path2675 && ~g2446) || (path2724 && ~path2455 && ~path2675 && g2446) || (path2476 && ~path2455 && ~path2675 && ~g2446) || (path2472 && path2455 && path2675 && g2446) || (path1738 && path2455 && path2675 && ~g2446)) || ~(~(r10_ff_a77_d3 || path1329) || g1720) || r10_ff_a77_d0);
assign path1791 = ~r10_ff_a117_d6;
assign path1843 = ~(~(path2521 && ~g1720) && ~(GND && g1720));
assign path1844 = path2251 || path2422;
assign path1845 = path2250 || path2422;
assign path1846 = path2693 || path2422;
assign path1892 = ~(~((path2772 && path2455 && ~path2675 && g2446) || (path1973 && path2455 && ~path2675 && ~g2446) || (path2277 && ~path2455 && path2675 && g2446) || (path2278 && ~path2455 && path2675 && ~g2446) || (path2736 && ~path2455 && ~path2675 && g2446) || (path2264 && ~path2455 && ~path2675 && ~g2446) || (path1968 && path2455 && path2675 && g2446) || (path2265 && path2455 && path2675 && ~g2446)) || ~(~(r10_ff_a77_d3 || path1329) || g1720) || r10_ff_a77_d0);
assign path2002 = ~path2776 && ~g37 && ~g2034 && ~path2602;
assign path2009 = ~(VCC && ~(~path2776 && ~g37 && g2034 && path2602) && ~(~path2776 && g37 && g2034 && ~path2602) && ~(path2776 && ~g37 && ~g2034 && path2602) && ~(path2776 && g37 && ~g2034 && ~path2602) && ~(path2776 && g37 && ~g2034 && path2602));
assign path2013 = ~(~(~path2776 && ~g37 && ~g2034 && ~path2602) && ~(~path2776 && ~g37 && g2034 && ~path2602) && ~(~path2776 && g37 && ~g2034 && path2602) && ~(~path2776 && g37 && g2034 && ~path2602) && ~(~path2776 && g37 && g2034 && path2602) && ~(path2776 && ~g37 && ~g2034 && ~path2602));
assign path2035 = ~path2591;
assign path2055 = ~path2056;
assign path2058 = ~((~((~path2508 && ~path2734 && ~path2735 && ~path2405 && ~path2707) || (~path2507 && ~path2181 && ~path2733 && ~path2732 && ~path2708) || (~path1300 && ~path2181 && ~path2733 && ~path2732 && ~path2707) || (~path2335 && ~path2181 && ~path2733 && ~path2405 && ~path2708) || (~path2336 && ~path2181 && ~path2733 && ~path2405 && ~path2707) || (g1341 && ~path2181 && ~path2735 && ~path2732 && ~path2708) || (g2511 && ~path2181 && ~path2735 && ~path2732 && ~path2707) || (g1994 && ~path2181 && ~path2735 && ~path2405 && ~path2708)) && ~((g1387 && ~path2181 && ~path2735 && ~path2405 && ~path2707) || (~path2734 && ~path2735 && ~path2405 && ~path2708)) && ~path2404) || (~(~((~path2508 && ~path2734 && ~path2735 && ~path2405 && ~path2707) || (~path2507 && ~path2181 && ~path2733 && ~path2732 && ~path2708) || (~path1300 && ~path2181 && ~path2733 && ~path2732 && ~path2707) || (~path2335 && ~path2181 && ~path2733 && ~path2405 && ~path2708) || (~path2336 && ~path2181 && ~path2733 && ~path2405 && ~path2707) || (g1341 && ~path2181 && ~path2735 && ~path2732 && ~path2708) || (g2511 && ~path2181 && ~path2735 && ~path2732 && ~path2707) || (g1994 && ~path2181 && ~path2735 && ~path2405 && ~path2708)) && ~((g1387 && ~path2181 && ~path2735 && ~path2405 && ~path2707) || (~path2734 && ~path2735 && ~path2405 && ~path2708))) && path2404));
assign path2099 = ~path1515;
assign path2108 = ~(~((path1984 && path2696 && SR_SEL_IN) || (clock_low_sr && ~SR_SEL_IN)) && ~r10_ff_a117_d4);
assign path2160 = path2162;
assign path2161 = path2740;
assign path2201 = ~((((~path2507 && ~path2181 && ~path2735 && ~path2405 && ~path2707) || (~path2508 && ~path2181 && ~path2735 && ~path2405 && ~path2708) || (~path2181 && ~path2735 && ~path2732 && ~path2707)) && path2404) || (~((~path2507 && ~path2181 && ~path2735 && ~path2405 && ~path2707) || (~path2508 && ~path2181 && ~path2735 && ~path2405 && ~path2708) || (~path2181 && ~path2735 && ~path2732 && ~path2707)) && ~path2404));
assign path2238 = path2629;
assign path2239 = path2663;
assign path2240 = path2662;
assign path2241 = ~(~((path2230 && path2455 && ~path2675 && g2446) || (path2229 && path2455 && ~path2675 && ~g2446) || (path2647 && ~path2455 && path2675 && g2446) || (path2646 && ~path2455 && path2675 && ~g2446) || (path2635 && ~path2455 && ~path2675 && g2446) || (path2432 && ~path2455 && ~path2675 && ~g2446) || (path2482 && path2455 && path2675 && g2446) || (path2433 && path2455 && path2675 && ~g2446)) || ~(~(r10_ff_a77_d3 || path1329) || g1720) || r10_ff_a77_d0);
assign path2243 = ~(~((path2209 && path2455 && ~path2675 && g2446) || (path2208 && path2455 && ~path2675 && ~g2446) || (path2428 && ~path2455 && path2675 && g2446) || (path2429 && ~path2455 && path2675 && ~g2446) || (path2787 && ~path2455 && ~path2675 && g2446) || (path2642 && ~path2455 && ~path2675 && ~g2446) || (path2641 && path2455 && path2675 && g2446) || (path2485 && path2455 && path2675 && ~g2446)) || ~(~(r10_ff_a77_d3 || path1329) || g1720) || r10_ff_a77_d0);
assign path2246 = ~(~(path1591 && ~g1720) && ~((path1596 || path2605) && g1720));
assign path2249 = ~(~(path2717 && ~g1720) && ~((path1598 || path2605) && g1720));
assign path2254 = path2253 || path2422;
assign path2307 = ~(~((path2284 && path2455 && ~path2675 && g2446) || (path1644 && path2455 && ~path2675 && ~g2446) || (path2648 && ~path2455 && path2675 && g2446) || (path2649 && ~path2455 && path2675 && ~g2446) || (path2640 && ~path2455 && ~path2675 && g2446) || (path2651 && ~path2455 && ~path2675 && ~g2446) || (path2723 && path2455 && path2675 && g2446) || (path2226 && path2455 && path2675 && ~g2446)) || ~(~(r10_ff_a77_d3 || path1329) || g1720) || r10_ff_a77_d0);
assign path2318 = ~(~((path2290 && path2455 && ~path2675 && g2446) || (path2276 && path2455 && ~path2675 && ~g2446) || (path2275 && ~path2455 && path2675 && g2446) || (path2291 && ~path2455 && path2675 && ~g2446) || (path2317 && ~path2455 && ~path2675 && g2446) || (path2314 && ~path2455 && ~path2675 && ~g2446) || (path2262 && path2455 && path2675 && g2446) || (path2263 && path2455 && path2675 && ~g2446)) || ~(~(r10_ff_a77_d3 || path1329) || g1720) || r10_ff_a77_d0);
assign path2323 = FSYNC_IN && ~(g2361 && g107 && ~(~((path1984 && path2696 && SR_SEL_IN) || (clock_low_sr && ~SR_SEL_IN)) && ~r10_ff_a117_d4));
assign path2407 = ~(~((path2049 && path2455 && ~path2675 && g2446) || (path2051 && path2455 && ~path2675 && ~g2446) || (path2053 && ~path2455 && path2675 && g2446) || (path2052 && ~path2455 && path2675 && ~g2446) || (path2050 && ~path2455 && ~path2675 && g2446) || (path1528 && ~path2455 && ~path2675 && ~g2446) || (path2054 && path2455 && path2675 && g2446) || (path1529 && path2455 && path2675 && ~g2446)) || ~(~(r10_ff_a77_d3 || path1329) || g1720) || r10_ff_a77_d0);
assign path2409 = ~(~((path1530 && path2455 && ~path2675 && g2446) || (path2303 && path2455 && ~path2675 && ~g2446) || (path2304 && ~path2455 && path2675 && g2446) || (path2750 && ~path2455 && path2675 && ~g2446) || (path2299 && ~path2455 && ~path2675 && g2446) || (path2300 && ~path2455 && ~path2675 && ~g2446) || (path2632 && path2455 && path2675 && g2446) || (path2631 && path2455 && path2675 && ~g2446)) || ~(~(r10_ff_a77_d3 || path1329) || g1720) || r10_ff_a77_d0);
assign path2410 = ~(~(path2720 && ~g1720) && ~((path2749 || path2605) && g1720));
assign path2412 = ~(~(path2716 && ~g1720) && ~(path2017 && g1720));
assign path2415 = ~(~(path2715 && ~g1720) && ~(path2615 && g1720));
assign path2425 = path2637;
assign path2523 = ~(~(path2018 && ~g1720) && ~(path2520 && g1720));
assign path2566 = ~(~(path2727 && ~g1720) && ~(GND && g1720));
assign path2571 = ~(g2621 && ~(~path2776 && ~g37 && g2034 && path2602) && ~(~path2776 && g37 && ~g2034 && path2602) && ~(~path2776 && g37 && g2034 && ~path2602) && ~(~path2776 && g37 && g2034 && path2602) && ~(path2776 && ~g37 && g2034 && ~path2602) && ~(path2776 && g37 && ~g2034 && ~path2602) && ~(path2776 && g37 && g2034 && ~path2602));
assign path2573 = ~(~(path2572 && ~g1720) && ~(path2626 && g1720));
assign path2576 = ~((~IC19_5_IN && r10_ff_a117_d5) || (IC19_5_IN && ~r10_ff_a117_d5));
assign path2592 = ~(~((path2765 && path2455 && ~path2675 && g2446) || (path2764 && path2455 && ~path2675 && ~g2446) || (path2232 && ~path2455 && path2675 && g2446) || (path2233 && ~path2455 && path2675 && ~g2446) || (path1867 && ~path2455 && ~path2675 && g2446) || (path1866 && ~path2455 && ~path2675 && ~g2446) || (path2223 && path2455 && path2675 && g2446) || (path2222 && path2455 && path2675 && ~g2446)) || ~(~(r10_ff_a77_d3 || path1329) || g1720) || r10_ff_a77_d0);
assign path2603 = ~(~(~path2776 && ~g37 && ~g2034 && ~path2602) && ~(~path2776 && ~g37 && ~g2034 && path2602));
assign path2614 = ~(~(~path2776 && ~g37 && ~g2034 && ~path2602) && ~(~path2776 && ~g37 && g2034 && ~path2602) && ~(~path2776 && ~g37 && g2034 && path2602) && ~(~path2776 && g37 && ~g2034 && ~path2602));
assign path2622 = ~(~(~path2776 && ~g37 && g2034 && path2602) && ~(~path2776 && g37 && g2034 && ~path2602) && ~(path2776 && ~g37 && ~g2034 && path2602) && ~(path2776 && ~g37 && g2034 && path2602) && ~(path2776 && g37 && ~g2034 && ~path2602) && ~(path2776 && g37 && g2034 && path2602));
assign path2665 = ~((((VCC && ~path2181 && ~path2733 && ~path2405 && ~path2708) || (~path2508 && ~path2181 && ~path2733 && ~path2405 && ~path2707) || (~path2507 && ~path2181 && ~path2735 && ~path2732 && ~path2708) || (~path1300 && ~path2181 && ~path2735 && ~path2732 && ~path2707) || (~path2335 && ~path2181 && ~path2735 && ~path2405 && ~path2708) || (~path2336 && ~path2181 && ~path2735 && ~path2405 && ~path2707)) && path2404) || (~((VCC && ~path2181 && ~path2733 && ~path2405 && ~path2708) || (~path2508 && ~path2181 && ~path2733 && ~path2405 && ~path2707) || (~path2507 && ~path2181 && ~path2735 && ~path2732 && ~path2708) || (~path1300 && ~path2181 && ~path2735 && ~path2732 && ~path2707) || (~path2335 && ~path2181 && ~path2735 && ~path2405 && ~path2708) || (~path2336 && ~path2181 && ~path2735 && ~path2405 && ~path2707)) && ~path2404));
assign path2692 = ~(~(path2726 && ~g1720) && ~((path2604 || path2605) && g1720));
assign path2709 = ~(~(path2711 && ~g1720) && ~(GND && g1720));
assign path2728 = ~(~((path2216 && path2455 && ~path2675 && g2446) || (path2217 && path2455 && ~path2675 && ~g2446) || (path2427 && ~path2455 && path2675 && g2446) || (path2430 && ~path2455 && path2675 && ~g2446) || (path2480 && ~path2455 && ~path2675 && g2446) || (path2431 && ~path2455 && ~path2675 && ~g2446) || (path2481 && path2455 && path2675 && g2446) || (path2653 && path2455 && path2675 && ~g2446)) || ~(~(r10_ff_a77_d3 || path1329) || g1720) || r10_ff_a77_d0);
assign path2730 = ~(~((path2751 && path2455 && ~path2675 && g2446) || (path2775 && path2455 && ~path2675 && ~g2446) || (path2294 && ~path2455 && path2675 && g2446) || (path2302 && ~path2455 && path2675 && ~g2446) || (path2298 && ~path2455 && ~path2675 && g2446) || (path2301 && ~path2455 && ~path2675 && ~g2446) || (path2237 && path2455 && path2675 && g2446) || (path2679 && path2455 && path2675 && ~g2446)) || ~(~(r10_ff_a77_d3 || path1329) || g1720) || r10_ff_a77_d0);
assign path2744 = ~(~((path2512 && ~path2181 && ~path2735 && ~path2405 && ~path2708) || (g1387 && ~path2181 && ~path2735 && ~path2732 && ~path2707) || (g1994 && ~path2181 && ~path2735 && ~path2732 && ~path2708) || (g2511 && ~path2181 && ~path2733 && ~path2405 && ~path2707) || (g1341 && ~path2181 && ~path2733 && ~path2405 && ~path2708) || (~path2336 && ~path2181 && ~path2733 && ~path2732 && ~path2707) || (~path2335 && ~path2181 && ~path2733 && ~path2732 && ~path2708) || (~path1300 && ~path2734 && ~path2735 && ~path2405 && ~path2707)) && ~((~path2507 && ~path2734 && ~path2735 && ~path2405 && ~path2708) || (~path2508 && ~path2734 && ~path2735 && ~path2732 && ~path2707) || (~path2734 && ~path2735 && ~path2732 && ~path2708)));
assign path2786 = ~(VCC && ~(~path2776 && g37 && ~g2034 && path2602) && ~(~path2776 && g37 && g2034 && path2602) && ~(path2776 && ~g37 && ~g2034 && path2602) && ~(path2776 && ~g37 && g2034 && ~path2602) && ~(path2776 && g37 && ~g2034 && path2602) && ~(path2776 && g37 && g2034 && ~path2602) && ~(path2776 && g37 && g2034 && path2602));

endmodule
