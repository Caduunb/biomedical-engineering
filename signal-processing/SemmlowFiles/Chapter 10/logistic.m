function [x]=logistic(r,N,xint)
%[x]=logistic(A,step,N,xint)
% Calculates the logistic equation where r is the driving force paramater,
% step is the step size, N is the number of step and xint is the inital value


x=zeros(1,N);
x(1)=xint;
    for n=1:(N-1);
       x(n+1)=r*x(n)*(1-x(n));
    end