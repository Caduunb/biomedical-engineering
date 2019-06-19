function [y,x]=henon(xint,yint,N,a,b)
%  This function creates two N length vectors y and x, where xint and yint
% are the initial values, and a and b are the Henon map parameters
% the canonical chaotic parameter values are a = 1.4 and b = 0.3
x=[xint,zeros(1,N-1)];
y=[yint,zeros(1,N-1)];
for i=1:N
    x(i+1)=y(i)+1-a*x(i).^2;
    y(i+1)=b*x(i);
end