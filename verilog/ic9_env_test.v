module test();

reg [3:0] param_bus;
reg [18:0] adder1_a;

wire VCC;
assign VCC = 1'b1;
wire GND;
assign GND = 1'b0;

reg [7:0] ic11_memory [0:8191];

reg bus4_cycle0_7;
reg bus5_cycle0_7;
reg bus6_cycle0_7;
reg bus7_cycle0_7;
reg rom_d0_cy3_7;
reg rom_d0_inv_cy5_7;
reg rom_d1_cy3_7;
reg rom_d1_inv_cy5_7;
reg rom_d2_cy3_7;
reg rom_d2_inv_cy5_7;
reg rom_d3_cy3_7;
reg rom_d3_inv_cy5_7;
reg rom_d4_cy3_7;
reg rom_d4_inv_cy5_7;
reg rom_d5_inv_cy3_7;
reg rom_d6_inv_cy3_7;
reg rom_d7_inv_cy3_7;

initial begin
  $readmemh("../roms/RD200_C_desc.hex", ic11_memory);

  param_bus = 4'd0;
  for (integer j = 0; j < 16; j++) begin
    param_bus = j[4:0];
    for (integer i = 0; i < 4096; i++) begin
      bus4_cycle0_7 = param_bus[0];
      bus5_cycle0_7 = param_bus[1];
      bus6_cycle0_7 = param_bus[2];
      bus7_cycle0_7 = param_bus[3];

      rom_d0_cy3_7     =  ic11_memory[i*2+0][0];
      rom_d1_cy3_7     =  ic11_memory[i*2+0][1];
      rom_d2_cy3_7     =  ic11_memory[i*2+0][2];
      rom_d3_cy3_7     =  ic11_memory[i*2+0][3];
      rom_d4_cy3_7     =  ic11_memory[i*2+0][4];
      rom_d5_inv_cy3_7 = ~ic11_memory[i*2+0][5];
      rom_d6_inv_cy3_7 = ~ic11_memory[i*2+0][6];
      rom_d7_inv_cy3_7 = ~ic11_memory[i*2+0][7];
      rom_d0_inv_cy5_7 = ~ic11_memory[i*2+1][0];
      rom_d1_inv_cy5_7 = ~ic11_memory[i*2+1][1];
      rom_d2_inv_cy5_7 = ~ic11_memory[i*2+1][2];
      rom_d3_inv_cy5_7 = ~ic11_memory[i*2+1][3];
      rom_d4_inv_cy5_7 = ~ic11_memory[i*2+1][4];

      adder1_a[0] = (~rom_d6_inv_cy3_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d5_inv_cy3_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (rom_d4_cy3_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (rom_d3_cy3_7 && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (rom_d2_cy3_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (rom_d1_cy3_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (rom_d0_cy3_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7 && bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7);
      adder1_a[1] = (~rom_d7_inv_cy3_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d6_inv_cy3_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d5_inv_cy3_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (rom_d4_cy3_7 && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (rom_d3_cy3_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (rom_d2_cy3_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (rom_d1_cy3_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (rom_d0_cy3_7 && bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7);
      adder1_a[2] = ~(~((~rom_d0_inv_cy5_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d7_inv_cy3_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d6_inv_cy3_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d5_inv_cy3_7 && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (rom_d4_cy3_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (rom_d3_cy3_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (rom_d2_cy3_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (rom_d1_cy3_7 && bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7)) && ~(rom_d0_cy3_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7));
      adder1_a[3] = ~(~((~rom_d1_inv_cy5_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d0_inv_cy5_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d7_inv_cy3_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d6_inv_cy3_7 && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d5_inv_cy3_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (rom_d4_cy3_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (rom_d3_cy3_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (rom_d2_cy3_7 && bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7)) && ~((rom_d1_cy3_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (rom_d0_cy3_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7)));
      adder1_a[4] = ~(~((~rom_d2_inv_cy5_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d1_inv_cy5_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d0_inv_cy5_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d7_inv_cy3_7 && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d6_inv_cy3_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d5_inv_cy3_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (rom_d4_cy3_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (rom_d3_cy3_7 && bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7)) && ~((rom_d2_cy3_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (rom_d1_cy3_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (rom_d0_cy3_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (GND && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7)));
      adder1_a[5] = ~(~((~rom_d3_inv_cy5_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d2_inv_cy5_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d1_inv_cy5_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d0_inv_cy5_7 && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d7_inv_cy3_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d6_inv_cy3_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d5_inv_cy3_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (rom_d4_cy3_7 && bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7)) && ~((rom_d3_cy3_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (rom_d2_cy3_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (rom_d1_cy3_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (rom_d0_cy3_7 && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7)));
      adder1_a[6] = ~(~((~rom_d4_inv_cy5_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d3_inv_cy5_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d2_inv_cy5_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d1_inv_cy5_7 && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d0_inv_cy5_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d7_inv_cy3_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d6_inv_cy3_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d5_inv_cy3_7 && bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7)) && ~((rom_d4_cy3_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (rom_d3_cy3_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (rom_d2_cy3_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (rom_d1_cy3_7 && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7)));
      adder1_a[7] = ~(~((VCC && ~bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d4_inv_cy5_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d3_inv_cy5_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d2_inv_cy5_7 && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d1_inv_cy5_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d0_inv_cy5_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d7_inv_cy3_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d6_inv_cy3_7 && bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7)) && ~((~rom_d5_inv_cy3_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (rom_d4_cy3_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (rom_d3_cy3_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (rom_d2_cy3_7 && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7)));
      adder1_a[8] = ~(~((GND && ~bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (VCC && bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d4_inv_cy5_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d3_inv_cy5_7 && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d2_inv_cy5_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d1_inv_cy5_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d0_inv_cy5_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d7_inv_cy3_7 && bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7)) && ~((~rom_d6_inv_cy3_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (~rom_d5_inv_cy3_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (rom_d4_cy3_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (rom_d3_cy3_7 && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7)));
      adder1_a[9] = ~(~((VCC && ~bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d4_inv_cy5_7 && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d3_inv_cy5_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d2_inv_cy5_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d1_inv_cy5_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d0_inv_cy5_7 && bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d7_inv_cy3_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (~rom_d6_inv_cy3_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7)) && ~((~rom_d5_inv_cy3_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (rom_d4_cy3_7 && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7)));
      adder1_a[10] = ~(~((VCC && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d4_inv_cy5_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d3_inv_cy5_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d2_inv_cy5_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d1_inv_cy5_7 && bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d0_inv_cy5_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (~rom_d7_inv_cy3_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (~rom_d6_inv_cy3_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7)) && ~(~rom_d5_inv_cy3_7 && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7));
      adder1_a[11] = (VCC && ~bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d4_inv_cy5_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d3_inv_cy5_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d2_inv_cy5_7 && bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d1_inv_cy5_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (~rom_d0_inv_cy5_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (~rom_d7_inv_cy3_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (~rom_d6_inv_cy3_7 && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7);
      adder1_a[12] = (GND && ~bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (VCC && bus4_cycle0_7 && ~bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d4_inv_cy5_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d3_inv_cy5_7 && bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d2_inv_cy5_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (~rom_d1_inv_cy5_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (~rom_d0_inv_cy5_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (~rom_d7_inv_cy3_7 && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7);
      adder1_a[13] = (VCC && ~bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d4_inv_cy5_7 && bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) || (~rom_d3_inv_cy5_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (~rom_d2_inv_cy5_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (~rom_d1_inv_cy5_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) || (~rom_d0_inv_cy5_7 && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7);
      adder1_a[14] = ~(VCC && ~(VCC && bus4_cycle0_7 && bus5_cycle0_7 && bus6_cycle0_7 && ~bus7_cycle0_7) && ~(~rom_d4_inv_cy5_7 && ~bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) && ~(~rom_d3_inv_cy5_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) && ~(~rom_d2_inv_cy5_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) && ~(~rom_d1_inv_cy5_7 && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7));
      adder1_a[15] = ~(~(~bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) && ~(~rom_d4_inv_cy5_7 && bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) && ~(~rom_d3_inv_cy5_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) && ~(~rom_d2_inv_cy5_7 && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7));
      adder1_a[16] = ~(~(bus4_cycle0_7 && ~bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) && ~(~rom_d4_inv_cy5_7 && ~bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) && ~(~rom_d3_inv_cy5_7 && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7));
      adder1_a[17] = ~(~(~bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7) && ~(~rom_d4_inv_cy5_7 && bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7));
      adder1_a[18] = bus4_cycle0_7 && bus5_cycle0_7 && ~bus6_cycle0_7 && bus7_cycle0_7;
      $display("%x", adder1_a);
    end
  end
end

endmodule
