module FSYNC_Gen(input clk, output reg fsync);
  reg[31:0] counter=32'd0;
  parameter DIVISOR = 32'd2666;
  always @(posedge clk) begin
   counter <= counter + 32'd1;
   if(counter>=(DIVISOR-1))
     counter <= 32'd0;
  end
  assign fsync = ~((counter==DIVISOR/2) ? 1'b1:1'b0);
endmodule
