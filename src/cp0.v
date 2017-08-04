`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    20:53:40 05/21/2016
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module cp0(
	output reg [31:0] dout,
	output [31:0] status, cause,
	input [31:0] din, epc,
	input [4:0] in_addr, out_addr,
	input [5:0] int_level,
	input reg_w, intr, inta, excp_ret, clk, rst_n
    );

	reg [31:0] cp0_reg[32:0];

	assign status = cp0_reg[12];
	assign cause = cp0_reg[13];

	always @ (posedge clk)
	begin
		if (!rst_n)
		begin
			cp0_reg[12][15:8] <= 8'hFF;
			cp0_reg[12][4] <= 1'b1;
			cp0_reg[12][1:0] <= 2'b01;
			cp0_reg[13][15:8] <= 8'h0;
		end
		else if (inta)
		begin
			cp0_reg[12][1:0] <= 2'b10;
			cp0_reg[14] <= epc;
		end
		else if (excp_ret)
		begin
			cp0_reg[12][1] <= 1'b0;
		end
		else if (reg_w)
		begin
			cp0_reg[in_addr] <= din;
		end
		else if (intr)
		begin
			cp0_reg[13][15:10] <= int_level;
			cp0_reg[13][6:2] <= 5'd0;
		end

		if (intr && 4'd13 == out_addr)
			dout <= {cp0_reg[13][31:16], int_level, cp0_reg[13][9:5], 5'd0, cp0_reg[13][1:0]};
		else
			dout <= cp0_reg[out_addr];
	end

endmodule
