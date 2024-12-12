`timescale 1ns/100ps

module CPUB_ICs (
   input wire XTAL_IN_12, // 12.8 MHz
   input wire XTAL_IN_8, // 8 MHz

   // CPU devices
   output wire RD_OUT, WR_OUT, PARAM_ROMCS_OUT, RAMCS_OUT,
   output wire [7:0] AL_OUT,
   output wire AL0_IOM,
   output wire P1_TOVERFLOW_OUT, // unused
   
   // CPU logic
   // input wire E_IN, // 2 MHz
   // input wire RW_IN, RESET_IN, AS_IN,
   // output wire IRQ_OUT,
   // input wire [7:0] CPU_P3_IN,
   // output wire [7:0] CPU_P3_OUT,
   // output wire CPU_P3_IOM,
   // input wire [7:0] CPU_P4_IN,

   input wire RESET_IN,
   input wire shouldWrite,
   output reg writeDone,
   input wire [15:0] writeAddress,
   input wire [15:0] writeData,

   // Audio
   output wire MPX1_OUT,
   output wire MPX2_OUT,
   output wire [15:0] DAC_OUT,

   // Debug
   reg [7:0] mem_ic12 [0:2047],
   reg [7:0] mem_ic13 [0:2047],
   reg [7:0] ic10_memory [0:2047],
   reg [7:0] ic11_memory [0:8191],
   reg [7:0] ic5_memory [0:131071],
   reg [7:0] ic6_memory [0:131071],
   reg [7:0] ic7_memory [0:131071],

   input wire [16:0] WR_A_OUT
);
   wire [7:0] CPU_P3_IN;
   wire [7:0] CPU_P3_OUT;
   wire CPU_P3_IOM;
   wire [7:0] CPU_P4_IN;
   CPUMock cpumock (
      .XTAL_IN(XTAL_IN_8),
      .RESET_IN(RESET_IN),
      .E_IN(E_IN),
      .RW(RW_IN),
      .AS(AS_IN),
      .IRQ(IRQ_OUT),
      .DATA_ADDR_LOW(CPU_P3_IN),
      .AD_HIGH(CPU_P4_IN),
      .shouldWrite(shouldWrite),
      .writeDone(writeDone),
      .writeAddress(writeAddress),
      .writeData(writeData)
   );

   // initial begin
   //    $monitor(
   //       "shouldWrite=%d writeDone=%d RD=%h WR=%h PARAM_ROMCS=%h RAMCS=%h CPU_BUS=%h %h", shouldWrite, writeDone, RD_OUT, WR_OUT, PARAM_ROMCS_OUT, RAMCS_OUT, CPU_P4_IN, CPU_P3_IN
   //    );
   // end


   // SYNC
   wire FSYNC, SYNC;

   // SRAM IC12
   wire [7:0] RAM12_D_IN;
   wire [7:0] RAM12_D_OUT;
   wire [10:0] RAM12_A_OUT;
   wire RAM12_WR_OUT;
   wire RAM12_OE_OUT;
   wire RAM12_D_IOM;
   Sram ic12 (
      RAM12_A_OUT,
      RAM12_D_OUT,
      RAM12_D_IN,
      RAM12_WR_OUT, // write on low
      RAM12_OE_OUT, // active low
      mem_ic12
   );

   // always @(posedge RAM12_WR_OUT) begin
   //    $display("%h %h", RAM12_A_OUT, RAM12_D_OUT);
   // end
   // initial begin
   //    $monitor(
   //       "%h", RAM12_A_OUT
   //    );
   // end

   // SRAM IC13
   wire [7:0] RAM13_D_IN;
   wire [7:0] RAM13_D_OUT;
   wire [10:0] RAM13_A_OUT;
   wire RAM13_WR_OUT;
   wire RAM13_OE_OUT;
   Sram ic13 (
      RAM13_A_OUT,
      RAM13_D_OUT,
      RAM13_D_IN,
      RAM13_WR_OUT, // write on low
      RAM13_OE_OUT, // active low
      mem_ic13
   );

   // initial begin
   //    $monitor(
   //       "%h %h %h", mem_ic13[0], mem_ic13[1], mem_ic13[2]
   //    );
   // end

   // ROM IC11
   wire [7:0] ROM11_D_IN;
   wire [12:0] ROM11_A_OUT;
   assign ROM11_D_IN = ic11_memory[ROM11_A_OUT];
   // ROM_IC11 ic11 (
   //    .addr(ROM11_A_OUT),
   //    .data(ROM11_D_IN)
   // );

   // ROM IC10
   wire [7:0] ROM10_D_IN;
   wire [10:0] ROM10_A_OUT;
   assign ROM10_D_IN = ic10_memory[ROM10_A_OUT];
   // ROM_IC10 ic10 (
   //    .addr(ROM10_A_OUT),
   //    .data(ROM10_D_IN)
   // );

   // ROM IC5
   wire [7:0] ROM5_D_IN;
   assign ROM5_D_IN = ic5_memory[WR_A_OUT];
   // ROM_IC5 ic5 (
   //    .addr(WR_A_OUT),
   //    .data(ROM5_D_IN)
   // );
   // ROM IC6
   wire [7:0] ROM6_D_IN;
   assign ROM6_D_IN = ic6_memory[WR_A_OUT];
   // ROM_IC6 ic6 (
   //    .addr(WR_A_OUT),
   //    .data(ROM6_D_IN)
   // );
   // ROM IC7
   wire [7:0] ROM7_D_IN;
   assign ROM7_D_IN = ic7_memory[WR_A_OUT];
   // ROM_IC7 ic7 (
   //    .addr(WR_A_OUT),
   //    .data(ROM7_D_IN)
   // );

   // Comm between chips
   wire [16:0] WR_A_OUT2;
   // wire [16:0] WR_A_OUT;
   wire IPT1_OUT, IPT2_OUT, IPT0_OUT;
   wire IO2_OUT, IO3_OUT, IO4_OUT, IO5_OUT, IO6_OUT, IO7_OUT, IO8_OUT;
   wire [7:0] RIC13_OUT_IC19;
   wire [7:0] RIC13_OUT_IC9;
   wire RIC13_OUT_IC19_OE;
   wire RIC13_OUT_IC9_OE;
   assign RAM13_D_OUT = ~RIC13_OUT_IC9_OE ? RIC13_OUT_IC9 : ~RIC13_OUT_IC19_OE? RIC13_OUT_IC19 : 8'dzz;

   IC19 ic19 (
      .E_NOR_77_IN(1'b1),
      .AL_CT_76_IN(1'b1),
      .UNK_75_IN(1'b1),
      .UNK_74_IN(1'b1),
      .P1_TOVERFLOW_OUT(P1_TOVERFLOW_OUT),

      .FSYNC_IN(FSYNC),
      .SYNC_IN(SYNC),

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

      .RIC12_D_IN(RAM12_D_IN),
      .RIC12_D_OUT(RAM12_D_OUT),
      .RIC12_D_IOM(RAM12_D_IOM),
      .RIC12_A_OUT(RAM12_A_OUT),
      .RIC12_OE_OUT(RAM12_OE_OUT),
      .RIC12_WE_OUT(RAM12_WR_OUT),

      .RIC13_D_IN(RAM13_D_IN),
      .RIC13_D_OUT(RIC13_OUT_IC19),
      .RIC13_D_IOM(RIC13_OUT_IC19_OE),

      .IO2_OUT(IO2_OUT), // 2
      .IO3_OUT(IO3_OUT), // 3
      .IO4_OUT(IO4_OUT), // 4
      .IO5_OUT(IO5_OUT), // 5
      .IO6_OUT(IO6_OUT), // 6
      .IO7_OUT(IO7_OUT), // 7
      .IO8_OUT(IO8_OUT)  // 8
   );

   IC9 ic9 (
      .XTAL_IN(XTAL_IN_12),
      .SYNCO_OUT(SYNC),
      .SYNC_IN(SYNC),
      .FSYNC_IN(FSYNC),

      .RAM_D_IN(RAM13_D_IN),
      .RAM_D_OUT(RIC13_OUT_IC9),
      .RAM_D_IOM(RIC13_OUT_IC9_OE),
      .RAM_A_OUT(RAM13_A_OUT),
      .RAM_OE_OUT(RAM13_OE_OUT),
      .RAM_WR_OUT(RAM13_WR_OUT),

      .ROM_A_OUT(ROM11_A_OUT),
      .ROM_D_IN(ROM11_D_IN),

      .BUS_IN(RAM12_D_OUT),
      
      // .WR_A_OUT(WR_A_OUT),
      .WR_A_OUT(WR_A_OUT2),

      .IPT1_OUT(IPT1_OUT), // 36
      .IPT2_OUT(IPT2_OUT), // 37
      .IPT0_OUT(IPT0_OUT)  // 38
   );

   IC8 ic8 (
      .SYNC_IN(SYNC),
      .FSYNC_IN(FSYNC),
      .FSYNC_OUT(FSYNC),

      .SR_SEL_IN(1'b0), // 0: 16 voices, 1: 10 voices
      .MPX1_IN(MPX1_OUT),
      .MPX1_OUT(MPX1_OUT),
      .MPX2_OUT(MPX2_OUT),
      .MPX1_IOM(1'b1),

      .AG1_IN(IPT1_OUT), // 71
      .AG2_IN(IPT2_OUT), // 70
      .AG3_IN(IPT0_OUT), // 69

      .IC19_1_IN(1'b0),//IO2_OUT), // 3
      .IC19_2_IN(1'b0),//IO4_OUT), // 2
      .IC19_3_IN(1'b0),//IO4_OUT), // 1
      .IC19_4_IN(1'b0),//IO5_OUT), // 80
      .IC19_5_IN(1'b0),//IO6_OUT), // 79
      .IC19_6_IN(1'b0),//IO7_OUT), // 78
      .IC19_7_IN(1'b0),//IO8_OUT), // 77

      .R5_D_IN(ROM5_D_IN),
      .R6_D_IN(ROM6_D_IN),
      .R7_D_IN(ROM7_D_IN),

      .R10_D_IN(ROM10_D_IN),
      .R10_A_OUT(ROM10_A_OUT),

      .DAC_OUT(DAC_OUT)
   );
endmodule