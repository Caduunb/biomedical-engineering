% Example 3.7  Investigation of the influence of averaging to improve 
%   broadband spectral characteristics in the Power Spectrum.
%  Loads file broadband1 that contains broadband and narrowband signals 
%	and noise.
%  Calculates the standard Power Spectrum and one obtained using
%   segment averaging.  Use 126 sample segement length with a 99% overlap
%  Assumes the data is variable x in the .mat file and was 
%   acquired at a sampling frequency of 1.0 kHz
%
close all; clear all;
load broadband1;                            % Load data (variable x)
fs = 1000;                                  % Sampling frequency
nfft = 128;                                 % Segment size for averaging
PS = abs((fft(x)).^2)/length(x);            % Calculate un-averaged PS
half_length = fix(length(PS)/2);			% Find data length /2
f = (0:half_length-1)* fs/(2*half_length);    % Frequency vector for plotting
subplot(1,2,1)
plot(f,PS(1:half_length),'k');              % Plot un-averaged Power Spectrum
    xlabel('Frequency (Hz)','FontSize',14); ylabel('Power Spectrum','FontSize',14);
    title('A) Standard Spectrum','FontSize',12);
%
[PS_avg,f] = pwelch(x,nfft,nfft-1,nfft,fs);  % Use 99% overlap
subplot(1,2,2)    
    plot(f,PS_avg,'k');                     % Plot averaged Power Spectrum
    xlabel('Frequency (Hz)','FontSize',14); ylabel('Power Spectrum','FontSize',14);
    title('B) Periodogram','FontSize',12);