function G = cone_shape(alpha,L)
% Function to calculate the cone-shape determining function
%
L_2 = round(L/2);
%  Initializaton
for u = 1:L_2
	for tau = 1:L_2
      u1= u/4;
      tau1 = tau/4;
      G(u,tau) = sinc(pi*u1*tau1)*exp(-2*pi*alpha*tau1^2);
   end
end
G(1,1) = 1;
 % Expand to 4 quandrents
 G = [ fliplr(G(:,2:end)) G];  	% Add 2nd quadrant
 G = [flipud(G(2:end,:)); G];	  	% Add 3rd and 4th quadrants
  contour(G); figure;   

      
      
