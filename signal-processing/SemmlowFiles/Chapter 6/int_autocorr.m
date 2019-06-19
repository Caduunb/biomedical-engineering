function [Rxx,t,lags] = int_autocorr(x,fs)
% Function to compute the Instantenous Autocorrelation 
%   Output 
%		Rx  Instantenous Autocorrelation
%   Input
%		x 	signal
%
[N, xcol] = size(x);
if N < xcol                 % Make signal a row vector if necessary
   x = x';
   N = xcol;
end 
if (round(N/2) - N/2) ~= 0
    x = [x; 0];             % Make data length even
    N = N + 1;
end
N_2 = N/2;                  % Half data length
%
Rxx = zeros(N,N);
% Compute instantaneous autocorrelation:  Eq. 6.5
for n = 1:N                     % Increment over time 
   k_max = min([n-1,N-n]);      % Limit lags to available data
   k = -k_max:k_max;            % Shift tau in both directions
   Rxx(N_2+k,n) = x(n+k) .* conj(x(n-k));    % Eq. 6.5
end
t = (1:N)/fs;                   % Time (in rows)
lags = (-N_2:N_2-1)/fs;         % Lags (in columns)