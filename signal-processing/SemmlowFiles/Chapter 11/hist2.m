function hist = hist2(x,y,nu_bin)
% hist = hist2(x,y,nu_bin)
% Function to compute a 2-D hostogram
% Inputs
%    x, y   Input signals (must be same length)
%    nu_bin  Bin size (horizontal and vertical)
% Output
%    hist    Histogram (matrix sized nu_bin x nu_bin)


if nargin < 3
    nu_bin = length(unique([x,y])); % Default bins is number 
end                             % of unique elements (IE no quantizing)


ln = length(x);
hist = zeros(nu_bin,nu_bin);      % Zero array
%
x_range = max(x) - min(x);          % x signal amplitude
y_range = max(y) - min(y);          % y signal amplitude
% Quantize data
quant_x = round((nu_bin-1)*(x-min(x))/x_range) + 1;  % Quantize x 
quant_y = round((nu_bin-1)*(y-min(y))/y_range) + 1;  % Quantize y
% Bin data 
for n = 1:ln
   hist(quant_x(n),quant_y(n)) = hist(quant_x(n),quant_y(n)) + 1;
end
