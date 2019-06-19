% Example 1.2 Generate a discrete 2 Hz sine wave using MATLAB.  
%  Assume a sample time of 0.01 sec. and use enough points to make 
%  the sine wave 1 sec. long; i.e., the total time, TT should be 1 sec.
%
clear all; close all;
Ts = .01;               % Define Ts = .01 sec
TT = 1;                 % Define total time = 1 sec
f = 2;                  % Define frequency = 2 Hz
t = 0:Ts:1;             % Generate time vector
x = sin(2*pi*f*t);      % Generate desired sine wave
plot(t,x,'.k');          % Plot sine wave
xlabel('Time (sec)','FontSize',14);   % and label
ylabel('x(t)','FontSize',14);
axis([0 1 -1.1 1.1]);