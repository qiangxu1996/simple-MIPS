`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    22:02:01 04/27/2016
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module hazard_detection_unit(
	output reg pc_write, if_id_write, if_id_flush, id_ex_flush,
	input mem_read_ex, mem_read_mem, reg_write_ex, alu_src_id,
	input [4:0] reg_w_addr_ex, reg_w_addr_mem, rs_id, rt_id,
	input [5:0] op, funct,
	input branch_taken, inta
    );

	parameter beq = 6'b000100;
	parameter bne = 6'b000101;
	parameter bgtz = 6'b000111;
	parameter j = 6'b000010;
	parameter jr_op = 6'b000000;
	parameter jr_funct = 6'b001000;
	parameter cp0_instr = 6'b010000;

	parameter eret = 5'b10000;

	always @ (*)
		if (inta)
		begin
			pc_write = 1'b1;
			if_id_write = 1'b1;
			if_id_flush = 1'b1;
			id_ex_flush = 1'b1;
		end
		else if (mem_read_ex && reg_w_addr_ex
				&& (reg_w_addr_ex == rs_id || (reg_w_addr_ex == rt_id && !alu_src_id))
			|| (op == beq || op == bne || op == bgtz || op == jr_op && funct == jr_funct)
				&& (reg_write_ex && reg_w_addr_ex && reg_w_addr_ex == rs_id
					|| mem_read_mem && reg_w_addr_mem && reg_w_addr_mem == rs_id)
			|| (op == beq || op == bne)
				&& (reg_write_ex && reg_w_addr_ex && reg_w_addr_ex == rt_id
					|| mem_read_mem && reg_w_addr_mem && reg_w_addr_mem == rt_id))
			// || (op == jr_op && funct == jr_funct)
			// 	&& (reg_write_ex && reg_w_addr_ex && reg_w_addr_ex == rs_id
			// 		|| mem_read_mem && reg_w_addr_mem && reg_w_addr_mem == rs_id))
		begin
			pc_write = 1'b0;
			if_id_write = 1'b0;
			if_id_flush = 1'b0;
			id_ex_flush = 1'b1;
		end
		else if ((op == beq || op == bne || op == bgtz) && branch_taken
			|| op == j || op == cp0_instr && rs_id == eret)
		begin
			pc_write = 1'b1;
			if_id_write = 1'b1;
			if_id_flush = 1'b1;
			id_ex_flush = 1'b0;
		end
		else
		begin
			pc_write = 1'b1;
			if_id_write = 1'b1;
			if_id_flush = 1'b0;
			id_ex_flush = 1'b0;
		end

endmodule
