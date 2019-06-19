function G = BJC(L)
% Function to calculate the Born-Jordan-Cohen determining function
%
L_2 = round(L/2);      % Points per quardrant
G = zeros(L_2,L_2);
for u = 1:L_2
	for tau = 1:u
      G(u,tau) = 1/(u+1);
   end
end
G(1,1) = 1;
 % Expand to 4 quandrants
 G = [ fliplr(G(:,2:end)) G];  	    % Add 2nd quadrant
 G = [flipud(G(2:end,:)); G];	  	% Add 3rd and 4th quadrants
      

      
      
