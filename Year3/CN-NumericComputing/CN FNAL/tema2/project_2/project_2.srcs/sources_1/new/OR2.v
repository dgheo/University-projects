`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2017 08:25:09 AM
// Design Name: 
// Module Name: OR2
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


module OR2(in1, in2, out);
    input in1, in2;
    output out;
    reg out;
    
    always @(in1, in2)
        out = in1 | in2;
     

endmodule
