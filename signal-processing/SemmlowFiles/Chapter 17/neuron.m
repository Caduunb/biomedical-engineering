function [y, der] = neuron(x,w,b,type)
% Function to simulate a linear neuron
% Inputs 
%   p       inputs
%   w       weights (vector or scalors)
%   b       bias (scalor)
%   type    neuron type: 'm', MC-P; 'l', linear; 's', sigmoid (default);
%                   'h', hyperbolic tan 
% Outputs
%   y       output 
%   der     Approximate local derivative
%
delta = 0.01;                   % Used to calculate derivative
if nargin < 4
    type = 's';                 % Default type
end
%
a = (sum(x .* w')) + b;         % Get sum of weighted inputs
if type == 'm'                  % McCullough-Pitts
    der = inf;                  % Derivative infinite
    if a >= 0                   % Set output
        y = 1;                  % Outputs are +/- 1
    else
        y = -1;
    end
elseif type == 's'                % Sigmoid
    y = 1 / (1 + exp(-a));
    y2 = 1/ (1 + exp(-a-delta));    % Get Y for delta x = .01
    der = (y2-y)/delta;             % Caculate approximate derivative
elseif type == 'h'                % Hyperbolic tangent
    y = tanh(a);
    y2 = tanh(a+delta);             % Get Y for delta x = .01
    der = (y2 - y)/delta;           % Caculate approximate derivative
elseif type == 'l'                % Linear
    y = a;
    der = 1;
else
    disp('Error in neuron input type')
end