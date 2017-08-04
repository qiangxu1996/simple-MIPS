`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    18:29:21 04/26/2016
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module EX_MEM(
	output reg [31:0] alu_result_mem, alu_src_2_mem,
	output reg [4:0] reg_w_addr_mem,
	input [31:0] alu_result_ex, alu_src_2_ex,
	input [4:0] reg_w_addr_ex,
	output reg [2:0] mem_ctrl_mem,
	output reg [2:0] wb_ctrl_mem,
	input [2:0] mem_ctrl_ex,
	input [2:0] wb_ctrl_ex,
	input clk, rst_n
    );

	always @ (negedge clk)
	begin
		alu_result_mem <= alu_result_ex;
		alu_src_2_mem <= alu_src_2_ex;
		reg_w_addr_mem <= reg_w_addr_ex;
		if (!rst_n)
		begin
			mem_ctrl_mem <= 3'b0;
			wb_ctrl_mem <= 3'b0;
		end
		else
		begin
			mem_ctrl_mem <= mem_ctrl_ex;
			wb_ctrl_mem <= wb_ctrl_ex;
		end
	end

endmodule
