% Example 10.7 Use the method of false nearest neighbors to determine an appropriate 
% embedding dimension for the Lorenz system.  Use a maximum embedding 
% dimension of 6, and embedding delay of 6, and a distance threshold of 0.1
% times the standard deviation of the signal.

y0=[8,9,25]';                    % Initial values of x, y, and z for ODE45
tspan=linspace(.01,100,10000);   % Time interval for solution
[t,sol]=ode45(@lorenzeq,tspan,y0);   % Solve the differential equation in   

x = sol(:,1); % Get x,y and z solutions from output sol
m = 6;            		      % Largest tested embedding dimension
tau = 6;					% Delay is 6 samples
r = 3;	                  % radius used
numnear = fnumnear(x,tau,m,r);    % Perform nearest neighbor operation


      plot(numnear,'k','linewidth', 2)
    axis([1,6,0,0.45])
     ylabel('Average Number of False Nearest Neighbors')
    xlabel('Embedding Dimension')
    set(gca,'FontSize',14)
    grid on
set(findall(gcf,'type','text'),'FontSize',14) 