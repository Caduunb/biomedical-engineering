function J=fn_rlc(params);
%  This function generates a vector ypred, containing the values of the
%   model prediction in response to input forcing (given in vector u)
%   and for given parameter values of R, L and C

global t u ypred y


R=params(1);L=params(2); C=params(3);
num=[1];
den=[L*C  R*C  1];
Hs=tf(num,den);
ypred=lsim(Hs,u,t);
e=y-ypred;
J= sum(e.^2);