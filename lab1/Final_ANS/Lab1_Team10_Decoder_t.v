`timescale 1ns / 1ps

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