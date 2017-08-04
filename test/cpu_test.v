`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:   10:58:58 04/23/2016
// Design Name:   CPU
// Module Name:   C:/Users/Qiang/Documents/Xilinx/little_mips/cpu_test.v
// Project Name:  little_mips
// Target Device:
// Tool versions:
// Description:
//
// Verilog Test Fixture created by ISE for module: CPU
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////

module cpu_test;

	wire [31:0] im_data;
	wire [31:0] dm_r_data;
	reg [5:0] int_level;
	reg intr, clk, rst_n;

	wire [31:0] im_addr;
	wire [31:0] dm_addr;
	wire [31:0] dm_w_data;
	wire mem_read;
	wire mem_write;

	// Instantiate the Unit Under Test (UUT)
	CPU uut (
		.im_addr(im_addr),
		.dm_addr(dm_addr),
		.im_data(im_data),
		.dm_w_data(dm_w_data),
		.dm_r_data_mem(dm_r_data),
		.mem_read(mem_read),
		.mem_write(mem_write),
		.int_level(int_level),
		.intr(intr),
		.clk(clk),
		.rst_n(rst_n)
	);

	im im0 (clk, im_addr[8:2], im_data);
	dm dm0 (clk, mem_write, dm_addr[7:2], dm_w_data
		, clk, mem_read, dm_addr[7:2], dm_r_data);

	initial
	begin
		clk = 1'b0;
		forever #50
			clk = ~clk;
	end

	initial
	begin
		rst_n = 1'b0;
		intr = 1'b0;
		int_level = 6'b0;
		@ (posedge clk);
		@ (negedge clk);
		rst_n = 1'b1;

//		#1645;
		#1545;
		intr = 1'b1;
		int_level = 6'b001000;
		#90;
		intr = 1'b0;
		int_level = 6'b0;
	end

endmodule
