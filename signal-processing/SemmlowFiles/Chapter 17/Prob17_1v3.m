% Problem 17.1 Load the data file prob15_1.mat which contains training
%   set data Xt, and dt and a larger test set, X and d. These data sets
%   were generated from two gaussian distributions and have some overlap
%   (i.e., they are not linearly separable).  Use the training set data to
%   train a single neuron with a sigmoid nonlinearity. Train using
%   lms_learn with an alpha = 0.1 and train until the change in error is
%   less than 0.001 or 2000 epochs whichever is less.  After training use
%   net_eval again with the test data set to evaluate the net.  Show the
%   final boundary and the sensitivity and specificity (it is convenient to
%   put the sensitivity and specificity in the title of the test set data
%   plot). Repeat using a minimum error change of 0.0001.  Does further
%   training improve the classifier’s performance?
%
clear all; close all;
load prob17_1;      % Get data
alpha = .01;
% Set up initial weights and bias
[r,c] = size(X);
w = (rand(c,1) - .5)*.01;       % Initialize weights and bias to small random number
b = (rand - .5)*.01;              % Set bias 
last_mse = 2;                      % Set initial mse error high
for k = 1:500 
   for k1 = 1:20
       [w,b] = lms_learn(Xt,dt,alpha,w,b); % Multiple epochs
   end
   mse = net_eval(X,d,w,b);         % Evaluate neuron behavior
   if abs(last_mse - mse) < 0.001  % Modifiy and  rerun
       disp('Converged')                    
       break;
   end
   last_mse = mse;
   disp(mse)
end
disp(['[Number epochs: ',num2str(k*k1)])
figure;
[mse, sensitivity, specificity] = net_eval(X,d,w,b);
title(['Sensitivity: ',num2str(sensitivity),'% Specificity: ',num2str(specificity),'%'],'FontSize',14);
% Results should show Sensitivity/Specificity of approx.  90.5% and 94.5%

