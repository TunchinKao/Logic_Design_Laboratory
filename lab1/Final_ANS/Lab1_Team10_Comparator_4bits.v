// done
`timescale 1ns/1ps

module Comparator_4bits (a, b, a_lt_b, a_gt_b, a_eq_b);
input [4-1:0] a, b;
output a_lt_b, a_gt_b, a_eq_b;
wire [3:0] x_res;

_xnor x1(a[0], b[0], x_res[0]);
_xnor x2(a[1], b[1], x_res[1]);
_xnor x3(a[2], b[2], x_res[2]);
_xnor x4(a[3], b[3], x_resa[3]);

and and1(a_eq_b, x_res[0], x_res[1], x_res[2], x_res[3]);

gt gt1(a, b, x_res, a_gt_b);

lt lt1(a, b, x_res, a_lt_b);



endmodule

module gt(a, b, x, o);
input [3:0] a, b, x;
output o;
wire a_0, a_1, a_2, a_3, b3_b, b2_b, b1_b, b0_b;
not n1(b3_b, b[3]);
not n2(b2_b, b[2]);
not n3(b1_b, b[1]);
not n4(b0_b, b[0]);

and a1(a_3, b3_b, a[3]);
and a2(a_2, b2_b, a[2], x[3]);
and a3(a_1, b1_b, a[1], x[3], x[2]);
and a4(a_0, b0_b, a[0], x[3], x[2], x[1]);

or o1(o, a_3, a_2, a_1, a_0);

endmodule

module lt(a, b, x, o);
input [3:0] a, b, x;
output o;
wire a_0, a_1, a_2, a_3, a0_b, a1_b, a2_b, a3_b;

not not1(a3_b, a[3]);
not not2(a2_b, a[2]);
not not3(a1_b, a[1]);
not not4(a0_b, a[0]);

and a1(a_3, a3_b, b[3]);
and a2(a_2, a2_b, b[2], x[3]);
and a3(a_1, a1_b, b[1], x[3], x[2]);
and a4(a_0, a0_b, b[0], x[3], x[2], x[1]);

or o1(o, a_0, a_1, a_2, a_3);

endmodule

module _xnor(a, b, c);
input a, b;
output c;
wire x1, x2, x3, c_b;
and a1(x1, a, b);
not n1(x2, x1);
or o1(x3, a, b);
and (c_b, x2, x3);
not (c, c_b);

endmodule