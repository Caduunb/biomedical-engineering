function [X, D] = gen_data4(distance,class_range,npts)
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
if nargin < 3
    npts = 200;                     % Default npts
end
if nargin < 2 || isempty(class_range) == 1
    class_range = [0 1];
end    

distance = distance/2;
D = ones(npts,4)*class_range(1);          %Initialize class specifier
R = randn(npts,2)/2;
for i = 1:4:npts
    X(i,1) = R(i,1) - distance;  % Generate symmetric class distributons
    X(i,2) = R(i,2) - distance; 
    D(i,1) = class_range(2);
    X(i+1,1) = R(i+1,1) + distance;
    X(i+1,2) = R(i+1,2) - distance;
    D(i+1,2) = class_range(2);
    X(i+2,1) = R(i+2,1) + distance;
    X(i+2,2) = R(i+2,2) + distance;
    D(i+2,3) = class_range(2);
    X(i+3,1) = R(i+3,1) - distance;
    X(i+3,2) = R(i+3,2) + distance;
    D(i+3,4) = class_range(2);
end
%
% Plot points  Removed to eliminate extra plots
%     clf; hold on;
%     for i = 1:npts
%         if D(i,1) == 1
%             plot(X(i,1),X(i,2),'sk','MarkerFaceColor','b');
%         elseif D(i,2) == 1
%             plot(X(i,1),X(i,2),'ok','MarkerFaceColor','r');
%         elseif D(i,3) == 1
%             plot(X(i,1),X(i,2),'dk','MarkerFaceColor','g');
%         elseif D(i,4) == 1
%                 plot(X(i,1),X(i,2),'vk','MarkerFaceColor','y');
%         end
%     end