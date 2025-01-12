// =============================================================================
// Internal status

// Cycle counter state
reg [3:0] cycle_cnt;

// RAM IC13 address counter
wire [10:3] ram_a_cnt;
wire ram_stage; // 0: write, 1: read
// RAM IC13 address for writing
reg [10:3] ram_a_cnt_temp;


// Phase computed value
reg [23:8] adder1_o_and;
reg [23:8] adder1_o_and_7;
reg [23:0] adder1_o_and_temp;

reg state_sel_0;
reg state_sel_1;
wire adder_use_temp;
reg ram_addr_use_current;



// Sub-phase value from RAM IC13
reg [23:0] ram_subphase_d;

// Config from RAM IC12
reg [7:4] cfg0_pitch;
reg [7:0] cfg2_lp;
reg [5:0] cfg3_sample_sel;
reg cfg6_1_flag;

// Value from ROM IC11
reg [12:0] rom_d;


// End of read cycle temp variables
reg [7:4] cfg0_pitch_ff;
reg [7:0] cfg2_lp_ff;
reg [5:0] cfg3_sample_sel_ff;
reg cfg6_1_flag_ff;
reg [12:0] rom_d_ff;



// =============================================================================
// SYNC generation
// XTAL / 2 => SYNC

cell_FDO N109 ( // DFF with Reset
  XTAL_IN, // INPUT CK
  clockdiv_loop, // INPUT D
  UNK34_IN, // INPUT R
  SYNCO_OUT, // OUTPUT Q
  clockdiv_loop, // OUTPUT XQ
);



// =============================================================================
// Cycle counting

cell_C45 R61 ( // 4-bit Binary Synchronous Up Counter
  0, // INPUT DA
  1, // INPUT EN
  1, // INPUT CI
  FSYNC_IN, // INPUT CL
  0, // INPUT DB
  1, // INPUT L
  SYNC_IN, // INPUT CK
  0, // INPUT DC
  0, // INPUT DD
  cycle_cnt[0], // OUTPUT QA
  cycle_cnt[1], // OUTPUT QB
  unconnected_R61_CO, // OUTPUT CO
  cycle_cnt[2], // OUTPUT QC
  cycle_cnt[3], // OUTPUT QD
);

cell_DE3 T61 ( // 3:8 Decoder
  cycle_cnt[1], // INPUT B
  cycle_cnt[0], // INPUT A
  cycle_cnt[2], // INPUT C
  cycle_sel_0, // OUTPUT X0
  cycle_sel_1, // OUTPUT X1
  cycle_sel_2, // OUTPUT X2
  cycle_sel_3, // OUTPUT X3
  cycle_sel_4, // OUTPUT X4
  cycle_sel_5, // OUTPUT X5
  cycle_sel_6, // OUTPUT X6
  cycle_sel_7, // OUTPUT X7
);

assign cycle_3 = cycle_sel_3 || SYNC_IN || cycle_cnt[3];
assign cycle_4 = cycle_sel_4 || SYNC_IN || cycle_cnt[3];
assign cycle_5 = cycle_sel_5 || SYNC_IN || cycle_cnt[3];
assign cycle_6 = cycle_sel_6 || SYNC_IN || cycle_cnt[3];
assign cycle_7 = cycle_sel_7 || SYNC_IN || cycle_cnt[3];
assign cycle_9 = cycle_sel_1 || SYNC_IN || ~cycle_cnt[3];
assign cycle_7_not = ~cycle_7;
assign cycle_15_not = ~(cycle_sel_7 || SYNC_IN || ~cycle_cnt[3]);
assign cycle_0_xor1 = ~(1 ^ ~(1 ^ (cycle_sel_0 || SYNC_IN || cycle_cnt[3])));
assign cycle_1_xor1 = ~(1 ^ ~(1 ^ (cycle_sel_1 || SYNC_IN || cycle_cnt[3])));
assign cycle_2_xor1 = ~(1 ^ ~(1 ^ (cycle_sel_2 || SYNC_IN || cycle_cnt[3])));
assign cycle_3_xor = ~(~(cycle_3 ^ 1) ^ 1);
assign cycle_6_xor = ~(~(cycle_6 ^ 1) ^ 1);
assign cycle_0_xor2 = ~(1 ^ cycle_0_xor1);
assign cycle_1_xor2 = ~(1 ^ cycle_1_xor1);
assign cycle_2_xor2 = ~(1 ^ cycle_2_xor1);

