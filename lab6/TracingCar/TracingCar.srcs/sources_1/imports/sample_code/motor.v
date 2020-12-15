module motor(
    input clk,
    input rst,
    input [9:0]mode,
    output  [1:0]pwm
);

    reg [9:0]next_left_motor, next_right_motor;
    reg [9:0]left_motor, right_motor; // 10bit means the power of motor
    wire left_pwm, right_pwm;

    motor_pwm m0(clk, rst, left_motor, left_pwm); .// motor_pwm use to generate power of motor
    motor_pwm m1(clk, rst, right_motor, right_pwm);
    
    always@(posedge clk)begin
        if(rst)begin
            left_motor <= 10'd0;
            right_motor <= 10'd0;
        end else begin
            left_motor <= next_left_motor;
            right_motor <= next_right_motor;
        end
    end
    
    // [TO-DO] take the right speed for different situation

parameter STOP = 9'd0;
parameter GO_STRAIGHT_25 = 9'd1;
parameter GO_STRAIGHT_50 = 9'd2;
parameter GO_STRAIGHT_75 = 9'd3;
parameter GO_STRAIGHT_100 = 9'd4;
parameter GO_BACK_25 = 9'd5;
parameter GO_BACK_50 = 9'd6;
parameter GO_BACK_75 = 9'd7;
parameter GO_BACK_100 = 9'd8;
parameter TURN_RIGHT_25 = 9'd9;
parameter TURN_RIGHT_50 = 9'd10;
parameter TURN_RIGHT_75 = 9'd11;
parameter TURN_RIGHT_100 = 9'd12;
parameter TURN_LEFT_25 = 9'd13;
parameter TURN_LEFT_50 = 9'd14;
parameter TURN_LEFT_75 = 9'd15;
parameter TURN_LEFT_100 = 9'd16;

    always @(*) begin
        case (mode)
            STOP : begin
                next_left_motor = 10'd0;
                next_right_motor = 10'd0;
            end 
            GO_STRAIGHT_25 :
            GO_BACK_25 :
            TURN_LEFT_25 :
            TURN_RIGHT_25 :
                next_left_motor = 10'd250;
                next_left_motor = 10'd250;
                
            GO_STRAIGHT_50 :
            GO_BACK_50 :
            TURN_LEFT_50 :
            TURN_RIGHT_50 :
                next_left_motor = 10'd500;
                next_left_motor = 10'd500;
            GO_STRAIGHT_75 :
            GO_BACK_75 :
            TURN_LEFT_75 :
            TURN_RIGHT_75 :
                next_left_motor = 10'd750;
                next_left_motor = 10'd750;
            GO_STRAIGHT_100 :
            GO_BACK_100 :
            TURN_RIGHT_100 :
            TURN_LEFT_100 :
                next_left_motor = 10'd1000;
                next_left_motor = 10'd1000;
            default: 
                next_left_motor = 10'd0;
                next_left_motor = 10'd0;
        endcase
    end


    assign pwm = {left_pwm,right_pwm};
endmodule

module motor_pwm (
    input clk,
    input reset,
    input [9:0]duty,
	output pmod_1 //PWM
);
        
    PWM_gen pwm_0 ( 
        .clk(clk), 
        .reset(reset), 
        .freq(32'd25000),
        .duty(duty), 
        .PWM(pmod_1)
    );

endmodule

//generte PWM by input frequency & duty
module PWM_gen (
    input wire clk,
    input wire reset,
	input [31:0] freq,
    input [9:0] duty,
    output reg PWM
);
    wire [31:0] count_max = 100_000_000 / freq;
    wire [31:0] count_duty = count_max * duty / 1024;
    reg [31:0] count;
        
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            count <= 0;
            PWM <= 0;
        end else if (count < count_max) begin
            count <= count + 1;
            if(count < count_duty)
                PWM <= 1;
            else
                PWM <= 0;
        end else begin
            count <= 0;
            PWM <= 0;
        end
    end
endmodule

