% Example 13.3 
%   Linear filtering. Load the blood cell image
% Apply a 16th order lowpass filter having a bandwidth of .125 fs/2, and a
%   highpass filter having the same bandwidth.  Implement the lowpass
%   filter using imfilter with the zero padding (the default) and with
%   replicated padding (extencing the final pixels).
% Plot the filter characterisitcs of the high and low pass filters
%
% Load the imageand transform if necessary
clear all; close all;
N = 32;                                 % Filter order
w_lp = .15;                            % Lowpass cutoff frequency
w_hp = .15;                           % Highpass cutoff frequeny
[I map] = imread('blood1.tif');  % Input image 
if isempty(map) == 0              % Check to see if Indexed data
    I = ind2gray(I,map);           % If so, convert to Intensity image
else 
    I = im2double(I);               % Convert to double and scale
end                                      %   if not already
b = fir1(N,w_lp);                    % Generate the lowpass filter
b2_lp = ftrans2(b);                 % Convert to 2-dimensions
I_lowpass = imfilter(I,b2_lp);       %    and apply
b = fir1(N,w_hp,'high');           % Repeat for highpass 
b2_hp = ftrans2(b);
I_highpass = imfilter(I, b2_hp);     % Apply highpass filter
I_highpass = mat2gray(I_highpass);   
I_highpass_rep = imfilter(I,b2_hp,'replicate');  % Apply lowpass filter
I_highpass_rep = mat2gray(I_highpass_rep);
b_g = fspecial('gaussian',8,2);     % Gaussian lowpass filter
I_lowgauss = imfilter(I,b_g);       % Apply Gaussain lowpass filter
%
                   %Plot the images
 subplot('Position',[.1 .55 .30 .35]);                  
imshow(I);
title('Original','FontSize',12);
subplot('Position',[.50 .55 .30 .35]);
imshow(I_highpass);
title('Highpass','FontSize',12);
subplot('Position',[.1 .1 .30 .35]);
imshow(im2bw(I_highpass,.44));
title('Highpass Thesholded');
imshow(im2bw(I_highpass_rep,.54));
title('Highpass ','FontSize',12);
subplot('Position',[.50 .1 .30 .35]);
imshow(im2bw(I_highpass_rep,.54));
title('Highpass Replicated','FontSize',12);

figure;
subplot(2,2,1); colormap(bone)
 imshow(I_lowpass);
title('Lowpass','FontSize',12);
subplot(2,2,2);
   imshow(I_lowgauss);
   title('Lowpass Gaussian','FontSize',12);
  
%
subplot(2,2,3);  % Now plot the highpass and lowpass frequency characteristics
N = 128;
F= fftshift(abs(fft2(b2_lp,N,N)));
f = -N/2:(N/2)-1;           % Relative frequency vector for plotting
mesh(f,f,F); caxis([0 2]);
    title('Lowpass Filter','FontSize',12); view([-37,15]);
    axis([-N/2 N/2 -N/2 N/2 0 1.2]);
     xlabel('Horizontal Frequency','FontSize',12); ylabel('Vertical Frequency','FontSize',12);
     zlabel('Magnitude','FontSize',12);
%
F = fftshift(abs(fft2(b2_hp,N,N)));
subplot(2,2,4); 
 F = fftshift(abs(fft2(b_g,N,N)));
 mesh(f,f,F);caxis([0 2]);
    title('Gaussian Filter','FontSize',12); view([-37,15]);
    axis([-N/2 N/2 -N/2 N/2 0 1.2]);
     xlabel('Horizontal Frequency','FontSize',12); ylabel('Vertical Frequency','FontSize',12);
     zlabel('Magnitude','FontSize',12);

figure;  % Not used   
F = fftshift(abs(fft2(b2_hp,N,N)));
mesh(1:N,1:N,F); caxis([0 2]);
    title('Highpass Filter','FontSize',12); view([-37,15]);
    axis([0 N 0 N 0 1.2]);
     xlabel('Horizontal Frequency','FontSize',12); ylabel('Vertical Frequency','FontSize',12);
     zlabel('Magnitude','FontSize',12);
    %
