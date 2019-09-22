`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/03/2019 08:38:49 AM
// Design Name: 
// Module Name: TX
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


module TX(DATASD, CLK, ARST_L, EN, TX);
input[9:0]DATASD;
input CLK, ARST_L, EN;
output TX; 


wire arst_i;
reg[9:0]datasd_i;
reg[3:0] cnt_i; 
wire read_i,send_i;

reg[1:0] cstate_i,nstate_i;
parameter SEND = 2'b00;
parameter READ =2'b01;
parameter WAIT = 2'b10;

assign arst_i = ~ARST_L;
assign TX = datasd_i[0];

always@(posedge CLK, posedge arst_i)
begin
    if(arst_i || !send_i)
        cnt_i <= 0;
    else 
        cnt_i <= cnt_i +1;     
end


always@(posedge CLK, posedge arst_i)
begin 
	if(arst_i)
	begin
		datasd_i <= 10'b1111111111;
	end
	else if(read_i)
	begin
		datasd_i <= DATASD;
	end
	else if(send_i)
	begin
		datasd_i <= {1'b1, datasd_i[9:1]};
	end	
	else
	   datasd_i <= 10'b1111111111;
end


always@(posedge CLK, negedge arst_i)
begin
    if(arst_i)
        cstate_i <= WAIT;
    else     
        cstate_i <= nstate_i;
end
always@(EN, cstate_i, cnt_i)
begin
    case(cstate_i)
        WAIT:
        begin
            if(EN)
                nstate_i <= READ;
            else
                nstate_i <= WAIT;    
        end
        READ:
        begin
            nstate_i <= SEND;
        end
        SEND:
        begin
            if(cnt_i >=10 && !EN)
                nstate_i <= WAIT;
            else
                nstate_i <= SEND;    
        end
        default:
        begin
            nstate_i <= WAIT;
        end
    endcase    
end
assign read_i = (cstate_i == READ)? 1'b1:1'b0;
assign send_i = (cstate_i == SEND)? 1'b1:1'b0;

endmodule
