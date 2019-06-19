% Exercício 3.24
clearvars; close all; clc

load ('p2_36data.mat')

fs = 200;                   % sampling frequency 
N = 512;                    % points
freq_vec = 0:(fs/N):fs/2;   % frequency vector
%% Power Spectrum
[PS_avg1,f1] = pwelch(gauss_noise,32);
[PS_avg2,f2] = pwelch(gauss_noise,256);

%% Plot
figure(1);
plot(f1,PS_avg1,'b', 'LineWidth', 2);
hold on;
plot(f2,PS_avg2,'m', 'LineWidth', 2);





