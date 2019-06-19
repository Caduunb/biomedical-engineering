% Example 9.1 and Figure 9.6
% Example of data rotation
% Create a two variable data set of x2 = sin (x1)
%    then rotate the data set by an angle of 45 deg
%
clear all; close all;
N = 100;                % Data length
x(1,:) = (0:N-1)/N;            % Create a two variable data set: x1 linear
x(2,:) = 0.1 * sin(x(1,:)*4*pi);   % x2 = sin(x1) - two periods
plot(x(1,:),x(2,:),'k','LineWidth',2);       % Plot points
xlabel('x_1 & y_1','FontSize',14); 
ylabel('x_2 & y_2','FontSize',14);
phi = 45*(2*pi/360);            % Rotation angle equals 45 deg
y = rotation(x,phi);            % Rotate
hold on;
plot(y(1,:),y(2,:),'k','LineWidth',2);       % Plot rotated data
plot([0 0],[-.1 1],'k');          % Plot vertical line
plot([-.1 1],[0 0],'k');         % Plot horixontal line
axis([-.1 1 -.1 1]);
axis('square');