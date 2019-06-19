% Example 13.4  
%  Example of various Spatial Transformations
%  Input the image of human prostrate tissue (tissue.png) and perform two 
%   spatial transformations: 1) Stretch the object by 50% in the 
%   horizontal direction; 2) Rotate the image clockwise by 30 deg.
%   with and without cropping.
% Display the original and transformed images.

clear all; close all;
[I map] = imread('hestain.png');     % Input image 
if isempty(map) == 0                 % Check to see if Indexed data
    I = ind2gray(I,map);             % If so, convert to Intensity image
end 
I = im2double(rgb2gray(I));          % Convert to double and scale
    %
% Rotate image
I_rotate = imrotate(I,-45,'bilinear');   % Rotation
I_rotate_crop = imrotate(I, -45, 'bilinear', 'crop');
%
% Stretch by 25% horizontally
[M N] = size(I);
I_stretch = imresize(I,[M N*1.25], 'bilinear');
%
subplot('Position',[.01 .50 .42 .4]); 
imshow(I);       %Display the images
    title('Original','FontSize',14);
subplot('Position',[.45 .50 .50 .4]);
imshow(I_stretch);
    title('Horizontal Stretch','FontSize',14);
subplot('Position',[.01 .01 .45 .4]); 
  imshow(I_rotate);
    title('Rotated','FontSize',14);    
subplot('Position',[.47 .01 .45 .4]); 
  imshow(I_rotate_crop);
  title('Rotated ~ Cropped','FontSize',14);