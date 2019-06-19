% Example 5.2  Evaluation of AR methods and model order
%
clear all; close all;
load example5_2_data.mat;
N =  length(x);             % Get signal length
fs = 1000;                  % Sample frequency
%
% Estimate the Welch spectrum using all points, no window,
%   and no overlap
%  Plot noiseless signal
[PS,f] = pwelch(x,N,[],[],fs);  % Classical Fourier spectrum
subplot(3,2,1);
plot(f,PS,'k');				% Plot PS 
text(200,max(PS),'Fourier Transform');
xlabel('Frequency (Hz)');
ylabel('PS ');
axis([0 500 0 .5]);
%
% Apply Welch method to noisey data set
subplot(3,2,2);
[PS,f] = pyulear(x,11,N,fs);
plot(f,PS,'k');				% Plot PS 
text(200,max(PS),'Yule Walker p = 11');
xlabel('Frequency (Hz)');
ylabel('PS ');
axis([0 500 0 .15]);
%
% Apply AR to noisy data set at three different weights
subplot(3,2,3);
[PS,f] = pyulear(x,17,N,fs);
plot(f,PS,'k');				% Plot
text(200,max(PS),'Yule Walker p = 17');
xlabel('Frequency (Hz)');
ylabel('PS ');
axis([0 500 0 .15]);
%
subplot(3,2,4);
[PS,f] = pyulear(x,25,N,fs);
plot(f,PS,'k');				% Plot 
text(200,max(PS),'Yule Walker p = 25');
xlabel('Frequency (Hz)');
ylabel('PS ');
axis([0 500 0 .15]);
%
subplot(3,2,5);
[PS,f] = pyulear(x,35,N,fs);
plot(f,PS,'k');				% Plot PS in log scale
text(200, max(PS),'Yule Walker = 35');
xlabel('Frequency (Hz)');
ylabel('PS');
axis([0 500 0 .15]);
%
%  Apply Covariance method to data set
subplot(3,2,6);
[PS,f] = pmcov(x,25,N,fs);
plot(f,PS,'k');				% Plot PS in log scale
text(200,max(PS),'Covariance p = 25');
xlabel('Frequency (Hz)');
ylabel('PS');
axis([0 500 0 .15]);
