`timescale 1ns / 1ns

module Lab3_AQ1_LSFR_tb;
// global clock
reg CLK = 1'b0;
// input
reg rst_n = 1'b0;
// output
wire Out;
// wire Out_2;
// wire [4:0] DFFout;
 
LFSR testing_instance(
     .clk(CLK), 
     .rst_n(rst_n),
     .out(Out)
 );
// LFSR_lookinside testing_inside(
//     .clk(CLK),
//     .rst_n(rst_n),
//     .out(Out_2),
//     .DFF_out(DFFout)
// );
always #2 CLK = ~CLK;

initial begin
    rst_n = 1'b0;

    repeat(2**7)begin
        @(negedge CLK)begin 
            rst_n = 1'b1;
        end
    end

    repeat(2**4)begin
        @(negedge CLK)
            rst_n = 1'b0;
    end

    repeat(2**5)begin
        @(negedge CLK)
            rst_n = 1'b1;
    end
    $finish;
end

endmodule
