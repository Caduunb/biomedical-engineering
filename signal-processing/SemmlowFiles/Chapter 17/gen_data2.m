function [X d] = gen_data2(distance, angle,type_data,class,N)
%  Function to generate two-variable classification data sets.
%  The data are from two classes with Gaussian distribution.
%  The means of each class are spaced distance apart and relative
%       positions specified by angle. Both classes have the same 
%       standard deviation (1). 
%   Outputs:
%       X   an N by 2 array containing two-variable 
%       d   the asssociated class.
%   Inputs:
%       distance is the Euclidian distance between the class means.
%       angle specifes the relative positions in degrees (default = 30).
%       type: 'l(inear)' Two Gaussian distributions (default)
%             'q(uad)' Multiple Gaussian in quadratic arrangement
%             'd'(iagonal)  Two classes across diagonal
%             'o'(verlap)  Both sets have same means but different
%             distributions
%             'c'(onvex)   Gaussian data surounded on three sides
%             's'(urrond) Gaussian data surrounded on all sides
%       class: number for output class (usually either -1,1 or 0,+1 default)
%       N:  number of points (default = 100)
% 
clear R X d; 
if nargin < 5
    N = 100;                     % Default npts
end
if nargin < 4 || isempty(class)
    class = [0 1] ;                  % Default
end
if nargin < 3 || isempty(type_data)
    type_data = 'l';                % Default
end
if nargin < 2  || isempty(angle)
    angle = 30;
end
nu_clusters = ceil(N/10);        % Number of cluster for nonlinear distribution
angle = angle*2*pi/360;             % Convert to radians
x1 = distance*cos(angle) + 1;
y1 = distance*sin(angle) + 1;
if type_data(1) == 'l'
    R = randn(N,2);
    for i = 1:2:N;
        X(i,:) = R(i,:) + 1;  %Generate first class centered at 1.0
        d(i) = class(1);
        X(i+1,1) = R(i+1,1) + x1;
        X(i+1,2) = R(i+1,2) + y1;
        d(i+1) = class(2);
    end
elseif type_data(1) == 'q'
    index = 1;
    npts1 = fix(N/nu_clusters);
    for i = 1:nu_clusters          %Generate 10 clusters with a smaller distribution
        R = randn(npts1,2)/4;      %Decrease distribution
        for j = 1:2:npts1;
            k = j + index - 1;
            y_bias = ((i-5)^2)/10;
            x_bias = (i - 1)/3;
            X(k,1) = R(j,1) + 1 + x_bias;
            X(k,2) = R(j,2) + 1 + y_bias;
            X(k+1,1) = R(j+1,1) + 1 + x_bias;       %Angle = 90 deg
            X(k+1,2) = R(j+1,2) + 1 + y_bias + distance;
            d(k) = class(1);
            d(k+1) = class(2);
        end
        index = index + 10;
    end
elseif type_data(1) == 'd'  %Diagonal
    R = randn(N,2);
    for i = 1:4:N
        X(i,:) = R(i,:) + 1;  %Generate first class centered at 1.0
        d(i) = class(1);
        X(i+1,1) = R(i+1,1) + 1 + distance;
        X(i+1,2) = R(i+1,2) + 1;
        d(i+1) = class(2);
        X(i+2,1) = R(i+1,1) + 1 + distance;
        X(i+2,2) = R(i+1,2) + 1 + distance;
        d(i+2) = class(1);
        X(i+3,1) = R(i+1,1) + 1;
        X(i+3,2) = R(i+1,2) + 1 + distance;
        d(i+3) = class(2);
    end
elseif type_data(1) == 'c'
    R = randn(N,2);
    for i = 1:4:N
        X(i,:) = R(i,:) + 1;  %Generate first class centered at 1.0
        d(i) = class(2);
        X(i+1,1) = R(i+1,1) + 1 + distance
        X(i+1,2) = R(i+1,2) + 1;
        d(i+1) = class(1);
        X(i+2,1) = R(i+1,1) + 1 + distance;
        X(i+2,2) = R(i+1,2) + 1 + distance;
        d(i+2) = class(1);
        X(i+3,1) = R(i+1,1) + 1;
        X(i+3,2) = R(i+1,2) + 1 + distance;
        d(i+3) = class(1);
    end
    elseif type_data(1) == 's'
    R = randn(N,2);
    for i = 1:4:N
        X(i,:) = R(i,:) + distance;  %Generate first class centered at 2.0
        d(i) = class(2);
        X(i+1,1) = R(i+1,1)*3 + distance; 
        X(i+1,2) = R(i+1,2) + 2* distance;
        d(i+1) = class(1);
        X(i+2,1) = R(i+1,1);
        X(i+2,2) = R(i+1,2)*3 + distance;
        d(i+2) = class(1);
        X(i+3,1) = R(i+1,1)*1.5 + 2 *distance;
        X(i+3,2) = R(i+1,2)*3 + .5 * distance;
        d(i+3) = class(1);
    end
elseif type_data(1) == 'o'  %Overlap
    R = randn(N,2);
    for i = 1:2:N
        X(i,1) = R(i,1) + 1;  %Generate first class centered at 1.0
        X(i,2) = R(i,2)*distance + 1
        d(i) = class(1);
        X(i+1,1) = R(i+1,1)*distance + 1;
        X(i+1,2) = R(i+1,2) + 1;
        d(i+1) = class(2);
    end
else
    disp('ERROR in type_data')
    return
end
% Plot data Removed to reduce number of plots
% clf; hold on;
% [r,c]= size(X);
% for i = 1:r
%     if d(i) > 0
%         plot(X(i,1),X(i,2),'sqk','LineWidth',1);
%     else
%         plot(X(i,1),X(i,2),'ok','MarkerFaceColor','c');
%     end
% end
% xlabel('x1','FontSize',14); ylabel('x2','FontSize',14)

