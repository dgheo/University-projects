`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2017 06:26:29 PM
// Design Name: 
// Module Name: max16b
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module max16b(a,b,c,y);
	input signed [15:0] a,b,c;
	output signed [15:0] y;

	wire u1_lt;
	assign u1_lt = (a < b);

	wire signed [15:0] max_ab;
	assign max_ab = u1_lt ? b : a;

	wire u2_lt;
	assign u2_lt = (c < max_ab);

	assign y = u2_lt ? c:max_ab;

endmodule
