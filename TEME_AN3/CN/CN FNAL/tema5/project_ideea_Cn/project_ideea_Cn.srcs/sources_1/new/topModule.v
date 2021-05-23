`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2017 12:46:39 PM
// Design Name: 
// Module Name: topModule
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


module topModule(
    input[63:0] DATA,
    input[127:0] KEY,
    input CLK,
    input OPERATIE,
    output reg [63:0]OUT
    );


	wire[95:0] KEY1;
	wire[95:0] KEY2;
	wire[95:0] KEY3;
	wire[95:0] KEY4;
	wire[95:0] KEY5;
	wire[95:0] KEY6;
	wire[95:0] KEY7;
	wire[95:0] KEY8;
	wire[63:0] KEYFINAL;
	
	wire[63:0] OUT1;
	wire[63:0] OUT2;
	wire[63:0] OUT3;
	wire[63:0] OUT4;
	wire[63:0] OUT5;
	wire[63:0] OUT6;
	wire[63:0] OUT7;
	wire[63:0] OUT8;
	wire[63:0] OUTFINAL;

	KEYGEN kg(KEY, OPERATIE, CLK, KEY1, KEY2, KEY3, KEY4, KEY5, KEY6, KEY7, KEY8, KEYFINAL);
	
	pasulx P1(KEY1, DATA, CLK, OUT1);
	
	pasulx P2(KEY2, OUT1, CLK, OUT2);
	
	pasulx P3(KEY3, OUT2, CLK, OUT3);
	
	pasulx P4(KEY4, OUT3, CLK, OUT4);
	
	pasulx P5(KEY5, OUT4, CLK, OUT5);
	
	pasulx P6(KEY6, OUT5, CLK, OUT6);
	
	pasulx P7(KEY7, OUT6, CLK, OUT7);
	
	pasulx P8(KEY8, OUT7, CLK, OUT8);
	
	pasFinal P9(KEYFINAL, OUT8, CLK, OUTFINAL);

always @(*) begin 
	OUT = OUTFINAL;
end


endmodule
