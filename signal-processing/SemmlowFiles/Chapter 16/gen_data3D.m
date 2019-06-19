function [X, d] = gen_data3D(distance, angle,type,class,npts)
%  Function to generate three-variable classification data sets
%  The data are from two classes with a Gaussian distribution.
%  The means of each class are spaced distance apart and relative
%       positions specified by angle. Both classes have the same 
%       standard deviation (1). 
%   Outputs:
%       X is a 100 by 2 array containing two-variable 
%       Y is asssociated classification variable.
%   Inputs:
%       distance is the Euclidian distance between the class means.
%       angle specifes the relative positions in degrees.
%       type specifies the distribution only 'l' and 'd' supported
%       class: Number for output class (default 0 and 1)
%       npts: nuber of points (default = 100)
%
clear R X d; close all;
distance = distance/3;      % Scale distance to match two-dimensional data 
nu_clusters = 10;           % Number of cluster for nonlinear distribution
if nargin < 5
    npts = 100;
end
if nargin < 4
    class = [0 1];
end
if nargin < 3
    type = 'l';
end
angle = angle*2*pi/360;             %Convert to radians
x1 = distance*cos(angle) + 1;
y1 = distance*sin(angle) + 1;
z1 = distance*sin(angle) + 1;
if type == 'l'
    R = randn(npts,3)/2;
    for i = 1:2:npts
        X(i,:) = R(i,:) + 1;  %Generate first class centered at 1.0
        d(i) = class(1);
        X(i+1,1) = R(i+1,1) + x1;
        X(i+1,2) = R(i+1,2) + y1;
        X(i+1,3) = R(i+1,3) + z1;
        y(i+1) = class(2);
    end
elseif type == 'd'
    R = randn(npts,3)/2;
    for i = 1:4:npts
        X(i,:) = R(i,:) + distance;  %Generate first class centered at 1.0
        d(i) = class(1);
        X(i+1,1) = R(i+1,1) + distance;
        X(i+1,2) = R(i+1,2) + distance;
        X(i+1,3) = R(i+1,3) - distance;
        d(i+1) = class(2);
        X(i+2,1) = R(i+2,1) - distance;
        X(i+2,2) = R(i+2,2) - distance;
        X(i+2,3) = R(i+2,3) + distance;
        d(i+2) = class(2);
        X(i+3,:) = R(i+3,:) - distance
        d(i+3) = class(1);
    end
end
figure; hold on;
for i = 1:npts
    if d(i) == 1
        plot3(X(i,1),X(i,2),X(i,3),'ks','MarkerFaceColor','b');
    else
         plot3(X(i,1),X(i,2),X(i,3),'ko','MarkerFaceColor','r');
    end
end
view(3); grid on; view([-40,20]);

