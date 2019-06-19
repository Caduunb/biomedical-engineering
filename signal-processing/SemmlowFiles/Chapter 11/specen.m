function entropy=specen(y,NF)
% Specen calculates the entropy.  Used the same code as In Example 11.6.
% entropy=specen(y,Fs) 
% Inputs
%   x:        The signal
%   NF: Number of frequency components 
% Outputs
%   entropy:  The determined spectral entropy
%
if nargin<2  % Default number of frequency components to use is length(x)
    NF=length(y);
end

y=y-mean(y);  %  Remove the mean value of the signal
PS=abs(fft(y,NF)).^2;  % Compute the power spectrum
PS=PS(1:end/2);        % Remove redundant components
Q=PS/sum(PS);          % Apply equation 11.4 by normalizing

H=Q.*log2((Q).^-1)/log2(NF/2); % Apply equation 11.5 (Shannon transform)  
entropy=sum(H);            % Spectral entropy is the sum of H (Eq. 11.6)
