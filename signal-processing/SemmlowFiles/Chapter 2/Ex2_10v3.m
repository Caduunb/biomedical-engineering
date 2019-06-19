% Example 2.10  
% Camparison of a sinusoids at different frequencies 
%   with the EEG signal using crosscorrelation. 
%
clear all; close all;
load eeg_data;                  % Get eeg data
fs = 50;                        % Sampling frequency       
t = (1:length(eeg))/fs;         % Time vector
% Sample freq. 
for i = 1:100
    f(i) = 0.25*i;               % Frequency range: 1 - 25 Hz
    x = cos(2*pi*f(i)*t);       % Generate sin
    rxy = axcor(eeg,x);         % Perform crosscorrelation
    rmax(i) = max(rxy);         % Store max value 
end    
plot(f,rmax,'k');               % Plot max values as function of freq. 
    xlabel('Frequency (Hz)','FontSize',14); ylabel('Maximum Correlation','FontSize',14);
% Confirm using fft
figure;
N = length(eeg);
X = abs(fft(eeg));
f= (1:N)*fs/N;
N2 = round(N/2);
plot(f(1:N2),X(1:N2));
 xlabel('Frequency (Hz)','FontSize',14);
