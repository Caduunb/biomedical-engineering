% Example 14.2 Continunity-based segmentation.
% Load image 'texture3'.tif' which contains three regions having 
% the same average intensities,but different textural paterns.
%   Apply the "range" nonlinear operator using 'nlfilter'
%   Plot original and Range images and their histograms 
%
clear all; close all;
[I] = imread('texture3.tif');                   % Load image and 
I = im2double(I);                               %   Convert to double
%
range = inline('max(max(x)) - min(min(x))');    % Range function
I_f = nlfilter(I,[7 7], range);                 % Compute local range
I_f = mat2gray(I_f);
%
imshow(I);                                      % Display results
    title('Original Figure','FontSize',14);
figure; imshow(I_f);
    title('"Range" Image','FontSize',14);
figure;
subplot(2,1,1);  imhist(I);                     % Display both histograms
   title('Original Histogram','FontSize',14);
   xlabel('Intensity','FontSize',14);
   ylabel('Number of Pixels','FontSize',14);
subplot(2,1,2);  imhist(I_f);
   title('"Range" Histogram','FontSize',14);
   xlabel('Intensity','FontSize',14);
   ylabel('Number of Pixels','FontSize',14);
   
figure; 
BW1 = ~im2bw(I_f,.21);               % Isolate upper texture
BW2 = im2bw(I_f,.55);                % Isolate right-side texture
BW3 = ~ BW1 & ~BW2;                  % Isolate remaining texture
subplot(2,3,1); imshow(BW1);         % Display three segments
subplot(2,3,2); imshow(BW2);        
subplot(2,3,3); imshow(BW3);
subplot(2,3,4); imshow(I.*BW1);         % Display three segments
subplot(2,3,5); imshow(I.*BW2);        
subplot(2,3,6); imshow(I.*BW3);
save 'Ex14_2_data.mat' BW1 BW2 BW3;   % Save isolated section  
   
    
    
       
    