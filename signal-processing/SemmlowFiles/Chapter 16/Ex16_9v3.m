% Example 16.9  Example of k-nearest neighbors classification 
% Two nonlinearly seperable classes. k = 5 and 15

clear all; %close all;
K = 15;                     % Number of training points to test
nu_classes = 2;             % Number of classes
 marker_type = ['sk'; 'ok'; 'dk'; 'vk'; '^k'];
 marker_color = ['m'; 'c'; 'b'; 'r'; 'y'];
% Generate data
% [Xt,dt] = gen_data2(4,[],'d');  %Generate training data
% [X,d] = gen_data2(4,45,'d',[0 1],400);   % Generate test data
% Xt = whiten_data(Xt);           % Whiten data
% X = whiten_data(X);
% save Ex16_9.mat X d Xt dt;    % Save data. Problem begins here
%
load Ex16_9.mat;        % Load data
[r,c] = size(X);            % Test set size
[rt,c] = size(Xt);          % Training set size
% Elvaluate.
class = zeros(r,1);         % Set up class assign vector
for j  = 1:r
    for i = 1:rt         % Find nearest K points 
        Distance(i,1) = norm(X(j,:) - Xt(i,:));
        Distance(i,2) = dt(i);      % Save Xi class
    end
    Distance = sortrows(Distance,1); % First row assending
    majority = mean(Distance(1:K,2));  % Distance to K closest pts
    class(j) = round(majority);     % Assign class
end
%       
% Evaluate errors and plot
subplot(1,2,2); hold on;
 confusion = zeros(nu_classes);
for i = 1:r    % Count correct and incorrect, build confusion and plot
    if class(i) == d(i)
        plot(X(i,1),X(i,2),marker_type(d(i)+1,:),'MarkerFaceColor',marker_color(d(i)+1,:));
        confusion(d(i)+1,d(i)+1) = confusion(d(i)+1,d(i)+1) + 1;
    else
        plot(X(i,1),X(i,2), marker_type(d(i)+1,:),'MarkerFaceColor','k');
        confusion(d(i)+1,class(i)+1) = confusion(d(i)+1,class(i)+1) + 1;
    end
end
 k_nearest_boundaries(X,K,Xt,dt);   % Plot boundaries
 xlabel('x_1','FontSize',14); ylabel('x_2','FontSize',14); 
 axis([-1 1 -1 1]);
 disp(confusion)        