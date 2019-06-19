% Example 11.8  Show that the Shannon Entropy is the same
% for the Lorenz signal and it's surrogates
close all
clear

 y0=[8,9,25]';                    % Initial values of x, y, and z for ODE45
 tspan=linspace(.01,100,10000);   % Time interval for solution
 [t,sol]=ode45(@lorenzeq,tspan,y0);   % Solve the differential equation in   


x=sol(:,1);  % The signal is the x dimension of the Lorenz system.

% Use 1024 frequency components, this is sufficient for the FFT
Lorenz_entropy = specen(x)
% Then repeat with surrogate
surrogate = gauss_surrogate(x);
surrogate_entropy = specen(surrogate)

