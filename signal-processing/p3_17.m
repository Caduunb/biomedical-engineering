% Exercício 3.17
clearvars; close all; clc;

load SemmlowFiles\'Chapter 3'\short.mat

x = x';
plot(x); hold on;
%% Fourier
xfourier = fft(x);
xpadfourier = fft(x, 256);

mag_xfourier = abs(xfourier);
phase_xfourier = rad2deg(angle(xfourier));

mag_xpadfourier = abs(xpadfourier);
phase_xpadfourier = rad2deg(angle(xpadfourier));
%% Plot
figure(1)
subplot(2,1,1);    hold on;
title('Freq x Mag');
plot(mag_xfourier);

subplot(2,1,2);    hold on;
title('Freq x Phase');
plot(phase_xfourier);

figure(2);
subplot(2,1,1);    hold on;
title('Freq x Mag');
plot(mag_xpadfourier);

subplot(2,1,2);    hold on;
title('Freq x Phase');
plot(phase_xpadfourier);