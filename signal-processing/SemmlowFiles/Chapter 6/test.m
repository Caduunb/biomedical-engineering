% Example 6.5  Example of the use of the Cohen class Distribution
%    on sequential sinusoids or chirp
%
clear all; %close all;
% Set up constants
L = 30;
fs = 500;             % Sample frequency assumed by tf_signal 
%
% Construct a step change in frequency
signal_type = input('Sig type:(ss=seq sine; ch=chirp, sc=chirp+sine; s2=2 sin; ms modul)','s');
x = tf_signal(signal_type);
N = length(x);
n_gain = input('Add noise: amount in %SD, blank to skip');
if ~isempty(n_gain);
    noise = randn(N,1);
    x = x + noise*n_gain*std(x)/std(noise);
    plot(x); figure;
end
% Get desired distribution
h_flag = input('hilbert transform: blank for yes','s');
if isempty(h_flag)
    x = hilbert(x);         % Analytic function
end
type = input('Enter type (c choi-williams; b = BJc; j = BCD; w = WV):','s');
[CD,f,t] = cohen(x,fs,type,L);    % Cohen's class of Transformations
%
 contour(t,f,CD);
     xlabel('Time (sec)','FontSize',14);
     ylabel('Frequency (Hz)','FontSize',14);
     
figure;
  mesh(t,f,CD);                       % Mesh 3-D plot
     xlabel('Time (sec)','FontSize',14);
     ylabel('Frequency (Hz)','FontSize',14);
     zlabel('CD(f,t)','FontSize',14);
     %view([50,39]);
     view([77,30]);     % Modified for chirp
     %colormap(flipud(gray));     % Make lower values lighter
     colormap(hsv);
     xlim([0 1.2]); ylim([0 120]);  


   
   
