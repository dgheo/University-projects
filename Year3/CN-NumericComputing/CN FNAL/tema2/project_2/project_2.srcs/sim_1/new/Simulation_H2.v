`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2017 08:02:48 AM
// Design Name: 
// Module Name: Simulation_H2
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


module Simulation_H2;
    
    reg ceas, reset, start, dreq, num12, rxrdy;
    wire rdy, incarc, ddisp, depl, txrdy;
    
    H2 uut(ceas, reset, start, dreq, num12, rxrdy, rdy, incarc, ddisp, depl, txrdy);
    
    initial begin
        ceas = 0;
        
        reset = 1;
        start = 0;
        dreq = 0;
        num12 = 0;
        rxrdy = 0;
    #20;
        reset = 0;
        start = 1;
    #40;
       dreq = 1;
    #40;
        
        
        
   
        
    end
    
    always begin
      #10 ceas = ~ceas;
    end

endmodule
