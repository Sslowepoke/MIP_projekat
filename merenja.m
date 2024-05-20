close all; clc;

ut = out.simout(:,1);
yt = out.simout(:,2);
up = out.simout(:,3);
yp = out.simout(:,4);
t = out.tout(1:50001);



% plot(out.simout(:,1), out.tout);
% plot(out.simout(:,2), out.tout(1:5001));
figure(1)
title('temeperatura');
plot(t, ut);
hold all
plot(t, yt);
hold off
legend('ut', 'yt');
%% prbs

Td = 31.95; %s
Fmax = 1/(2*pi*Td);
Fmin = Fmax/10;
Ts = 2*pi/5/Fmax;
Order = floor(log(2*pi/Ts/Fmin)/log(2));


input = frest.PRBS('Order', Order, 'NumPeriods', 1, 'Amplitude' , 2, 'Ts', Ts);
data = generateTimeseries(input);
pobuda = [data.Time + 200 data.Data];


