`timescale 1ns / 1ps

`define CYC 4

module Greatest_Common_Divisor_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
reg Begin = 1'b0;
reg [15:0] a = 16'd128;
reg [15:0] b = 16'd96;
wire cmp;
wire [15:0] gcd;

Greatest_Common_Divisor GCD(
    .clk(clk), 
    .rst_n(rst_n), 
    .Begin(Begin),
    .a(a),
    .b(b), 
    .Complete(cmp), 
    .gcd(gcd)
);


always #(`CYC / 2) clk = ~clk;

initial begin
    @(negedge clk) rst_n = 1'b0;
    @(negedge clk) rst_n = 1'b1;
    @(negedge clk) Begin = 1'b1;
    #(`CYC) Begin = 1'b0;
    #(`CYC * 7); 
    a = 16'd85;
    b = 16'd135;
    #(`CYC * 2);
    @(negedge clk) Begin = 1'b1;
    @(negedge clk) Begin = 1'b0;
    #(`CYC * 11);
    a = 16'd247;
    b = 16'd247;
    Begin = 1'd1;
    #(`CYC) Begin = 1'b0;
    #(`CYC * 4);

    $finish;

end


endmodule
