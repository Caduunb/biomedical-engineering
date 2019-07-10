% Exercício 3.29 - appying Hamming window to White Gaussian Noise using
% pwelch(X, WINDOW, NOVERLAP) routine 
% Please, note that running this script requires a custom function named
% add_awgn_noise(x, SNR). 

clearvars; close all; clc;

fs = 1e3;
N = 512;
t = (0:N-1)/fs;
f = [280 300];
freq_vec = 0:fs/N:fs/2;

% Generate Signal
x = sin(2*pi*f(1)*t) + sin(2*pi*f(1)*t);

% Generate White Noise with SNR
SNR     = -10;                      % signal-noise ration in dB
SNR     = 10^(SNR/10);              % SNR to linear scale
Esym    = sum(abs(x).^2)/(N);       % Calculate actual symbol energy
var     = Esym/SNR;                 % Find the noise spectral density
sigma   = sqrt(var);                % variance equals 4
gaussiannoise = sigma*randn(N, 1);

% Generate signal with added noise
x = x + gaussiannoise;

%% Creating windows
WINDOW_LENGTH = 512;
windowrect      = ones(WINDOW_LENGTH, 1);
windowblack     = blackmanharris(WINDOW_LENGTH);
windowhamm      = hamming(WINDOW_LENGTH);
%% Fourier D. Transform
% overlap 50 percent windowing Power Spectrum
xrectPS  = pwelch(x, windowrect);
xblackPS = pwelch(x, windowblack);
xhammPS  = pwelch(x, windowhamm);

%% plotting transformed signals
poi = length(freq_vec);
figure(1); hold on;
subplot(3,1,1);
plot(freq_vec, xrectPS(1:poi), 'LineWidth', 2);
legend({'Rectangle'}, 'FontSize', 15)
ylabel('Magnitude (|x(f)|)')
xlabel('Frequency (Hz)')

subplot(3,1,2);
plot(freq_vec, xhammPS(1:poi), 'LineWidth', 2);
legend({'Hamming'}, 'FontSize', 15)
ylabel('Magnitude (|x(f)|)')
xlabel('Frequency (Hz)')

subplot(3,1,3);
plot(freq_vec, xblackPS(1:poi), 'LineWidth', 2);
legend({'Blackman-Harris'}, 'FontSize', 15)
ylabel('Magnitude (|x(f)|)')
xlabel('Frequency (Hz)')

sgtitle('Discrete Fourier Magnitude Spectrum')
