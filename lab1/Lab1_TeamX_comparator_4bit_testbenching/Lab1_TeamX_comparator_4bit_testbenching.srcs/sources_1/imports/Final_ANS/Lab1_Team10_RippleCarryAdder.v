`timescale 1ns/1ps

module RippleCarryAdder (input [8-1:0] a, input [8-1:0]b,
 input cin, input cout, output [8-1:0] sum);
wire [7-1:0] c;

    FullAdder A0(a[0], b[0], cin, c[0], sum[0]);
    FullAdder A1(a[1], b[1], c[0], c[1], sum[1]);
    FullAdder A2(a[2], b[2], c[1], c[2], sum[2]);
    FullAdder A3(a[3], b[3], c[2], c[3], sum[3]);
    FullAdder A4(a[4], b[4], c[3], c[4], sum[4]);
    FullAdder A5(a[5], b[5], c[4], c[5], sum[5]);
    FullAdder A6(a[6], b[6], c[5], c[6], sum[6]);
    FullAdder A7(a[7], b[7], c[6], cout, sum[7]);

endmodule

module FullAdder (a, b, cin, cout, sum);
input a, b, cin;
output sum;
output cout;
wire a, b, cin;
wire sum, cout;
wire XNOR_a_b;
    XNOR xnor_a_b(a, b, XNOR_a_b);
    XNOR xnor_cin_xnorab(cin, XNOR_a_b, sum);
    Mux_1bit gecout(a, cin, XNOR_a_b, cout);
endmodule

module XNOR (a, b, Q);
    input a, b;
    output Q;
    wire a, b;
    wire Q;
    wire nor_a_b, and_a_b;
    nor NOR_(nor_a_b, a, b);
    and AND_(and_a_b, a, b);
    or OR_(Q, and_a_b, nor_a_b);
endmodule 

module Mux_1bit (a, b, sel, f);
input a, b;
input sel;
output f;

    wire a, b, sel;
    wire f;
    wire and_a_sel, and_b_sel;
    wire notsel;
    not NOT_1(notsel, sel);
    and AND_(and_a_sel, a, sel);
    and AND_2(and_b_sel, b, notsel);
    or OR_(f, and_a_sel, and_b_sel);
endmodule
