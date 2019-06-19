% Example 6.2 Example to generate a sine wave with a linear change in frequency
%   Evaluate the time-frequency charactoristic using the STFT
% 	Sine wave should vary between 10 and 200 Hz over a  sec period
% Assume a sample rate of 500 Hz
%
clear all; close all;
%  Constants
N = 500;				% Number of points	
fs = 500;			    % Sample freq;
f1 = 10;				% Minimum frequency
f2 = 200;			    % Maximum frequency 
nfft = 32;			    % Window size 
colormap('gray');
tc = (1:N)/fs;
%Generate chirp signal (i.e., linear change in freq)
fc = ((1:N)*((f2-f1)/N)) + f1; 
x = sin(pi*tc.*fc);     % Note 2pi just pi since freq. doubled. 
%
plot(tc,x,'k');     % Plot chirp signal
 axis([0 .3 -1.5 1.5]);
 xlabel('Time (sec)','FontSize',14);
 ylabel('x(t)','FontSize',14);
% Compute spectrgram Hanning window, 50% overlap
% [B,f,t] = spectog(x,nfft,fs,nfft/2);   % Alternate
[B,f,t] = spectrogram(x,nfft,[],nfft,fs);
%
%      Plots
figure;
subplot(1,2,1);
    mesh(t,f,abs(B));
    xlabel('Time (sec)','FontSize',12);
    ylabel('Frequency (Hz)','FontSize',12);
    title ('Spectogram','FontSize',12);
    axis([0 1 0 250 0 15]);
subplot(1,2,2);
    contour(t,f,abs(B));
    xlabel('Time (sec)','FontSize',12);
    ylabel('Frequency (Hz)','FontSize',12);
    axis([0 1 0 250]);
%
% nfft = 64;
% [B,f,t] = spectog(x,nfft,fs,nfft/2);
% %
% subplot(2,2,3);
%     mesh(t,f,abs(B));
%     xlabel('Time (sec)','FontSize',12);
%     ylabel('Frequency (Hz)','FontSize',12);
%     title ('Spectogram','FontSize',12);
%     axis([0 1 0 250 0 15]);
% subplot(2,2,4);
%     contour(t,f,abs(B));
%     xlabel('Time (sec)','FontSize',12);
%     ylabel('Frequency (Hz)','FontSize',12);
%     axis([0 1 0 250]);