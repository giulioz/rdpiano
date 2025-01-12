`timescale 1ns/100ps

module ROM_IC11 (
  input wire [12:0] addr,
  output reg [7:0] data
);
  reg [7:0] ic11_memory [0:8191];
  initial begin
    $readmemh("../roms/RD200_C_desc.hex", ic11_memory);
  end

  always @(*) begin
    data <= ic11_memory[addr];
  end
endmodule
module ROM_IC10 (
  input wire [10:0] addr,
  output reg [7:0] data
);
  reg [7:0] ic10_memory [0:2047];
  initial begin
    $readmemh("../roms/RD200_IC10_desc.hex", ic10_memory);
  end

  always @(*) begin
    data <= ic10_memory[addr];
  end
endmodule

module test;
   reg running;

   // Xtal
   reg XTAL_IN;
   initial begin
      running = 1;
      XTAL_IN = 0;
      while (running)
         #1 XTAL_IN = ~XTAL_IN;
   end

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
      RAM12_OE_OUT // active low
   );

   // SRAM IC13
   wire [7:0] RAM13_D_IN;
   wire [7:0] RAM13_D_OUT;
   wire [10:0] RAM13_A_OUT;
   wire RAM13_WR_OUT;
   wire RAM13_OE_OUT;
   wire RAM13_D_IOM;
   Sram ic13 (
      RAM13_A_OUT,
      RAM13_D_OUT,
      RAM13_D_IN,
      RAM13_WR_OUT, // write on low
      RAM13_OE_OUT // active low
   );

   // ROM IC11
   wire [7:0] ROM11_D_IN;
   wire [12:0] ROM11_A_OUT;
   ROM_IC11 ic11 (
      .addr(ROM11_A_OUT),
      .data(ROM11_D_IN)
   );

   // ROM IC10
   wire [7:0] ROM10_D_IN;
   wire [10:0] ROM10_A_OUT;
   ROM_IC10 ic10 (
      .addr(ROM10_A_OUT),
      .data(ROM10_D_IN)
   );

   // Mock wave roms
   wire [7:0] R5_D_IN;
   wire [7:0] R6_D_IN;
   wire [7:0] R7_D_IN;
   assign R5_D_IN = 8'h00;
   assign R6_D_IN = 8'h00;
   assign R7_D_IN = 8'h00;


   // Comm between chips
   wire [16:0] WR_A_OUT;
   wire IPT1_OUT, IPT2_OUT, IPT0_OUT;
   wire IO2_OUT, IO3_OUT, IO4_OUT, IO5_OUT, IO6_OUT, IO7_OUT, IO8_OUT;
   
   // Outputs
   wire MPX1_OUT, MPX2_OUT;
   wire [15:0] DAC_OUT;

   // CPU devices
   wire RD_OUT, WR_OUT, PARAM_ROMCS_OUT, RAMCS_OUT;
   wire [7:0] AL_OUT;
   wire AL0_IOM;
   wire P1_TOVERFLOW_OUT; // unused
   
   // CPU logic
   reg E_IN, RW_IN, RESET_IN, AS_IN;
   wire IRQ_OUT;
   wire [7:0] CPU_P3_IN;
   wire [7:0] CPU_P3_OUT;
   wire CPU_P3_IOM;
   wire [7:0] CPU_P4_IN;

   // CPU mock
   reg [15:0] currentAddr;
   reg [8:0] currentData;
   assign CPU_P4_IN = currentAddr[15:8];
   assign CPU_P3_IN = AS_IN ? currentAddr[7:0] : currentData;

   initial begin
      running = 1;

      RESET_IN = 1;
      E_IN = 1;
      RW_IN = 1;
      AS_IN = 1;

      #10 RESET_IN = 0;
      #2 E_IN = 0;
      #2 E_IN = 1;
      #10 RESET_IN = 1;

      // while (running) begin
      //    #2 E_IN = 0;
      //    #2 AS_IN = 1;
      //    #2 AS_IN = 0;
      //    #2 E_IN = 1;
      // end

      RW_IN = 0;
      currentAddr = 16'h1000;
      currentData = 8'h6C;
      #2 E_IN = 0;
      #2 AS_IN = 1;
      #2 AS_IN = 0;
      #2 E_IN = 1;
      RW_IN = 1;

      RW_IN = 0;
      currentAddr = 16'h1001;
      currentData = 8'h01;
      #2 E_IN = 0;
      #2 AS_IN = 1;
      #2 AS_IN = 0;
      #2 E_IN = 1;
      RW_IN = 1;

      RW_IN = 0;
      currentAddr = 16'h1002;
      currentData = 8'h10;
      #2 E_IN = 0;
      #2 AS_IN = 1;
      #2 AS_IN = 0;
      #2 E_IN = 1;
      RW_IN = 1;
      
      RW_IN = 0;
      currentAddr = 16'h1003;
      currentData = 8'h00;
      #2 E_IN = 0;
      #2 AS_IN = 1;
      #2 AS_IN = 0;
      #2 E_IN = 1;
      RW_IN = 1;
      
      RW_IN = 0;
      currentAddr = 16'h1004;
      currentData = 8'hDF;
      #2 E_IN = 0;
      #2 AS_IN = 1;
      #2 AS_IN = 0;
      #2 E_IN = 1;
      RW_IN = 1;
      
      RW_IN = 0;
      currentAddr = 16'h1005;
      currentData = 8'h7F;
      #2 E_IN = 0;
      #2 AS_IN = 1;
      #2 AS_IN = 0;
      #2 E_IN = 1;
      RW_IN = 1;

      #40000 running = 0;
   end


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
      .RIC12_WE_OUT(RAM12_WE_OUT),

      .RIC13_D_IN(RAM13_D_IN),
      .RIC13_D_OUT(RAM13_D_OUT),
      .RIC13_D_IOM(RAM13_D_IOM),

      .IO2_OUT(IO2_OUT), // 2
      .IO3_OUT(IO3_OUT), // 3
      .IO4_OUT(IO4_OUT), // 4
      .IO5_OUT(IO5_OUT), // 5
      .IO6_OUT(IO6_OUT), // 6
      .IO7_OUT(IO7_OUT), // 7
      .IO8_OUT(IO8_OUT)  // 8
   );

   IC9 ic9 (
      .XTAL_IN(XTAL_IN),
      .SYNCO_OUT(SYNC),
      .SYNC_IN(SYNC),
      .FSYNC_IN(FSYNC),

      .RAM_D_IN(RAM13_D_IN),
      .RAM_D_OUT(RAM13_D_OUT),
      .RAM_D_IOM(RAM13_D_IOM),
      .RAM_A_OUT(RAM13_A_OUT),
      .RAM_OE_OUT(RAM13_OE_OUT),
      .RAM_WR_OUT(RAM13_WR_OUT),

      .ROM_A_OUT(ROM11_A_OUT),
      .ROM_D_IN(ROM11_D_IN),

      .BUS_IN(RAM12_D_OUT),
      
      .WR_A_OUT(WR_A_OUT),

      .IPT1_OUT(IPT1_OUT), // 36
      .IPT2_OUT(IPT2_OUT), // 37
      .IPT0_OUT(IPT0_OUT)  // 38
   );

   IC8 ic8 (
      .SYNC_IN(SYNC),
      .FSYNC_IN(FSYNC),
      .FSYNC_OUT(FSYNC),

      .SR_SEL_IN(1'b0),
      .MPX1_IN(MPX1_OUT),
      .MPX1_OUT(MPX1_OUT),
      .MPX2_OUT(MPX2_OUT),
      .MPX1_IOM(1'b1),

      .AG1_IN(IPT1_OUT), // 71
      .AG2_IN(IPT2_OUT), // 70
      .AG3_IN(IPT0_OUT), // 69

      .IC19_1_IN(IO2_OUT), // 3
      .IC19_2_IN(IO4_OUT), // 2
      .IC19_3_IN(IO4_OUT), // 1
      .IC19_4_IN(IO5_OUT), // 80
      .IC19_5_IN(IO6_OUT), // 79
      .IC19_6_IN(IO7_OUT), // 78
      .IC19_7_IN(IO8_OUT), // 77

      .R5_D_IN(R5_D_IN),
      .R6_D_IN(R6_D_IN),
      .R7_D_IN(R7_D_IN),

      .R10_D_IN(ROM10_D_IN),
      .R10_A_OUT(ROM10_A_OUT),

      .DAC_OUT(DAC_OUT)
   );

   initial begin
      // $monitor(
      //    "%d %d", MPX1_OUT, DAC_OUT
      // );
      $monitor(
         "%d", WR_A_OUT
      );
   end
endmodule
