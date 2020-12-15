module Top(
    input clk,
    input rst,
    input echo,
    input left_signal,
    input right_signal,
    input mid_signal,
    output trig,
    output left_motor,
    output reg [1:0]left,
    output right_motor,
    output reg [1:0]right
);

    wire Rst_n, rst_pb, stop;
    wire left_signal_pb, right_signal_pb, mid_signal_pb;
    wire [1:0] motor_speed;
    debounce d0(rst_pb, rst, clk);
    onepulse d1(rst_pb, clk, Rst_n);

    debounce dls(left_signal_pb, rst, clk);
    debounce drs(right_signal_pb, rst, clk);
    debounce dms(mid_signal_pb, rst, clk);

    reg[9:0] mode;
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

    motor A(
        .clk(clk),
        .rst(Rst_n),
        .mode(mode),
        .pwm(motor_speed)
    );

    sonic_top B(
        .clk(clk), 
        .rst(Rst_n), 
        .Echo(echo), 
        .Trig(trig),
        .stop(stop)
    );
    
    tracker_sensor C(
        .clk(clk), 
        .reset(Rst_n), 
        .left_signal(left_signal_pb), 
        .right_signal(right_signal_pb),
        .mid_signal(mid_signal_pb), 
        .state(mode)
       );
    
    always @(*) begin
        case (mode)
            STOP : {left, right} = 4'b0000;
            GO_STRAIGHT_25 :
            GO_STRAIGHT_50 :
            GO_STRAIGHT_75 :
            GO_STRAIGHT_100 :
            {left, right} = 4'b1010;
            GO_BACK_25 :
            GO_BACK_50 :
            GO_BACK_75 :
            GO_BACK_100 :
            {left, right} = 4'b0101;
            TURN_RIGHT_25 :
            TURN_RIGHT_50 :
            TURN_RIGHT_75 :
            TURN_RIGHT_100 :
            {left, right} = 4'b1000;
            TURN_LEFT_25 :
            TURN_LEFT_50 :
            TURN_LEFT_75 :
            TURN_LEFT_100 :
            {left, right} = 4'b0010; 
            default:
                {left, right} = 4'b0000; 
        endcase
    end

    assign {left_motor, right_motor} = motor_speed;

endmodule

module debounce (pb_debounced, pb, clk);
    output pb_debounced; 
    input pb;
    input clk;
    reg [4:0] DFF;
    
    always @(posedge clk) begin
        DFF[4:1] <= DFF[3:0];
        DFF[0] <= pb; 
    end
    assign pb_debounced = (&(DFF)); 
endmodule

module onepulse (PB_debounced, clk, PB_one_pulse);
    input PB_debounced;
    input clk;
    output reg PB_one_pulse;
    reg PB_debounced_delay;

    always @(posedge clk) begin
        PB_one_pulse <= PB_debounced & (! PB_debounced_delay);
        PB_debounced_delay <= PB_debounced;
    end 
endmodule

