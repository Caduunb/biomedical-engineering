function y=delay_emb(x,m,tau);
% Usage:  y = delay_emb(x,m,tau)
% delay_emb performs delay embedding on input vector x.  Output y is
% composed of m vectors made of delayed versions of x, where the delay is
% tau samples.

L=length(x)-(m-1)*tau;
y=zeros(m,L);
for i=1:m
    a=(1+tau*(i-1));
    b=(a+L-1);
    y(i,1:L)=x(a:b);
end
y=y';