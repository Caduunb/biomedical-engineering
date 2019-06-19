function [mse, sensitivity, specificity] = net_eval(X,d,W1,b1,W2,b2,W3,b3,type)
% Evaluates net performance and plots output classification
% Plots only two variable input data for one, two, or three layer nets.
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
%           or type
%     b2  bias of layer 2: a vector of biases for the neurons in hidden
%           layer 
%     w3  weights of output layer 3 neuron (a vector)
%           or type
%     b3  bias of layer 3: a scalor of bias for the neuron in the output
%           layer
%     type  neuron type: 'm' McCullough-Pitts, 'l' linear, 
%           's' Sigmoid (default), 'h' hyperpolic tangent
% Outputs
%     mse: Mean squared error
%     Sensitivity: Percent correct 
%     Specificity:  1- percent error
if nargin == 5 
    type = W2;
elseif nargin == 7
    type = W3;
elseif nargin == 4 || nargin == 6 || nargin == 8
    type = 's';
end
if type == 'l' || type == 's'   % Set threshold
    test = .5;      
else
    test = 0.;
end
[r,dimension] = size(X);
% Determine response to X
for i = 1:r
    if nargin < 6        
        y(i) = neuron(X(i,:),W1,b1,type);      %Single layer
    elseif nargin < 8 
        [y_hl1, der_hl1]  = net_layer(X(i,:),W1,b1,type);    %Calculate the first layer of actan neurons
        y(i) = neuron(y_hl1,W2,b2,type);       %Output layer
    else 
        [y_hl1, der_hl1]  = net_layer(X(i,:),W1,b1,type);    %Calculate the first layer of actan neurons
        y_hl2 = net_layer(y_hl1,W2,b2,type); %Second layer
        y(i) = neuron(y_hl2,W3,b3,type);      %Output layer
    end
end 
mse = sqrt(mean((y - d).^2));
[sensitivity specificity] = plot_results(X,d,y,test);   % Plot results
% Plot Decision boundaries
if dimension == 2 && nargin < 6     % Plot decision boundary for single-layer nets
        y_lim = get(gca,'YLim');
        x_lim = get(gca,'XLim');
        x1 = [min(X(:,1)),max(X(:,1))];     
        x2 = -W1(1)*x1/W1(2) -b1/W1(2);         % Eq. 17.5
        plot(x1,x2,'k','LineWidth',2);          % Plot boundary line
        axis([xlim, ylim]);
 elseif dimension == 3 && nargin < 6 % Plot decision boundary only for 3D, single-layer nets
        y_lim = get(gca,'YLim');
        x_lim = get(gca,'XLim');
        % Plot decision boundary W*x + b = 0
        x_axis = 0:max(X(:,1))/20:max(X(:,1));
        y_axis = 0:max(X(:,2))/22:max(X(:,2));
        for i = 1:length(x_axis)
            for  j = 1:length(y_axis)       % Extension of Ex. 17.5
                Z(i,j) = -W1(2)*x_axis(i)/W1(3)+ -W1(1)*y_axis(j)/W1(3) -b1/W1(3);
            end
        end
        p = mesh(y_axis,x_axis,Z);
        axis([xlim, ylim]);
        colormap('bone');
    end
end
