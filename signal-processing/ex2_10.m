% Example 2.10 Camparison of an EEG signal with sinusoids: checking which
% frequency correlates the most
clear all; close all;
load SemmlowFiles\'Chapter 2'\eeg_data.mat; % Get eeg data
fs = 50; % Sampling frequency
t = (1:length(eeg))/fs; % Time vector
for i = 1:100
    f(i) = 0.25*i; % Frequency range: 0.25–25 Hz
    x = sin(2*pi*f(i)*t); % Generate sine
    rxy = xcorr(eeg,x, 'coeff'); % Perform crosscorrelation
    rmax(i) = max(rxy); % Store max value
end
plot(f,rmax,'k'); % Plot max values as function of freq.
xlabel ('Frequency (Hz)');
ylabel ('Maximum correlation');
%% Plotting the max correlation point
hold on;
[rmaxmax, index] = max(rmax);
plot(f(index), rmaxmax, 'og');
