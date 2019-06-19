function [X, d] = gen_bowtie(dist,class,npts)
%  Function to generate two-variable classification data sets.
%  The data are from two classes with a "bow tie" distribution.
%   Outputs:
%       X is a 100 by 2 array containing two-variable 
%       d is asssociated classification variable.
%   Inputs:
%       dist contrls the seperation between the classes.
%       class: number for output class (usually either 0,1 or -1,+1 default)
%       npts:  number of points (default = 100)
% 
clear R X d; 

if nargin < 3
    npts = 100;
end
if nargin < 2
    class = [-1 1];
end
X = -2 +  4*rand(npts,2);      
for i = 1:npts
    if ((X(i,1)-.5)^2 + X(i,2)^2 > dist) | ((X(i,1)+.5)^2 + X(i,2)^2 > dist)
        d(i) = class(2);
    else
        d(i) = class(1);
    end
end


clf; hold on;
[r,c]= size(X);
for i = 1:r
    if d(i) > 0
        plot(X(i,1),X(i,2),'sqk','LineWidth',1);
    else
        plot(X(i,1),X(i,2),'ok','MarkerFaceColor','c');
    end
end
xlabel('x1','FontSize',14); ylabel('x2','FontSize',14)

