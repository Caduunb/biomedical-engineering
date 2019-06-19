% Example 14.8 and Figure 14.25 and 14.26
% Apply various edge detection schemes to the blood
%  cell image
%
clear all; close all;
[I map] = imread('blood1.tif');
if isempty(map);
    I = im2double(I);
else
    I = ind2gray(I, map);
end
%
% Apply the 5 filters to the cell image
[BW1,thresh1] = edge(I,'sobel',.13,'nothinning'); 
[BW2,thresh2]=  edge(I,'roberts',.09,'nothinning');
[BW5,thresh3]= edge(I,'prewitt',.13,'nothinning');
[BW3,thresh4] = edge(I,'log',.004);
[BW4,thresh5] = edge(I,'canny',[.04 .08]);
%
subplot(2,2,1);
imshow(I);
   title ('Original Image','FontSize',12);
subplot(2,2,2);
imshow(BW1);
   title ('Sobel Thresh: 0.13','FontSize',12);
subplot(2,2,3);
imshow(BW2);
   title ('Roberts thresh: 0.09','FontSize',12);
subplot(2,2,4);
imshow(BW5);
   title ('Prewitt Thresh: 0.13','FontSize',12);   
   figure;
   subplot(1,2,1) 
imshow(BW3);
   title ('Log Thresh: 0.004','FontSize',12);
subplot(1,2,2);   
imshow(BW4);
   title ('Canny Thresh 0.4, 0.8','FontSize',12);


    
