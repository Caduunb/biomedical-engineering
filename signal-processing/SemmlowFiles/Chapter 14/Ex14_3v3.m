% Example 14.3 Analysis of texture pattern having similiar textural characteristics 
%   but with different orientations.  Use a direction specific filter.
%
clear all; close all;
[I] = imread('texture4.tif');       % Load "orientation" texture
I = im2double(I);                   % Convert to double
%
% Define filters and functions
h_lp = fspecial('gaussian',[20 20], 4);     % Gaussian lowpass filter
%
I_nl = nlfilter(I, [9 1],'max(x) - min(x)');          % Directional nonlinear filter
I_f = imfilter(I_nl*2, h_lp);              % Average (lowpass filter)
I_f = mat2gray(I_f);                    % Scale intensities
%
subplot(2,2,1); imshow(5*I_nl);            % Display image and histogram 
    title('Modified Image','FontSize',12);                %  before lowpass filtering 
subplot(2,2,2); imhist(I_nl);               %  and after lowpass filtering
   xlabel('Intensity','FontSize',12);
   ylabel('Number of Pixels','FontSize',12);
subplot(2,2,3); imshow(3.5*I_f);            % Display modified image
    title('Modified Filtered Image','FontSize',12);
subplot(2,2,4); imhist(I_f); 
   xlabel('Intensity','FontSize',12);
   ylabel('Number of Pixels','FontSize',12);
%                              
figure; 
BW1 = ~im2bw(I_f,.1);               % Isolate upper texture
BW2 = im2bw(I_f,.29);                % Isolate right-side texture
BW3 = ~ BW1 & ~BW2;                  % Isolate remaining texture
subplot(1,3,1); imshow(BW1);         % Display three segments
subplot(1,3,2); imshow(BW2);        
subplot(1,3,3); imshow(BW3);
save 'Ex14_3_data.mat' BW1 BW2 BW3;

    
       
    