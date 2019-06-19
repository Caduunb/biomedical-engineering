% Example 2.6 Evaluate 2 waveform for Orthogonality.
clear all
close all

Ts = 0.01; % Sample interval
N = 300; % Number of points
t = (0:N-1)*Ts; % Time vector
f1 = 1.5; % Frequency of sine wave
f2 = f1; % Frequency of cosine wave
sin_wave = sin(2*pi*f1*t);
cos_wave = cos(2*pi*f2*t);
Corr = sum(sin_wave.*cos_wave);
disp("Corerelation between waves:")
disp(Corr)
