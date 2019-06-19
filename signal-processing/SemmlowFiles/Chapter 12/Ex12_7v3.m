% Example 12.7
%  Demonstration of Sliding Neighborhood operations
% Load image of blood cells, blood.tiff from the Image Processing 
%  Toolbox in subdirectory imdemos.
% Use a sliding 3 by 3 element block to perform several Sliding
%   Neighborhood operations including taking the average over the 
%   block, impleminting the function 'F' in the MATLAB Statement 
%   above, and implementing a function that enhances vertical boundaries.
% Display the original and all modification on the same plot
%
clear all; close all;
[I map] = imread('blood1.tif');   % Input image 
% Since image is stored in tif format, it could be in either uint8 or 
%   unit16 format (although the 'whos' command shows it is in uint8). 
% The specific data format will not matter since the format will be 
%   converted to double either by 'ind2gray,' if it is an Indexed image
%   or by the 'double assignment (in conjunction with 'mat2gray' for 
%   appropriate scaling.  
%  
if isempty(map) == 0                % Check to see if Indexed data
    I = ind2gray(I,map);            % If so, convert to Intensity image
end 
I = im2double(I);               % Convert to double and scale
                                     %   if not already
%
% Perform the various Sliding Neighborhood opeations.
I_avg = nlfilter(I,[10 10], 'mean2'); % Average the image 
F = inline('x(2,2) - sum(x(1:3,1))/3 - sum(x(1:3,3))/3 - x(1,2) - x(3,2)');
I_diff = nlfilter(I, [3 3], F);
F1 = inline ('sum(x(1:3,2)) - sum(x(1:3,1))');
I_vertical = nlfilter(I,[3 2], F1);
%
% Rescale all arrays
I_avg = mat2gray(I_avg);           
I_diff = mat2gray(I_diff);  
I_vertical = mat2gray(I_vertical);  
BW_left = ~im2bw(I_vertical,.68);    % Identify left boundaries
BW_right = im2bw(I_vertical,.8);     % Identify right boundaries
%
subplot(3,2,1);                     % Display all images in a single plot
    imshow(I);
    title('Original');
subplot(3,2,2);
    imshow(I_avg);
    title('Averaged');
subplot(3,2,3);
    imshow(I_diff);
    title('Differentiated');
subplot(3,2,4);
    imshow(I_vertical);                    
    title('Vertical boundaries');
subplot(3,2,5);
    imshow(BW_left);
    title('Left boundaries');
subplot(3,2,6);
    imshow(BW_right);
    title('Right boundaries');
figure;
subplot(1,2,1);
    imshow(BW_left);
    title('Left boundaries');
subplot(1,2,2);
    imshow(BW_right);
    title('Right boundaries');
    
                                