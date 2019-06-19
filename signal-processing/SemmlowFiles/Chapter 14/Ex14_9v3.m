% Example 12.9 Example of the Hough Transform (implemented using radon)
%   to identify lines in an image.   
% Use the image of Saturn in saturn.png
%
clear all; close all;
theta = 0:179;                      % Define projection angles
conv = 2*pi/360;                    % Convert from degrees to radians
I = imread('saturn1.tif');           % Get image of Saturn
BW = edge(I,'canny',.05);         % Threshold image
[R,xp] = radon(BW,theta);           % Radon Transform
%
fig1 = figure; subplot(1,2,1);
imshow(I);
subplot(1,2,2);
imshow(BW)                           % Display original image
    title('Canny','FontSize',14);
fig2 = figure; imagesc(theta, xp, 1.5*R); colormap(hot);
 title('Radon Transform','FontSize',14);
% 
[~, c] = max(max(R));               % Find maximum element
[~, r] = max(R(:,c)');
% Convert to rectangular coordinates
[ri ci] = size(I);                 % Size of image array
[ra ca] = size(R);                  % Size of accmulator array
phi = theta(c);                    % Convert to deg
r = xp(r);
m = tan((c-90)*conv);               % Slope from theta
b =  r/cos((c-90)*conv);             % From basic trigometry 
x = (0:ci);
y = m*x + b;                        % Consturct line 
figure(fig1); subplot(1,2,2); hold on;
    plot(x,-y,'w','LineWidth',3);                 % Plot line on graph
figure(fig2); hold on;
    plot(phi, r,'*b','MarkerSize',14,'LineWidth',2);  % Plot the marker
    xlabel('Angle (deg)','FontSize',14); ylabel('Offset','FontSize',14);
    
