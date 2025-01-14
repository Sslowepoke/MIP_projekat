%% Zadatak 1
% ucitavanje merenja
clear; close all; clc;

Ts = 0.01;
fs = 1/Ts;

load('merenja/step.mat')

% raspakivanje merenja
ut = out.simout(:,1);
up = out.simout(:,2);
yt = out.simout(:,3);
yp = out.simout(:,4);
t_sim = out.tout;

figure
plot(t_sim, yt/max(yt));
hold on
plot(t_sim, ut/max(ut));
hold off
title('celo merenje')
xline(100)
xline(200)
% doterati grafik
% plotujemo skalirano na (0,1) da bi se lepse videlo

%% samo onaj deo koji nam treba
% za estimaciju sistemom prvog reda, uzimamo deo kada se 
% ukljucila step pobuda, a poremecaja nema

y = yt(find(t_sim==100, 1, 'first'):find(t_sim==200, 1, 'first'));
u = ut(find(t_sim==100, 1, 'first'):find(t_sim==200, 1, 'first'));
t = 0:Ts:100;

figure
plot(t, y/max(y))
hold on
plot(t, u/max(u));
hold off
title('samo ono sto nam treba')
legend('y', 'u')
% plotujemo skalirano na (0,1) da bi se lepse videlo

%% kasnjenje
% vertikalna linija oznacava pocetak odziva, odnosno kasnjenje
y_start = mean(yt(t>=98 & t<=100));
start_ind = find(y>y_start*1.001, 1, 'first');
tau = t(start_ind) - t(1);
xline(tau)

%% filtriranje signala - pitanje da l je uopste bolje i da l je neophodno
% (nije neophodno)

% skidanje pocetne vrednosti
% y_0 = y(1);
% y = y - y_0;

% low pass filtar, frekvencija izabrana na oko, ispadne posle isto ko
% fs_new, sto se i slaze :)
% Hd = designfilt('lowpassfir','FilterOrder',20,'CutoffFrequency',0.2, ...
%        'DesignMethod','window','Window',{@kaiser,3},'SampleRate',fs);
% yf = filter(Hd,y);



% MA samo srednja vrednost 5 odbiraka
% b = [0.2 0.2 0.2 0.2 0.2];
% % b = [0.8 0.2];
% % yf = fftfilt(Num, yt1);
% yf = filter(b, 1, y);
% 
% figure;
% plot(t, y, 'b');
% hold all;
% plot(t, yf, 'r');
% hold off;
% title('filtriranje');

% y = yf;
%% G(s) = K/(T*s + 1) * e^(tau*s)

% modelujemo kao sistem prvog reda u delu do 15s, a posle toga cemo dodati
% integrator

t0 = 15;

y_0 = mean(y(t < tau));
y_end = mean(y(t > 10 & t < 15));
delta_y = y_end - y_0;
delta_u = ut(t_sim == 195) - ut(t_sim == 95);
K_est = delta_y/delta_u;


y90 = delta_y*0.9 + y_0;
y10 = delta_y*0.1 + y_0;
ind90 = find(y > y90, 1, 'first');
ind10 = find(y < y10, 1, 'last');
t_rise = t(ind90) - t(ind10);
T_est = t_rise/2.197; 

save('fopdt.mat', 'T_est', 'K_est', 'tau');

% G(s)
s = tf('s');
% model prvog reda
G = K_est/(s*T_est + 1)*exp(-tau*s);
% posto ovaj model lose opisuje nas sistem, mozemo mu dodati integrator

% a * delta_t = delta_y
% a - koeficijent integracije
y_start = y(t==t0);
y_end = y(end);
delta_y = y_end-y_start;
delta_t = t(end) - t0;
a = delta_y/delta_t;
G = G + a/s;

% resample-ovanje
Ts_new = round(T_est/10, 2);
fs_new = 1/Ts_new;
n = Ts_new/Ts;
% y = decimate(y, Ts_new/Ts, 5);
% u = decimate(u, Ts_new/Ts, 5);
% t = (1:length(u))*Ts_new;
yr = y(1:n:end);
ur = u(1:n:end);
tr = t(1:n:end);
% ovo resample-ovanje nam tehnicki nista ne znaci sada, ali morali smo
% svakako prvo da odredimo T_est da bi mogli da resample-ujemo :)
% znacice nam za arx


u_sim = delta_u * ones(length(ur), 1);
y_sim = lsim(G, u_sim', tr);

figure
plot(tr, yr-y_0)
hold on
plot(tr, y_sim)
hold off
title('estimacija funkcijom prenosa prvog reda')
yline(y_0-y_0)
yline(y_end-y_0)

%% ostaje jos da se odredi ekvivalentni ARX model prvog reda (LLS)













