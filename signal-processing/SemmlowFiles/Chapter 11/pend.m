function d_theta_omega = pend(t,theta_omega,b,k)
% The system equations of a damped driven pendulum
% given in equation 10.2 and 10.3
% g/l = 1 the gravity and length constants are normalized to 1
% t is a required time vector
% b is the damping factor, f is the forcing factor


d_theta_omega = [theta_omega(2);
    - sin(theta_omega(1)) + k*sin(t) - b*theta_omega(2)];

