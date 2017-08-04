`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    08:44:00 04/23/2016
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module add(
	output [31:0] result,
	input signed [31:0] op1, op2
    );

	assign result = op1 + op2;

endmodule
