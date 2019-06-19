function [W1 b1 W2 b2 w3 b3] = initialize_weights(prob_nu,nu_inputs,hl1, hl2)
%  [W1 b1 W2 b2 W3 b3] = initialize_weights('prob_nu',nu_inputs,hl1, hl2)
% Function to initialize and save weights
% If called without input arguments other than prob_nu, the routine reads the 
%  appropriate file and outputs previously stored values.  (Recommended for
%  some problems.
%
% Inputs
%   'prob_nu'  String with problem number and letter(for storing or retreiving initial weights)
%   nu_inputs number of inputs
%   hl1  Number of weights in first (input layer)
%   hl2  Number of weights in middle layer (optional)
%
% Outputs 
%   Generate initial weights for all layers.  If a given problem does not
%     call for some weights/bias, those variable will be empty
%
filename = ['initial_weights_17_', prob_nu,'.mat'];  % Construct file name
if nargin > 1
   W1 = (rand(nu_inputs,hl1)-.5)*.25;     %Set weights to small random values
   b1 = rand(1,hl1)*.25;
   if nargin > 3
        W2 = (rand(hl1,hl2)-.5)*.25;     %Set weights for three-layer nets
        b2 = rand(1,hl2)*.25;
        w3 = (rand(hl2,1)-.5)*.25;       %Output layer receives hl inputs 
        b3 =  rand(1,1)*.25;
   else
        W2 = (rand(hl1,1)-.5)*.25;     %Set weights for two-layer nets
        b2 = rand(1,1)*.25;
        w3 = [];                       % Not used 
        b3 = [];
   end
   save(filename, 'W1', 'b1', 'W2', 'b2', 'w3', 'b3');
else
 load(filename);
end 
   
   
   
   
   