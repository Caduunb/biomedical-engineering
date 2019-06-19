% Example 17.4 Three-layer net example. Trains a three layer neural net to 
%   perform classifcation of different gaussian distributions. Use a
%   training set of 100 points. Use the lms learning algorithm with backprojection
% Evaluate the trained net on a test set (N = 400).
%
clear all;
close all;
alpha = .2;
hl1 = 6;                % Number of neurons in hidden layer 1
hl2 = 6;                % Number of neurons in hidden layer 2
[Xt, dt] = gen_data2(4,[],'d');       % Generate training data
[X, d] = gen_data2(4,[],'d',[],400);       % Generate training data
% Generate initial weights for both layers
[r,nu_inputs] = size(X);
W1 = (rand(nu_inputs,hl1)-1)*.25;   % Initialize weights    
b1 = (rand(1,hl1)-1)*.25; %         %   and biases, input layer	
W2 = (rand(hl1,hl2)-1)*.25;         % Initialize hidden layer		   
b2 = (rand(1,hl2)-1)*.25;
W3 = (rand(hl2,1)-1)*.25;           % Initialize output neuron
b3 = (rand(1,1)-1)*.25;		
last_mse = 2;                       % Set initial mse large 
%
for k3 = 1:200
    for k1 = 1:20
        [Xt,dt]= mix_data(Xt,dt);
        [W1,b1,W2,b2,W3,b3] = net_learn_3(Xt,dt,alpha,W1,b1,W2,b2,W3,b3);  % Multiple training
    end
    mse(k3) = net_eval(Xt,dt,W1,b1,W2,b2,W3,b3);      % Evaluate net
    if abs(mse(k3) - last_mse) < .00001 
       disp('Delta error minimum')
       break;
   end
   last_mse = mse(k3);
   disp([mse(k3)])
end
net_boundaries(Xt,dt,W1,b1,W2,b2,W3,b3);        % Training data 
[mse(k3), sensitivity, specificity] = net_eval(Xt,dt,W1,b1,W2,b2,W3,b3); % Training data
title(['Sensitivity: ',num2str(sensitivity,3),'% Specificity: ',num2str(specificity,3),'%'],'FontSize',14);
%
% Evaluate trained net on test set
figure;
[mse(k3), sen, sp] = net_eval(Xt,dt,W1,b1,W2,b2,W3,b3); 
disp(['Epochs: ',num2str(20*k3)])
net_boundaries(X,d,W1,b1,W2,b2,W3,b3);        % Test data 
[mse(k3), sensitivity, specificity] = net_eval(X,d,W1,b1,W2,b2,W3,b3); % Test data
title(['Sensitivity: ',num2str(sensitivity,3),'% Specificity: ',num2str(specificity,3),'%'],'FontSize',14);





