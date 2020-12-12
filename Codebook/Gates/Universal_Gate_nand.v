`timescale 1ns/1ps

module NAND_Implement (a, b, sel, out);
input a, b;
input [3-1:0] sel;
output out;
wire [7:0] dataflow;

NOT_by_NAND gene_df_0 (dataflow[0], a);
NOR_by_NAND gene_df_1 (dataflow[1], a, b);
AND_by_NAND gene_df_2 (dataflow[2], a, b);
OR_by_NAND  gene_df_3 (dataflow[3], a, b);
XOR_by_NAND gene_df_4 (dataflow[4], a, b);
XNOR_by_NAND gene_df_5 (dataflow[5], a, b);
NAND_by_NAND gene_df_6 (dataflow[6], a, b);
NAND_by_NAND gene_df_7 (dataflow[7], a, b);
MUX_8_to_1_by_NAND gene_out(dataflow[7:0], sel[2:0], out);

endmodule

module MUX_8_to_1_by_NAND(in, sel, out);
input [7:0]in;
input [2:0] sel;
output out;

wire [3:0] layer1;
wire [1:0] layer2;

MUX_2_to_1_by_NAND MUX_1_0(in[1:0], sel[0], layer1[0]);
MUX_2_to_1_by_NAND MUX_3_2(in[3:2], sel[0], layer1[1]);
MUX_2_to_1_by_NAND MUX_5_4(in[5:4], sel[0], layer1[2]);
MUX_2_to_1_by_NAND MUX_7_6(in[7:6], sel[0], layer1[3]);

MUX_2_to_1_by_NAND MUX_layer2_0(layer1[1:0], sel[1], layer2[0]);
MUX_2_to_1_by_NAND MUX_layer2_1(layer1[3:2], sel[1], layer2[1]);

MUX_2_to_1_by_NAND gene_out(layer2[1:0], sel[2], out);


endmodule

module MUX_2_to_1_by_NAND (
    in, sel, out
);
input [1:0] in;
input sel;
output out;
wire n_sel;
wire in_0_and, in_1_and;

NOT_by_NAND gene_n_sel(n_sel, sel);
nand gene_in_0(in_0_and, in[0], n_sel);
nand gene_in_1(in_1_and, in[1], sel);
nand gene_out(out, in_0_and, in_1_and);

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