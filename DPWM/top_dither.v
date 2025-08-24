`timescale 1ns/1ns
`include "dither.v"
//`include "deadtime.v"
`include "counter.v"
//module top(clk,rst,ditherin,duty_high,duty_low);
module top(clk,rst,ditherin,duty);
input clk,rst;
input [8:0]ditherin;
output duty;
//output duty_high;
//output duty_low;
wire [5:0] d_n_input;
reg [5:0]clk2;
reg clk_in;

//除頻//
always@(posedge clk or posedge rst) begin
    if(rst) begin
        clk_in =0;
        clk2 = 6'b0;
    end

    else if (clk2 == 6'd31) begin
        clk_in = ~clk_in;
        clk2 = 6'd0;
    end
    else begin
        clk2 = clk2 +6'd1;
    end
end

dither_dpwm ditherdpwm(clk_in,rst,ditherin,d_n_input);
counter_dpwm counterdpwm(clk,rst,d_n_input,duty);
//counter_deadtime counterdeadtime(clk,rst,d_n_input,duty_high,duty_low);

endmodule
