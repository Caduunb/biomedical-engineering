% PRogram to generate several broadband signals and signals with noise
% to be used in the problem sets of Chapter 5. 
%  Program to generate data for Example 5.2
%
clear all; close all;
N = 1024;           % Size of arrays
fs = 1000;          % Sample fruequency
L2 = 8;             % Filter order
L1 = 4;             % Single broadband filter order
p = 15;             % AR model order 
SNR = -12;          % SNR
%
% Generate a triple bandpass filter
noise = randn(N,1);	        % Generate noise
f = [0 50 50 100 100 200 200 250 250 350 350 400 400 fs/2]/(fs/2);  % Construct desired 
G = [0  0  1  1   0   0   1   1   0  0    1   1   0    0 ];      %  frequency characteristic
[b a] = yulewalk(L2,f,G);
out = 5 * filter(b,a,noise);    % Generate broadband signal with noise
x =  out';                      % Construct data set 
k = ['2,2,1'];                  % Subplot windows
fft_ar_comp(x,p,k);             % Plot, use default fs
%save spectral_analysis1.mat x;
% 
% Single broadband signal BW = 300 Hz, Fcenter = 250 Hz.
wn = [100 400]/(fs/2);
noise = randn(N,1);	        % Generate noise
[b a] = butter(L1,wn);
out = 5 * filter(b,a,noise);    % Generate broadband signal with noise
x =  out';                      % Construct data set 
k = ['2,2,3'];                  % Subplot windows
fft_ar_comp(x,p,k);             % Plot, use default fs
save spectral_analysis6.mat x;
%
figure;
% Single broadband with narrrowband signal outside the broadband signal
SNR = -10;                   % Narrowband SNR
noise = randn(N,1);	        % Generate noise
f = [0 50 50 300 300 fs/2]/(fs/2);  % Construct desired 
G = [0  0  1    1   0   0  ];    %  frequency characteristic
[b a] = yulewalk(L2,f,G);
out = 5 * filter(b,a,noise);    % Generate broadband signal with noise
x = sig_noise([400],SNR,N);     % Generate sinusoidal data 
x =  x + out';              %    Consturct data set with added noise
k = ['2,2,1'];                  % Subplot windows
fft_ar_comp(x,6,k);             % Plot, use default fs
%save spectral_analysis3.mat x;
%
% Single broadband with narrrowband signal in the broadband signal
SNR = -2;                   % Narrowband SNR
noise = randn(N,1);	        % Generate noise
f = [0 50 50 300 300 fs/2]/(fs/2);  % Construct desired 
G = [0  0  1    1   0   0  ];    %  frequency characteristic
[b a] = yulewalk(L2,f,G);
out = 5 * filter(b,a,noise);    % Generate broadband signal with noise
x = sig_noise(200,SNR,N);     % Generate sinusoidal data 
x =  x + out';              %    Consturct data set with added noise
k = ['2,2,3'];                  % Subplot windows
fft_ar_comp(x,p,k);             % Plot, use default fs
%save spectral_analysis4.mat x;
%
figure
% Single broadband with 3 narrrowband signals in and outside the broadband signal
N = 128;
p = 25;                     % Model order
SNR = -3;                   % Narrowband SNR
noise = randn(N,1);	        % Generate noise
f = [0 150 150 300 300 fs/2]/(fs/2);  % Construct desired 
G = [0  0  1    1   0   0  ];    %  frequency characteristic
[b a] = yulewalk(L2,f,G);
out = 5 * filter(b,a,noise);    % Generate broadband signal with noise
x = sig_noise([100 250 400],SNR,N);     % Generate sinusoidal data 
x =  x + out';              %    Consturct data set with added noise
k = ['2,2,1'];                  % Subplot windows
fft_ar_comp(x,p,k);             % Plot, use default fs
%save spectral_analysis.mat x;
%
% Double broadband signal
N = 2048;
p = 25;                     % Model order
SNR = -3;                   % Narrowband SNR
noise = randn(N,1);	        % Generate noise
f = [0  100 100 200 200 300 300 400 400 fs/2]/(fs/2);  % Construct desired 
G = [0   0   1  1   0   0   1    1   0    0 ];      %  frequency characteristic
[b a] = yulewalk(L2,f,G);
out = 5 * filter(b,a,noise);    % Generate broadband signal with noise
x =  out';              %    Consturct data set with added noise
k = ['2,2,3'];                  % Subplot windows
fft_ar_comp(x,p,k);             % Plot, use default fs
%save spectral_analysis5.mat x;
