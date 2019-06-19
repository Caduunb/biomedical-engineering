function [sp,f,t] = spectog_cheby(x,nfft,fs,noverlap);
%Function to calculate spectrogram
%[sp,f,t] = spectog(x,nfft,fs,noverlap);
%  Output arguments
%		sp	spectrogram
%		t	time vector for plotting
%		f	frequency vector for plotting
%  Input arguments
%		x data
%		nfft window size
%     fs sample frequency
%		noverlap number of overlaping points in adjacent segements
%	Uses Hanning window
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
f = (1:hwin)* fs/nfft;  	% Calculate frequency vector
x_mod = [zeros(hwin,1); x; zeros(hwin,1)];  % Zero pad array to handle edge effects
j = 1;
for i = 1:incr:N  			% Calculate spectra for each data point
   data = x_mod(i:i+nfft-1) .* chebwin(nfft,30);  % Window data with cheby window
   ft = abs(fft(data));
   sp(:,j) = ft(1:hwin);   % Limit frequency range to meaningful points
   t(j) = i/fs;				% Calculate time vector
   j = j + 1;
end

   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
