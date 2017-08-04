`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    17:32:12 04/28/2016
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module forwarding_unit_mem(
	output reg forward,
	input reg_write_wb,
	input [4:0] reg_w_addr_wb, reg_w_addr_mem
    );

	always @ (*)
		if (reg_write_wb && reg_w_addr_wb
			&& reg_w_addr_wb == reg_w_addr_mem)
			forward = 1'b1;
		else
			forward = 1'b0;

endmodule
