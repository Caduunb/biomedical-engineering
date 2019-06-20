% Exercício 3.29
% Please, note that running this script requires a custom function named
% add_awgn_noise(x, SNR). 

clearvars; close all; clc;

fs = 1e3;
N = 64;
t = (0:N-1)/fs;
f = [200 300];
freq_vec = 0:fs/N:fs/2;
x = sin(2*pi*f(1)*t) + sin(2*pi*f(1)*t);
x = add_awgn_noise(x, -4);          % function used

%% Creating windows
WINDOW_LENGTH = 64;
rectwindow = ones(WINDOW_LENGTH, 1);
hammingwindow = hamming(WINDOW_LENGTH);
blackwindow   = blackmanharris(WINDOW_LENGTH);
figure(1)
hold on;
plot(rectwindow);
plot(hammingwindow);
plot(blackwindow);
legend({'Rectangle', 'Hamming', 'Blackman-Harris'}, 'FontSize', 15)
sgtitle('Windows used')

%% Fourier D. Transform
xrect = x'.*rectwindow;
xhamm = x'.*hammingwindow;
xblack = x'.*blackwindow;

xrect = fft(xrect);
xrectmag = abs(xrect);
xhamm = fft(xhamm);
xhammmag = abs(xhamm);
xblack = fft(xblack);
xblackmag = abs(xblack);

poi = length(freq_vec);
figure(2); hold on;
subplot(3,1,1);
plot(freq_vec, xrectmag(1:poi), 'LineWidth', 2);
legend({'Rectangle'}, 'FontSize', 15)
ylabel('Magnitude (|x(f)|)')
xlabel('Frequency (Hz)')

subplot(3,1,2);
plot(freq_vec, xhammmag(1:poi), 'LineWidth', 2);
legend({'Hamming'}, 'FontSize', 15)
ylabel('Magnitude (|x(f)|)')
xlabel('Frequency (Hz)')

subplot(3,1,3);
plot(freq_vec, xblackmag(1:poi), 'LineWidth', 2);
legend({'Blackman-Harris'}, 'FontSize', 15)
ylabel('Magnitude (|x(f)|)')
xlabel('Frequency (Hz)')

sgtitle('Discrete Fourier Magnitude Spectrum')
