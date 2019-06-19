function [w,b] = lms_learn(X,d,alpha,w,b,type)
% Learing rule for neurons based the lms Widrow--Hoff algorithm
%   Neurons must be linear or continuous suca as sigmoid
% Inputs X, Y are the training set
%   X   inputs (assumed a matrix where the number or rows are different
%       samples and the number of columns are the input dimension 
%   y   correct outputs; i.e., targets (assumed a vector)
%   alpha  Learning rate constant
%   type neuron type: l(inear); p(ecpt); s(igmoid); t(arctan)
%   w   initial weights 
%   b   initial bias 
%   type    neuron type: 'm', MC-P; 'l', linear; 's', sigmoid (default);
%                   'h', hyperbolic tan   
%
if nargin < 6
    type = 's';
end
[r,c] = size(X);
for i = 1:r
    [y,der] = neuron(X(i,:),w,b,type);
    e = d(i) - y;       % Compute the error
    w = w + alpha*e*der*X(i,:)';   %Update weights
    b = b + alpha*e*der;
end
%
% Rule, W(k+1) = W(k) + 2a der e(k)x(k)'
%       b(k+1) = b(k) + 2a der e(k)
%       where alpha is the learning rate constant