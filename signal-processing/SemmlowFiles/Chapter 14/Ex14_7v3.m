%  Example 14.7 Demonstration of imfill with option 'holes' on grayscale
% followed by thresholding and opening to produce a segmented image
%  of the blood cells.

%
clear all; close all;
I = imread('blood1.tif');
I = im2double(I);
I1 = imcomplement(I);        % Invert Threshold orignal image.  
%
I2 = imfill(I1,'holes'); 
BW = im2bw(I2,.5);
SE = strel('disk',5);           % Define structure: disk of radius 4 pixels    
BW1 = imopen(BW,SE);
subplot(1,2,1); imshow(I);      % Use opened image
    title('Original Image','FontSize',14);
subplot(1,2,2); imshow(imcomplement(I2));
    title('Filled Image','FontSize',14);
% 
figure;
subplot(1,2,1); imshow(BW);      % Use opened image
    title('Threshold 0.5','FontSize',14);
subplot(1,2,2); imshow(BW1);
    title('Opened Image','FontSize',14);
    I_seg = I.*(BW1);
    %I_seg = mat2gray(I_seg);
    figure; imshow(2*I_seg);
    
    
       
    