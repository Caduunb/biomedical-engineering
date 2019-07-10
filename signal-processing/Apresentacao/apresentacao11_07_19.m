% Apresentação
% Construct observation matrix UU
clearvars; close all; clc;

%% Load data
load ('dadosApresentacao');

%% Set Parameters
N = length(ecg_o8);
p = round(N/5);
T = 0.004; % time step
%UU = zeros(N,p);

%% Regressor matrix U
entrada = [resp_y8, resp_y10, resp_o8, resp_o10];

for i=1:p
    if i==1
        UUy8(:, i)=entrada(:, 1);
    else
        UUy8(:, i)= [zeros(i-1,1)' entrada(1:N-i+1, 1)']';
    end
end
for i=1:p
    if i==1
        UUy10(:, i)=entrada(:, 2);
    else
        UUy10(:, i)= [zeros(i-1,1)' entrada(1:N-i+1, 2)']';
    end
end
for i=1:p
    if i==1
        UUo8(:, i)=entrada(:, 3);
    else
        UUo8(:, i)= [zeros(i-1,1)' entrada(1:N-i+1, 3)']';
    end
end
for i=1:p
    if i==1
        UUo10(:, i)=entrada(:, 4);
    else
        UUo10(:, i)= [zeros(i-1,1)' entrada(1:N-i+1, 4)']';
    end
end
%%
UU = UUo8;
UU = T*UU;
clear i;
%% Impulse response estimate (h(t))
saida       = [ecg_y8, ecg_y10, ecg_o8, ecg_o10];
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