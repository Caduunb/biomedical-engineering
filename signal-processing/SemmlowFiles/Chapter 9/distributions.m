% Distributions  Shows Probability density (histogram) for 
%  various data
%
close all; clear all;
N = 20000;		% Number of data points
nb = 10;			% Number of bins
w = (1:N)/N;
% Gaussian distribution
xh = (-nb:nb)/nb;
x_norm = normpdf(xh,0,.3);
y = sin(100*pi*w);
hi = hist(y,21);
subplot(1,2,1);
plot(xh,hi/max(hi),'k');
hold on; plot(xh,x_norm/max(x_norm),'k:');
xlabel('x');
ylabel('P(x)');
title('Single Sinusoid');
%
y = sin(100*pi*w) + sin(30*pi*w);
hi = hist(y,21);
subplot(1,2,2);
plot(xh,hi/max(hi),'k');
hold on; plot(xh,x_norm/max(x_norm),'k:');
xlabel('x');
ylabel('P(x)');
title('Two Sinusoids');
%
