% Example 3.5 Application of several window functions
%  
clear all; close all;
fs = 1000;              	% Sampling freq assumed by sig_noise
N = 128;
x = sig_noise([235 250],-3,N);    % Generate data 
f = (0:N-1)*fs/N;     		% Frequency vector
%
X_mag = abs(fft(x));		% Mag. spect: rect. (no) window
subplot(3,1,1);
plot(f(1:N/2),X_mag(1:N/2),'k');  % Plot magnitude
xlabel('Frequency (Hz)','FontSize',14); % Lables
ylabel('X(f)','FontSize',14); % Lables
title('Rectangular','FontSize',14); % Title
%
x1 = x .* hamming(N)';		% Apply Hamming window (Eq. 2.26)
X_mag = abs(fft(x1));		% Mag. spect: Hamming window
subplot(3,1,2);
plot(f(1:N/2),X_mag(1:N/2),'k');  % Plot magnitude
xlabel('Frequency (Hz)','FontSize',14); % Lables
ylabel('X(f)','FontSize',14); % Lables
title('Hamming','FontSize',14); % Title
%
x1 = x .* blackmanharris(N)';     % Apply Blackman-Harris (Eq. 2.27)
X_mag = abs(fft(x1));		% Mag. spect: Blackman-Harris window
subplot(3,1,3);
plot(f(1:N/2),X_mag(1:N/2),'k'); % Plot magnitude 
xlabel('Frequency (Hz)','FontSize',14); % Lables
ylabel('X(f)','FontSize',14); % Lables
title('Blackman-Harris','FontSize',14); % Title