assign cycle7_15 = (cycle_sel_7 || SYNC_IN || ~cycle_cnt[3]) && (cycle_sel_7 || SYNC_IN || cycle_cnt[3]);
assign cycle_between = ~(~((cycle_sel_0 || SYNC_IN || cycle_cnt[3]) && (cycle_sel_2 || SYNC_IN || cycle_cnt[3]) && (cycle_sel_4 || SYNC_IN || cycle_cnt[3]) && (cycle_sel_6 || SYNC_IN || cycle_cnt[3]) && (cycle_sel_0 || SYNC_IN || ~cycle_cnt[3]) && (cycle_sel_2 || SYNC_IN || ~cycle_cnt[3]) && (cycle_sel_4 || SYNC_IN || ~cycle_cnt[3]) && (cycle_sel_6 || SYNC_IN || ~cycle_cnt[3])) || ~((cycle_sel_1 || SYNC_IN || cycle_cnt[3]) && (cycle_sel_3 || SYNC_IN || cycle_cnt[3]) && (cycle_sel_5 || SYNC_IN || cycle_cnt[3]) && (cycle_sel_7 || SYNC_IN || cycle_cnt[3]) && (cycle_sel_1 || SYNC_IN || ~cycle_cnt[3]) && (cycle_sel_3 || SYNC_IN || ~cycle_cnt[3]) && (cycle_sel_5 || SYNC_IN || ~cycle_cnt[3]) && (cycle_sel_7 || SYNC_IN || ~cycle_cnt[3])));
assign cycle_odd = ~((cycle_sel_1 || SYNC_IN || cycle_cnt[3]) && (cycle_sel_3 || SYNC_IN || cycle_cnt[3]) && (cycle_sel_5 || SYNC_IN || cycle_cnt[3]) && (cycle_sel_7 || SYNC_IN || cycle_cnt[3]) && (cycle_sel_1 || SYNC_IN || ~cycle_cnt[3]) && (cycle_sel_3 || SYNC_IN || ~cycle_cnt[3]) && (cycle_sel_5 || SYNC_IN || ~cycle_cnt[3]) && (cycle_sel_7 || SYNC_IN || ~cycle_cnt[3]));



// =============================================================================
// Input from RAM/ROM

assign ROM_A_OUT[0] = ram_a_cnt[2];

// Latches
always @(*) begin
  // ROM data input (LSB and MSB)
  if (!cycle_3) begin
    rom_d[4:0] <= ROM_D_IN[4:0];
    rom_d[7:5] <= ~ROM_D_IN[7:5];
  end
  if (!cycle_5)
    rom_d[12:8] <= ~ROM_D_IN[4:0];

  // config[0,1] (pitch)
  if (!cycle_0_xor1) begin
    cfg0_pitch[7:4] <= BUS_IN[7:4];
    ROM_A_OUT[12:9] <= BUS_IN[3:0];
  end
  if (!cycle_1_xor1)
    ROM_A_OUT[8:1] <= BUS_IN[7:0];
  
  // config[2] (loop point)
  if (!cycle_2_xor1)
    cfg2_lp <= ~BUS_IN;
  
  // config[3] (sample select)
  if (!cycle_3_xor)
    cfg3_sample_sel[5:0] <= BUS_IN[5:0];
  
  // config[6][1] (flag?)
  if (!cycle_6_xor)
    cfg6_1_flag <= BUS_IN[1];

  // Subphase RAM IC13 data input
  if (!cycle_0_xor2)
    ram_subphase_d[7:0]   <= {RAM_D_IN[7], RAM_D_IN[6], RAM_D_IN[5], ~RAM_D_IN[4], ~RAM_D_IN[3], RAM_D_IN[2], RAM_D_IN[1], ~RAM_D_IN[0]};
  if (!cycle_1_xor2)
    ram_subphase_d[15:8]  <= {RAM_D_IN[7], RAM_D_IN[6], RAM_D_IN[5], ~RAM_D_IN[4], ~RAM_D_IN[3], RAM_D_IN[2], RAM_D_IN[1], ~RAM_D_IN[0]};
  if (!cycle_2_xor2)
    ram_subphase_d[23:16] <= {RAM_D_IN[7], RAM_D_IN[6], RAM_D_IN[5], ~RAM_D_IN[4], ~RAM_D_IN[3], RAM_D_IN[2], RAM_D_IN[1], ~RAM_D_IN[0]};
  
  // Store current subphase to store in RAM IC13
  if (!cycle_7)
    adder1_o_and_7[23:8] <= adder1_o_and[23:8];
