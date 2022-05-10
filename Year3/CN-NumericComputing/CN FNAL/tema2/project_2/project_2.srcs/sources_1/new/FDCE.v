`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2017 06:01:26 PM
// Design Name: 
// Module Name: FDCE
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


module FDCE(CLR, CE, C, D, Q);

    input CLR, CE, C, D;
    reg Q;
    output Q;
    
    always @(posedge C or CLR or CE)
    begin
        if(CLR)
            Q = 0;
        else if (CE)
            Q = D;
    end
    
    
endmodule
