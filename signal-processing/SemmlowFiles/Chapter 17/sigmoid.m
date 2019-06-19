function [a, der] = sigmoid(p,w,b)
% Function to simulate a linear neuron
% Inputs 
%   p   inputs to perceptron (vectors or scalors)
%   w   weights(vectors or scalors)
%   b   bias (scalor; default = 0)
% Outputs
%   a   output (a = 1 / (1 + exp(-S)) )
%   dn  Approximate Derivative
%
S = (sum(p .* w')) + b;       % Get sum of weighted inputs
a = 1 / (1 + exp(-S));
a2 = 1/ (1 + exp(-S+.01));    % Get Y for delta x = .01
der = (a - a2)/.01;             % Caculate approximate derivative