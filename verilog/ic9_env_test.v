module test();

reg [3:0] param_bus;
reg [13:0] param_rom;
reg [18:0] adder1_a;

// assign param_bus[0] = bus4_cycle0_7;
// assign param_bus[1] = bus5_cycle0_7;
// assign param_bus[2] = bus6_cycle0_7;
// assign param_bus[3] = bus7_cycle0_7;

// assign param_rom[0] = rom_d0_lsb_7; // 0
// assign param_rom[1] = rom_d1_lsb_7; // 1
// assign param_rom[2] = rom_d2_lsb_7; // 2
// assign param_rom[3] = rom_d3_lsb_7; // 3
// assign param_rom[4] = rom_d4_cycle3_7; // 4
// assign param_rom[5] = rom_d5_not_lsb_7; // 5
// assign param_rom[6] = rom_d6_not_lsb_7; // 6
// assign param_rom[7] = rom_d7_not_lsb_7; // 7
// assign param_rom[8] = rom_d0_not_msb_7; // 8
// assign param_rom[9] = rom_d1_not_msb_7; // 9
// assign param_rom[10] = rom_d2_not_msb_7; // 10
// assign param_rom[11] = rom_d3_not_msb_7; // 11
// assign param_rom[12] = rom_d4_not_msb_7; // 12

wire VCC;
assign VCC = 1'b1;
wire GND;
assign GND = 1'b0;

reg [7:0] ic11_memory [0:8191];

