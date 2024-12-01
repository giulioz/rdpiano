module test_mult;
  reg [28:0] n1;
  reg [28:0] n2;
  wire [28:0] output;

  initial begin
    addr = 11'd0;
    # 17 addr = 11'd0;
    # 11 addr = 11'd1;
    # 29 addr = 11'd2;
    # 11 addr = 11'd3;
    # 100 $stop;
  end

  initial begin
  $moni tor("%0t, addr = %0d, data = %0h %0h %0h %0h %0h", $time, addr, data_10, data_11, data_5, data_6, data_7);
  end

endmodule
