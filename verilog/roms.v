`timescale 1ns/100ps

module ROM_IC10 (
  input wire [10:0] addr,
  output wire [7:0] data
);
  reg [7:0] ic10_memory [0:2047];
  initial begin
    $readmemh("../roms/RD200_IC10_desc.hex", ic10_memory);
  end

  assign data = ic10_memory[addr];
endmodule

module ROM_IC11 (
  input wire [12:0] addr,
  output wire [7:0] data
);
  reg [7:0] ic11_memory [0:8191];
  initial begin
    $readmemh("../roms/RD200_C_desc.hex", ic11_memory);
  end

  assign data = ic11_memory[addr];
endmodule

module ROM_IC5 (
  input wire [16:0] addr,
  output wire [7:0] data
);
  reg [7:0] ic5_memory [0:131071];
  initial begin
    $readmemh("../roms/RD200_IC5_desc.hex", ic5_memory);
  end

  assign data = ic5_memory[addr];
endmodule

module ROM_IC6 (
  input wire [16:0] addr,
  output wire [7:0] data
);
  reg [7:0] ic6_memory [0:131071];
  initial begin
    $readmemh("../roms/RD200_IC6_desc.hex", ic6_memory);
  end

  assign data = ic6_memory[addr];
endmodule

module ROM_IC7 (
  input wire [16:0] addr,
  output wire [7:0] data
);
  reg [7:0] ic7_memory [0:131071];
  initial begin
    $readmemh("../roms/RD200_IC7_desc.hex", ic7_memory);
  end

  assign data = ic7_memory[addr];
endmodule
