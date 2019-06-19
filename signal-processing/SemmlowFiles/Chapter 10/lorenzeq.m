function yprime = lorenzeq(t,y)
%  Function containing the Lorenz equations. This is used with ODE45
%  The rows of yprime correspond to equations 10.8 10.9 and 10.10
%  y(1) is x, y(2) is y, and y(3) is z.  

% The Lorenz equation gives chaotic solutions for these parameter values
sigma = 10.;
R = 28.;
Beta = 8./3.;

  yprime=[ sigma.*(y(2)-y(1));        %dx/dt
           y(1).*(R-y(3))-y(2);       %dy/dt
           y(1).*y(2)-Beta*(y(3))];   %dz/dt
  