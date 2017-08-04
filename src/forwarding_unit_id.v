`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    20:17:43 04/28/2016
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module forwarding_unit_id(
	output reg forward_a, forward_b,
	input reg_write_mem,
	input [4:0] reg_w_addr_mem, rs_id, rt_id
    );

	always @ (*)
	begin
		if (reg_write_mem && reg_w_addr_mem && reg_w_addr_mem == rs_id)
			forward_a = 1'b1;
		else
			forward_a = 1'b0;

		if (reg_write_mem && reg_w_addr_mem && reg_w_addr_mem == rt_id)
			forward_b = 1'b1;
		else
			forward_b = 1'b0;
	end

endmodule
