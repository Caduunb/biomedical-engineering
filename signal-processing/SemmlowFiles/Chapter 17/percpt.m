function a = MCP_neuron(p,w,b)
% Function to simulate a McCullough-Pitts neuron
% Inputs 
%   p   inputs to neruon (vectors or scalors)
%   w   weights(vectors or scalor)
%   b   bias (scalor)
% Outputs
%   a   output (0 or 1)
%
S = (sum(p .* w')) + b;     % Get sum of weighted inputs
if S >= 0                   % Set output
    a = 1;
else
    a = -1;
end
    