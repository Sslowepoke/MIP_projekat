%% Zadatak2
%ucitavanje merenja
clear; close all; clc;

Ts = 0.01;
fs = 1/Ts;

load('prbs_a1_kraci.mat')
ut = out.simout(1:50001,1);
yt = out.simout(1:50001,2);
up = out.simout(1:50001,3);
yp = out.simout(1:50001,4);
t_sim = out.tout(1:50001);

figure
plot(t_sim, yt);
hold on
plot(t_sim, ut);
hold off
title('celo merenje')

%% 
% da li cemo uopste da ukljucujemo transportno kasnjenje, jer je mnogo
% malo?