end


// End of first phase flip flops
always @(negedge cycle_7_not) begin
  cfg0_pitch_ff[7:4] <= cfg0_pitch[7:4];
  cfg2_lp_ff <= cfg2_lp;
  cfg3_sample_sel_ff[16:11] <= cfg3_sample_sel[5:0];
  cfg6_1_flag_ff <= ~cfg6_1_flag;
  
  rom_d_ff <= rom_d;
end



// =============================================================================
// Voice/part counter

cell_C45 P13 ( // 4-bit Binary Synchronous Up Counter
  1, // INPUT DA
  1, // INPUT EN
  1, // INPUT CI
  FSYNC_IN, // INPUT CL
  1, // INPUT DB
  1, // INPUT L
  cycle_between, // INPUT CK
  1, // INPUT DC
  1, // INPUT DD
  ram_a_cnt[0], // OUTPUT QA
  ram_a_cnt[1], // OUTPUT QB
  cnt_part_addr_co, // OUTPUT CO
  ram_a_cnt[2], // OUTPUT QC
  ram_stage, // OUTPUT QD
);

assign r13_overflow = cnt_part_addr_co || ~UNK34_IN;
assign cnt_next_part = FSYNC_IN && ~(ram_a_cnt[6] && ram_a_cnt[3] && (cnt_part_addr_co || ~UNK34_IN));
cell_C45 U73 ( // 4-bit Binary Synchronous Up Counter
  0, // INPUT DA
  r13_overflow, // INPUT EN
  r13_overflow, // INPUT CI
  cnt_next_part, // INPUT CL
  0, // INPUT DB
  1, // INPUT L
  cycle_between, // INPUT CK
  0, // INPUT DC
  0, // INPUT DD
  ram_a_cnt[3], // OUTPUT QA
  ram_a_cnt[4], // OUTPUT QB
  unconnected_U73_CO, // OUTPUT CO
  ram_a_cnt[5], // OUTPUT QC
  ram_a_cnt[6], // OUTPUT QD
);

assign cnt_next_voice = ram_a_cnt[6] && ram_a_cnt[3] && (cnt_part_addr_co || ~UNK34_IN);
cell_C45 S66 ( // 4-bit Binary Synchronous Up Counter
  1, // INPUT DA
  1, // INPUT EN
  cnt_next_voice, // INPUT CI
  FSYNC_IN, // INPUT CL
  0, // INPUT DB
  1, // INPUT L
  cycle_between, // INPUT CK
  0, // INPUT DC
  0, // INPUT DD
  ram_a_cnt[7], // OUTPUT QA
  ram_a_cnt[8], // OUTPUT QB
  unconnected_S66_CO, // OUTPUT CO
  ram_a_cnt[9], // OUTPUT QC
  ram_a_cnt[10], // OUTPUT QD
);



// =============================================================================
// Internal/stored selection

always @(posedge cycle_7 or negedge cycle_4) begin
  if (!cycle_4)
    state_sel_0 <= 1'b1;
  else
    state_sel_0 <= ram_stage;
end

always @(posedge cycle_9 or negedge cycle_6) begin
  if (!cycle_6)
    state_sel_1 <= 1'b0;
  else
    state_sel_1 <= ram_stage;
end

// false on cycle 8 and 9
assign adder_use_temp = state_sel_0 || state_sel_1;


// Inverse of ram_stage
always @(posedge cycle7_15 or negedge FSYNC_IN) begin
  if (!FSYNC_IN)
    ram_addr_use_current <= 1'b1;
  else
    ram_addr_use_current <= ram_stage;
end



// =============================================================================
// Phase computation
// Input config: rom_d_ff, cfg0_pitch_ff, cfg2_lp_ff, cfg6_1_flag_ff
// Input state:  adder_use_temp, adder1_o_and_temp, ram_subphase_d

