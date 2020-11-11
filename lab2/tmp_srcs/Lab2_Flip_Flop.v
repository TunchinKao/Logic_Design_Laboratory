`timescale 1ns/1ps

module Flip_Flop (clk, d, q);
input clk;
input d;
output q;

Latch Master (
  .clk (),
  .d (),
  .q ()
);

Latch Slave (
  .clk (),
  .d (),
  .q ()
);
endmodule

module Latch (clk, d, q);
input clk;
input d;
output q;

endmodule
