function y = prbs(nbits)
%  Program prbs.m to generate pseudorandom binary sequence (values 0 to 1)
%   The total number of points generated, N = 2^nbits -1
%     where "nbits" = order of shift register
x = ones(nbits,1);
N = 2^nbits - 1;
y = zeros(N,1);

for i=1:N,
   y(i) = x(nbits);
   for j=nbits-1:-1:1,
      x(j+1) = x(j);
   end;
   if x(1)==y(i),
      x(1) = 0;
   else
      x(1) = 1;
   end;
end;
