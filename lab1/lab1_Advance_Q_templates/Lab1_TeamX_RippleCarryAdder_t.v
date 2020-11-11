`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/19 21:48:05
// Design Name: 
// Module Name: Lab1_TeamX_RippleCarryAdder_t
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
//////////////////////////////////////////////////////////////////////////////////


module Lab1_TeamX_RippleCarryAdder_t;
reg [7:0] a, b;
reg cin;
wire [7:0] sum;
wire cout;
RippleCarryAdder RCA(a, b, cin, cout, sum);


initial begin
    {a[7:0], b[7:0], cin} = 17'b0;
    repeat (2 ** 30) begin
//       #1 {a[7:0], b[7:0], cin} =  {a[7:0], b[7:0], cin} + 1'b1;
        #1 {a[7:0], b[7:0], cin} =  $random;        
    end
    #10 $finish;
end


endmodule
