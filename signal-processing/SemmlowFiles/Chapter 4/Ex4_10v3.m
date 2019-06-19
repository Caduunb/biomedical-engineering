% Ex 4.10 Design a double bandpass filter has a passband range of 50 to
%   100 Hz and a second passband between 200 and 250 Hz.  Use a filter 
%   order of 65.  Apply this to signal containing sinusoids at 75 and 225 Hz
%   in -20 dB of noise.  (Use sig_noise to generate the signal).   
%   Plot the desired and actual filter magnitude spectrum and the magnitude
%   spectrum of the signal before and after filtering.   
%
close all; clear all;

fs = 1000;					    % Sample frequency
N = 2000;                       % Number of points
L = 65;                         % Filter order
fl1 = 50/(fs/2);                % First peak low cutoff freq.
fh1 = 100/(fs/2);			    % First peak high cutoff freq. 
fl2 = 200/(fs/2);               % Second peak low freq. cutoff
fh2 = 250/(fs/2);               % Second peak high freq. cutoff
%
x = sig_noise([75 225],-20,N);  % Generate noise waveform 
% Design filter
f = [0 fl1 fl1 fh1 fh1 fl2 fl2 fh2 fh2 1];  % Construct desired 
G = [0  0   1   1   0   0   1   1   0  0];  %   frequency characteristic
subplot(2,1,1);  hold on;       % Set up to plot spectra
plot(f,G,'k');                  % Plot the desired frequency response
b = fir2(L,f,G);                % Construct filter
[H,f] = freqz(b,1,512,fs);	    % Calculate filter1 frequency response
xlabel('Frequency (Hz)','FontSize',14);
ylabel('Magnitude','FontSize',14);
subplot(2,1,2);
plot(f,abs(H),'k');             % Plot filter frequency reponse
y = filter(b,1,x);              % Apply filter
xlabel('Frequency (Hz)','FontSize',14);
ylabel('Magnitude','FontSize',14);
Xf = abs(fft(x));
Yf = abs(fft(y));
figure;
subplot(2,1,1);                 % Now plot time curves curves 
f = (1:N)*fs/N;                 % Frequency vector for plotting
plot(f(1:N/2),Xf(1:N/2),'k');   % Plot spectrum before filtering
xlabel('Frequency (Hz)','FontSize',14);
ylabel('Magnitude','FontSize',14);
subplot(2,1,2);
plot(f(1:N/2),Yf(1:N/2),'k');   % Plot spectrum after filtering.
xlabel('Frequency (Hz)','FontSize',14);
ylabel('Magnitude','FontSize',14);

