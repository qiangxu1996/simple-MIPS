`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    22:56:03 04/22/2016
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module mux_32(
	output [31:0] out,
	input [31:0] a, b,
	input sel
    );

	assign out = sel ? b : a;

endmodule
