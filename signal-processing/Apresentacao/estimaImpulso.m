% Estima a saida impulso por Mínimos Quadrados
clearvars;
close all;
clc;

load ('MGHsaidas.mat')
NOISE_ON = 1;
%% Set Parameters
if (NOISE_ON == 1)
    saida = saida_ruido;
end
N = length(saida);
p = round(N/5);
UU = zeros(N,p); % allocating memory
entrada = ones(N,1);
%% Regressor matrix U
for i=1:p
    if i==1
        UU(:, i)=entrada(:, 1);
    else
        UU(:, i)= [zeros(i-1,1)' entrada(1:N-i+1, 1)']';
    end
end
clear i;
%%
UU = T*UU;
%% Impulse response estimate (h(t))
AA = UU'*UU;
for j = 1:4
    b(:,:,j) = UU'*saida(:, :, j);
    h_est(:,:,j) = AA\b(:,:,j);         % RI_estimada = inv(U'*U)*U'*y 
end
clear j;
%% Gráficos das Respostas ao Impulso dados e estimados
interval = 100;
time = 0:T:(length(h_est)- 1 - 2*interval)*T;

% --- mgh001
j = 1;
figure;
sgtitle('Indivíduo mgh001')
subplot(2,1,1)
plot(time, h_dado(interval + 1:length(h_est)-interval, 1, j), 'g', 'LineWidth', 2)    % RI dado mgh001
ylabel('RI do banco de dados MGH (V)')
xlabel('Tempo (s)');
subplot(2,1,2)
plot(time, h_est(interval + 1:end-interval, 1, j), 'k', 'LineWidth', 2);
ylabel('RI estimada (V)')
xlabel('Tempo (s)');

% --- mgh007
j = 2;
figure;
sgtitle('Indivíduo mgh007')
subplot(2,1,1)
plot(time, h_dado(interval + 1:length(h_est)-interval, 1, j), 'g', 'LineWidth', 2)    % RI dado mgh001
ylabel('RI do banco de dados MGH (V)')
xlabel('Tempo (s)');
subplot(2,1,2)
plot(time, h_est(interval + 1:end-interval, 1, j), 'k', 'LineWidth', 2);
ylabel('RI estimada (V)')
xlabel('Tempo (s)');

% --- mgh097
j = 3;
figure;
sgtitle('Indivíduo mgh097')
subplot(2,1,1);
plot(time, h_dado(interval + 1:length(h_est)-interval, 1, j), 'g', 'LineWidth', 2)    % RI dado mgh001
ylabel('RI do banco de dados MGH (V)')
xlabel('Tempo (s)');
subplot(2,1,2);
plot(time, h_est(interval + 1:length(h_est)-interval, 1, j), 'k', 'LineWidth', 2);
ylabel('RI estimada (V)');
xlabel('Tempo (s)');

% --- mgh201
j = 4;
figure;
sgtitle('Indivíduo mgh201')
subplot(2,1,1)
plot(time, h_dado(interval + 1:length(h_est)-interval, 1, j), 'g', 'LineWidth', 2)    % RI dado mgh001
ylabel('RI do banco de dados MGH (V)')
xlabel('Tempo (s)');
subplot(2,1,2)
plot(time, h_est(interval + 1:length(h_est)-interval, 1, j), 'k', 'LineWidth', 2);
ylabel('RI estimada (V)')
xlabel('Tempo (s)');

%% Resposta ao Degrau com a RI estimada
j = 1;
time = 0:T:(length(saida) - 1)*T;
for j = 1:4
    respDegrau (:,:,j) = conv(entrada,h_est(:,:,j),'same');
    figure
    subplot(2,1,1)
    plot(time, saida(:,:,j), 'LineWidth', 2);
    ylabel('Resposta ao degrau para a RI dado');
    xlabel('Tempo (s)');

    subplot(2,1,2)
    plot(time, respDegrau(:,:,j), 'LineWidth', 2);
    ylabel('Resposta ao degrau para a RI estimado');
    xlabel('Tempo (s)');
end
%% Correlação entre os impulsos estimado e medido
%{
subplot(3,1,3)
hcorr = xcorr(h);
plot(hcorr(interval:end-interval), 'k', 'LineWidth', 2);
ylabel('Resposta ao Impulso estimada por Mínimos Quadrados(V)')
xlabel('Tempo (s)');
%}