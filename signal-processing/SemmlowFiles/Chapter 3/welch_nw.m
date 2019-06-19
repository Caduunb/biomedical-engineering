function [PS,f] = welch_nw(x,nfft,noverlap,fs)
%Function to calculate averaged spectrum
%[ps,f] = welch(x,nfft,noverlap,fs);
%  Output arguments
%		sp	spectrogram
%		f	frequency vector for plotting
%  Input arguments
%		x data
%		nfft window size
%      	noverlap number of overlaping points in adjacent segements
%	    fs sample frequency
%	Uses Hanning window
%
N = length(x);                     % Get data length
half_segment = round(nfft/2);      % Half segment length
if nargin < 4                      % Test inputs
    fs = 2*pi;                     % Default fs
end
if nargin < 3 || isempty(noverlap) == 1
    noverlap = half_segment;       % Set default overlap at 50%
end
nfft = round(nfft);                % Make sure nfft is an interger
noverlap = round(noverlap);        % Make sure noverlap is an interger
%
f = (1:half_segment)* fs/(nfft);   % Calculate frequency vector
increment = nfft - noverlap;       % Caluclate window shift
nu_avgs =  round(N/increment);     % Determine the number of segments
%
for k = 1:nu_avgs 			       % Calculate spectra for each data point
   first_point = 1 + (k - 1) * increment;
   if (first_point + nfft -1) > N
       first_point = N - nfft + 1;          % Prevent overflow
   end
    data = x(first_point:first_point+nfft-1); % Get data segment
    if k == 1
       PS = abs((fft(data)).^2);            % Calculate Power spectrum Eq. 4.16
   else
       PS = PS + abs((fft(data)).^2);       % Calculate Power spectrum
   end
end
PS = PS(2:half_segment+1)/(nu_avgs*nfft/2);  % Remove redundant points, no avg


   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
