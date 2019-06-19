function Proto = cluster_learn(X,d,Proto,alpha)
% Function to use Learning Vector Quantization to find best 
%   cluster centers
% Outputs
%   Proto   prototype cluster center (matrix)
% Inputs
%   X       Inputs signals (matrix)
%   d       desired response
%   Proto   initial cluster centers (matrix)
%   alpha   learning constant
%
[r,c] = size(X);        % Determine number of input patterns
[r1,c1] = size(Proto);  % Determine number of prototype centers
% Train centers. Pick data training sequentially
% Train over all observations
for i1 = 1:r
   for j1 = 1:r1        % Find distances to all prototypes centers
        distance(j1) = norm(Proto(j1,1:2)-X(i1,:));
   end
   [dum,i_close] = min(distance);  % Find closest prototype center 
   if d(i1) == Proto(i_close,3)    % Closest center is same class
       % Move prototype center closer to this training point
        Proto(i_close,1:2) = Proto(i_close,1:2) + alpha* (X(i1,:) - Proto(i_close,1:2));
   else
       % Move prototype center farther away from this point
        Proto(i_close,1:2) = Proto(i_close,1:2) -  alpha*(X(i1,:) - Proto(i_close,1:2));
   end
end