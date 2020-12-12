`timescale 1ns/1ps
module Mux_8bits (input [8-1:0]a, input [8-1:0]b, input [8-1:0]c, input [8-1:0]d, input sel1,input sel2,input sel3, output [8-1:0]f);

wire n_sel1, n_sel2, n_sel3;
wire [8-1:0] a_and_sel, b_and_n_sel, c_and_sel, d_and_n_sel;
wire [8-1:0] a_second, b_second;
wire [8-1:0] a_second_and_n_sel, b_second_and_n_sel;

not (n_sel1, sel1);
not (n_sel2, sel2);
not (n_sel3, sel3);

and ( a_and_sel[0], a[0], sel1); 
and ( a_and_sel[1], a[1], sel1); 
and ( a_and_sel[2], a[2], sel1);
and ( a_and_sel[3], a[3], sel1); 
and ( a_and_sel[4], a[4], sel1); 
and ( a_and_sel[5], a[5], sel1); 
and ( a_and_sel[6], a[6], sel1); 
and ( a_and_sel[7], a[7], sel1);  

and( b_and_n_sel[0], b[0], n_sel1); 
and( b_and_n_sel[1], b[1], n_sel1); 
and( b_and_n_sel[2], b[2], n_sel1);
and( b_and_n_sel[3], b[3], n_sel1); 
and( b_and_n_sel[4], b[4], n_sel1); 
and( b_and_n_sel[5], b[5], n_sel1); 
and( b_and_n_sel[6], b[6], n_sel1); 
and( b_and_n_sel[7], b[7], n_sel1);  

and( c_and_sel[0], c[0], sel2); 
and( c_and_sel[1], c[1], sel2); 
and( c_and_sel[2], c[2], sel2);
and( c_and_sel[3], c[3], sel2); 
and( c_and_sel[4], c[4], sel2); 
and( c_and_sel[5], c[5], sel2); 
and( c_and_sel[6], c[6], sel2); 
and( c_and_sel[7], c[7], sel2);  

and( d_and_n_sel[0], d[0], n_sel2); 
and( d_and_n_sel[1], d[1], n_sel2); 
and( d_and_n_sel[2], d[2], n_sel2);
and( d_and_n_sel[3], d[3], n_sel2); 
and( d_and_n_sel[4], d[4], n_sel2); 
and( d_and_n_sel[5], d[5], n_sel2); 
and( d_and_n_sel[6], d[6], n_sel2); 
and( d_and_n_sel[7], d[7], n_sel2);  

or Or_Array_a_b_n[7:0] (a_second, a_and_sel, b_and_n_sel);

or Or_Array_c_d [7:0] (b_second, c_and_sel, d_and_n_sel);

and(a_second_and_n_sel[0], a_second[0], sel3);
and(a_second_and_n_sel[1], a_second[1], sel3);
and(a_second_and_n_sel[2], a_second[2], sel3);
and(a_second_and_n_sel[3], a_second[3], sel3);
and(a_second_and_n_sel[4], a_second[4], sel3);
and(a_second_and_n_sel[5], a_second[5], sel3);
and(a_second_and_n_sel[6], a_second[6], sel3);
and(a_second_and_n_sel[7], a_second[7], sel3);

and(b_second_and_n_sel[0], b_second[0], n_sel3);
and(b_second_and_n_sel[1], b_second[1], n_sel3);
and(b_second_and_n_sel[2], b_second[2], n_sel3);
and(b_second_and_n_sel[3], b_second[3], n_sel3);
and(b_second_and_n_sel[4], b_second[4], n_sel3);
and(b_second_and_n_sel[5], b_second[5], n_sel3);
and(b_second_and_n_sel[6], b_second[6], n_sel3);
and(b_second_and_n_sel[7], b_second[7], n_sel3);

or OR_ARR[7:0] (f, a_second_and_n_sel, b_second_and_n_sel);

endmodule
