`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2017 12:38:53 PM
// Design Name: 
// Module Name: pasFinal
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


module pasFinal(
    input[63:0] KEY,
    input[63:0]DATA,
    input CLK,
    output reg [63:0] OUT
    );

	reg[15:0] X0;
	reg[15:0] X1;
	reg[15:0] X2;
	reg[15:0] X3;
	
	reg[15:0] KEY1;
	reg[15:0] KEY2;
	reg[15:0] KEY3;
	reg[15:0] KEY4;
	
	
	reg[15:0] P1;
	reg[15:0] P2;
	reg[15:0] P3;
	reg[15:0] P4;

always @(*) begin

	
	
	X3[15:0] = DATA[15:0];
	X2[15:0] = DATA[31:16];
	X1[15:0] = DATA[47:32];
	X0[15:0] = DATA[63:48];

	KEY4 = KEY[15:0];
	KEY3 = KEY[31:16];
	KEY2 = KEY[47:32];
	KEY1 = KEY[63:48];
	
	P1 = (X0 * KEY1) % 65537;
	P2 = (X1 + KEY2) % 65536;
	P3 = (X2 + KEY3) % 65536;
	P4 = (X3 * KEY4) % 65537;
	
	OUT = {P1,P2,P3,P4};

end


endmodule
