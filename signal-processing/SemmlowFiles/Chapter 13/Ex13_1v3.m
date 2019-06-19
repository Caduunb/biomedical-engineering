% Example 13.1  Two-dimensional Fourier Transform of a simple object.
%  Consturct a simple 2 by 16 pixel rectangular object, or bar.
% Take the Foruier Transform padded to 256 by 256 and plot the 
%   result as a 3 dimensional function (using mesh) and as an 
%   intensity image.
%
% Construct object
close all; clear all;

I = zeros(22,30);               % Original figure can be any size since it
I(10:12,10:20) = 1;             %   will be padded 
F = fft2(I,128,128);            % Take Fourier Transform padded to 128
F = abs(fftshift(F));           % Shift center; get log magnitude
%
imshow(I);                      % Plot object
xlabel('X','FontSize',14); ylabel('Y','FontSize',14);
figure;
mesh(F); colormap(hot);         % Plot Fourier Transform as function
 xlabel('Horizontal Frequency','FontSize',12); ylabel('Vertical Frequency','FontSize',12);
axis([0 128 0 128 0 30]); 
caxis([0 50]);
%
figure;
F = log(F);                     % Take log function
I = mat2gray(F);                % Scale as intensity image
imshow(I); colormap(bone);       % Plot Fourier Transform as image
xlabel('Horizontal Frequency','FontSize',14); ylabel('Vertical Frequency','FontSize',14);

