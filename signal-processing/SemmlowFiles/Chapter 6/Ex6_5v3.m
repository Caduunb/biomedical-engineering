% Example 6.5  Example of the use of the Cohen class Distribution
%    on sequential sinusoids or chirp
%
clear all; close all;
% Set up constants
fs = 500;			% Sample frequency
N = 256;			% Signal length 
f1 = 40;			 % First frequency in Hz
f2 = 100;			 % Second frequency in Hz
alpha = 0.3;         % Choi-Williams filter constant
L = 30;              % Determining function size
%
tn = (1:N/4)/fs;
x = [zeros(N/4,1); sin(2*pi*f1*tn)'; sin(2*pi*f2*tn)'; zeros(N/4,1)];
% Get desired distribution
x = hilbert(x);  					% Get Analytic function
t = (1:N)/fs;		% Calculate time and frequency vectors
f = (1:N) *(fs/(2*N));
%Compute instantainous autocorrelaton:  Eq. 9-2
Rxx = int_autocorr(x,fs);
G = choi_williams(alpha,L);					% Born-Jorden-Cohen
CD1 = conv2(Rxx,G,'same');		 		% 2-D convolution
CD = abs(fft(CD1)); 
figure;								% Plot in 3-D
mesh(t,f,CD);
     xlabel('Time (sec)','FontSize',14);
     ylabel('Frequency (Hz)','FontSize',14);
     zlabel('CD(f,t)','FontSize',14);
     view([50,39]);
      colormap(flipud(gray));     % Make lower values lighter
      xlim([0 0.5]); ylim([0 120])
   figure
     contour(t,f,CD);
     xlabel('Time (sec)','FontSize',14);
     ylabel('Frequency (Hz)','FontSize',14);
    xlim([0 0.5]); ylim([0 120])

   
   