wire [23:0] adder1_a;
wire [23:0] adder1_b;
wire [23:0] adder1_o;
wire [7:0] adder2_o;
wire adder2_co;
wire [23:0] adder1_o_and;

// LUT
assign adder1_a[0] = (~rom_d_ff[6] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[5] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (rom_d_ff[4] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (rom_d_ff[3] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (rom_d_ff[2] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (rom_d_ff[1] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (rom_d_ff[0] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]);
assign adder1_a[1] = (~rom_d_ff[7] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[6] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[5] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (rom_d_ff[4] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (rom_d_ff[3] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (rom_d_ff[2] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (rom_d_ff[1] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (rom_d_ff[0] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]);
assign adder1_a[2] = ~(~((~rom_d_ff[8] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[7] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[6] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[5] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (rom_d_ff[4] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (rom_d_ff[3] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (rom_d_ff[2] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (rom_d_ff[1] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7])) && ~(rom_d_ff[0] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]));
assign adder1_a[3] = ~(~((~rom_d_ff[9] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[8] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[7] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[6] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[5] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (rom_d_ff[4] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (rom_d_ff[3] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (rom_d_ff[2] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7])) && ~((rom_d_ff[1] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (rom_d_ff[0] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7])));
assign adder1_a[4] = ~(~((~rom_d_ff[10] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[9] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[8] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[7] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[6] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[5] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (rom_d_ff[4] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (rom_d_ff[3] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7])) && ~((rom_d_ff[2] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (rom_d_ff[1] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (rom_d_ff[0] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (0 && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7])));
assign adder1_a[5] = ~(~((~rom_d_ff[11] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[10] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[9] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[8] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[7] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[6] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[5] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (rom_d_ff[4] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7])) && ~((rom_d_ff[3] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (rom_d_ff[2] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (rom_d_ff[1] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (rom_d_ff[0] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7])));
assign adder1_a[6] = ~(~((~rom_d_ff[12] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[11] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[10] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[9] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[8] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[7] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[6] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[5] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7])) && ~((rom_d_ff[4] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (rom_d_ff[3] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (rom_d_ff[2] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (rom_d_ff[1] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7])));
assign adder1_a[7] = ~(~((1 && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[12] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[11] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[10] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[9] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[8] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[7] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[6] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7])) && ~((~rom_d_ff[5] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (rom_d_ff[4] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (rom_d_ff[3] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (rom_d_ff[2] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7])));
assign adder1_a[8] = ~(~((0 && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (1 && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[12] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[11] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[10] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[9] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[8] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[7] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7])) && ~((~rom_d_ff[6] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (~rom_d_ff[5] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (rom_d_ff[4] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (rom_d_ff[3] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7])));
assign adder1_a[9] = ~(~((1 && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[12] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[11] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[10] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[9] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[8] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[7] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (~rom_d_ff[6] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7])) && ~((~rom_d_ff[5] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (rom_d_ff[4] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7])));
assign adder1_a[10] = ~(~((1 && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[12] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[11] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[10] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[9] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[8] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (~rom_d_ff[7] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (~rom_d_ff[6] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7])) && ~(~rom_d_ff[5] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]));
assign adder1_a[11] = (1 && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[12] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[11] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[10] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[9] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (~rom_d_ff[8] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (~rom_d_ff[7] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (~rom_d_ff[6] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]);
assign adder1_a[12] = (0 && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (1 && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[12] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[11] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[10] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (~rom_d_ff[9] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (~rom_d_ff[8] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (~rom_d_ff[7] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]);
assign adder1_a[13] = (1 && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[12] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) || (~rom_d_ff[11] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (~rom_d_ff[10] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (~rom_d_ff[9] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) || (~rom_d_ff[8] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]);
assign adder1_a[14] = ~(1 && ~(1 && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && cfg0_pitch_ff[6] && ~cfg0_pitch_ff[7]) && ~(~rom_d_ff[12] && ~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) && ~(~rom_d_ff[11] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) && ~(~rom_d_ff[10] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) && ~(~rom_d_ff[9] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]));
assign adder1_a[15] = ~(~(~cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) && ~(~rom_d_ff[12] && cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) && ~(~rom_d_ff[11] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) && ~(~rom_d_ff[10] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]));
assign adder1_a[16] = ~(~(cfg0_pitch_ff[4] && ~cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) && ~(~rom_d_ff[12] && ~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) && ~(~rom_d_ff[11] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]));
assign adder1_a[17] = ~(~(~cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]) && ~(~rom_d_ff[12] && cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7]));
assign adder1_a[18] = cfg0_pitch_ff[4] && cfg0_pitch_ff[5] && ~cfg0_pitch_ff[6] && cfg0_pitch_ff[7];
assign adder1_a[19] = 0;
assign adder1_a[20] = 0;
assign adder1_a[21] = 0;
assign adder1_a[22] = 0;
assign adder1_a[23] = 0;

assign adder1_b = adder_use_temp ? adder1_o_and_temp : ram_subphase_d;

assign adder1_o = adder1_a + adder1_b;

assign {adder2_co, adder2_o} = 1'b1 + adder1_o[23:16] + cfg2_lp_ff[7:0];

assign adder1_o_and[15:0]  = ~cfg6_1_flag_ff ? adder1_o[15:0] : 16'd0;
assign adder1_o_and[23:16] = ~cfg6_1_flag_ff ? (adder2_co ? adder2_o : adder1_o[23:16]) : 8'd0;



// =============================================================================
// Wave address output

assign WR_A_OUT[0]  =  adder1_b[9];
assign WR_A_OUT[1]  = ~adder1_b[10];
assign WR_A_OUT[2]  =  adder1_b[11];
assign WR_A_OUT[3]  = ~adder1_b[12];
assign WR_A_OUT[4]  =  adder1_b[13];
assign WR_A_OUT[5]  = ~adder1_b[14];
assign WR_A_OUT[6]  =  adder1_b[15];
assign WR_A_OUT[7]  =  adder1_b[16];
assign WR_A_OUT[8]  = ~adder1_b[17];
assign WR_A_OUT[9]  = ~adder1_b[18];
assign WR_A_OUT[10] =  adder1_b[19];
assign WR_A_OUT[16:11] = cfg3_sample_sel_ff[5:0];



// =============================================================================
// IC13 RAM

always @(negedge cycle_15_not)
  ram_a_cnt_temp[10:3] <= ram_a_cnt[10:3];
assign RAM_A_OUT[2:0] = ram_a_cnt[2:0];
assign RAM_A_OUT[10:3] = ram_addr_use_current ? ram_a_cnt : ram_a_cnt_temp;

always @(negedge cycle_odd) begin
  adder1_o_and_temp <= adder1_o_and;
end

assign RAM_D_OUT[0] =   ~(adder1_o_and_temp[0] && ~RAM_A0_OUT && ~RAM_A1_OUT) && ~(adder1_o_and_7[8]  && RAM_A0_OUT && ~RAM_A1_OUT) && ~(adder1_o_and_7[16] && ~RAM_A0_OUT && RAM_A1_OUT);
assign RAM_D_OUT[1] = ~(~(adder1_o_and_temp[1] && ~RAM_A0_OUT && ~RAM_A1_OUT) && ~(adder1_o_and_7[9]  && RAM_A0_OUT && ~RAM_A1_OUT) && ~(adder1_o_and_7[17] && ~RAM_A0_OUT && RAM_A1_OUT));
assign RAM_D_OUT[2] = ~(~(adder1_o_and_temp[2] && ~RAM_A0_OUT && ~RAM_A1_OUT) && ~(adder1_o_and_7[10] && RAM_A0_OUT && ~RAM_A1_OUT) && ~(adder1_o_and_7[18] && ~RAM_A0_OUT && RAM_A1_OUT));
assign RAM_D_OUT[3] =   ~(adder1_o_and_temp[3] && ~RAM_A0_OUT && ~RAM_A1_OUT) && ~(adder1_o_and_7[11] && RAM_A0_OUT && ~RAM_A1_OUT) && ~(adder1_o_and_7[19] && ~RAM_A0_OUT && RAM_A1_OUT);
assign RAM_D_OUT[4] =   ~(adder1_o_and_temp[4] && ~RAM_A0_OUT && ~RAM_A1_OUT) && ~(adder1_o_and_7[12] && RAM_A0_OUT && ~RAM_A1_OUT) && ~(adder1_o_and_7[20] && ~RAM_A0_OUT && RAM_A1_OUT);
assign RAM_D_OUT[5] = ~(~(adder1_o_and_temp[5] && ~RAM_A0_OUT && ~RAM_A1_OUT) && ~(adder1_o_and_7[13] && RAM_A0_OUT && ~RAM_A1_OUT) && ~(adder1_o_and_7[21] && ~RAM_A0_OUT && RAM_A1_OUT));
assign RAM_D_OUT[6] = ~(~(adder1_o_and_temp[6] && ~RAM_A0_OUT && ~RAM_A1_OUT) && ~(adder1_o_and_7[14] && RAM_A0_OUT && ~RAM_A1_OUT) && ~(adder1_o_and_7[22] && ~RAM_A0_OUT && RAM_A1_OUT));
assign RAM_D_OUT[7] = ~(~(adder1_o_and_temp[7] && ~RAM_A0_OUT && ~RAM_A1_OUT) && ~(adder1_o_and_7[15] && RAM_A0_OUT && ~RAM_A1_OUT) && ~(adder1_o_and_7[23] && ~RAM_A0_OUT && RAM_A1_OUT));

assign RAM_OE_OUT = ram_stage;
assign RAM_D_IOM = UNK34_IN && ~(~ram_a_cnt[2] && RAM_OE_OUT);

// Write on slots 0,1,2,3,4,5,6,7 on the second stage (cycle_cnt[3])
assign RAM_WR_OUT = (cycle_sel_0 || SYNC_IN || ~cycle_cnt[3]) && (cycle_sel_1 || SYNC_IN || ~cycle_cnt[3]) && (cycle_sel_2 || SYNC_IN || ~cycle_cnt[3]) && (cycle_sel_4 || SYNC_IN || ~cycle_cnt[3]) && (cycle_sel_5 || SYNC_IN || ~cycle_cnt[3]) && (cycle_sel_6 || SYNC_IN || ~cycle_cnt[3]) && (cycle_sel_7 || SYNC_IN || ~cycle_cnt[3]) && 1;



// =============================================================================
// Control output to IC8

wire ipt0_out_unsync, ipt1_out_unsync, ipt2_out_unsync;
wire ag3_sel_sample_type, ag1_phase_hi;

cell_DE3 V91 ( // 3:8 Decoder
  WR_A_OUT[12], // INPUT B
  WR_A_OUT[11], // INPUT A
  WR_A_OUT[13], // INPUT C
  wr_11_13_dec0, // OUTPUT X0
  wr_11_13_dec1, // OUTPUT X1
  wr_11_13_dec2, // OUTPUT X2
  wr_11_13_dec3, // OUTPUT X3
  wr_11_13_dec4, // OUTPUT X4
  unconnected_V91_X5, // OUTPUT X5
  unconnected_V91_X6, // OUTPUT X6
  unconnected_V91_X7, // OUTPUT X7
);

// WR_A_OUT[16] || WR_A_OUT[15] || WR_A_OUT[14] || !((WR_A_OUT[13] && !WR_A_OUT[11] && ! WR_A_OUT[12]) || !WR_A_OUT[13])
assign ag3_sel_sample_type = WR_A_OUT[16] || WR_A_OUT[15] || WR_A_OUT[14] || ~(wr_11_13_dec0 || wr_11_13_dec1 || wr_11_13_dec2 || wr_11_13_dec3 || wr_11_13_dec4);

assign ag1_phase_hi = (
  // after the end of the pitch table
  (cfg0_pitch_ff[7] && cfg0_pitch_ff[6]) ||
  // not one-shot
  (adder1_b[23] || adder1_b[22] || adder1_b[21] || adder1_b[20]) ||
  cfg6_1_flag_ff
);

assign ipt0_out_unsync = RAM_A0_OUT ? adder1_b[6] : ag3_sel_sample_type; // AG3
assign ipt2_out_unsync = RAM_A0_OUT ? adder1_b[7] : ag1_phase_hi; // AG1
assign ipt1_out_unsync = RAM_A0_OUT ? adder1_b[8] : adder1_b[5]; // AG2

always @(*) begin
  if (!SYNC_IN) begin
    IPT1_OUT <= ipt1_out_unsync;
    IPT2_OUT <= ipt2_out_unsync;
    IPT0_OUT <= ipt0_out_unsync;
  end
end
