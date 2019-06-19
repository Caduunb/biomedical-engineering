function y = rotation(x,phi)
% out = rotation(input,phi)
% Function 2-D rotation
% Inputs  
%   x       data to be rotated (2-D matrix
%   phi     rotation angle in radians
% Outputs
%   y       rotated data
% Rotates the first argument by an angle phi given in the second argument
% Assumes 2-D data and performs 2-D rotation.
[r c] = size(x);
transpose_flag = 'n';
if r < c
    x = x';
    transpose_flag = 'y';
end
W = [cos(phi) sin(phi); -sin(phi) cos(phi)];      % Set up rotation matrix
y = x * W;							        % Rotate input
if transpose_flag == 'y'
    y = y';
end