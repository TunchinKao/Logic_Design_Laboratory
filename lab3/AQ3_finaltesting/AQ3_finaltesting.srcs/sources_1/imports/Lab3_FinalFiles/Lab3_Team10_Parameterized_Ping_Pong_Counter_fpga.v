`timescale 1ns/1ps 

module FPGA_Display(clk, rst_n, enable, flip, max, min, out, an, num, flip_db_op_longer, not_rst_n_dp_op);
input clk, rst_n, enable, flip;
input [3:0] max, min;
output [6:0] out;
output [3:0] an;
output [3:0] num;
output not_rst_n_dp_op, flip_db_op_longer;
wire clk_225, clk_216, dir, flip_db, rst_n_db, flip_db_op, rst_n_db_op;
//wire not_rst_n_dp_op, not_flip_db_op;
wire [3:0] num;
reg [3:0] an;
reg [6:0] out;
wire rst_n_dp_longer, flip_db_op_longer;


Clock_Divider_225 cd225(clk, clk_225);
Clock_Divider_216 cd216(clk, clk_216);

debounce db_f(flip_db, flip, clk);
debounce db_r(rst_n_db, rst_n, clk);
one_pulse op_f(flip_db_op, flip_db, clk);
one_pulse op_r(rst_n_db_op, rst_n_db, clk);

Extend ex_rst(clk, rst_n_db_op, rst_n_dp_longer);
Extend ex_ret(clk, flip_db_op, flip_db_op_longer);


not(not_rst_n_dp_op, rst_n_dp_longer);
//not(not_flip_db_op, flip_db_op);

Parameterized_Ping_Pong_Counter pppc(clk_225 , not_rst_n_dp_op, enable, flip_db_op_longer, max, min, dir, num);
// Parameterized_Ping_Pong_Counter pppc(clk, not_rst_n_dp_op, enable, not_flip_db_op, max, min, dir, num);

// always @ (posedge clk) begin
always @ (posedge clk_216) begin
    if(not_rst_n_dp_op == 1'b0) begin
        an <= 4'b1110;
        case (an) 
        4'b1110: 
        begin 
            an <= 4'b0111;
            case (num)
            4'b0000: out <= 7'b000_0001;
            4'b0001: out <= 7'b000_0001;
            4'b0010: out <= 7'b000_0001;
            4'b0011: out <= 7'b000_0001;
            4'b0100: out <= 7'b000_0001;
            4'b0101: out <= 7'b000_0001;
            4'b0110: out <= 7'b000_0001;
            4'b0111: out <= 7'b000_0001;
            4'b1000: out <= 7'b000_0001;
            4'b1001: out <= 7'b000_0001;
            4'b1010: out <= 7'b100_1111;
            4'b1011: out <= 7'b100_1111;
            4'b1100: out <= 7'b100_1111;
            4'b1101: out <= 7'b100_1111;
            4'b1110: out <= 7'b100_1111;
            4'b1111: out <= 7'b100_1111;
            default : out <= 7'b101_1111;
            endcase
        end
        4'b0111:     
        begin 
            an <= 4'b1011;
            case (num)
            4'b0000: out <= 7'b000_0001;
            4'b1010: out <= 7'b000_0001;
            4'b0001: out <= 7'b100_1111;
            4'b1011: out <= 7'b100_1111;
            4'b0010: out <= 7'b001_0010;
            4'b1100: out <= 7'b001_0010;
            4'b0011: out <= 7'b000_0110;
            4'b1101: out <= 7'b000_0110;
            4'b0100: out <= 7'b100_1100;
            4'b1110: out <= 7'b100_1100;
            4'b0101: out <= 7'b010_0100;
            4'b1111: out <= 7'b010_0100;
            4'b0110: out <= 7'b010_0000;
            4'b0111: out <= 7'b000_1111;
            4'b1000: out <= 7'b000_0000;
            4'b1001: out <= 7'b000_0100;
            default : out <= 7'b011_1111;
            endcase
        end
        4'b1011:
        begin 
            an <= 4'b1101;
            out <= 7'b001_1101;
        end
        4'b1101:
        begin 
            an <= 4'b1110;
            out <= 7'b001_1101;
        end
        default : out <= 7'b111_0111;
        endcase
    end
    else begin
        case (an) 
        4'b1110: 
        begin 
            an <= 4'b0111;
            case (num)
            4'b0000: out <= 7'b000_0001;
            4'b0001: out <= 7'b000_0001;
            4'b0010: out <= 7'b000_0001;
            4'b0011: out <= 7'b000_0001;
            4'b0100: out <= 7'b000_0001;
            4'b0101: out <= 7'b000_0001;
            4'b0110: out <= 7'b000_0001;
            4'b0111: out <= 7'b000_0001;
            4'b1000: out <= 7'b000_0001;
            4'b1001: out <= 7'b000_0001;
            4'b1010: out <= 7'b100_1111;
            4'b1011: out <= 7'b100_1111;
            4'b1100: out <= 7'b100_1111;
            4'b1101: out <= 7'b100_1111;
            4'b1110: out <= 7'b100_1111;
            4'b1111: out <= 7'b100_1111;
            default : out <= 7'b101_1111;
            endcase
        end
        4'b0111:     
        begin 
            an <= 4'b1011;
            case (num)
            4'b0000: out <= 7'b000_0001;
            4'b1010: out <= 7'b000_0001;
            4'b0001: out <= 7'b100_1111;
            4'b1011: out <= 7'b100_1111;
            4'b0010: out <= 7'b001_0010;
            4'b1100: out <= 7'b001_0010;
            4'b0011: out <= 7'b000_0110;
            4'b1101: out <= 7'b000_0110;
            4'b0100: out <= 7'b100_1100;
            4'b1110: out <= 7'b100_1100;
            4'b0101: out <= 7'b010_0100;
            4'b1111: out <= 7'b010_0100;
            4'b0110: out <= 7'b010_0000;
            4'b0111: out <= 7'b000_1111;
            4'b1000: out <= 7'b000_0000;
            4'b1001: out <= 7'b000_0100;
            default : out <= 7'b011_1111;
            endcase
        end
        4'b1011:
        begin 
            an <= 4'b1101;
            if(dir == 1'b1) out <= 7'b001_1101;
            else out <= 7'b110_0011;
        end
        4'b1101:
        begin 
            an <= 4'b1110;
            if(dir == 1'b1) out <= 7'b001_1101;
            else out <= 7'b110_0011;
        end
        default : an <= 4'b1110;
        endcase
    end
end

endmodule

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
        if(enable === 1'b1 && (max > min) && (cnt >= min) && (cnt <= max)) begin
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
            direction <= direction;
        end 
    end
end

always @ (cnt, max, min, flip, rst_n, direction) begin
    if(rst_n === 1'b1) begin
        if(flip === 1'b1) nxt_direction = ~direction;
        else begin
            if(cnt === max) begin
                if(direction === 1'b1) nxt_direction = ~direction;
                else nxt_direction = direction;
            end
            else if(cnt === min) begin
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

module debounce(db, in, clk);
input in, clk;
output db;

reg [3:0] dff;

always @ (posedge clk) begin
    dff[3:1] <= dff[2:0];
    dff[0] <= in;
end

assign db = ( (dff == 4'b1111) ? 1'b1 : 1'b0);

endmodule

module one_pulse(o_p, in, clk);
input in, clk;
output o_p;

reg o_p, in_delay;

always @ (posedge clk) begin
    o_p <= in & ( !in_delay);
    in_delay <= in;
end

endmodule

parameter longer_multi = 15;

module Extend(clk, in ,out);

input clk, in;
// input sub_clk; // the clk we concern about the length
output out;

reg [25-1:0]cnt;

always @(posedge clk)begin
    if(in == 1'b1 && cnt == 24'd000000000)begin
        cnt <= cnt + 1'b1;
    end
    else if(cnt != 24'd000000000)begin
        cnt <= cnt + 1'b1;
    end
    else begin
        cnt <= 24'd000000000;
    end      
end


assign out = (cnt == 30'd0000000 ? 1'b0 : 1'b1);


endmodule


module Clock_Divider_225 (clk, clk1_2_25);
input clk;
output clk1_2_25;

reg clk1_2_25;
reg [24:0] cnt, nxt_cnt;

always @ (posedge clk)
    begin
        cnt <= nxt_cnt;
        if (cnt == 25'b1_1111_1111_1111_1111_1111_1111) clk1_2_25 <= 1'b1;
        else clk1_2_25 <= 1'b0;
    end
    
always @ (*) begin
    if(cnt == 25'b1_1111_1111_1111_1111_1111_1111) nxt_cnt = 25'd0;
    else nxt_cnt = cnt + 1'b1;
end

endmodule

module Clock_Divider_216 (clk, clk1_2_16);
input clk;
output clk1_2_16;

reg clk1_2_16;
reg [15:0] cnt, nxt_cnt;

always @ (posedge clk)
    begin
        cnt <= nxt_cnt;
        if (cnt === 16'b1111_1111_1111_1111) clk1_2_16 <= 1'b1;
        else clk1_2_16 <= 1'b0;
    end
     
always @ (*) begin
    if(cnt === 16'b1111_1111_1111_1111) nxt_cnt = 16'd0;
    else nxt_cnt = cnt + 1'b1;
end

endmodule



