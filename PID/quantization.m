close all;clear all;clc
%get the coefficients
format long
z= tf('z');
C=(9.458*z^2-18.1521496*z+8.704350893)/((z-1)*z);
%C=(9.4572*z^2-18.1521496*z+8.704350893)/((z-1)*z);
%C=9.4572*(z-0.9346)*(z-0.9848)/((z-1)*z);
%C = (9.5572*z^2-18.1421688*z+8.699564844)/((z-1)*z);
[Gcdnum,Gcdden] = tfdata(C,'v');

%Word-length selection
e_n_max = 4;
e_n_min = -4;
Nia = ceil(log2(1+abs(2*Gcdnum(1)*e_n_max)));
Nib = ceil(log2(1+abs(2*Gcdnum(2)*e_n_max)));
Nic = ceil(log2(1+abs(2*Gcdnum(3)*e_n_max)));
Nd = ceil(abs(log2(1/(Gcdnum(1)+Gcdnum(2)+Gcdnum(3)))));
Na = Nia+Nd+1;
Nb = Nib+Nd+1;
Nc = Nic+Nd+1;
Nbit = max([Na Nb Nc]);

%quantization
Vq = 1/64;
Da = dec2bin(round(abs(Gcdnum(1)*Vq)*(2^(Nbit))));
Aa = sign(Gcdnum(1))*bin2dec(Da)/(2^(Nbit));
aq=Aa/Vq;
Db = dec2bin(round(abs(Gcdnum(2)*Vq)*(2^(Nbit))));
Ab = sign(Gcdnum(2))*bin2dec(Db)/(2^(Nbit));
bq=Ab/Vq;
Dc = dec2bin(round(abs(Gcdnum(3)*Vq)*(2^(Nbit))));
Ac = sign(Gcdnum(3))*bin2dec(Dc)/(2^(Nbit));
cq=Ac/Vq;

%compute coeffifient of LUT
code = e_n_min:e_n_max;
ae_product=aq*code.*Vq*(2^(Nbit));
be_product=bq*code.*Vq*(2^(Nbit));
ce_product=cq*code.*Vq*(2^(Nbit));
a_table = num2bin(quantizer([Nbit+2,0]),ae_product)
b_table = num2bin(quantizer([Nbit+2,0]),be_product)
c_table = num2bin(quantizer([Nbit+2,0]),ce_product)

%limiter 0.95 change to binary numbe
duty_max=0.95;
kd=dec2bin(duty_max*(2^(Nbit+1)));
Ka = bin2dec(kd)/(2^(Nbit+1));
Kal=Ka*(2^(Nbit+1));
duty_bin = num2bin(quantizer([Nbit+2,0]),Kal)
