%Example 10.1 Solve the pendulum equations for many initial conditions
%to show linear, nonlinear and chaotic time behavior
clear all;close all
initial_values = [pi/100,0]   % Initial angle is small, initial velocity is 0
k = 0;            % Driving force is 0 
b = 0;            % Damping factor is 0
tspan = [0,100];      % Create time boundaries

[t,sol]=ode45(@pend,tspan,initial_values,[],b,k);  % Use ODE45 with pend function to solve
theta=sol(:,1);                       % sol is a two column vectors of solutions
                                  % in order from lowest to highest order
                                  % column one is angle omega, column
	                              % two is angular velocity

theta=sol(:,1);
subplot(3,1,1)
    plot(t,theta,'k','Linewidth',2)
    title('pendulum Motion in Linear Behavior')
    xlabel('Time (sec)')
    ylabel('\theta')
    h =  text(5,0.036,'A');
    set(h,'fontweight','bold')


% Change angle to large angle for nonlinear solution and resolve
initial_values = [pi/1.1,0];		 % Large initial angle, 
[t,sol]=ode45(@pend,tspan,initial_values,[],b,k);  % Solve for nonlinear behavior
theta = sol(:,1);
subplot(3,1,2)
    plot(t,theta,'k','Linewidth',2)
    title('pendulum Motion in Noninear Behavior')
    xlabel('Time (sec)')
    ylabel('\theta')
    h =  text(5,3,'B')
    set(h,'fontweight','bold')
%
% For chaotic motion, increase driving force to 0.75 and solve
tspan = [0,500];		 % Extend the solution time frame   
k =.75;   			 % Add driving force
initial_values = [pi/100,0];		 % Small initial angle. 
[t,sol]=ode45(@pend,tspan,initial_values,[],b,k);  % Solve for chaotic behavior
theta=sol(:,1);
theta = mod(pi+theta,2*pi)-pi; % Creates circular boundary conditions from –pi
				 %  to pi. Needed because the pendulum 
				 %  may invert and go past pi degrees (vertical)

subplot(3,1,3)
    plot(t,theta,'k','Linewidth',2)
    title('pendulum Motion in Chaotic Behavior')
    xlabel('Time (sec)')
    ylabel('\theta')
    axis([0,200,-5,5])
    h =  text(10,4,'C')
    set(h,'fontweight','bold')
    set(findall(gcf,'type','text'),'FontSize',12) 