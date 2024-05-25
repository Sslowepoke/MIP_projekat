clear
close all
clc

Ts = 9;  % stavite neko svoje
D = 450;  % duration
amp = 1;  % amplituda
u = idinput(D/Ts,'prbs',[0 1],[-amp amp]);
data = iddata([],u,Ts);

figure
plot(data)