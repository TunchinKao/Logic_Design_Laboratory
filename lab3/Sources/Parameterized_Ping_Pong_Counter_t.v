`timescale 1ns/1ps

`define CYC 4

module Parameterized_Ping_Pong_Counter_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
reg enable = 1'b0;
reg flip = 1'b0;
reg [3:0] max = 4'b1111;
reg [3:0] min = 4'b0000;
wire direction;
wire [4-1:0] out;

Parameterized_Ping_Pong_Counter pppc (
    .clk(clk), 
    .rst_n(rst_n),
    .enable(enable), 
    .flip(flip), 
    .max(max), 
    .min(min), 
    .direction(direction), 
    .out(out)
);

always #(`CYC / 2) clk = ~clk;

initial begin
    @ (negedge clk)
    rst_n = 1'b0;
    @ (negedge clk)
    rst_n = 1'b1;
    enable = 1'b1;
    
    #(`CYC * 10)
    max = 4'd9;
    
    #(`CYC * 4)
    max = 4'd10;
    
    #(`CYC * 4)
    max = 4'd15;

    #(`CYC * 4)
    enable = 1'b0;

    #(`CYC * 5)
    enable = 1'b1;
    flip = 1'b1;
    
    #(`CYC * 1)
    flip = 1'b0;
    
    #(`CYC * 4)
    min = 4'd9;
    
    #(`CYC * 4)
    min = 4'd7;
    max = 4'd7;
    
    #(`CYC * 4)
    min = 4'd3;
    max = 4'd15;
    
    #(`CYC * 4)
    max = 4'd15;
    
    #(`CYC * 4)
    $finish;
end
endmodule
