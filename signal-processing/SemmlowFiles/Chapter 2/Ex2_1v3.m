% Ex 2.1 Digital solution. Generate a 1 cycle sine wave.  Assume a sample interval 
%  of Ts = 0.005 sec. and make N = 500 points long (both arbitrary).
%  So solving Eq. 1.4 for the total time: TT = NTs = 0.005(500) = 2.5 sec.
%  To generate cycle given these parameters, the frequency of the sine wave  
%  should be f = 1/TT = 1/2/5 = 0.4 Hz.   
%
close all; clear all;
N = 500;                 % Number of points for waveform
Ts = .005;				 % Sample interval =  5 msec
t  = (1:N)*Ts;		     % Generate time vector (t = N Ts)
f = 1/(Ts*N);            % Sine wave freq for 1 cycle
A = 1;                   % Sine wave amplitude
x = A*sin(2*pi*f*t);       % Generate sine wave
plot(t,x);               % Plot (not shown)
rms = sqrt(mean(x.^2))   % Evaluate the RMS value and output


