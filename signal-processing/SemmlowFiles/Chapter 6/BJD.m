function G = BJD(L)
% Function to calculate the Born-Jordan determining function
%
L_2 = round(L/2);
%  Initializaton
for u = 1:L_2
	for tau = 1:L_2
       tau1 = tau/4;        % Reduce arguments to broaden function 
       u1 = u/4;
       G(u,tau) = sinc(u1*tau1);
   end
end
% Expand to 4 quandrents
 G = [ fliplr(G(:,2:end)) G];  	% Add 2nd quadrant
 G = [flipud(G(2:end,:)); G];	  	% Add 3rd and 4th quadrants
 

      
      
