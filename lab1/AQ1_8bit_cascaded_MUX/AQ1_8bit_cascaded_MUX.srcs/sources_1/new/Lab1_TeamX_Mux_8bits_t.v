
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/19 12:07:37
// Design Name: 
// Module Name: Lab1_TeamX_Mux_88s_t
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module Mux_8bits_t;
reg [8-1:0]A, B, C, D;
wire [8-1:0] F;
reg sel_1 = 0, sel_2 = 0, sel_3 = 0;
Mux_8bits M8(.a(A), .b(B), .c(C), .d(D), .sel1(sel_1), .sel2(sel_2), .sel3(sel_3), .f(F));
initial begin
    A[8-1:0] = 8'd32;
    B[8-1:0] = 8'd45;
    C[8-1:0] = 8'd12;
    D[8-1:0] = 8'd7;
    
    repeat (2 ** 3) begin
         #1 {sel_1, sel_2, sel_3} = {sel_1, sel_2, sel_3} + 1'b1;
     end
    
end
    
endmodule
