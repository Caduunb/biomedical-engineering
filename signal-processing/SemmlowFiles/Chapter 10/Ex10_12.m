% Ex10.13  Use the GPA to determine the correlation dimension of the Lorenz System
% Use the GPA and the approach of Eq. 10.22 to estimate the correlation dimension of 
% the Lorenz system.  Determine the slope of the linear region of a plot of log Cd(R) versus log R. 
% Use the parameters of Example 10.10. Use embedding parameters of m = 3 and t = 6, a sampling 
% frequency of 100 Hz and 100 seconds of data. Use logarithmically spaced values of R as test
% points for the determination of the radius with 100 values between 10e-4 and 10e3.   

close all
clear

m=3; tau=6; fs=100; % Set up delay parameters using dimension 3 and delay 5 
 y0=[8,9,25]';                    % Initial values of x, y, and z for ODE45
 tspan=linspace(.01,100,10000);   % Time interval for solution
 [t,sol]=ode45(@lorenzeq,tspan,y0);   % Solve the differential equation in   

x  = sol(:,1);
R = exp(-3:.05:-1); % Setup R values to test using GPA
CR=cordim(x,tau,m,R); % Use cordim to compute C^d(R)
x1 = 18; xf = 27; % Start and stop points of observed scaling region
%%
  method = 1;
subplot(2,1,1)
  
    Cd=cor_dim_plot(R,CR,x1,xf,method); % Compute D^c and plot
subplot(2,1,2)
   method = 2;
    Cd=cor_dim_plot(R,CR,x1,xf,method); % Compute D^c and plot
%%
    % %repeat using all three dimensions of the numerical solution
figure
%%
R = exp(-1.5:.05:1.5); % Setup R values to test using GPA
CR=cordim_original(sol,R); % Use cordim to compute C^d(R)

%%
x1 = 33; xf = 40; % Start and stop points of observed scaling region
subplot(2,1,1)
    method = 1;
    Cd=cor_dim_plot(R,CR,x1,xf,method); % Compute D^c and plot
subplot(2,1,2)
   method = 2;
    Cd=cor_dim_plot(R,CR,x1,xf,method); % Compute D^c and plot
