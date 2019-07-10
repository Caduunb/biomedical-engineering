% Cria banco de dados
clearvars; close all; clc;

interval = 500;
sigma    = 2;           % standard deviation
ruido = sigma*randn(interval, 1);

load('Dados_Fantasia\f2o08m.mat')
ecg = val(2,:);
resp = val(1,:);
gain_o8 = 163.84;
ecg_o8 = ecg(300001:300001 + interval - 1)'/gain_o8;
resp_o8 = resp(300001:300001 + interval - 1)'/gain_o8;

load('Dados_Fantasia\f2o10m.mat')
ecg = val(2,:);
resp = val(1,:);
gain_o10 = 409.6;
ecg_o10 = ecg(100001:100001 + interval - 1)'/gain_o10;
resp_o10 = resp(100001:100001 + interval - 1)'/gain_o10;

load('Dados_Fantasia\f2y08m.mat')
ecg = val(2,:);
resp = val(1,:);
gain_y8 = 819.2;
ecg_y8 = ecg(500001:500001 + interval - 1)'/gain_y8;
resp_y8 = resp(500001:500001 + interval - 1)'/gain_y8;

load('Dados_Fantasia\f2y10m.mat')
ecg = val(2,:);
resp = val(1,:);
gain_y10 = 409.6;
ecg_y10 = ecg(800001:800001 + interval - 1)'/gain_y10;
resp_y10 = resp(800001:800001 + interval - 1)'/gain_y10;


% Adiciona ruído aos sinais
ecg_y8 = ecg_y8 + ruido;
ecg_y10 = ecg_y10 + ruido;
ecg_o8 = ecg_o8 + ruido;
ecg_o10 = ecg_o10 + ruido;

% Save
save ('dadosApresentacao', 'ecg_o8', 'ecg_o10', 'resp_o8', 'resp_o10', 'ecg_y8', 'ecg_y10', 'resp_y8', 'resp_y10');
save ('dadosApresentacaoRuido', 'ecg_o8ruido', 'ecg_o10ruido', 'resp_o8ruido', 'resp_o10ruido', 'ecg_y8ruido', 'ecg_y10ruido', 'resp_y8ruido', 'resp_y10ruido');
