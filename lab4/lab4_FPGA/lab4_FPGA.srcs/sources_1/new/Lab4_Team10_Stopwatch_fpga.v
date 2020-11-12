`timescale 1ns / 1ps

module Stopwatch(clk, push_bottom, reset_bottom, out, an, 
                r_signal_ex, sp_signal_ex, state, clk_10
                , push_bottom_out, reset_bottom_out);
input clk, push_bottom, reset_bottom;
output [7:0]out;
output [3:0]an;
output [1:0]state;
output clk_10;
output r_signal_ex, sp_signal_ex;
output push_bottom_out, reset_bottom_out;

reg [7:0]out;
reg [3:0]an;
wire minute, second, sec_onetenth;
wire clk_onesecdiv10;

wire p_bottom_db, r_bottom_db;
debounce db_push_bottom(.bottom(push_bottom), .out(p_bottom_db), .clk(clk));
debounce db_reset_bottom(.bottom(reset_bottom), .out(r_bottom_db), .clk(clk));

wire resetsignal, sp_signal; // sp -> start and pause
one_pulse gene_sp_signal(.in(p_bottom_db), .o_p(sp_signal), .clk(clk));
one_pulse gene_re_signal(.in(r_bottom_db), .o_p(resetsignal), .clk(clk));

wire r_signal_ex, sp_signal_ex;

Extend extend_r_signal(.clk(clk), .in(resetsignal), .out(r_signal_ex));
Extend extend_sp_signal(.clk(clk), .in(sp_signal), .out(sp_signal_ex));

// clksecdiv_10 div10ms(clk, clk_onesecdiv10);

wire n_resetsignal;

not gene_reset(n_resetsignal, r_signal_ex);

assign push_bottom_out = push_bottom;
assign reset_bottom_out = reset_bottom;


wire [3:0] min;
wire [3:0] sec1;
wire [3:0] sec2;
wire [3:0] secdiv10;

counterup countit(.clk(clk), .r_signal(n_resetsignal), .sp_signal(sp_signal_ex)
        ,.min(min), .sec1(sec1), .sec2(sec2), .secdiv10(secdiv10), .state(state));

clksecdiv_10 testclk(.clk(clk), .clk_10(clk_10));

wire clk_216;

Clock_Divider_216 cd216(clk, clk_216);
always @ (posedge clk_216) begin
        an[3:0] <= {an[0], an[3:1]};
        case (an) 
        4'b1110: // atually 0111
        begin 
            out[7] <= 1'b1;
            case (min)
            4'b0000: out[6:0] <= 7'b000_0001;
            4'b0001: out[6:0] <= 7'b100_1111;
            4'b0010: out[6:0] <= 7'b001_0010;
            4'b0011: out[6:0] <= 7'b000_0110;
            4'b0100: out[6:0] <= 7'b100_1100;
            4'b0101: out[6:0] <= 7'b010_0100;
            4'b0110: out[6:0] <= 7'b010_0000;
            4'b0111: out[6:0] <= 7'b000_1111;
            4'b1000: out[6:0] <= 7'b000_0000;
            4'b1001: out[6:0] <= 7'b000_0100;
            default : out[6:0] <= 7'b101_1111;
            endcase
        end
        4'b0111:  //atually 1011
        begin 
            out[7] <= 1'b1;
            case (sec1)
            4'b0000: out[6:0] <= 7'b000_0001;
            4'b0001: out[6:0] <= 7'b100_1111;
            4'b0010: out[6:0] <= 7'b001_0010;
            4'b0011: out[6:0] <= 7'b000_0110;
            4'b0100: out[6:0] <= 7'b100_1100;
            4'b0101: out[6:0] <= 7'b010_0100;
            4'b0110: out[6:0] <= 7'b010_0000;
            4'b0111: out[6:0] <= 7'b000_1111;
            4'b1000: out[6:0] <= 7'b000_0000;
            4'b1001: out[6:0] <= 7'b000_0100;
            default : out[6:0] <= 7'b101_1111;
            endcase
        end
        4'b1011:
        begin 
            out[7] <= 1'b0;
            // an <= 4'b0111;
            case (sec2)
            4'b0000: out[6:0] <= 7'b000_0001;
            4'b0001: out[6:0] <= 7'b100_1111;
            4'b0010: out[6:0] <= 7'b001_0010;
            4'b0011: out[6:0] <= 7'b000_0110;
            4'b0100: out[6:0] <= 7'b100_1100;
            4'b0101: out[6:0] <= 7'b010_0100;
            4'b0110: out[6:0] <= 7'b010_0000;
            4'b0111: out[6:0] <= 7'b000_1111;
            4'b1000: out[6:0] <= 7'b000_0000;
            4'b1001: out[6:0] <= 7'b000_0100;
            default : out[6:0] <= 7'b101_1111;
            endcase
        end
        4'b1101:
        begin 
            out[7] <= 1'b1;
            // an <= 4'b0111;
            case (secdiv10)
            4'b0000: out[6:0] <= 7'b000_0001;
            4'b0001: out[6:0] <= 7'b100_1111;
            4'b0010: out[6:0] <= 7'b001_0010;
            4'b0011: out[6:0] <= 7'b000_0110;
            4'b0100: out[6:0] <= 7'b100_1100;
            4'b0101: out[6:0] <= 7'b010_0100;
            4'b0110: out[6:0] <= 7'b010_0000;
            4'b0111: out[6:0] <= 7'b000_1111;
            4'b1000: out[6:0] <= 7'b000_0000;
            4'b1001: out[6:0] <= 7'b000_0100;
            default : out[6:0] <= 7'b101_1111;
            endcase
        end
        default : an <= 4'b1110;
        endcase
    
end

endmodule


module counterup(clk, r_signal, sp_signal, min, sec1, sec2, secdiv10, state);
input clk, r_signal, sp_signal;
output  min, sec1, sec2, secdiv10;
output state;
reg [3:0]min, next_min;
reg [3:0]sec1, sec2, next_sec1 , next_sec2;
reg [3:0]secdiv10, next_secdiv10;
wire [1:0]state;
wire sec_div10_clk;
parameter COUNT = 2'b01;
parameter WAIT = 2'b10;
parameter RESET = 2'b11;

state_transition setup( .start_pause(sp_signal),
                        .reset(r_signal),
                        .clk(clk), .state(state),
                    .min(min), .sec1(sec1), .sec2(sec2), .secdiv10(secdiv10)    
                    );

clksecdiv_10 gene_onetensec(.clk(clk), .clk_10(sec_div10_clk));
// Clock_Divider_216 geneclkdiv(.clk(clk), .clk1_2_16(sec_div10_clk));

// Clock_Divider_23 geneclkdiv(.clk(clk), .clk1_2_16(sec_div10_clk));
always @(posedge clk)begin
    if(sec_div10_clk == 1'b1) begin
        case(state)
        COUNT: begin
            min <= next_min;
            sec1 <= next_sec1;
            sec2 <= next_sec2;
            secdiv10 <= next_secdiv10;
        end
        WAIT: begin
            min <= min;
            sec1 <= sec1;
            sec2 <= sec2;
            secdiv10 <= secdiv10;
        end
        RESET:begin
            min <= 4'd0;
            sec1 <= 4'd0;
            sec2 <= 4'd0;
            secdiv10 <= 4'd0;
        end
        endcase
    end else begin
        min <= min;
        sec1 <= sec1;
        sec2 <= sec2;
        secdiv10 <= secdiv10;
    end
end


always @(*)begin
    if(sec1 == 4'd5 && sec2 == 4'd9 && secdiv10 == 4'd9)
        if(min == 4'd9) 
            next_min = 4'd0;
        else
            next_min = min + 1'd1;
    else
        next_min = min;
    if(secdiv10 == 4'd9 && sec2 == 4'd9)
        if(sec1 == 4'd5)
            next_sec1 = 4'd0;
        else
            next_sec1 = sec1 + 1'd1;
    else
        next_sec1 = sec1;
    if(secdiv10 == 4'd9)begin
        if(sec2 == 4'd9)
            next_sec2 = 4'd0;
        else
            next_sec2 = sec2 + 1'd1;
    end else begin
        next_sec2 = sec2;
    end
    if(secdiv10 == 4'd9)
        next_secdiv10 = 4'd0;
    else
        next_secdiv10 = secdiv10 + 1'd1;   
end

endmodule

module state_transition(start_pause, reset, clk, state,
                        min, sec1, sec2, secdiv10);
input start_pause, reset, clk;
input min, sec1, sec2, secdiv10;
output [1:0]state;
wire [3:0] min, sec1, sec2, secdiv10;
parameter COUNT = 2'b01;
parameter WAIT = 2'b10;
parameter RESET = 2'b11;

reg [1:0] state, next_state;

wire sec_div10_clk;

clksecdiv_10 gene_onetensec(.clk(clk), .clk_10(sec_div10_clk));
// Clock_Divider_216 geneclkdiv(.clk(clk), .clk1_2_16(sec_div10_clk));
//  Clock_Divider_23 geneclkdiv(.clk(clk), .clk1_2_16(sec_div10_clk));

always @(posedge clk)begin
    if(sec_div10_clk == 1'b1)begin
        if(reset == 1'b0)begin
            state <= RESET;
        end else
            state <= next_state;
    end
    else begin
        state <= state;
    end
end

always @(*)begin
    case (state)
        COUNT:
            if(min == 4'd9 && sec1 == 4'd5 && sec2 == 4'd9 && secdiv10 == 4'd9)
                next_state = RESET;
            else begin
                if(start_pause == 1'b1)
                    next_state = WAIT;
                else
                    next_state = COUNT;
            end      
        WAIT:
            if(start_pause == 1'b1)
                next_state = COUNT;
            else
                next_state = WAIT;
        RESET:
            next_state = WAIT;
    default:
        next_state = RESET;
    endcase
end 
endmodule

module debounce(out, bottom, clk);
input bottom, clk;
output out;
reg [3:0] cnt;

always @(posedge clk)begin
    cnt[3:1] <= cnt[2:0];
    cnt[0] <= bottom;
end

assign out = (cnt[3:0] == 4'b1111 ? 1'b1 : 1'b0);

endmodule

module one_pulse(in, o_p, clk);
input in, clk;
output o_p;    

reg in_delay;
reg o_p;
always @(posedge clk)begin
    o_p <= in & (!in_delay);
    in_delay <= in;
end

endmodule

module Extend(clk, in, out);

input clk, in;
output out;

reg [25:0] cnt, next_cnt;

parameter conNum = 26'd10000000;

always @(posedge clk)begin
    if(in == 1'b1 && cnt == 26'd0)begin
        cnt <= cnt + 1'b1;
    end
    else if(cnt != 26'd0)begin
        cnt <= next_cnt;
    end
    else begin
        cnt <= 26'd0;
    end      
end

always @(*)begin
    if(cnt == conNum - 1)
        next_cnt = 26'd0;
    else
        next_cnt = cnt + 1'b1;
end

assign out = (cnt == 26'd0 ? 1'b0 : 1'b1);

endmodule


module clksecdiv_10(clk, clk_10);
input clk;
output clk_10;
reg clk_10;
reg [25:0]cnt;
reg [25:0]next_cnt;
parameter conNum = 26'd10000000;
always @(negedge clk)begin
    cnt <= next_cnt;
    if(cnt == conNum - 1'b1)
        // clk_10 <= !clk_10;
        clk_10 <= 1'b1;
    else
        clk_10 <= 1'b0;
end

always @(*)begin
    if(cnt >= conNum - 1'b1)begin
        next_cnt  = 26'd0;
    end
    else begin
        next_cnt = cnt + 1'b1;
    end
end

endmodule

module Clock_Divider_216 (clk, clk1_2_16);
input clk;
output clk1_2_16;

parameter constantNumber = 16'b1111_1111_1111_1111;
reg clk1_2_16;
reg [15:0] cnt, nxt_cnt;

always @ (negedge clk)
    begin
        cnt <= nxt_cnt;
        if (cnt === constantNumber) clk1_2_16 <= 1'b1;
        else clk1_2_16 <= 1'b0;
    end
     
always @ (*) begin
    if(cnt === constantNumber) nxt_cnt = 16'd0;
    else nxt_cnt = cnt + 1'b1;
end

endmodule

module Clock_Divider_23 (clk, clk1_2_16);
input clk;
output clk1_2_16;

reg clk1_2_16;
reg [2:0] cnt;
// reg [2:0] nxt_cnt;
parameter constantNum = 3'b111;
always @ (negedge clk)
    begin
        
        if (cnt === constantNum - 1'b1)begin
            clk1_2_16 <= 1'b1;
            cnt <= 3'd0;
        end 
        else begin
            clk1_2_16 <= 1'b0;
            cnt <= cnt + 1'b1;            
        end 
    end

endmodule