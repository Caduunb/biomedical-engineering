% Example 5.6 and Figure 5.10
% Compares FFT-based, AR, and Eigenanalysis Spectral methods
%
close all; clear all;
N = 1024;	               	    % Size of arrays
fs = 1000;                      % Sampling frequency
SNR = -12;                      % SNR
%
%  Generate a spectra of sinusoids and noise
x = sig_noise([50 80 240 400],SNR,N);  
%
% Estimate the Welch Spectrum for comparison, no window and no overlap
[PS,f] = pwelch(x,N,[],[],fs);
subplot(2,2,1);                         % Plot Spectrum and label
     plot(f,PS,'k');			
     xlabel('Frequency (Hz)','FontSize',12);
     ylabel('PS ','FontSize',12);  title ('Fourier Transform','FontSize',12);

% Calculate the Modified Covariance Spectrum for comparison
subplot(2,2,2);            % Plot spectrum and label
[PS,f] = pmcov(x,15,N,fs);
    plot(f,PS,'k');				
    xlabel('Frequency (Hz)','FontSize',12);
    ylabel('PS','FontSize',12);
    title('AR 15th order','FontSize',12);

% Generate the Eigenvector Spectrum using the MUSIC Method
%   now window and no overlap
subplot(2,2,3);
[PS,f] = pmcov(x,31,N,fs);
     plot(f,PS,'k');				  % Plot spectrum and label
     xlabel('Frequency (Hz)','FontSize',12);
     ylabel('PS ','FontSize',12); title('AR 31th order','FontSize',12);
%
% Get the singular values from the eigenvector routine
%    and plot.  Use high subspace dimension to get many singular values
subplot(2,2,4);
[PS,f] = pmusic(x,15,N, fs);    % Get eigenvalues (svals)
     plot(f,PS,'k');				    % Plot Singular values 
     xlabel('Frequency (Hz)','FontSize',12);
     ylabel('PS ','FontSize',12);
     title('MUSIC SS = 15','FontSize',12);
