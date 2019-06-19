% Example 2.6 Generate a 500 point, 2 Hz sine wave and a 4
% Hz sine wave of the same length.  Make TT = 1 sec. Are these two waveforms orthogonal?
% Solution. Generate the waveforms. Since N = 500 and  TT = 1 sec, 
% Ts = TT /N = 0.002 sec.  Apply Eq. 2.29 to these to waveforms.  
% If the result is small (near zero) the waveforms are orthogonal. 
%
clear all close all;
Ts = 0.002;             % Sample interval
N = 500;                % Number of points
t = (0:N-1)*Ts;         % Time vector
f1 = 2;                 % Frequency of sine wave 1
f2 = 4;                 % Frequency of sine wave 2
x = sin(2*pi*f1*t);     % Sine wave 1
y = sin(2*pi*f2*t);     % Sine wave 2
r = sum(x.*y);          % Eq. 2.29
disp(r)
