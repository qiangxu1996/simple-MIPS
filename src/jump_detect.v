`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    19:55:27 05/20/2016
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module jump_detect(
	output reg jump_addr_sel, jump,
	input [5:0] op, funct
    );

	parameter j = 6'b000010;
	parameter jr_op = 6'b000000;
	parameter jr_funct = 6'b001000;

	always @ (*)
		if (op == j)
		begin
			jump = 1'b1;
			jump_addr_sel = 1'b0;
		end
		else if (op == jr_op && funct == jr_funct)
		begin
			jump = 1'b1;
			jump_addr_sel = 1'b1;
		end
		else
		begin
			jump = 1'b0;
			jump_addr_sel = 1'bx;
		end

endmodule
