%% simulacija
clear; close all; clc;

tsim = 500; %[s] - trajanje simulacije

up_nominalna = 2;
ut_nominalna = 5;

t_step_v = 300;
t_step_t = 100;

uv_1 = 0;
uv_2 = 3;
ut_1 = 0;
ut_2 = 0.1*ut_nominalna;

prbs_flag = 0;
prbs_pobuda = 0;

out = sim('model_moj.slx', tsim);

Ts = 0.01; %[s] - perioda odabiranja unutar simulacije
N = tsim/Ts+1; % broj odbiraka signala

save('step_merenja.m', 'out');