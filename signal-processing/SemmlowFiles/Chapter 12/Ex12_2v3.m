% Example 1.2 and Figure 10-4 2
% Generate a mulitframe array consisting of sinewave gratings that vary
%   in phase from 0 to 2 * pi across 12 images  
%
% The gratings should be the same as in Example 10-1 except with
%     fewer pixels (100 by 100) to conserve memnory.  
%   Assume the hoizontal and vertical dimensions are 4 inches
%
clear all; close all;
N = 100;                        % Vertical and horizontal points 
Nu_cyc = 2;                     % Produce 4 cycle grating
M = 12;                         % Produce 12 images
x = (1:N)*Nu_cyc/N;             % Generate spatial vector 
for j = 1:M                     % Generate M (12) images
    % Generate sine; scale between 0 and 1
    phase = 2*pi*(j-1)/(M-1);     % Shift phase through 180 (2 pi) degrees
    I_sin = .5 * sin(2*pi*x + phase) + .5;
    % Add some black space at left and right borders
    I_sin = [zeros(1,10) I_sin(1,:) zeros(1,10)]; 
    I_8 = im2uint8(I_sin);      % Convert to a uint8 vector
    I_temp = repmat(I_8,100,1);            % Add 100 rows
    % Add some blac space at top and bottom borders
    I(:,:,1,j) = [zeros(10,120); I_temp; zeros(10,120)];
end    
montage(I);                     % Display image
title('Sinewave Grating','FontSize',14);
