function [W,b] = percpt_learn4(X,d,W,b)
% Simple learing rule for perceptron cotininf 4 neurons
% Inputs X, Y are the training set
%   X   inputs (assumed a matrix where the number or rows are different
%       samples and the number of columns are the input dimension 
%   y   correct outputs; i.e., targets (assumed a vector)
% Rule, If output correct no weight change
%       If output 0 and should be 1, input vector is added to weights
%       If output 1 and should be 0, input vector is subtracted from
%       weights
%
%
[r,c] = size(X);
for i = 1:r
    clear y;
    y = MC_neuron(X(i,:),W(:,d(i)),b(d(i))); %Evaluate proper neuron
    e = d(i) - y;       % Compute the error
    W(:,d(i)) = W(:,d(i)) + e*X(i,:)';   %Update asocciated weights
    b(d(i)) = b(d(i)) + e;
end