`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/21 19:49:41
// Design Name: 
// Module Name: Dec_testbench
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


module Dec_testbench;
reg [3:0]din;
wire [15:0]dout;
Decoder d(din, dout);
initial 
begin 
    din = 4'b0000;
    repeat (16) 
    begin
        #10 din = din + 4'b0001;
    end
    $finish;
end

endmodule