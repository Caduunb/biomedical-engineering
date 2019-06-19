
function an = w_packet(x,h0,L)
% an = w_packet(x,h,L)
% Function to calculate Analyze Filter Bank using a "Balanced Tree"
% All arguments are the same as in routine 'analyze'
% Inputs
%	x 	  input waveform (must be longer than 2^L + L and power of two)
%	h0    filter coefficients (low pass)
%	L     decomposition level (number of High pass filter in bank)
% Outputs
%   an    Decomponsed signals in a single array.
%
lf = length(h0);            % Filter length
lx = length(x);             % Data length
an = x;                     % Initialize output 
% Calculate High pass coefficients from low pass coefficients
for k = 0:(lf-1)
   h1(k+1) = (-1)^k * h0(lf-k);  % Uses Eq 7.20
end
% Calculate filter outputs for all levels
for k = 1:L
   nu_low = 2^(k-1);        % Number of lowpass filters at this level
   l_seg = lx/2^(k-1);      % Length of each data segment at this level
   for j = 1:nu_low;
      i_start = 1 + l_seg * (j-1);   % Location for this segment
      a_seg = an(i_start:i_start+l_seg-1); 
      lpf = conv(a_seg,h0,'same');			 % Low pass filter 
      hpf = conv(a_seg,h1,'same');			 % High pass filter
      lpf = lpf(1:2:l_seg);                  % Down sample
      hpf = hpf(1:2:l_seg);
      an(i_start:i_start+l_seg-1) = [lpf hpf];	
  end  
end 


