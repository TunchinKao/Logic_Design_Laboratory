module XNOR (a, b, Q);
    input a, b;
    output Q;
    wire a, b;
    wire Q;
    wire nor_a_b, and_a_b;
    nor NOR_(nor_a_b, a, b);
    and AND_(and_a_b, a, b);
    or OR_(Q, and_a_b, nor_a_b);
endmodule 