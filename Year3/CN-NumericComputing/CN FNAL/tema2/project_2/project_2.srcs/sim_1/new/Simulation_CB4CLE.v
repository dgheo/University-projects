`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2017 07:29:06 PM
// Design Name: 
// Module Name: Simulation_CB4CLE
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


module Simulation_CB4CLE;

    reg [3:0] D;
    reg CLR, L, CE, C;
    
    wire TC, CEO;
    wire [3:0] Q;
    
    CB4CLE uut(CLR, L, CE, C, D, Q, TC, CEO);
    
    initial begin
        C = 0;
        
        CLR = 1;
        L = 0;
        CE = 0;
        D = 4'b0000;
    
        #100
        CLR = 0;
        L = 1;
        CE = 0;
        D = 4'b0001;
        
        #100
        CLR = 0;
        L = 0;
        CE = 0;
        D = 4'b0010;
        
        #100
        CLR = 0;
        L = 0;
        CE = 1;
        D = 4'b0000;
        
        
  
       
    end
    
    always begin
    #50 C = ~C;
    end

endmodule
