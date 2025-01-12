module FSYNC_Gen(input clk, output reg fsync);
  reg [11:0] counter = 12'd2559;
  parameter MAX_CYCLES = 12'd2560;
  always @(posedge clk) begin
   if (counter == MAX_CYCLES)
     counter <= 12'd0;
    else
      counter <= counter + 12'd1;
  end
  assign fsync = ~((counter == MAX_CYCLES-1) ? 1'b1 : 1'b0);
endmodule
