module test();

reg [3:0] param;
reg [8:0] result;
initial begin
  param = 8'd0;
  for (integer i = 0; i < 16; i++) begin
    param = i[3:0];
    result[0] = ~(~(~param[3] && ~param[2] && param[1] && param[0]) && ~(~param[3] && param[2] && param[1] && ~param[0]) && ~(param[3] && ~param[2] && ~param[1] && param[0]) && ~(param[3] && ~param[2] && param[1] && param[0]) && ~(param[3] && param[2] && ~param[1] && ~param[0]) && ~(param[3] && param[2] && param[1] && param[0]));
    result[1] = ~(1 && ~(~param[3] && param[2] && ~param[1] && param[0]) && ~(~param[3] && param[2] && param[1] && param[0]) && ~(param[3] && ~param[2] && ~param[1] && param[0]) && ~(param[3] && ~param[2] && param[1] && ~param[0]) && ~(param[3] && param[2] && ~param[1] && param[0]) && ~(param[3] && param[2] && param[1] && ~param[0]) && ~(param[3] && param[2] && param[1] && param[0]));
    result[2] = ~(1 && ~(~param[3] && ~param[2] && param[1] && param[0]) && ~(~param[3] && param[2] && ~param[1] && param[0]) && ~(~param[3] && param[2] && param[1] && ~param[0]) && ~(~param[3] && param[2] && param[1] && param[0]) && ~(param[3] && ~param[2] && param[1] && ~param[0]) && ~(param[3] && param[2] && ~param[1] && ~param[0]) && ~(param[3] && param[2] && param[1] && ~param[0]));
    result[3] = ~(1 && ~(~param[3] && ~param[2] && param[1] && param[0]) && ~(~param[3] && param[2] && param[1] && ~param[0]) && ~(param[3] && ~param[2] && ~param[1] && param[0]) && ~(param[3] && param[2] && ~param[1] && ~param[0]) && ~(param[3] && param[2] && ~param[1] && param[0]));
    result[4] = ~(~(~param[3] && param[2] && ~param[1] && param[0]) && ~(param[3] && ~param[2] && ~param[1] && param[0]) && ~(param[3] && ~param[2] && param[1] && ~param[0]) && ~(param[3] && ~param[2] && param[1] && param[0]));
    result[5] = ~(~(~param[3] && ~param[2] && ~param[1] && ~param[0]) && ~(~param[3] && ~param[2] && param[1] && ~param[0]) && ~(~param[3] && param[2] && ~param[1] && param[0]) && ~(~param[3] && param[2] && param[1] && ~param[0]) && ~(~param[3] && param[2] && param[1] && param[0]) && ~(param[3] && ~param[2] && ~param[1] && ~param[0]));
    result[6] = ~(~(~param[3] && ~param[2] && ~param[1] && ~param[0]) && ~(~param[3] && ~param[2] && param[1] && ~param[0]) && ~(~param[3] && ~param[2] && param[1] && param[0]) && ~(~param[3] && param[2] && ~param[1] && ~param[0]));
    result[7] = ~(~(~param[3] && ~param[2] && ~param[1] && ~param[0]) && ~(~param[3] && ~param[2] && ~param[1] && param[0]));
    result[8] = ~param[3] && ~param[2] && ~param[1] && ~param[0];
    $display("%x", result);
  end
end

endmodule
