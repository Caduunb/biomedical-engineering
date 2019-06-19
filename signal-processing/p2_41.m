% Exercise 2.41
%% Generate impulse response and input signals
clear all; close all;
fs = 500;        % Sample frequency
tau = 1;         % Time constant
damp = 0.04;     % damping factor
fn(1) = 10;
fn(2) = 20;      % undamped natural frequency
N = 1000;        % number of points
t = (0:N-1)/fs;  % Time vector [0,2]s

% 4 different impulse responses
termo = damp/(sqrt(1 - damp.*2));
term1(1,:) = termo.*exp(-damp.*2.*pi.*fn(1).*t);
term1(2,:) = termo.*exp(-damp.*2.*pi.*fn(2).*t);

term2(1,:) = sin(2*pi*fn(1)*sqrt(1 - damp*2*t));
term2(2,:) = cos(2*pi*fn(1)*sqrt(1 - damp*2*t));
term2(3,:) = sin(2*pi*fn(2)*sqrt(1 - damp*2*t));
term2(4,:) = cos(2*pi*fn(2)*sqrt(1 - damp*2*t));

h = zeros(N, 4);

h(:, 1) = term1(1,:).*term2(1,:);
h(:, 2) = term1(1,:).*term2(2,:);
h(:, 3) = term1(2,:).*term2(3,:);
h(:, 4) = term1(2,:).*term2(4,:);
%% Plotting h(t) in its 4 variations
figure
subplot(2,2,1);
    plot(t, h(:,1)); 
    title ('h(t) sine wave; fn: 10Hz');
    xlabel('Time (s)');
    ylabel('h(t)');
subplot(2,2,2);
    plot(t, h(:,2)); 
    title ('h(t) cosine wave; fn: 10Hz');
    xlabel('Time (s)');
    ylabel('h(t)');
subplot(2,2,3);
    plot(t, h(:,3));
    title ('h(t) sine wave; fn: 20Hz');
    xlabel('Time (s)');
    ylabel('h(t)');
subplot(2,2,4);
    plot(t, h(:,4));
    title ('h(t) cosine wave; fn: 20Hz');
    xlabel('Time (s)');
    ylabel('h(t)');
%% Computing cross correlation
R = corrcoef(h)
clear term1 term2 termo;