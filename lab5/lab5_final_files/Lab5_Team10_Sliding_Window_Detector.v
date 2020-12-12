`timescale 1ns/1ps

module Sliding_Window_Detector (clk, rst_n, in, dec1, dec2);
input clk, rst_n;
input in;
output dec1, dec2;

parameter S0_1 = 3'b000;
parameter S1_1 = 3'b001;
parameter S2_1 = 3'b010;
parameter S0_2 = 3'b011;
parameter S1_2 = 3'b100;
parameter S2_2 = 3'b101;
parameter S3_2 = 3'b110;
parameter STOP = 3'b111;

reg [2:0] state1, nxt_state1, state2, nxt_state2, cnt, nxt_cnt;
reg dec1, dec2;

always @ (posedge clk) begin
    if(rst_n == 1'b0) state1 <= S0_1;
    else state1 <= nxt_state1;
end

always @ (posedge clk) begin
    if(rst_n == 1'b0) state2 <= S0_2;
    else state2 <= nxt_state2;
end

always @ (negedge clk) begin
    if(rst_n == 1'b0) cnt <= 1'b0;
    else cnt <= nxt_cnt;
end

always @ (state1, in, cnt) begin
    case (state1)
        S0_1:
        begin
            nxt_cnt = 3'd0;
            if(in == 1'b1) begin
                nxt_state1 = S1_1;
                dec1 = 1'b0;
            end
            else begin
                nxt_state1 = S0_1;
                dec1 = 1'b0;
            end
        end
        S1_1:
        begin
            if(cnt == 3'd4) begin
                nxt_state1 = STOP;
                nxt_cnt = cnt;
                dec1 = 1'b0;
            end
            else begin
                nxt_cnt = cnt + 1'b1;
                if(in == 1'b1) begin
                    nxt_state1 = S1_1;
                    dec1 = 1'b0;
                end
                else begin
                    nxt_state1 = S2_1;
                    dec1 = 1'b0;
                end    
            end
        end
        S2_1:
        begin
            nxt_cnt = 3'd0;
            if(in == 1'b1) begin
                nxt_state1 = S1_1;
                dec1 = 1'b1;
            end
            else begin
                nxt_state1 = S0_1;
                dec1 = 1'b0;
            end
        end
        STOP:
        begin
            nxt_cnt = cnt;
            nxt_state1 = STOP;
            dec1 = 1'b0;
        end
        default:
        begin
            nxt_cnt = 3'd0;
            nxt_state1 = S0_1;
            dec1 = 1'b0; 
        end
    endcase
end

always @ (state2, in) begin
    case (state2)
        S0_2:
        begin
            if(in == 1'b1) begin
                nxt_state2 = S1_2;
                dec2 = 1'b0;
            end
            else begin
                nxt_state2 = S0_2;
                dec2 = 1'b0;
            end
        end
        S1_2:
        begin
            if(in == 1'b1) begin
                nxt_state2 = S2_2;
                dec2 = 1'b0;
            end
            else begin
                nxt_state2 = S0_2;
                dec2 = 1'b0;
            end
        end
        S2_2:
        begin
            if(in == 1'b1) begin
                nxt_state2 = S2_2;
                dec2 = 1'b0;
            end
            else begin
                nxt_state2 = S3_2;
                dec2 = 1'b0;
            end
        end
        S3_2:
        begin
            if(in == 1'b1) begin
                nxt_state2 = S1_2;
                dec2 = 1'b1;
            end
            else begin
                nxt_state2 = S0_2;
                dec2 = 1'b0;
            end
        end
        default: 
        begin
            nxt_state2 = S0_2;
            dec2 = 1'b0;
        end
    endcase
end

endmodule