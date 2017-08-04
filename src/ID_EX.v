`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    18:28:50 04/26/2016
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module ID_EX(
	output reg [31:0] reg_to_alu_1, reg_to_alu_2
		, sign_extend_to_alu_src_mux,
	input [31:0] read_data_1, read_data_2, immi,
	output reg [4:0] rs_ex, rt_ex, rd_ex,
	input [4:0] rs_id, rt_id, rd_id,
	output reg [4:0] shamt_ex,
	output reg [5:0] funct_ex,
	output reg [5:0] ex_ctrl_ex,
	output reg [2:0] mem_ctrl_ex,
	output reg [2:0] wb_ctrl_ex,
	input [4:0] shamt_id,
	input [5:0] funct_id,
	input [5:0] ex_ctrl_id,
	input [2:0] mem_ctrl_id,
	input [2:0] wb_ctrl_id,
	input id_ex_flush, clk, rst_n
    );

	always @ (negedge clk)
	begin
		reg_to_alu_1 <= read_data_1;
		reg_to_alu_2 <= read_data_2;
		sign_extend_to_alu_src_mux <= immi;
		shamt_ex <= shamt_id;
		funct_ex <= funct_id;
		rs_ex <= rs_id;
		rt_ex <= rt_id;
		rd_ex <= rd_id;
		if (!rst_n || id_ex_flush)
		begin
			ex_ctrl_ex <= 6'b0;
			mem_ctrl_ex <= 3'b0;
			wb_ctrl_ex <= 3'b0;
		end
		else
		begin
			ex_ctrl_ex <= ex_ctrl_id;
			mem_ctrl_ex <= mem_ctrl_id;
			wb_ctrl_ex <= wb_ctrl_id;
		end
	end

endmodule
