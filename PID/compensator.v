`timescale 1ns/1ns
module compensator(clk,reset,e_n_input,d_n_output);
input       clk,reset;
input    [3:0]  e_n_input;
output    [9:0]  d_n_output;

reg [3:0] e_n,e_n_1,e_n_2;
reg [14:0] ae_product,be_product,ce_product,d_n_reg,d_n_1;
wire [14:0] d_n_pre;
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
    ae_product=15'b111001010110000;
    4'b1101:
    ae_product=15'b111011000000100;
    4'b1110:
    ae_product=15'b111100101011000;
    4'b1111:
    ae_product=15'b111110010101100;
    4'b0000:
    ae_product=15'b000000000000000;
    4'b0001:
    ae_product=15'b000001101010100;
    4'b0010:
    ae_product=15'b000011010101000;
    4'b0011:
    ae_product=15'b000100111111100;
    4'b0100:
    ae_product=15'b000110101010000;

    default:ae_product=15'd0;
  endcase
end

//TableB
always@(e_n_1)
begin
  case(e_n_1)
   4'b1100: 
  be_product=15'b001100001001100;
  4'b1101: 
  be_product=15'b001001000111001;
  4'b1110:
  be_product=15'b000110000100110;
  4'b1111:  
  be_product=15'b000011000010011;
  4'b0000: 
  be_product=15'b000000000000000;
  4'b0001:
  be_product=15'b111100111101101;
  4'b0010: 
  be_product=15'b111001111011010;
  4'b0011: 
  be_product=15'b110110111000111;
  4'b0100: 
  be_product=15'b110011110110100;

  default:be_product=15'd0;
  endcase
end

//Table C
always@(e_n_2)
begin
  case(e_n_2)
  4'b1100: 
  ce_product=15'b111010011101000;
  4'b1101:   
  ce_product=15'b111011110101110;
  4'b1110:
  ce_product=15'b111101001110100;
  4'b1111:  
  ce_product=15'b111110100111010;
  4'b0000:  
  ce_product=15'b000000000000000;
  4'b0001:
  ce_product=15'b000001011000110;
  4'b0010:
  ce_product=15'b000010110001100;
  4'b0011:
  ce_product=15'b000100001010010;
  4'b0100:
  ce_product=15'b000101100011000;
  
  default:ce_product=15'd0;
  endcase
end

//limiter
always@(d_n_pre)
begin
  if(d_n_pre[14]==1)
    d_n_reg = 15'b0;
  else if(d_n_pre>15'b011110011001100)
    d_n_reg = 15'b011110011001100;
  else
    d_n_reg = d_n_pre;
end

//Truncation
assign d_n_output = d_n_reg[13:4];

endmodule