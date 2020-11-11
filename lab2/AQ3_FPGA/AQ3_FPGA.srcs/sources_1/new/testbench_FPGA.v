`timescale 1ns / 1ps
module Lab2_TeamX_Carry_Look_Ahead_t;
reg [3:0] a, b;
reg cin;
wire [6:0] signal;
wire cout;
wire [3:0] AN;
//Carry_Look_Ahead_Adder CLAA(a, b, cin, cout, sum);
Set_signal OMG(a, b, cin, cout, signal, AN);

initial begin
    {a[3:0], b[3:0], cin} = 17'b0;
    repeat (2 ** 30) begin
//       #1 {a[7:0], b[7:0], cin} =  {a[7:0], b[7:0], cin} + 1'b1;
        #1 {a[3:0], b[3:0], cin} =  $random;        
    end
    #10 $finish;
end
endmodule
