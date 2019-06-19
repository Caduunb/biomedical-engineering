% Example 16.1 Linear classification using least squares.
%  
clear all; close all;
distance = 6;       % Distance between distribution centers
angle = 30;         % Angle between distribution centers
[X,d] = gen_data2(distance);  % Generate data
[r,c] = size(X);
X = [X,ones(r,1)];              % To account for bias
w = inv(X'*X)*(X'*d');          % Train weights (least squares)
linear_eval(X,d,w);             % Evaluate and plot boundary


