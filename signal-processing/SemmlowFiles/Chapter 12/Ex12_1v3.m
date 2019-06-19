% Example 12.1 
% Generate a sinewave grating 400 by 400 pixels
%   The grating should vary horizontally with a spatial frequency of 4 cycles per inch.
%   Assume the hoizontal and vertical dimensions are 4 inches
%
clear all; close all;
N = 400;
Nu_cyc = 4;                         % Produce 4 cycle grating
x = (1:N)*Nu_cyc/N;                 % Generate spatial vector   
% Generate sine; scale between 0 and 1
I_sin(1,:) = .5 * sin(2*pi*x) + .5;
I_8 = im2uint8(I_sin);            % Convert to a uint8 vector
I = repmat(I_8,400,1);            % Add 400 rows
imshow(I);                         % Display image
title('Sinewave Grating','FontSize',14);