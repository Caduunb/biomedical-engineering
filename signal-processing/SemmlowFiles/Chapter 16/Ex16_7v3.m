% Example 16.7  Example of using the Support Vector Machine software
% on a data set that is nonlinearly seperable. A polynomial kernal is 
% used with an order of 2
%
clear all; close all;
global p1;
p1 = 2;                     % Kernal order
ker = 'poly';               % Kernal type
% [Xt,dt] = gen_data2(4,45,'c',[-1 1],100);  % Generate training set
% [X,d] = gen_data2(4,45,'c',[-1 1],400); % Generate test set
% save Ex16_7.mat Xt dt X d;
load Ex16_7.mat
[nsv,alpha,b] = svc(Xt,dt',ker);
svcplot(Xt,dt',ker,alpha,b);
xlabel('x_1','FontSize',14); ylabel('x_2','FontSize',14);
% Evaluate the test set data
figure;
y = svcoutput(Xt,dt',X,ker,alpha,b);           % Apply classifier
[Sensitivity, Specificity] = plot_results(X,d,y,0);    % Plot data
svcbound(Xt,dt',ker,alpha,b);                  % Plot boundaries 
title(['Sensitivity ',num2str(Sensitivity),'%  Specificity ', num2str(Specificity),'%'],'FontSize',12);


