%% Calculate the parameters of the first order tranfer function of the actuator
% author: Caio E C Oliveira
% date:   June 2, 2019.
% Uses the function plotDadosQT.m for showing plots of data and also for loading it into the script.  

%clearvars; 
close all; 
clc;

file = 'q';
if (strcmp(file, 'Q') || strcmp(file, 'q'))
    file = 'dadosQ';
elseif(strcmp(file, 'T') || strcmp(file, 't'))
    file = 'dadosT';
end

datasize = length(dados);
time_step= dados(1,2) - dados(1,1);             % discrete time step
disp(['Data size: ', num2str(size(dados)), ';', ' Time Step: ', num2str(time_step), ';']);
 
%% Defining Matrices
entrada = (dados(4, 1:datasize-1))';      % input R from r1 to rn-1 as a column vector
saida   = (dados(3, 1:datasize-1))';      % actuator output Y from y1 to yn-1 as a column vector
Y       = (dados(3, 2:datasize))';        % output Y as a column vector from y2 to yn

A       = [saida, entrada];                   % column matrix
disp(['A matrix size: ', num2str(size(A)), ' First column: actuator output; Second column: system input']);
disp(['Y matrix size: ', num2str(size(Y))]);

%% Theta calculation
theta = (A'*A)\A'*Y;

a = (1 - theta(1))/time_step;
b = theta(2)/time_step;

disp ('System type: b/(s + a)');
disp (['a value: ', num2str(a), ';', ' b value: ', num2str(b), ';']);

%% Simulacao do sistema
sys = tf([b],[1 a]);
saida_atuador = dados(3, :);
entrada_sistema = dados(4, :);

t = dados(1,:);
ye = lsim(sys, entrada_sistema, t);

figure;
hold on;
plot(t, saida_atuador, '--k', 'LineWidth', 2);
plot(t, ye, '-g', 'LineWidth', 1);
legend ('Saída do Atuador', 'Saída estimada');
