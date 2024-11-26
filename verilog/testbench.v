`timescale 1ns/100ps

module test;
   reg running;

   // Mock for IC8/9, sync signals
   wire FSYNC_IN;
   reg SYNC_IN;
   FSYNC_Gen fsync_gen(SYNC_IN, FSYNC_IN);
   initial begin
      running = 1;
      SYNC_IN = 1;
      while (running)
         #1 SYNC_IN = ~SYNC_IN;
   end


   // RAM & I/O busses
   wire [7:0] RIC12_D_IN;
   wire [7:0] RIC12_D_OUT;
   wire [7:0] RIC13_D_IN;
   wire [7:0] RIC13_D_OUT;

   // SRAM IC12
   wire [10:0] ic12_address;
   wire [7:0] ic12_data;
   wire ic12_write_enable;
   wire ic12_output_enable;
   Sram ic12 (
      ic12_address,
      ic12_data,
      ic12_write_enable, // write on low
      ic12_output_enable // active low
   );
   assign ic12_data = RIC12_D_IOM ? RIC12_D_IN : RIC12_D_OUT;

   // CPU interface
   reg [15:0] currentAddr;
   reg E_IN, RW_IN, RESET_IN, AS_IN;
   reg [7:0] CPU_P3_IN;
   reg [7:0] CPU_P4_IN;
   wire [7:0] CPU_P3_OUT;
   wire [7:0] AL_OUT;

   // debug
   wire [3:0] COUNTER_OUT_C13;
   wire [3:0] COUNTER_OUT_F13;

   IC19 ic19 (
      .E_NOR_77_IN(1'b1),
      .AL_CT_76_IN(1'b1),
      .UNK_75_IN(1'b1),
      .UNK_74_IN(1'b1),
      .P1_TOVERFLOW(P1_TOVERFLOW),

      .FSYNC_IN(FSYNC_IN),
      .SYNC_IN(SYNC_IN),

      .E_IN(E_IN),
      .RW_IN(RW_IN),
      .IRQ_OUT(IRQ_OUT),
      .RESET_IN(RESET_IN),
      .AS_IN(AS_IN),

      .CPU_P3_IN(CPU_P3_IN),
      .CPU_P3_OUT(CPU_P3_OUT),
      .CPU_P3_IOM(CPU_P3_IOM),

      .CPU_P4_IN(CPU_P4_IN),
      .AL_IN(AL_OUT),
      .AL_OUT(AL_OUT),
      .AL0_IOM(AL0_IOM),

      .RD_OUT(RD_OUT),
      .WR_OUT(WR_OUT),
      .PARAM_ROMCS_OUT(PARAM_ROMCS_OUT),
      .RAMCS_OUT(RAMCS_OUT),

      .RIC12_D_IN(RIC12_D_IN),
      .RIC12_D_OUT(RIC12_D_OUT),
      .RIC12_D_IOM(RIC12_D_IOM),
      .RIC12_A_OUT(ic12_address),
      .RIC12_OE_OUT(ic12_output_enable),
      .RIC12_WE_OUT(ic12_write_enable),

      .RIC13_D_IN(8'b0),
      .RIC13_D_OUT(RIC13_D_OUT),
      .RIC13_D_IOM(RIC13_D_IOM),

      .IO2_OUT(IO2_OUT),
      .IO3_OUT(IO3_OUT),
      .IO4_OUT(IO4_OUT),
      .IO5_OUT(IO5_OUT),
      .IO6_OUT(IO6_OUT),
      .IO7_OUT(IO7_OUT),
      .IO8_OUT(IO8_OUT),

      .COUNTER_OUT_C13(COUNTER_OUT_C13),
      .COUNTER_OUT_F13(COUNTER_OUT_F13)
   );

   initial begin
      running = 1;

      RESET_IN = 1;
      E_IN = 1;
      RW_IN = 1;
      AS_IN = 1;
      CPU_P3_IN = 8'h0;
      CPU_P4_IN = 8'h0;

      #10 RESET_IN = 0;
      #2 E_IN = 0;
      #2 E_IN = 1;
      #10 RESET_IN = 1;

      while (running) begin
         #2 E_IN = 0;
         #2 AS_IN = 1;
         #2 {CPU_P4_IN, CPU_P3_IN} = currentAddr;
         #2 AS_IN = 0;
         #2 E_IN = 1;
      end
   end

   initial begin
      currentAddr = 16'hffff;
      #40

      #40 currentAddr = 16'hc000;
      #40 currentAddr = 16'h1005;
      #40 currentAddr = 16'hc000;
      #40 currentAddr = 16'h2000;

      #100 running = 0;
   end

   // initial begin
   //    $monitor(
   //       "addr=%04h al=%02h wr=%d rd=%d",
   //       currentAddr, AL_OUT, WR_OUT, RD_OUT
   //    );
   // end

   initial begin
      $monitor(
         "addr=%04h al=%02h ic12_addr=%04x ic12_oe=%d ic12_we=%d C13=%d F13=%d sync=%d fsync=%d",
         // "addr=%04h al=%02h ic12_addr=%04x ic12_oe=%d ic12_we=%d",
         currentAddr, AL_OUT, ic12_address, ic12_output_enable, ic12_write_enable,
         COUNTER_OUT_C13, COUNTER_OUT_F13, SYNC_IN, FSYNC_IN
      );
   end
endmodule
