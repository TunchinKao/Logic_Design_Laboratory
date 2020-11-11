`timescale 1ns/1ps

module Decoder (din, dout);
input [4-1:0] din;
output [16-1:0] dout;
wire [2:0] din_n;
_xor x1(din[0], din[3], din_n[0]);
_xor x2(din[1], din[3], din_n[1]);
_xor x3(din[2], din[3], din_n[2]);
dec_3to8 d1(din_n, dout[15:8]);
dec_3to8 d2(din_n, dout[7:0]);


endmodule

module dec_3to8 (din, dout);
input [2:0] din;
output [7:0] dout;

wire [2:0] din_b;

not n1(din_b[0], din[0]);
not n2(din_b[1], din[1]);
not n3(din_b[2], din[2]);
and a1(dout[0], din_b[2], din_b[1], din_b[0]);
and a2(dout[1], din_b[2], din_b[1], din[0]);
and a3(dout[2], din_b[2], din[1], din_b[0]);
and a4(dout[3], din_b[2], din[1], din[0]);
and a5(dout[4], din[2], din_b[1], din_b[0]);
and a6(dout[5], din[2], din_b[1], din[0]);
and a7(dout[6], din[2], din[1], din_b[0]);
and a8(dout[7], din[2], din[1], din[0]);

endmodule 

module _xor(a, b, c);
input a, b;
output c;
wire x1, x2, x3;
and a1(x1, a, b);
not n1(x2, x1);
or o1(x3, a, b);
and (c, x2, x3);

endmodule