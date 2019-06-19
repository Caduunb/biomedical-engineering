function H_xy = mutual(hist_xy)
% H_xy = mutual(hist_xy)
% Function to determine the information in a signal
% Input
%   hist_xy     the joint histogram of the x and y series
% Output
%   H_xy        the mutual information, using equation 11.3

hist_xy = hist_xy+eps;
p_xy = (hist_xy)/sum(sum(hist_xy));
p_y = sum(p_xy);
p_x = sum(p_xy,2);
H_xy = sum(sum(p_xy.*log2(p_xy./(p_x*p_y))));