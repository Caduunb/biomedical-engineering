% Example 3.8  Find the approximate bandwidth of the signal x in file Ex3_8_data.mat
%
clear all; close all;
load Ex3_8_data.mat;			% Load the data file.  Data in x.
fs = 500;				        % Sampling frequency (given).
nfft =64;                       % Power spectrum window size
[PS,f] = pwelch(x,[],nfft-1,nfft,fs);       % Magnitude spectrum of eeg
plot(f,PS,'k');  hold on;                   % Plot spectrum
bandpass_thresh = 0.50 * max(PS);                    % Theshold for bandpass values
bandpass_value = mean(PS(PS>bandpass_thresh));       % Use logical indexing Get average of bandpass values
plot(f,PS,'k'); hold on;                    % Plot spectrum
plot([f(1) f(end)], [bandpass_value bandpass_value],':k'); % Plot bandpass estimate
xlabel('Frequency (Hz)','FontSize',14);     % and label
ylabel('PS(f)','FontSize',14);
%
cutoff_thresh = 0.5 * bandpass_value;
in_fl = find(PS > cutoff_thresh, 1, 'first');          % Find index of low freq. cutoff
in_fh = find(PS > cutoff_thresh, 1, 'last');           % Find index of high freq. cutoff
f_low = f(in_fl);                           % Find low cutoff freq.
f_high = f(in_fh);                          % Find high cutoff freq.
plot(f_low,PS(in_fl),'k*','MarkerSize',10); % Put marker at cutoff freqs. 
plot(f_high,PS(in_fh),'k*','MarkerSize',10);
BW = f_high - f_low;                        % Calculate bandwidth
title(['Bandwidth:  ',num2str(BW,3),' Hz'],'FontSize',14);
