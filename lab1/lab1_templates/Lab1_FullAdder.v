//done

`timescale 1ns/1ps

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





