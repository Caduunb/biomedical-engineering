function [PS,f] = welch(x,nfft,noverlap,fs)
%Function to calculate averaged spectrum
%[ps,f] = welch(x,nfft,noverlap,fs);
%  Output arguments
%		PS	power spectrum
%		f	frequency vector for plotting
%  Input arguments
%		x data
%		nfft window size
%      	noverlap number of overlaping points in adjacent segements
%	    fs sample frequency
%	Uses Hanning window
%
N = length(x);                              % Get data length
half_segment = round(nfft/2);               % Half segment length
if nargin < 4                               % Test inputs
    fs = pi;                                % Default fs
end
if nargin < 3 | isempty(noverlap) == 1
    noverlap = half_segment;                % Set default overlap at 50%
end
 %
%  Defaults complete. The routine now calculates the appropriate number of points
%	to shift the window and the number of averages that can be done given
%	the data length (N), window size (nff) and overlap (noverlap). 
f = (1:half_segment)* fs/(nfft);    		% Calculate frequency vector
increment = nfft - noverlap;        		% Calculate window shift
nu_avgs =  round(N/increment);          	% Determine the number of segments
%
% Now shift the segment window and calculate the PS using Eq. 4.17
for k = 1:nu_avgs               			% Calculate spectra for each data point
   first_point = 1 + (k - 1) * increment;
   if (first_point + nfft -1) > N			% Check for possible overflow
       first_point = N - nfft + 1;       	% Shift last segment to prevent overflow
   end
    data = x(first_point:first_point+nfft-1); 	% Get data segment
    N1 = length(data);
% Insert window function
    window = .41 - .5*cos(2*pi*(0:N1-1)/N1) + .08*cos(4*pi*(0:N1-1)/N1);
    data = data .* window';                  % apply winddow to data
    if k == 1
       PS = abs((fft(data)).^2);       		% Calculate power spectrum first time
   else
       PS = PS + abs((fft(data)).^2);     	% Calculate power spectrum and add to average
   end
end
% Scale average and remove redundant points. Also do not include DC term
PS = PS(2:half_segment+1)/(nu_avgs*nfft/2);     


   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
