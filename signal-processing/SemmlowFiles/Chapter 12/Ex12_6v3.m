% Example 12.6  Generate an RGB image from an MR image using pseudocolor.
% Apply the pseudocolor scheme to frame 16 of the MRI images where
% grayscale values above 0.75 are coded in shades of yellow, values between
% 0.40 and 0.75 are coded into red and values below 0.33 are coded to
% green.  Each grayscale range should be expanded to cover the full range
% of color intensity.  Finally, convert the black background to blue.  To
% construct this image use masking techniques and show the masks used.
%
clear all; close all;
frame = 17;						% Load frame 17 only
[I(:,:,1,1), map ] = imread('mri.tif', frame);
if isempty(map) == 0     	% Check if indexed data
    I = ind2gray(I,map); 	% If so, convert to grayscale
end
I = im2double(I);    		% Convert to double
%   
[M N] = size(I);			% Size of image
RGB = zeros(M,N,3);     	% Initialize RGB array

BW_Y = im2bw(I,0.75);       % Threshold image for > 0.75
BW_G = ~im2bw(I,.4);        % Treshold for < 0.40
BW_R = ~BW_G & ~BW_Y;       % Threshold beteen 0.40 and 0.75
BW_B = ~im2bw(I,0.0001);    % Threshold for blue
%
RGB(:,:,1) = mat2gray(I.*BW_R|BW_Y);
RGB(:,:,2) = mat2gray(I.*BW_G|BW_Y);
RGB(:,:,3) = BW_B;
subplot(2,2,1);
  imshow(BW_G);
  title('Green Threshold < 0.4');
subplot(2,2,2);
  imshow(BW_Y);
  title('Yellow Threshold > 0.75');
subplot(2,2,3);
  imshow(BW_R);
  title('Red Threshold > 0.40 & < 0.75');
subplot(2,2,4);
  imshow(BW_B);
  title('Blue Threshold < 0.001');  
%
figure;
subplot(1,2,1);                     % Display all images in a single plot
    imshow(I);
    title('Original');
subplot(1,2,2);
    imshow(RGB)
    title('Pseudocolor');
