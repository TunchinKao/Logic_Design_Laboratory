`timescale 1ns / 1ps

module comp_testbench;
reg [3:0] a, b;
wire a_lt_b, a_gt_b, a_eq_b;
Comparator_4bits c(a, b, a_lt_b, a_gt_b, a_eq_b);
initial 
begin 
    a = 4'b0000;
    b = 4'b0000;
    repeat (16) 
    begin
        repeat (16) 
        begin
            #1 a = a + 4'b0001;
        end
        #1 b = b + 4'b0001;
    end
    $finish;
end

endmodule