% Script to calculate the RMS for a given x(time) sawtooth wave.
% Parameters
clear all
close all

disp("Parameters of the sawtooth waveform")
T = 1/2     % period
fs = 1000   % sample rate

% Defining the sawtooth wave
% Ploting sawtooth wave
T_5 = T*5;
t = 0:1/fs:(T_5-1/fs);
disp("Time vector created")
x = sawtooth (2*pi*(1/T)*t);
plot(t, x);

% Calculating the RMS of x(time)
fun = @(time) (sawtooth(2*pi*(1/T)*time)).^2
x_rms = integral(fun, 0, T);
x_rms = (1/T)*x_rms;
disp("RMS of x(time):")
x_rms = sqrt(x_rms)
