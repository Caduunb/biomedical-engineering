function [X, d] = gen_data(npts,distance)
% [X, d] = gen_data(npts,distance)
%  Function to generate two-variable classification data sets.
%  The data are from four classes with Gaussian distribution.
%  The means of each class are spaced distance apart in an approx.
%       square configuration. Both classes have the same 
%       standard deviation (1). 
%   Outputs:
%       X is a 200 by 2 array containing two-variable 
%       d is asssociated classification variable specifed 
%           with a 1.0 in the associated vector locaton.
%   Inputs:
%      npts        (default 400);
%      distance   (default 1.5) 
%  Angle = 45 deg. Not flexible since used for some problems only
% 
if nargin < 2
   distance = 1.5;     % Default distance
end
if nargin < 1
    npts = 400;        % Default npts
end
% CLusters 45 deg appart 
d = zeros(npts,1);          %Initialize class specifier
R = randn(npts,4)/2;
for i = 1:2:npts
        X(i,:) = R(i,:) + 1;  %Generate first class centered at 1.0
        X(i+1,1) = R(i+1,1) + distance;
        X(i+1,2) = R(i+1,2) + distance;
        X(i+1,3) = R(i+1,3) + distance;
        X(i+1,4) = R(i+1,4) + distance;
        d(i+1) = 1;
    end
