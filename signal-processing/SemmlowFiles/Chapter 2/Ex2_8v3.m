% Example 2.8 Use the MATLAB covariance and correlation coefficient matrices to find the 
%  correlation between an sinewave and a cosinewave. 
clear all; close all;
N = 1000;                		% Number of points
Tt = 2;                 		% desired total time
fs = N/Tt;              		% Calculate sampling frequency
t = (0:N-1)/fs;            		% Time vector from 0 (approx.) to 2 sec
X(:,1) = cos(2*pi*t)';          	% Generate a 1 Hz cosine
X(:,2) = sin(2*pi*t)';          	% Generate a 1 Hz sine
X(:,3) = cos(4*pi*t)';          	% Generate a 2 Hz cosine
X(:,4) = sin(4*pi*t)';          	% Generate a 1 Hz sine
%
S = cov(X)                  	     	% Print covariance matrix
Rxx = corrcoef(X)               	%       and correlation matrix
