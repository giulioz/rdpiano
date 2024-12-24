module test();

// expdec_lut
// reg [3:0] param;
// reg [8:0] result;
// initial begin
//   param = 8'd0;
//   for (integer i = 0; i < 16; i++) begin
//     param = i[3:0];
//     result[0] = ~(~(~param[3] && ~param[2] && param[1] && param[0]) && ~(~param[3] && param[2] && param[1] && ~param[0]) && ~(param[3] && ~param[2] && ~param[1] && param[0]) && ~(param[3] && ~param[2] && param[1] && param[0]) && ~(param[3] && param[2] && ~param[1] && ~param[0]) && ~(param[3] && param[2] && param[1] && param[0]));
//     result[1] = ~(1 && ~(~param[3] && param[2] && ~param[1] && param[0]) && ~(~param[3] && param[2] && param[1] && param[0]) && ~(param[3] && ~param[2] && ~param[1] && param[0]) && ~(param[3] && ~param[2] && param[1] && ~param[0]) && ~(param[3] && param[2] && ~param[1] && param[0]) && ~(param[3] && param[2] && param[1] && ~param[0]) && ~(param[3] && param[2] && param[1] && param[0]));
//     result[2] = ~(1 && ~(~param[3] && ~param[2] && param[1] && param[0]) && ~(~param[3] && param[2] && ~param[1] && param[0]) && ~(~param[3] && param[2] && param[1] && ~param[0]) && ~(~param[3] && param[2] && param[1] && param[0]) && ~(param[3] && ~param[2] && param[1] && ~param[0]) && ~(param[3] && param[2] && ~param[1] && ~param[0]) && ~(param[3] && param[2] && param[1] && ~param[0]));
//     result[3] = ~(1 && ~(~param[3] && ~param[2] && param[1] && param[0]) && ~(~param[3] && param[2] && param[1] && ~param[0]) && ~(param[3] && ~param[2] && ~param[1] && param[0]) && ~(param[3] && param[2] && ~param[1] && ~param[0]) && ~(param[3] && param[2] && ~param[1] && param[0]));
//     result[4] = ~(~(~param[3] && param[2] && ~param[1] && param[0]) && ~(param[3] && ~param[2] && ~param[1] && param[0]) && ~(param[3] && ~param[2] && param[1] && ~param[0]) && ~(param[3] && ~param[2] && param[1] && param[0]));
//     result[5] = ~(~(~param[3] && ~param[2] && ~param[1] && ~param[0]) && ~(~param[3] && ~param[2] && param[1] && ~param[0]) && ~(~param[3] && param[2] && ~param[1] && param[0]) && ~(~param[3] && param[2] && param[1] && ~param[0]) && ~(~param[3] && param[2] && param[1] && param[0]) && ~(param[3] && ~param[2] && ~param[1] && ~param[0]));
//     result[6] = ~(~(~param[3] && ~param[2] && ~param[1] && ~param[0]) && ~(~param[3] && ~param[2] && param[1] && ~param[0]) && ~(~param[3] && ~param[2] && param[1] && param[0]) && ~(~param[3] && param[2] && ~param[1] && ~param[0]));
//     result[7] = ~(~(~param[3] && ~param[2] && ~param[1] && ~param[0]) && ~(~param[3] && ~param[2] && ~param[1] && param[0]));
//     result[8] = ~param[3] && ~param[2] && ~param[1] && ~param[0];
//     $display("%x", result);
//   end
// end

reg [7:0] ic10_memory [0:2047];
reg [7:0] ic11_memory [0:8191];
reg [15:0] r11;

