`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2017 08:26:33 AM
// Design Name: 
// Module Name: TOP
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


module TOP(D, CEAS, RESET, RXRDY, DREQ, START, DDISP, RDY, DATE_SERIALE, DATE_OPERATIE,
             CB4CLEout);
    input[7:0] D;
    input CEAS, RESET, START, RXRDY, DREQ;
    output DATE_SERIALE, DATE_OPERATIE, DDISP, RDY;
    output[3:0] CB4CLEout;

    wire DATE_SERIALE, DATE_OPERATIE, DDISP, RDY;
    
    wire XorOut, num12In, incarcOut, deplOut, setIn1, invOut1, resetIn1, fdrse1Out, InvReset;
    wire S1Out;
    wire QA1out, QB1out, QC1out, QD1out;
    wire QA2out, QB2out, QC2out, QD2out;
    wire Or2out;
    wire [3:0] CB4CLEout;
    wire TC, CEO;
    wire And4in0, And4in1;
    H2 centru(CEAS, RESET, START, DREQ, num12In, RXRDY, RDY, incarcOut, DDISP, deplOut, txrdyOut);
    //module H2(ceas, reset, start, dreq, num12, rxrdy, rdy, incarc, ddisp, depl, txrdy);


    
    H1 circ_gen_parit(D, XorOut);
    AND2 and2_1(XorOut, incarcOut, setIn1);
    INV inv_1(XorOut, InvOut1);
    AND2 and2_2(InvOut1, incarcOut, resetIn1);
    FDRSE fdrse1(resetIn1, setIn1, deplOut, 1, CEAS, fdrse1Out);
    //R, S, CE, D, C, Q
    
    INV inv_2(RESET, InvReset);
    OR2 or2(deplOut, incarcOut, S1Out);
    X74_194 reg1(InvReset, S1Out, incarcOut, 1, fdrse1Out, D[4], D[5], D[6], D[7], CEAS, QA1out, QB1out, QC1out, QD1out);
    //CLR, S1, S0, SRI, SLI, A, B, C, D, CK, QA, QB, QC, QD
    X74_194 reg2(InvReset, S1Out, incarcOut, 1, QA1out, D[0], D[1], D[2], D[3], CEAS, QA2out, QB2out, QC2out, QD2out);
    FDRSE fdrse2(incarcOut, RESET, deplOut, QA2out, CEAS, DATE_SERIALE);
     //R, S, CE, D, C, Q
     
    OR2 or3(RESET, DATE_OPERATIE, Or2out);
    CB4CLE cb4cle(Or2out, 0, deplOut, CEAS, 4'b0000, CB4CLEout, TC, CEO);
    //CLR, L, CE, C, D, Q, TC, CEO
    
    
    INV inv_3(CB4CLEout[0], And4in0);
    INV inv_4(CB4CLEout[1], And4in1);
    AND4 and4(And4in0, And4in1, CB4CLEout[2], CB4CLEout[3], num12In);
    
    FDCE fdce(RESET, txrdyOut, CEAS, 1, DATE_OPERATIE);
    //CLR, CE, C, D, Q
    


endmodule
