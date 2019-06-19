%Ex 17.1 Single McCullough-Pitts neuron example 
%  Show the ability of a single McCullough-Pitts neuron to perform a
%   classifcation of two gaussian distributions that are linearly  
%   seperable. 
%  Uses the perceptron learning rule
%
clear all; close all;
% Generate training set: two Gaussian distributions
angle = 45;      %Angle between distributions in deg.
distance = 6;    %Separation of the two clusters in STD units
[X, d] = gen_data2(distance, angle,'l',[-1 1]);  %Generate data
% Set up initial weights and bias
[r,c] = size(X);
w = (rand(c,1) - .5)*.25;          %Initialize weights and bias to small random number
b = (rand - .5)*.25;               %Set bias similarly
for k = 1:10				% Multiple epochs 
    [w,b] = percpt_learn(X,d,w,b);  % Evaluate training  		
     [sensitivity, specificity] = linear_eval([X,ones(r,1)],d,[w;b],0);
    if sensitivity == 100 && specificity == 100
        	disp('Convergence')
       	break;
    end
end

 
