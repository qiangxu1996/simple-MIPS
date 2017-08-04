`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    16:06:34 03/26/2016
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module registers(
	output reg [31:0] r1_dout,
	output reg [31:0] r2_dout,
	input [4:0] r1_addr,
	input [4:0] r2_addr,
	input [4:0] r3_addr,
	input [31:0] r3_din,
	input r3_wr, clk
	);

	// register[0] is not used.
	reg [31:0] register[31:0];

	always @ (posedge clk)
	begin
		if (r3_wr && r3_addr)
			register[r3_addr] <= r3_din;

		if (r1_addr == 5'b0)
			r1_dout <= 32'b0;
		else if (r3_wr && r1_addr == r3_addr)
			r1_dout <= r3_din;
		else
			r1_dout <= register[r1_addr];

		if (r2_addr == 5'b0)
			r2_dout <= 32'b0;
		else if (r3_wr && r2_addr == r3_addr)
			r2_dout <= r3_din;
		else
			r2_dout <= register[r2_addr];
	end

endmodule
