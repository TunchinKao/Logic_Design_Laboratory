module Mux_1bit (a, b, sel, f);
input a, b;
input sel;
output f;

    wire a, b, sel;
    wire f;
    wire and_a_sel, and_b_sel;
    wire notsel;
    not NOT_1(notsel, sel);
    and AND_(and_a_sel, a, sel);
    and AND_2(and_b_sel, b, notsel);
    or OR_(f, and_a_sel, and_b_sel);
endmodule