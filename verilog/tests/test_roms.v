module test;
   reg [17:0] addr;
   wire [7:0] data_10;
   wire [7:0] data_11;
   wire [7:0] data_5;
   wire [7:0] data_6;
   wire [7:0] data_7;

   ROM_IC10 ic10 (
      .addr(addr),
      .data(data_10)
   );
   ROM_IC11 ic11 (
      .addr(addr),
      .data(data_11)
   );
   ROM_IC5 ic5 (
      .addr(addr),
      .data(data_5)
   );
   ROM_IC6 ic6 (
      .addr(addr),
      .data(data_6)
   );
   ROM_IC7 ic7 (
      .addr(addr),
      .data(data_7)
   );

   initial begin
      addr = 11'd0;
      # 17 addr = 11'd0;
      # 11 addr = 11'd1;
      # 29 addr = 11'd2;
      # 11 addr = 11'd3;
      # 100 $stop;
   end

   initial begin
      $monitor("%0t, addr = %0d, data = %0h %0h %0h %0h %0h", $time, addr, data_10, data_11, data_5, data_6, data_7);
   end
endmodule
