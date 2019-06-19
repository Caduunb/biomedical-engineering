function a = linear(p,w,b)
% Function to simulate a linear neuron
% Inputs 
%   p   inputs to perceptron (vectors or scalors)
%   w   weights(vectors or scalors)
%   b   bias (scalor; default = 0)
% Outputs
%   a   output (0 or 1)
%
a = (sum(p .* w')) + b;       % Get sum of weighted inputs
