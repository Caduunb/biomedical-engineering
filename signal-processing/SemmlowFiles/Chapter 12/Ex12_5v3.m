% Example 12.5 Example of the use of pseudocolor
% Load the frame 21 of the mri image (mri.tif) 
%  from the Image Processing Toolbox in subdirectory imdemos.
% Plot a pseudocolor image in which all values less that 50% maximum
% plot in shade of blue and value above lot in shades of red. 
%
clear all; close all;
frame = 17;
[I(:,:,:,1), map ] = imread('mri.tif', frame);
% Now check to see if image is Indexed (in fact 'whos' shows it is). 
if isempty(map) == 0                % Check to see if Indexed data
    I = ind2gray(I,map);            % If so, convert to Intensity image
end
I = im2double(I);                % Convert to double
%
[M N] = size(I);
RGB = zeros(M,N,3);                % Initialize RGB array
for i = 1:M
    for j = 1:N                     % Fill RGB planes
        if I(i,j) > .5
            RGB(i,j,1) = (I(i,j)-.5)*2;
        else 
            RGB(i,j,3) = I(i,j)*2;
        end
    end
end
%
subplot(1,2,1);                     % Display all images in a single plot
    imshow(I);
    title('Original');
subplot(1,2,2);
    imshow(RGB)
    title('Pseudocolor');
