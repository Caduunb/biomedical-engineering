% Example 4.7 Apply a bandpass filter to the EEG data in file ECG.mat. 
%   Use a lower cutoff frequency of 8 Hz and an upper cutoff frequency of 
%   20 Hz.  Use a Blackman window to truncate the filter’s impulse to 129
%   coefficients.  Plot the data before and after bandpass filtering.  
%   Also plot the spectrum of the original signal and superimpose the 
%   spectrum of the bandpass filter. 
%
close all; clear all;
%
load EEG;                           % Get data
fs = 50;                             % Sample frequency
N = length(eeg);
fh = 12/fs;                         % Set bandpass cutoff frequencies
fl = 6/fs;
L = 129;							% Set number of weights as 128   
k  = -floor(L/2):-1;              % Construct k for negative b[k];
b = sin(2*pi*fh*k)./(pi*k) - sin(2*pi*fl*k)./(pi*k);  % Construct negative b[k]
b =  [b 2*(fh-fl), fliplr(b)];      % Rest of b
b = b .* blackman(L)';              % Apply Blackman window to filter coefficients;
%
y = conv(eeg,b,'same');				 % Filter the data using convolution
subplot(2,1,1);
N_plt = 1000;                        % Plot only 1000 points for clarity
t = (1:N_plt)/fs;				     % Time vector for plotting	
plot(t,eeg(1:N_plt),'k')             % Plot only 1/2 of the data set for clarity
xlabel('Time (sec)','FontSize',14);
ylabel('EEG','FontSize',14);
subplot(2,1,2);					     % Plot the bandpass filtered data
plot (t, y(1:N_plt),'k');
xlabel('Time','FontSize',14);
ylabel('Filtered EEG','FontSize',14);
%
figure;
H_eeg = abs(fft(eeg));            % Plot data spectrum for comparison
N2 = round(N/2);
freq = (1:N)*fs/N;                  % Frequency vector for plotting
plot(freq(1:N2),H_eeg(1:N2),'k');   % Plot data FFT only to fs/2
hold on;
B= abs(fft(b,N));				 	% Find the filter frequency response  
B = B * (max(H_eeg)/max(B));		% Scale filter H(z) to facilitate comparison
plot(freq(1:N2),B(1:N2),'--k','LineWidth',2);		    % Plot the filter frequency response
xlabel('Freqency (Hz)','FontSize',14);
ylabel('Magnitude','FontSize',14);
xlim([0 25]);