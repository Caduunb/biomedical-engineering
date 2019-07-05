%  Function "Fn_llm" to generate criterion function (J) values for different
%   combinations of parameter values in the state-space formulation of the
%   linear lung mechanics model
function J=fn_llm(theta)
global t u ypred  y
A = [0  1; -theta(1)  -theta(2)];
B = [0  theta(1)]';
Hs=ss(A,B,[1 0],0);
ypred=lsim(Hs,u,t);
e=y-ypred;
J= sum(e.^2);


