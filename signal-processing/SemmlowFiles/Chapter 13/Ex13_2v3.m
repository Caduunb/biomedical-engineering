% Example 13.2 
%  Example of linear filtering using selected filters from the
%   MATLAB fspecial funciton.
% Load the blood cell image and apply the 3 by 3 "unshape" contrast 
%   enhancement filter shown in the text. 
% Also apply a by 3 Sobel filter to enhance both horizontal and vertical edges
%
% Load the image and transform data class if necessary
clear all; close all;
N = 16;                                      % Filter order
w_lp = .01;                             	% Lowpass cutoff frequency
w_hp = .1;                                  % Highpass cutoff frequeny
%[I map] = imread('cell.tif');         % Input image 
frame = 17;
[I(:,:,:,1), map ] = imread('mri.tif', frame);
if isempty(map) == 0                    % Check to see if Indexed data
    I = ind2gray(I,map);                 % If so, convert to Intensity image
else 
    I = im2double(I);                      % Convert to double and scale
end                                              %   if not already
b_unsharp = fspecial('unsharp',.5);
I_unsharp = imfilter(I,b_unsharp);
%
b_s = fspecial('sobel');            % Get basic Sobel filter
% Apply horizontal Sobel filter
I_sobel_horin = imfilter(I,b_s);
I_sobel_vertical = imfilter(I,b_s');
I_sobel_combined = im2bw(I_sobel_horin) | im2bw(I_sobel_vertical);
%
subplot('Position',[.1 .55 .30 .35]);
imshow(I);       %Display the images
    title('Original','FontSize',14);
subplot('Position',[.50 .55 .30 .35]);
imshow(I_unsharp);
    title('Unsharp','FontSize',14);
subplot('Position',[.1 .1 .30 .35]);
imshow(I_sobel_horin);
    title('Horizontal Sobel','FontSize',14);
subplot('Position',[.50 .1 .30 .35]);
imshow(I_sobel_combined);
title('Combined Image','FontSize',14);
%
figure;                         % Now plot the unsharp and Sobel
subplot('Position',[.1 .2 .30 .6]);
F= fftshift(abs(fft2(b_unsharp,32,32)));
f = -N:N-1;                 
mesh(f,f,F); colormap(bone); caxis([0 20]);
    title('Unsharp Filter','FontSize',14);  view([-37,15]);
    xlabel('Horizontal Frequency','FontSize',12); ylabel('Vertical Frequency','FontSize',12);
     zlabel('Magnitude','FontSize',12);
   
%
F = fftshift(abs(fft2(b_s,32,32)));
subplot('Position',[.55 .2 .30 .6]);
    mesh(f,f,F); colormap(bone); caxis([0 20]);
    title('Sobel Filter','FontSize',14);  view([-37,15]);
     xlabel('Horizontal Frequency','FontSize',12); ylabel('Vertical Frequency','FontSize',12);
     zlabel('Magnitude','FontSize',12);
   

