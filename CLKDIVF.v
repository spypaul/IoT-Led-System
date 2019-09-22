`timescale 1ns / 1ps



module CLKDIVF(CLKIN, ACLR_L, CLKOUT);
input CLKIN, ACLR_L;
output reg CLKOUT;
reg[6:0] cnt; 
wire aclr_i;
assign aclr_i = ~ACLR_L;


always @ (posedge CLKIN, posedge aclr_i)
begin
    if (aclr_i == 1'b1)
        cnt <= 0;
    else if (cnt == 81)
        cnt <= 0;
    else
        cnt <= cnt+1;     
end

always @ (posedge CLKIN, posedge aclr_i)
begin 
    if (aclr_i == 1'b1)
       CLKOUT <= 1'b0;
    else if (cnt == 81)
       CLKOUT <= ~CLKOUT;
    else 
        CLKOUT <= CLKOUT;   
end

endmodule
