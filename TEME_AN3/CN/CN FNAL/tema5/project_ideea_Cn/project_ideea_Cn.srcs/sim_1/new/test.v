`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2017 12:48:10 PM
// Design Name: 
// Module Name: test
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


module test;

	// Inputs
	reg [63:0] DATA;
	reg [127:0] KEY;
	reg CLK;
	reg OPERATIE;

	// Outputs
	wire [63:0] OUT;

	// Instantiate the Unit Under Test (UUT)
	topModule uut (
		.DATA(DATA), 
		.KEY(KEY), 
		.CLK(CLK), 
		.OPERATIE(OPERATIE), 
		.OUT(OUT)
	);

	initial begin
		// Initialize Inputs
		
		OPERATIE = 0;
		KEY = 128'b00000000011001000000000011001000000000010010110000000001100100000000000111110100000000100101100000000010101111000000001100100000;
		DATA = 64'b0000010100110010000010100110010000010100110010000001100111111010;
		CLK = 0;
		
		#500
		
		OPERATIE = 1; //decriptare
		KEY = 128'b00000000011001000000000011001000000000010010110000000001100100000000000111110100000000100101100000000010101111000000001100100000;
		DATA = 64'b110010110111110100001111110011110100010010100111000101011101101;
		CLK = 0;
		
		
	end
      
endmodule
