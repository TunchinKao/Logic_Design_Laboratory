`timescale 1ns/1ps
module tracker_sensor(clk, reset, left_signal, right_signal, mid_signal/*, state*/);
    input clk;
    input reset;
    input left_signal, right_signal, mid_signal;
    output reg [9:0] state;
    reg [9:0] next_state;
    wire [2:0] signal = {left_signal, mid_signal, right_signal};
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
    // [TO-DO] Receive three signals and make your own policy.
    // Hint: You can use output state to change your action.
    always @(posedge clk or negedge reset) begin
        if(reset == 1'b0)
            state <= STOP;
        else begin
            state <= next_state;
        end
    end
    always @(*) begin
       case (state)
           STOP:begin
                case(signal)
                        3'd000 :
                            next_state = GO_STRAIGHT_50;
                    default :
                        next_state = STOP;
                endcase
           end 
           GO_STRAIGHT_50 :begin
               case(signal)
                    3'd001 :
                    3'd011 :
                        next_state = TURN_LEFT_25;
                    3'd100 :
                    3'd110 :
                        next_state = TURN_RIGHT_25;
                    default:
                        next_state = state;
               endcase
           end
            TURN_RIGHT_25 : begin 
                case(signal)
                    3'd001 :
                    3'd011 :
                        next_state = TURN_LEFT_25;
                    3'd100 :
                    3'd110 :
                        next_state = TURN_RIGHT_25;
                    default :
                        next_state = GO_STRAIGHT_50;
                endcase
            end
            TURN_LEFT_25 : begin
                case(signal)
                    3'd001 :
                    3'd011 :
                        next_state = TURN_LEFT_25;
                    3'd100 :
                    3'd110 :
                        next_state = TURN_RIGHT_25;
                    default :
                        next_state = GO_STRAIGHT_50;
                endcase
            end
           default: 
       endcase 
    end
endmodule
