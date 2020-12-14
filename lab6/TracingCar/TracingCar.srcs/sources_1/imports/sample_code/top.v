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



    motor A(
        .clk(clk),
        .rst(Rst_n),
        //.mode(),
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
        //.state()
       );

    always @(*) begin
        case (mode)
            STOP : {left, right} = 4'b0000;
            GO_STRAIGHT : {left, right} = 4'b1010; 
            default: 
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

