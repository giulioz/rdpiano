`timescale 1ns/100ps

module Sram (
	address,
	data_in,
	data_out,
	write_enable, // write on low
	output_enable, // active low
	mem
);
	parameter DATA_WIDTH = 8;
	parameter ADDR_WIDTH = 11;
	parameter RAM_DEPTH = 2048;

	input [ADDR_WIDTH-1:0] address;
	input write_enable;
	input output_enable;

	input [DATA_WIDTH-1:0] data_in;
	output [DATA_WIDTH-1:0] data_out;

	reg [DATA_WIDTH-1:0] data_out;
	output reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];

	assign data_out = (write_enable && !output_enable) ? mem[address] : 8'bz;

	always @(posedge write_enable) begin
	  //  if (!write_enable && output_enable)
		  //  mem[address] <= data_in;
	end

	initial begin
		for (integer i = 0; i < RAM_DEPTH; i = i + 1) begin
			mem[i] = 8'h00;
		end
	end
endmodule
