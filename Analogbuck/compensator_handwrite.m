close all;clear all;clc
s = tf('s');

Vin =6;
L = 10*1e-6;
C=22*1e-6;
Rload = 1;% or2
RL = 0.068;
Rc = 0.02;
wo = 1/((L*C)^0.5);
wz = 1/(Rc*C);
Q = (1/wo) * (1/(L/(Rload+RL)+C*(Rc+RL*Rload/(RL+Rload))));
Gvd = Vin * (1+s/wz)/(1+s/(Q*wo)+(s/wo)^2);
Hsense = 1.2;
VM = 3;
T = Hsense*(1/VM)*Gvd;
bode(T,{1,1e8});
hold on;
%%compensator%%
Wz1 = 6000*2*pi;%%2pi*fL
Wz2 = 8816*2*pi;%%2pi*fz
Wp1 = 283564*2*pi;%%2pi*fp
Wp2 = 361715*2*pi;%%2pi*fp2
gcm = 1.596;%%4.05824dB
comp = gcm *(1+Wz1/s)*(1+s/Wz2)/((1+s/Wp1)*(1+s/Wp2));%%transfer function
bode(comp,{1,1e8});
hold on;
%%closed loop%%
closeloop = comp * T;
bode(closeloop,{1,1e8});
grid on;
