close all;clear all;clc
s = tf('s');

Vin =6;
L = 10*1e-6;
C=22*1e-6;
Rload = 1;% or1
RL = 0.068;
Rc = 0.02;
wo = 1/((L*C)^0.5);
wz = 1/(Rc*C);
Q = (1/wo) * (1/(L/(Rload+RL)+C*(Rc+RL*Rload/(RL+Rload))));
Gvd = Vin * (1+s/wz)/(1+s/(Q*wo)+(s/wo)^2);
Td = 495*10^-9;
Gvd_z=Gvd*(1-Td*s+((-Td*s)^2)/2+((-Td*s)^3)/6);
Gvd_z=Gvd*exp(-s*Td);
Hsense = 1;
VM = 3;
T = Hsense*(1/VM)*Gvd;
bode(T,{1,1e8});
grid on;

sisotool(Gvd_z);
