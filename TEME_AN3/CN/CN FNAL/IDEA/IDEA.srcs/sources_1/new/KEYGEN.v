`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2017 12:34:57 PM
// Design Name: 
// Module Name: backup
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


module KEYGEN(
    input[127:0] KEY,
    input OPERATIE,
    input CLK,
    output reg [95:0]KEY1,
    output reg [95:0]KEY2,
    output reg [95:0]KEY3,
    output reg [95:0]KEY4,
    output reg [95:0]KEY5,
    output reg [95:0]KEY6,
    output reg [95:0]KEY7,
    output reg [95:0]KEY8,
    output reg [63:0]KEYFINAL
    );

reg[127:0] newKEY;
reg[127:0] auxKEY;

reg[95:0] K1;
reg[95:0] K2;
reg[95:0] K3;
reg[95:0] K4;
reg[95:0] K5;
reg[95:0] K6;
reg[95:0] K7;
reg[95:0] K8;
reg[63:0] KF;

reg[15:0] KD[51:0];
reg[95:0] K[7:0];
reg[15:0] toInv;
reg[15:0] rez;
reg[16:0] i;
reg[16:0] j;

always @(*) begin

	auxKEY = KEY;
	$display("%h ", auxKEY);
	K1 = auxKEY[127:32];
	K2[95:64] = auxKEY[31:0];
	
	newKEY = {auxKEY[102:0], auxKEY[127:103]}; //rotate left
	
	K2[63:0] = newKEY[127:64];
	K3[95:32] = newKEY[63:0];
	
	auxKEY = newKEY;
	newKEY = {auxKEY[102:0], auxKEY[127:103]}; //rotate left
	
	K3[31:0] = newKEY[127:96];
	K4[95:0] = newKEY[95:0];
	
	auxKEY = newKEY;
	newKEY = {auxKEY[102:0], auxKEY[127:103]}; //rotate left
	
	K5 = newKEY[127:32];
	K6[95:64] = newKEY[31:0];
	
	auxKEY = newKEY;
	newKEY = {auxKEY[102:0], auxKEY[127:103]}; //rotate left
	
	K6[63:0] = newKEY[127:64];
	K7[95:32] = newKEY[63:0];
	
	auxKEY = newKEY;
	newKEY = {auxKEY[102:0], auxKEY[127:103]}; //rotate left
	
	K7[31:0] = newKEY[127:96];
	K8[95:0] = newKEY[95:0];
	
	auxKEY = newKEY;
	newKEY = {auxKEY[102:0], auxKEY[127:103]}; //rotate left
	
	KF = newKEY[127:64];

	if (OPERATIE == 0) 
		begin
			KEY1 = K1;
			KEY2 = K2;
			KEY3 = K3;
			KEY4 = K4;
			KEY5 = K5;
			KEY6 = K6;
			KEY7 = K7;
			KEY8 = K8;
			KEYFINAL = KF;
		end
	else
		begin //decriptare
			
			K[0] = K1;
			K[1] = K2;
			K[2] = K3;
			K[3] = K4;
			K[4] = K5;
			K[5] = K6;
			K[6] = K7;
			K[7] = K8;
		
			toInv = KF[63:48];
			for (i = 0; i<65537; i = i+1) begin
				if ((toInv * i) % 65537 == 1) begin
					rez = i;
				end
			end
			KD[0] = rez;
			KD[1] = -KF[47:32];
			KD[2] = -KF[31:16];
			toInv = KF[15:0];
			for (i = 0; i<65537; i = i+1) begin
				if ((toInv * i) % 65537 == 1) begin
					rez = i;
				end
			end
			KD[3] = rez;
		
		
			for (j = 0; j<8; j = j + 1) begin
				KD[j*6 + 4] = K[8-j-1][31:16];
				KD[j*6 + 5] = K[8-j-1][15:0];
				toInv = K[8-j-1][95:80];
				for (i = 0; i<65537; i = i+1) begin
					if ((toInv * i) % 65537 == 1) begin
						rez = i;
					end
				end
				KD[j*6 + 6] = rez;
				KD[j*6 + 7] = - K[8-j-1][63:48];
				KD[j*6 + 8] = - K[8-j-1][79:64];
				toInv = K[8-j-1][47:32];
				for (i = 0; i<65537; i = i+1) begin
					if ((toInv * i) % 65537 == 1) begin
						rez = i;
					end
				end
				KD[j*6 + 9] = rez;
			end
			
			KEY1 = {KD[0],KD[1],KD[2],KD[3], KD[4], KD[5]};
			KEY2 = {KD[6],KD[7],KD[8],KD[9], KD[10], KD[11]};
			KEY3 = {KD[12],KD[13],KD[14],KD[15], KD[16], KD[17]};
			KEY4 = {KD[18],KD[19],KD[20],KD[21], KD[22], KD[23]};
			KEY5 = {KD[24],KD[25],KD[26],KD[27], KD[28], KD[29]};
			KEY6 = {KD[30],KD[31],KD[32],KD[33], KD[34], KD[35]};
			KEY7 = {KD[36],KD[37],KD[38],KD[39], KD[40], KD[41]};
			KEY8 = {KD[42],KD[43],KD[44],KD[45], KD[46], KD[47]};
			KEYFINAL = {KD[48],KD[50],KD[49],KD[51]};
			
			$display("FINAL:\n%h\n %h\n %h\n %h\n %h ",KD[48],KD[49],KD[50],KD[51], KEYFINAL);
			
		end
end

endmodule
