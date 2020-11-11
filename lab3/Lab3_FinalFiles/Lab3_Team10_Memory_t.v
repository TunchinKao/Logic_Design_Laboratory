`timescale 1ns / 1ps

module Memory_tb;
// clock;
reg CLK = 0;
// input
reg REN;
reg WEN;
reg [7:0]DIN;
reg [6:0]ADR;
reg [7:0]curANS;
// output
wire [7:0]DOUT;
// debug using
integer phase = 0;
reg [7:0]out_mem[127:0];
Memory testing_Memory(
    .clk(CLK),
    .ren(REN),
    .wen(WEN),
    .addr(ADR), 
    .din(DIN), 
    .dout(DOUT)
);

always #3 CLK = ~CLK;

initial begin
    {REN, WEN} = 2'b01;
    ADR = 7'b000000;
    DIN = $random;
    // write something into all memory
    repeat(2**7)begin
        @(posedge CLK)begin
            out_mem[ADR[6:0]] = DIN;
        end
        @(negedge CLK)begin
            DIN = $random;
            ADR = ADR + 1'b1;
        end
    end
    {REN, WEN} = 2'b00;
    #10
    {REN, WEN} = 2'b10;

    // random read something out;
    repeat(2**5)begin
        // I used to think can't task
        @(posedge CLK)begin
            curANS = out_mem[ADR];
        end
        @(negedge CLK)begin
            ADR = $random;
            DIN = 8'b00000000;
            testreadout;
        end
    end
    phase = phase + 1;
    // write and read
    {REN, WEN} = 2'b00;
    ADR = $random;
    repeat(2**7)begin
        @(posedge CLK)begin
            case({REN, WEN})
            2'b00:
            begin // nothing
                curANS <= 8'b00000000;
                out_mem[ADR] <= out_mem[ADR]; 
            end
            2'b01:
            begin // write
                curANS <= 8'b00000000;
                out_mem[ADR] <= DIN;
            end
            2'b10:
            begin // read
                curANS <= out_mem[ADR];
                out_mem[ADR] <= out_mem[ADR];
            end
            2'b11:
            begin // read
                curANS <= out_mem[ADR];
                out_mem[ADR] <= out_mem[ADR];
            end
            endcase 
            testreadout;
        end
        @(negedge CLK)begin
            {REN, WEN} = {REN, WEN} + 2'b01;
            ADR = $random;
            DIN = $random;
        end
    end
    $finish;
end
task testreadout;
begin
    if(DOUT != curANS)begin
        $display("ERROR!");
        $write("Phase: %d. Address at: %h ", phase, ADR);
        $write("DOUT: %h but it should be %h\n", DOUT, curANS);
    end
end
endtask
endmodule
