% Example 2.3 and Figure 2.4 Evaluation of the distribution of data produced by MATLAB's
% rand and randn functions.  
%
clear all; close all;
N = 20000;          		% Number of data points
nu_bins = 40;           	% Number of bins
y = randn(1,N);     		% Generate random Gaussian noise
[ht,xout] = hist(y,nu_bins); 	% Calculate histogram
ht = ht/max(ht);        	% Normalize histogram to 1.0
subplot(2,1,1);
bar(xout, ht);             	% Plot as bar graph
xlabel('x','FontSize',14);
ylabel('P(x)','FontSize',14);
title('Gaussian Distribution','Fontsize',14);
% Repeat for uniform distribution
y = rand(1,N);     		% Generate random Gaussian noise
[ht,xout] = hist(y,nu_bins); 	% Calculate histogram
ht = ht/max(ht);        	% Normalize histogram to 1.0
subplot(2,1,2);
bar(xout, ht);             	% Plot as bar graph
xlabel('x','FontSize',14);
ylabel('P(x)','FontSize',14);
title('Uniform distribution','Fontsize',14);