`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    20:48:11 04/27/2016
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module mux_4_1(
	output reg [31:0] out,
	input [31:0] a, b, c, d,
	input [1:0] sel
    );

	always @ (*)
		case (sel)
			2'b00: out = a;
			2'b01: out = b;
			2'b10: out = c;
			2'b11: out = d;
		endcase

endmodule
