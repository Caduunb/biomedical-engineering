% Exercício 3.14
clearvars; close all; clc;

N = 512;
fs = 1e3;
t = (0:1:(N-1))*(1/fs);    % 512-point time vector
freq_vec = 0:(fs/N):(fs/2); % frequency vector

signal400 = sin(2*400*pi*t) + sin(2*200*pi*t);
signal900 = sin(2*200*pi*t) + sin(2*900*pi*t);

%% Plot Signals
figure(1)
subplot(2,1,1);
plot(t, signal400);
xlabel('time (ms)')
ylabel('Signal with 400 and 200Hz elements')
subplot(2,1,2);
plot(t, signal900);
xlabel('time (ms)')
ylabel('Signal with 900 and 200Hz elements')


%% Fourier
%fouriersignal400 = signal400/N; % normalization
fouriersignal400 = fft(signal400);

% [DC_element, RestOfSignal]
%magsignal400 = [abs(fouriersignal400(1)), 2*abs(fouriersignal400(2:end))]; 
magsignal400 = abs(fouriersignal400); 

%fouriersignal900 = signal900/N;
fouriersignal900 = fft(signal900);

% [DC_element, RestOfSignal]
%magsignal900 = [abs(fouriersignal900(1)), 2*abs(fouriersignal900(2:end))];
magsignal900 = abs(fouriersignal900);

%% Plot discrete Fourier Transform
poi = length(freq_vec); % points of interest
figure(2); hold on;
sgtitle('Comparison between both signals magnitude spectrum');
plot(freq_vec, magsignal400(1, 1:poi));
plot(freq_vec, magsignal900(1, 1:poi));
legend({'400Hz and 200Hz elements signal', '900Hz and 200Hz elements signal'}, 'FontSize', 15);
