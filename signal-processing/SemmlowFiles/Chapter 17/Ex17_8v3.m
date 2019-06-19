% Example 17.8.  Generate a three-variable training set (N = 100) 
%  and use it to train a single neuron.  Use ‘net_eval.m’ to plot
%  the data including the decision plane and give the sensitivity
%  and specificity
clear all; close all;
alpha = .05;
[X, d] = gen_data3D(6, 45);  %Generate data
[r,c] = size(X);
w = (rand(c,1) - .5)/4;         % Initialize weights and bias 
b = (rand - .5)/4;              % Set bias 
last_mse = 2;
for k3 = 1:300
   for k1 = 1:10
       [w,b] = lms_learn(X,d,alpha,w,b); %Multiple epochs
   end
   mse = net_eval(X,d,w,b);    % Evaluate neuron
   if abs(last_mse - mse) < .00001 
       disp('Delta error minimum')
       break;
   end
   last_mse = mse;
   disp(mse)
end
figure;
[mse, Sensitivity, Specificity] = net_eval(X,d,w,b);    % Evaluate neuron
title(['Sensitivity: ',num2str(Sensitivity),'% Specificity: ',num2str(Specificity),'%'],'FontSize',14);
view([-69 26]);
