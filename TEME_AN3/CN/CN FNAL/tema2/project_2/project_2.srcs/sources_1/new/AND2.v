`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2017 08:18:47 AM
// Design Name: 
// Module Name: AND2
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


module AND2(in1, in2, out);

    input in1, in2;
    output out;
    reg out;

    always @(in1, in2) begin
        out = in1 & in2;
    end

endmodule
