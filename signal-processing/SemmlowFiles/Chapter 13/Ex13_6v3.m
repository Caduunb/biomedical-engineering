% Example 13.6  Construct a series of projective transformations that when
% shown as a movie give the appear-ance of the image tilting backward in
% space.  Use one of the frames of the MRI image.
%
clear all; close all;
frame = 18;                     % Desired frame number
Nu_frame = 12;                  % Number of frames used in each direction
Max_tilt = .4;                  % Maximumu tilt achieved
[I(:,:,:,1), map ] = imread('mri.tif', frame);
if isempty(map) == 0            % Check to see if Indexed data
    I = ind2gray(I,map);        % If so, convert to Intensity image
else 
    I = im2double(I);           % Convert to double and scale
end
[M N]= size(I);                     
%
U = [1 1; 1 M; N M; N 1];
for i = 1:Nu_frame              % Construct movie frames
    
    % Define projective transformation
    offset = Max_tilt*N*i/Nu_frame;
    X = [1+offset 1+offset; 1-offset M-offset; N+offset M-offset; N-offset 1+offset]; 
    Tform2 = maketform('projective', U, X);
    [I_proj(:,:,1,i), map] = gray2ind(imtransform(I,Tform2,'Xdata',[1 N],'Ydata',[1 M]));
    I_proj(:,:,1,2*Nu_frame+1-i) = I_proj(:,:,1,i);   % Make image tilt back and forth
end
%
% Display as movie
montage(I_proj(:,:,:,1:12),map);                    % Display as montage
title('Tilting Brain Movie','FontSize',14);
pause; figure;
mov = immovie(I_proj,map);
movie(mov,3);