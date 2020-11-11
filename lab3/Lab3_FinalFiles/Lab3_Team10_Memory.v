`timescale 1ns/1ps

module Memory (clk, ren, wen, addr, din, dout);
input clk;
input ren, wen;
input [7-1:0] addr;
input [8-1:0] din;
output [8-1:0] dout;

reg [7:0]Memory_array[128-1:0];
reg [7:0] data;
// read
always @(posedge clk)begin
    case({ren, wen})
    2'b00:
    begin
        data <= 8'b00000000;
        Memory_array[addr[6:0]] <= Memory_array[addr[6:0]];
    end
    2'b01:
    begin
        data <= 8'b00000000;
        Memory_array[addr[6:0]] <= din;
    end
    2'b10:
    begin
        data <= Memory_array[addr[6:0]]; 
        Memory_array[addr[6:0]] <= Memory_array[addr[6:0]];
    end
    2'b11:
    begin
        data <= Memory_array[addr[6:0]]; 
        Memory_array[addr[6:0]] <= Memory_array[addr[6:0]];
    end
    endcase
end

assign dout = data;
endmodule
