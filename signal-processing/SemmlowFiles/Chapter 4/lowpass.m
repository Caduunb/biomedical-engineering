function b = lowpass(L,fc)
%function b = lowpass(L,fc)
% Function to generate a lowpass rectangular window FIR filter
% Inputs
%   L     filter order (i.e., length)
%   fc    cutoff frequency (relative to fs)
% Outputs
%   b     filter coefficients   
%

for k = 1:L                 % Generate sin(n)/n function Make symmetrical
    n = k-L/2 ;            % n = k - L/2 where L even
    if n == 0
        b(k) = 2*fc;        % Case where denomonator is zero.
    else   
        b(k) = (sin(2*pi*fc*n))/(pi*n); % Filter impulse response
    end
end 