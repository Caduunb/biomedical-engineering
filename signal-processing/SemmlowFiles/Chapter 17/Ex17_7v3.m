% Ex. 17.7 Four classification using a two-layer net.
% Trains a two-layer neural net to identify four classes
% Uses the lms learning algorithm with backprojection
%
clear all; close all;
alpha = .05;
hl1 = 8;                % Number of neurons in hidden layer 1
ol = 4;                 % Number of nuurons in output layer
[X, d] = gen_data_m(2.75,4);  % Generate four-class data
% Generate initial weights for both layers
 [r,nu_inputs] = size(X);
   W1 = (rand(nu_inputs,hl1)-1)*.25;     %Set weights to small random values
   b1 = (rand(1,hl1)-1)*.25;
   W2 = (rand(2,ol)-1)*.25;   % Output neurons connected to two input neurons
   b2 = (rand(1,ol)-1)*.25;
last_mse = 4;                       %Initial mean squared error
for k3 = 1:50
    for k1 = 1:20
        for k2 = 1:4
            j = (k2-1)*2 + 1;           % Conneted to only two first layer neurons
            [W1(:,j:j+1),b1(j:j+1),W2(:,k2),b2(k2)] = net_learn_2(X,d(:,k2),alpha,W1(:,j:j+1),b1(j:j+1),W2(:,k2),b2(k2));  %Multiple training
        end
    end
    mse = net_eval_m(X,d,W1,b1,W2,b2);          %Evaluate neuron
    if abs(sum(mse) - last_mse) < .00001  
       disp('Delta error minimum')
       break;
   end
   last_mse = sum(mse);
   disp(mse)
end
net_boundaries_m(X,d,W1,b1,W2,b2);
disp(['Epochs: ',num2str(20*k3)])





