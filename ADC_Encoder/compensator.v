`timescale 1ns/1ns
module compensator(clk,reset,e_n_input,d_n_output);
input       clk,reset;
input    [3:0]  e_n_input;
output    [8:0]  d_n_output;

reg [3:0] e_n,e_n_1,e_n_2;
reg [15:0] ae_product,be_product,ce_product,d_n_reg,d_n_1;
wire [15:0] d_n_pre;
wire [3:0] e_n_input;

//delay blocks
always@(posedge clk or posedge reset)
begin
  if(reset)
  begin
    e_n <= 4'b0;
    e_n_1 <=4'b0;
    e_n_2 <= 4'b0;
    d_n_1 <=16'b0;
  end
  else
  begin
    e_n <= e_n_input;
    e_n_1 <= e_n;
    e_n_2 <= e_n_1;
    d_n_1 <= d_n_pre;
  end
end

//adder
assign d_n_pre = ae_product +be_product + ce_product +d_n_1;

//TableA
always@(e_n)
begin
  case(e_n)
    4'b1100:
    ae_product=16'b1101101000010100;
    4'b1101:
    ae_product=16'b1110001110001111;
    4'b1110:
    ae_product=16'b1110110100001010;
    4'b1111:
    ae_product=16'b1111011010000101;
    4'b0000:
    ae_product=16'b0000000000000000;
    4'b0001:
    ae_product=16'b0000100101111011;
    4'b0010:
    ae_product=16'b0001001011110110;
    4'b0011:
    ae_product=16'b0001110001110001;
    4'b0100:
    ae_product=16'b0010010111101100;

    default:ae_product=16'd0;
  endcase
end

//TableB
always@(e_n_1)
begin
  case(e_n_1)
   4'b1100: 
  be_product=16'b0100100010010100;
  4'b1101: 
  be_product=16'b0011011001101111;
  4'b1110:
  be_product=16'b0010010001001010;
  4'b1111:  
  be_product=16'b0001001000100101;
  4'b0000: 
  be_product=16'b0000000000000000;
  4'b0001:
  be_product=16'b1110110111011011;
  4'b0010: 
  be_product=16'b1101101110110110;
  4'b0011: 
  be_product=16'b1100100110010001;
  4'b0100: 
  be_product=16'b1011011101101100;

  default:be_product=16'd0;
  endcase
end

//Table C
always@(e_n_2)
begin
  case(e_n_2)
  4'b1100: 
  ce_product=16'b1101110100110100;
  4'b1101:   
  ce_product=16'b1110010111100111;
  4'b1110:
  ce_product=16'b1110111010011010;
  4'b1111:  
  ce_product=16'b1111011101001101;
  4'b0000:  
  ce_product=16'b0000000000000000;
  4'b0001:
  ce_product=16'b0000100010110011;
  4'b0010:
  ce_product=16'b0001000101100110;
  4'b0011:
  ce_product=16'b0001101000011001;
  4'b0100:
  ce_product=16'b0010001011001100;
  
  default:ce_product=16'd0;
  endcase
end

//limiter
always@(d_n_pre)
begin
  if(d_n_pre[15]==1)
    d_n_reg = 16'b0;
  else if(d_n_pre>16'b0111100110011001)
    d_n_reg = 16'b0111100110011001;
  else
    d_n_reg = d_n_pre;
end

//Truncation
assign d_n_output = d_n_reg[14:6];

endmodule