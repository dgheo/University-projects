`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2017 06:10:15 PM
// Design Name: 
// Module Name: Simulation_FDCE
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


module Simulation_FDCE;

reg CLR, CE, C, D;
wire Q;

FDCE uut(CLR, CE, C, D, Q);

initial begin
    C = 0;
    
    CLR = 1;
    D = 0;
    CE = 0;
#200;
    CLR = 0;
    D = 1;
    CE = 1;
#200;
    CLR = 0;
    D = 0;
    CE = 0;
    
end

always begin
    #100 C = ~C;
end

endmodule
