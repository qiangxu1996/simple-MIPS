`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    21:10:42 04/27/2016
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module forwarding_unit_ex(
	output reg [1:0] forward_a, forward_b,
	input reg_write_mem, reg_write_wb,
	input [4:0] reg_w_addr_mem, reg_w_addr_wb, rs_ex, rt_ex
    );

	always @ (*)
	begin
		// the order shouldn't be altered because the result
		// in EX/MEM is newer than that in MEM/WB.
		// the I-type instructions use rt as dest, not rd.
		// So the results from mem are not forwarded.
		// Apr 28, 2016 indeed, rt is also forwarded.
		if (reg_write_mem && reg_w_addr_mem && reg_w_addr_mem == rs_ex)
			forward_a = 2'b01;
		else if (reg_write_wb && reg_w_addr_wb && reg_w_addr_wb == rs_ex)
			forward_a = 2'b10;
		else
			forward_a = 2'b00;

		if (reg_write_mem && reg_w_addr_mem && reg_w_addr_mem == rt_ex)
			forward_b = 2'b01;
		else if (reg_write_wb && reg_w_addr_wb && reg_w_addr_wb == rt_ex)
			forward_b = 2'b10;
		else
			forward_b = 2'b00;
	end

endmodule
