function G = stft(N)
% Function to calculate the STFT Distribution function
%
% Initialization
G = zeros(N/2,N/2);
%  Set scale factor
sf = 1/(2*(N-1));
for i = 1:N/2							% Calculate 1st quadrant
   for j = 1:(N/2)-i
      G(i,j) = sf;
   end
end
% Expand to 4 quandrents
G = [ fliplr(G(:,2:end)) G];  	% Add 2nd quadrant
G = [flipud(G(2:end,:)); G];	  	% Add 3rd and 4th quadrants
      

      
      
