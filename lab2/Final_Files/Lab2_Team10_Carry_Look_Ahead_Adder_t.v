`timescale 1ns / 1ps
module Lab2_TeamX_Carry_Look_Ahead_t;
reg [3:0] a, b;
reg cin;
wire [3:0] sum;
wire cout;
Carry_Look_Ahead_Adder CLAA(a, b, cin, cout, sum);
task Test;
begin
    if({cout, sum} !== (a + b + cin))begin
        $display("ERROR!!!!");
        $write("debug a:%d ", a);
        $write("debug b:%d ", b);
        $write("debug cin:%d ", cin);
        $write("debug cout:%d ", cout);
        $write("debug su:%d ", sum);
    end
end   
endtask
initial begin
    {a[3:0], b[3:0], cin} = 17'b0;
    repeat (2 ** 30) begin
        #1 {a[3:0], b[3:0], cin} =  {a[3:0], b[3:0], cin} + 1'b1;        
        #1 Test;
    end
    #10 $finish;
end
endmodule
