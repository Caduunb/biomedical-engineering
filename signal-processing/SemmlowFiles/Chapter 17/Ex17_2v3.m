% Example 17.2 Single neuron example. Shows the ability of a single neuron to perform a
%   classifcation of two gaussian distributions with wide of 
%   seperability.  Plot two-variable data. 
% Uses the lms learning algorithm
%
clear all; close all;
alpha = .5;
[X, d] = gen_data2(6,45,'l');  %Generate data
% Set up initial weights and bias
[r,c] = size(X);
w = (rand(c,1) - .5)*.25;         % Initialize weights and bias to small random number
b = (rand - .5)*.25;              % Set bias 
last_mse = 2;                   % Set initial mse error high
for k = 1:100 
   for k1 = 1:20
       [w,b] = lms_learn(X,d,alpha,w,b); % Multiple epochs
   end
   [mse, sensitivity, specificity] = net_eval(X,d,w,b); % Evaluate neuron performance
   if abs(last_mse - mse) < .00001
       disp('Converged')                    
       break;
   end
   last_mse = mse;
   disp([mse sensitivity specificity])
end
clf;
[mse, sensitivity, specificity] = net_eval(X,d,w,b); % Evaluate neuron performance
title(['Sensitivity: ',num2str(sensitivity,2),'% Specificity: ',num2str(specificity,2),'%'],'FontSize',14);
disp(['[Number epochs: ',num2str(k*k1)])




