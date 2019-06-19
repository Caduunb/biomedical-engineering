% Example 2.12 Construct an array containing the impulse response of a 
%  first-order process.  The impulse response of a first-order process 
%  is given by the equation: h(t) =  e-t/? (scaled for unit amplitude).  
%  Assume a sampling frequency of 500 Hz and a time constant, ?, of 1 sec. 
%  Use convolution to find the response of this system to a unit step input.
%
clear all; close all;
fs = 500;                   % Sample frequency
N = 2500;                   % Construct 5 seconds worth of data
t = (0:N-1)/fs;              % Time vector 0 to 5 
tau = 1;                    % Time constant
h = exp(-t./tau);           % Construct impulse response
x = ones(1,N);              % Construct step stimulus
y = conv(x,h);              % Get output (convolution)
subplot(1,2,1);
plot(t,h,'k');              % Plot impulse response
xlabel('Time (sec)','FontSize',14); ylabel('y(t)','FontSize',14);
title('Impulse Response','FontSize',12);
subplot(1,2,2);
plot(t,y(1:N),'k');         % Plot the step response
xlabel('Time (sec)','FontSize',14); ylabel('y(t)','FontSize',14);
title('Step Response','FontSize',12);
%
