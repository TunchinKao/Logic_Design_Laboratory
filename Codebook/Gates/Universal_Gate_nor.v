`timescale 1ns/1ps

module NOR_Implement (a, b, sel, out);
input a, b;
input [3-1:0] sel;
output out;
wire [7:0] dataflow;

NOT_by_NOR gene_df_0 (dataflow[0], a);
NOR_by_NOR gene_df_1 (dataflow[1], a, b);
AND_by_NOR gene_df_2 (dataflow[2], a, b);
OR_by_NOR  gene_df_3 (dataflow[3], a, b);
XOR_by_NOR gene_df_4 (dataflow[4], a, b);
XNOR_by_NOR gene_df_5 (dataflow[5], a, b);
NAND_by_NOR gene_df_6 (dataflow[6], a, b);
NAND_by_NOR gene_df_7 (dataflow[7], a, b);
MUX_8_to_1_by_NOR gene_out(dataflow[7:0], sel[2:0], out);


endmodule

module MUX_8_to_1_by_NOR(in, sel, out);
input [7:0]in;
input [2:0] sel;
output out;

wire [3:0] layer1;
wire [1:0] layer2;

MUX_2_to_1_by_NOR MUX_1_0(in[1:0], sel[0], layer1[0]);
MUX_2_to_1_by_NOR MUX_3_2(in[3:2], sel[0], layer1[1]);
MUX_2_to_1_by_NOR MUX_5_4(in[5:4], sel[0], layer1[2]);
MUX_2_to_1_by_NOR MUX_7_6(in[7:6], sel[0], layer1[3]);

MUX_2_to_1_by_NOR MUX_layer2_0(layer1[1:0], sel[1], layer2[0]);
MUX_2_to_1_by_NOR MUX_layer2_1(layer1[3:2], sel[1], layer2[1]);

MUX_2_to_1_by_NOR gene_out(layer2[1:0], sel[2], out);


endmodule

module MUX_2_to_1_by_NOR (
    in, sel, out
);
input [1:0] in;
input sel;
output out;
wire n_sel;
wire in_0_and, in_1_and;

NOT_by_NOR gene_n_sel(n_sel, sel);
AND_by_NOR gene_in_0(in_0_and, in[0], n_sel);
AND_by_NOR gene_in_1(in_1_and, in[1], sel);
OR_by_NOR gene_out(out, in_0_and, in_1_and);

endmodule

module NOT_by_NOR(out, a);
input a;
output out;

nor gene_out(out, a, a);

endmodule

module AND_by_NOR(out, a, b);
input a, b;
output out;
wire n_a, n_b;

nor gene_n_a(n_a, a);
nor gene_n_b(n_b, b);
nor gene_out(out, n_a, n_b);

endmodule 

module OR_by_NOR(out, a, b);
input a, b;
output out;
wire a_nor_b;

nor gene_a_nor_b (a_nor_b, a, b);
nor gene_out(out, a_nor_b);

endmodule

module NOR_by_NOR(out, a, b);
input a, b;
output out;

nor gene_out(out, a, b);

endmodule

module NAND_by_NOR(out, a, b);
input a, b;
output out;
wire a_and_b;

AND_by_NOR gene_a_and_b(a_and_b, a, b);
NOT_by_NOR gene_out(out, a_and_b);

endmodule

module XOR_by_NOR(out, a, b);
input a, b;
output out;
wire n_a, n_b;
wire not_a_NOR_not_b, a_NOR_b;

NOT_by_NOR gene_not_a(not_a, a);
NOT_by_NOR gene_not_b(not_b, b);
nor gene_nor1(not_a_NOR_not_b, not_a, not_b);
nor gene_nor2(a_NOR_b, a, b);
nor gene_out(out, not_a_NOR_not_b, a_NOR_b);

endmodule

module XNOR_by_NOR(out, a, b);
input a, b;
output out;
wire a_NOR_b;
wire a_nor_norab, b_nor_norab;

nor gene_a_
NOR_b(a_NOR_b, a, b);
nor gene_a_nor_norab(a_nor_norab, a, a_NOR_b);
nor gene_b_nor_norab(b_nor_norab, b, a_NOR_b);
nor gene_out(out, a_nor_norab, b_nor_norab);

endmodule