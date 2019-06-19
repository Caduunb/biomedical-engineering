% Example 12.4 Analysis of the image of a cell using texture and intensity
% information then combining the resultant binary images with a logical OR
% operation.
%
clear all; close all;
[I] = imread('cell.tif');       % Load "orientation" texture
I = im2double(I);                   % Convert to double
%
h = fspecial('gaussian', 20, 2);     % Gaussian lowpass filter
%
subplot(1,2,1); imshow(I);          % Display original image
    title('Original Image','FontSize',14); 
I_std = (nlfilter(I,[3 3], 'std2')) * 10;  % Texture operation
I_lp = imfilter(I_std, h);        % Average (lowpass filter)

%
subplot(1,2,2); imshow(I_lp*2);   %  Dispaly texture image
   title('Filtered image','FontSize',14); 
%
figure;  
BW_th = im2bw(I,.5);                       % Threshold image 
BW_thc = ~im2bw(I,.42);                     % and its complement
BW_std = im2bw(I_std,.2);                     % Threshold texture image
BW1 = BW_th | BW_thc;                   % Combine thwo trhesholded images
BW2 = BW_std | BW_th | BW_thc;               % Combine all three images 
subplot(2,2,1); imshow(BW_th);             % Display threshoded and 
    title('Threshold 0.5','FontSize',12);
subplot(2,2,2); imshow(BW_thc);   %  combined images
    title('Threshold 0.42','FontSize',12);
subplot(2,2,3); imshow(BW1);
    title('0.42 OR 0.5','FontSize',12);
subplot(2,2,4); imshow(BW2);
    title('.42 OR .5 OR Std','FontSize',12);
save Ex12_4_data BW2;


    
       
    