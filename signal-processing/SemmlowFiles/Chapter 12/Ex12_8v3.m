% Example 12.8 
%  Demonstration of Distinct Block operations
% Load image of bonemarrow, used in Example 10-5
% Use a 8 by 8 Disticnt block to get averages and standard
%   deviationfor the entire block
% Apply the 3 by 3 differentiator from Example 10-5 as a Distinct 
%   Block opeartion.   
% Display the original and all modification on the same plot
%
clear all; close all;
[I map] = imread('blood1.tif');     % Input image, same as Example 10-5 
%  
if isempty(map) == 0                % Check to see if Indexed data
    I = ind2gray(I,map);            % If so, convert to Intensity image
end 
I = mat2gray(double(I));        % Convert to double and scale
                                 %   if not already
%
% Perform the various Distinct Block operations.
% Average and standard deviation of the image 
I_avg = blkproc(I,[10 10], 'mean2 * ones(10,10)');
I_std = blkproc(I,[10 10], 'std2 * ones(10,10)');
% Deferentiator - place result in all blocks
F = inline('(x(2,2) - sum(x(1:3,1))/3 - sum(x(1:3,3))/3 - x(1,2) - x(3,2)) * ones(size(x))');
I_diff = blkproc(I, [3 3], F);
% Vertical edge detector
F1 = inline ('(sum(x(1:3,2)) - sum(x(1:3,1))) * ones(3,2)');
I_vertical = blkproc(I, [3,2], F1);
%
% Rescale all arrays
I_avg = mat2gray(I_avg);           
I_diff = mat2gray(I_diff);  
I_vertical = mat2gray(I_vertical);  
%
subplot(2,2,1);                     % Display all images in a single plot
    imshow(I);
    title('Original');
subplot(2,2,2);
    imshow(I_avg);
    title('Averaged');
subplot(2,2,3);
    imshow(I_diff);                    
    title('Differentiated');   
subplot(2,2,4);
    imshow(I_vertical);
    title('Vertical Edge');



    
                                