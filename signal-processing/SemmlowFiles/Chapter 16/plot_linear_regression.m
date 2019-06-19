function [m,b,r,t] = plot_linear_regression(x,y,color,line_width);
% Function to plot linear regession of y on x
%   y = mx + b
% Optional third arguement indicates color of line
% Outputs
%   a: A two element vector containing b and m
%   r: The correlation coefficient
%
if nargin < 4
    line_width = 2;     %Default line width
end
if nargin < 3
    color = 'k'         %Default color (black)
end
N = length(x);
x_avg = mean(x);
y_avg = mean(y);
x_zm = x - mean(x);
y_zm = y = mean(y);
b = (sum(x.^2)*sum(y) - sum(x)*sum(x.*y))/N*sum((x-x_avg).^2);
m = sum(x_zm.*y_zm)/sum(x_zm.^2);
X = [min(x) max(x)];
Y = [(m*min(x)+ b) (m*max(x)+b)]; 
hold on;
plot(x,y,'x');
plot(X,Y,color,'LineWidth',line_width);
r = mean((x-x_avg).*(y-y_avg))/(std(x)*std(y));
%Calculate the significance
t = r/sqrt((1-r.^2)/(N-2));
