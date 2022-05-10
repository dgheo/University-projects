`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2017 06:32:38 PM
// Design Name: 
// Module Name: Simulation_FDRSE
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


module Simulation_FDRSE;
    reg R, S, CE, D, C;
    wire Q;
    
    FDRSE uut(R, S, CE, D, C, Q);
    
    initial begin
    C = 0;
    
    R = 1;
    S = 0;
    CE = 0;
    D = 0;
    #200;
    R = 0;
    S = 1;
    CE = 0;
    D = 0;
    #200;
    R = 0;
    S = 0;
    CE = 0;
    D = 0;
    #200;
    R = 0;
    S = 0;
    CE = 1;
    D = 0;
    #200;
    R = 0;
    S = 0;
    CE = 1;
    D = 1;
    #200;
    R = 0;
    S = 0;
    CE = 0;
    D = 0;
    
    
    end
    
    
    always begin
    #100 C = ~C; 
    end
    
    
endmodule
