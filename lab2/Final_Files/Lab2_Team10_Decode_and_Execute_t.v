`timescale 1ps/1ps

module Decode_and_Execute_t;
reg [2:0] op_code = 3'b0;
reg [3:0] rs = 4'b0;
reg [3:0] rt = 4'b0;
wire [3:0] rd;

Decode_and_Execute dae(op_code, rs, rt, rd);


initial begin
  repeat (2**11) begin
    #1 {rs, rt, op_code} = {rs, rt, op_code} + 1'b1;
  end
  #1 $finish;
end
endmodule