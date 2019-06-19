function [b,y,e] = lms(x,d,delta,N)
%  [b,no,e] = lms(x,d,delta,N)
%  Simple function to adjust filter coeffients using LSM-based algorithm
%  Inputs:	x = input
%  			d = desired signal
%			delta = the convergence gain
%			L is the length (order) of the FIR filter.
% Outputs:	b = FIR filter coefficients
%			y = ALE output
%			e = residual error 
%  Adjusts filter coefficients, h, to best provide best match between
%	the input, x(n), and a desired waveform, d(n). X and D must be the same length
%  N specifes the number of filter weights and delta the convergence factor
% Uses a standard FIR filter
%
M = length(x);                      % Get data length
b = zeros(1,N); y = zeros(1,M);     % Initialize outputs
for n = N:M
   x1 = x(n:-1:n-N+1);              % Select convolution segment              
   y(n) = b * x1';                  % Convolve filter with input
   e(n) = d(n) - y(n);			     % Calculate error
   b = b + delta*e(n)*x1;            % Adjust filter coeff. 
end


