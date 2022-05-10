`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2017 06:32:26 PM
// Design Name: 
// Module Name: tb_max16b
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


module tb_max16b;
    reg signed [15:0] a,b,c;
    wire signed [15:0] y;
    reg[8*100:1] align;
    integer fd;
    integer count, status;
    integer i_a, i_b, i_c, i_result;
    integer errors;
    max16b uut(a,b,c,y);
    initial begin
        a=0; b=0; c=0;
        fd = $fopen("../../../values.txt", "r");
        if (fd == 0)
            fd = $fopen("../../../../values.txt", "r");
        count = 1;
        # 100;
        errors = 0;
        while ($fgets(align, fd))
        begin
            status = $sscanf(align, "%d %d %d %d", i_a, i_b, i_c, i_result);
            a = i_a; b = i_b; c = i_c;
            # 50;
            if (y == i_result)
                $display("%d(%t): pass, a:%d, b:%d, c:%d, y:%d\n", count, $time, a, b, c, y);
            else
            begin
                $display("%d(%t): fail, a:%d, b:%d, c:%d, y(actual):%d, y(asteptat):%d\n", count, $time, a, b, c, y, i_result);
                errors = errors + 1;
            end
            
            count = count + 1;
        end
    end
endmodule
