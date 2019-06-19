% Ex 4-5 and Figure 4-13
% Bandstop filter with a passband gain of 1 between 0 and 100, 
%  a stop-band gain of -60 db between 300 and 400 Hz, 
%  and an upper passband gain of 1 between 500 and fs/2 Hz. 
% Maximum ripple for the pass band should be 1.5 db
% 
clear all;
rp_pass = 10^(-1.5/20);				% Specify ripple tolerance in passband 
rp_stop = 10^(-60/20);              % Specify error tolerance in stopband
fs = 2000;							% Sample frequency: 2 kHz
f = [100 300 400 500];              % Define frequency ranges
a= [1 0 1];                         % Specify gain in those regions
dev = [rp_pass rp_stop rp_pass]
% Design filter - determine filter order
[n,fo,ao,w] = firpmord(f,a,dev,fs)  % Determine filter order, Stage 1   
b = firpm(n, fo, ao, w);		    % Determine filter weights, Stage 2
freqz(b,1,512,fs);                  % Plot filter frequency response 
disp(n)
	