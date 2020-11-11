`timescale 1ns/1ps

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