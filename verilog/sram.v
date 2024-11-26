`timescale 1ns/100ps

module Sram (
	address,
	data,
	write_enable, // write on low
	output_enable // active low
);
	parameter DATA_WIDTH = 8;
	parameter ADDR_WIDTH = 11;
	parameter RAM_DEPTH = 2048;

	input [ADDR_WIDTH-1:0] address;
	input write_enable;
	input output_enable;

	inout [DATA_WIDTH-1:0] data;

	reg [DATA_WIDTH-1:0] data_out;
	reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];

	assign data = (write_enable && !output_enable) ? mem[address] : 8'bz;

	always @(posedge write_enable) begin
	   if (!write_enable && output_enable)
		   mem[address] <= data;
	end
endmodule
