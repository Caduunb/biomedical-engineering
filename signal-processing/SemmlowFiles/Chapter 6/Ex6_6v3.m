% Example 6.5  Example of the use of the Cohen class Distribution
%    on sequential sinusoids or chirp
%
clear all; close all;
% Set up constants
fs = 500;             % Sample frequency assumed by tf_signal 
L = 30;               % Determining function size
%
% Construct a step change in frequency
signal_type = input('Signal type: (ss = sines; ch = chirp)','s');
x = tf_signal(signal_type);
%
% Get desired distribution
type = input('Enter type (c choi-williams; b = BJC):','s');
x = hilbert(x);  					% Analytic function
[CD,f,t] = cohen(x,fs,type,L);    % Cohen's class of Transformations
%
mesh(t,f,CD);                       % Mesh 3-D plot
     xlabel('Time (sec)','FontSize',14);
     ylabel('Frequency (Hz)','FontSize',14);
     zlabel('CD(f,t)','FontSize',14);
     %view([50,39]);
     view([77,30]);     % Modified for chirp
     colormap(flipud(gray));     % Make lower values lighter
     xlim([0 1.2]); ylim([0 120]);

%      contour(t,f,CD);
%      xlabel('Time (sec)','FontSize',14);
%      ylabel('Frequency (Hz)','FontSize',14);
     


   
   
