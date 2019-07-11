%% Calculate the parameters of the system dynamics plus filter, 
% author: Caio E C Oliveira
% date:   July 11, 2019.
% Perform a 2order system identification.

clearvars;
close all;
clc;

%dados = plotDadosQT(file); close all;
load dadosFisiologicos.mat

T= 0.004;             % discrete time step from Fantasia database
%% Matrices definition
input =  ones(5000, 1);      % system input column vectors
output = resp_o8(:, 1);       % system output column vectors
%% Calculate theta(1:3)
A = [output(2:length(output) - 1), output(1:length(output)-2)];
A = [A, input(1:(length(input)-2))];
Y = output(3:length(output));

theta = inv(A'*A)*A'*Y;

a = (2 - theta(1))/T;
b = (a*T - 1 - theta(2)) / T^2;
c = theta(3)/T^2;

disp ('System type: c/(s^2 + s*a + b)');
disp(['a = ', num2str(a), ';', 'b = ', num2str(b), ';', 'c = ', num2str(c)])
close all;
%% Simulation
time  = 0:T:(length(input)-1)*T;
g = tf([c], [1 a b]);
sys2order = lsim (g, input, time);

figure;
plot(time, output, 'k', time, sys2order, 'g', 'LineWidth', 2);
legend('Saida Medida', 'Resposta Simulada');
