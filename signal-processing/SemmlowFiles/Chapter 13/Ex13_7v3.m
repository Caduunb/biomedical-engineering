% Example 13.7
% Image registration after spatial transformation 
% Load a frame of the MRI image (mri.tif).  Transform the original
%     image by increasing it horizontally, decreasing it vertically,
%     and tilting it to the right.  Also decrease image contrast slightly
%  Use MATLAB's basic optimization routine, 'fminsearch' to find
%     the transformation that restores the original image shape.
%
clear all; close all;
frame = 18;                     % Desired frame number
H_scale = .25;                  % Re-scale dimension in percent
V_scale = .2;
tilt = .2;
[I(:,:,:,1), map ] = imread('mri.tif', frame);
if isempty(map) == 0            % Check to see if Indexed data
    I = ind2gray(I,map);        % If so, convert to Intensity image
else 
    I = im2double(I);           % Convert to double and scale
end
[M N]= size(I); 
H_scale = H_scale * N/2;          % Convert percent rescale to pixels
V_scale = V_scale * M;
tilt = tilt * N
%
% Construct distorted image.  Reduce image intensity
U = [1 1; 1 M; N M];          % Input triangle
X = [1-H_scale+tilt 1+V_scale; 1-H_scale M; N+H_scale M];  % Output triangle
Tform = maketform('affine', U, X);
I_transform = imtransform(I,Tform,'bicubic','Xdata',[1 N],'Ydata',[1 M]);
% 
% Find transformation to relign image
initial_scale = [-1 -1 -1];        % Set initial values
[scale,FVAL,error] = fminsearch('realign',initial_scale,[],I, I_transform);
disp(FVAL)                  % Display final correlation
%
% Realign imge using optimized scaling
X = [1+scale(1)+scale(3) 1 + scale(2); 1+scale(1) M; N-scale(1) M];
Tform = maketform('affine', U, X);
I_aligned = imtransform(I_transform,Tform,'bicubic','Xdata',[1 N],'Ydata',[1 M]);
%
subplot(1,3,1);
imshow(I);       %Display the shifted image
    title('Reference Image','FontSize',14);
subplot(1,3,2); imshow(I_transform);
    title('Input Image','FontSize',14);
subplot(1,3,3);  imshow(I_aligned);
    title('Aligned Image','FontSize',14);   