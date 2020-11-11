`timescale 1ns/1ps

module Ping_Pong_Counter (clk, rst_n, enable, direction, out);
input clk, rst_n;
input enable;
output direction;
output [4-1:0] out;

reg [4-1:0] counter = 4'b0000;
reg direc = 1'b1;
always @(posedge clk)
begin
    if(!rst_n)
        counter <= 4'b0001;
    if(enable == 1'b1)begin
        if(counter == 4'b1111 && direc == 1'b1)
        begin
            direc <= !direc;
            counter <= counter - 1'b1;
        end
        else if(counter == 4'b0000 && direc == 1'b0)
        begin
            direc <= !direc;        
            counter <= counter + 1'b1;
        end
        
        if(direc == 1'b1 && counter !== 4'b1111)
            counter <= counter + 1'b1;
        if(direc == 1'b0 && counter !== 4'b0000)
            counter <= counter - 1'b1;
    end
end 

assign out[3:0] = counter[3:0];
assign direction = direc;

endmodule
