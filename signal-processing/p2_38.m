% Example 2.12 Convolution of a first-order system with a step
%% Generate inputs and impulse response
clear all; close all;
% Generate random input as a white Gaussian noise
mu = 0; % mean value
sigma = 2; % variance equals 4
N = 2500; % number of points
rand_in = sigma*randn(N, 1) + mu; %random input
clear mu sigma;

fs = 500; % Sample frequency
t = (0:N-1)/fs; % Time vector [0,5]s
tau = 1; % Time constant

h = exp(-t./tau); % Construct impulse response

step_in = ones(1,N); % Construct step stimulus

%% Generate outputs
step_out = conv(step_in,h); % Get output of step input(convolution)
rand_out = conv(rand_in,h); % Get output of random input (convolution)
[out_corr, lags] = xcorr(step_out, rand_out, 'coeff'); %correlation between outputs
lags = lags/fs; % normalize the lags to time
subplot(1,3,1);
    plot(t,h); % Plot impulse response
    title ('Impulse response');
    xlabel('Time (s)');
    ylabel('h(t)');
subplot(2,3,2);
    plot(t, step_out(1:N)); % Plot 2500 points of the step response 
    title ('Step response');
    xlabel('Time (s)');
    ylabel('x(t)');
subplot(2,3,3);
    plot(t, rand_out(1:N)); % Plot 2500 points of the step response 
    title ('Random input response');
    xlabel('Time (s)');
    ylabel('y(t)');
subplot(2, 3, [5,6]);
    plot(lags, out_corr); % Plot 2500 points of the step response 
    title ('Correlation between responses');
    xlabel('Lags (s)');
    ylabel('R_{xy}');