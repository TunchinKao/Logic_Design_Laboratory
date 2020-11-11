`timescale 1ns/1ps

module Moore (clk, rst_n, in, out, state);
input clk, rst_n;
input in;
output reg [2-1:0] out;
output reg [3-1:0] state;
reg [3-1:0] next_state;

parameter S0 = 3'b000;
parameter S1 = 2'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;

endmodule
