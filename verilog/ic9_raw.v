`timescale 1ns/100ps

module IC9 (
  input wire XTAL_IN,
  output wire SYNCO_OUT,
  input wire SYNC_IN,
  input wire FSYNC_IN,

  input wire [7:0] RAM_D_IN,
  output wire [7:0] RAM_D_OUT,
  output wire RAM_D_IOM,
  output wire [10:0] RAM_A_OUT,
  output wire RAM_OE_OUT,
  output wire RAM_WR_OUT,

  output wire [12:0] ROM_A_OUT,
  input wire [7:0] ROM_D_IN,

  input wire [7:0] BUS_IN,
  
  output wire [16:0] WR_A_OUT,

  output wire IPT1_OUT, // 36
  output wire IPT2_OUT, // 37
  output wire IPT0_OUT  // 38
);

assign VCC = 1;
assign GND = 0;
assign UNK34_IN = 1;

assign RAM_A_OUT = {RAM_A10_OUT, RAM_A9_OUT, RAM_A8_OUT, RAM_A7_OUT, RAM_A6_OUT, RAM_A5_OUT, RAM_A4_OUT, RAM_A3_OUT, RAM_A2_ROM_A0_OUT, RAM_A1_OUT, RAM_A0_OUT};
assign {RAM_D7_IN, RAM_D6_IN, RAM_D5_IN, RAM_D4_IN, RAM_D3_IN, RAM_D2_IN, RAM_D1_IN, RAM_D0_IN} = RAM_D_IN;
assign RAM_D_OUT = {RAM_D7_OUT, RAM_D6_OUT, RAM_D5_OUT, RAM_D4_OUT, RAM_D3_OUT, RAM_D2_OUT, RAM_D1_OUT, RAM_D0_OUT};

assign ROM_A_OUT = {ROM_A12_OUT, ROM_A11_OUT, ROM_A10_OUT, ROM_A9_OUT, ROM_A8_OUT, ROM_A7_OUT, ROM_A6_OUT, ROM_A5_OUT, ROM_A4_OUT, ROM_A3_OUT, ROM_A2_OUT, ROM_A1_OUT, RAM_A2_ROM_A0_OUT};
assign {ROM_D7_IN, ROM_D6_IN, ROM_D5_IN, ROM_D4_IN, ROM_D3_IN, ROM_D2_IN, ROM_D1_IN, ROM_D0_IN} = ROM_D_IN;

assign {BUS7_IN, BUS6_IN, BUS5_IN, BUS4_IN, BUS3_IN, BUS2_IN, BUS1_IN, BUS0_IN} = BUS_IN;

assign WR_A_OUT = {WR_A16_OUT, WR_A15_OUT, WR_A14_OUT, WR_A13_OUT, WR_A12_OUT, WR_A11_OUT, WR_A10_OUT, WR_A9_OUT, WR_A8_OUT, WR_A7_OUT, WR_A6_OUT, WR_A5_OUT, WR_A4_OUT, WR_A3_OUT, WR_A2_OUT, WR_A1_OUT, WR_A0_OUT};



// =============================================================================
// SYNC generator (XTAL/2)

cell_FDO N109 ( // DFF with Reset
  XTAL_IN, // INPUT CK
  path631, // INPUT D
  UNK34_IN, // INPUT R
  SYNCO_OUT, // OUTPUT Q
  path631 // OUTPUT XQ
);



// =============================================================================
// Internal cycle counter

cell_C45 R61 ( // 4-bit Binary Synchronous Up Counter
  GND, // INPUT DA
  VCC, // INPUT EN
  VCC, // INPUT CI
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
  cycle_cnt_d // OUTPUT QD
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
  cycle_sel_7 // OUTPUT X7
);

assign cycle_3 = cycle_sel_3 || SYNC_IN || cycle_cnt_d;
assign cycle_4 = cycle_sel_4 || SYNC_IN || cycle_cnt_d;
assign cycle_5 = cycle_sel_5 || SYNC_IN || cycle_cnt_d;
assign cycle_6 = cycle_sel_6 || SYNC_IN || cycle_cnt_d;
assign cycle_7 = cycle_sel_7 || SYNC_IN || cycle_cnt_d;
assign cycle_9 = cycle_sel_1 || SYNC_IN || ~cycle_cnt_d;

assign cycle_0_xor1 = ~(VCC ^ ~(VCC ^ (cycle_sel_0 || SYNC_IN || cycle_cnt_d)));
assign cycle_0_xor2 = ~(VCC ^ ~(VCC ^ ~(VCC ^ (cycle_sel_0 || SYNC_IN || cycle_cnt_d))));
assign cycle_1_xor1 = ~(VCC ^ ~(VCC ^ (cycle_sel_1 || SYNC_IN || cycle_cnt_d)));
assign cycle_1_xor2 = ~(~VCC ^ ~(VCC ^ ~(VCC ^ (cycle_sel_1 || SYNC_IN || cycle_cnt_d))));
assign cycle_2_xor1 = ~(VCC ^ ~(VCC ^ (cycle_sel_2 || SYNC_IN || cycle_cnt_d)));
assign cycle_2_xor2 = ~(VCC ^ ~(VCC ^ ~(VCC ^ (cycle_sel_2 || SYNC_IN || cycle_cnt_d))));
assign cycle_3_xor = ~(~((cycle_sel_3 || SYNC_IN || cycle_cnt_d) ^ VCC) ^ VCC);
assign cycle_6_xor = ~(~((cycle_sel_6 || SYNC_IN || cycle_cnt_d) ^ VCC) ^ VCC);

assign cycle7_15 = (cycle_sel_7 || SYNC_IN || ~cycle_cnt_d) && (cycle_sel_7 || SYNC_IN || cycle_cnt_d);
assign cycle_7_not = ~(cycle_sel_7 || SYNC_IN || cycle_cnt_d);
assign cycle_15_not = ~(cycle_sel_7 || SYNC_IN || ~cycle_cnt_d);

assign cycle_odd = ~((cycle_sel_1 || SYNC_IN || cycle_cnt_d) && (cycle_sel_3 || SYNC_IN || cycle_cnt_d) && (cycle_sel_5 || SYNC_IN || cycle_cnt_d) && (cycle_sel_7 || SYNC_IN || cycle_cnt_d) && (cycle_sel_1 || SYNC_IN || ~cycle_cnt_d) && (cycle_sel_3 || SYNC_IN || ~cycle_cnt_d) && (cycle_sel_5 || SYNC_IN || ~cycle_cnt_d) && (cycle_sel_7 || SYNC_IN || ~cycle_cnt_d));
assign cycle_between = ~(~((cycle_sel_0 || SYNC_IN || cycle_cnt_d) && (cycle_sel_2 || SYNC_IN || cycle_cnt_d) && (cycle_sel_4 || SYNC_IN || cycle_cnt_d) && (cycle_sel_6 || SYNC_IN || cycle_cnt_d) && (cycle_sel_0 || SYNC_IN || ~cycle_cnt_d) && (cycle_sel_2 || SYNC_IN || ~cycle_cnt_d) && (cycle_sel_4 || SYNC_IN || ~cycle_cnt_d) && (cycle_sel_6 || SYNC_IN || ~cycle_cnt_d)) || ~((cycle_sel_1 || SYNC_IN || cycle_cnt_d) && (cycle_sel_3 || SYNC_IN || cycle_cnt_d) && (cycle_sel_5 || SYNC_IN || cycle_cnt_d) && (cycle_sel_7 || SYNC_IN || cycle_cnt_d) && (cycle_sel_1 || SYNC_IN || ~cycle_cnt_d) && (cycle_sel_3 || SYNC_IN || ~cycle_cnt_d) && (cycle_sel_5 || SYNC_IN || ~cycle_cnt_d) && (cycle_sel_7 || SYNC_IN || ~cycle_cnt_d)));



// =============================================================================
// Register/Part/Voice counter and RAM controller

// Goes over 0-7 two times, first read then write
// 0-3 and 4-7 will read two bytes of the rom
cell_C45 P13 ( // 4-bit Binary Synchronous Up Counter
  VCC, // INPUT DA
  VCC, // INPUT EN
  VCC, // INPUT CI
  FSYNC_IN, // INPUT CL
  VCC, // INPUT DB
  VCC, // INPUT L
  cycle_between, // INPUT CK
  VCC, // INPUT DC
  VCC, // INPUT DD
  RAM_A0_OUT, // OUTPUT QA
  RAM_A1_OUT, // OUTPUT QB
  path22, // OUTPUT CO
  RAM_A2_ROM_A0_OUT, // OUTPUT QC
  RAM_OE_OUT // OUTPUT QD
);
assign r13_overflow = path22 || ~UNK34_IN;
assign cnt_next_part = FSYNC_IN && ~(ram_a6_wr && ram_a3_wr && r13_overflow);
cell_C45 U73 ( // 4-bit Binary Synchronous Up Counter
  GND, // INPUT DA
  r13_overflow, // INPUT EN
  r13_overflow, // INPUT CI
  cnt_next_part, // INPUT CL
  GND, // INPUT DB
  VCC, // INPUT L
  cycle_between, // INPUT CK
  GND, // INPUT DC
  GND, // INPUT DD
  ram_a3_wr, // OUTPUT QA
  ram_a4_wr, // OUTPUT QB
  unconnected_U73_CO, // OUTPUT CO
  ram_a5_wr, // OUTPUT QC
  ram_a6_wr // OUTPUT QD
);
assign cnt_next_voice = ram_a6_wr && ram_a3_wr && r13_overflow;
cell_C45 S66 ( // 4-bit Binary Synchronous Up Counter
  VCC, // INPUT DA
  VCC, // INPUT EN
  cnt_next_voice, // INPUT CI
  FSYNC_IN, // INPUT CL
  GND, // INPUT DB
  VCC, // INPUT L
  cycle_between, // INPUT CK
  GND, // INPUT DC
  GND, // INPUT DD
  ram_a7_wr, // OUTPUT QA
  ram_a8_wr, // OUTPUT QB
  unconnected_S66_CO, // OUTPUT CO
  ram_a9_wr, // OUTPUT QC
  ram_a10_wr // OUTPUT QD
);

// OE is in read mode for cycles 0-7
// At the end of sub cycles (7, 15), the output address gets switched
cell_FDN Q77 ( // DFF with Set
  cycle7_15, // INPUT CK
  RAM_OE_OUT, // INPUT D
  FSYNC_IN, // INPUT S
  ram_addr_mode_read, // OUTPUT Q
  ram_addr_mode_write // OUTPUT XQ
);

// Cycle 15 (end of part): RAM write address becomes read address
cell_FDQ T40 ( // 4-bit DFF
  cycle_15_not, // INPUT CK
  ram_a7_wr, // INPUT DA
  ram_a8_wr, // INPUT DB
  ram_a9_wr, // INPUT DC
  ram_a10_wr, // INPUT DD
  ram_a7_rd, // OUTPUT QA
  ram_a8_rd, // OUTPUT QB
  ram_a9_rd, // OUTPUT QC
  ram_a10_rd // OUTPUT QD
);
cell_FDQ V32 ( // 4-bit DFF
  cycle_15_not, // INPUT CK
  ram_a3_wr, // INPUT DA
  ram_a4_wr, // INPUT DB
  ram_a5_wr, // INPUT DC
  ram_a6_wr, // INPUT DD
  ram_a3_rd, // OUTPUT QA
  ram_a4_rd, // OUTPUT QB
  ram_a5_rd, // OUTPUT QC
  ram_a6_rd // OUTPUT QD
);

// A3 gets && with FSYNC_IN externally
assign RAM_A3_OUT = ~(~(ram_a3_wr && ~ram_addr_mode_write) && ~(ram_a3_rd && ~ram_addr_mode_read)) && FSYNC_IN;
assign RAM_A4_OUT = ~(~(ram_a4_wr && ~ram_addr_mode_write) && ~(ram_a4_rd && ~ram_addr_mode_read));
assign RAM_A5_OUT = ~(~(ram_a5_wr && ~ram_addr_mode_write) && ~(ram_a5_rd && ~ram_addr_mode_read));
assign RAM_A6_OUT = ~(~(ram_a6_wr && ~ram_addr_mode_write) && ~(ram_a6_rd && ~ram_addr_mode_read));
assign RAM_A7_OUT = ~(~(ram_a7_wr && ~ram_addr_mode_write) && ~(ram_a7_rd && ~ram_addr_mode_read));
assign RAM_A8_OUT = ~(~(ram_a8_wr && ~ram_addr_mode_write) && ~(ram_a8_rd && ~ram_addr_mode_read));
assign RAM_A9_OUT = ~(~(ram_a9_wr && ~ram_addr_mode_write) && ~(ram_a9_rd && ~ram_addr_mode_read));
assign RAM_A10_OUT = ~(~(ram_a10_wr && ~ram_addr_mode_write) && ~(ram_a10_rd && ~ram_addr_mode_read));

assign ram_addr_0 = ~RAM_A0_OUT && ~RAM_A1_OUT;
assign ram_addr_1 = RAM_A0_OUT && ~RAM_A1_OUT;
assign ram_addr_2 = ~RAM_A0_OUT && RAM_A1_OUT;

// The result of the multiplier (24 bit) will be stored in RAM
cell_LT4 Q38 ( // 4-bit Data Latch
  cycle_7, // INPUT G
  adder1_o8_and, // INPUT DA
  adder1_o9_and, // INPUT DB
  adder1_o10_and, // INPUT DC
  adder1_o11_and, // INPUT DD
  unconnected_Q38_NA, // OUTPUT NA
  adder1_o8_and_cycle7, // OUTPUT PA
  unconnected_Q38_NB, // OUTPUT NB
  adder1_o9_and_cycle7, // OUTPUT PB
  unconnected_Q38_NC, // OUTPUT NC
  adder1_o10_and_cycle7, // OUTPUT PC
  unconnected_Q38_ND, // OUTPUT ND
  adder1_o11_and_cycle7 // OUTPUT PD
);
cell_LT4 Q20 ( // 4-bit Data Latch
  cycle_7, // INPUT G
  adder1_o12_and, // INPUT DA
  adder1_o13_and, // INPUT DB
  adder1_o14_and, // INPUT DC
  adder1_o15_and, // INPUT DD
  unconnected_Q20_NA, // OUTPUT NA
  adder1_o12_and_cycle7, // OUTPUT PA
  unconnected_Q20_NB, // OUTPUT NB
  adder1_o13_and_cycle7, // OUTPUT PB
  unconnected_Q20_NC, // OUTPUT NC
  adder1_o14_and_cycle7, // OUTPUT PC
  unconnected_Q20_ND, // OUTPUT ND
  adder1_o15_and_cycle7 // OUTPUT PD
);
cell_LT4 M61 ( // 4-bit Data Latch
  cycle_7, // INPUT G
  adder1_o16_and, // INPUT DA
  adder1_o17_and, // INPUT DB
  adder1_o18_and, // INPUT DC
  adder1_o19_and, // INPUT DD
  unconnected_M61_NA, // OUTPUT NA
  adder1_o16_and_cycle7, // OUTPUT PA
  unconnected_M61_NB, // OUTPUT NB
  adder1_o17_and_cycle7, // OUTPUT PB
  unconnected_M61_NC, // OUTPUT NC
  adder1_o18_and_cycle7, // OUTPUT PC
  unconnected_M61_ND, // OUTPUT ND
  adder1_o19_and_cycle7 // OUTPUT PD
);
cell_LT4 G18 ( // 4-bit Data Latch
  cycle_7, // INPUT G
  adder1_o20_and, // INPUT DA
  adder1_o21_and, // INPUT DB
  adder1_o22_and, // INPUT DC
  adder1_o23_and, // INPUT DD
  unconnected_G18_NA, // OUTPUT NA
  adder1_o20_and_cycle7, // OUTPUT PA
  unconnected_G18_NB, // OUTPUT NB
  adder1_o21_and_cycle7, // OUTPUT PB
  unconnected_G18_NC, // OUTPUT NC
  adder1_o22_and_cycle7, // OUTPUT PC
  unconnected_G18_ND, // OUTPUT ND
  adder1_o23_and_cycle7 // OUTPUT PD
);
assign RAM_D0_OUT = ~(adder1_o0_and_oddcycle && ram_addr_0) && ~(adder1_o8_and_cycle7 && ram_addr_1) && ~(adder1_o16_and_cycle7 && ram_addr_2);
assign RAM_D1_OUT = ~(~(adder1_o1_and_oddcycle && ram_addr_0) && ~(adder1_o9_and_cycle7 && ram_addr_1) && ~(adder1_o17_and_cycle7 && ram_addr_2));
assign RAM_D2_OUT = ~(~(adder1_o2_and_oddcycle && ram_addr_0) && ~(adder1_o10_and_cycle7 && ram_addr_1) && ~(adder1_o18_and_cycle7 && ram_addr_2));
assign RAM_D3_OUT = ~(adder1_o3_and_oddcycle && ram_addr_0) && ~(adder1_o11_and_cycle7 && ram_addr_1) && ~(adder1_o19_and_cycle7 && ram_addr_2);
assign RAM_D4_OUT = ~(adder1_o4_and_oddcycle && ram_addr_0) && ~(adder1_o12_and_cycle7 && ram_addr_1) && ~(adder1_o20_and_cycle7 && ram_addr_2);
assign RAM_D5_OUT = ~(~(adder1_o5_and_oddcycle && ram_addr_0) && ~(adder1_o13_and_cycle7 && ram_addr_1) && ~(adder1_o21_and_cycle7 && ram_addr_2));
assign RAM_D6_OUT = ~(~(adder1_o6_and_oddcycle && ram_addr_0) && ~(adder1_o14_and_cycle7 && ram_addr_1) && ~(adder1_o22_and_cycle7 && ram_addr_2));
assign RAM_D7_OUT = ~(~(adder1_o7_and_oddcycle && ram_addr_0) && ~(adder1_o15_and_cycle7 && ram_addr_1) && ~(adder1_o23_and_cycle7 && ram_addr_2));

// Cycles 8/9/10/11 (addresses 0/1/2/3)
assign RAM_D_IOM = UNK34_IN && ~(~RAM_A2_ROM_A0_OUT && RAM_OE_OUT);

// Cycles 8/9/10/12/13/14/15 (addresses 0/1/2/4/5/6/7)
// Data from 12/13/14/15 comes from IC19 (addresses 4/5/6/7)
assign RAM_WR_OUT = (cycle_sel_0 || SYNC_IN || ~cycle_cnt_d) && (cycle_sel_1 || SYNC_IN || ~cycle_cnt_d) && (cycle_sel_2 || SYNC_IN || ~cycle_cnt_d) && (cycle_sel_4 || SYNC_IN || ~cycle_cnt_d) && (cycle_sel_5 || SYNC_IN || ~cycle_cnt_d) && (cycle_sel_6 || SYNC_IN || ~cycle_cnt_d) && (cycle_sel_7 || SYNC_IN || ~cycle_cnt_d) && VCC;



// =============================================================================
// ROM Control

// ADDRESSES
//

// IC12[0](0-3) => ROM_A(9-12)
cell_LT4 A107 ( // 4-bit Data Latch
  cycle_0_xor1, // INPUT G
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
  ROM_A12_OUT // OUTPUT PD
);

// IC12[1](0-7) => ROM_A(1-8)
cell_LT4 A76 ( // 4-bit Data Latch
  cycle_1_xor1, // INPUT G
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
  ROM_A8_OUT // OUTPUT PD
);
cell_LT4 A94 ( // 4-bit Data Latch
  cycle_1_xor1, // INPUT G
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
  ROM_A4_OUT // OUTPUT PD
);
// A0 of the rom is controlled with the RAM address 0-3 (0) and 4-7 (1)


// DATA
//

// LSB
cell_LT4 D108 ( // 4-bit Data Latch
  cycle_3, // INPUT G
  ROM_D4_IN, // INPUT DA
  ROM_D5_IN, // INPUT DB
  ROM_D6_IN, // INPUT DC
  ROM_D7_IN, // INPUT DD
  unconnected_D108_NA, // OUTPUT NA
  rom_d4_lsb, // OUTPUT PA
  rom_d5_not_lsb, // OUTPUT NB
  unconnected_D108_PB, // OUTPUT PB
  rom_d6_not_lsb, // OUTPUT NC
  unconnected_D108_PC, // OUTPUT PC
  rom_d7_not_lsb, // OUTPUT ND
  unconnected_D108_PD // OUTPUT PD
);
cell_LT4 E108 ( // 4-bit Data Latch
  cycle_3, // INPUT G
  ROM_D0_IN, // INPUT DA
  ROM_D1_IN, // INPUT DB
  ROM_D2_IN, // INPUT DC
  ROM_D3_IN, // INPUT DD
  unconnected_E108_NA, // OUTPUT NA
  rom_d0_lsb, // OUTPUT PA
  unconnected_E108_NB, // OUTPUT NB
  rom_d1_lsb, // OUTPUT PB
  unconnected_E108_NC, // OUTPUT NC
  rom_d2_lsb, // OUTPUT PC
  unconnected_E108_ND, // OUTPUT ND
  rom_d3_lsb // OUTPUT PD
);

// MSB
cell_LT4 E90 ( // 4-bit Data Latch
  cycle_5, // INPUT G
  ROM_D0_IN, // INPUT DA
  ROM_D1_IN, // INPUT DB
  ROM_D2_IN, // INPUT DC
  ROM_D3_IN, // INPUT DD
  rom_d0_not_msb, // OUTPUT NA
  unconnected_E90_PA, // OUTPUT PA
  rom_d1_not_msb, // OUTPUT NB
  unconnected_E90_PB, // OUTPUT PB
  rom_d2_not_msb, // OUTPUT NC
  unconnected_E90_PC, // OUTPUT PC
  rom_d3_not_msb, // OUTPUT ND
  unconnected_E90_PD // OUTPUT PD
);
cell_LT2 E103 ( // 1-bit Data Latch
  cycle_5, // INPUT G
  ROM_D4_IN, // INPUT D
  unconnected_E103_Q, // OUTPUT Q
  rom_d4_not_msb // OUTPUT XQ
);



// =============================================================================
// Reads from RIC13 RAM

cell_LT4 F20 ( // 4-bit Data Latch
  cycle_0_xor2, // INPUT G
  ~RAM_D0_IN, // INPUT DA
  RAM_D1_IN, // INPUT DB
  RAM_D2_IN, // INPUT DC
  ~RAM_D3_IN, // INPUT DD
  unconnected_F20_NA, // OUTPUT NA
  ram_d0_not_cycle0, // OUTPUT PA
  unconnected_F20_NB, // OUTPUT NB
  ram_d1_cycle0, // OUTPUT PB
  unconnected_F20_NC, // OUTPUT NC
  ram_d2_cycle0, // OUTPUT PC
  unconnected_F20_ND, // OUTPUT ND
  ram_d3_not_cycle0 // OUTPUT PD
);
cell_LT4 H20 ( // 4-bit Data Latch
  cycle_0_xor2, // INPUT G
  ~RAM_D4_IN, // INPUT DA
  RAM_D5_IN, // INPUT DB
  RAM_D6_IN, // INPUT DC
  RAM_D7_IN, // INPUT DD
  unconnected_H20_NA, // OUTPUT NA
  ram_d4_not_cycle0, // OUTPUT PA
  unconnected_H20_NB, // OUTPUT NB
  ram_d5_cycle0, // OUTPUT PB
  unconnected_H20_NC, // OUTPUT NC
  ram_d6_cycle0, // OUTPUT PC
  unconnected_H20_ND, // OUTPUT ND
  ram_d7_cycle0 // OUTPUT PD
);

cell_LT4 F4 ( // 4-bit Data Latch
  cycle_1_xor2, // INPUT G
  ~RAM_D0_IN, // INPUT DA
  RAM_D1_IN, // INPUT DB
  RAM_D2_IN, // INPUT DC
  ~RAM_D3_IN, // INPUT DD
  unconnected_F4_NA, // OUTPUT NA
  ram_d0_not_cycle1, // OUTPUT PA
  unconnected_F4_NB, // OUTPUT NB
  ram_d1_cycle1, // OUTPUT PB
  unconnected_F4_NC, // OUTPUT NC
  ram_d2_cycle1, // OUTPUT PC
  unconnected_F4_ND, // OUTPUT ND
  ram_d3_not_cycle1 // OUTPUT PD
);
cell_LT4 H3 ( // 4-bit Data Latch
  cycle_1_xor2, // INPUT G
  ~RAM_D4_IN, // INPUT DA
  RAM_D5_IN, // INPUT DB
  RAM_D6_IN, // INPUT DC
  RAM_D7_IN, // INPUT DD
  unconnected_H3_NA, // OUTPUT NA
  ram_d4_not_cycle1, // OUTPUT PA
  unconnected_H3_NB, // OUTPUT NB
  ram_d5_cycle1, // OUTPUT PB
  unconnected_H3_NC, // OUTPUT NC
  ram_d6_cycle1, // OUTPUT PC
  unconnected_H3_ND, // OUTPUT ND
  ram_d7_cycle1 // OUTPUT PD
);

cell_LT4 F36 ( // 4-bit Data Latch
  cycle_2_xor2, // INPUT G
  ~RAM_D0_IN, // INPUT DA
  RAM_D1_IN, // INPUT DB
  RAM_D2_IN, // INPUT DC
  ~RAM_D3_IN, // INPUT DD
  unconnected_F36_NA, // OUTPUT NA
  ram_d0_not_cycle2, // OUTPUT PA
  unconnected_F36_NB, // OUTPUT NB
  ram_d1_cycle2, // OUTPUT PB
  unconnected_F36_NC, // OUTPUT NC
  ram_d2_cycle2, // OUTPUT PC
  unconnected_F36_ND, // OUTPUT ND
  ram_d3_not_cycle2 // OUTPUT PD
);
cell_LT4 H34 ( // 4-bit Data Latch
  cycle_2_xor2, // INPUT G
  ~RAM_D4_IN, // INPUT DA
  RAM_D5_IN, // INPUT DB
  RAM_D6_IN, // INPUT DC
  RAM_D7_IN, // INPUT DD
  unconnected_H34_NA, // OUTPUT NA
  ram_d4_not_cycle2, // OUTPUT PA
  unconnected_H34_NB, // OUTPUT NB
  ram_d5_cycle2, // OUTPUT PB
  unconnected_H34_NC, // OUTPUT NC
  ram_d6_cycle2, // OUTPUT PC
  unconnected_H34_ND, // OUTPUT ND
  ram_d7_cycle2 // OUTPUT PD
);



// =============================================================================
// Reads from RIC12 RAM

cell_LT4 A61 ( // 4-bit Data Latch
  cycle_0_xor1, // INPUT G
  BUS4_IN, // INPUT DA
  BUS5_IN, // INPUT DB
  BUS6_IN, // INPUT DC
  BUS7_IN, // INPUT DD
  unconnected_A61_NA, // OUTPUT NA
  bus4_cycle0, // OUTPUT PA
  unconnected_A61_NB, // OUTPUT NB
  bus5_cycle0, // OUTPUT PB
  unconnected_A61_NC, // OUTPUT NC
  bus6_cycle0, // OUTPUT PC
  unconnected_A61_ND, // OUTPUT ND
  bus7_cycle0 // OUTPUT PD
);

cell_LT4 B61 ( // 4-bit Data Latch
  cycle_2_xor1, // INPUT G
  BUS0_IN, // INPUT DA
  BUS1_IN, // INPUT DB
  BUS2_IN, // INPUT DC
  BUS3_IN, // INPUT DD
  bus0_not_cycle2, // OUTPUT NA
  unconnected_B61_PA, // OUTPUT PA
  bus1_not_cycle2, // OUTPUT NB
  unconnected_B61_PB, // OUTPUT PB
  bus2_not_cycle2, // OUTPUT NC
  unconnected_B61_PC, // OUTPUT PC
  bus3_not_cycle2, // OUTPUT ND
  unconnected_B61_PD // OUTPUT PD
);
cell_LT4 B74 ( // 4-bit Data Latch
  cycle_2_xor1, // INPUT G
  BUS4_IN, // INPUT DA
  BUS5_IN, // INPUT DB
  BUS6_IN, // INPUT DC
  BUS7_IN, // INPUT DD
  bus4_not_cycle2, // OUTPUT NA
  unconnected_B74_PA, // OUTPUT PA
  bus5_not_cycle2, // OUTPUT NB
  unconnected_B74_PB, // OUTPUT PB
  bus6_not_cycle2, // OUTPUT NC
  unconnected_B74_PC, // OUTPUT PC
  bus7_not_cycle2, // OUTPUT ND
  unconnected_B74_PD // OUTPUT PD
);

cell_LT4 B87 ( // 4-bit Data Latch
  cycle_3_xor, // INPUT G
  BUS0_IN, // INPUT DA
  BUS1_IN, // INPUT DB
  BUS2_IN, // INPUT DC
  BUS3_IN, // INPUT DD
  unconnected_B87_NA, // OUTPUT NA
  bus0_cycle3, // OUTPUT PA
  unconnected_B87_NB, // OUTPUT NB
  bus1_cycle3, // OUTPUT PB
  unconnected_B87_NC, // OUTPUT NC
  bus2_cycle3, // OUTPUT PC
  unconnected_B87_ND, // OUTPUT ND
  bus3_cycle3 // OUTPUT PD
);
cell_LT2 A89 ( // 1-bit Data Latch
  cycle_3_xor, // INPUT G
  BUS4_IN, // INPUT D
  bus4_cycle3, // OUTPUT Q
  unconnected_A89_XQ // OUTPUT XQ
);
cell_LT2 C63 ( // 1-bit Data Latch
  cycle_3_xor, // INPUT G
  BUS5_IN, // INPUT D
  bus5_cycle3, // OUTPUT Q
  unconnected_C63_XQ // OUTPUT XQ
);

cell_LT2 C91 ( // 1-bit Data Latch
  cycle_6_xor, // INPUT G
  BUS1_IN, // INPUT D
  bus1_cycle6, // OUTPUT Q
  unconnected_C91_XQ // OUTPUT XQ
);



// =============================================================================
// Temp registers

// Cycle 7
cell_FDQ B100 ( // 4-bit DFF
  cycle_7_not, // INPUT CK
  bus4_cycle0, // INPUT DA
  bus5_cycle0, // INPUT DB
  bus6_cycle0, // INPUT DC
  bus7_cycle0, // INPUT DD
  bus4_cycle0_7, // OUTPUT QA
  bus5_cycle0_7, // OUTPUT QB
  bus6_cycle0_7, // OUTPUT QC
  bus7_cycle0_7 // OUTPUT QD
);
cell_FDQ C67 ( // 4-bit DFF
  cycle_7_not, // INPUT CK
  bus4_not_cycle2, // INPUT DA
  bus5_not_cycle2, // INPUT DB
  bus6_not_cycle2, // INPUT DC
  bus7_not_cycle2, // INPUT DD
  bus4_not_cycle2_7, // OUTPUT QA
  bus5_not_cycle2_7, // OUTPUT QB
  bus6_not_cycle2_7, // OUTPUT QC
  bus7_not_cycle2_7 // OUTPUT QD
);
cell_FDQ C100 ( // 4-bit DFF
  cycle_7_not, // INPUT CK
  bus0_not_cycle2, // INPUT DA
  bus1_not_cycle2, // INPUT DB
  bus2_not_cycle2, // INPUT DC
  bus3_not_cycle2, // INPUT DD
  bus0_not_cycle2_7, // OUTPUT QA
  bus1_not_cycle2_7, // OUTPUT QB
  bus2_not_cycle2_7, // OUTPUT QC
  bus3_not_cycle2_7 // OUTPUT QD
);
cell_FDQ D61 ( // 4-bit DFF
  cycle_7_not, // INPUT CK
  rom_d0_lsb, // INPUT DA
  rom_d1_lsb, // INPUT DB
  rom_d2_lsb, // INPUT DC
  rom_d3_lsb, // INPUT DD
  rom_d0_lsb_7, // OUTPUT QA
  rom_d1_lsb_7, // OUTPUT QB
  rom_d2_lsb_7, // OUTPUT QC
  rom_d3_lsb_7 // OUTPUT QD
);
cell_FDQ D87 ( // 4-bit DFF
  cycle_7_not, // INPUT CK
  rom_d4_lsb, // INPUT DA
  rom_d5_not_lsb, // INPUT DB
  rom_d6_not_lsb, // INPUT DC
  rom_d7_not_lsb, // INPUT DD
  rom_d4_cycle3_7, // OUTPUT QA
  rom_d5_not_lsb_7, // OUTPUT QB
  rom_d6_not_lsb_7, // OUTPUT QC
  rom_d7_not_lsb_7 // OUTPUT QD
);
cell_FDQ E61 ( // 4-bit DFF
  cycle_7_not, // INPUT CK
  rom_d0_not_msb, // INPUT DA
  rom_d1_not_msb, // INPUT DB
  rom_d2_not_msb, // INPUT DC
  rom_d3_not_msb, // INPUT DD
  rom_d0_not_msb_7, // OUTPUT QA
  rom_d1_not_msb_7, // OUTPUT QB
  rom_d2_not_msb_7, // OUTPUT QC
  rom_d3_not_msb_7 // OUTPUT QD
);
cell_FDM K84 ( // DFF
  cycle_7, // INPUT CK
  rom_d4_not_msb, // INPUT D
  unconnected_K84_XQ, // OUTPUT XQ
  rom_d4_not_msb_7 // OUTPUT Q
);
cell_FDM L91 ( // DFF
  cycle_7, // INPUT CK
  bus1_cycle6, // INPUT D
  bus1_cycle6_cycle7, // OUTPUT XQ
  unconnected_L91_Q // OUTPUT Q
);


// =============================================================================
// Multiplier?

assign mult_enable = ~bus1_cycle6_cycle7;

assign mult_ina_a = bus4_cycle0_7;
assign mult_ina_b = bus5_cycle0_7;
assign mult_ina_c = bus6_cycle0_7;
assign mult_ina_d = bus7_cycle0_7;

assign mult_ina_k = rom_d0_lsb_7; // 0
assign mult_ina_j = rom_d1_lsb_7; // 1
assign mult_ina_i = rom_d2_lsb_7; // 2
assign mult_ina_h = rom_d3_lsb_7; // 3
assign mult_ina_g = rom_d4_cycle3_7; // 4
assign mult_ina_f = rom_d5_not_lsb_7; // 5
assign mult_ina_e = rom_d6_not_lsb_7; // 6
assign mult_ina_l = rom_d7_not_lsb_7; // 7
assign mult_ina_m = rom_d0_not_msb_7; // 8
assign mult_ina_n = rom_d1_not_msb_7; // 9
assign mult_ina_o = rom_d2_not_msb_7; // 10
assign mult_ina_p = rom_d3_not_msb_7; // 11
assign mult_ina_q = rom_d4_not_msb_7; // 12

assign mult_inb_0 = ram_d0_not_cycle0;
assign mult_inb_1 = ram_d1_cycle0;
assign mult_inb_2 = ram_d2_cycle0;
assign mult_inb_3 = ram_d3_not_cycle0;
assign mult_inb_4 = ram_d4_not_cycle0;
assign mult_inb_5 = ram_d5_cycle0;
assign mult_inb_6 = ram_d6_cycle0;
assign mult_inb_7 = ram_d7_cycle0;
assign mult_inb_8 = ram_d0_not_cycle1;
assign mult_inb_9 = ram_d1_cycle1;
assign mult_inb_10 = ram_d2_cycle1;
assign mult_inb_11 = ram_d3_not_cycle1;
assign mult_inb_12 = ram_d4_not_cycle1;
assign mult_inb_13 = ram_d5_cycle1;
assign mult_inb_14 = ram_d6_cycle1;
assign mult_inb_15 = ram_d7_cycle1;
assign mult_inb_16 = ram_d0_not_cycle2;
assign mult_inb_17 = ram_d1_cycle2;
assign mult_inb_18 = ram_d2_cycle2;
assign mult_inb_19 = ram_d3_not_cycle2;
assign mult_inb_20 = ram_d4_not_cycle2;
assign mult_inb_21 = ram_d5_cycle2;
assign mult_inb_22 = ram_d6_cycle2;
assign mult_inb_23 = ram_d7_cycle2;

cell_FDN N64 ( // DFF with Set
  cycle_7, // INPUT CK
  RAM_OE_OUT, // INPUT D
  cycle_4, // INPUT S
  ram_oe_cycle7, // OUTPUT Q
  ram_oe_cycle7_not // OUTPUT XQ
);
cell_FDO N83 ( // DFF with Reset
  cycle_9, // INPUT CK
  RAM_OE_OUT, // INPUT D
  cycle_6, // INPUT R
  ram_oe_cycle9, // OUTPUT Q
  ram_oe_cycle9_not // OUTPUT XQ
);
assign mult_select = ram_oe_cycle7 || ram_oe_cycle9;


// Adder in A
assign adder1_a0 = (~mult_ina_e && ~mult_ina_a && ~mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_f && mult_ina_a && ~mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (mult_ina_g && ~mult_ina_a && mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (mult_ina_h && mult_ina_a && mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (mult_ina_i && ~mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (mult_ina_j && mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (mult_ina_k && ~mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d) || (mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d && mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d);
assign adder1_a1 = (~mult_ina_l && ~mult_ina_a && ~mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_e && mult_ina_a && ~mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_f && ~mult_ina_a && mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (mult_ina_g && mult_ina_a && mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (mult_ina_h && ~mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (mult_ina_i && mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (mult_ina_j && ~mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d) || (mult_ina_k && mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d);
assign adder1_a2 = ~(~((~mult_ina_m && ~mult_ina_a && ~mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_l && mult_ina_a && ~mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_e && ~mult_ina_a && mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_f && mult_ina_a && mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (mult_ina_g && ~mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (mult_ina_h && mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (mult_ina_i && ~mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d) || (mult_ina_j && mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d)) && ~(mult_ina_k && ~mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d));
assign adder1_a3 = ~(~((~mult_ina_n && ~mult_ina_a && ~mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_m && mult_ina_a && ~mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_l && ~mult_ina_a && mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_e && mult_ina_a && mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_f && ~mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (mult_ina_g && mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (mult_ina_h && ~mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d) || (mult_ina_i && mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d)) && ~((mult_ina_j && ~mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) || (mult_ina_k && mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d)));
assign adder1_a4 = ~(~((~mult_ina_o && ~mult_ina_a && ~mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_n && mult_ina_a && ~mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_m && ~mult_ina_a && mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_l && mult_ina_a && mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_e && ~mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_f && mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (mult_ina_g && ~mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d) || (mult_ina_h && mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d)) && ~((mult_ina_i && ~mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) || (mult_ina_j && mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) || (mult_ina_k && ~mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d) || (GND && mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d)));
assign adder1_a5 = ~(~((~mult_ina_p && ~mult_ina_a && ~mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_o && mult_ina_a && ~mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_n && ~mult_ina_a && mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_m && mult_ina_a && mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_l && ~mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_e && mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_f && ~mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d) || (mult_ina_g && mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d)) && ~((mult_ina_h && ~mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) || (mult_ina_i && mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) || (mult_ina_j && ~mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d) || (mult_ina_k && mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d)));
assign adder1_a6 = ~(~((~mult_ina_q && ~mult_ina_a && ~mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_p && mult_ina_a && ~mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_o && ~mult_ina_a && mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_n && mult_ina_a && mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_m && ~mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_l && mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_e && ~mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_f && mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d)) && ~((mult_ina_g && ~mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) || (mult_ina_h && mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) || (mult_ina_i && ~mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d) || (mult_ina_j && mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d)));
assign adder1_a7 = ~(~((VCC && ~mult_ina_a && ~mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_q && mult_ina_a && ~mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_p && ~mult_ina_a && mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_o && mult_ina_a && mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_n && ~mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_m && mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_l && ~mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_e && mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d)) && ~((~mult_ina_f && ~mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) || (mult_ina_g && mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) || (mult_ina_h && ~mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d) || (mult_ina_i && mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d)));
assign adder1_a8 = ~(~((GND && ~mult_ina_a && ~mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (VCC && mult_ina_a && ~mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_q && ~mult_ina_a && mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_p && mult_ina_a && mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_o && ~mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_n && mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_m && ~mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_l && mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d)) && ~((~mult_ina_e && ~mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) || (~mult_ina_f && mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) || (mult_ina_g && ~mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d) || (mult_ina_h && mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d)));
assign adder1_a9 = ~(~((VCC && ~mult_ina_a && mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_q && mult_ina_a && mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_p && ~mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_o && mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_n && ~mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_m && mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_l && ~mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) || (~mult_ina_e && mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d)) && ~((~mult_ina_f && ~mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d) || (mult_ina_g && mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d)));
assign adder1_a10 = ~(~((VCC && mult_ina_a && mult_ina_b && ~mult_ina_c && ~mult_ina_d) || (~mult_ina_q && ~mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_p && mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_o && ~mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_n && mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_m && ~mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) || (~mult_ina_l && mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) || (~mult_ina_e && ~mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d)) && ~(~mult_ina_f && mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d));
assign adder1_a11 = (VCC && ~mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_q && mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_p && ~mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_o && mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_n && ~mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) || (~mult_ina_m && mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) || (~mult_ina_l && ~mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d) || (~mult_ina_e && mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d);
assign adder1_a12 = (GND && ~mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (VCC && mult_ina_a && ~mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_q && ~mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_p && mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_o && ~mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) || (~mult_ina_n && mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) || (~mult_ina_m && ~mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d) || (~mult_ina_l && mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d);
assign adder1_a13 = (VCC && ~mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_q && mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d) || (~mult_ina_p && ~mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) || (~mult_ina_o && mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) || (~mult_ina_n && ~mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d) || (~mult_ina_m && mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d);
assign adder1_a14 = ~(VCC && ~(VCC && mult_ina_a && mult_ina_b && mult_ina_c && ~mult_ina_d) && ~(~mult_ina_q && ~mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) && ~(~mult_ina_p && mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) && ~(~mult_ina_o && ~mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d) && ~(~mult_ina_n && mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d));
assign adder1_a15 = ~(~(~mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) && ~(~mult_ina_q && mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) && ~(~mult_ina_p && ~mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d) && ~(~mult_ina_o && mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d));
assign adder1_a16 = ~(~(mult_ina_a && ~mult_ina_b && ~mult_ina_c && mult_ina_d) && ~(~mult_ina_q && ~mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d) && ~(~mult_ina_p && mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d));
assign adder1_a17 = ~(~(~mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d) && ~(~mult_ina_q && mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d));
assign adder1_a18 = mult_ina_a && mult_ina_b && ~mult_ina_c && mult_ina_d;


// Adder in B
assign adder1_b0 = (adder1_o0_and_oddcycle && mult_select) || (mult_inb_0 && ~mult_select);
assign adder1_b1 = (adder1_o1_and_oddcycle && mult_select) || (mult_inb_1 && ~mult_select);
assign adder1_b2 = (adder1_o2_and_oddcycle && mult_select) || (mult_inb_2 && ~mult_select);
assign adder1_b3 = (adder1_o3_and_oddcycle && mult_select) || (mult_inb_3 && ~mult_select);
assign adder1_b4 = (adder1_o4_and_oddcycle && mult_select) || (mult_inb_4 && ~mult_select);
assign adder1_b5 = (adder1_o5_and_oddcycle && mult_select) || (mult_inb_5 && ~mult_select);
assign adder1_b6 = (adder1_o6_and_oddcycle && mult_select) || (mult_inb_6 && ~mult_select);
assign adder1_b7 = (adder1_o7_and_oddcycle && mult_select) || (mult_inb_7 && ~mult_select);
assign adder1_b8 = (adder1_o8_and_oddcycle && mult_select) || (mult_inb_8 && ~mult_select);
assign adder1_b9 = (adder1_o9_and_oddcycle && mult_select) || (mult_inb_9 && ~mult_select);
assign adder1_b10 = (adder1_o10_and_oddcycle && mult_select) || (mult_inb_10 && ~mult_select);
assign adder1_b11 = (adder1_o11_and_oddcycle && mult_select) || (mult_inb_11 && ~mult_select);
assign adder1_b12 = (adder1_o12_and_oddcycle && mult_select) || (mult_inb_12 && ~mult_select);
assign adder1_b13 = (adder1_o13_and_oddcycle && mult_select) || (mult_inb_13 && ~mult_select);
assign adder1_b14 = (adder1_o14_and_oddcycle && mult_select) || (mult_inb_14 && ~mult_select);
assign adder1_b15 = (adder1_o15_and_oddcycle && mult_select) || (mult_inb_15 && ~mult_select);

assign adder1_b16 = (adder1_o16_and_oddcycle && mult_select) || (mult_inb_16 && ~mult_select);
assign adder1_b17 = (adder1_o17_and_oddcycle && mult_select) || (mult_inb_17 && ~mult_select);
assign adder1_b18 = (adder1_o18_and_oddcycle && mult_select) || (mult_inb_18 && ~mult_select);
assign adder1_b19 = (adder1_o19_and_oddcycle && mult_select) || (mult_inb_19 && ~mult_select);
assign adder1_b20 = (adder1_o20_and_oddcycle && mult_select) || (mult_inb_20 && ~mult_select);
assign adder1_b21 = (adder1_o21_and_oddcycle && mult_select) || (mult_inb_21 && ~mult_select);
assign adder1_b22 = (adder1_o22_and_oddcycle && mult_select) || (mult_inb_22 && ~mult_select);
assign adder1_b23 = (adder1_o23_and_oddcycle && mult_select) || (mult_inb_23 && ~mult_select);


// Adder 1 (24 bit)
cell_A4H N11 ( // 4-bit Full Adder
  adder1_a3, // INPUT A4
  adder1_b3, // INPUT B4
  adder1_a2, // INPUT A3
  adder1_b2, // INPUT B3
  adder1_a1, // INPUT A2
  adder1_b1, // INPUT B2
  adder1_a0, // INPUT A1
  adder1_b0, // INPUT B1
  GND, // INPUT CI
  path656, // OUTPUT CO
  adder1_o3, // OUTPUT S4
  adder1_o2, // OUTPUT S3
  adder1_o1, // OUTPUT S2
  adder1_o0 // OUTPUT S1
);
cell_A4H I7 ( // 4-bit Full Adder
  adder1_a7, // INPUT A4
  adder1_b7, // INPUT B4
  adder1_a6, // INPUT A3
  adder1_b6, // INPUT B3
  adder1_a5, // INPUT A2
  adder1_b5, // INPUT B2
  adder1_a4, // INPUT A1
  adder1_b4, // INPUT B1
  path656, // INPUT CI
  g1031, // OUTPUT CO
  adder1_o7, // OUTPUT S4
  adder1_o6, // OUTPUT S3
  adder1_o5, // OUTPUT S2
  adder1_o4 // OUTPUT S1
);
cell_A4H S3 ( // 4-bit Full Adder
  adder1_a11, // INPUT A4
  adder1_b11, // INPUT B4
  adder1_a10, // INPUT A3
  adder1_b10, // INPUT B3
  adder1_a9, // INPUT A2
  adder1_b9, // INPUT B2
  adder1_a8, // INPUT A1
  adder1_b8, // INPUT B1
  g1031, // INPUT CI
  path181, // OUTPUT CO
  adder1_o11, // OUTPUT S4
  adder1_o10, // OUTPUT S3
  adder1_o9, // OUTPUT S2
  adder1_o8 // OUTPUT S1
);
cell_A4H U1 ( // 4-bit Full Adder
  adder1_a15, // INPUT A4
  adder1_b15, // INPUT B4
  adder1_a14, // INPUT A3
  adder1_b14, // INPUT B3
  adder1_a13, // INPUT A2
  adder1_b13, // INPUT B2
  adder1_a12, // INPUT A1
  adder1_b12, // INPUT B1
  path181, // INPUT CI
  path574, // OUTPUT CO
  adder1_o15, // OUTPUT S4
  adder1_o14, // OUTPUT S3
  adder1_o13, // OUTPUT S2
  adder1_o12 // OUTPUT S1
);
cell_A4H P68 ( // 4-bit Full Adder
  GND, // INPUT A4
  adder1_b19, // INPUT B4
  adder1_a18, // INPUT A3
  adder1_b18, // INPUT B3
  adder1_a17, // INPUT A2
  adder1_b17, // INPUT B2
  adder1_a16, // INPUT A1
  adder1_b16, // INPUT B1
  path574, // INPUT CI
  path138, // OUTPUT CO
  adder1_o19, // OUTPUT S4
  adder1_o18, // OUTPUT S3
  adder1_o17, // OUTPUT S2
  adder1_o16 // OUTPUT S1
);
cell_A4H H69 ( // 4-bit Full Adder
  GND, // INPUT A4
  adder1_b23, // INPUT B4
  GND, // INPUT A3
  adder1_b22, // INPUT B3
  GND, // INPUT A2
  adder1_b21, // INPUT B2
  GND, // INPUT A1
  adder1_b20, // INPUT B1
  path138, // INPUT CI
  unconnected_H69_CO, // OUTPUT CO
  adder1_o23, // OUTPUT S4
  adder1_o22, // OUTPUT S3
  adder1_o21, // OUTPUT S2
  adder1_o20 // OUTPUT S1
);

assign adder1_o0_and = adder1_o0 && mult_enable;
assign adder1_o1_and = adder1_o1 && mult_enable;
assign adder1_o2_and = adder1_o2 && mult_enable;
assign adder1_o3_and = adder1_o3 && mult_enable;
assign adder1_o4_and = adder1_o4 && mult_enable;
assign adder1_o5_and = adder1_o5 && mult_enable;
assign adder1_o6_and = adder1_o6 && mult_enable;
assign adder1_o7_and = adder1_o7 && mult_enable;
assign adder1_o8_and = adder1_o8 && mult_enable;
assign adder1_o9_and = adder1_o9 && mult_enable;
assign adder1_o10_and = adder1_o10 && mult_enable;
assign adder1_o11_and = adder1_o11 && mult_enable;
assign adder1_o12_and = adder1_o12 && mult_enable;
assign adder1_o13_and = adder1_o13 && mult_enable;
assign adder1_o14_and = adder1_o14 && mult_enable;
assign adder1_o15_and = adder1_o15 && mult_enable;

cell_FDQ O4 ( // 4-bit DFF
  cycle_odd, // INPUT CK
  adder1_o3_and, // INPUT DA
  adder1_o2_and, // INPUT DB
  adder1_o1_and, // INPUT DC
  adder1_o0_and, // INPUT DD
  adder1_o3_and_oddcycle, // OUTPUT QA
  adder1_o2_and_oddcycle, // OUTPUT QB
  adder1_o1_and_oddcycle, // OUTPUT QC
  adder1_o0_and_oddcycle // OUTPUT QD
);
cell_FDQ J40 ( // 4-bit DFF
  cycle_odd, // INPUT CK
  adder1_o7_and, // INPUT DA
  adder1_o6_and, // INPUT DB
  adder1_o5_and, // INPUT DC
  adder1_o4_and, // INPUT DD
  adder1_o7_and_oddcycle, // OUTPUT QA
  adder1_o6_and_oddcycle, // OUTPUT QB
  adder1_o5_and_oddcycle, // OUTPUT QC
  adder1_o4_and_oddcycle // OUTPUT QD
);
cell_FDQ R40 ( // 4-bit DFF
  cycle_odd, // INPUT CK
  adder1_o11_and, // INPUT DA
  adder1_o10_and, // INPUT DB
  adder1_o9_and, // INPUT DC
  adder1_o8_and, // INPUT DD
  adder1_o11_and_oddcycle, // OUTPUT QA
  adder1_o10_and_oddcycle, // OUTPUT QB
  adder1_o9_and_oddcycle, // OUTPUT QC
  adder1_o8_and_oddcycle // OUTPUT QD
);
cell_FDQ T1 ( // 4-bit DFF
  cycle_odd, // INPUT CK
  adder1_o15_and, // INPUT DA
  adder1_o14_and, // INPUT DB
  adder1_o13_and, // INPUT DC
  adder1_o12_and, // INPUT DD
  adder1_o15_and_oddcycle, // OUTPUT QA
  adder1_o14_and_oddcycle, // OUTPUT QB
  adder1_o13_and_oddcycle, // OUTPUT QC
  adder1_o12_and_oddcycle // OUTPUT QD
);


// Adder 2
cell_A4H I61 ( // 4-bit Full Adder
  adder1_o19, // INPUT A4
  bus3_not_cycle2_7, // INPUT B4
  adder1_o18, // INPUT A3
  bus2_not_cycle2_7, // INPUT B3
  adder1_o17, // INPUT A2
  bus1_not_cycle2_7, // INPUT B2
  adder1_o16, // INPUT A1
  bus0_not_cycle2_7, // INPUT B1
  VCC, // INPUT CI
  path654, // OUTPUT CO
  adder2_o3, // OUTPUT S4
  adder2_o2, // OUTPUT S3
  adder2_o1, // OUTPUT S2
  adder2_o0 // OUTPUT S1
);
cell_A4H F71 ( // 4-bit Full Adder
  adder1_o23, // INPUT A4
  bus7_not_cycle2_7, // INPUT B4
  adder1_o22, // INPUT A3
  bus6_not_cycle2_7, // INPUT B3
  adder1_o21, // INPUT A2
  bus5_not_cycle2_7, // INPUT B2
  adder1_o20, // INPUT A1
  bus4_not_cycle2_7, // INPUT B1
  path654, // INPUT CI
  adder2_co, // OUTPUT CO
  adder2_o7, // OUTPUT S4
  adder2_o6, // OUTPUT S3
  adder2_o5, // OUTPUT S2
  adder2_o4 // OUTPUT S1
);

assign adder1_o16_and = ((adder1_o16 && ~adder2_co) || (adder2_o0 && adder2_co)) && mult_enable;
assign adder1_o17_and = ((adder1_o17 && ~adder2_co) || (adder2_o1 && adder2_co)) && mult_enable;
assign adder1_o18_and = ((adder1_o18 && ~adder2_co) || (adder2_o2 && adder2_co)) && mult_enable;
assign adder1_o19_and = ((adder1_o19 && ~adder2_co) || (adder2_o3 && adder2_co)) && mult_enable;
assign adder1_o20_and = ((adder1_o20 && ~adder2_co) || (adder2_o4 && adder2_co)) && mult_enable;
assign adder1_o21_and = ((adder1_o21 && ~adder2_co) || (adder2_o5 && adder2_co)) && mult_enable;
assign adder1_o22_and = ((adder1_o22 && ~adder2_co) || (adder2_o6 && adder2_co)) && mult_enable;
assign adder1_o23_and = ((adder1_o23 && ~adder2_co) || (adder2_o7 && adder2_co)) && mult_enable;

cell_FDQ M93 ( // 4-bit DFF
  cycle_odd, // INPUT CK
  adder1_o19_and, // INPUT DA
  adder1_o18_and, // INPUT DB
  adder1_o17_and, // INPUT DC
  adder1_o16_and, // INPUT DD
  adder1_o19_and_oddcycle, // OUTPUT QA
  adder1_o18_and_oddcycle, // OUTPUT QB
  adder1_o17_and_oddcycle, // OUTPUT QC
  adder1_o16_and_oddcycle // OUTPUT QD
);
cell_FDQ G38 ( // 4-bit DFF
  cycle_odd, // INPUT CK
  adder1_o23_and, // INPUT DA
  adder1_o22_and, // INPUT DB
  adder1_o21_and, // INPUT DC
  adder1_o20_and, // INPUT DD
  adder1_o23_and_oddcycle, // OUTPUT QA
  adder1_o22_and_oddcycle, // OUTPUT QB
  adder1_o21_and_oddcycle, // OUTPUT QC
  adder1_o20_and_oddcycle // OUTPUT QD
);



// =============================================================================
// Wave rom address final

cell_FDQ V61 ( // 4-bit DFF
  cycle_7_not, // INPUT CK
  bus0_cycle3, // INPUT DA
  bus1_cycle3, // INPUT DB
  bus2_cycle3, // INPUT DC
  bus3_cycle3, // INPUT DD
  bus0_cycle3_7, // OUTPUT QA
  bus1_cycle3_7, // OUTPUT QB
  bus2_cycle3_7, // OUTPUT QC
  bus3_cycle3_7 // OUTPUT QD
);
cell_FDM V16 ( // DFF
  cycle_7, // INPUT CK
  bus4_cycle3, // INPUT D
  unconnected_V16_XQ, // OUTPUT XQ
  bus4_cycle3_7 // OUTPUT Q
);
cell_FDM V22 ( // DFF
  cycle_7, // INPUT CK
  bus5_cycle3, // INPUT D
  unconnected_V22_XQ, // OUTPUT XQ
  bus5_cycle3_7 // OUTPUT Q
);


// Lower part comes from the multiplier
assign WR_A0_OUT = adder1_b9;
assign WR_A1_OUT = ~adder1_b10;
assign WR_A2_OUT = adder1_b11;
assign WR_A3_OUT = ~adder1_b12;
assign WR_A4_OUT = adder1_b13;
assign WR_A5_OUT = ~adder1_b14;
assign WR_A6_OUT = adder1_b15;
assign WR_A7_OUT = adder1_b16;
assign WR_A8_OUT = ~adder1_b17;
assign WR_A9_OUT = ~adder1_b18;
assign WR_A10_OUT = adder1_b19;

// Highest part of the wave rom address (11-16) comes from register 3
assign WR_A11_OUT = bus0_cycle3_7;
assign WR_A12_OUT = bus1_cycle3_7;
assign WR_A13_OUT = bus2_cycle3_7;
assign WR_A14_OUT = bus3_cycle3_7;
assign WR_A15_OUT = bus4_cycle3_7;
assign WR_A16_OUT = bus5_cycle3_7;



// =============================================================================
// Output to interpolator

cell_DE3 V91 ( // 3:8 Decoder
  bus1_cycle3_7, // INPUT B
  bus0_cycle3_7, // INPUT A
  bus2_cycle3_7, // INPUT C
  wr_sel_0000, // OUTPUT X0        0x0000
  wr_sel_0800, // OUTPUT X1        0x0800
  wr_sel_1000, // OUTPUT X2        0x1000
  wr_sel_1800, // OUTPUT X3        0x1800
  wr_sel_2000, // OUTPUT X4        0x2000
  unconnected_V91_X5, // OUTPUT X5 0x2800
  unconnected_V91_X6, // OUTPUT X6 0x3000
  unconnected_V91_X7 // OUTPUT X7 0x3800
);

assign ipt0_out_unsync = ~(~(adder1_b6 && RAM_A0_OUT) && ~((bus5_cycle3_7 || bus4_cycle3_7 || bus3_cycle3_7 || (VCC && wr_sel_0000 && wr_sel_0800 && wr_sel_1000 && wr_sel_1800 && wr_sel_2000)) && ~RAM_A0_OUT));
assign ipt2_out_unsync = ~(~(adder1_b7 && RAM_A0_OUT) && ~(~(~(bus7_cycle0_7 && bus6_cycle0_7) && ~(adder1_b23 || adder1_b22 || adder1_b21 || adder1_b20) && ~bus1_cycle6_cycle7) && ~RAM_A0_OUT));
assign ipt1_out_unsync = ~(~(adder1_b8 && RAM_A0_OUT) && ~(adder1_b5 && ~RAM_A0_OUT));
assign ipt3_out_unsync = ~(~(GND && RAM_A0_OUT) && ~(GND && ~RAM_A0_OUT)); // unused

// initial begin
//   $monitor(
//     "%d %d %d",adder1_b6, adder1_b7, adder1_b8
//   );
// end

cell_LT4 Q106 ( // 4-bit Data Latch
  SYNC_IN, // INPUT G
  ipt1_out_unsync, // INPUT DA
  ipt2_out_unsync, // INPUT DB
  ipt0_out_unsync, // INPUT DC
  ipt3_out_unsync, // INPUT DD
  unconnected_Q106_NA, // OUTPUT NA
  IPT1_OUT, // OUTPUT PA
  unconnected_Q106_NB, // OUTPUT NB
  IPT2_OUT, // OUTPUT PB
  unconnected_Q106_NC, // OUTPUT NC
  IPT0_OUT, // OUTPUT PC
  unconnected_Q106_ND, // OUTPUT ND
  unconnected_Q106_PD // OUTPUT PD
);

endmodule
