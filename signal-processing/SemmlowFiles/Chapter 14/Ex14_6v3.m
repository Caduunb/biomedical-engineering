% Ex 14.6 Use opening to remove the dark patches in the thresholded cell image.
%   of Figure 14.17.
%  Also remove both the black and white artifacts from the
%  texture-segmented image of Figure 12.12 (right side; BW3)
%
close all; clear all;
%
load Ex14_4_data;                       % Get data of Figure 12.17 (BW2)
SE = strel('square',5);             % Define structure: disk radius 4 pixels
BW1= ~imopen(~BW2,SE);               % Opening operation
%
subplot(1,2,1); imshow(BW2); title('Original Image','FontSize',12);
subplot(1,2,2); imshow(BW1); title('Opened Inverted','FontSize',12);
%
figure; clear BW1 BW2 BW3;
load Ex12_2_data;
BW = ~imopen(~BW3,SE);               % Opening operation
BWA = imopen(BW,SE);
subplot(1,3,1); imshow(BW3); title('Original Image','FontSize',12);
subplot(1,3,2); imshow(BW); title('Opened Image','FontSize',12);
subplot(1,3,3); imshow(BWA); title('Opened Inverted','FontSize',12);


