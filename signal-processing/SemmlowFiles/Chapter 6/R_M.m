function G = R_M(N)
% Function to calculate the Rihaczek-Margenau Distribution function
%
N_2 = round(N/2);
G = zeros(N_2,N_2);
for u = 1:N_2       % Calculate 1st quadrant
    for tau= 1:N_2
        %G(u,tau) = exp(-1i*u*tau/2);
        G(u,tau) = cos(u*tau/2);
    end
end
% Expand to 4 quandrents
G = [ fliplr(G(:,2:end)) G];  	% Add 2nd quadrant
G = [flipud(G(2:end,:)); G];	  	% Add 3rd and 4th quadrants


      

      
      
