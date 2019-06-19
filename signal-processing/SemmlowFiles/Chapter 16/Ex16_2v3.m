% Example 16.2 Linear classification using least squares.
% Trained on 2 data sets one 20 points and the other 200 points and
% evaluated on a test set of 500 points
%  
clear all; close all;
distance = 5;       % Distance between distribution centers
angle = 30;         % Angle between distribution centers
training_set = 20;          % Training set size
[Xt,dt] = gen_data2(distance,[],[],[],training_set);  % Generate training data
[r,c] = size(Xt);
Xt = [Xt,ones(r,1)];          % To account for bias
w = inv(Xt'*Xt)*(Xt'*dt');    % Train on small training set
linear_eval(Xt,dt,w); title('Training Set (small)','FontSize',14);
figure;
%
% Samll training set
[X,d] = gen_data2(distance,[],[],[],500);  % Generate test data
[r,c] = size(X);
X = [X,ones(r,1)];          % To account for bias
linear_eval(X,d,w);         % Evaluate boundary
title('Test Set (Small Training)','FontSize',14);
%
% Repeat for a training set of 200
figure;
training_set = 200;         % Training set size
[Xt,dt] = gen_data2(distance,[],[],[],training_set);  % Generate training data
[r,c] = size(Xt);
Xt = [Xt,ones(r,1)];          % To account for bias
w = inv(Xt'*Xt)*(Xt'*dt');  % Train on larger training set
linear_eval(X,d,w);         % Evaluate boundary
title('Test Set (Large Training)','FontSize',14);