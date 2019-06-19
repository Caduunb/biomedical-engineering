% Example 16.5  Use the Support Vector Machine software to classify a 
% a linearly separable data set. Use 'gen_data2 to produce two classes
%  identified a class -1 and class +1 which are Gaussianly distributed 
%  and seperated by 5 standard deviations. 
%
clear all; close all;
[X,d] = gen_data2(5,45,[],[-1 1]);  % Generate linearly separable data
[nsv,alpha,b] = svc(X,d','linear');    % Train SVM
svcplot(X,d','linear',alpha,b);        % Plot results
xlabel('x_1','FontSize',14); ylabel('x_2','FontSize',14)
