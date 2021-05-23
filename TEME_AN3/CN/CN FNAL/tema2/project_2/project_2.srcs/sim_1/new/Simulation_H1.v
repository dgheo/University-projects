`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2017 05:51:15 PM
// Design Name: 
// Module Name: Simulation_H1
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


module Simulation_H1;


    reg [7:0] D;
    wire Xor;
    
    H1 uut(D, Xor);
    
    initial begin
    D = 8'b00001111;
    #10;
    D = 8'b00011111;
    #10;
    
    end

endmodule
