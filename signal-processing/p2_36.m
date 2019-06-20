% Filter 512 point Gaussian noise and apply convolution [1/3 1/3 1/3].
% Compare the autocorrelation between the filtered and non-filtered
% signals.
clear all; close all;
mu = 0; % mean value
sigma = 2; % variance equals 4
L = 512; % number of points
gaussiannoise = sigma*randn(L, 1) + mu;
%% filter
subplot(2,2,1);
plot(gaussiannoise, 'g'); hold on;
title ('Gaussian White Noise')
subplot (2,2,2);
filter = [1/3 1/3 1/3];
filter_noise = conv(filter, gaussiannoise);
plot (filter_noise, 'b');
title('Filtered Noise');

%% autocorrelation
subplot(2,2,3) %
[cgg, lags1] = xcorr(gaussiannoise, gaussiannoise, 20, 'coeff');
plot(lags1, cgg, 'g');
title('Autocorrelation Gaussian Noise');
subplot(2,2,4);
[cff, lags2] = xcorr(filter_noise, filter_noise, 20, 'coeff');
plot(lags2, cff, 'b');
title('Autocorrelation filtered noise');

%% Save data
gauss_noise = gaussiannoise;
save('p2_36data', 'filter_noise', 'gauss_noise')