`timescale 1ns/1ps

module Clock_Divider (clk, rst_n, sel, clk1_2, clk1_4, clk1_8, clk1_3, dclk);
input clk, rst_n;
input [2-1:0] sel;
output clk1_2;
output clk1_4;
output clk1_8;
output clk1_3;
output dclk;


debounce gene_clks({clk1_8,
                    clk1_4,
                    clk1_3,
                    clk1_2}, clk, rst_n);

MUX_4_to_1 gene_out({clk1_8,
                     clk1_4,
                     clk1_2,
                     clk1_3}, sel, dclk);


endmodule

module debounce(pb, clk, reset);
output [3:0]pb;
input clk, reset;

reg [2:0]counter = 3'b000;
reg [1:0]three_counter = 2'b00;
always @(posedge clk)
begin
    if(!reset == 1'b1) begin
        counter <= 3'b000;
        three_counter <= 2'b00;
    end
    else begin
        counter <= counter+1'b1;
        if (three_counter == 2'b10) begin
            three_counter <= 2'b00;
        end else begin
            three_counter <= three_counter + 1'b1;
        end
    end
end
    assign pb[0] = ((counter[0] == 1'b1) ? 1'b1:1'b0);
    assign pb[1] = ((three_counter[1:0] == 2'b10) ? 1'b1:1'b0);
    assign pb[2] = ((counter[1:0] == 2'b11) ? 1'b1:1'b0);
    assign pb[3] = ((counter[2:0] == 3'b111) ? 1'b1:1'b0);

endmodule

module MUX_4_to_1 (
    in, sel, out
);
input [3:0] in;
input [1:0]sel;
output out;

wire [1:0]layer1;
MUX_2_to_1_by_NOR gene_layer1_1(in[1:0], sel[0], layer1[0]);
MUX_2_to_1_by_NOR gene_layer1_2(in[3:2], sel[0], layer1[1]);
MUX_2_to_1_by_NOR gene_out(layer1[1:0], sel[1], out);

endmodule

module MUX_2_to_1_by_NOR (
    in, sel, out
);
input [1:0] in;
input sel;
output out;
wire n_sel;
wire in_0_and, in_1_and;

not gene_n_sel(n_sel, sel);
and gene_in_0(in_0_and, in[0], n_sel);
and gene_in_1(in_1_and, in[1], sel);
or gene_out(out, in_0_and, in_1_and);

endmodule