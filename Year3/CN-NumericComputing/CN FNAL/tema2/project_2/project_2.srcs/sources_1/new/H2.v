`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2017 08:46:15 PM
// Design Name: 
// Module Name: H2
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


module H2(ceas, reset, start, dreq, num12, rxrdy, rdy, incarc, ddisp, depl, txrdy);

    input ceas, reset, start, dreq, num12, rxrdy;
    output rdy, incarc, ddisp, depl, txrdy;
    reg rdy, incarc, ddisp, depl, txrdy;

    
    reg[2:0] current_state;
    reg[2:0] next_state;


    always @(reset)
        begin
        if(reset) next_state = 3'b000;
        end
        
    always @(posedge ceas)
        begin
        current_state = next_state;
        end    
     
         
     always @(posedge ceas, start, dreq, rxrdy, current_state, num12)
        begin
            if(current_state == 3'b000)
                    begin
                    rdy = 1;
                    incarc = 0;
                    ddisp = 0;
                    depl = 0;
                    txrdy = 0;
                    if(start) 
                        begin
                        next_state = 3'b001;

                        end
                    end
            else if(current_state == 3'b001)
                begin
                rdy = 0;
                next_state = 3'b010;
                incarc = 1;
                end
            else if(current_state == 3'b010)
                begin
                    incarc = 0;
                    ddisp = 1;
                    if(dreq)
                        begin
                        next_state = 3'b011;
                        end
                    else next_state = 3'b010;
                end
            else if(current_state == 3'b011)
                begin
                    ddisp = 0;
                    depl = 1;
                    next_state = 3'b100;
                end
            else if(current_state == 3'b100)
                begin
                    if(num12) 
                        begin
                        depl = 0;
                        next_state = 3'b101;
                        current_state = 3'b101;
                        end
                end
           else if(current_state == 3'b101)
                begin
                    txrdy = 1;
                    if(rxrdy) 
                        begin
                        next_state = 3'b000;
                        end
                    else next_state = 3'b101;

                end
        end

endmodule
