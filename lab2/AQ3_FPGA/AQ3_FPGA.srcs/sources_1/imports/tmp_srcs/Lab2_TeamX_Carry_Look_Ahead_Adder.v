`timescale 1ns/1ps

module Set_signal(a, b, cin, cout, signal, AN);
input [4-1:0]a, b;
input cin;
output cout;
output [7-1:0] signal;
output [3:0] AN;
wire [3:0] sum;
wire [7-1:0] n_signal;
wire n_cout;
// solving AN problem
wire n_1;
nand gene_one(n_1, a[0], a[0]);
nand geone_one_for_all(AN[0], n_1, a[0]);
nand geone_one_for_all_2(AN[1], n_1, a[0]);
nand geone_one_for_all_3(AN[2], n_1, a[0]);
nand geen_zero_for_all(AN[3], AN[0], AN[0]);
// --------------------------------
Carry_Look_Ahead_Adder CLAA(a, b, cin, n_cout, sum);
// do 7 times K-map can solve it
wire [15:0] decodewire;
decoder_4to16 gene_decode(sum, decodewire);
nand gene_signal_0(n_signal[0], decodewire[0] 
                , decodewire[2], decodewire[3]
                , decodewire[5], decodewire[6]
                , decodewire[7], decodewire[8]
                , decodewire[9], decodewire[10]
                , decodewire[12], decodewire[14]
                , decodewire[15]);
nand gene_signal_1(n_signal[1], decodewire[0] 
                , decodewire[1], decodewire[2]
                , decodewire[3], decodewire[4]
                , decodewire[7], decodewire[8]
                , decodewire[9], decodewire[10]
                , decodewire[13]);
nand gene_signal_2(n_signal[2], decodewire[0]
                , decodewire[1], decodewire[3], decodewire[4]
                , decodewire[5], decodewire[6]
                , decodewire[7], decodewire[8]
                , decodewire[9], decodewire[10]
                , decodewire[11], decodewire[13]);
nand gene_signal_3(n_signal[3], decodewire[0] 
                , decodewire[2], decodewire[3]
                , decodewire[5], decodewire[6]
                , decodewire[8]
                , decodewire[9], decodewire[11]
                , decodewire[12], decodewire[13]
                , decodewire[14]);
nand gene_signal_4(n_signal[4], decodewire[0] 
                , decodewire[2], decodewire[6]
                , decodewire[13], decodewire[8]
                , decodewire[11], decodewire[10]
                , decodewire[12], decodewire[14]
                , decodewire[15]);
nand gene_signal_5(n_signal[5], decodewire[0] 
                , decodewire[4]
                , decodewire[5], decodewire[6]
                , decodewire[11], decodewire[8]
                , decodewire[9], decodewire[10]
                , decodewire[12], decodewire[14]
                , decodewire[15]);
nand gene_signal_6(n_signal[6], decodewire[4] 
                , decodewire[2], decodewire[3]
                , decodewire[5], decodewire[6]
                , decodewire[13], decodewire[8]
                , decodewire[9], decodewire[10]
                , decodewire[11], decodewire[14]
                , decodewire[15]);
NOT_by_NAND gene_signals [6:0](signal, n_signal);
NOT_by_NAND gene_cout (cout, n_cout);
endmodule
module decoder_4to16(in, out);
input [3:0] in;
output [15:0] out;
wire [3:0] n_Enable;
wire [3:0] Enable;
decoder_2to4 gene_n_Enable(in[3:2], 1, n_Enable);
NOT_by_NAND gene_Enable [3:0] (Enable, n_Enable);
// layer 2
decoder_2to4 gene_out_3to0(in[1:0], Enable[0], out[3:0]);
decoder_2to4 gene_out_7to4(in[1:0], Enable[1], out[7:4]);
decoder_2to4 gene_out_11to8(in[1:0], Enable[2], out[11:8]);
decoder_2to4 gene_out_15to12(in[1:0], Enable[3], out[15:12]);

endmodule

module decoder_2to4(in, Enable, out);
input [1:0] in;
input Enable;
output [3:0] out;

wire [1:0] n_in;
NOT_by_NAND gene_n_in [1:0] (n_in, in);
nand gene_out0(out[0], n_in[0], n_in[1], Enable);
nand gene_out1(out[1], in[0], n_in[1], Enable);
nand gene_out2(out[2], n_in[0], in[1], Enable);
nand gene_out3(out[3], in[0], in[1], Enable);

endmodule

module Carry_Look_Ahead_Adder (a, b, cin, cout, sum);
input [4-1:0] a, b;
input cin;
output cout;
output [4-1:0] sum;
wire [2:0] CarryOut;
wire [3:0] G, P;

AND_by_NAND gene_G[3:0](G, a, b);
XOR_by_NAND gene_P[3:0](P, a, b);

Look_4bit_Ahead L4A(cin, G, P, {cout, CarryOut[2:0]});
FullAdder gene_sum0(a[0], b[0], cin, sum[0]);
FullAdder gene_sum1(a[1], b[1], CarryOut[0], sum[1]);
FullAdder gene_sum2(a[2], b[2], CarryOut[1], sum[2]);
FullAdder gene_sum3(a[3], b[3], CarryOut[2], sum[3]);

endmodule

module FullAdder (a, b, cin, sum);
input a, b, cin;
output sum;

wire XNOR_a_b;
XNOR_by_NAND gene_XNOR_a_b(XNOR_a_b, a, b);
XNOR_by_NAND gene_out(sum, XNOR_a_b, cin);

endmodule

module Look_4bit_Ahead(cin, G, P, Cout);
input cin;
input [3:0] G, P;
output [3:0] Cout;
wire [3:0] n_G;
wire layer1;
wire [1:0] layer2;
wire [2:0] layer3;
wire [3:0] layer4;
// init n_G
NOT_by_NAND gene_n_G [3:0](n_G, G); 
// layer1
nand gene_layer1(layer1, P[0], cin);
// layer2
nand gene_layer2_0(layer2[0], P[1], G[0]);
nand gene_layer2_1(layer2[1], P[1], P[0], cin);
// layer3
nand gene_layer3_0(layer3[0], P[2], G[1]);
nand gene_layer3_1(layer3[1], P[2], P[1], G[0]);
nand gene_layer3_2(layer3[2], P[2], P[1], P[0], cin);
// layer4
nand gene_layer4_0(layer4[0], P[3], G[2]);
nand gene_layer4_1(layer4[1], P[3], P[2], G[1]);
nand gene_layer4_2(layer4[2], P[3], P[2], P[1], G[0]);
nand gene_layer4_3(layer4[3], P[3], P[2], P[1], P[0], cin);
// output
nand gene_cout_0(Cout[0], n_G[0], layer1);
nand gene_cout_1(Cout[1], n_G[1], layer2[0], layer2[1]);
nand gene_cout_2(Cout[2], n_G[2], layer3[0], layer3[1], layer3[2]);
nand gene_cout_3(Cout[3], n_G[3], layer4[0], layer4[1], layer4[2], layer4[3]);

endmodule



module NOT_by_NAND(out, a);
input a;
output out;

nand nand_a_a(out, a, a);

endmodule

module AND_by_NAND(out, a, b);
input a, b;
output out;
wire w_nand_a_b;

nand nand_a_b(w_nand_a_b, a, b);
nand nand_to_output(out, w_nand_a_b, w_nand_a_b);

endmodule 

module OR_by_NAND(out, a, b);
input a, b;
output out;
wire nand_a, nand_b;

nand a_itself(nand_a, a, a);
nand b_itself(nand_b, b, b);
nand gene_output(out, nand_a, nand_b);

endmodule

module NOR_by_NAND(out, a, b);
input a, b;
output out;
wire or_a_b;

OR_by_NAND gene_OR(or_a_b, a, b);
NOT_by_NAND gene_out(out, or_a_b);

endmodule

module NAND_by_NAND(out, a, b);
input a, b;
output out;

nand simple(out, a, b);

endmodule

module XOR_by_NAND(out, a, b);
input a, b;
output out;
wire a_NAND_b, a_nn, b_nn;

nand gene_a_NAND_b(a_NAND_b, a, b);
nand gene_a_nn(a_nn, a, a_NAND_b);
nand gene_b_nn(b_nn, b, a_NAND_b);
nand gene_out(out, a_nn, b_nn);

endmodule

module XNOR_by_NAND(out, a, b);
input a, b;
output out;
wire not_a, not_b;
wire not_a_NAND_not_b, a_NAND_b;

NOT_by_NAND gene_not_a(not_a, a);
NOT_by_NAND gene_not_b(not_b, b);
nand gene_nand1(not_a_NAND_not_b, not_a, not_b);
nand gene_nand2(a_NAND_b, a, b);
nand gene_out(out, not_a_NAND_not_b, a_NAND_b);

endmodule