`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    18:28:28 04/26/2016
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module IF_ID(
	output reg [31:0] instruction, pc_plus_4_id, address_id,
	output reg valid,
	input [31:0] im_data, pc_plus_4_if, address_if,
	input if_id_write, if_id_flush, clk, rst_n
    );

	always @ (negedge clk)
	begin
		if (if_id_write)
		begin
			pc_plus_4_id <= pc_plus_4_if;
			address_id <= address_if;
		end

		if (!rst_n || if_id_flush)
		begin
			instruction <= 32'b0;
			valid <= 1'b0;
		end
		else if (if_id_write)
		begin
			instruction <= im_data;
			valid <= 1'b1;
		end
	end

endmodule
