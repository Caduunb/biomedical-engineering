function [Sensitivity,Specificity,y] = svm_boundaries(Xt,dt,X,d,ker,L_mult,b)
% [Sensitivity,Specificity] = svm_boundaries(Xt,dt,X,d,ker,L_mult,b)
% Function to plot svm boundaries and test data classes
% Inputs: 
%   Xt     Training data set
%   dt     Training classes
%   X      Test data set
%   d      Test classes
%   ker    Kernel (describes nonlinear boundary type)
%   L_mult Legrange multiplies, from svc
%   b      Bias,frome svc
%
% Outputs
%   Sensitivity  (as defined)
%   Specificity  
%   y      Classifier output for test data set
%
hold on;
y = svcoutput(Xt,dt',X,ker,L_mult,b);           % Classifier
[Sensitivity, Specificity] = plot_results(X,d,y,0);    % Plot data
svcbound(Xt,dt',ker,L_mult,b);                  % Plot boundaries 