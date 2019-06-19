% Example 14.4
%  Program to use of higher dimensions to separate the data set
% 	shown in Figure 14.14
close all; clear all; 
distance = 6;
[X d] = gen_data2(distance, [],'d');
[r c] = size(X);
X1 = [X, X(:,1).*X(:,2), ones(r,1)];	% Add the cross product term
w = inv(X1'*X1)*(X1'*d');      % Train the classifier
[sensitivity, specificity, mse] = linear_eval3D(X1,d,w);
%
