% Apresentação
% Construct observation matrix UU
% autores: Caio Oliveira, Amanda Pereira
% O código realiza a identificação de resposta ao impulso de um modelo
% linear. O  modelo foi retirado, tendo apenas seus parâmetros alterados do código sss_llm.m, do autor Michael
% Khoo, no livro Physiological Control Systems: Analysis, Simulation, and
% Estimation, 2ª edição, John Wiley & Sons, 2018.

clearvars; 
close all; 
clc;
%% Load data
%load ('dadosPhysionet');
%load ('dadosPhysionetRuido');
load ('MGHsaidas.mat')

%{
%% Create linear model 
% Program "sss_llm.m" to produce the solution to the state-space formulation
%    of the linear lung mechanics model to a unit step input in Pao (u)

% Parameter values of model
L = 0.01 ;  % inertance in units of cm H2O s2/L
C = 0.1 ;   % compliance in units of L/cm H2O
R = 1 ;     % resistance in units of cm H2O s/L

T = 0.004;
A = [0  1; -1/L/C  -R/L];
B = [0  1/L/C]';
t = [0:0.004:0.8]';
u = ones(size(t));
%}
%% Set Parameters
N = length(saida001);
p = round(N/5);
UU = zeros(N,p);        % aloca memória
entrada = ones(N, 1);
%% Regressor matrix U
for i=1:p
    if i==1
        UU(:, i)=entrada(:, 1);
    else
        UU(:, i)= [zeros(i-1,1)' entrada(1:N-i+1, 1)']';
    end
end
%%
UU = T*UU;
clear i;

%% Impulse response estimate (h(t))
%saida_ruido = 0;
AA = UU'*UU;
b = UU'*saida(:, 3);
% Compute estimate of h
h = inv(AA)*b;       % h = inv(U'*U)*U'*y

plot(h);

%% Automação do problema
%{
% Compute estimated standard errors of h, hse
e = y - UU*h;

sigma = std(e);

AAinv = inv(AA);

hse = zeros(size(h));

for i = 1:p
    hse(i) = sqrt(AAinv(i,i))*sigma;
end
%}