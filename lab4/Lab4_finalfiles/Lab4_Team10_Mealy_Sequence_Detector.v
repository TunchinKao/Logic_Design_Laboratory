`timescale 1ns/1ps

module Mealy_Sequence_Detector (clk, rst_n, in, dec);
input clk, rst_n;
input in;
output dec;

reg [3:0] state, nxt_state, dec;

parameter S0 = 4'b0000;
parameter S1 = 4'b0001;
parameter S2 = 4'b0010;
parameter S3 = 4'b0011;
parameter S4 = 4'b0100;
parameter S5 = 4'b0101;
parameter S6 = 4'b0110;
parameter S7 = 4'b0111;
parameter S8 = 4'b1000;

always @ (posedge clk) begin
    if(rst_n == 1'b0) begin
        state <= 4'd0;
    end
    else begin
        state <= nxt_state;
    end
end

always @ (state or in) begin
    case (state)
        S0: 
        begin
            if(in == 1'b1) begin
                nxt_state = S1;
                dec = 1'b0;
            end
            else begin
                nxt_state = S4;
                dec = 1'b0;
            end
        end
        S1: 
        begin
            if(in == 1'b1) begin
                nxt_state = S7;
                dec = 1'b0;
            end
            else begin
                nxt_state = S2;
                dec = 1'b0;
            end
        end 
        S2: 
        begin
            if(in == 1'b1) begin
                nxt_state = S3;
                dec = 1'b0;
            end
            else begin
                nxt_state = S8;
                dec = 1'b0;
            end
        end
        S3: 
        begin
            nxt_state = S0;
            dec = 1'b1;
        end
        S4: 
        begin
            if(in == 1'b1) begin
                nxt_state = S7;
                dec = 1'b0;
            end
            else begin
                nxt_state = S5;
                dec = 1'b0;
            end
        end
        S5: 
        begin
            if(in == 1'b1) begin
                nxt_state = S6;
                dec = 1'b0;
            end
            else begin
                nxt_state = S8;
                dec = 1'b0;
            end
        end
        S6: 
        begin
            nxt_state = S0;
            if(in == 1'b1) begin
                dec = 1'b1;
            end
            else begin
                dec = 1'b0;
            end
        end
        S7: 
        begin
            nxt_state = S8;
            dec = 1'b0;
        end
        S8: 
        begin
            nxt_state = S0;
            dec = 1'b0;
        end
        default: 
        begin
            nxt_state = 4'b1111;
            dec = 1'b0;
        end
    endcase
end


endmodule
