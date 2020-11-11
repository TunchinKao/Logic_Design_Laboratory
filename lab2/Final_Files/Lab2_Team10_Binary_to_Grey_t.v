`timescale 1ns/1ps

module Binary_to_Grey_t ;
reg [3:0] din = 4'b0;
wire [3:0] dout;

Binary_to_Grey btg(din, dout);


initial begin
  repeat (16) begin
    #1 din = din + 1'b1;
  end
  #1 $finish;
end
endmodule