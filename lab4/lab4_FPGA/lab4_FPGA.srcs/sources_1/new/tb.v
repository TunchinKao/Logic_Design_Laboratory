`timescale 1ns / 1ps

module tb;


reg clk, push_bottom, reset_bottom;

wire [3:0] min, sec1, sec2, secdiv10;
wire [7:0]out;
wire [3:0]an;
wire [1:0] state;
// Stopwatch ohReally(.clk(clk), .push_bottom(push_bottom), .reset_bottom(reset_bottom), .out(out), .an(an),
//                 .min(min), .sec1(sec1), .sec2(sec2), .secdiv10(secdiv10));
wire clk_10;
// clksecdiv_10 testdiv_10(.clk(clk), .clk_10(clk_10));
wire clk_23;
// Clock_Divider_216 noname(.clk(clk), .clk1_2_16(clk_10));
 Clock_Divider_23 geneclkdiv(.clk(clk), .clk1_2_16(clk_23));

counterup testcounter(  .clk(clk), .r_signal(!reset_bottom), .sp_signal(push_bottom)
                    ,   .min(min), .sec1(sec1), .sec2(sec2), .secdiv10(secdiv10)
                    ,   .state(state));

initial begin
    clk = 1'b0;
    push_bottom = 1'b0;
    reset_bottom = 1'b1;
    #40
    push_bottom = 1'b1;
    reset_bottom = 1'b0;
    #40
    push_bottom = 1'b0;
end

always  begin
    #2 clk = !clk;
end




endmodule

