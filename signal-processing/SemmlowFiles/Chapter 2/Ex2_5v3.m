% Example 2.5 Find the angle between two vectors in deg: x = [1.7, 3, 2.2] and
% y = [2.6, 2.4, 3.2]. Since these vectors are short, plot the two in 3-Dimensions.
% Solution.  Consruct the two vectors and find the scalar product using 
% Eq. 2.32 (same as Eq.2.31).  Solve Eq. 2.33 for the angle and apply.
%
clear all; close all;
x = [1.7, 3, 2.2];              % Generate the vectors
y = [2.6, 1.6, 3.2];
sp = sum(x.*y);                 % Calculate the scalar product
mag_x = sqrt(sum(x.^2));        % Calculate magnitude of x vector
mag_y = sqrt(sum(y.^2));        % Calculate magnitude of y vector
cos_theta = sp/(mag_x*mag_y);   % Calculate the cosine of theta
angle = acos(cos_theta);        % Take the arc cosine and 
angle = angle*360/(2*pi);       %    convert to degrees
disp(angle)                     % Display result
plot3(x(1),x(2),x(3),'k*','LineWidth',2);      % Plot x vector end point
hold on;
plot3([0 x(1)],[0 x(2)],[0 x(3)],'k','LineWidth',2);   % Plot x vector line
plot3(y(1),y(2),y(3),'k*','LineWidth',2);      % Plot y vector end point
plot3([0 y(1)],[0 y(2)],[0 y(3)],'k','LineWidth',2);   % Plot vector y line
title(['Angle = ',num2str(angle,2),' (deg)'],'FontSize',14);  % Output angle
grid on;
xlabel('x','FontSize',16); ylabel('y','FontSize',16); zlabel('z','FontSize',16);