// adder2_lut
reg wavein_sign;
reg [9:0] r10;
reg [3:0] add_r;
reg [14:0] result;
initial begin
  $readmemh("../roms/RD200_IC10_desc.hex", ic10_memory);

  // for (integer i = 0; i < 1024; i++) begin
  //   r10[1:0] = {ic10_memory[i*2][5], ic10_memory[i*2][3]};
  //   r10[9:2] = {ic10_memory[i*2+1][6], ic10_memory[i*2+1][7], ic10_memory[i*2+1][2], ic10_memory[i*2+1][1],
  //               ic10_memory[i*2+1][4], ic10_memory[i*2+1][0], ic10_memory[i*2+1][5], ic10_memory[i*2+1][3]};
  //   $display("%x", r10);
  // end
  
  // $readmemh("../roms/RD200_C_desc.hex", ic11_memory);
  // for (integer i = 0; i < 8192/2; i++) begin
  //   r11 = 16'd0;
  //   // r11[7:0] = ic11_memory[i*2+0];
  //   // r11[15:8] = ic11_memory[i*2+1];

  //   r11[13:0] = {
  //     ic11_memory[i*2+1][3],
  //     ic11_memory[i*2+1][4],
  //     ic11_memory[i*2+1][6],
  //     ic11_memory[i*2+1][2],
  //     ic11_memory[i*2+1][1],
  //     ic11_memory[i*2+1][2],

  //     ic11_memory[i*2+0][7],
  //     ic11_memory[i*2+0][0],
  //     ic11_memory[i*2+0][5],
  //     ic11_memory[i*2+0][3],
  //     ic11_memory[i*2+0][4],
  //     ic11_memory[i*2+0][6],
  //     ic11_memory[i*2+0][2],
  //     ic11_memory[i*2+0][1]
  //   };
  //   $display("%x", r11);
  // end

  wavein_sign = 1'd0;
  r10 = 10'd0;
  add_r = 4'd0;
  for (integer j = 0; j < 16; j++) begin
    for (integer i = 0; i < 1024; i++) begin
      r10[9:8] = {ic10_memory[i*2][5], ic10_memory[i*2][3]};
      r10[7:0] = {ic10_memory[i*2+1][6], ic10_memory[i*2+1][7], ic10_memory[i*2+1][2], ic10_memory[i*2+1][1],
                  ic10_memory[i*2+1][4], ic10_memory[i*2+1][0], ic10_memory[i*2+1][5], ic10_memory[i*2+1][3]};
      r10[7:3] = ~r10[7:3];
      add_r = j[3:0];
      result[14] = ~((~(~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) && ~wavein_sign) || (~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0] && wavein_sign));
      result[13] = ~((((~r10[7] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0])) && wavein_sign) || (~((~r10[7] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0])) && ~wavein_sign));
      result[12] = ~((((~r10[6] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[7] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0])) && wavein_sign) || (~((~r10[6] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[7] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0])) && ~wavein_sign));
      result[11] = ~((((~r10[5] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[6] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~r10[7] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (1 && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0])) && wavein_sign) || (~((~r10[5] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[6] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~r10[7] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (1 && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0])) && ~wavein_sign));
      result[10] = ~((~((~r10[7] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (~r10[6] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (~r10[5] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~r10[4] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0])) && ~(~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) && ~wavein_sign) || (~(~((~r10[7] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (~r10[6] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (~r10[5] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~r10[4] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0])) && ~(~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0])) && wavein_sign));
      result[9] = ~((((1 && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[7] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[6] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (~r10[5] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (~r10[4] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~r10[3] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0])) && wavein_sign) || (~((1 && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[7] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[6] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (~r10[5] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (~r10[4] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~r10[3] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0])) && ~wavein_sign));
      result[8] = ~((((1 && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[7] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[6] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[5] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (~r10[4] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (~r10[3] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (r10[2] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (1 && 0)) && wavein_sign) || (~((1 && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[7] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[6] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[5] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (~r10[4] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (~r10[3] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (r10[2] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (1 && 0)) && ~wavein_sign));
      result[7] = ~((((1 && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (~r10[7] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[6] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[5] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[4] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (~r10[3] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (r10[2] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (r10[1] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0])) && wavein_sign) || (~((1 && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (~r10[7] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[6] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[5] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[4] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (~r10[3] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (r10[2] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (r10[1] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0])) && ~wavein_sign));
      result[6] = ~((~((1 && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[7] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (~r10[6] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[5] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[4] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[3] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (r10[2] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (r10[1] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0])) && ~(r10[0] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) && ~wavein_sign) || (~(~((1 && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[7] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (~r10[6] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[5] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[4] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[3] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (r10[2] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (r10[1] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0])) && ~(r10[0] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0])) && wavein_sign));
      result[5] = ~((~((~r10[7] && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[6] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (~r10[5] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[4] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[3] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (r10[2] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (r10[1] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (r10[0] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0])) && ~((r10[9] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0])) && ~wavein_sign) || (~(~((~r10[7] && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[6] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (~r10[5] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[4] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[3] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (r10[2] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (r10[1] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (r10[0] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0])) && ~((r10[9] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]))) && wavein_sign));
      result[4] = ~((~((r10[8] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (r10[9] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (r10[0] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (r10[1] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (r10[2] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[3] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[4] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[5] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0])) && ~((~r10[6] && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[7] && add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0])) && ~wavein_sign) || (~(~((r10[8] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (r10[9] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (r10[0] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (r10[1] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (r10[2] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[3] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[4] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[5] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0])) && ~((~r10[6] && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[7] && add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]))) && wavein_sign));
      result[3] = ~((~((r10[8] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (r10[9] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (r10[0] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (r10[1] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (r10[2] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[3] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[4] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (~r10[5] && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0])) && ~((~r10[6] && add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~r10[7] && add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (add_r[3] && ~add_r[2] && add_r[1] && add_r[0])) && ~wavein_sign) || (~(~((r10[8] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (r10[9] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (r10[0] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (r10[1] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (r10[2] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[3] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[4] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (~r10[5] && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0])) && ~((~r10[6] && add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~r10[7] && add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (add_r[3] && ~add_r[2] && add_r[1] && add_r[0]))) && wavein_sign));
      result[2] = ~((~((r10[8] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (r10[9] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (r10[0] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (r10[1] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (r10[2] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[3] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (~r10[4] && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[5] && add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0])) && ~((~r10[6] && add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (~r10[7] && add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0])) && ~wavein_sign) || (~(~((r10[8] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (r10[9] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (r10[0] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (r10[1] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (r10[2] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[3] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (~r10[4] && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[5] && add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0])) && ~((~r10[6] && add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (~r10[7] && add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]))) && wavein_sign));
      result[1] = ~((~((r10[8] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (r10[9] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (r10[0] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (r10[1] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (r10[2] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (~r10[3] && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[4] && add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~r10[5] && add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0])) && ~((~r10[6] && add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (~r10[7] && add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (add_r[3] && add_r[2] && ~add_r[1] && add_r[0])) && ~wavein_sign) || (~(~((r10[8] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (r10[9] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (r10[0] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (r10[1] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (r10[2] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (~r10[3] && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[4] && add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~r10[5] && add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0])) && ~((~r10[6] && add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (~r10[7] && add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (add_r[3] && add_r[2] && ~add_r[1] && add_r[0]))) && wavein_sign));
      result[0] = ~((~((r10[8] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (r10[9] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (r10[0] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (r10[1] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (r10[2] && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[3] && add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~r10[4] && add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (~r10[5] && add_r[3] && ~add_r[2] && add_r[1] && add_r[0])) && ~((~r10[6] && add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[7] && add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (add_r[3] && add_r[2] && add_r[1] && ~add_r[0])) && ~wavein_sign) || (~(~((r10[8] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (r10[9] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (r10[0] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (r10[1] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (r10[2] && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[3] && add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~r10[4] && add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (~r10[5] && add_r[3] && ~add_r[2] && add_r[1] && add_r[0])) && ~((~r10[6] && add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[7] && add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (add_r[3] && add_r[2] && add_r[1] && ~add_r[0]))) && wavein_sign));
      $display("%x", result);
    end
  end
  
  wavein_sign = 1'd1;
  r10 = 10'd0;
  add_r = 4'd0;
  for (integer j = 0; j < 16; j++) begin
    for (integer i = 0; i < 1024; i++) begin
      r10[9:8] = {ic10_memory[i*2][5], ic10_memory[i*2][3]};
      r10[7:0] = {ic10_memory[i*2+1][6], ic10_memory[i*2+1][7], ic10_memory[i*2+1][2], ic10_memory[i*2+1][1],
                  ic10_memory[i*2+1][4], ic10_memory[i*2+1][0], ic10_memory[i*2+1][5], ic10_memory[i*2+1][3]};
      r10[7:3] = ~r10[7:3];
      add_r = j[3:0];
      result[14] = ~((~(~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) && ~wavein_sign) || (~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0] && wavein_sign));
      result[13] = ~((((~r10[7] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0])) && wavein_sign) || (~((~r10[7] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0])) && ~wavein_sign));
      result[12] = ~((((~r10[6] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[7] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0])) && wavein_sign) || (~((~r10[6] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[7] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0])) && ~wavein_sign));
      result[11] = ~((((~r10[5] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[6] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~r10[7] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (1 && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0])) && wavein_sign) || (~((~r10[5] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[6] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~r10[7] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (1 && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0])) && ~wavein_sign));
      result[10] = ~((~((~r10[7] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (~r10[6] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (~r10[5] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~r10[4] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0])) && ~(~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) && ~wavein_sign) || (~(~((~r10[7] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (~r10[6] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (~r10[5] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~r10[4] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0])) && ~(~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0])) && wavein_sign));
      result[9] = ~((((1 && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[7] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[6] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (~r10[5] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (~r10[4] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~r10[3] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0])) && wavein_sign) || (~((1 && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[7] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[6] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (~r10[5] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (~r10[4] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~r10[3] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0])) && ~wavein_sign));
      result[8] = ~((((1 && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[7] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[6] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[5] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (~r10[4] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (~r10[3] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (r10[2] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (1 && 0)) && wavein_sign) || (~((1 && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[7] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[6] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[5] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (~r10[4] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (~r10[3] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (r10[2] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (1 && 0)) && ~wavein_sign));
      result[7] = ~((((1 && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (~r10[7] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[6] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[5] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[4] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (~r10[3] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (r10[2] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (r10[1] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0])) && wavein_sign) || (~((1 && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (~r10[7] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[6] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[5] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[4] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (~r10[3] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (r10[2] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (r10[1] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0])) && ~wavein_sign));
      result[6] = ~((~((1 && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[7] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (~r10[6] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[5] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[4] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[3] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (r10[2] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (r10[1] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0])) && ~(r10[0] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) && ~wavein_sign) || (~(~((1 && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[7] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (~r10[6] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[5] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[4] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[3] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (r10[2] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (r10[1] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0])) && ~(r10[0] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0])) && wavein_sign));
      result[5] = ~((~((~r10[7] && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[6] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (~r10[5] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[4] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[3] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (r10[2] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (r10[1] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (r10[0] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0])) && ~((r10[9] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0])) && ~wavein_sign) || (~(~((~r10[7] && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[6] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (~r10[5] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[4] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[3] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (r10[2] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (r10[1] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (r10[0] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0])) && ~((r10[9] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]))) && wavein_sign));
      result[4] = ~((~((r10[8] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (r10[9] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (r10[0] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (r10[1] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (r10[2] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[3] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[4] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[5] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0])) && ~((~r10[6] && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[7] && add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0])) && ~wavein_sign) || (~(~((r10[8] && ~add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (r10[9] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (r10[0] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (r10[1] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (r10[2] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[3] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[4] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[5] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0])) && ~((~r10[6] && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[7] && add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]))) && wavein_sign));
      result[3] = ~((~((r10[8] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (r10[9] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (r10[0] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (r10[1] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (r10[2] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[3] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[4] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (~r10[5] && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0])) && ~((~r10[6] && add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~r10[7] && add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (add_r[3] && ~add_r[2] && add_r[1] && add_r[0])) && ~wavein_sign) || (~(~((r10[8] && ~add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (r10[9] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (r10[0] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (r10[1] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (r10[2] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (~r10[3] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[4] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (~r10[5] && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0])) && ~((~r10[6] && add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~r10[7] && add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (add_r[3] && ~add_r[2] && add_r[1] && add_r[0]))) && wavein_sign));
      result[2] = ~((~((r10[8] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (r10[9] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (r10[0] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (r10[1] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (r10[2] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[3] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (~r10[4] && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[5] && add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0])) && ~((~r10[6] && add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (~r10[7] && add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0])) && ~wavein_sign) || (~(~((r10[8] && ~add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (r10[9] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (r10[0] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (r10[1] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (r10[2] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (~r10[3] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (~r10[4] && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[5] && add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0])) && ~((~r10[6] && add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (~r10[7] && add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]))) && wavein_sign));
      result[1] = ~((~((r10[8] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (r10[9] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (r10[0] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (r10[1] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (r10[2] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (~r10[3] && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[4] && add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~r10[5] && add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0])) && ~((~r10[6] && add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (~r10[7] && add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (add_r[3] && add_r[2] && ~add_r[1] && add_r[0])) && ~wavein_sign) || (~(~((r10[8] && ~add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (r10[9] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (r10[0] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (r10[1] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (r10[2] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (~r10[3] && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[4] && add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~r10[5] && add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0])) && ~((~r10[6] && add_r[3] && ~add_r[2] && add_r[1] && add_r[0]) || (~r10[7] && add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (add_r[3] && add_r[2] && ~add_r[1] && add_r[0]))) && wavein_sign));
      result[0] = ~((~((r10[8] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (r10[9] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (r10[0] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (r10[1] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (r10[2] && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[3] && add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~r10[4] && add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (~r10[5] && add_r[3] && ~add_r[2] && add_r[1] && add_r[0])) && ~((~r10[6] && add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[7] && add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (add_r[3] && add_r[2] && add_r[1] && ~add_r[0])) && ~wavein_sign) || (~(~((r10[8] && ~add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (r10[9] && ~add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (r10[0] && ~add_r[3] && add_r[2] && add_r[1] && ~add_r[0]) || (r10[1] && ~add_r[3] && add_r[2] && add_r[1] && add_r[0]) || (r10[2] && add_r[3] && ~add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[3] && add_r[3] && ~add_r[2] && ~add_r[1] && add_r[0]) || (~r10[4] && add_r[3] && ~add_r[2] && add_r[1] && ~add_r[0]) || (~r10[5] && add_r[3] && ~add_r[2] && add_r[1] && add_r[0])) && ~((~r10[6] && add_r[3] && add_r[2] && ~add_r[1] && ~add_r[0]) || (~r10[7] && add_r[3] && add_r[2] && ~add_r[1] && add_r[0]) || (add_r[3] && add_r[2] && add_r[1] && ~add_r[0]))) && wavein_sign));
      $display("%x", result);
    end
  end
end

endmodule
