% Example 5.7 and Figure 5.11  Construct a spectum for white noise passed through
%   a FIR derivative filter 
% Compare classical, model-based and eigenvector methods
%
% The initial code is the same as Ex 4-6
close all; clear all;
fs = 200;					    % Sampling freqeuncy
N = 512;                        % Data length
fc = 0.4;						% Derivative cutoff frequency
N1 = 28;                        % Filter length
x = randn(N,1);                 % Generate white noise
%
% Design filter and plot magnitude charactoristics
f1 = [ 0 fc fc+.01 1];          % Construct desired frequency characteristic
G = [0 1 0 0];                  % Upward slope until 0.4 fs then lowpass
b = fir2(N,f1,G);               % Design filter
subplot(2,2,1);
PS = abs(fft(b,N)).^2;          % Calculate filter PS
f = (1:N/2)*N/(2*fs);           % Calculate frequency vector for plotting
plot(f,PS(1:N/2),'k');          % Plot filter frequency response
text(50,max(PS),'Actual Spectrum','FontSize',12);
xlabel('Frequency (Hz)','FontSize',12);
ylabel('PS ','FontSize',12);
data = filter(b,1,x);           % Apply FIR filter
%
subplot(2,2,2);                 % Classical method (Welch)
[PS,f] = pwelch(data,N/8,(N/8)-1,[],fs);  % Use 99% overlap
plot(f,PS,'k');			
text(50,max(PS),'Welch','FontSize',12);
xlabel('Frequency (Hz)','FontSize',12');
ylabel('PS','FontSize',12);
%
subplot(2,2,3);                 % Model-based (AR - Mod. Covariance)
[PS,f] = pmcov(data,9,N,fs);
plot(f,PS,'k');				
text(50,max(PS),'Mod Covariance p = 9','FontSize',12);
xlabel('Frequency (Hz)','FontSize',12);
ylabel('PS','FontSize',12);
%
subplot(2,2,4);                 % Eigenvector method (Music)
[PS,f] = pmusic(data,9,N,fs);
plot(f,PS,'k');				
text(50, max(PS),'MUSIC Method SS = 9','FontSize',12);
xlabel('Frequency (Hz)','FontSize',12);
ylabel('PS','FontSize',12);
%