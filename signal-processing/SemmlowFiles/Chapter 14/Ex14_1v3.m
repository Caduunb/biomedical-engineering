% Example 14.1 and Figure 14.2, Figure 14.3, and Figure 14.6
% Lowpass filtter blood cell image, then display histograms
%   before and after edge point removal. 
% Applies "optimal" threshold routine to both original and "masked" 
%   images and display the results
%
clear all; close all;
[I map] = imread('blood1.tif');
if isempty(map);
    I = im2double(I);
else
    I = ind2gray(I, map);
end
h = fspecial('gaussian',12,2);          % Construct gaussian filter
I_f = imfilter(I,h,'replicate');           % Filter image
%                                   
I_edge = edge(I_f,'canny',.3);         % To remove edge points, find edge,
I_rem = I_f .* ~I_edge;                 %   complement and use as mask 
%
subplot(1,2,1); imshow(I_edge);
    title ('Canny Edge','FontSize',12);
subplot(1,2,2); imshow(imcomplement(I_edge));
    title ('Mask','FontSize',12);
figure;
subplot(2,2,1); imshow(I_f);            % Display images and histograms
    title('Original Figure','FontSize',12);
subplot(2,2,2); imhist(I_f); axis([0 1 0 1000]);
    title('Filtered Histogram','FontSize',12);
    %xlabel('Intensity','FontSize',12);
     ylabel('Number of Pixels','FontSize',12);
subplot(2,2,3); imshow(I_rem);
    title('Edge Removed','FontSize',12);
subplot(2,2,4);  imhist(I_rem); axis([0 1 0 1000]);
    %xlabel('Intensity','FontSize',12);
    ylabel('Number of Pixels','FontSize',12);
    title('Edge Removed histogram','FontSize',12);
figure;
t1 = graythresh(I);  
t2 = graythresh(I_f);
subplot(1,2,1); imshow(im2bw(I,t1));
    title('Threshold Original Image','FontSize',14);
subplot(1,2,2);  imshow(im2bw(I_f,t2));
    title('Threshold Masked Image','FontSize',14);
    
   
    
    
       
    