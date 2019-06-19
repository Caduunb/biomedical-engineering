% Example 10.3 Solve the differential equations for the pendulum given in Eqs. 10.2 and 
% 10.3 and plot the phase plane.  Solve for two conditions: no damping, 
% b = 0, and a damping factor of b = 0.2.  Plot the state variables, angle 
% and angular velocity, as time functions and plot the phase plane 
% for the two conditions.
close all;clear all

%set up time span and inintial values for ODE45
tspan=[0,50];
theta_0=[-1;0];

%damping factor is 0.2
b= .3
k = 0;
%Use ODE45 with function Pendamp to solve differential equation
[t,sol]=ode45(@pend,tspan,theta_0,[],b,k);
theta = sol(:,1);
omega = sol(:,2);
%plot single axis versus time and state variables for
%time and phase space

subplot(2,2,1)
    plot(t,theta,'k')
    xlabel('Time (sec)')
    ylabel('Angle (rads)')
    title('Damped Pendulum Angle' )    
    grid on
subplot(2,2,3)
    plot(t,omega,'k')
    xlabel('Time (sec)')
    ylabel('Velocity (rads/sec)')
    title('Damped Pendulum Velocity' ) 
    grid on
subplot(1,2,2)
    plot(theta,omega,'k')
    axis([-1.1,1.1,-1.1,1.1])
    axis square
    xlabel('Angle (rads)')
    ylabel('Velocity (rads/sec)')
    title('Phase Plane of Damped Pendulum')
    grid on
%repeat with zero damping  
b=0;
[t,sol]=ode45(@pend,tspan,theta_0,[],b,k);
theta = sol(:,1);
omega = sol(:,2);    
set(findall(gcf,'type','text'),'FontSize',12) 
figure
subplot(2,2,1)
    plot(t,theta,'k')
    xlabel('Time (sec)')
    ylabel('Angle (rads)')
    title('Angle (No Damping)' )    
    grid on
subplot(2,2,3)
    plot(t,omega,'k')
    xlabel('Time (sec)')
    ylabel('Velocity (rads/sec)')
    title('Velocity (No Damping)' ) 
    grid on
subplot(2,2,[2,4])
    plot(theta,omega,'k')
    axis([-1.1,1.1,-1.1,1.1])
    axis square
    xlabel('Angle (rad)')
    ylabel('Velocity (rads/sec)')
    title('Phase Plane of Pendulum (No Damping)')
    grid on 
    set(findall(gcf,'type','text'),'FontSize',12) 
    set(findall(gca,'type','text'),'FontSize',12) 