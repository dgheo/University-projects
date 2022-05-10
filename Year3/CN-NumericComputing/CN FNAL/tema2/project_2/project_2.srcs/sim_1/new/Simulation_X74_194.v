`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2017 08:21:47 PM
// Design Name: 
// Module Name: Simulation_X74_194
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


module Simulation_X74_194;

    reg CLR, S1, S0, SRI, SLI, A, B, C, D, CK;
    wire QA, QB, QC, QD;
    
    X74_194 uut(CLR, S1, S0, SRI, SLI, A, B, C, D, CK, QA, QB, QC, QD);
    
    initial begin
        CK = 0;
        
        CLR = 0;
        S1 = 0;
        S0 = 0;
        SRI = 0;
        SLI = 0;
        A = 0;
        B = 0;
        C = 0;
        D = 0;
        
        #100
        CLR = 1;
        S1 = 1;
        S0 = 1;
        SRI = 0;
        SLI = 0;
        A = 1;
        B = 1;
        C = 0;
        D = 1;
        
        #100
        CLR = 1;
        S1 = 0;
        S0 = 1;
        SRI = 1;
        SLI = 0;
        A = 0;
        B = 0;
        C = 0;
        D = 0;    
        
        #200
        CLR = 1;
        S1 = 1;
        S0 = 0;
        SRI = 1;
        SLI = 0;
        A = 0;
        B = 0;
        C = 0;
        D = 0;
        
    end
    
    always begin
    #50 CK = ~CK;
    end
    
endmodule
