`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    23:09:49 04/22/2016
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module mux_5(
	output [4:0] out,
	input [4:0] a, b,
	input sel
    );

	assign out = sel ? b : a;

endmodule
