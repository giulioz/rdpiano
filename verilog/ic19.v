module IC19 (
  input wire E_NOR_77_IN,
  input wire AL_CT_76_IN,
  input wire UNK_75_IN,
  input wire UNK_74_IN, // maybe test pin?
  // output wire P1_TOVERFLOW_OUT,  // unimplemented

  input wire FSYNC_IN,
  input wire SYNC_IN, // inverted

  input wire E_IN,
  input wire RW_IN,
  output wire IRQ_OUT,
  input wire RESET_IN,
  input wire AS_IN,

  input wire [7:0] CPU_P3_IN,
  output reg [7:0] CPU_P3_OUT,
  output wire CPU_P3_IOM,

  input wire [7:0] CPU_P4_IN,
  input wire [7:0] AL_IN,
  output reg [7:0] AL_OUT,
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

  output wire volout_7, // 2=>IC19_1_IN
  output wire volout_1, // 3=>IC19_2_IN
  output wire volout_2, // 4=>IC19_3_IN
  output wire volout_3, // 5=>IC19_4_IN
  output wire volout_4, // 6=>IC19_5_IN
  output wire volout_6, // 7=>IC19_6_IN
  output wire volout_5  // 8=>IC19_7_IN
);



// =============================================================================
// Address Latch & Decoding for CPU

always @(*) begin
  if (AS_IN)
    AL_OUT <= CPU_P3_IN;
end

assign AL0_IOM = UNK_74_IN && ~AL_CT_76_IN;
// 0x4000-0xbfff
assign PARAM_ROMCS_OUT = ~(P47_IN ^ P46_IN) || RD_OUT;
// 0x0000-0x0fff
assign RAMCS_OUT = ~(~(P47_IN || P46_IN) && ~P45_IN && ~P44_IN);
assign RD_OUT = ~(RW_IN && E_IN);
assign WR_OUT = ~(~RW_IN && E_IN);

assign low_addr_intrnl = (AL_OUT && AL_CT_76_IN) || (AL_IN && ~AL_CT_76_IN)



// =============================================================================
// Internal cycles counting

reg [3:0] current_cycle;

always @(posedge SYNC_IN) begin
  if (!FSYNC_IN)
    current_cycle <= 4'h0;
  else if (!UNK_74_IN)
    current_cycle <= 4'hF;
  else
    current_cycle <= current_cycle + 1;
end

