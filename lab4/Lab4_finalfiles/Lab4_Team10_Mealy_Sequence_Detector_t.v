`timescale 1ns / 1ps

`define CYC 4

module Mealy_Sequence_Detector_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
reg in = 1'b0;
wire dec;
integer i;
reg [0:3] cnt = 4'b0001;

Mealy_Sequence_Detector msd(clk, rst_n, in, dec);

always #(`CYC/2) clk = ~clk;

initial begin
    @ (negedge clk) rst_n = 1'b0;
    @ (posedge clk) 
    @ (negedge clk) rst_n = 1'b1;
    #(`CYC * 3);
    repeat(2**4 - 1) begin
        for(i = 0; i < 4; i = i + 1) begin
            #(`CYC) in = cnt[i];
        end
        cnt = cnt + 1'b1;
    end
    #(`CYC) $finish;
end


endmodule
