`timescale 1ps / 1ps
module testbenchAQ2;
reg [3:0] a, b;
wire [7:0] result;
Multiplier CLAA(a, b, result);
task Test;
begin
    if(result !== (a*b))begin
        $display("ERROR!!!!");
        $write("debug a:%d ", a);
        $write("debug b:%d ", b);
        $write("debug result:%d ", result);
    end
end   
endtask
initial begin
    {a[3:0], b[3:0]} = 8'b0;
    repeat (2 ** 20) begin
        #1 {a[3:0], b[3:0]} =  {a[3:0], b[3:0]} + 1'b1;        
        #1 Test;
    end
    #10 $finish;
end
endmodule
