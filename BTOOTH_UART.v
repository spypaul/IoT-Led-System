`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2019 09:24:18 AM
// Design Name: 
// Module Name: BTOOTH_UART
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


module BTOOTH_UART(RX, TX, CLK, SENSE, ARST_L);
input RX, CLK, ARST_L;
input[7:0] SENSE;
output TX;
//output[9:0] LED;

wire clk_fast, clk_slow, en_i;
wire[7:0] datarec_i;
wire[9:0] datasd_i;
CLKDIVF U1(.CLKIN(CLK), .ACLR_L(ARST_L), .CLKOUT(clk_fast));
CLKDIVS U2(.CLKIN(clk_fast), .ACLR_L(ARST_L), .CLKOUT(clk_slow));
MASTER U3(.DATAREC(datarec_i), .SENSE(SENSE), .CLK(clk_slow), .ARST_L(ARST_L), .EN(en_i), .DATASD(datasd_i));
RX U4(.RX(RX), .CLK(clk_fast), .ARST_L(ARST_L), .DATAREC(datarec_i));
TX U5(.DATASD(datasd_i), .CLK(clk_slow), .ARST_L(ARST_L), .EN(en_i), .TX(TX));
endmodule
