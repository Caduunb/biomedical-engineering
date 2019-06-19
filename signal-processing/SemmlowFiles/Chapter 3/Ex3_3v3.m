% Example 3.3  Determine the magnitude and phase spectrum of a noisy 
%       waveform
% First generates a waveform consisting of a single sine in noise,
%     then calculates the magnitude and phase spectum from the FFT and plot  
clear all; close all;
N = 1024;               % Data length
N2 = 511;               % Valid spectral points
fs = 1000;              % Sample frequency (assumed by sig_noise)
[x,t] = sig_noise(250,-7,N); % Get data (250 Hz sin plus white noise) 
X = fft(x);		        % Calculate FFT
X_mag = abs(X);  	        % Compute magnitude spectrum
Phase = unwrap(angle(X));  % Phase spectrum unwraped
Phase = Phase*360/(2*pi);  % Convert phase to deg
f = (0:N-1)*fs/N;         % Frequency vector
subplot(2,1,1);
plot(f(1:N2),X_mag(1:N2),'k');      % Plot magnitude spectrum
title('Magnitude Spectrum','FontSize',12);
xlabel('Frequency (Hz)','FontSize',14);
ylabel('|X(f)','FontSize',14);
subplot(2,1,2);
plot(f(1:N2),Phase(1:N2),'k');      % Plot phase spectrum
title('Phase Spectrum ','FontSize',12);
xlabel('Frequency (Hz)','FontSize',14);
ylabel('Phase (deg)','FontSize',14);