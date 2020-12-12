//
//
//
//

module Decoder (
	input [15:0] tone,
	output reg [31:0] freq 
);

always @(*) begin
	case (tone)
		16'd1: freq = 32'd262;	//Do-m
		16'd2: freq = 32'd294;	//Re-m
		16'd3: freq = 32'd330;	//Mi-m
		16'd4: freq = 32'd349;	//Fa-m
		16'd5: freq = 32'd392;	//Sol-m
		16'd6: freq = 32'd440;	//La-m
		16'd7: freq = 32'd494;	//Si-m
		16'd8: freq = 32'd262 << 1;	//Do-h
		16'd9: freq = 32'd294 << 1;
		16'd10: freq = 32'd330 << 1;
		16'd11: freq = 32'd349 << 1;
		16'd12: freq = 32'd392 << 1;
		16'd13: freq = 32'd440 << 1;
		16'd14: freq = 32'd494 << 1;
		16'd15: freq = 32'd262 << 2; // Do C6
		16'd16: freq = 32'd294 << 2;
		16'd17: freq = 32'd330 << 2;	//Mi-m
		16'd18: freq = 32'd349 << 2;	//Fa-m
		16'd19: freq = 32'd392 << 2;	//Sol-m
		16'd20: freq = 32'd440 << 2;	//La-m
		16'd21: freq = 32'd494 << 2;	//Si-m
		16'd22: freq = 32'd262 << 3; // Do C7
		16'd23: freq = 32'd294 << 3;
		16'd24: freq = 32'd330 << 3;	//Mi-m
		16'd25: freq = 32'd349 << 3;	//Fa-m
		16'd26: freq = 32'd392 << 3;	//Sol-m
		16'd27: freq = 32'd440 << 3;	//La-m
		16'd28: freq = 32'd494 << 3;	//Si-m
		16'd29: freq = 32'd262 << 4; // Do C8
		default : freq = 32'd20000;	//Do-dummy
	endcase
end

endmodule