function dxy  = vanderpol(t,xy,u)
% function for the system of differential equations
% equivilant to the vanderpol equation x''-u(1-x^2)*x' + x = 0;

dxy = [xy(2);
       u*(1-xy(1)^2)*xy(2)-xy(1)];