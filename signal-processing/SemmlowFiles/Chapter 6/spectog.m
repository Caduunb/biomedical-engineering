function [sp,f,t] = spectog(x,nfft,fs,noverlap)
%[sp,f,t] = spectog(x,nfft,fs,noverlap);
% Function to calculate spectrogram
%  Output arguments
%		sp	spectrogram
%		t	time vector for plotting
%		f	frequency vector for plotting
%  Input arguments
%		x data
%		nfft window size
%       fs sample frequency
%		noverlap number of overlaping points in adjacent segements (default 50%)
%
%	Uses Hamming window
%
if nargin < 4
    noverlap = floor(nfft/2);       % Default overlap
end
[N xcol] = size(x);
if N < xcol
   x = x';						% Make row vector 
   N = xcol;
end  
incr = nfft - noverlap; 
hwin = fix(nfft/2);
f = (1:hwin-1)* fs/nfft;  	% Calculate frequency vector
x_mod = [zeros(hwin,1); x; zeros(hwin,1)];  % Zero pad array to handle edge effects
j = 1;
for k = 1:incr:N  			% Calculate spectra for each data point
   data = x_mod(k:k+nfft-1) .* hamming(nfft);  % Window data
   ft = abs(fft(data));
   sp(:,j) = ft(2:hwin);   % Limit frequency range to meaningful points
   t(j) = k/fs;				% Calculate time vector
   j = j + 1;
end

   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
