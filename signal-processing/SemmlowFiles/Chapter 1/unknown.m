function output = unknown(input)
% Unknown process used in Problem 1.8.
%
[r c] = size(input);        % Get size of input vector
if r < c
    input = input';         % Make row vector
end
output = 6*[diff(input); 0];    % Take derivative, pad
