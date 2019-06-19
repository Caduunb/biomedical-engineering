function y = MCP_neuron(x,w,b)
% Function to simulate a McCullough-Pitts neuron
% Inputs 
%   x   inputs to neruon (vectors)
%   w   weights(vectors)
%   b   bias (scalor)
% Outputs
%   y   output (-1 or 1)
%
a = (sum(x .* w')) + b;     % Get sum of weighted inputs
if a >= 0                   % Set output
    y = 1;
else
    y = -1;
end
    