% Example 13.5 General Spatial Transformations
% Load a frame of the MRI image (mri.tif) 
%   and perform two spatial tranformations
%   1) An affine transformation that 
%   2) A projective transformation that tilts the image backward 
%   3) A projective transformation that tilts the image forward
%
clear all; close all;
frame = 18;
[I(:,:,:,1), map ] = imread('mri.tif', frame);
if isempty(map) == 0                    % Check to see if Indexed data
    I = ind2gray(I,map);                % If so, convert to Intensity image
else 
    I = im2double(I);                 % Convert to double and scale
end
[M N]= size(I);                     
%
% Define afine transformation
U1 = [N/2 1; 1 M; N M];               % Input triangle
X1 = [1 1; 1 M; N N];               % Output triangle
Tform1 = maketform('affine', U1, X1);
I_affine = imtransform(I,Tform1,'Xdata',[1 N],'Ydata',[1 M]);
%
% Define projective transformation
U = [1 1; 1 M; N M; N 1];
offset = .15*N;
X = [1-offset 1+offset; 1+offset M-offset; N-offset M-offset; N+offset 1+offset]; 
Tform2 = maketform('projective', U, X);
I_proj1 = imtransform(I,Tform2,'Xdata',[1 N],'Ydata',[1 M]);
%
% Second transformation. Define new output quadrilateral
X = [1+offset 1+offset; 1-offset M-offset; N+offset M-offset; N-offset 1+offset]; 
Tform3 = maketform('projective', U, X);
I_proj2 = imtransform(I,Tform3,'Xdata',[1 N],'Ydata',[1 M]);
%
subplot(2,2,1);
 imshow(I);       %Display the images
    title('Original','FontSize',12);
subplot(2,2,2);
    imshow(I_affine);
    title('Affine Transformation','FontSize',12);
subplot(2,2,3);
    imshow(I_proj1);
    title('Projective Transformation 1','FontSize',12);
subplot(2,2,4);
    imshow(I_proj2);
    title('Projective Transformation 2','FontSize',12);