% PRogram to plot several broadband signals and signals with noise
%  to be used in the problem sets of Chapter 5. 
%
clear all; close all;
 p = 15;            % AR model order 
%
load spectral_analysis1.mat x;
k = ['2,2,1'];                  % Subplot windows
fft_ar_comp(x,p,k);             % Plot, use default fs

% 
% Single boradband signal
load spectral_analysis2.mat x;
k = ['2,2,3'];                  % Subplot windows
fft_ar_comp(x,p,k);             % Plot, use default fs

%
figure;
% Single broadband with narrrowband signal outside the broadband signal
load spectral_analysis3.mat x;
k = ['2,2,1'];                  % Subplot windows
fft_ar_comp(x,p,k);             % Plot, use default fs

%
% Single broadband with narrrowband signal in the broadband signal
load spectral_analysis4.mat x;
k = ['2,2,3'];                  % Subplot windows
fft_ar_comp(x,p,k);             % Plot, use default fs

