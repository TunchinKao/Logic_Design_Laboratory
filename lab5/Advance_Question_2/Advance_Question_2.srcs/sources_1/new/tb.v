`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/22 16:50:34
// Design Name: 
// Module Name: tb
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


module tb();

parameter HW_go = 3'b000;
parameter HW_wait = 3'b001;
parameter Going_toLR = 3'b010;
parameter LR_go = 3'b011;
parameter LR_wait = 3'b100;
parameter Going_toHW = 3'b101;

reg clk = 1'b0, rst_n, lr_has_car;
reg [4-1:0] cnt;
wire[3-1:0] hw_light, lr_light, isashimaState;
wire [64-1:0] cnts;
Traffic_Light_Controller testing(
    .clk(clk), .rst_n(rst_n), .lr_has_car(lr_has_car),
     .hw_light(hw_light), .lr_light(lr_light), .state(isashimaState),
    .cnt(cnts)
);

always begin
  #2 clk = ~clk;
end

initial begin
    rst_n = 1'b0;
    lr_has_car = 1'b0;
    cnt = 4'd0;
    #5
    rst_n = 1'b1;
    repeat(2**9)begin
        @(negedge clk)begin
            if(cnt >= 4'd10)begin 
                lr_has_car = 1'b1;
                // cnt = 4'd0;
            end
            else begin
                lr_has_car = 1'b0;

            end
            if(cnt >= 4'd14)
                cnt = 4'd0;
            else cnt = cnt + 1'd1;
        end
    end
end


endmodule
