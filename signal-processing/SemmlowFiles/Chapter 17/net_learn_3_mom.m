function [W1,b1,W2,b2,W3,b3] = net_learn_3_mom(X,d,alpha,nu,W1,b1,W2,b2,W3,b3)
% Trains a three-layer network using the lms algorithm and backprojection
% Assumes only one output neuron
% Inputs
%     X   input variables a matrix
%     d   class associated with each variable (i.e. desired output)
%     alpha leaning constant
%     nu  momentum constant
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
%  Outputs
%     W's weights and biases as above
%
% Preserve old weights and biases 
persistent W1_old b1_old W2_old b2_old w3_old b3_old; 
if isempty(W1_old)      % Check if first time around
    W1_old = W1;        % Imitialize save weights and biases
    b1_old = b1;        %   if first time around
    W2_old = W2;
    b2_old = b2;
    w3_old = W3;
    b3_old = b3;
end
%
[r,nu_inputs] = size(X);        % Determine number of input patterns
[~,nu_hl1] = size(W1);        % Determine number of neurons in first layer
[~,nu_hl2] = size(W2);        % Determine number of neruons in second layer
% Train net usin
for i = 1: r                    % Calculate net output (feedforward response)
    [y_hl1, der_hl1]  = net_layer(X(i,:),W1,b1,'s');    
    [y_hl2, der_hl2] = net_layer(y_hl1,W2,b2,'s');
    [y, der_ol] = neuron(y_hl2,W3,b3,'s');      
    e(i) = d(i) - y;            %Calculate the error
    %Compute local errors
    err_ol = der_ol * e(i);     %Output neuron local errors
    for k = 1:nu_hl2            %Now backproject on each neuron in layer 2
        err_hl2(k) = der_hl2(k) * err_ol * W3(k,1);    %Hidden layer local error
        % Now add momentum to other variables
        delta = alpha * err_hl2(k) * y_hl1' + nu*(W2(:,k) - W2_old(:,k));   
        W2_old(:,k) = W2(:,k);      % Save current weights before update
        W2(:,k) = W2(:,k) + delta;  % Update weights
        delta = alpha * err_hl2(k) + nu*(b2(k) - b2_old(k));
        b2_old(k) = b2(k);          % Save current bias before update
        b2(k) = b2(k) + delta; 
    end
    for k = 1:nu_hl1            % Now backproject on each neuron in layer 1
        for m = 1: nu_hl2       % Get responsibility for k layer 1 neuron 
            credit(m) = err_hl2(m)*W2_old(k,m); %Sum over all layer 2 neurons, m
        end
        err_hl1 = der_hl1(k) * sum(credit);    % Local error hidden layer neuron k
        delta = alpha * err_hl1 * X(i,:)' + nu*(W1(:,k) - W1_old(:,k));
        W1_old(:,k) = W1(:,k);
        W1(:,k) = W1(:,k) + delta;  % Update weights
        delta = alpha * err_hl1 + nu*(b1(k) - b1_old(k));
        b1_old(k) = b1(k);          % Save current bias before update
        b1(k) = b1(k) + delta;      % Update bias     
    end
    delta = alpha * err_ol*y_hl2' + nu*(W3 - w3_old);
    w3_old = W3;
    W3 = W3 + delta;  %Update weights and biases in output layer
    delta = alpha * err_ol + nu*(b3 - b3_old);
    b3_old = b3;
    b3 = b3 + delta;              
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

    
