% Example 8.1 An Example of Weiner Filter Theory
%  Uses optimal filter to eliminate broadband noise form a narrowband signal
%	Uses Weiner-Hoft equations
% Generate signal and noise
close all; clear all;
fs = 1000;					% Sampling frequency
N = 1024;					% Number of points
n = 256;    				% Optimnal filter order
t = (1:N)/fs;				% Time vector for plotting
% Generate data:  10 Hz sine in 8 db noise
[xn, t, x] = sig_noise(10,-8,N);   % 50 Hz sine;  SNR = -8 db
%
subplot(3,1,1);
plot(t, xn,'k');			% Plot unfiltered data
xlabel('Time(sec)','FontSize',14);
ylabel('x(t)','FontSize',14);
axis([0 1 1.2*min(xn) 1.2*max(xn)]);
title('SNR -8 dB; 10 Hz sine','FontSize',12);
b  = wiener_hopf(xn,x,n); %Apply Weiner Hopf Equations
subplot(3,1,2);
y = filter(b,1,xn);		% Filter data using optimum filter weights
plot(t,y,'k');				% Plot filtered data
xlabel('Time(sec)','FontSize',14);
ylabel('y(t)','FontSize',14);
axis([0 1 1.2*min(y) 1.2*max(y)])
title('After Optimal Filtering','FontSize',12);
subplot(3,1,3);
[h,f] = pwelch(b,256,[],[],1000);
plot(f,h,'k');				% Plot optimal filter spectra
xlabel('Frequency (Hz)','FontSize',14);
ylabel('|H(f)|','FontSize',14);
axis([0 100 0 1.2*max(h)])
title('Optimal Filter Freq Plot','FontSize',12);

