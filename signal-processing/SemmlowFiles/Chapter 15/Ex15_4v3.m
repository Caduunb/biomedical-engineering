% Example 15.4 Example of identification of active area using correlation.
%  Load the 24 frames of image 'fmri1.tif.' Construct a stimulus profile.
%  In this fMRI expeirment the frst 6 frames were taken during no-task
%       conditions, the next six frames during the task condition,the the cycle
%       was repeated.
%  Correlate each pixel's variation over the 24 frames with the task
%       profile.  Pixels that correlate above a certain threshold (use .7)
%       should be identified in the image by a pixel whose intensity is the 
%       correlation valuees
%  
clear all; close all
thresh = .7;        % Correlation threshold
load fmri1;         % Get data
i_stim2 = ones(24,1);   % Construct task profile
i_stim2(1:6) = 0;      % First 6 frames are no-task
i_stim2(13:18) = 0;    % Frames 13 through 18 are no-task
%
% Do correlation: pixel by pixel over the 24 frames
I_fmri_marked = I_fmri;
active = [];             % Active pixel locations
for iv = 1:128           % Search vertically 
    for ih = 1:128       % Search horizontally
        for k = 1:24
            temp(k) = I_fmri(iv,ih,1,k);  % Get data across all frames
        end 
        cor_temp = corrcoef([temp' i_stim2]);   % Correlation
        corr(iv,ih) = cor_temp(2,1);  % Get correlation value
        if abs(corr(iv,ih)) > thresh       % Apply threshold
            I_fmri_marked(iv,ih) =  1;  %corr(iv,ih)+ I_fmri(iv,ih,:,1);
            active = [active; iv,ih];  % Save supra-threshold locations
        end    
    end
end 
%
%  Dispaly marked image
imshow(I_fmri_marked(:,:,:,1)); title('fMRI Image');
figure;
for i = 1:24    % Plot one of the active areas 
    active_neuron(i) = I_fmri(active(2,1),active(2,2),:,i);
end   
cor_temp = corrcoef([active_neuron' i_stim2]);   % Correlation
corr_neuron = cor_temp(2,1);  % Get correlation value
plot(active_neuron,'k'); hold on,
plot((i_stim2/20)+.55,'k');
xlabel ('Frame Number','FontSize',14);
ylabel ('Activity','FontSize',14);
title(['Correlation: ', num2str(corr_neuron,2)],'FontSize',14);
ylim([.5 .85]);

