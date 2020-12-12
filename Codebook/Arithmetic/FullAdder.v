// done

module FullAdder (a, b, cin, cout, sum);
input a, b, cin;
output sum;
output cout;
wire a, b, cin;
wire sum, cout;
wire XNOR_a_b;
    xnor xnor_a_b(a, b, XNOR_a_b);
    xnor xnor_cin_xnorab(cin, XNOR_a_b, sum);
    Mux_1bit gecout(a, cin, XNOR_a_b, cout);
endmodule
