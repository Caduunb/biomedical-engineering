% Determine heart beat's autocorrelation during meditation
clear all; close all;
load SemmlowFiles\'Chapter 2'\Hr_med.mat
signal = hr_med;
t = t_med;
clear hr_med t_med;
%%
[cxx, lags] = xcorr(signal - mean(signal), 'coeff'); %autocovariance
subplot(2,1,1);
    plot(t, signal, 'g');
    xlabel('time (s)');
    grid on;
    title('Heart beat during meditation');
    xlabel('Time (s)');
    ylabel('Signal(t)');
subplot(2,1,2);
    grid on;
    plot(lags, cxx, '.k');
    title ('Autocovariance');
    xlabel('Time (s)');
    ylabel('Cxx');

%% Checking frequencies for the heart rate 
for i = 1:1000
    f(i) = 0.25*i;
    x_sin = sin(2*pi*f(i)*t);
    cxy = xcorr(x_sin, signal, 'coeff');
    cmax(i) = max(cxy); %maximum covariances array
end
%%
figure
plot (f, cmax, 'b');
title ('Maximum correlation (approx. 0.11) occurs at 57.25Hz')
xlabel('Frequency (Hz)');
ylabel('Maximum covariance');
hold on;
[cmaxmax, index] = max(cmax);
plot(f(index), cmaxmax, 'og');