% Example 7.6 Example of Balance Tree Decomposition applied to 2 EEG signals
%  The file ecg1.mat contains two 60 sec segments of ECG data in variables ecg1
%  and ecg2 (fs = 250 Hz)  Decompose each segment using a 3 level balanced
%  tree composition.  Take as features the RMS value of each decomposed
%  subband. Find two features (RMS values) that best differentiate between
%  the two signals an plot the features from each segment on a 2D plot. Use
%  a Daubeches 6-element filter
%
clear all; close all;
load ecg1_data.mat;
levels = 3;                      % Number of levels for decomposition
nu_seg = 2^levels;               % Number of decomposed segments
N = length(ecg1);                % Data length
t = (1:N/nu_seg)/fs;             % Time vector for plotting
h0 = daub(10);                   % Get filter coefficients: Daubechies 10
%
a = w_packet(ecg1,h0,levels);      % Decompose signal, Balanced Tree, 3 levels 
for i = 1:nu_seg
    i_s = 1 + (N/nu_seg) * (i-1);    % Location for this segment
    a_p = a(i_s:i_s+(N/nu_seg)-1);   % Get subband
    feature1(i) = sqrt(mean(a_p.^2));    % RMS value
    subplot(nu_seg/2,2,i);             % Plot decompositions
        plot(t,a_p,'k');  
        xlabel('Time (sec)','FontSize',12);
        xlim([0 t(end)]);
end  
figure;
a = w_packet(ecg2,h0,levels);      % Decompose signal, Balanced Tree, 3 levels 
for i = 1:nu_seg
    i_s = 1 + (N/nu_seg) * (i-1);    % Location for this segment
    a_p = a(i_s:i_s+(N/nu_seg)-1);  % Get subband
    feature2(i) = sqrt(mean(a_p.^2));    % RMS value
    subplot(nu_seg/2,2,i);             % Plot decompositions
        plot(t,a_p,'k');  
        xlabel('Time (sec)','FontSize',12);
        xlim([0 t(end)]);
end 
feature_diff = 100 * abs(feature1 - feature2)./feature2;
disp([feature1' feature2' feature_diff' ])

