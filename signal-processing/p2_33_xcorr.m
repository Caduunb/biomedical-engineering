% Cross correlation between a signal and a 50Hz sine wave
clear all; close all;
load SemmlowFiles\'Chapter 2'\prob2_33_data.mat;
signal = x;
clear x;
fs = 500;
Ts = 1/fs;
f = 50;
t = (0:length(signal) - 1)*Ts;
x = sin(2*pi*f*t);
%%
subplot(3,1,1);
    plot(t, signal, 'r');
    xlabel('time (s)');
    grid on;
    title('Imported signal');
    xlabel('Time (s)');
    ylabel('Signal y(t)');
subplot(3,1,2);
    grid on;
    plot(t, x, '-.b');
    title ('sin 50Hz');
    xlabel('Time (s)');
    ylabel('Signal x(t)');
%%
% Pearson's correlation coeficient
[rxy, lags] = xcorr(x,signal, 'coeff');
%N = length(signal); 
%den = (N - 1)*sqrt((var(x)*var(signal)));
%rxy = rxy/(den);

% Finding the max correlation point
[max_corr, max_shift_index] = max(rxy);
lags_normal = lags*Ts; %normalizing lags vector
max_shift = lags(max_shift_index)*Ts;

% Plotting the correlation graph
subplot(3,1,3);
    hold on;
    grid on;
    plot(lags_normal, rxy, '-b');
    plot(max_shift_normal, max_corr, 'ok');
    title ('Max correlation: 0.3052 ; Delay: -0.448s');
    xlabel('Lags (s)');
    ylabel('rxy');