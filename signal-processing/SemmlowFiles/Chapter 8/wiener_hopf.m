function b = wiener_hopf(x,y,maxlags)
% Function to compute LMS algol using Wiener-Hopf equations
% b = wiener_hopf(x,y,maxlags)
%  Inputs:	x = input
%  			y = desired signal
%				Maxlags = filter length
% Compute the autocorrelation matrix
%n = length(x);
rxx = xcorr(x,maxlags);                % Compute the autocorrelation function
rxx = rxx(maxlags+1:end-1)';        % Use only positive half of symmetrical vector
rxy = xcorr(x,y,maxlags);              % Compute the crosscorrelation vector
rxy = rxy(maxlags+1:end-1)';        %   and use only positive half. 
%
rxx_matrix = toeplitz(rxx);            % Construct correlation matrix
b = rxx_matrix\rxy;                      % Calculate FIR coefficients using matrix
                                                 %   inversion. Levenson could be used here
