% Example 1.4 Write a Matlab program to evaluate Eq 1.8 through simulation.  
%  Generate 1 cycle of a sine wave in a 1000 point array. 
%  Quantize this sin wave array into a 6-bit binary number using the routine
%  quantization.m  (quantization.m, like all auxillary routine, can be found on the 
%   textbook website.) The calling structure for this routine is 
%   signal_out = quantization(signal_in, bits) where signal_in is the original
%  signal, bits is the number of bits for quantization (bits = 6 in this 
%  case), and signal_out is the quantized signal.  Find the noise signal 
%  by subtracting the original signal from the quantized signal.  Plot this 
%  signal and take the variance to quantify the noise.  Then evaluate the 
%  theoretical noise using Eq. 1.8 and compare the two results.
%
% Solution  Since the number of points desired is given, it is easiest to 
%  generate a 1000 point time vector then multiply by Ts; i.e.: t = (0:999)*Ts. 
% Then use that vector in to generate the desired 4 Hz sine wave signal as
%  in Example 1.2.  (Note that almost any waveform and sample interval 
%  would work as long as it included a fair number of points, the sine wave
%  is just a handy waveform.)   Quantize the 
% signal into 6 bits using the special routine quantization.m.   Subtract
% the original signal from the quantized signal and take the variance of 
% the result as the simulated noise variance.  Then evaulate Eq. 1.6 with
% bits = 6 to find the quantization level q, and use that value of q
% in conjunction with Eq. 1.8 to find the theoretical value of noise 
% variance.  Compare the two results. 
f = 4;                        % Desired frequency
N = 1000;                     % Number of points
Ts = 0.002;                   % Ts
bits = 6;                     % Quantization level
t = (0:N-1)*Ts;               % Vector used to generate 1-cycle sine wave
signal_in = sin(2*pi*f*t);    % Generate signal
signal_out = quantization(signal_in,bits);   % Quantize signal
noise_signal = signal_out - signal_in;       % Determine quantization error
q_noise = var(noise_signal);  % Quantify noise of quantization error
q = 1/(2^bits - 1);           % Calculate quantization level (Eq. 1.6)
theoretical = (q^2)/12;       % Theoritical quantization error (Eq. 1.8)
disp(' Quantization Noise')
disp('Bits    Empirical     Theoretical')
out = sprintf('%2d    %5e  %5e', bits, q_noise, theoretical);
disp(out)


    
   