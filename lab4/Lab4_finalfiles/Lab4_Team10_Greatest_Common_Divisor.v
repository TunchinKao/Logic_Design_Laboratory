`timescale 1ns/1ps

module Greatest_Common_Divisor (clk, rst_n, Begin, a, b, Complete, gcd);
input clk, rst_n;
input Begin;
input [16-1:0] a;
input [16-1:0] b;
output Complete;
output [16-1:0] gcd;

parameter WAIT = 2'b00;
parameter CAL = 2'b01;
parameter FINISH = 2'b10;

reg [1:0] state, nxt_state, cnt, nxt_cnt;
reg [15:0] gcd, gcd_a, gcd_b, nxt_gcd_a, nxt_gcd_b;
reg Complete, cal_finish;


always @ (posedge clk) begin
    if(rst_n == 1'b0) begin
        state <= WAIT;
    end
    else begin
        state <= nxt_state;
    end
end

always @ (posedge clk) begin
    gcd_a <= nxt_gcd_a;
    gcd_b <= nxt_gcd_b;
end

always @ (negedge clk) begin
    if(state == FINISH) cnt <= nxt_cnt;
    else cnt <= 2'b00;
end

always @ (state or Begin or cal_finish or cnt) begin
    case (state)
        WAIT:
        begin
            Complete = 1'b0;
            gcd = 16'd0;
            if(Begin == 1'b1) nxt_state = CAL;
            else nxt_state = WAIT;
        end 
        CAL:
        begin
            Complete = 1'b0;
            gcd = 16'd0;
            if(cal_finish == 1'b0) nxt_state = CAL;
            else nxt_state = FINISH;
        end
        FINISH:
        begin
            if(cnt < 2'b10) nxt_state = FINISH;
            else nxt_state = WAIT;
            Complete = 1'b1;
            gcd = gcd_a;
        end
        default:
        begin
            nxt_state = 2'b11;
            Complete = 1'b0;
            gcd = 16'b1111_1111_1111_1111;
        end 
    endcase
end

always @ (*) begin
    if(state == WAIT) begin
        if(Begin == 1'b1) begin
            nxt_gcd_a = a;
            nxt_gcd_b = b;
            cal_finish = 1'b0;
        end
        else begin
            nxt_gcd_a = nxt_gcd_a;
            nxt_gcd_b = nxt_gcd_b;
            cal_finish = cal_finish;
        end
    end
    else if (state == CAL) begin  
        if(gcd_b == 16'd0) begin
            nxt_gcd_a = gcd_a;
            nxt_gcd_b = gcd_b;
            cal_finish = 1'b1;
        end  
        else begin 
            cal_finish = 1'b0;   
            if(gcd_a > gcd_b) begin
                nxt_gcd_a = gcd_a - gcd_b;
                nxt_gcd_b = gcd_b; 
            end
            else begin
                nxt_gcd_a = gcd_a;
                nxt_gcd_b = gcd_b - gcd_a;
            end
        end
    end
    else if(state == FINISH) begin
        nxt_gcd_a = nxt_gcd_a;
        nxt_gcd_b = nxt_gcd_b;
        cal_finish = cal_finish;
    end
    else begin
        nxt_gcd_a = nxt_gcd_a;
        nxt_gcd_b = nxt_gcd_b;
        cal_finish = cal_finish;
    end
end

always @ (*) begin
    nxt_cnt = cnt + 1'b1;
end

endmodule
