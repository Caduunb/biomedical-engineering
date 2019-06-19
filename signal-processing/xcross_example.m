% Cross correlation example
clear all; close all;
Ts = 0.02; %time sample 0.2ms
t = (0:499)*Ts;
x = sin(2*pi*t);
y = cos(2*pi*t);
%%
subplot(2,1,1);
grid on;
plot(t, x, 'b'); hold on;
plot(t, y, '-.k');
legend ('sin 1Hz', 'cos 1Hz');
title('X and Y');

subplot(2,1,2);
grid on;
[rxy, lags] = xcorr(x,y);
plot(lags*Ts, rxy); %lags*Ts to match with the time on the original plots
title('Cross correlation between X and Y');
