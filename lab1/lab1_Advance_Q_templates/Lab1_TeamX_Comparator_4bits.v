`timescale 1ns/1ps

module Comparator_4bits (a, b, a_lt_b, a_gt_b, a_eq_b);
input [4-1:0] a, b;
output a_lt_b, a_gt_b, a_eq_b;
wire x_res1, x_res2, x_res3, x_res4, a_a1, a_a2, a_a3, a_a4,  b_a1, b_a2, b_a3, b_a4, a3_b, a2_b, a1_b, a0_b, b3_b, b2_b, b1_b, b0_b;
_xnor x1(a[0], b[0], x_res1);
_xnor x2(a[1], b[1], x_res2);
_xnor x3(a[2], b[2], x_res3);
_xnor x4(a[3], b[3], x_res4);

and (a_eq_b, x_res1, x_res2, x_res3, x_res4);

not (a3_b, a[3]);
not (a2_b, a[2]);
not (a1_b, a[1]);
not (a0_b, a[0]);
not (b3_b, b[3]);
not (b2_b, b[2]);
not (b1_b, b[1]);
not (b0_b, b[0]);

and (a_a1, a3_b, b[3]);
and (a_a2, a2_b, b[2], x_res4);
and (a_a3, a1_b, b[1], x_res4, x_res3);
and (a_a4, a0_b, b[0], x_res4, x_res3, x_res2);

or (a_lt_b, a_a1, a_a2, a_a3, a_a4);

and (b_a1, b3_b, a[3]);
and (b_a2, b2_b, a[2], x_res4);
and (b_a3, b1_b, a[1], x_res4, x_res3);
and (b_a4, b0_b, a[0], x_res4, x_res3, x_res2);

or (a_gt_b, b_a1, b_a2, b_a3, b_a4);



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