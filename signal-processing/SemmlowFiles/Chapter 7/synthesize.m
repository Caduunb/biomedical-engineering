function y = synthesize(a,h0,L)
% Function to calculate synthesize filter bank
%  Uses circular convolution
%  y = synthesize(a,h0,L)
%  Inputs
%	a 	analyze filter bank outputs produced by analyze.m
%	h   filter coefficients (low pass)
%	L  decomposition level (number of High pass filters in bank)
%
%  Putputs
%    y   restored output signal
%
lf = length(h0);		% Filter length
lx = length(a);         % Data length
lseg = lx/(2^L);		% Lenght of first low and high pass segments
y = a;					% Initialize output
g0 = h0(lf:-1:1);       % Reverse filter coefficient order: Eq. 7.23
% Calculate High pass coefficients from low pass coefficients
for k = 0:(lf-1)
   h1(k+1) = (-1)^k * h0(lf-k);  % Alternating flip: Eq 7.20
end
g1 = h1(lf:-1:1);	% Reverse high pass filter coeffieients, Eq. 7.24
% Calculate filter outputs for all levels
for k = 1:L
   lpx = y(1:lseg);						% Get Low pass segment
   hpx = y(lseg+1:2*lseg);	 		
   up_lpx = zeros(1,2*lseg);			% Initialize vector for upsampling 
   up_lpx(1:2:2*lseg) = lpx;	        % Up sample low pass (every odd point)
   up_hpx = zeros(1,2*lseg);			% Repeat for high pass 
   up_hpx(1:2:2*lseg) = hpx;
   y(1:2*lseg) = conv(up_lpx,g0,'same') + conv(up_hpx,g1,'same'); % Filter and combine
   lseg = lseg * 2;						% Double segment lengths for next pass						s
end   
   
   

