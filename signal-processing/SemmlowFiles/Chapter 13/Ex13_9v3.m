% Example 13.9 Interactive Image Registration 
% Load a frame of the MRI image (mri.tif) and perform a spatial 
%     tranformation that tilts the image backward.
% Use interactive registration and the MATALAB function 'cp2tform'
%   to realing the image
%
clear all; close all;
frame = 18;
nu_points = 4;                      % Number of image reference points
[I(:,:,:,1), map ] = imread('mri.tif', frame);
if isempty(map) == 0                    % Check to see if Indexed data
    I = ind2gray(I,map);                % If so, convert to Intensity image
else 
    I = im2double(I);                 % Convert to double and scale
end
[M N]= size(I);                     
%
% Perform projective transformation
U = [1 1; 1 M; N M; N 1];
offset = .15*N;
H = .2 * N;
V = .15 * M;
X = [1-offset+H 1+offset-V; 1+offset+H M-offset-V; N-offset+H M-offset-V; N+offset+H 1+offset-V]; 
Tform1 = maketform('projective', U, X);
I_transform = imtransform(I,Tform1,'Xdata',[1 N],'Ydata',[1 M]);
%
% Open two display windows 
fig(1) = figure;
    imshow(I);
fig(2) = figure;
    imshow(I_transform);
    title('Input eight reference points');
    %
for i = 1:2  % Get reference point for both images
    figure(fig(i)); 
    hold on;
    title('Enter four reference points');
    for j = 1:nu_points    
        [x(j,i), y(j,i)] = ginput(1);  % Get ref. point
        plot(x(j,i), y(j,i),'X');  % mark ref. point
    end
end    
%
[Tform2, inpts, base_pts] = cp2tform([x(:,2) y(:,2)],[x(:,1) y(:,1)],'projective');
I_aligned = imtransform(I_transform,Tform2,'Xdata',[1 N],'Ydata',[1 M]);   
%
disp([inpts base_pts]);
subplot(1,3,1);;
imshow(I);       %Display the images
    title('Reference Image','FontSize',14);
subplot(1,3,2);  imshow(I_transform);
    title('Input Image','FontSize',14);
subplot(1,3,3); imshow(I_aligned);
    title('Realigned','FontSize',14);