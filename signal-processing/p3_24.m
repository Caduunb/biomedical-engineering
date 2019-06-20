% Exercício 3.24 - Welch application
clearvars; close all; clc

load ('p2_36data.mat')

fs = 200;                   % sampling frequency 
N  = 512;                   % points
freq_vec = 0:(fs/N):fs/2;   % frequency vector
%% Power Spectrum
[gaussPS_avg32,freq_vector32]  = pwelch(gauss_noise,32);
[gaussPS_avg256,freq_vector256] = pwelch(gauss_noise,256);
[filteredPS_avg32,freq_vector32]  = pwelch(filter_noise,32);
[filteredPS_avg256,freq_vector256] = pwelch(filter_noise,256);

%% Plot
% Raw gaussian data
figure(1); hold on;
sgtitle('Raw Gaussian Noise');
subplot(2,1,1);
plot(freq_vector32, gaussPS_avg32,'b', 'LineWidth', 2);
legend('32-point Welch Transform', 'FontSize', 12);
subplot(2,1,2);
plot(freq_vector256, gaussPS_avg256,'m', 'LineWidth', 2);
legend({'256-point Welch Transform'}, 'FontSize', 12)

% Filtered Gaussian Noise
figure(2); hold on;
sgtitle('Filtered Gaussian Noise');
subplot(2,1,1);
plot(freq_vector32,filteredPS_avg32,'b', 'LineWidth', 2);
legend('32-point Welch Transform', 'FontSize', 12)
subplot(2,1,2);
plot(freq_vector256,filteredPS_avg256,'m', 'LineWidth', 2);
legend('256-point Welch Transform', 'FontSize', 12)
