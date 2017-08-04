`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    22:26:53 04/22/2016
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module PC(
	output reg [31:0] pc,
	input [31:0] npc,
	input pc_write, clk, rst_n
    );

	always @ (negedge clk)
		if (~rst_n)
			pc <= 32'b0;
		else if (pc_write)
			pc <= npc;

endmodule
