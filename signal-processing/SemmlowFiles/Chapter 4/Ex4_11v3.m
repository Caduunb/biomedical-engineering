% Example 4.11 Design a double bandpass filter has a passband range of 50 to
%   100 Hz and a second passband between 200 and 250 Hz.  Use a filter 
%   order of 65.  Apply this to signal containing sinusoids at 75 and 225 Hz
%   in -20 dB of noise.  (Use sig_noise to generate the signal).   
%   Plot the desired and actual filter magnitude spectrum and the magnitude
%   spectrum of the signal before and after filtering.   
%
close all; clear all;

fs = 1000;					    % Sample frequency
N = 2000;                       % Number of points
L1 = 65;                        % FIR Filter order
L2 = 12;                        % IIR Filter order
%
x = sig_noise([75 225],-20,N);   % Generate noise waveform 
% Design filter
f = [0 50 50 100 100 200 200 250 250 fs/2]/(fs/2);  % Construct desired 
G = [0  0  1  1   0   0   1   1   0  0];      %  frequency characteristic
subplot(2,1,1);      
plot(f,G,'k'); hold on;           % Plot the desired frequency response
b = fir2(L1,f,G);                % Construct filter
[H1,f1] = freqz(b,1,512,fs);	    % Calculate filter1 frequency response
[b2 a2] = yulewalk(L2,f,G);
[H2 f2] = freqz(b2,a2,512,fs);
xlabel('Frequency (Hz)','FontSize',14);
ylabel('Magnitude','FontSize',14);
subplot(2,1,2);
plot(f1,abs(H1),'k'); hold on; 
plot(f2,abs(H2),':k','LineWidth',2);
xlabel('Frequency (Hz)','FontSize',14);
ylabel('Magnitude','FontSize',14);
%
% Section to test timing
x = rand(1,10000);      		  % Generate random data
% Get IIR filter operation time
disp('IIR')
tic                     		  % Restart clock
y = filter(b2,a2,x);     		  % Filter using the FIR filter
toc                     		  % Get FIR filter operation time
clear y;
disp('FIR filter')
tic                               % Repeat for FIR filter
y = filter(b1,1,x);
toc
disp('FIR conv')
tic                               % Repeat for FIR filter
y = conv(b1,x,'same');
toc




