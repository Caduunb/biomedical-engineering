function [W1,b1,W2,b2] = net_learn_2(X,d,alpha,W1,b1,W2,b2)
% Train a two layer network using the lms algorithm and backprojection
% Assumes only one output neuron
% Inputs
%     X   input variables a matrix
%     d   class associated with each variable (i.e. desired output)
%     alpha leaning constant (scalar)
%     W1  weights of hidden layer: The weights are a matrix where the  
%           column indicates the neuron number and row is input channel. 
%     b1  bias of layer 1: a vector of biases for the neurons in hidden
%           layer 
%     w2  weights of output layer neuron (a vector)  
%     b2  bias of layer 2: a scalor of bias for the neuron in the output
%           layer
%
[r,~] = size(X);
[~,nu_hl] = size(W1);
% Train net
for i = 1: r 
    [y_hl, der_hl]  = net_layer(X(i,:),W1,b1,'s');  %First layer output
    [y, der_ol] = neuron(y_hl,W2,b2,'s');           % Second layer output
    e = d(i) - y;                                   % Calculate the error
    %Compute local errors
    err_ol = der_ol * e;     %Output neuron local errors
    for k = 1:nu_hl             %Now backproject on each neuron
        err_hl = der_hl(k) * err_ol * W2(k,1);    %Hidden layer local error
        W1(:,k) = W1(:,k) + alpha * err_hl * X(i,:)';  %Update weights
        b1(k) = b1(k) + alpha * err_hl; 
    end
    W2 = W2 + alpha * err_ol*y_hl';           %Update weights and biases in output layer
    b2 = b2 + alpha * err_ol;              
end

% Internal Variable names
%   der_hl  local derivative of hidden layer neurons (vector)
%   der_ol  local derivative of output layer neuron (scalor)
%   err_ol  local error (delta) of output neruon (scalor)
%   err_hl  local error of kth hidden layer neuron (scalor)
%   nu_hl   number of neurons in the hidden layer
%   e       error (desired - acutal)
%   y_hl    hidden layer output (vector)
%   y       net output (scalor)

    
