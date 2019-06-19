% Example 17.3 Two layer net example. Shows the ability of a a two layer net to perform a
%   classifcation of various gaussian distributions. 
% Uses the lms learning algorithm with backprojection
%
clear all; close all;
alpha = .1;
hl = 4;             % Number of neurons in hidden layer
[X, d] = gen_data2(6,[],'s');        % Generate data
[r,nu_inputs] = size(X);
%
% Generate initial weights for both layers
W1 = (rand(nu_inputs,hl)-1)*.25;     % Set weights to small random values
b1 = (rand(1,hl)-1)*.25;
W2 = (rand(hl,1)-1)*.25;             % Output layer receives hl inputs 
b2 = (rand(1,1)-1)*.25;
last_mse = 2; 
%
for k3 = 1:400
    for k1 = 1:20
        [X,d]= mix_data(X,d);
        [W1,b1,W2,b2] = net_learn_2(X,d,alpha,W1,b1,W2,b2);  %Multiple training
    end
    [mse,sens,sp] = net_eval(X,d,W1,b1,W2,b2);          %Evaluate neuron
    if abs(mse - last_mse) < .00001 
       disp('Convergence: delta error minimum')
       break;
   end
   last_mse = mse;
   disp(mse)
end
net_boundaries(X,d,W1,b1,W2,b2);
disp(['Epochs: ',num2str(k3*20)]);           %Show number of Epochs




