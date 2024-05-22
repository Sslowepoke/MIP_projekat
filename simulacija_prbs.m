%% parametri prbs
clear; close all; clc;
load('T_est.mat') %T_est

Fmax = 1/(T_est*2*pi);
Fmin = Fmax/3;

Ts_prbs = 2*pi/5/Fmax;
Order = floor(log(2*pi/Ts_prbs/Fmin) / log(2));

input = frest.PRBS('Order', Order, 'NumPeriods', 1, ...
    'Amplitude' , 0.5, 'Ts', Ts_prbs);
data = generateTimeseries(input);
prbs_pobuda = [data.Time + 200, data.Data];

%% simulacija
tsim = 400; %[s] - trajanje simulacije

up_nominalna = 2;
ut_nominalna = 5;

t_step_v = 200;
t_step_t = 0;

uv_1 = 0;
uv_2 = 3;
ut_1 = 0;
ut_2 = 1;

prbs_flag = 1;

out = sim('model_moj.slx', tsim);

Ts = 0.01; %[s] - perioda odabiranja unutar simulacije
N = tsim/Ts+1; % broj odbiraka signala

save('prbs_merenja.m', 'out')