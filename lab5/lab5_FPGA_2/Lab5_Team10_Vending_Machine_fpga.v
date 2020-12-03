`timescale 1ns / 1ps

module Lab5_Team10_Vending_Machine_fpga(
    input wire left,
    input wire right,
    input wire ctr,
    input wire top,
    input wire bot,
    inout wire PS2_DATA,
    inout wire PS2_CLK,
    input wire clk,
    output reg [3:0] led,
    output wire [6:0] display,
    output wire [3:0] digit,
    output reg [1:0] state,
    output reg [3:0] drink_code
  );

  parameter [8:0] KEY_CODES [0:3] = {
              9'b0_0001_1100,	// a => 1C
              9'b0_0001_1011,	// s => 1B
              9'b0_0010_0011,	// d => 23
              9'b0_0010_1011	// f => 2B
            };

  parameter INIT = 2'b00;
  parameter INSERT = 2'b01;
  parameter BUYING = 2'b10;
  parameter REFUND = 2'b11;

  reg [17:0] clk_18, delay;
  reg [25:0] cnt, nxt_cnt;
  reg [7:0] num, nxt_num;
  reg [6:0] coin;
  reg [3:0] buy;
  reg [9:0] last_key;
  reg [1:0] nxt_state;
  reg into_refund, into_buy;

  wire [511:0] key_down;
  wire [8:0] last_change;
  wire been_ready, top_db, bot_db, ctr_db, left_db, right_db;

  always @ (posedge clk)
  begin
    clk_18 <= clk_18 + 18'd1;
  end

  always @ (posedge clk)
  begin
    if(into_buy == 1'b0)
      delay <= 18'd0;
    else
      delay <= delay + 1'b1;
  end

  always @ (posedge clk, posedge top_sign)
  begin
    if (top_sign == 1'b1)
      cnt <= 26'd0;
    else
      cnt <= nxt_cnt;
  end

  debounce db1 (
             .button(top),
             .clk(clk_18[17]),
             .button_debounced(top_db)
           );

  debounce db2 (
             .button(bot),
             .clk(clk_18[17]),
             .button_debounced(bot_db)
           );

  debounce db3 (
             .button(left),
             .clk(clk_18[17]),
             .button_debounced(left_db)
           );

  debounce db4 (
             .button(ctr),
             .clk(clk_18[17]),
             .button_debounced(ctr_db)
           );


  debounce db5 (
             .button(right),
             .clk(clk_18[17]),
             .button_debounced(right_db)
           );

  OnePulse op1 (
             .signal_single_pulse(top_sign),
             .signal(top_db),
             .clock(clk_18[17])
           );

  OnePulse op2 (
             .signal_single_pulse(bot_sign),
             .signal(bot_db),
             .clock(clk_18[17])
           );

  OnePulse op3 (
             .signal_single_pulse(left_sign),
             .signal(left_db),
             .clock(clk_18[17])
           );

  OnePulse op4 (
             .signal_single_pulse(right_sign),
             .signal(right_db),
             .clock(clk_18[17])
           );

  OnePulse op5 (
             .signal_single_pulse(ctr_sign),
             .signal(ctr_db),
             .clock(clk_18[17])
           );

  SevenSegment seven_seg (
                 .display(display),
                 .digit(digit),
                 .nums(num),
                 .rst(top_sign),
                 .clk(clk)
               );

  KeyboardDecoder key_de (
                    .key_down(key_down),
                    .last_change(last_change),
                    .key_valid(been_ready),
                    .PS2_DATA(PS2_DATA),
                    .PS2_CLK(PS2_CLK),
                    .rst(top_sign),
                    .clk(clk)
                  );

  always @ (posedge clk_18[17], posedge top_sign)
  begin
    if(top_sign == 1'b1)
    begin
      state <= INIT;
      num <= 8'b0000_0000;
    end
    else
    begin
      state <= nxt_state;
      num <= nxt_num;
    end
  end

  always @ (*)
  begin
    if(state == INSERT)
    begin
      if(left_sign == 1'b1)
        coin = 6'd5;
      else
      begin
        if(ctr_sign == 1'b1)
          coin = 6'd10;
        else
        begin
          if(right_sign == 1'b1)
            coin = 6'd50;
          else
            coin = 6'd0;
        end
      end
    end
    else
      coin = 6'd0;
  end

  always @ (*)
  begin
    if(num[7:4] < 4'd6)
    begin
      if(num[7:4] < 4'd3)
      begin
        if(num[7:4] == 4'd2)
        begin
          if(num[3:0] < 4'd5)
            led = 4'b0001;
          else
            led = 4'b0011;
        end
        else
          led = 4'b0000;
      end
      else
        led = 4'b0111;
    end
    else
      led = 4'b1111;
  end

  always @ (*)
  begin
    if(state == INSERT)
    begin
      if(delay == 18'd0)
      begin
        if(been_ready == 1'b1 && key_down[last_change] == 1'b1)
        begin
          buy = drink_code & led;
          if(buy == 4'b0000)
            into_buy = 1'b0;
          else
            into_buy = 1'b1;
        end
        else
          into_buy = 1'b0;
      end
      else
        into_buy = 1'b1;
    end
    else
      into_buy = 1'b0;
  end

  always @ (*)
  begin
    case (state)
      INIT:
      begin
        nxt_state = INSERT;
        nxt_num = num;
        into_refund = 1'b0;
        nxt_cnt = 26'd1;
      end
      INSERT:
      begin
        nxt_num = num;
        if(into_buy == 1'b1)
        begin
          nxt_state = BUYING;
        end
        else
        begin
          if(bot_sign == 1'b1)
            nxt_state = REFUND;
          else
          begin
            nxt_state = INSERT;
            case(coin)
              6'd0:
                nxt_num = num;
              6'd5:
              begin
                if(num == 8'b1001_0101)
                  nxt_num = 8'b1001_1001;
                else
                begin
                  if(num[3:0] == 4'd5)
                  begin
                    nxt_num[3:0] = 4'd0;
                    nxt_num[7:4] = num[7:4] + 4'd1;
                  end
                  else if(num[3:0] == 4'd0)
                    nxt_num[3:0] = 4'd5;
                  else
                    nxt_num = 8'b1001_1001;
                end
              end
              6'd10:
              begin
                if(num[7:4] == 4'd9)
                  nxt_num = 8'b1001_1001;
                else
                  nxt_num[7:4] = num[7:4] + 4'd1;
              end
              6'd50:
              begin
                if(num[7:4] < 4'd5)
                  nxt_num[7:4] = num[7:4] + 4'd5;
                else
                  nxt_num = 8'b1001_1001;
              end
              default:
                nxt_num = 8'b0001_0001;
            endcase
          end
        end
      end
      BUYING:
      begin
        nxt_state = REFUND;
        case(buy)
          4'b1000:
            nxt_num[7:4] = num[7:4] - 4'd6;
          4'b0100:
            nxt_num[7:4] = num[7:4] - 4'd3;
          4'b0001:
            nxt_num[7:4] = num[7:4] - 4'd2;
          4'b0010:
          begin
            if(num[3:0] < 4'd5)
            begin
              nxt_num[7:4] = num[7:4] - 4'd3;
              nxt_num[3:0] = 4'd5;
            end
            else
            begin
              nxt_num[7:4] = num[7:4] - 4'd2;
              nxt_num[3:0] = num[3:0] - 4'd5;
            end
          end
          default:
            nxt_num = num;
        endcase
      end
      REFUND:
      begin
        if(into_refund == 1'b0)
        begin
          nxt_cnt = 26'd1;
          into_refund = 1'b1;
        end
        else
        begin
          nxt_cnt = cnt + 1'b1;
        end
        if(num == 8'b0000_0000)
        begin
          nxt_state = INIT;
          nxt_num = num;
        end
        else
        begin
          nxt_state = REFUND;
          if(cnt == 26'd0)
          begin
            nxt_num[7:4] = num[7:4];
            if(num[3:0] == 4'd5)
              nxt_num[3:0] = 4'd0;
            else if(num[3:0] == 4'd9)
              nxt_num[3:0] = 4'd4;
            else if(num[3:0] == 4'd4)
            begin
              if(num[7:4] == 4'd0)
              begin
                nxt_num[7:4] = num[7:4];
                nxt_num[3:0] =  4'd0;
              end
              else
              begin
                nxt_num[7:4] = num[7:4] - 4'd1;
                nxt_num[3:0] =  4'd9;
              end
            end
            else
            begin
              nxt_num[7:4] = num[7:4] - 4'd1;
              nxt_num[3:0] =  4'd5;
            end
          end
          else
            nxt_num = num;
        end
      end
      default:
      begin
        nxt_state = INIT;
        nxt_num = 8'b0000_0000;
        into_refund = 1'b0;
      end
    endcase
  end

  always @ (*)
  begin
    case (last_change)
      KEY_CODES[00] :
        drink_code = 4'b1000;
      KEY_CODES[01] :
        drink_code = 4'b0100;
      KEY_CODES[02] :
        drink_code = 4'b0010;
      KEY_CODES[03] :
        drink_code = 4'b0001;
      default		  :
        drink_code = 4'b0000;
    endcase
  end

endmodule

module debounce(
    input wire button,
    input wire clk,
    output wire button_debounced
  );

  reg [3:0] dff;

  always @(posedge clk)
  begin
    dff[3:1] <= dff[2:0];
    dff[0] <= button;
  end

  assign button_debounced = ((dff == 4'b1111) ? 1'b1 : 1'b0);

endmodule
