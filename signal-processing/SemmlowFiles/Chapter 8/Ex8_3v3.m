% Example 8.3 and Figure 8.8   Adaptive Filters
%  Uses an adaptive filter to eliminate broadband noise from a narrowband sigal
%	Uses LSM algorithm applied to the same data as Ex. 8-1
% Generate signal and noise
close all; clear all;
fs = 1000;					% Sampling frequency
N = 1024;					% Number of points
L = 256;    				% Optimnal filter order
a = .25;                      % Convergence gain
t = (1:N)/fs;				% Time vector for plotting
% Generate data:  10 Hz sine in 8 db noise
% xn = Signal + noise;  x = signal only (desired)
[xn,t,x] = sig_noise(10,-8,N);   % 50 Hz sine;  SNR = -8 db
%
subplot(3,1,1);
plot(t, xn,'k');			% Plot unfiltered data
xlabel('Time(sec)','FontSize',12);
ylabel('x(t)','FontSize',14);
axis([0 1 1.2*min(xn) 1.2*max(xn)]);
title('SNR -8 dB; 10 Hz sine','FontSize',14);
% Calcuate Convergence Parameter
Px = mean(xn.^2);
delta = a * (1/(10*L*Px));
b = lms(xn,x,delta,L); %LMS algo
subplot(3,1,2);
y = filter(b,1,xn);		% Filter data using optimum filter weights
plot(t,y,'k');				% Plot filtered data
xlabel('Time(sec)','FontSize',12);
ylabel('y(t)','FontSize',14);
axis([0 1 1.2*min(y) 1.2*max(y)])
title('After Adaptive Filtering','FontSize',14);
subplot(3,1,3);
[h,f] = pwelch(b,[],[],512,1000);
plot(f,h,'k');				% Plot Adaptive Filter spectra
xlabel('Frequency (Hz)','FontSize',12);
ylabel('|H(f)|','FontSize',14);
axis([0 100 0 1.2*max(h)])
title('Optimal Filter Freq Plot','FontSize',14);

