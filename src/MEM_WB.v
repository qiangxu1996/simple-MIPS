`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    18:29:39 04/26/2016
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module MEM_WB(
	output reg [31:0] dm_r_data_wb, alu_result_wb,
	output reg [4:0] reg_w_addr_wb,
	input [31:0] dm_r_data_mem, alu_result_mem,
	input [4:0] reg_w_addr_mem,
	output reg [2:0] wb_ctrl_wb,
	input [2:0] wb_ctrl_mem,
	input clk, rst_n
    );

	always @ (negedge clk)
	begin
		dm_r_data_wb <= dm_r_data_mem;
		alu_result_wb <= alu_result_mem;
		reg_w_addr_wb <= reg_w_addr_mem;
		if (!rst_n)
			wb_ctrl_wb <= 3'b0;
		else
			wb_ctrl_wb <= wb_ctrl_mem;
	end

endmodule
