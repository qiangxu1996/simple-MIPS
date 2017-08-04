`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    22:35:27 04/22/2016
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module CPU(
	output [31:0] im_addr, dm_addr,
	input [31:0] im_data,
	output [31:0] dm_w_data,
	input [31:0] dm_r_data_mem,
	output mem_read, mem_write,
	input [5:0] int_level,
	input intr, clk, rst_n
    );

	// IF stage
	wire [31:0] branch_target, jump_addr, pc_plus_4_or_br, pc_plus_4_or_br_or_jump;

	// ID stage
	wire [31:0] instruction, branch_rs, branch_rt, address_id;
	wire [31:0] read_data_1, read_data_2, read_data_2_excp, immi;

	// EX stage
	wire [31:0] reg_to_alu_1, reg_to_alu_2
		, alu_src_mux_to_alu, sign_extend_to_alu_src_mux;
	wire [31:0] alu_src_1, alu_src_2_ex;
	wire [4:0] rs_ex, rt_ex, rd_ex, shamt;

	// MEM stage
	wire [31:0] alu_src_2_mem;

	// WB stage
	wire [31:0] dm_r_data_wb;
	wire [31:0] mem_to_reg_mux_to_reg;

	// cross stages
	wire [31:0] alu_result_ex, alu_result_mem, alu_result_mem_excp, alu_result_wb;
	wire [31:0] pc_plus_4_if, pc_plus_4_id, npc;
	wire [4:0] reg_w_addr_ex, reg_w_addr_mem, reg_w_addr_wb;

	// control signals in pipline reg
	wire [5:0] ex_ctrl_id, ex_ctrl_ex;
	wire [2:0] mem_ctrl_id, mem_ctrl_ex, mem_ctrl_mem;
	wire [2:0] wb_ctrl_id, wb_ctrl_ex, wb_ctrl_mem, wb_ctrl_wb;
	wire [5:0] funct;

	// control signals out of pipline reg
	wire reg_write, alu_src, mem_to_reg, reg_dst;
	wire [3:0] alu_op;
	wire [3:0] alu_control_to_alu;

	// extra control signals
	wire pc_write, if_id_write, id_ex_flush, if_id_flush
		, forward_mem, forward_br_a, forward_br_b, jump_addr_sel, jump;
	wire [1:0] forward_a, forward_b;

	// exception signals
	wire [31:0] cp0_out, status, cause;
	reg [31:0] epc;
	wire [4:0] cp0_out_addr;
	wire inta, excp_ret, cp0_read, cp0_write, id_valid;
	reg inta_pending;

	always @ (posedge clk)
		inta_pending <= inta;
	always @ (negedge clk)
		epc <= id_valid ? address_id : im_addr;

	PC pc (im_addr, npc, pc_write, clk, rst_n);
	registers rf (read_data_1, read_data_2
		, instruction[25:21], instruction[20:16], reg_w_addr_wb
		, mem_to_reg_mux_to_reg, reg_write, clk);
	ALU alu (alu_result_ex, , alu_src_1, alu_src_mux_to_alu, shamt, alu_control_to_alu);

	alu_control ac (alu_control_to_alu, alu_op, funct);
	control cu (ex_ctrl_id, mem_ctrl_id, wb_ctrl_id, inta, excp_ret
		, instruction[31:26], instruction[25:21], status, cause);
	forwarding_unit_id fui (forward_br_a, forward_br_b, wb_ctrl_mem[1]
		, reg_w_addr_mem, instruction[25:21], instruction[20:16]);
	forwarding_unit_ex fue (forward_a, forward_b
		, wb_ctrl_mem[1], reg_write
		, reg_w_addr_mem, reg_w_addr_wb, rs_ex, rt_ex);
	// another forwarding unit for mem copy should be added
	// Apr 28, 2016 see below
	forwarding_unit_mem fum (forward_mem, reg_write
		, reg_w_addr_wb, reg_w_addr_mem);
	hazard_detection_unit hdu (pc_write, if_id_write, if_id_flush, id_ex_flush
		, mem_ctrl_ex[1], mem_ctrl_mem[1], wb_ctrl_ex[1], ex_ctrl_id[1]
		, reg_w_addr_ex, reg_w_addr_mem
		, instruction[25:21], instruction[20:16]
		, instruction[31:26], instruction[5:0], branch_taken, inta);
	branch_validate bv (branch_taken, instruction[31:26], branch_rs, branch_rt);
	jump_detect jd (jump_addr_sel, jump, instruction[31:26], instruction[5:0]);

	cp0 cp (cp0_out, status, cause, alu_result_wb, epc, reg_w_addr_wb, cp0_out_addr
		, int_level, cp0_write, intr, inta, excp_ret, clk, rst_n);

	add add_4 (pc_plus_4_if, im_addr, 32'd4);
	add branch_alu (branch_target, pc_plus_4_id, {immi[29:0], 2'b0});

	mux_4_1 forward_a_mux (alu_src_1, reg_to_alu_1, alu_result_mem
		, mem_to_reg_mux_to_reg, , forward_a);
	mux_4_1 forward_b_mux (alu_src_2_ex, reg_to_alu_2, alu_result_mem
		, mem_to_reg_mux_to_reg, , forward_b);
	mux_32 forward_br_a_mux (branch_rs, read_data_1, alu_result_mem, forward_br_a);
	mux_32 forward_br_b_mux (branch_rt, read_data_2, alu_result_mem, forward_br_b);
	mux_32 alu_src_mux (alu_src_mux_to_alu
		, alu_src_2_ex, sign_extend_to_alu_src_mux, alu_src);
	mux_32 forward_mem_mux (dm_w_data, alu_src_2_mem, mem_to_reg_mux_to_reg
		, forward_mem);
	mux_32 mem_to_reg_mux (mem_to_reg_mux_to_reg
		, alu_result_wb, dm_r_data_wb, mem_to_reg);
	mux_5 reg_dst_mux (reg_w_addr_ex, rt_ex, rd_ex, reg_dst);
	sign_extend se (immi, instruction[15:0]);
	mux_32 branch_mux (pc_plus_4_or_br, pc_plus_4_if, branch_target
		, branch_taken);
	mux_32 jump_addr_mux (jump_addr
		, {pc_plus_4_id[31:28], instruction[25:0], 2'b0}
		, branch_rs, jump_addr_sel);
	mux_32 jump_mux (pc_plus_4_or_br_or_jump, pc_plus_4_or_br, jump_addr, jump);
	mux_4_1 excp_mux (npc, pc_plus_4_or_br_or_jump, 32'h80000180, cp0_out,
		, {excp_ret, inta});
	mux_32 cp0_data_id_mux (read_data_2_excp, read_data_2, cp0_out, mem_ctrl_id[2]);
	mux_5 cp0_out_addr_mux (cp0_out_addr, instruction[15:11], 5'd14, excp_ret);
	mux_32 cp0_data_mem_mux (alu_result_mem_excp, alu_result_mem, alu_src_2_mem
		, cp0_read | wb_ctrl_mem[2]);

	assign dm_addr = alu_result_mem;

	assign {alu_op, alu_src, reg_dst} = ex_ctrl_ex;
	assign {cp0_read, mem_read, mem_write} = mem_ctrl_mem;
	assign {cp0_write, reg_write, mem_to_reg} = wb_ctrl_wb;

	IF_ID if_id (instruction, pc_plus_4_id, address_id, id_valid
		, im_data, pc_plus_4_if, im_addr
		, if_id_write, if_id_flush, clk, rst_n);
	ID_EX id_ex (reg_to_alu_1, reg_to_alu_2, sign_extend_to_alu_src_mux
		, read_data_1, read_data_2_excp, immi
		, rs_ex, rt_ex, rd_ex
		, instruction[25:21], instruction[20:16], instruction[15:11]
		, shamt, funct, ex_ctrl_ex, mem_ctrl_ex, wb_ctrl_ex
		, instruction[10:6], instruction[5:0], ex_ctrl_id, mem_ctrl_id, wb_ctrl_id
		, id_ex_flush, clk, rst_n);
	EX_MEM ex_mem (alu_result_mem, alu_src_2_mem, reg_w_addr_mem
		, alu_result_ex, alu_src_2_ex, reg_w_addr_ex
		, mem_ctrl_mem, wb_ctrl_mem
		, mem_ctrl_ex, wb_ctrl_ex
		, clk, rst_n);
	MEM_WB mem_wb (dm_r_data_wb, alu_result_wb, reg_w_addr_wb
		, dm_r_data_mem, alu_result_mem_excp, reg_w_addr_mem
		, wb_ctrl_wb, wb_ctrl_mem
		, clk, rst_n);

endmodule
