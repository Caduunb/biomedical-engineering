% Example 7.6 Example of Balance Tree Decomposition applied to EEG signals
%  The file ecg1.mat contains two 60 sec segments of ECG data in variables ecg1
%  and ecg2 (fs = 250 Hz)  Decompose each segment using a 3 level balenaced
%  tree composition.  Take as features the RMS value of each decomposed
%  subband. Find two features (RMS values) that best differentiate between
%  the two signals an plot the features from each segment on a 2D plot. Use
%  a Daubeches 6-element filter
%
clear all; close all;
fs = 100;
load Hr_pre.mat;
load Hr_med.mat;
levels = 3;                     % Number of levels for decomposition
nu_seg = 2^levels;              % Number of decomposed segments
N1 = length(hr_pre);            % Data length hr_pre
N2 = length(hr_med);            % Data lenght hr_med
t1 = (1:N1/nu_seg)/fs;          % Time vector for plotting
t2 = (1:N2/nu_seg)/fs;          % Time vector for plotting
h0 = daub(10);                  % Get filter coefficients: Daubechies 10
%
a = w_packet(hr_pre,h0,levels);      % Decompose signal, Balanced Tree, 3 levels 
for k = 1:nu_seg
    i_s = 1 + (N1/nu_seg) * (k-1);    % Location for this segment
    a_p = a(i_s:i_s+(N1/nu_seg)-1);  % Get subband
    feature1(k) = sqrt(mean(a_p.^2));    % RMS value
    subplot(nu_seg/2,2,k);             % Plot decompositions
        plot(t1,a_p,'k');  
        xlabel('Time (sec)','FontSize',12);
        xlim([0 t1(end)]);
end  
figure;
a = w_packet(hr_med,h0,levels);      % Decompose signal, Balanced Tree, 3 levels 
for k = 1:nu_seg
    i_s = 1 + (N2/nu_seg) * (k-1);    % Location for this segment
    a_p = a(i_s:i_s+(N2/nu_seg)-1);  % Get subband
    feature2(k) = sqrt(mean(a_p.^2));    % RMS value
    subplot(nu_seg/2,2,k);             % Plot decompositions
        plot(t2,a_p,'k');  
        xlabel('Time (sec)','FontSize',12);
        xlim([0 t2(end)]);
end 
feature_diff = abs(feature1 - feature2)./feature2;
disp([feature1' feature2' feature_diff' ])

