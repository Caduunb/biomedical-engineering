function [y, der]  = net_layer(x,W,b,type);
% Function that simulates one layer of a nural net.
%  
% Inputs
%    x     inputs: a vector of inputs to each neuron.  All neuron in a layer
%                   get the same inputs
%  type    neuron type: 'p' perceptron, 'l' linear (default), 's', sigmoid
%     W    weights: The weights are a matrix where the column 
%          indicates the neuron number. (Note size(In = size(W') ) 
%     b    bias: a vector of biases for the neurons
% Outputs 
%     a    A vector of outputs for the neurons in this layer 
%
%Compute the output (and derivative) for each neuron, k.
%Note All neurons receive the same input
if nargin < 4
    type = 's';
end
[r,nu_neuron] = size(W);
for k = 1:nu_neuron                
    [y(1,k), der(k)] = neuron(x,W(:,k),b(k),type);
end

    

