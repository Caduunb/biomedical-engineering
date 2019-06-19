%  Example 5.3 and Figure 5.6 Program to evaluate different modern spectral methods 
%   with regard to detecting a narrowband signal in various amounts of
%   noise
%
clear all; close all;
N = 1024;						% Signal length
fs = 1000;					% Sample frequency from sig_noise
p = 15;						% Model order
SNR = [0 -4 -9 -15];		% Define SNR levels in dB 
for k = 1:4
   	x = sig_noise([240 280],SNR(k),N);	
  	[PS,f] = pyulear(x,p,N,fs);
    subplot(2,2,k);           % Select subplot
    plot(f,PS,'k');		      % Plot Power Spectrum and label 
	text(200,max(PS),['SNR: ',num2str(SNR(k)), 'dB'],'FontSize',12);
	xlabel('Frequency (Hz)','FontSize',12);  ylabel('PS ','FontSize',12);
end