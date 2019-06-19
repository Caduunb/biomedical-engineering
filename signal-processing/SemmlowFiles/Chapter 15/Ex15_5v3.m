% Example 15.5 Example of using PCA and ICA to identify signal and artifact
%     components in a region of interest containing some active neurons. 
%   Load the region of interest then reformat to a matrix where each of the
%   24 frames is a column.  Apply PCA and ICA analysis.  Plot the first four 
%   principal componenent and the first two independent components.    
%
close all; clear all;
nu_comp = 2;                                % Number of independent components
load roi1;                                      % Get ROI data
[r c dum frames] = size(ROI);           % Find size and number of frames
%
% Convert each image frame to a vector and construct ensemble were
%   each row is a different frame.

data = [];                  % Data matrix
for i = 1:frames 
    col = [];               % Vector to store active pixels               
    for j = 1:r          
        col = [col ROI(j,:,:,i)];  % String roi into vector 
    end
    data = [data col'];     % Combine each frame as column in a matrix
end
%
%  Now apply PCA analysis 
[U,S,pc]= svd(data,0);     % Use singular value decomposition
eigen = diag(S).^2;
for i = 1:length(eigen)   
   pc(:,i) = pc(:,i) * sqrt(eigen(i));
end
%
% Determine the Independent Components
w = jadeR(data, nu_comp);      
ica = (w * data);
%
% Display components;
    subplot(2,1,1)
        plot(ica(1,:),'k'); title('Independent Components');
    subplot(2,1,2);
        plot(ica(2,:),'k'); xlabel('Frame Number');
    figure
    subplot(4,1,1);
        plot(pc(:,1),'k'); title('Principal Components');
    subplot(4,1,2); 
        plot(pc(:,2),'k'); 
    subplot(4,1,3);
        plot(pc(:,3),'k');
    subplot(4,1,4);
        plot(pc(:,4),'k'); xlabel('Frame Number');