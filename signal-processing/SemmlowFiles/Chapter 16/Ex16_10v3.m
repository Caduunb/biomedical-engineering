% Example 16.10  Example of classification using cluster analysis
%   Two nonlinearly seperable classes using 5 cluster per class
%
clear all; close all;
k = 8;        	% Number of clusters per class
nu_classes = 2;             % Number of classes
alpha = .25;                % Learning constant
nu_training = 1000;          % Number of training cycles
 marker_type = ['sk'; 'ok'; 'dk'; 'vk'; '^k'];
 marker_color = ['m'; 'c'; 'b'; 'r'; 'y'];
% Generate data
% [Xt, dt] = gen_data2(4,[],'d');  %Generate data
% Xt = whiten_data(Xt); 
% [X, d] = gen_data2(4,[],'d',[0 1],400);  %Generate data
% X = whiten_data(X); 
% save Ex14_10.mat X d Xt dt
load Ex16_9.mat;
[r,c] = size(Xt);
% Whiten data
% Initialize cluster centers. Select centers randomly from the
%   data set.  
for i = 1:nu_classes*k
    Proto(i,:) = [Xt(i,:),dt(i)];
end
%       
% Train clusters by moving prototype centers
for i = 1:nu_training 
    [Xt,dt] = mix_data(Xt,dt);      % Randomize input sequence
    Proto = cluster_learn(Xt,dt,Proto,alpha);  % Train clusters
    % Evaluate performance
    alpha = alpha*(1 - i/nu_training);   % Reduce learning constant
end
[mse, correct, incorrect] = cluster_eval(Xt,dt,Proto);
disp([mse, correct, incorrect])
cluster_boundaries(Xt,dt,Proto);  % Draw cluster boundaries
% Now evaluate on test set of 400 points
figure;
[mse, correct, incorrect, confusion] = cluster_eval(X,d,Proto); 
cluster_boundaries(X,d,Proto);  % Draw cluster boundaries
axis([-1 1 -1 1]);
disp([mse, correct, incorrect])
disp(confusion)
        