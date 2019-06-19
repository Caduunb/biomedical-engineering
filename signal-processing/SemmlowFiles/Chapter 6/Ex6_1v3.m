% Example 6.1  Example of the use of the spectogram
%    Uses spectog
%
clear all; close all;
% Set up constants
fs = 500;               % Sample frequency
n = 256;				% Signal length divided by four
f1 = 10;                % First frequency in Hz
f2 = 40;				% Second frequency in Hz
nfft = 64;              % Window size
noverlap = 32;          % Number of overlaping points
% Construct a step change in frequency
tn = (1:n)/fs;          % Time vector used to create sinusoids
t = (1:4*n)/fs;         % Time vector used for plotting
x = [zeros(n,1); sin(2*pi*f1*tn)'; sin(2*pi*f2*tn)'; zeros(n,1)];
plot(t,x,'k');
xlabel('Time (sec)','FontSize',14);
ylabel('x(t)','FontSize',14);
% Can use either spectrogram from the MATLAB Signal Processing Toolbox
%    or similiar function shown below.  
%[B,f,t] = spectrogram(x,nfft,fs,nfft,noverlap);   % Alternate
[B,f,t] = spectog(x,nfft,fs,noverlap);
B = abs(B);
figure;
clf;
mesh(t,f,B);            % Plot spectogram
view(155,60);
axis([0 2 0 100 0 20]);
xlabel('Time (sec)','FontSize',14);
ylabel('Frequency (Hz)','FontSize',14);
zlabel('B(f,t)','FontSize',14);
colormap('gray');
caxis([0 50]);
%brighten(-1);		% Make image darker
figure
contour(t,f,B);
xlabel('Time (sec)','FontSize',14);
ylabel('Frequency (Hz)','FontSize',14);
axis([0 2 0 100]);
colormap('bone');
brighten(-1);


   
   
