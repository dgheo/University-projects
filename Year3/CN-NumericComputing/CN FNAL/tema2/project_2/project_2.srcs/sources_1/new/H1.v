`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2017 05:48:15 PM
// Design Name: 
// Module Name: H1
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


module H1(D, Xor);

input [7:0] D;
reg Xor;
output Xor;

always @(D)
    begin
    Xor = D[0] ^ D[1] ^ D[2] ^ D[3] ^ D[4] ^ D[5] ^ D[6] ^ D[7];
    end
endmodule
