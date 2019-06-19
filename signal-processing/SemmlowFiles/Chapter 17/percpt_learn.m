function [w,b] = percpt_learn(X,d,w,b)
% Simple learning rule for perceptrons
% Inputs X, d are the training set
%   X       Inputs (assumed a matrix where the number or rows are different
%           samples and the number of columns are the different input patterns) 
%   d       correct outputs; i.e., targets (assumed a vector)
%   alpha   convergence weight
%   w       Current weights
%   b       Current biasfunction [w,b] = percpt_learn(X,d,alpha,w,b)
% Simple learing rule for peceptrons
% Inputs X, d are the training set
%   X       Inputs (assumed a matrix where the number or rows are different
%           samples and the number of columns are the different input patterns) 
%   d       correct outputs; i.e., targets (assumed a vector)
%   w       Current wieghts
%   b       Current 
%
% Outputs
%   X       Updated weights
%   b       Updated bias
%
[r,c] = size(X);        %Determine the number of input patterns
for i = 1:r             %Train on the entire epoch
    y = MCP_neuron(X(i,:),w,b);
    e = d(i) - y;               %Compute the error
    w = w + e*X(i,:)';    %Update weights
    b = b + e;            %Update bias
end
%
% Outputs
%   X       Updated weights
%   b       Updated bias
%
[r,c] = size(X);        %Determine the number of input patterns
for i = 1:r             %Train on the entire epoch
    y = MCP_neuron(X(i,:),w,b);
    e = d(i) - y;               %Compute the error
    w = w + e*X(i,:)';    %Update weights
    b = b + e;            %Update bias
end
% Rule, If output correct no weight change
%       If output 0 and should be 1, input vector is added to weights
%       If output 1 and should be 0, input vector is subtracted from
%       weights
%
