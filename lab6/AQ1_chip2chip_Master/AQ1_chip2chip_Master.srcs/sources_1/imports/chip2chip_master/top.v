`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NTHU
// Engineer: Bob Cheng
//
// Create Date: 2019/08/25 12:47:53
// Module Name: top
// Project Name: Chip2Chip
// Additional Comments: top module for master, pass signals and perform debounce onepulse
//
//////////////////////////////////////////////////////////////////////////////////
module debounce (pb_debounced, pb, clk);
	output pb_debounced; // signal of a pushbutton after being debounced
	input pb; // signal from a pushbutton
	input clk;

	reg [3:0] DFF;
	always @(posedge clk)begin
		DFF[3:1] <= DFF[2:0];
		DFF[0] <= pb;
	end
	assign pb_debounced = ((DFF == 4'b1111) ? 1'b1 : 1'b0);
endmodule

module onepulse (pb_debounced, clock, pb_one_pulse);
	input pb_debounced;
	input clock;
	output reg pb_one_pulse;
	reg pb_debounced_delay;
	always @(posedge clock) begin
		pb_one_pulse <= pb_debounced & (! pb_debounced_delay);
		pb_debounced_delay <= pb_debounced;
	end
endmodule

module top(clk, rst_n, in, request, notice_master,
 data_to_slave_o, valid, request2s, ack, seven_seg, AN,
 req_signal, reset_signal, state);
    input clk;
    input rst_n;
    input [8-1:0] in;
    input request;
    input ack;
    output [3-1:0] data_to_slave_o;
    output notice_master;
    output valid;
    output request2s;
    output [7-1:0] seven_seg;
    output [4-1:0] AN;
// ------ self I/O
    output [3-1:0] data;
    output wire req_signal;
    output wire reset_signal;
    output wire [3-1:0] state;
// ------   

    wire db_request;
    wire op_request;
    wire [3-1:0] data_to_slave;
    wire rst_n_inv;
    wire [8-1:0]slave_data_dec;
    wire db_rst_n, op_rst_n;
	wire [8-1:0]data_to_slave_dec;
    assign rst_n_inv = ~op_rst_n;
    assign AN = 4'b1110;
	assign data_to_slave_o = data_to_slave;
    // -----self I/O
    assign req_signal = request;
    assign reset_signal = rst_n;

    encoder enc0(.in(in), .out(data_to_slave)); // turn the switch part into 3bit wire
    // button part
    debounce db_0(.pb_debounced(db_request), .pb(request), .clk(clk));
    onepulse op_0(.pb_debounced(db_request), .clock(clk), .pb_one_pulse(op_request));
    debounce db_1(.pb_debounced(db_rst_n), .pb(rst_n), .clk(clk));
    onepulse op_1(.pb_debounced(db_rst_n), .clock(clk), .pb_one_pulse(op_rst_n));
    // control part
    master_control ms_ctrl_0(.clk(clk), .rst_n(rst_n_inv), .request(op_request), // send
     .ack(ack), .data_in(data_to_slave), .notice(notice_master), .data(data),
      .valid(valid), .request2s(request2s), .state(state));
    
	// seven_segment part
    decoder dec0(.in(data_to_slave), .out(data_to_slave_dec)); // turn the 3bit data_to_slave  to decoded 7bit
    seven_segment dis_0(.in(data_to_slave_dec), .out(seven_seg)); // display number


endmodule
