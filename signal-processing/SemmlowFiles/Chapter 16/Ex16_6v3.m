% Example 16.6  Example of using the Support Vector Machine software
% on a data set that is not linearly seperable
%
clear all; close all;
[Xt,dt] = gen_data2(3,45,[],[-1 1]);  % Generate linearly seperable data
[X,d] = gen_data2(3,45,[],[-1 1],400);  % Generate linearly seperable data
[nsv,alpha,b] = svc(Xt,dt','linear');
svcplot(Xt,dt','linear',alpha,b);
xlabel('x_1','FontSize',14); ylabel('x_2','FontSize',14);
figure;
y = svcoutput(Xt,dt',X,'linear',alpha,b);           % Classifier
[Sensitivity, Specificity] = plot_results(X,d,y,0);    % Plot data
svcbound(Xt,dt','linear',alpha,b);                  % Plot boundaries 
xlabel('x_1','FontSize',14); ylabel('x_2','FontSize',14);
title(['Sensitivity ',num2str(Sensitivity),'%  Specificity ', num2str(Specificity),'%'],'FontSize',14);

