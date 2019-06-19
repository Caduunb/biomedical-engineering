% Function to integrate input by simple summation
%
% 
function y = integrate(x)
%
y = zeros(1,length(x));
for i= 2:length(x)
   y(i) = (y(i-1) + x(i))/2;
end
y(1) = x(1);
