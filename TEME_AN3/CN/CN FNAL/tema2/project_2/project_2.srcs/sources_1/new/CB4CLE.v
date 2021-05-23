`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2017 07:11:57 PM
// Design Name: 
// Module Name: CB4CLE
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


module CB4CLE(CLR, L, CE, C, D, Q, TC, CEO);

input [3:0] D;
reg [3:0] Q;
output [3:0] Q;

input CLR, L, CE, C;
reg  TC, CEO;
output TC, CEO;

always @(posedge C | CLR)
    begin
        if(CLR)
           begin
            Q = 0;
            TC = 0;
            CEO = 0;
           end
        else if(L)
            begin
               Q[3:0] = D[3:0];
               TC = Q[0] ^ Q[1] ^ Q[2] ^ Q[3];
               CEO = TC ^ CE;
            end
        else if(CE)
            begin
               Q[3:0] = Q[3:0] + 4'b0001;
               TC = Q[0] ^ Q[1] ^ Q[2] ^ Q[3];
               CEO = TC ^ CE;
            end
        else
            begin
               CEO = 0;
            end
    end

endmodule
