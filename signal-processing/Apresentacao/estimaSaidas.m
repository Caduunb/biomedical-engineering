% Estima as saídas convoluindo uma entrada degrau com a resposta ao impulso
% fornecida pelo banco de dados MGH. Adiciona ruído branco às respostas e
% salva os dados em no arquivo MGHsaidas.mat
% autor: Caio E. C. Oliveira
% data:  11 de Julho de 2019

clearvars;
close all;
clc;
gain = 1000;
start = 1000;  % start ahead of signal interferences
T = 0.0027;    % time step
%% Load data 001
figure;
sgtitle('Indivíduo mgh001')
subplot(2,1,1)
load ("Dados_MGH\mgh001m.mat")
h001 = val(7, start:end)/gain;   % resposta ao impulso
h001 = h001';
plot(h001, 'g', 'LineWidth', 2)
ylabel('Resposta ao Impulso (V)')
xlabel('Tempo (s)');

subplot(2,1,2)
u = ones(length(h001), 1);
saida001 = conv(u, h001, 'same');
plot(saida001, 'b', 'LineWidth', 2);
ylabel('Resposta ao Degrau Estimado (V)')
xlabel('Tempo (s)');
%% Load data 007
figure;
sgtitle('Indivíduo mgh007')

subplot(2,1,1)
load ("Dados_MGH\mgh007m.mat")
h007 = val(7, start:end)/gain;   % resposta ao impulso
h007 = h007';
plot(h007, 'g', 'LineWidth', 2)
ylabel('Resposta ao Impulso (V)')
xlabel('Tempo (s)');

subplot(2,1,2)
u = ones(length(h007), 1);
saida007 = conv(u, h007, 'same');
plot(saida007, 'b', 'LineWidth', 2);
ylabel('Resposta ao Degrau Estimado (V)')
xlabel('Tempo (s)');
%% Load data 097
figure;
sgtitle('Indivíduo mgh097')

subplot(2,1,1)
load ("Dados_MGH\mgh097m.mat")
h097 = val(7, start:end)/gain;   % resposta ao impulso
h097 = h097';
plot(h097, 'g', 'LineWidth', 2)
ylabel('Resposta ao Impulso (V)')
xlabel('Tempo (s)');

subplot(2,1,2)
u = ones(length(h097), 1);
saida097 = conv(u, h097, 'same');
plot(saida097, 'b', 'LineWidth', 2);
ylabel('Resposta ao Degrau Estimado (V)')
xlabel('Tempo (s)');
%% Load data 201
figure;
sgtitle('Indivíduo mgh201')

subplot(2,1,1)
load ("Dados_MGH\mgh201m.mat")
h201 = val(7, start:end)/gain;   % resposta ao impulso
h201 = h201';
plot(h201, 'g', 'LineWidth', 2)
ylabel('Resposta ao Impulso (V)')
xlabel('Tempo (s)');

subplot(2,1,2)
u = ones(length(h201), 1);
saida201 = conv(u, h201, 'same');
plot(saida201, 'b', 'LineWidth', 2);
ylabel('Resposta ao Degrau Estimado (V)')
xlabel('Tempo (s)');
%% Guardas as saidas em .mat
sigma = 10;
ruido(:,:,1) = normrnd(0, sigma);
ruido(:,:,2) = normrnd(0, sigma);
ruido(:,:,3) = normrnd(0, sigma);
ruido(:,:,4) = normrnd(0, sigma);

saida(:,:,1)   = saida001;
saida(:,:,2)   = saida007;
saida(:,:,3)   = saida097;
saida(:,:,4)   = saida201;

for j=1:4
    saida_ruido(:,:,j)   = saida(:,:,j) + ruido(:,:,j);
end

h_dado(:,:,1)   = h001;
h_dado(:,:,2)   = h007;
h_dado(:,:,3)   = h097;
h_dado(:,:,4)   = h201;
%% Guardar dados das saidas com ruido branco.
save ('MGHsaidas.mat', 'h_dado', 'saida', 'saida_ruido', 'T')