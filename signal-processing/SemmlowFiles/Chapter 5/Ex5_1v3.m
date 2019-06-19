% Example 5_1 Using the Yule_Walker Equations to find the 
%   spectrum of sinusiods buried in noise includig a broad band signal
clear all; close all
N = 1024;           % Signal length
SNR = -12;          % SNR
fs = 1000;          % Sample frequency
p = 17;             % AR Model order
%
% Construct data
x = sig_noise([100 240 280 400],SNR,N);	% Generate data 
%
[rxx, lags] = xcorr(x,p,'biased');       % Autorcorrelation with p lags
rxx = rxx(p+1:end)';                     % Use positive lags only
Rxx = toeplitz(rxx(1:end-1));            % Const. autocorr matrix
a = -(Rxx\rxx(2:end));                   % Solve for a's
a = [1; a];                              % Add a[0]
H = var(x)./fft(a,1024);                 % Get spectrum from a's
subplot(2,1,1);
plot(abs(H(1:500)),'k'); 
xlabel('Frequency (Hz)','FontSize',14); ylabel('PS','FontSize',14);
title('Basic Equations','FontSize',14)
%          Compare with pyulear and plot
subplot(2,1,2); 
[PS,f] = pyulear(x,17,N,fs);  
plot(f,PS,'k');				% Plot PS 
xlabel('Frequency (Hz)','FontSize',14); ylabel('PS','FontSize',14);
title('pyulear','FontSize',14);

