%  Program "popt_llm.m" to illustrate the use of optimization for
%   estimating the parameters of the state-space formulation of
%   the linear lung mechanics model
%  Updated to use "fminsearch"

global t u ypred  y
load data_llm.mat

% Input initial guesses for the parameters to be estimated
theta_init=[0  0]'; theta=[0  0]';
theta_init(1)=input(' Enter initial value of 1st parameter >>');
theta_init(2)=input(' Enter initial value of 2nd parameter >>');

% Perform optimization to minimize the objective function J
%    defined by the function "fn_llm"

options=optimset('Display','iter');
[theta,Jmin] = fminsearch('fn_llm',theta_init,options);

disp(' '); disp('  Final Parameter Values :');
disp(theta);

