function [Xout,yout] = mix_data(X,y);
%Function to randamly mix the order of the test set
% Also used to generate a random sequence of numbers
%   between 1 and r if X is scalor nad y absent
%
[r,c] = size(X);
available = ones(r,1);  %Available vectors 
Xout = X;             %Initialize outputs for better speed
yout = y;             
for i = 1:r
    index = ceil(r*rand);  %Random number between 1 and r
    while available(index) == 0;   %Check if already used
        index = index + 1;         %Increment index if used
        if index > r
            index = 1;             %Wrap around increment
        end
    end
    Xout(i,:) = X(index,:);        %Transfer to output     
    if nargin == 2
        yout(i) = y(index);
    else
        yout(i) = 0;
    end
    available(index) = 0;          %Make this index unavailable
end
    