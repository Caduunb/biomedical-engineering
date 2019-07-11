% Estima a saida impulso por M�nimos Quadrados
clearvars;
close all;
clc;

load ('MGHsaidas.mat')
NOISE_ON = 0;
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
%% Gr�ficos das Respostas ao Impulso dados e estimados
interval = 100;
time = 0:T:(length(h_est)- 1 - 2*interval)*T;

% --- mgh001
j = 1;
figure;
sgtitle('Indiv�duo mgh001')
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
sgtitle('Indiv�duo mgh007')
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
sgtitle('Indiv�duo mgh097')
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
sgtitle('Indiv�duo mgh201')
subplot(2,1,1)
plot(time, h_dado(interval + 1:length(h_est)-interval, 1, j), 'g', 'LineWidth', 2)    % RI dado mgh001
ylabel('RI do banco de dados MGH (V)')
xlabel('Tempo (s)');
subplot(2,1,2)
plot(time, h_est(interval + 1:length(h_est)-interval, 1, j), 'k', 'LineWidth', 2);
ylabel('RI estimada (V)')
xlabel('Tempo (s)');

%% Estimar a resposta ao Degrau com a RI estimada
j = 1;
for j = 1:4
    respDegrau (:,:,j) = conv(entrada,h_est(:,:,j),'same');
    figure
    subplot(2,1,1)
    plot(saida(:,:,j), 'LineWidth', 2);
    ylabel('Saida estimada com o RI dado');

    subplot(2,1,2)
    plot(time, respDegrau(:,:,j));
    ylabel('Saida estimada com o RI estimado');
end
%% Correla��o entre os impulsos estimado e medido
%{
subplot(3,1,3)
hcorr = xcorr(h);
plot(hcorr(interval:end-interval), 'k', 'LineWidth', 2);
ylabel('Resposta ao Impulso estimada por M�nimos Quadrados(V)')
xlabel('Tempo (s)');
%}