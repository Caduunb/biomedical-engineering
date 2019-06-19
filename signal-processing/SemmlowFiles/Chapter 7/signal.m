function [waveform, time] = signal(freqsin, ampl, npts);
% function [waveform, time] = signal(freqsin, ampl, npts);
% Function to generate test data.  Generates sinusoids without noise.
%
%  freqsin  	is a vector specifing the frequency of sinusoid(s) 
%              	assuming a sample frequency of 1 KHz
%						One sinusoid of amplitude 1 is generated for each entry
% ampl   			is a vector the amplitude values of the associated sinusoid
% npts    		number of points in the array
% waveform 		is the output vector containing sinusoids 
% time     		is the time vector useful in ploting the waveform
%						i.e., plot(time,waveform)
%
%
fs = 1000;   	% Assume a sampling freq of 1 kHz
Ts = 1/fs;
time = (0:(npts-1))*Ts;
%
for i = 1:length(freqsin)
   freq_scale = freqsin(i) * 2 * pi/fs;
   x = (1:npts) * freq_scale;
   component = sin(x) * ampl(i);
   if i == 1
      waveform = component;
   else
      waveform = waveform + component;
   end
end
