% Program "sss_llm.m" to produce the solution to the state-space formulation
%    of the linear lung mechanics model to a unit step input in Pao (u)

% Parameter values of model
L = 0.01 ;  %inertance in units of cm H2O s2/L
C = 0.1 ;   %compliance in units of L/cm H2O
R = 1 ;     %resistance in units of cm H2O s/L

A = [0  1; -1/L/C  -R/L];
B = [0  1/L/C]';
t = [0:0.005:0.8]';
u = ones(size(t));

% Construct the system using state-space formulation
Hs = ss(A,B,[1 0],0);

% Solve state space equation using lsim and plot results
y = lsim(Hs, u, t);
plot(t, u, t, y)
