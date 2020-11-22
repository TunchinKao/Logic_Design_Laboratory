`timescale 1ns/1ps

module Traffic_Light_Controller (clk, rst_n, lr_has_car, hw_light, lr_light, state, cnt);
input clk, rst_n;
input lr_has_car;
output [3-1:0] hw_light;
output [3-1:0] lr_light;
output [3-1:0] state;
output [64-1:0] cnt;
wire [3-1:0] state;

light_control lc(.state(state), .hw_light(hw_light), .lr_light(lr_light));
state_control sc(.clk(clk), .rst_n(rst_n), .lr_has_car(lr_has_car), .state(state)
                ,.cnt(cnt));


endmodule

module state_control(clk, rst_n, lr_has_car, state, cnt);
input clk, rst_n, lr_has_car;
output [3-1:0] state;
output [64-1:0] cnt;
parameter HW_go = 3'b000;
parameter HW_wait = 3'b001;
parameter Going_toLR = 3'b010;
parameter LR_go = 3'b011;
parameter LR_wait = 3'b100;
parameter Going_toHW = 3'b101;

reg [3-1:0] state;
reg [64-1:0] cnt;
reg [3-1:0] next_state;
reg flag;
always @(posedge clk)begin
    if(rst_n == 1'b0)begin
        state <= HW_go;
        cnt <= 64'd0;
    end else begin
        if(state == next_state)
            cnt <= cnt + 1'b1;
        else
            cnt <= 64'd0;
            state <= next_state;
            if(cnt >= 64'd35 && ~flag)
                flag <= 1'b1;
    end
end


always @(*)begin

case (state)
    HW_go :
        if((cnt >= 64'd2 || flag == 1'b1) && lr_has_car == 1'b1)begin
            next_state = HW_wait;
        end else begin
            next_state = HW_go;
        end

    HW_wait:
        if(cnt >= 64'd1)begin
            next_state = Going_toLR;
        end else begin
            next_state = HW_wait;
        end
    Going_toLR:
        
        if(cnt >= 64'd0)begin
            next_state = LR_go;
        end else begin
            next_state = Going_toLR;
        end
    LR_go:
    
        if(cnt >= 64'd2)begin
            next_state = LR_wait;
        end else begin
            next_state = LR_go;
        end
    LR_wait:
        
        if(cnt >= 64'd1)begin
            next_state = Going_toHW;
        end else begin
            next_state = LR_wait;
        end
    Going_toHW: 
        
        if(cnt >= 64'd0)begin
            next_state = HW_go;
        end else begin
            next_state = Going_toHW;
        end
    default:
        next_state = state;
endcase
    

end


endmodule

module light_control(state, hw_light, lr_light);
input [3-1:0] state;
output [3-1:0] hw_light, lr_light;
parameter HW_go = 3'b000;
parameter HW_wait = 3'b001;
parameter Going_toLR = 3'b010;
parameter LR_go = 3'b011;
parameter LR_wait = 3'b100;
parameter Going_toHW = 3'b101;
parameter Green = 3'b100;
parameter Yellow = 3'b010;
parameter Red = 3'b001;
wire [3-1:0] state;
reg [3-1:0] hw_light, lr_light;

always@(*)begin
    
case (state)
    HW_go : begin
        
        hw_light = Green;
        lr_light = Red;
    end
    HW_wait:begin
        
        hw_light = Yellow;
        lr_light = Red;
    end
    Going_toLR:begin
        
        hw_light = Red;
        lr_light = Red;
    end
    LR_go:begin
        
        hw_light = Red;
        lr_light = Green;
    end
    LR_wait:begin
        
        hw_light = Red;
        lr_light = Yellow;
    end
    Going_toHW:begin
        
        hw_light = Red;
        lr_light = Red;
    end 
    default:begin
        
        hw_light = Green;
        lr_light = Green; 
    end
endcase

end

endmodule