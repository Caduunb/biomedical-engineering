% Example 15.1 and Figure 15.4.
%  Image Reconstruction using back-projection and filtered
%      back-projection.
% Uses MATLAB's 'iradon' for filtered backprojection and 'i_back', a version
%   of 'iradon' modified to eliminate the filter.  
% Construct a simple image consisting of a white square against a 
%     black bakcground.  Then apply back-projection without filtering
%   and with the derivative (Ram-Lak) filters. 
% Display the original and reconstructed images along with the
%     projections.  
%
clear all; close all;
I = zeros(128,128);
I(44:84,44:84) = 1;
%
delta_theta = (1:180);        % Angle between projections is one degree
[p,xp] = radon(I,delta_theta);
I_back = iradon(p,delta_theta,'none');
I_back = mat2gray(I_back);      % Concert to grayscale
I_filter_back = iradon(p,delta_theta);
%
subplot(2,2,1);
    imshow(I); title('Original Image');
subplot(2,2,2);
    imshow(mat2gray(p)); title('Projections')
subplot(2,2,3)
    imshow(I_back); title('Backprojection Only');
subplot(2,2,4);
    imshow(I_filter_back); title('Ram-Lak');


    