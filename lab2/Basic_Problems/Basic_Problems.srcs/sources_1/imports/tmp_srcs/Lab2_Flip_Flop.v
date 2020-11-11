// done
`timescale 1ns/1ps

module Flip_Flop (clk, d, q);
input clk;
input d;
output q;
wire n_clk;
wire connect;

not gene_n_clk(n_clk, clk);
Latch Master (
  .clk (clk),
  .d (d),
  .q (connect)
);

Latch Slave (
  .clk (n_clk),
  .d (connect),
  .q (q)
);
endmodule

module Latch (clk, d, q);
input clk;
input d;
output q;

wire n_d;
wire n_d_clk, d_clk;
wire n_q;

not gene_n_d(n_d, d);
nand gene_d_clk(d_clk, d, clk);
nand gene_n_d_clk(n_d_clk, n_d, clk);
nand gene_q(q, d_clk, n_q);
nand gene_n_q(n_q, n_d_clk, q);


endmodule
