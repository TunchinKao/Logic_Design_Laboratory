`timescale 1ns/1ps

module Binary_to_Grey (din, dout);
input [4-1:0] din;
output [4-1:0] dout;
AND a1(dout[3], din[3], din[3]);
XOR x1(dout[2], din[3], din[2]);
XOR x2(dout[1], din[2], din[1]);
XOR x3(dout[0], din[1], din[0]);

endmodule

module XOR (out, in1, in2);
input in1, in2;
output out;
wire a_bar, b_bar, o_na1, o_na2, o_na3;
nand na_a(a_bar, in1, in1);
nand na_b(b_bar, in2, in2);
nand na1(o_na1, in1, in2);
nand na2(o_na2, a_bar, b_bar);
nand na3(o_na3, o_na2, o_na1);
nand na4(out, o_na3, o_na3);

endmodule

module AND (out, in1, in2);
input in1, in2;
output out;
wire o_na1;
nand na1(o_na1, in1, in2);
nand na2(out, o_na1, o_na1);

endmodule