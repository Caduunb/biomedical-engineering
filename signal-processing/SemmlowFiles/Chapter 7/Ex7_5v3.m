% Example 7-5 Discontinunity detection
%  Construct a waveform of 2 sinusiods with a discontinunity
%      in the second derivative
% Decompose the waveform into 3 levels to detect the discontinuity. 
%  Use Daubeches 4 element filter
%
close all; clear all;
fs = 1000;						% Sample frequency
N = 1024;						% Number of points in waveform
freqsin = [.23 .8 1.8]; 		% Sinusoidal frequencies
ampl = [1.2 1 .7];				% Amplitude of sinusoid
incr = .01;						% Size of second derivative discontinunity 
offset = [zeros(1,N/2) ones(1,N/2)];
[x1 t] = signal(freqsin,ampl,N); 	% Construct signal
x1 = x1 + offset*incr;  			% Add discontinunity at midpoint
x = integrate(integrate(x1));			% Double integrate
save ex7_5_data x offset t;
clear all; 
load ex7_5_data;                % Solution begins here. 
plot(t,x,'k',t,offset-2.2,'k');
axis([0 1 -2.5 2.5]);
xlabel('Time (sec)','FontSize',14);
ylabel('x(t)','FontSize',14);
%
figure;
h0 = daub(4);                     % Daubechies 4
a = analyze(x,h0,3);	% Decompose signal, analytic filter bank of level 3


