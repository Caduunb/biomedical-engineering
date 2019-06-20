% Exercício 3.23 - filtered gaussian noise
clearvars; close all; clc

load ('p2_36data.mat')

fs = 200;                   % sampling frequency 
N = 512;                    % points
freq_vec = 0:(fs/N):fs/2;   % frequency vector
%% Power Spectrum
gauss_noisefft = gauss_noise/N;         % normalization
gauss_noisefft = fft(gauss_noise);      % normalized DTFT
amplit_gauss = 2*abs(gauss_noisefft);   % magnitude times 2
DCgauss = amplit_gauss(1)/2;            % DC value (doesn't need to be doubled)
amplit_gauss(1) = DCgauss;              % Corrected DC value
psgauss = amplit_gauss.^2;              % Power Spectrum = Mag^2

signal = filter_noise;
signalfft = fft(signal);
amplit_signal = abs(signalfft);
signalfft(1) = signalfft(1)/N;
amplit_signal = (2/N)*amplit_signal(2:length(amplit_signal));
pssignal = amplit_signal.^2;


%% Plot
figure(1);
plot(freq_vec, pssignal(1:257), 'LineWidth', 2);
title('Filtered noise')
ylabel('Power Spectrum')
figure(2);
plot(freq_vec, psgauss(1:257), 'g', 'LineWidth', 2);
title('Gaussian noise')
ylabel('Power Spectrum')