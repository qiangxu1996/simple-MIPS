`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    08:54:24 04/23/2016
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module alu_control(
	output reg [3:0] alu_control_input,
	input [3:0] alu_op,
	input [5:0] funct
    );

	parameter lw = 4'b0000, sw = 4'b0000, addi = 4'b0000, addiu = 4'b0001
		, andi = 4'b0010, ori = 4'b0011, xori = 4'b0100, slti = 4'b0101
		, sltiu = 4'b0110, r_type = 4'b1111;
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

	always @ (*)
		case (alu_op)
			lw: alu_control_input = A_ADD;
			addiu: alu_control_input = A_ADDU;
			andi: alu_control_input = A_AND;
			ori: alu_control_input = A_OR;
			xori: alu_control_input = A_XOR;
			slti: alu_control_input = A_SLT;
			sltiu: alu_control_input = A_SLTU;
			r_type:
				case (funct)
					6'b100000: alu_control_input = A_ADD;
					6'b100001: alu_control_input = A_ADDU;
					6'b100010: alu_control_input = A_SUB;
					6'b100011: alu_control_input = A_SUBU;
					6'b100100: alu_control_input = A_AND;
					6'b100101: alu_control_input = A_OR;
					6'b100111: alu_control_input = A_NOR;
					6'b101010: alu_control_input = A_SLT;
					6'b101011: alu_control_input = A_SLTU;
					6'b000000: alu_control_input = A_SLL;
					6'b000100: alu_control_input = A_SLLV;
					6'b000011: alu_control_input = A_SRA;
					6'b000111: alu_control_input = A_SRAV;
					6'b000010: alu_control_input = A_SRL;
					6'b000110: alu_control_input = A_SRLV;
					6'b100110: alu_control_input = A_XOR;
					default: alu_control_input = 4'bx;
				endcase
			default: alu_control_input = 4'bx;
		endcase

endmodule
