% Example 14.5 and Figure 12-15 and 12-16
% Demonstration of opening to eleminate small artifacts and
%   of closing to fill gaps
% Thes operation will be applied to the thresholed blood cell
%   images of Figure 12-3 (left image).  
% Uses a circular or disk shaped structure 4 pixels in diameter
%
clear all; close all;
I = imread('blood1.tif');
I = im2double(I);
BW = ~im2bw(I,graythresh(I));    % Threshold and invert orignal image.  
%
SE1 = strel('disk',4);           % Define structure: disk of radius 4 pixels
BW1= imerode(BW,SE1);            % Opening operation: erode image first,
BW2 = imdilate(BW1,SE1);         %  then dilate.
%
subplot(2,2,1); imshow(~BW);
    title('Original Image','FontSize',12);
subplot(2,2,2); imshow(BW1);
    title('Eroded Inverted Image','FontSize',12);
subplot(2,2,3);  imshow(BW2);
    title('Opened Image','FontSize',12);
subplot(2,2,4); imshow(~BW2);
    title('Opened Image Noninverted','FontSize',12)
%
SE2 = strel('disk',4);           % Define closing structure: disk radius 4 pixels
BW3= imdilate(BW,SE2);           % Closing operation, dilate image first
BW4 = imerode(BW3,SE2);          %  then erode
%
figure;
subplot(2,2,1); imshow(~BW);      % Use opened image
    title('Original Inverted','FontSize',12);
subplot(2,2,2); imshow(BW3);
    title('Dilated Image Inverted','FontSize',12);
subplot(2,2,3);  imshow(BW4);
    title('Closed Image','FontSize',12);
subplot(2,2,4); imshow(~BW4);
   title('Closed Image Non-inverted','FontSize',12);
    
    
       
    