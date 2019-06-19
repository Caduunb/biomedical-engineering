function Out = whiten_data(X);
% Function to whiten data.  Center the data and scale to 
%   a variance of 1.0
% Inputs
%   x   data input vector or matrix
% Output
%   out whitened data out
[r,c] = size(X);
transpose_flag = 'n';
if r < c                       % Check orientation
    X = X';
    transpose_flag = 'y';
end
for i = 1:c
    Out(:,i) = X(:,i) - mean(X(:,i));  % Zero mean
    Out(:,i) = Out(:,i)/var(Out(:,i));
end
if transpose_flag == 'y'
    Out = Out';     % Reset orientation
end
    