assign cycle_0  = ~(current_cycle == 4'd0)  || SYNC_IN;
assign cycle_1  = ~(current_cycle == 4'd1)  || SYNC_IN;
assign cycle_2  = ~(current_cycle == 4'd2)  || SYNC_IN;
assign cycle_3  = ~(current_cycle == 4'd3)  || SYNC_IN;
assign cycle_4  = ~(current_cycle == 4'd4)  || SYNC_IN;
assign cycle_5  = ~(current_cycle == 4'd5)  || SYNC_IN;
assign cycle_6  = ~(current_cycle == 4'd6)  || SYNC_IN;
assign cycle_7  = ~(current_cycle == 4'd7)  || SYNC_IN;
assign cycle_8  = ~(current_cycle == 4'd8)  || SYNC_IN;
assign cycle_9  = ~(current_cycle == 4'd9)  || SYNC_IN;
assign cycle_10 = ~(current_cycle == 4'd10) || SYNC_IN;
assign cycle_11 = ~(current_cycle == 4'd11) || SYNC_IN;
assign cycle_12 = ~(current_cycle == 4'd12) || SYNC_IN;
assign cycle_13 = ~(current_cycle == 4'd13) || SYNC_IN;
assign cycle_14 = ~(current_cycle == 4'd14) || SYNC_IN;
assign cycle_15 = ~(current_cycle == 4'd15) || SYNC_IN;

assign cycle_odd = cycle_1 && cycle_3 && cycle_5 && cycle_7 && cycle_9 && cycle_11 && cycle_13 && cycle_15;
assign cycle_even = cycle_0 && cycle_2 && cycle_4 && cycle_6 && cycle_8 && cycle_10 && cycle_12 && cycle_14;
assign cycle_sync = cycle_even && cycle_odd; // same as SYNC_IN



// =============================================================================
// RAM IC12 Address Counter

reg [3:0] ram12_addr_low;
reg [3:0] ram12_addr_part;
reg [3:0] ram12_addr_voice;

always @(posedge cycle_sync) begin
  if (!FSYNC_IN) begin
    // FSYNC starts over
    ram12_addr_low <= 4'h0;
    ram12_addr_part <= 4'h0;
    ram12_addr_voice <= 4'h0;
  end
  else if (!UNK_74_IN) begin
    ram12_addr_low <= 4'hF;
  end
  else begin
    if (ram12_addr_low + 1 == 16 || ~UNK_74_IN) begin
      // wrap at 10 voices
      if (ram12_addr_part < 9)
        ram12_addr_part <= ram12_addr_part + 1;
      else begin
        ram12_addr_part <= 0;
        ram12_addr_voice <= ram12_addr_voice + 1;
      end
      
      ram12_addr_low <= ram12_addr_low + 1;
    end else
      ram12_addr_low <= ram12_addr_low + 1;
  end
end

// Stage 0: read
// Stage 1: write
wire ric12_ac0_stage;
assign ric12_ac0_stage = ram12_addr_low[3];



// =============================================================================
// CPU Write to RAM IC12

assign high_address_100x = ~P47_IN && ~P46_IN && ~P45_IN && P44_IN;
assign wr_1000 = high_address_100x && ~(~(AL0_OUT && AL_CT_76_IN) && ~(AL0_IN && ~AL_CT_76_IN)) && ~RW_IN && E_IN;
assign wr_1001 = high_address_100x && ~(AL0_OUT && AL_CT_76_IN) && ~(AL0_IN && ~AL_CT_76_IN) && ~RW_IN && E_IN;

// When writing to 0x1000, save the write address/data
always @(*) begin
  if (wr_1000) begin
    // address
    ram12_address_write[10:7] <= CPU_P4_IN[3:0];
    ram12_address_write[6:3] <= low_addr_intrnl[7:4];
    // low internal address b3 is skipped
    ram12_address_write[2:1] <= low_addr_intrnl[2:1];
    ram12_address_write[2:0] <= 0; // counter is used instead

    // data 0
    ram12_data_write_0 <= CPU_P3_IN;
  end

  if (wr_1001) begin
    // data 1
    ram12_data_write_1 <= CPU_P3_IN;
  end
end

// Controls the write request from the CPU commands
reg ram12_cpu_write_req;
always @(negedge wr_1000, negedge UNK_74_IN, posedge (ram12_write_pending && cycle_9)) begin
  if (!UNK_74_IN)
    ram12_cpu_write_req <= 1'b1;
  else if (ram12_write_pending && cycle_9)
    ram12_cpu_write_req <= 1'b0;
  else
    ram12_cpu_write_req <= E_IN;
end

// Set the write pending flag at the beginning of the write stage
reg ram12_write_pending;
always @(negedge cycle_8) begin
  ram12_write_pending <= ram12_cpu_write_req;
end

reg [10:0] ram12_address_write;
reg [7:0] ram12_data_write_0;
reg [7:0] ram12_data_write_1;



// =============================================================================
// RAM IC12 Controller

reg ram12_write_mode, ram12_write_part, ram12_read_part;
always @(posedge cycle_sync) begin
  // turn into write mode when after the start of write stage, keep it down for 2 cycles
  ram12_write_mode <= ric12_ac0_stage && (ram12_addr_low[2:0] == 1 || ram12_addr_low[2:0] == 0);

  // TODO: check if this is correct:
  // output write address for part after the two cycles of writing, but not for address 6/7 (?)
  ram12_write_part <= (
    (ric12_ac0_stage && ram12_addr_low[2:0] == 1) || (
      (ric12_ac0_stage && ram12_addr_low[2:0] == 0) &&
      ~(ram12_address_write[2:0] == 6 || ram12_address_write[2:0] == 7)
    )
  );

  // TODO: check if this is correct:
  // output read address for part, but not for the two cycles of writing and address 6 (?)
  ram12_read_part <= (
    ~(ric12_ac0_stage && ram12_addr_low[2:0] == 1) &&
    ~(ric12_ac0_stage && ram12_addr_low[2:0] == 0) &&
    ~(~ric12_ac0_stage && ram12_addr_low[2:0] == 5)
  );
end

// read when not in write mode
assign RIC12_OE_OUT = ram12_write_mode;
// write if pending, but not during cycle 9 and 10
assign RIC12_WE_OUT = ~((cycle_9 || cycle_10) && ram12_write_pending);

// output the read or write address
assign RIC12_A0_OUT  = ~(ram12_write_mode ? ~ram12_addr_low[0] : ram12_addr_low[0]);
assign RIC12_A1_OUT  = ~(ram12_write_mode ? ram12_address_write[1] : ram12_addr_low[1]);
assign RIC12_A2_OUT  = ~(ram12_write_mode ? ram12_address_write[2] : ram12_addr_low[2]);
assign RIC12_A3_OUT  =  (ram12_addr_part[0] && ram12_read_part) || (ram12_address_write[3] && ram12_write_part);
assign RIC12_A4_OUT  =  (ram12_addr_part[1] && ram12_read_part) || (ram12_address_write[4] && ram12_write_part);
assign RIC12_A5_OUT  =  (ram12_addr_part[2] && ram12_read_part) || (ram12_address_write[5] && ram12_write_part);
assign RIC12_A6_OUT  =  (ram12_addr_part[3] && ram12_read_part) || (ram12_address_write[6] && ram12_write_part);
assign RIC12_A7_OUT  = ~(ram12_write_mode ? ram12_address_write[7] : ram12_addr_voice[0]);
assign RIC12_A8_OUT  = ~(ram12_write_mode ? ram12_address_write[8] : ram12_addr_voice[1]);
assign RIC12_A9_OUT  = ~(ram12_write_mode ? ram12_address_write[9] : ram12_addr_voice[2]);
assign RIC12_A10_OUT = ~(ram12_write_mode ? ram12_address_write[10] : ram12_addr_voice[3]);

// output to write the latched MSB or LSB
assign RIC12_D_OUT = ~(ram12_addr_low[0] ? ram12_data_write_1 : ram12_data_write_0);
assign RIC12_D_IOM = ~(ram12_write_mode || ~UNK_74_IN);



// =============================================================================
// Registers for read values from RAM IC12/13

// From RAM IC12
reg [7:0] env_dest;
reg [7:0] env_speed;
reg [7:0] part_flags;

// From RAM IC13
reg [31:0] env_prev;

// During the read phase
always @(*) begin
  if (!cycle_4) begin
    env_dest <= RIC12_D_IN;
    env_prev[7:0] <= RIC13_D_IN;
  end

  if (!cycle_5) begin
    env_speed <= RIC12_D_IN;
    env_prev[15:8] <= RIC13_D_IN;
  end
  
  if (!cycle_6) begin
    part_flags <= RIC12_D_IN;
    env_prev[23:16] <= RIC13_D_IN;
  end

  if (!cycle_7) begin
    env_prev[31:24] <= RIC13_D_IN;
  end
end

// At the end of the read phase, store them in registers
reg [7:0] env_dest_r;
reg [7:0] env_speed_r;
reg [7:0] env_flag0_6_r;
reg [7:0] env_param_7;
always @(posedge cycle_7) begin
  env_dest_r <= env_dest;
  env_speed_r <= env_speed;
  env_flag0_6_r <= part_flags[0];
  env_param_7 <= RIC12_D_IN;
end



// =============================================================================
// IRQ

// IRQ is fired using the carry output of adder2
wire adder2_co;
assign adder2_co = (adder1_o[27:20] + ~env_dest_r[7:0] + 8'd1) > 9'hFF;

wire should_fire_irq, env_speed_some_high;
assign env_speed_some_high = (env_speed_r[6] || env_speed_r[5] || env_speed_r[4] || env_speed_r[3]) && (env_speed_r[2] || env_speed_r[1] || env_speed_r[0]);
assign should_fire_irq = ~(~env_speed_some_high || ~((adder1_co ^ env_speed_r[7]) || (adder2_co ^ env_speed_r[7])));

// If a write is done, reset the IRQ status
reg irq_fired;
always @(posedge cycle_odd or posedge ram12_write_pending) begin
  if (ram12_write_pending)
    irq_fired <= 1'b0;
  else if (should_fire_irq)
    irq_fired <= 1'b1;
end

wire current_voice_irqs;
assign current_voice_irqs = ~UNK_75_IN || irq_fired;
assign IRQ_OUT = ~((UNK_75_IN || ~should_fire_irq) && current_voice_irqs);



// =============================================================================
// IRQ readback from CPU
// When an IRQ fires the current voice+part index is stored, and it can be read by the CPU

// Latches the current voice/part counter value on cycle 8 to be outputed to the CPU data bus
reg [7:0] irq_part_voice;
always @(*) begin
  if (!cycle_8)
    irq_part_voice <= {ram12_addr_voice, ram12_addr_part};
end
// IRQ happened: output the current latched voice/part counter value
always @(posedge current_voice_irqs) begin
  CPU_P3_OUT <= irq_part_voice;
end

// CPU data bus becomes output on address 0x1000
assign P32_IOM = ~(high_address_100x && RW_IN && ~(E_IN ^ E_NOR_77_IN)) && UNK_74_IN;



// =============================================================================
// Envelope computation
// next = prev + exp(env_speed)
// It uses a flip flop because IC8 receives values every 2 cycles, so it generates a bunch of sequential values!

// Select prev or new envelope value
reg cycles_0_to_7, cycles_9_to_0;
always @(posedge cycle_7 or negedge cycle_0) begin
  if (!cycle_0)
    cycles_0_to_7 <= 1'b1;
  else
    cycles_0_to_7 <= ric12_ac0_stage;
end
always @(posedge cycle_9 or negedge cycle_1) begin
  if (!cycle_1)
    cycles_9_to_0 <= 1'b0;
  else
    cycles_9_to_0 <= ric12_ac0_stage;
end

// Use the value from RAM on cycles 
wire adder_ctrl;
assign adder_ctrl = cycles_0_to_7 || cycles_9_to_0;

// 28 bit adder
wire [27:0] adder1_a;
assign adder1_a[0]  = ~env_flag0_6_r && ((env_prev[0]  && ~adder_ctrl) || (prev_adder[0]  && adder_ctrl));
assign adder1_a[1]  = ~env_flag0_6_r && ((env_prev[1]  && ~adder_ctrl) || (prev_adder[1]  && adder_ctrl));
assign adder1_a[2]  = ~env_flag0_6_r && ((env_prev[2]  && ~adder_ctrl) || (prev_adder[2]  && adder_ctrl));
assign adder1_a[3]  = ~env_flag0_6_r && ((env_prev[3]  && ~adder_ctrl) || (prev_adder[3]  && adder_ctrl));
assign adder1_a[4]  = ~env_flag0_6_r && ((env_prev[4]  && ~adder_ctrl) || (prev_adder[4]  && adder_ctrl));
assign adder1_a[5]  = ~env_flag0_6_r && ((env_prev[5]  && ~adder_ctrl) || (prev_adder[5]  && adder_ctrl));
assign adder1_a[6]  = ~env_flag0_6_r && ((env_prev[6]  && ~adder_ctrl) || (prev_adder[6]  && adder_ctrl));
assign adder1_a[7]  = ~env_flag0_6_r && ((env_prev[7]  && ~adder_ctrl) || (prev_adder[7]  && adder_ctrl));
assign adder1_a[8]  = ~env_flag0_6_r && ((env_prev[8]  && ~adder_ctrl) || (prev_adder[8]  && adder_ctrl));
assign adder1_a[9]  = ~env_flag0_6_r && ((env_prev[9]  && ~adder_ctrl) || (prev_adder[9]  && adder_ctrl));
assign adder1_a[10] = ~env_flag0_6_r && ((env_prev[10] && ~adder_ctrl) || (prev_adder[10] && adder_ctrl));
assign adder1_a[11] = ~env_flag0_6_r && ((env_prev[11] && ~adder_ctrl) || (prev_adder[11] && adder_ctrl));
assign adder1_a[12] = ~env_flag0_6_r && ((env_prev[12] && ~adder_ctrl) || (prev_adder[12] && adder_ctrl));
assign adder1_a[13] = ~env_flag0_6_r && ((env_prev[13] && ~adder_ctrl) || (prev_adder[13] && adder_ctrl));
assign adder1_a[14] = ~env_flag0_6_r && ((env_prev[14] && ~adder_ctrl) || (prev_adder[14] && adder_ctrl));
assign adder1_a[15] = ~env_flag0_6_r && ((env_prev[15] && ~adder_ctrl) || (prev_adder[15] && adder_ctrl));
assign adder1_a[16] = ~env_flag0_6_r && ((env_prev[16] && ~adder_ctrl) || (prev_adder[16] && adder_ctrl));
assign adder1_a[17] = ~env_flag0_6_r && ((env_prev[17] && ~adder_ctrl) || (prev_adder[17] && adder_ctrl));
assign adder1_a[18] = ~env_flag0_6_r && ((env_prev[18] && ~adder_ctrl) || (prev_adder[18] && adder_ctrl));
assign adder1_a[19] = ~env_flag0_6_r && ((env_prev[19] && ~adder_ctrl) || (prev_adder[19] && adder_ctrl));
assign adder1_a[20] = ~env_flag0_6_r && ((env_prev[20] && ~adder_ctrl) || (prev_adder[20] && adder_ctrl));
assign adder1_a[21] = ~env_flag0_6_r && ((env_prev[21] && ~adder_ctrl) || (prev_adder[21] && adder_ctrl));
assign adder1_a[22] = ~env_flag0_6_r && ((env_prev[22] && ~adder_ctrl) || (prev_adder[22] && adder_ctrl));
assign adder1_a[23] = ~env_flag0_6_r && ((env_prev[23] && ~adder_ctrl) || (prev_adder[23] && adder_ctrl));
assign adder1_a[24] = ~env_flag0_6_r && ((env_prev[24] && ~adder_ctrl) || (prev_adder[24] && adder_ctrl));
assign adder1_a[25] = ~(~env_flag0_6_r && ~((env_prev[25] && ~adder_ctrl) || (prev_adder[25] && adder_ctrl)));
assign adder1_a[26] = ~env_flag0_6_r && ((env_prev[26] && ~adder_ctrl) || (prev_adder[26] && adder_ctrl));
assign adder1_a[27] = ~env_flag0_6_r && ((env_prev[27] && ~adder_ctrl) || (prev_adder[27] && adder_ctrl));

assign adder1_b_invert = env_speed_some_high && env_speed_r[7];

// Exponential table!
wire [20:0] adder1_b;
assign adder1_b[0] = ~(((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && ~env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3] && adder1_b_invert) || (~((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && ~env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) && ~(adder1_b_invert)));
assign adder1_b[1] = ~(((((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && ~env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && ~env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3])) && adder1_b_invert) || (~(((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && ~env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && ~env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3])) && ~(adder1_b_invert)));
assign adder1_b[2] = ~((((~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || ((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && ~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && ~env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && ~env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3])) && adder1_b_invert) || (~((~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || ((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && ~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && ~env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && ~env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3])) && ~(adder1_b_invert)));
assign adder1_b[3] = ~(((((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && ~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && ~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && ~env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && ~env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3])) && adder1_b_invert) || (~(((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && ~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && ~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && ~env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && ~env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3])) && ~(adder1_b_invert)));
assign adder1_b[4] = ~((((0 && ~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || ((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && ~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && ~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && ~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && ~env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && ~env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3])) && adder1_b_invert) || (~((0 && ~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || ((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && ~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && ~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && ~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && ~env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && ~env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3])) && ~(adder1_b_invert)));
assign adder1_b[5] = ~((~(~env_speed_some_high || ~(((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && ~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && ~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && ~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && ~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && ~env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (~env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]))) && adder1_b_invert) || ((~env_speed_some_high || ~(((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && ~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && ~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && ~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && ~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && ~env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (~env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]))) && ~(adder1_b_invert)));
assign adder1_b[6] = ~(((((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && ~env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && ~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && ~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && ~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && ~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (~env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3])) && adder1_b_invert) || (~(((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && ~env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && ~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && ~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && ~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && ~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (~env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3])) && ~(adder1_b_invert)));
assign adder1_b[7] = ~(((((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && ~env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && ~env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && ~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && ~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && ~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3])) && adder1_b_invert) || (~(((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && ~env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && ~env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && ~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && ~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && ~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3])) && ~(adder1_b_invert)));
assign adder1_b[8] = ~(((((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && ~env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && ~env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && ~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && ~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3])) && adder1_b_invert) || (~(((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && ~env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && ~env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && ~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && ~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (~env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3])) && ~(adder1_b_invert)));
assign adder1_b[9] = ~(((((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && ~env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && ~env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && ~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3])) && adder1_b_invert) || (~(((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && ~env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && ~env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && ~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3])) && ~(adder1_b_invert)));
assign adder1_b[10] = ~(((((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && ~env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && ~env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3])) && adder1_b_invert) || (~(((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && ~env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && ~env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (~env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3])) && ~(adder1_b_invert)));
assign adder1_b[11] = ~(((((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && ~env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (~env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3])) && adder1_b_invert) || (~(((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && ~env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (~env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3])) && ~(adder1_b_invert)));
assign adder1_b[12] = ~(((((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (~env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && env_speed_r[3])) && adder1_b_invert) || (~(((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (~env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && env_speed_r[3])) && ~(adder1_b_invert)));
assign adder1_b[13] = ~(((((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3])) && adder1_b_invert) || (~(((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3])) && ~(adder1_b_invert)));
assign adder1_b[14] = ~(((((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3])) && adder1_b_invert) || (~(((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (env_speed_r[6] && ~env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3])) && ~(adder1_b_invert)));
assign adder1_b[15] = ~(((((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3])) && adder1_b_invert) || (~(((~(~env_speed_r[2] || env_speed_r[1]) || env_speed_r[0]) && env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3])) && ~(adder1_b_invert)));
assign adder1_b[16] = ~((((((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (0 && env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3])) && adder1_b_invert) || (~((((~env_speed_r[2] && ~env_speed_r[1] && env_speed_r[0]) || ~((~env_speed_r[2] && env_speed_r[0]) || ~env_speed_r[1])) && env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3]) || (env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (0 && env_speed_r[6] && ~env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3])) && ~(adder1_b_invert)));
assign adder1_b[17] = ~((((~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3])) && adder1_b_invert) || (~((~(~env_speed_r[2] && ~env_speed_r[1]) && ~env_speed_r[0] && env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3]) || (env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && ~env_speed_r[3])) && ~(adder1_b_invert)));
assign adder1_b[18] = ~((((((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3])) && adder1_b_invert) || (~((((env_speed_r[2] && ~env_speed_r[1] && ~env_speed_r[0]) || ~(~env_speed_r[1] || ~env_speed_r[0])) && env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3]) || (env_speed_r[6] && env_speed_r[5] && ~env_speed_r[4] && env_speed_r[3])) && ~(adder1_b_invert)));
assign adder1_b[19] = ~((((env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3])) && adder1_b_invert) || (~((env_speed_r[2] && ~(~env_speed_r[1] && ~env_speed_r[0]) && env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) || (env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && ~env_speed_r[3])) && ~(adder1_b_invert)));
assign adder1_b[20] = ~((env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && env_speed_r[3] && adder1_b_invert) || (~(env_speed_r[6] && env_speed_r[5] && env_speed_r[4] && env_speed_r[3]) && ~(adder1_b_invert)));

wire [27:0] adder1_o;
wire adder1_co;
assign {adder1_co, adder1_o} = adder1_b_invert + adder1_a + {{7{adder1_b_invert}}, adder1_b}

assign adder_tmp_1 = UNK_75_IN && should_fire_irq;

wire [27:0] adder1_or;
assign adder1_or[19:0] = adder1_o[19:0] && ~{20{adder_tmp_1}};
assign adder1_or[27:20] = (adder1_o[27:20] && ~{8{adder_tmp_1}}) || (env_dest_r[7:0] && {8{adder_tmp_1}});

reg [27:0] prev_adder;
always @(posedge cycle_odd) begin
  prev_adder <= adder1_or;
end



// =============================================================================
// Write the envelope result to RAM IC13

wire [31:0] ric13_out;
assign ric13_out[31:28] = 4'b0;

always @(*) begin
  if (!cycle_7)
    ric13_out[27:0] <= adder1_or;
end

// Output in sequence the adder result
assign RIC13_D_OUT =
      ram12_addr_low[1:0] == 2'd0 ? ric13_out[7:0]   :
      ram12_addr_low[1:0] == 2'd2 ? ric13_out[15:8]  :
      ram12_addr_low[1:0] == 2'd1 ? ric13_out[23:16] :
      ram12_addr_low[1:0] == 2'd3 ? ric13_out[27:24] :
      8'd0;

// Output on sub address 12/13/14/15
assign RIC13_D_IOM = UNK_74_IN && ~(ric12_ac0_stage && ram12_addr_low[2]);



// =============================================================================
// Controls the output to IC8 (pins 2-8)

wire [7:0] adder3_o;
wire adder3_co;
assign {adder3_co, adder3_o} = adder1_a[27:20] + env_param_7 + 8'd1;

// Output in sequence the low and high part
assign path257_volout_1_unsync = ~(ram12_addr_low[0] ? (adder3_o[1]                ) : (adder1_a[14] ));
assign path256_volout_2_unsync = ~(ram12_addr_low[0] ? (~adder3_o[2]               ) : (~adder1_a[15]));
assign path255_volout_3_unsync = ~(ram12_addr_low[0] ? (adder3_o[3]                ) : (adder1_a[16] ));
assign path270_volout_4_unsync = ~(ram12_addr_low[0] ? (~(adder3_co && adder3_o[4])) : (~adder1_a[17]));
assign path269_volout_5_unsync = ~(ram12_addr_low[0] ? (adder3_co && adder3_o[5]   ) : (adder1_a[18] ));
assign path268_volout_6_unsync = ~(ram12_addr_low[0] ? (adder3_co && adder3_o[6]   ) : (adder1_a[19] ));
assign path267_volout_7_unsync = ~(ram12_addr_low[0] ? (~(adder3_co && adder3_o[7])) : (~adder3_o[0] ));

// volout_1 => IC19_2_IN
// volout_2 => IC19_3_IN
// volout_3 => IC19_4_IN
// volout_4 => IC19_5_IN
// volout_5 => IC19_7_IN
// volout_6 => IC19_6_IN
// volout_7 => IC19_1_IN

always @(*) begin
  if (!SYNC_IN) begin
    volout_7 <= path267_volout_7_unsync;
    volout_6 <= path268_volout_6_unsync;
    volout_5 <= path269_volout_5_unsync;
    volout_4 <= path270_volout_4_unsync;
    volout_3 <= path255_volout_3_unsync;
    volout_2 <= path256_volout_2_unsync;
    volout_1 <= path257_volout_1_unsync;
  end
end


endmodule
