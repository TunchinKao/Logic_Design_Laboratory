`timescale 1ns/1ps

module Decode_and_Execute (op_code, rs, rt, rd);
input [3-1:0] op_code;
input [4-1:0] rs, rt;
output [4-1:0] rd;
wire c_0, c_1, c_2, c_3, num_1;
wire [3:0] in [7:0];
wire [3:0] rt_bar, rt_cpm, num_1_arr;

XNOR xn_1(num_1, op_code[0], op_code[0]);

AND a1_0(num_1_arr[0], num_1, num_1);
nor no1_1(num_1_arr[1], num_1, num_1);
nor no1_2(num_1_arr[2], num_1, num_1);
nor no1_3(num_1_arr[3], num_1, num_1);

nor no_rt_bar[3:0](rt_bar, rt, rt);

RCA4 cpm_2(rt_bar, num_1_arr, rt_cpm, c_3);

RCA4 add(rs, rt, in[0], c_0);

RCA4 sub(rs, rt_cpm, in[1], c_1);

RCA4 inc(rs, num_1_arr, in[2], c_2);

nor no_out_3[3:0](in[3], rs, rt);

NAND na1(in[4][0], rs[0], rt[0]);
NAND na2(in[4][1], rs[1], rt[1]);
NAND na3(in[4][2], rs[2], rt[2]);
NAND na4(in[4][3], rs[3], rt[3]);

nor n_out5_3(in[5][3], num_1, num_1);
nor n_out5_2(in[5][2], num_1, num_1);
AND a1(in[5][1], num_1, rs[3]);
AND a2(in[5][0], num_1, rs[2]);

AND a3(in[6][3], num_1, rs[2]);
AND a4(in[6][2], num_1, rs[1]);
AND a5(in[6][1], num_1, rs[0]);
nor n_5(in[6][0], num_1, num_1);

Multiplier m(rs, rt, in[7]);

mux_3to8 mux_0(in[0][0], in[1][0], in[2][0], in[3][0], in[4][0], in[5][0], in[6][0], in[7][0], op_code, rd[0]);
mux_3to8 mux_1(in[0][1], in[1][1], in[2][1], in[3][1], in[4][1], in[5][1], in[6][1], in[7][1], op_code, rd[1]);
mux_3to8 mux_2(in[0][2], in[1][2], in[2][2], in[3][2], in[4][2], in[5][2], in[6][2], in[7][2], op_code, rd[2]);
mux_3to8 mux_3(in[0][3], in[1][3], in[2][3], in[3][3], in[4][3], in[5][3], in[6][3], in[7][3], op_code, rd[3]);

endmodule

module mux_3to8 (in0, in1, in2, in3, in4, in5, in6, in7, sel, out);
input in0, in1, in2, in3, in4, in5, in6, in7;
input [2:0] sel;
output out;
wire s0_b, s1_b, s2_b, out0, out1, out2, out3, out4, out5, out6, out7;
NOT n0(s0_b, sel[0]);
NOT n1(s1_b, sel[1]);
NOT n2(s2_b, sel[2]);
AND4 a0(out0, in0, s0_b, s1_b, s2_b);
AND4 a1(out1, in1, sel[0], s1_b, s2_b);
AND4 a2(out2, in2, s0_b, sel[1], s2_b);
AND4 a3(out3, in3, sel[0], sel[1], s2_b);
AND4 a4(out4, in4, s0_b, s1_b, sel[2]);
AND4 a5(out5, in5, sel[0], s1_b, sel[2]);
AND4 a6(out6, in6, s0_b, sel[1], sel[2]);
AND4 a7(out7, in7, sel[0], sel[1], sel[2]);
OR8 o1(out, out0, out1, out2, out3, out4, out5, out6, out7);

endmodule

module NOT (out, in);
input in;
output out;
nor no1(out, in, in);

endmodule

module OR (out, in1, in2);
input in1, in2;
output out;
wire o_no1;
nor no1(o_no1, in1, in2);
nor no2(out, o_no1, o_no1);

endmodule

module OR8 (out, in1, in2, in3, in4, in5, in6, in7, in8);
input in1, in2, in3, in4, in5, in6, in7, in8;
output out;
wire o_no1;
nor no1(o_no1, in1, in2, in3, in4, in5, in6, in7, in8);
nor no2(out, o_no1, o_no1);

endmodule

module AND (out, in1, in2);
input in1, in2;
output out;
wire o_no1, o_no2;
nor no1(o_no1, in1, in1);
nor no2(o_no2, in2, in2);
nor no3(out, o_no1, o_no2);

endmodule

module AND4 (out, in1, in2, in3, in4);
input in1, in2, in3, in4;
output out;
wire o_no1, o_no2, o_no3, o_no4;
nor no1(o_no1, in1, in1);
nor no2(o_no2, in2, in2);
nor no3(o_no3, in3, in3);
nor no4(o_no4, in4, in4);
nor noo(out, o_no1, o_no2, o_no3, o_no4);

endmodule

module NAND (out, in1, in2);
input in1, in2;
output out;
wire o_no1, o_no2, o_no3;
nor no1(o_no1, in1, in1);
nor no2(o_no2, in2, in2);
nor no3(o_no3, o_no1, o_no2);
nor no4(out, o_no3, o_no3);

endmodule

module XOR (out, in1, in2);
input in1, in2;
output out;
wire a_bar, b_bar, o_no1, o_no2;
nor no_a(a_bar, in1, in1);
nor no_b(b_bar, in2, in2);
nor no1(o_no1, in1, in2);
nor no2(o_no2, a_bar, b_bar);
nor no3(out, o_no2, o_no1);

endmodule

module XNOR (out, in1, in2);
input in1, in2;
output out;
wire a_bar, b_bar, o_no1, o_no2, o_no3;
nor no_a(a_bar, in1, in1);
nor no_b(b_bar, in2, in2);
nor no1(o_no1, in1, in2);
nor no2(o_no2, a_bar, b_bar);
nor no3(o_no3, o_no2, o_no1);
nor no4(out, o_no3, o_no3);

endmodule



module Multiplier (a, b, p);
input [3:0] a, b;
output [3:0] p;
wire [3:0] ab_0, ab_1, ab_2, ab_3, sum_0, sum_1;
wire num_1, co_0, co_1, co_2;

XNOR xn1(num_1, a[0], a[0]);

AND a_00(ab_0[0], a[0], b[0]);
AND a_01(ab_0[1], a[1], b[0]);
AND a_02(ab_0[2], a[2], b[0]);
AND a_03(ab_0[3], a[3], b[0]);

nor n_10(ab_1[0], num_1, num_1);
AND a_10(ab_1[1], a[0], b[1]);
AND a_11(ab_1[2], a[1], b[1]);
AND a_12(ab_1[3], a[2], b[1]);

nor n_20(ab_2[0], num_1, num_1);
nor n_21(ab_2[1], num_1, num_1);
AND a_20(ab_2[2], a[0], b[2]);
AND a_21(ab_2[3], a[1], b[2]);

nor n_30(ab_3[0], num_1, num_1);
nor n_31(ab_3[1], num_1, num_1);
nor n_32(ab_3[2], num_1, num_1);
AND a_30(ab_3[3], a[0], b[3]);

RCA4 RCA_1(ab_0, ab_1, sum_0, co_0);

RCA4 RCA_2(sum_0, ab_2, sum_1, co_1);

RCA4 RCA_3(sum_1, ab_3, p, co_2);

endmodule

module RCA4(a, b, sum, cout);
input [3:0] a, b;
output [3:0] sum;
output cout;
wire [2:0] carry;
wire num_0;
XOR x1(num_0, a[0], a[0]);
FA FA_1(a[0], b[0], num_0, sum[0], carry[0]);
FA FA_2(a[1], b[1], carry[0], sum[1], carry[1]);
FA FA_3(a[2], b[2], carry[1], sum[2], carry[2]);
FA FA_4(a[3], b[3], carry[2], sum[3], cout);

endmodule

module FA(a, b, cin, sum, cout);
input a, b, cin;
output sum, cout;
wire x_tmp, o_a1, o_a2, o_a3, o_tmp;
XOR x1(x_tmp, a, b);
XOR x2(sum, x_tmp, cin);
AND a1(o_a1, a, b);
AND a2(o_a2, a, cin);
AND a3(o_a3, cin, b);
OR o1(o_tmp, o_a1, o_a2);
OR o2(cout, o_tmp, o_a3);

endmodule