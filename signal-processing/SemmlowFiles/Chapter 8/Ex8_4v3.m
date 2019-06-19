%Ex 8.4 Adaptive Line Enhancement (ALE)
%  Uses adaptive filter to eliminate broadband noise form a narrowband sigal
%
% Generate signal and noise
close all; clear all;
fs = 1000;	% Sampling frequency
L = 256;		% Filter order
N = 2000;	% Number of points
delay = 6;  %Decorrelation delay,  white noise should have little correlation
t = (1:N)/fs;	% Time vector for plotting
%
%Generate data: two sequential sinusoids, 10 & 20 Hz in noise (SNR = -10)
x = [sig_noise(10,-6,N/2) sig_noise(20,-6,N/2)];
% 
subplot(2,1,1);                     % Plot unfiltered data
plot(t, x,'k');
xlabel('Time(sec)','FontSize',14);
ylabel('x(t)','FontSize',14);
title('10 & 20 Hz  SNR -6 dB','FontSize',14);
Px = mean(x.^2);	        % Calculate waveform power for delta
delta = (1/(10*L*Px)) *.075	        % Use have max range of delta 
xd = [x(delay:N) zeros(1,delay-1)];	% Delay signal to decorrelate broadband noise
[b,y] = lms(xd,x,delta,L);          % Apply LMS algorithm
subplot(2,1,2);                     % Plot filtered data
plot(t,y,'k');
xlabel('Time(sec)','FontSize',14);
ylabel('y(t)','FontSize',14);
title('After Adaptive Filtering','FontSize',14);


