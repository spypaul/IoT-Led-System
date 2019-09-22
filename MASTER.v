`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/03/2019 08:32:40 AM
// Design Name: 
// Module Name: MASTER
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


module MASTER(DATAREC, SENSE, CLK, ARST_L, EN, DATASD);
input[7:0] DATAREC;
input[7:0] SENSE;
input CLK, ARST_L;
output reg EN;
output reg[9:0]DATASD;

wire[7:0] datasdt_i;
reg[7:0] datasdpwm_i;
wire arst_i;

assign arst_i = ~ARST_L;

assign datasdt_i = SENSE;

always@(posedge CLK, posedge arst_i)
begin
    if (arst_i)
    begin
        DATASD <= 10'b1111111111;
        EN <= 0;
    end
    else if(DATAREC == 1 )
    begin
        DATASD <= {1'b1,datasdt_i,1'b0};
        EN <= 1;
    end
    else if(DATAREC == 3 )
    begin
        DATASD <= {1'b1,datasdpwm_i,1'b0};
        EN <=1;
    end
    else
    begin
        DATASD <= 10'b1111111111;
        EN <= 0;    
    end
end

always@(SENSE)
begin
    if(SENSE < 10)
    begin
        datasdpwm_i <= 200;
    end
    else if(SENSE < 20 && SENSE >= 10)
    begin
        datasdpwm_i <= 100;
    end
    else if(SENSE <= 35 && SENSE >= 20)
    begin
        datasdpwm_i <= 20;
    end
    else
    begin
        datasdpwm_i <= 0;
    end
end


endmodule
