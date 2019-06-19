% Example 2.6 Evaluate 2 waveform for Orthogonality.
clear all
close all

t = linspace(0, 2);
f1 = 1; % Frequency of sine wave
f2 = f1; % Frequency of cosine wave
cos_wave = cos(2*pi*f1*t);
square_wave = square(2*pi*f2*t);
normal_corr = sum(square_wave.*cos_wave);
disp("Normalized correlation between waves:")
disp(normal_corr)
plot(t, cos_wave, ".-", t, square_wave, 'g')
