`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2017 12:40:24 PM
// Design Name: 
// Module Name: pasIntermediar
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


module pasIntermediar(
    input[95:0] KEY,
    input[63:0]DATA,
    input CLK,
    output reg[63:0]OUT
    );
//?????!!!!Între pasii 2 si 3, sub-blocurile sunt interschimbate, iar în final cele 4
   reg[15:0] X0;
	reg[15:0] X1;
	reg[15:0] X2;
	reg[15:0] X3;
	
	reg[15:0] KEY1;
	reg[15:0] KEY2;
	reg[15:0] KEY3;
	reg[15:0] KEY4;
	reg[15:0] KEY5;
	reg[15:0] KEY6;
	
	reg[15:0] P1;
	reg[15:0] P2;
	reg[15:0] P3;
	reg[15:0] P4;
	reg[15:0] P5;
	reg[15:0] P6;
	reg[15:0] P7;
	reg[15:0] P8;
	reg[15:0] P9;
	reg[15:0] P10;
	reg[15:0] P11;
	reg[15:0] P12;
	reg[15:0] P13;
	reg[15:0] P14;

always @(*) 
begin
	X3 = DATA[15:0];
	X2 = DATA[31:16];
	X1 = DATA[47:32];
	X0 = DATA[63:48];

	KEY6 = KEY[15:0];
	KEY5 = KEY[31:16];
	KEY4 = KEY[47:32];
	KEY3 = KEY[63:48];
	KEY2 = KEY[79:64];
	KEY1 = KEY[95:80];
	
	P1 = X0;
	P2 = X1;
	P3 = X2;
	P4 = X3;
	P5 = P1^P3;
	P6 = P2^P4;
	P7 = (P5*KEY5) % 65537;
	P8 = (P6+P7) % 65536;
	P9 = (P8*KEY6) % 65537;
	P10 =(P7+P9) % 65536;
	
	P11 = P1 ^ P9;
	P12 = P3 ^ P9;
	P13 = P2 ^ P10;
	P14 = P4 ^ P10;
	
	//posibil sa nu fie asta ordinea
	OUT = {P11, P13, P12, P14};

end
endmodule
