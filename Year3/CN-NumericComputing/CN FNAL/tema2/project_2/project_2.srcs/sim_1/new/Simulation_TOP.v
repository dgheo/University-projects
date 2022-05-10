`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2017 09:36:23 AM
// Design Name: 
// Module Name: Simulation_TOP
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


module Simulation_TOP;
    
    reg [7:0] D;
    reg CEAS, RESET, RXRDY, DREQ, START;
    wire DDISP, RDY, DATE_SERIALE, DATE_OPERATIE;
    wire [3:0] CB4CLEout;
    TOP uut(D, CEAS, RESET, RXRDY, DREQ, START, DDISP, RDY, DATE_SERIALE, DATE_OPERATIE, 
             CB4CLEout);
    //

    initial begin
        CEAS = 0;
        
        RESET = 1;
        RXRDY = 0;
        DREQ = 0;
        START = 0;
        D = 8'b01010110; 
        #20;
        RESET = 0;
        #5;
        START = 1;
        #5;
        START = 0;
        #25;
        DREQ = 1;
        #25;
        DREQ = 0;
        #300;
        RXRDY = 1;
        #25;
        RXRDY = 0;
        
    end
    
    always begin
      #10  CEAS = ~CEAS;
    end

endmodule
