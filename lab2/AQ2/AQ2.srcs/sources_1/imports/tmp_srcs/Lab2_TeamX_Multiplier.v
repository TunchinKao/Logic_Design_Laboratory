`timescale 1ns/1ps

module Multiplier (a, b, p);
input [4-1:0] a, b;
output [8-1:0] p;
wire [4-1:0] n_a, n_b;
wire [4-1:0] ab [4-1:0];
nor gene_n_a [4-1:0] (n_a, a, a);
nor gene_n_b [4-1:0] (n_b, b, b);
wire [4-1:0] layer[1:0];
wire alwaysZero;

nor gene_Zero(alwaysZero, n_a[0], a[0]);

nor gene_0_0(p[0], n_a[0], n_b[0]);
nor gene_0_1(ab[0][1], n_a[0], n_b[1]);
nor gene_0_2(ab[0][2], n_a[0], n_b[2]);
nor gene_0_3(ab[0][3], n_a[0], n_b[3]);

nor gene_1_0(ab[1][0], n_a[1], n_b[0]);
nor gene_1_1(ab[1][1], n_a[1], n_b[1]);
nor gene_1_2(ab[1][2], n_a[1], n_b[2]);
nor gene_1_3(ab[1][3], n_a[1], n_b[3]);

nor gene_2_0(ab[2][0], n_a[2], n_b[0]);
nor gene_2_1(ab[2][1], n_a[2], n_b[1]);
nor gene_2_2(ab[2][2], n_a[2], n_b[2]);
nor gene_2_3(ab[2][3], n_a[2], n_b[3]);

nor gene_3_0(ab[3][0], n_a[3], n_b[0]);
nor gene_3_1(ab[3][1], n_a[3], n_b[1]);
nor gene_3_2(ab[3][2], n_a[3], n_b[2]);
nor gene_3_3(ab[3][3], n_a[3], n_b[3]);

RCA_4bit RCA_1({alwaysZero, ab[0][3:1]}, ab[1], {layer[0][2:0], p[1]}, layer[0][3]);
RCA_4bit RCA_2(layer[0], ab[2], {layer[1][2:0], p[2]}, layer[1][3]);
RCA_4bit RCA_3(layer[1], ab[3], p[6:3], p[7]);

endmodule

module RCA_4bit(a, b, sum, cout);
input [3:0] a, b;
output [3:0] sum;
output cout;
wire [2:0] carry;
wire alwaysZero,  n_a_0;

nor gene_n_a_0(n_a_0, a[0], a[0]);
nor gene_Zero(alwaysZero, a[0], n_a_0);

FullAdder_1bit FA_1(a[0], b[0], alwaysZero, sum[0], carry[0]);
FullAdder_1bit FA_2(a[1], b[1], carry[0], sum[1], carry[1]);
FullAdder_1bit FA_3(a[2], b[2], carry[1], sum[2], carry[2]);
FullAdder_1bit FA_4(a[3], b[3], carry[2], sum[3], cout);

endmodule


module FullAdder_1bit(a, b, cin, sum, cout);
input a, b, cin;
output sum, cout;
wire a_nor_b;
wire a_nor_a_nor_b, a_nor_b_nor_b;
wire layer1;
wire layer1_nor_cin, layer1_nor_layer1_nor_cin, layer1_nor_cin_nor_cin;

nor gene_a_nor_b(a_nor_b, a, b);
nor gene_ananb(a_nor_a_nor_b, a, a_nor_b);
nor gene_anbnb(a_nor_b_nor_b, b, a_nor_b);
nor gene_layer1(layer1, a_nor_a_nor_b, a_nor_b_nor_b);

nor gene_lnc(layer1_nor_cin, layer1, cin);
nor gene_lnlnc(layer1_nor_layer1_nor_cin, layer1, layer1_nor_cin);
nor gene_lncnc(layer1_nor_cin_nor_cin, cin, layer1_nor_cin);

nor gene_sum(sum, layer1_nor_cin_nor_cin, layer1_nor_layer1_nor_cin);
nor gene_cout(cout, layer1_nor_cin, a_nor_b);

endmodule