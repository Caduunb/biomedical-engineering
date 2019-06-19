function hist_x = hist(x,nu_bin)
% hist_x = hist(x,nu_bin)
% Function to compute a histogram
% Inputs
%    x  Input signals
%    nu_bin  Bin size 
%    hist    Histogram

if nargin < 2
    nu_bin = length(unique(x))/10; % Default bins is number 
end                             % of unique elements (IE no quantizing)

ln = length(x);
hist_x = zeros(1,nu_bin);      % Zero array
%
x_range = max(x) - min(x);          % x signal amplitude
% Quantize data
quant_x = round((nu_bin-1)*(x-min(x))/x_range) + 1;  % Quantize x 
% Bin data 
for n = 1:ln
hist_x(quant_x(n))= hist_x(quant_x(n)) + 1;
end

