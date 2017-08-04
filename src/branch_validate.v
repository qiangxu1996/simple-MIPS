`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    19:11:49 04/28/2016
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module branch_validate(
	output reg branch_taken,
	input [5:0] op,
	input [31:0] rs, rt
    );

	parameter beq = 6'b000100;
	parameter bne = 6'b000101;
	parameter bgtz = 6'b000111;

	always @ (*)
		case (op)
			beq: branch_taken = rs == rt;
			bne: branch_taken = rs != rt;
			bgtz: branch_taken = rs > 32'b0;
			default: branch_taken = 1'b0;
		endcase

endmodule
