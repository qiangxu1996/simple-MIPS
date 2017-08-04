`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    09:19:55 04/23/2016
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module control(
	output [5:0] ex_ctrl,
	output [2:0] mem_ctrl,
	output [2:0] wb_ctrl,
	output inta, excp_ret,
	input [5:0] op,
	input [4:0] rs,
	input [31:0] status, cause
    );

	parameter r_format = 6'b000000;
	parameter lw = 6'b100011;
	parameter sw = 6'b101011;
	parameter addi = 6'b001000;
	parameter addiu = 6'b001001;
	parameter andi = 6'b001100;
	parameter ori = 6'b001101;
	parameter xori = 6'b001110;
	parameter slti = 6'b001010;
	parameter sltiu = 6'b001011;
	parameter cp0_instr = 6'b010000;

	parameter mfc0 = 5'b00000;
	parameter mtc0 = 5'b00100;
	parameter eret = 5'b10000;

	reg reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write;
	wire cp0_read, cp0_write;
	reg [3:0] alu_op;

	assign ex_ctrl = {alu_op, alu_src, reg_dst};
	assign mem_ctrl = {cp0_read, mem_read, mem_write};
	assign wb_ctrl = {cp0_write, reg_write, mem_to_reg};
	assign inta = status[0] && !status[1] && status[15:8] & cause[15:8];
	assign excp_ret = op == cp0_instr && rs == eret;
	assign cp0_read = op == cp0_instr && rs == mfc0;
	assign cp0_write = op == cp0_instr && rs == mtc0;

	always @ (*)
		case (op)
			r_format:
			begin
				reg_dst = 1'b1;
				alu_src = 1'b0;
				mem_to_reg = 1'b0;
				reg_write = 1'b1;
				mem_read = 1'b0;
				mem_write = 1'b0;
				alu_op = 4'b1111;
			end
			lw:
			begin
				reg_dst = 1'b0;
				alu_src = 1'b1;
				mem_to_reg = 1'b1;
				reg_write = 1'b1;
				mem_read = 1'b1;
				mem_write = 1'b0;
				alu_op = 4'b0000;
			end
			sw:
			begin
				reg_dst = 1'b0;
				alu_src = 1'b1;
				mem_to_reg = 1'bx;
				reg_write = 1'b0;
				mem_read = 1'b0;
				mem_write = 1'b1;
				alu_op = 4'b0000;
			end
			addi, addiu, andi, ori, xori, slti, sltiu:
			begin
				reg_dst = 1'b0;
				alu_src = 1'b1;
				mem_to_reg = 1'b0;
				reg_write = 1'b1;
				mem_read = 1'b0;
				mem_write = 1'b0;
				case (op)
					addi: alu_op = 4'b0000;
					addiu: alu_op = 4'b0001;
					andi: alu_op = 4'b0010;
					ori: alu_op = 4'b0011;
					xori: alu_op = 4'b0100;
					slti: alu_op = 4'b0101;
					sltiu: alu_op = 4'b0110;
					default: alu_op = 4'bx;
				endcase
			end
			cp0_instr:
			begin
				if (rs == mfc0)
					reg_dst = 1'b0;
				else if (rs == mtc0)
					reg_dst = 1'b1;
				else
					reg_dst = 1'bx;
				alu_src = 1'bx;
				// eret not care
				mem_to_reg = 1'b0;
				if (rs == mfc0)
					reg_write = 1'b1;
				else
					reg_write = 1'b0;
				mem_read = 1'b0;
				mem_write = 1'b0;
				alu_op = 4'bx;
			end
			default:
			begin
				reg_dst = 1'bx;
				alu_src = 1'bx;
				mem_to_reg = 1'bx;
				reg_write = 1'b0;
				mem_read = 1'bx;
				mem_write = 1'b0;
				alu_op = 4'bx;
			end
		endcase

endmodule
