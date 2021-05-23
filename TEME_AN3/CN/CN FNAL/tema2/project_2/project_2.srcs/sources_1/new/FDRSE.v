`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2017 06:27:48 PM
// Design Name: 
// Module Name: FDRSE
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


module FDRSE(R, S, CE, D, C, Q);

input R, S, CE, D, C;
reg Q;
output Q;

always @(posedge C)
    if(R) 
        Q = 0;
    else if(S)
        Q = 1;
    else if(CE)
        Q = D;
    
endmodule
