`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    14:46:46 03/22/2016
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module ALU(
	output reg [31:0] alu_out,
	output alu_overflow,
	input [31:0] alu_a, alu_b,
	input [4:0] shamt,
	input [3:0] alu_op
	);

	parameter A_AND = 4'b0000;
	parameter A_OR  = 4'b0001;
	parameter A_ADD = 4'b0010;
	parameter A_SUB = 4'b0110;
	parameter A_SLT = 4'b0111;
	parameter A_NOR = 4'b1100;
	// FIXME: following parameters are not optimized.
	parameter A_ADDU = 4'b0011;
	parameter A_SUBU = 4'b0100;
	parameter A_SLTU = 4'b0101;
	parameter A_SLL = 4'b1000;
	parameter A_SLLV = 4'b1001;
	parameter A_SRA = 4'b1010;
	parameter A_SRAV = 4'b1011;
	parameter A_SRL = 4'b1101;
	parameter A_SRLV = 4'b1110;
	parameter A_XOR = 4'b1111;

	reg carry_out;
	wire signed [31:0] signed_a, signed_b;

	assign alu_overflow = (alu_op == A_ADD || alu_op == A_SUB)
		&& (carry_out ^ alu_out[31]);

	assign signed_a = alu_a;
	assign signed_b = alu_b;

	always @ (*)
		case (alu_op)
			A_AND: {carry_out, alu_out} = {1'bx, alu_a & alu_b};
			A_OR : {carry_out, alu_out} = {1'bx, alu_a | alu_b};
			A_ADD: {carry_out, alu_out} = signed_a + signed_b;
			A_SUB: {carry_out, alu_out} = signed_a - signed_b;
			A_SLT: {carry_out, alu_out} = (signed_a < signed_b)
				? {1'bx, 32'b1} : {1'bx, 32'b0};
			A_NOR: {carry_out, alu_out} = {1'bx, ~(alu_a | alu_b)};
			A_ADDU: {carry_out, alu_out} = {1'bx, alu_a + alu_b};
			A_SUBU: {carry_out, alu_out} = {1'bx, alu_a - alu_b};
			A_SLTU: {carry_out, alu_out} = (alu_a < alu_b)
				? {1'bx, 32'b1} : {1'bx, 32'b0};
			A_SLL: {carry_out, alu_out} = {1'bx, alu_b << shamt};
			A_SLLV: {carry_out, alu_out} = {1'bx, alu_b << alu_a[4:0]};
			A_SRA: {carry_out, alu_out} = {1'bx, alu_b >>> shamt};
			A_SRAV: {carry_out, alu_out} = {1'bx, alu_b >>> alu_a[4:0]};
			A_SRL: {carry_out, alu_out} = {1'bx, alu_b >> shamt};
			A_SRLV: {carry_out, alu_out} = {1'bx, alu_b >> alu_a[4:0]};
			A_XOR: {carry_out, alu_out} = {1'bx, alu_a ^ alu_b};
			default: {carry_out, alu_out} = 33'hx;
		endcase

endmodule
