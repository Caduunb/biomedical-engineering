% Ex. 17.6 Momentum example. Trains a three layer neural net to 
%   with 6 neurons in each of the two hidden layers
%   to perform classifcation of different gaussian distributions. 
% Uses the lms learning algorithm with backprojection with
%   and without momentum.
%
close all; clear all;
alpha = .1;             % Learning constant
nu = 0;                 % Momentum constant (Initially zero)
hl1 = 6;                % Number of neurons in hidden layer 1
hl2 = 6;                % Number of neurons in hidden layer 2
[X, d] = gen_data2(4,[],'d');  %Generate data
% Generate initial weights for both layers
   [r,nu_inputs] = size(X);
   [W1 b1 W2 b2 W3 b3]= initialize_weights(6,nu_inputs,hl1,hl2);
% Train without momentum   
   last_mse = 2;                       
for k3 = 1:100
    for k1 = 1:20
        [X,d]= mix_data(X,d);
        [W1,b1,W2,b2,W3,b3] = net_learn_3_mom(X,d,alpha,nu,W1,b1,W2,b2,W3,b3); %Multiple training
    end
    [mse, sen, sp] = net_eval(X,d,W1,b1,W2,b2,W3,b3);          %Evaluate neuron
    mse_save1(k3) = mse;
    if abs(mse - last_mse) < .00001 && mse < .12 
       disp('Delta error minimum')
       break;
   end
   last_mse = mse;
   disp(mse)
end
net_boundaries(X,d,W1,b1,W2,b2,W3,b3);
disp(['Epochs: ',num2str(20*k3)])
training_error = mse; nu_epochs = 20*k3;
figure;
%
% Train with momentum
nu  = .5;
[W1 b1 W2 b2 W3 b3]= initialize_weights(6);   % Restore initial weight values to be used
last_mse = 2;                       
for k3 = 1:200
    for k1 = 1:20
        [X,d]= mix_data(X,d);
        [W1,b1,W2,b2,W3,b3] = net_learn_3_mom(X,d,alpha,nu,W1,b1,W2,b2,W3,b3);  %Multiple training
    end
    [mse, sen, sp] = net_eval(X,d,W1,b1,W2,b2,W3,b3);          %Evaluate neuron
    mse_save2(k3) = mse;
    if (abs(mse - last_mse) < .00001 || mse < training_error) && mse < .12
       disp('Delta error minimum')
       break;
   end
   last_mse = mse;
   disp(mse)
end
net_boundaries(X,d,W1,b1,W2,b2,W3,b3);
disp(['Epochs: ',num2str(20*k3), ' Epochs (n):', num2str(nu_epochs)])
disp(['MSE: ', num2str(mse), ' MSE(n): ', num2str(training_error)])
x1 = (1:length(mse_save1))*20;
figure; clf; hold on;
plot(x1,mse_save1,'k')
x2 = (1:length(mse_save2))*20;
plot(x2,mse_save2)



