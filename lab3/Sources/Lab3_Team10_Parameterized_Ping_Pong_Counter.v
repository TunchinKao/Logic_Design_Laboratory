module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, direction, out);
input clk, rst_n;
input enable;
input flip;
input [4-1:0] max;
input [4-1:0] min;
output direction;
output [4-1:0] out;

reg direction, nxt_direction;
reg [3:0] cnt;

always @ (posedge clk) begin
    if(rst_n == 1'b0) begin
        cnt <= min;
        direction <= 1'b1;
    end
    else begin
        if(enable == 1'b1 && (max > min) && (cnt >= min) && (cnt <= max)) begin
            if(nxt_direction == 1'b1)begin
                cnt <= cnt + 1'b1;
            end
            else begin
                cnt <= cnt - 1'b1;
            end 
                direction <= nxt_direction;
        end 
        else begin  
            cnt <= cnt;
            direction <= nxt_direction;
        end 
    end
end

always @ (cnt, max, min, flip, rst_n, direction) begin
    if(rst_n == 1'b1) begin
        if(flip == 1'b1) nxt_direction = ~direction;
        else begin
            if(cnt == max) begin
                if(direction == 1'b1) nxt_direction = ~direction;
                else nxt_direction = direction;
            end
            else if(cnt == min) begin
                if(direction == 1'b0) nxt_direction = ~direction;
                else nxt_direction = direction;
            end
            else nxt_direction = direction;
        end
    end
    else nxt_direction = direction;
end

assign out = cnt;

endmodule