initial begin
  $readmemh("../roms/RD200_C_desc.hex", ic11_memory);

  param_bus = 4'd0;
  param_rom = 13'd0;
  for (integer j = 0; j < 16; j++) begin
    param_bus = j[4:0];
    for (integer i = 0; i < 4096; i++) begin
      param_rom[12:0] = {
        ~ic11_memory[i*2+1][3],
        ~ic11_memory[i*2+1][4],
        ~ic11_memory[i*2+1][6],
        ~ic11_memory[i*2+1][2],
        ~ic11_memory[i*2+1][1],
        ~ic11_memory[i*2+0][7],
        ~ic11_memory[i*2+0][0],
        ~ic11_memory[i*2+0][5],
        
        ic11_memory[i*2+0][3],
        ic11_memory[i*2+0][4],
        ic11_memory[i*2+0][6],
        ic11_memory[i*2+0][2],
        ic11_memory[i*2+0][1]
      };

      // param_rom[12:0] = {
      //   ic11_memory[i*2+1][3],
      //   ic11_memory[i*2+1][4],
      //   ic11_memory[i*2+1][6],
      //   ic11_memory[i*2+1][2],
      //   ic11_memory[i*2+1][1],
      //   ic11_memory[i*2+0][7],
      //   ic11_memory[i*2+0][0],
      //   ic11_memory[i*2+0][5],
        
      //   ic11_memory[i*2+0][3],
      //   ic11_memory[i*2+0][4],
      //   ic11_memory[i*2+0][6],
      //   ic11_memory[i*2+0][2],
      //   ic11_memory[i*2+0][1]
      // };
      // $display("%x", param_rom);

      adder1_a[0] = (~param_rom[6] && ~param_bus[0] && ~param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[5] && param_bus[0] && ~param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (param_rom[4] && ~param_bus[0] && param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (param_rom[3] && param_bus[0] && param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (param_rom[2] && ~param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (param_rom[1] && param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (param_rom[0] && ~param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3]) || (param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3] && param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3]);
      adder1_a[1] = (~param_rom[7] && ~param_bus[0] && ~param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[6] && param_bus[0] && ~param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[5] && ~param_bus[0] && param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (param_rom[4] && param_bus[0] && param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (param_rom[3] && ~param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (param_rom[2] && param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (param_rom[1] && ~param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3]) || (param_rom[0] && param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3]);
      adder1_a[2] = ~(~((~param_rom[8] && ~param_bus[0] && ~param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[7] && param_bus[0] && ~param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[6] && ~param_bus[0] && param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[5] && param_bus[0] && param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (param_rom[4] && ~param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (param_rom[3] && param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (param_rom[2] && ~param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3]) || (param_rom[1] && param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3])) && ~(param_rom[0] && ~param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]));
      adder1_a[3] = ~(~((~param_rom[9] && ~param_bus[0] && ~param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[8] && param_bus[0] && ~param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[7] && ~param_bus[0] && param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[6] && param_bus[0] && param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[5] && ~param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (param_rom[4] && param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (param_rom[3] && ~param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3]) || (param_rom[2] && param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3])) && ~((param_rom[1] && ~param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) || (param_rom[0] && param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3])));
      adder1_a[4] = ~(~((~param_rom[10] && ~param_bus[0] && ~param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[9] && param_bus[0] && ~param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[8] && ~param_bus[0] && param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[7] && param_bus[0] && param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[6] && ~param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[5] && param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (param_rom[4] && ~param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3]) || (param_rom[3] && param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3])) && ~((param_rom[2] && ~param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) || (param_rom[1] && param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) || (param_rom[0] && ~param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3]) || (GND && param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3])));
      adder1_a[5] = ~(~((~param_rom[11] && ~param_bus[0] && ~param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[10] && param_bus[0] && ~param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[9] && ~param_bus[0] && param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[8] && param_bus[0] && param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[7] && ~param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[6] && param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[5] && ~param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3]) || (param_rom[4] && param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3])) && ~((param_rom[3] && ~param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) || (param_rom[2] && param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) || (param_rom[1] && ~param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3]) || (param_rom[0] && param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3])));
      adder1_a[6] = ~(~((~param_rom[12] && ~param_bus[0] && ~param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[11] && param_bus[0] && ~param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[10] && ~param_bus[0] && param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[9] && param_bus[0] && param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[8] && ~param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[7] && param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[6] && ~param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[5] && param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3])) && ~((param_rom[4] && ~param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) || (param_rom[3] && param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) || (param_rom[2] && ~param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3]) || (param_rom[1] && param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3])));
      adder1_a[7] = ~(~((VCC && ~param_bus[0] && ~param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[12] && param_bus[0] && ~param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[11] && ~param_bus[0] && param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[10] && param_bus[0] && param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[9] && ~param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[8] && param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[7] && ~param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[6] && param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3])) && ~((~param_rom[5] && ~param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) || (param_rom[4] && param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) || (param_rom[3] && ~param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3]) || (param_rom[2] && param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3])));
      adder1_a[8] = ~(~((GND && ~param_bus[0] && ~param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (VCC && param_bus[0] && ~param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[12] && ~param_bus[0] && param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[11] && param_bus[0] && param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[10] && ~param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[9] && param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[8] && ~param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[7] && param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3])) && ~((~param_rom[6] && ~param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) || (~param_rom[5] && param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) || (param_rom[4] && ~param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3]) || (param_rom[3] && param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3])));
      adder1_a[9] = ~(~((VCC && ~param_bus[0] && param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[12] && param_bus[0] && param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[11] && ~param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[10] && param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[9] && ~param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[8] && param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[7] && ~param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) || (~param_rom[6] && param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3])) && ~((~param_rom[5] && ~param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3]) || (param_rom[4] && param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3])));
      adder1_a[10] = ~(~((VCC && param_bus[0] && param_bus[1] && ~param_bus[2] && ~param_bus[3]) || (~param_rom[12] && ~param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[11] && param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[10] && ~param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[9] && param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[8] && ~param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) || (~param_rom[7] && param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) || (~param_rom[6] && ~param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3])) && ~(~param_rom[5] && param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3]));
      adder1_a[11] = (VCC && ~param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[12] && param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[11] && ~param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[10] && param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[9] && ~param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) || (~param_rom[8] && param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) || (~param_rom[7] && ~param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3]) || (~param_rom[6] && param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3]);
      adder1_a[12] = (GND && ~param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (VCC && param_bus[0] && ~param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[12] && ~param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[11] && param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[10] && ~param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) || (~param_rom[9] && param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) || (~param_rom[8] && ~param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3]) || (~param_rom[7] && param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3]);
      adder1_a[13] = (VCC && ~param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[12] && param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3]) || (~param_rom[11] && ~param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) || (~param_rom[10] && param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) || (~param_rom[9] && ~param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3]) || (~param_rom[8] && param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3]);
      adder1_a[14] = ~(VCC && ~(VCC && param_bus[0] && param_bus[1] && param_bus[2] && ~param_bus[3]) && ~(~param_rom[12] && ~param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) && ~(~param_rom[11] && param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) && ~(~param_rom[10] && ~param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3]) && ~(~param_rom[9] && param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3]));
      adder1_a[15] = ~(~(~param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) && ~(~param_rom[12] && param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) && ~(~param_rom[11] && ~param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3]) && ~(~param_rom[10] && param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3]));
      adder1_a[16] = ~(~(param_bus[0] && ~param_bus[1] && ~param_bus[2] && param_bus[3]) && ~(~param_rom[12] && ~param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3]) && ~(~param_rom[11] && param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3]));
      adder1_a[17] = ~(~(~param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3]) && ~(~param_rom[12] && param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3]));
      adder1_a[18] = param_bus[0] && param_bus[1] && ~param_bus[2] && param_bus[3];
      $display("%x", adder1_a);
    end
  end
end

endmodule
