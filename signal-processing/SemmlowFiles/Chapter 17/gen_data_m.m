function [X, d] = gen_data_m(distance,nu_classes,npts)
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
%       distance is the Euclidian distance between the class means.
%       class: number for output class (usually either -1,1 or 0,+1 default)
%       npts:  number of points (default = 200)
% 
clear R X d; close all;
if nargin < 3
    npts = 200;                     % Default npts
end
if nu_classes == 4
    distance = distance/2;
    d = zeros(npts,4);          %Initialize class specifier
    R = randn(npts,2)/2;
    for i = 1:4:npts
        X(i,1) = R(i,1) - distance;  %Generate symmetric class distributons
        X(i,2) = R(i,2) - distance; 
        d(i,1) = 1;
        X(i+1,1) = R(i+1,1) + distance;
        X(i+1,2) = R(i+1,2) - distance;
        d(i+1,2) = 1;
        X(i+2,1) = R(i+2,1) + distance;
        X(i+2,2) = R(i+2,2) + distance;
        d(i+2,3) = 1;
        X(i+3,1) = R(i+3,1) - distance;
        X(i+3,2) = R(i+3,2) + distance;
        d(i+3,4) = 1;
    end
else
    distance = distance/2;
    d = zeros(npts,3);          %Initialize class specifier
    R = randn(npts,2)/2;
    for i = 1:3:npts
        X(i,1) = R(i,1);  %Generate triangular class distributons
        X(i,2) = R(i,2); 
        d(i,1) = 1;
        X(i+1,1) = R(i+1,1) + distance/2;
        X(i+1,2) = R(i+1,2) - distance;
        d(i+1,2) = 1;
        X(i+2,1) = R(i+2,1) - distance/2;
        X(i+2,2) = R(i+2,2) - distance;
        d(i+2,3) = 1;
    end
end
%
% Plot points
    clf; hold on;
    for i = 1:npts
        if d(i,1) == 1
            plot(X(i,1),X(i,2),'sk','MarkerFaceColor','b');
        elseif d(i,2) == 1
            plot(X(i,1),X(i,2),'ok','MarkerFaceColor','r');
        elseif d(i,3) == 1
            plot(X(i,1),X(i,2),'dk','MarkerFaceColor','g');
        end
        if nu_classes == 4;
            if d(i,4) == 1
                plot(X(i,1),X(i,2),'vk','MarkerFaceColor','y');
            end
        end
    end