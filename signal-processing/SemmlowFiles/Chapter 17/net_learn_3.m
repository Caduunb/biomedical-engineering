function [W1,b1,W2,b2,W3,b3] = net_learn_3(X,d,alpha,W1,b1,W2,b2,W3,b3)
% Trains a three-layer network using the lms algorithm and
%   backprojection
% Inputs
%     X   input variables a matrix
%     d   class associated with each variable (i.e. desired output)
%     alpha leaning constant
%     W1  weights of hidden layer 1: The weights are a matrix where the  
%           column indicates the neuron number and row is input channel. 
%     b1  bias of layer 1: a vector of biases for the neurons in hidden
%           layer
%     W2  weights of hidden layer 2: The weights are a matrix where the  
%           column indicates the neuron number and row is input channel. 
%     b2  bias of layer 2: a vector of biases for the neurons in hidden
%           layer 
%     w3  weights of output layer 3 neuron (a vector)  
%     b3  bias of layer 3: a scalor of bias for the neuron in the output
%           layer
%
%  Outputs
%     W's weights and biases as above
%
[r,nu_inputs] = size(X);      % Determine number of input patterns
[~,nu_hl1] = size(W1);        % Determine number of neurons in first layer
[~,nu_hl2] = size(W2);        % Determine number of neruons in second layer
% Train net
for i = 1: r 
    [y_hl1, der_hl1]  = net_layer(X(i,:),W1,b1,'s');    %Calculate the first layer of actan neurons
    [y_hl2, der_hl2] = net_layer(y_hl1,W2,b2,'s');
    [y, der_ol] = neuron(y_hl2,W3,b3,'s');      %Calculate the second layer of linear neurons
    e(i) = d(i) - y;            %Calculate the error
    %Compute local errors
    err_ol = der_ol * e(i);     %Output neuron local errors
    W2_old = W2;                %Save unmodified weights
    for k = 1:nu_hl2            %Now backproject on each neuron in layer 2
        err_hl2(k) = der_hl2(k) * err_ol * W3(k,1);    %Hidden layer local error
        W2(:,k) = W2(:,k) + alpha * err_hl2(k) * y_hl1';  %Update weights
        b2(k) = b2(k) + alpha * err_hl2(k); 
    end
    for k = 1:nu_hl1            %Now backproject on each neuron in layer 1
        for m = 1: nu_hl2       %Get responsibility for k layer 1 neuron 
            credit(m) = err_hl2(m)*W2_old(k,m); %Sum over all layer 2 neurons, m
        end
        err_hl1 = der_hl1(k) * sum(credit);    %Local error hidden layer neuron k
        W1(:,k) = W1(:,k) + alpha * err_hl1 * X(i,:)';  %Update weights
        b1(k) = b1(k) + alpha * err_hl1; 
    end
    W3 = W3 + alpha * err_ol*y_hl2';           %Update weights and biases in output layer
    b3 = b3 + alpha * err_ol;              
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

    
