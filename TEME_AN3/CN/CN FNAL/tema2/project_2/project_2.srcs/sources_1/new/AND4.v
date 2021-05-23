`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2017 08:22:02 AM
// Design Name: 
// Module Name: AND4
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


module AND4(in1, in2, in3, in4, out);
    input in1, in2, in3, in4;
    output out;
    reg out;
    
    always @(in1, in2, in3, in4) begin
        out = in1 & in2 & in3 & in4;
    end    

endmodule
