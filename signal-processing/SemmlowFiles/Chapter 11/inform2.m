function [H,hist_xy] = inform2(x,y,nu_bin)
% H = inform(x,nu_bin)
% Function to determine the information in a signal
% x the test signal
% nu_bin the number of bins used in the histogram
% H is the determined entropy


if nargin < 3
    nu_bin = length(unique(x)); % Default bins is number 
end                             % of unique elements (IE no quantizing)


L = length(x);
H_xy2 = mutual(hist2(x,y,nu_bin));
hist_xy = hist2(x,y,nu_bin)+eps;

p_xy = hist_xy/L;
p_y = sum(p_xy);
p_x = sum(p_xy,2);
H = sum(sum(p_xy.*log2(p_xy./(p_x*p_y))));