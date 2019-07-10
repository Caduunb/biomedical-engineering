% Apresentação
% Construct observation matrix UU
clearvars; close all; clc;

%% Load data
load('Dados_Fantasia\f2o08m.mat')
ecg = val(2,:);
resp = val(1,:);
gain_o8 = 163.84;
ecg_o8 = ecg(300001:315000)'/gain_o8;
resp_o8 = resp(300001:315000)'/gain_o8;

load('Dados_Fantasia\f2o10m.mat')
ecg = val(2,:);
resp = val(1,:);
gain_o10 = 409.6;
ecg_o8 = ecg(100000:175000)'/gain_o10;
resp_o8 = resp(100000:175000)'/gain_o10;

load('Dados_Fantasia\f2y08m.mat')
ecg = val(2,:);
resp = val(1,:);
gain_y8 = 819.2;
ecg_y08 = ecg(500000:575000)'/gain_y8;
resp_y08 = resp(500000:575000)'/gain_y8;

load('Dados_Fantasia\f2y10m.mat')
ecg = val(2,:);
resp = val(1,:);
gain_y10 = 409.6;
ecg_y10 = ecg(800000:875000)'/gain_y10;
resp_y10 = resp(800000:875000)'/gain_y10;
%% Set Parameters
N = length(ecg_o8);
p = round(N/5);
T = 0.004; % time step
UU = zeros(N,p);

%% Regressor matrix U
for i=1:p
    if i==1
        UU(:,1)=resp_o8;
    else
        UU(:,i)= [zeros(i-1,1)' resp_o8(1:N-i+1)']';
    end
end

UU = T*UU;

%% Impulse response (h(t))
% Construct autocorrelation matrix
AA = UU'*UU;
b = UU'*ecg_o8;
% Compute estimate of h
h = AA\b;

plot(h);

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