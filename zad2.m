%% Zadatak2
%ucitavanje merenja
clear; close all; clc;

Ts = 0.01;
fs = 1/Ts;

% objasniti kako smo dosli do parametara prbs :)

prbs_amp = 1;
load('merenja/prbs_amp_1_with_poremecaj.mat')
load('fopdt.mat')

% raspakivanje merenja
ut = out.simout(:,1);
up = out.simout(:,2);
yt = out.simout(:,3);
yp = out.simout(:,4);
t_sim = out.tout;
t_start = 50;
t_disturbance = 200;

y = yt(t_sim > t_start);
u = ut(t_sim > t_start);
t = (1:length(u))*Ts;
% da ide oko 0
y = y - y(1);
u = u - u(1) - prbs_amp;


figure
plot(t, y);
hold on
% skaliramo u na izlaz
plot(t, u*K_est);
hold off
title('celo merenje')
xline(t_disturbance)
% doterati grafik


%% izbacivanje transportnog kasnjenja iz podataka
y = y(tau/Ts:end);
u = u(tau/Ts:end);
t = (1:length(u))*Ts;

%% LLS
y1 = y(1:find(t>t_disturbance, 1, 'first'));
u1 = u(1:find(t>t_disturbance, 1, 'first'));
t1 = (0:length(u1)-1)*Ts;
% regresioni vektor
Phi = [-y1(1:end-1) u1(1:end-1)];
Y = y1(2:end);


Teta = (Phi'*Phi)^(-1)*Phi'*Y;
a1 = Teta(1);
b1 = Teta(2);

% procena diskretnog pola
p_est = - a1; 
% procena pojacanja
K_est = b1/(1+a1);

sp_est = log(p_est)/Ts;

G_est = tf(-K_est * sp_est, [1 -sp_est]);

y_est = lsim(G_est, u1, t1);

figure
subplot(2,1,1)
plot(t1, u1);
grid on
subplot(2,1,2)
plot(t1, y1);
hold on
plot(t1, y_est, 'r--')
hold off
