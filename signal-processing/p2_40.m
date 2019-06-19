% Exercise 2.40
%% Generate impulse response and input signals
clear all; close all;
fs = 500; % Sample frequency
tau = 1; % Time constant
damp = 0.1; % damping factor
fn = 2; % undamped natural frequency
N = 1000; % number of points
t = (0:N-1)/fs; % Time vector [0,2]s

% Impulse response
term1 = damp/(sqrt(1 - damp*2));
term1 = term1.*exp(-damp*2*pi*fn*t);
term2 = sin(2*pi*fn*sqrt(1 - damp*2*t));
h = term1.*term2;
clear term1 term2;
% Input signals
stepin = ones(1,N); % generate step stimulus
randin = zeros(3,N); % pre-allocating memory
for i = 1:3
    randin(i, :) = randn(N,1);
end
%% Generate outputs and plot signals
stepout = conv(h, stepin);
randout = zeros(3,2*N-1); % pre-allocating memory 
for i = 1:3
    randout(i, :) = conv(h, randin(i, 1:N));
end
subplot(1,3,1);
    plot(t,h); % Plot impulse response
    title ('Impulse response');
    xlabel('Time (s)');
    ylabel('h(t)');
subplot(1,3,2);
    plot(t, stepout(1:N)); % Plot 1000 points of the step response 
    title ('Step response');
    xlabel('Time (s)');
    ylabel('x(t)');
subplot(1,3,3);
    plot(t, randout(1, 1:N)); % Plot 1000 points of the step response 
    title ('Random response (signal 1)');
    xlabel('Time (s)');
    ylabel('y(t)');
%% Generate another plot for 3 different random input analysis
figure
for i = 1:3
    subplot(3,2,2*i-1);
        plot(t, randin(i, 1:N)); % Plot 1000 points of the step response 
        title (sprintf('Normally distributed input signal %d', i));
        xlabel('Time (s)');
        ylabel('rand(t)');
end
for i = 1:3
    subplot(3,2,2*i);
        plot(t, randout(i, 1:N)); % Plot 1000 points of the step response 
        title (sprintf('Random signal response %d', i));
        xlabel('Time (s)');
        ylabel('y(t)');
end