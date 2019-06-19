function mse = net_eval_m(X,d,W1,b1,W2,b2,W3,b3)
% Evaluates net performance and plots output classification
% Plots four variable input data for two or three layer nets.
% Number of layers is determined from the number of arguments and the 
%   number of neurons in each layer is determined from the dimension
%   of the associated weights.
% Tests classification performance of a peceptron with weights w and bias b
%   and plots the linear classfication along with the actual class as 
%   given in y
%
% Inputs
%     X   input variables a matrix
%     d   class associated with each variable (i.e. desired output)
%     W1  weights of hidden layer 1: The weights are a matrix where the  
%           column indicates the neuron number and row is input channel. 
%     b1  bias of layer 1: a vector of biases for the neurons in hidden
%           layer
%     W2  weights of hidden layer 2: The weights are a matrix where the  
%           column indicates the neuron number and row is input channel. 
%     b2  bias of layer 2: a vector of biases for the neurons in hidden
%           layer 
%     W3  weights of output layer neurons (matrix as in W1 and W2)  
%     b3  bias of layer 3: a scalor of bias for the neuron in the output
%           layer
%
% Outputs
%     mse: Measn squared error
%     Sensitivity: Percent correct 
%     Specificity:  1- percent error
type = 's';
if type == 's' 
    test = .5;
else 
    test = 0;
end
[r,nu_inputs] = size(X);    % Determine number of patterns
[~,nu_hl1] = size(W1);     % Determine number of hidden neurons
[~,nu_ol] = size(d);     % Determine number of output neurons
% Determine linear response to X
for i = 1:r
    y_hl1 = net_layer(X(i,:),W1,b1,type);    %Calculate the first layer of actan neurons
    if nargin < 8
        for j = 1:nu_ol                 % Output neurons
            j1 = (j-1)*2 + 1;           % Conneted to only two first layer neurons
            y(i,j) = neuron(y_hl1(j1:j1+1),W2(:,j),b2(j),'s');   
        end
    else 
        y_hl2 = net_layer(y_hl1,W2,b2,type);        % Second layer
        for j = 1:nu_ol                                 % Output neurons
            j1 = (j-1)*2 + 1;           % Conneted to only two first layer neurons
            y(i,j) = neuron(y_hl2(j1:j1+1),W2(:,j),b2(j),'s');   
        end
    end
end
mse = sqrt(mean((y - d).^2));       % This will be a vector
figure(1);
clf; hold on;       % Plot the results 
%Assumes Class 0 is negative and Class 1 is positive
marker_type = ['sk'; 'ok'; 'dk'; 'vk'];
marker_color = ['b'; 'r'; 'g'; 'y']; 
for i = 1:r                         % Index over patterns
    for k = 1:5        % Index over class
        if k <= nu_ol
            if d(i,k) == 1;
                if y(i,k) > test
                    plot(X(i,1),X(i,2),marker_type(k,:),'MarkerFaceColor',marker_color(k,:));
                else 
                    plot(X(i,1),X(i,2),marker_type(k,:),'MarkerFaceColor','c');
                end
            end
        end
    end
end
xlabel('x1','FontSize',14); ylabel('x2','FontSize',14);



