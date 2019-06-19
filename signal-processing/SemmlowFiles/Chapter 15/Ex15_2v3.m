% Example 15.2 Image Reconstruction using filtered back-projection
% Uses MATLAB's 'iradon' for filtered backprojection 
% Load a frame of the MRI image (mri.tif) and construct the CT
%   projections using 'radon'.  Then apply backprojection with two 
%   different filters:  Ram-Lak and cosine (with .4 as highest frequency 
%
clear all; close all;
frame = 18;                             % Use MR image slice 18
[I(:,:,:,1), map ] = imread('mri.tif', frame);
if ~isempty(map)                    % Check to see if Indexed data
    I = ind2gray(I,map);                % If so, convert to Intensity image
end
I = im2double(I);                       % Convert to double and scale
%
% construct procjestion of MR image
delta_theta = (0:179);                  % Angle between projections is one degree
[p,xp] = radon(I,delta_theta);
%
% Reconstruct image
I1 = iradon(p,delta_theta);             % No additonal filter
I2 = iradon(p,delta_theta,'cosine');    % Standard Cosine filter
I3 = iradon(p,delta_theta,'cosine',0.5);  % Stronger cosine filter
%
subplot(2,2,1);
    imshow(I); title('Original Image','FontSize',12);
subplot(2,2,2);
    imshow(I1); title('Ram-Lak','FontSize',12);    
subplot(2,2,3);
    imshow(I2); title('Cosine','FontSize',12)
subplot(2,2,4)
    imshow(I3); title('Cosine 0.5','FontSize',12);
