function [w,b] = lms_batch(X,y,alpha,type,w,b)
% Learing rule for neurons based the lms Widrow--Hoff algorithm
%   Neurons must be linear or continuous such as sigmoid
% This version used the entire data set to adjust the weigthts
% Inputs X, Y are the training set
%   X   inputs (assumed a matrix where the number or rows are different
%       samples and the number of columns are the input dimension 
%   y   correct outputs; i.e., targets (assumed a vector)
%   alpha  Learning rate constant
%   type neuron type: l(inear); p(ecpt); s(igmoid); t(arctan)
%   w   initial weights (optional)
%   b   initial bias (optional)
%
% Rule, W(k+1) = W(k) + 2a der e(k)p(k)'
%       b(k+1) = b(k) + 2a der e(k)
%       where alpha is the learning rate constant
%
[r,c] = size(X);
if nargin < 5
    w = ones(c,1);          %Initialize weights to one
    b = -1;                  %Set bias to one
end
%
for i = 1:r
    [a,d] = neuron(X(i,:),w,b,type);
    e(i) = y(i) - a;       % Compute the error
end
w = w + alpha*mean(e)*X(i,:)';   %Update weights
b = b + alpha*mean(e);
end