`timescale 1ns/1ps

module LFSR (clk, rst_n, out);
input clk, rst_n;
output out;

reg [4:0] DFF;

always @(posedge clk)begin
    if(rst_n === 1'b0)
        DFF[4:0] <= 5'b11111;
    else begin
        DFF[0] <= DFF[1] ^ DFF[4];
        DFF[1] <= DFF[0];
        DFF[2] <= DFF[1];
        DFF[3] <= DFF[2];
        DFF[4] <= DFF[3];
    end
end

assign out = DFF[4];

endmodule

// module LFSR_lookinside (clk, rst_n, out, DFF_out);
// input clk, rst_n;
// output out;
// output [4:0] DFF_out;
// reg [4:0] DFF;

// always @(posedge clk)begin
//     if(rst_n === 1'b0)
//         DFF[4:0] <= 5'b11111;
//     else begin
//         DFF[0] <= DFF[1] ^ DFF[4];
//         DFF[1] <= DFF[0];
//         DFF[2] <= DFF[1];
//         DFF[3] <= DFF[2];
//         DFF[4] <= DFF[3];
//     end
// end

// assign out = DFF[4];
// assign DFF_out = DFF;
// endmodule
