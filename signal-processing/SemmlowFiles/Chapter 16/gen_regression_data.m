function [y,x] = gen_regression_data(m, b, sigma, npts, type)
% Function to generate mulitple regression data.
% Inputs:
%       m       Slope(s) or scale(s) of the data 
%               If m a vector, multiple dimensions will be generated
%       b       Intercept(s) of data
%       sigma   Gaussian noise on data
%       type    'linear' (default) or 'quadratic'
%
if nargin < 5
    type = 'linear';
end
if nargin < 4
    npts = 100;         %Default
end
if isempty(b) == 1
    b = 0;              %Default.
end 
if length(m) > length(b)
    i = 2:length(m)     %If b smaller than m 
    b(i) = b(1);        % Fill b with same values
end
noise = rand(length(m),npts) * sigma;
for i = 1:length(m)     %Do for each dimension
    for j = 1:npts
        if type == 'linear'
            y(j,i) = m(i)*j/npts + b(i) + noise(i,j);
        else
           y(j,i) = m(i)*j/(npts^2) + b(i) + noise(i,j);
        end
    end
    x(:,i) = [1:npts];
end
if length(m) == 1
    plot(x,y,'xb');
    xlabel('Number'); ylabel('x');
end

    
    