`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/03/2019 08:37:37 AM
// Design Name: 
// Module Name: RX
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


module RX(RX, CLK, ARST_L, DATAREC);
input RX, CLK, ARST_L;
output reg[7:0] DATAREC;

wire arst_i, en_i, end_i;
reg[3:0]cntb_i;
reg[3:0]cntt_i;
reg[9:0]regdata_i;

reg currents_i, nexts_i;

parameter WAIT = 0;
parameter REC = 1;


assign arst_i = ~ARST_L;

always@(posedge CLK, posedge arst_i)
begin
	if(arst_i) // || cntt_i == 15)
	begin
		cntt_i <= 4'b0000;
	end
	else if(en_i)
	begin
		cntt_i <= cntt_i+1;
	end
	else 
	begin
		cntt_i <= 4'b0000;
	end	
end

always@(posedge CLK, posedge arst_i)
begin
        if(arst_i || end_i)
        begin
                cntb_i <= 4'b0000;
        end
        else if(cntt_i == 15)
        begin
                cntb_i <= cntb_i+1;
        end
        else
        begin
                cntb_i <= cntb_i;
        end
end

always@(posedge CLK, posedge arst_i)
begin
	if(arst_i)// || end_i)
	begin
		regdata_i <= 10'b0000000000;
	end	
	else if(cntt_i == 8)
	begin 
		regdata_i <= {RX, regdata_i[9:1]};
	end
	else 
	begin
		regdata_i <= regdata_i;
	end	
end	

always@(posedge CLK, posedge arst_i)
begin
    if(arst_i)
        DATAREC <= 0;
    else 
        DATAREC <= regdata_i[8:1];
end
//state machine

always@(posedge CLK, posedge arst_i)
begin 
	if(arst_i)
	begin
		currents_i <= WAIT;
	end	
	else
	begin
		currents_i <= nexts_i;
	end	
end

always@(currents_i, cntb_i, RX, cntt_i)
begin
	case(currents_i)
	WAIT:
	begin
		if(RX == 1'b0)
		  nexts_i <= REC;
		else	
		  nexts_i <= WAIT;

	end

	REC:
	begin
	   if(cntb_i == 10)
	       nexts_i <= WAIT;
       else	
           nexts_i <= REC;

	end

	endcase	
end	

assign en_i = (currents_i == REC)? 1'b1:1'b0;
assign end_i = (currents_i == WAIT)? 1'b1:1'b0;
endmodule

