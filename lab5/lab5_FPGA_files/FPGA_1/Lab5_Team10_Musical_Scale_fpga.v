`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: TunchinKao
// 
// Create Date: 2020/11/23 09:03:55
// Design Name: 
// Module Name: TOP
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


module TOP(
    input wire clk,
	inout wire PS2_DATA,
	inout wire PS2_CLK,
	output pmod_1,	//AIN
	output pmod_2,	//GAIN
	output pmod_4,	//SHUTDOWN_N
	output [2:0]state
    );
// state Part -------------------------------------------

// reg dnBt, upBt, spBt, rst;
// reg [31:0] excnt;
wire rst;
// assign rst = 1'b0;

reg [3-1:0] state;
reg [3-1:0] next_state;
// StateControl SC(
// 	.downDirec(dnBt),
// 	.upDirec(upBt),
// 	.speedBt(spBt),
// 	.clk(clk),
// 	.rst(rst),
// 	.state(state)
// );

// Audio Part ------------------------------------------- From TOP.v

wire [15:0] tone;

wire [31:0] freq;
assign pmod_2 = 1'd1;	//no gain(6dB)
assign pmod_4 = 1'd1;	//turn-on


audioControl AC(
	.clk(clk),
	.rst(rst),
	.state(state),
	.tone(tone)
);

Decoder decoder00 (
	.tone(tone),
	.freq(freq)
);

PWM_gen pwm_0 ( 
	.clk(clk), 
	.reset(reset), 
	.freq(freq),
	.duty(10'd512), 
	.PWM(pmod_1)
);
// KeyBoard Part ---------------------------------------- from Sample Display

	parameter [8:0] LEFT_SHIFT_CODES  = 9'b0_0001_0010;
	parameter [8:0] RIGHT_SHIFT_CODES = 9'b0_0101_1001;
	parameter [8:0] KEY_CODES [0:7] = {
		9'b0_0100_0101,	// 0 => 45
		9'b0_0001_0110,	// 1 => 16
		9'b0_0001_1110,	// 2 => 1E
		
		9'b0_0111_0000, // right_0 => 70
		9'b0_0110_1001, // right_1 => 69
		9'b0_0111_0010, // right_2 => 72

		9'b0_0101_1010, // enter => 5A
		9'b1_0101_1010  // right_enter => E05A
	};
	reg [9:0] last_key;
	     
	wire shift_down;
	wire [511:0] key_down;
	wire [8:0] last_change;
	wire been_ready;
	
	// assign shift_down = (key_down[LEFT_SHIFT_CODES] == 1'b1 || key_down[RIGHT_SHIFT_CODES] == 1'b1) ? 1'b1 : 1'b0;
	assign enter_down = (key_down[KEY_CODES[6]] == 1'b1 || key_down[KEY_CODES[7]] == 1'b1) ? 1'b1 : 1'b0;
	assign rst = enter_down;
    KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);
parameter upOne = 3'b000;
parameter upHf = 3'b001;
parameter downOne = 3'b010;
parameter downHf = 3'b011;
	always @ (posedge clk, posedge rst) begin
		if(rst)begin
			state <= upHf;
		end else begin
			if (been_ready == 1'b1 && key_down[last_change] == 1'b1) begin
				state <= next_state;
			end	else begin
				state <= state;
			end	
		end
	end
	always @ (posedge clk, posedge rst) begin
		if(rst)begin
			state <= upHf;
		end else begin
			if (been_ready == 1'b1 && key_down[last_change] == 1'b1) begin
				state <= next_state;
			end	else begin
				state <= state;
			end	
		end
	end
	always @ (*) begin
		case(last_change)
				KEY_CODES[0]: begin
					case(state)
						upOne:
							next_state = downOne;
						upHf:
							next_state = downHf;
						default:
							next_state = state;
					endcase
				end
				KEY_CODES[1]:begin
					case(state)
						downOne:
							next_state = upOne;
						downHf:
							next_state = upHf;
						default:
							next_state = state;
					endcase
				end
				KEY_CODES[2]:begin
					case(state)
						downOne:
							next_state = downHf;
						upOne:
							next_state = upHf;
						downHf:
							next_state = downOne;
						upHf:
							next_state = upOne;
						default:
							next_state = state;
					endcase
				end
				KEY_CODES[3]: begin
					case(state)
						upOne:
							next_state = downOne;
						upHf:
							next_state = downHf;
						default:
							next_state = state;
					endcase
				end
				KEY_CODES[4]:begin
					case(state)
						downOne:
							next_state = upOne;
						downHf:
							next_state = upHf;
						default:
							next_state = state;
					endcase
				end
				KEY_CODES[5]:begin
					case(state)
						downOne:
							next_state = downHf;
						upOne:
							next_state = upHf;
						downHf:
							next_state = downOne;
						upHf:
							next_state = upOne;
						default:
							next_state = state;
					endcase
				end
				KEY_CODES[6]:begin
					next_state = upHf;
				end
				KEY_CODES[7]:begin
					next_state = upHf;
				end
				default 	: next_state = state;
		endcase
		
	end
	
endmodule

module audioControl (
	input wire clk,
	input wire rst,
	input wire [2:0] state,
	output reg [15:0] tone
);
parameter upOne = 3'b000;
parameter upHf = 3'b001;
parameter downOne = 3'b010;
parameter downHf = 3'b011;

reg [31:0] cnt;
parameter SEC = 32'd100_000_000;
parameter hfSEC = 32'd50_000_000;
always @(posedge clk, posedge rst)begin
	if(rst)begin
		cnt <= 32'd0;
		tone <= 16'd1;
	end else begin
		if(cnt >= SEC)
			cnt <= 32'd0;
		else
			cnt <= cnt + 1'b1;
		case(state)
		upOne:begin
			if(cnt == SEC && tone != 16'd29)begin
				tone <= tone + 16'd1;
			end else begin
				tone <= tone;
			end
		end
		
		upHf:begin
			if((cnt == SEC || cnt == hfSEC) && tone != 16'd29)begin
				tone <= tone + 16'd1;
			end else begin
				tone <= tone;
			end
		end
		downOne:begin
			if(cnt == SEC && tone != 16'd1)begin
				tone <= tone - 16'd1;
			end else begin
				tone <= tone;
			end
		end
		downHf:begin
			if((cnt == SEC || cnt == hfSEC) && tone != 16'd1)begin
				tone <= tone - 16'd1;
			end else begin
				tone <= tone;
			end
		end
		default :tone <= tone;
		endcase
	end
end

	
endmodule