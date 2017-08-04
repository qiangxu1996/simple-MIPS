`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    23:15:17 04/22/2016
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module sign_extend(
	output [31:0] extended,
	input [15:0] src
    );

	assign extended = src[15] ? {16'hFFFF, src} : {16'h0, src};

endmodule
