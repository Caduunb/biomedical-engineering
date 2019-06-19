% Example 16.11  Example of classification using cluster analysis
%   Four nonlinearly seperable classes using 6 clusters per class
% Present only as Figure 14.22.
%
clear all; close all;
nu_clusters = 8;        	% Number of clusters per class
nu_classes = 4;             % Number of classes
k = 8;
alpha = .25;                % Learning constant
nu_training = 1000;          % Number of training cycles
% Generate data
[Xt, Dt] = gen_data4(2.25);  %Generate training data, four classes
[X, D] = gen_data4(2.25,[],400);  %Generate test data
[r1,c] = size(X);
[r,c] = size(Xt);
for i = 1:r
    dt(i) = find(Dt(i,:)) - 1;      % Convert from position to number
end
Xt = whiten_data(Xt);             % Whiten data
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
    alpha = alpha*(1 - i/nu_training);   % Reduce learning constant
end
[mse, correct, incorrect] = cluster_eval(Xt,dt,Proto);
disp([mse, correct, incorrect])
cluster_boundaries(Xt,dt,Proto);  % Draw cluster boundaries
% Now evaluate on test set of 400 points
figure;

for i = 1:r1
    d(i) = find(D(i,:)) - 1;      % Convert from position to number
end
X = whiten_data(X);
[mse, correct, incorrect, confusion] = cluster_eval(X,d,Proto);
cluster_boundaries(X,d,Proto);  % Draw cluster boundaries
axis([-1 1 -1 1]);
disp([mse, correct, incorrect])
disp(confusion)

        