`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2017 08:08:37 PM
// Design Name: 
// Module Name: X74_194
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


module X74_194(CLR, S1, S0, SRI, SLI, A, B, C, D, CK, QA, QB, QC, QD);
   
    input CLR, S1, S0, SRI, SLI, A, B, C, D, CK;
    reg QA, QB, QC, QD;
    output QA, QB, QC, QD;
    
    always @(posedge CK) begin
        if(CLR == 0)
            begin
             QA = 0;
             QB = 0;
             QC = 0;
             QD = 0;
            end
        else if(S1 == 1 && S0 == 1)
            begin
             QA = A;
             QB = B;
             QC = C;
             QD = D;
            end
        else if(S1 == 1)
            begin
             QA = QB;
             QB = QC;
             QC = QD;
             QD = SLI;
            end
        else if(S0 == 1)
            begin
             QD = QC;
             QC = QB;
             QB = QA;
             QA = SRI;
            end
        
            
    end

endmodule
