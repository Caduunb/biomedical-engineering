% Example 12.4  
%  Demonstration of various image functions
%  Load all frames of the mri image in mri.tif from the
%  the MATLAB Image Processing Toolbox in subdirectory imdemos.
%  Select one frame based on a user input.  
% Process that frame by: contrast enhancement of the image, inverting the image, 
%    slicing the image windowing the image, and thresholding the image..
%  Display original and all modifications on the same figure
%
clear all; close all;
N_slice = 5;                  % Number of sliced for sliced image
Level = .75;                  % Threshold for binary image
% Initialize an array to hold 27 frames of mri.tif
% Since image is stored in tif format, it could be in unit16 format; however,
%   the 'whos' command shows it is in uint8.  
%
for    frame = 1:27                              % Read all frames into mri
    [mri(:,:,:,frame), map ] = imread('mri.tif', frame);
end    
montage(mri, map);                  % Display images as a montage
                                    % Include map in case Indexed image
frame_select = input('Select frame for processing: ');
I = mri(:,:,:,frame_select);               % Select specific frame for continued processing
% Now check to see if image is Indexed (in fact 'whos' shows it is). 
if ~isempty(map)                % Check to see if Indexed data
    I = ind2gray(I,map);            % If so, convert to Intensity image
end    
I1= im2double(I);                  % Convert to Class double
%
I_bright = immultiply(I1,1.2);      % Increase the contrast 
I_invert = imcomplement(I1);        % Compliment image
x_slice = grayslice(I1,N_slice);    % Slice image in 5 equal levels
map1 = hot(N_slice);                % Colorize sliced image 
[M N] = size(I1);
for i = 1:M                         % Multiple horizontally by a Hamming window
    I_window(i,:) = I1(i,:) .* hanning(N)';
end
for i = 1:N                         % Multiply vertically by a Hamming window
    I_window(:,i) = I_window(:,i) .* hanning(M);
end    
I_window = mat2gray(I_window);      % Scale windowed image appropriately
BW = im2bw(I1,Level);               % Convert to binary    
%
figure;
subplot(3,2,1);                     % Display all images in a single plot
 imshow(I1);
    title('Original');
subplot(3,2,2);
    imshow(I_bright);
    title('Brightened');
subplot(3,2,3);
    imshow(I_invert);
    title('Inverted');
subplot(3,2,4);
    I_slice = ind2rgb(x_slice, jet(N_slice)); % Convert to RGB (see text) 
    imshow(I_slice);                    % Display color slices
    title('Sliced');
subplot(3,2,5);
    imshow(BW );
    title('Thresholded');
subplot(3,2,6);
    imshow(I_window );
    title('Windowed');
 

    
                                