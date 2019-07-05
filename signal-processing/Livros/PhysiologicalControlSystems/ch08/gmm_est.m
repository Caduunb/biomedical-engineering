% Program "gmm_est.m" to estimate the parameters of the glucose dynamics portion 
%   of the Bergman Glucose-Insulin Minimal Model
%   using the Nelder-Mead simplex algorithm

% First, generate "data" by executing SIMULINK file "gmm_sim.mdl"
%  The "data" to be used here will be left in workspace
% Alternatively, load the MAT file: "Data_gmm.mat"

global t x u z xpred Nresamp N

% Check on availability of data
ians = input(' Have you run gmm_sim.mdl or loaded data_gmm.mat? No=0, Yes=1 >>');
if ians==0
   return;
end;

% Resample tout and y so that sampling interval is decreased from 1 min to 0.01 min
N=length(tout);
u=interp(y,100);
t=[0:0.01:tout(N)]';
Nresamp = 100*(N-1) + 1;
u=u(1:Nresamp);

% Input initial guesses of parameters to be estimated
p_init = [0  0  0  0  0];
p_init(1) = input(' Enter initial guess of parameter p1 >>');
p_init(2) = input(' Enter initial guess of paramater p2 >>');
p_init(3) = input(' Enter initial guess of parameter p3 >>');
p_init(4) = input(' Enter initial guess of paramater p4 >>');
p_init(5) = x(1)/x(1); %Last parameter = normalized initial glucose concn

% Perform optimization to minimize the objective function J
%    defined by the function "fn_gmm"
% options(1)=1;
% [p,options] = fmins('fn_gmm',p_init,options,[]);
options=optimset('Display','iter');
[p,Jmin] = fminsearch('fn_gmm',p_init,options);

plot(tout,x,tout,xpred);

disp(' '); disp('  Final Parameter Values :');
disp(p);
% disp(' '); disp('  Total Number of Iterations:');
% disp(options(10));

