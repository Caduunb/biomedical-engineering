% Example 11.4  Use information to determine the mutual information of
% Gaussian and IID noise as well as a sine wave and the same sine wave
% embedded in 10 dB noise.  Use the minimum and maximum values of the
% Gaussian signal as the boundaries for the histogram and 50 bins per
% direction in x and y.  Use an unbiased estimate and a log base of 2 to
% give final answer in bits
clear all
x = randn(1,100);  %  Create vectors of Gaussian and IID noise
y = rand(1,100); 

hist_xy = hist2(x,y); % Use histogram2
H_xy = mutual(hist_xy) % Use mutual to get mutual information
clear x y
[x,~, y] = sig_noise(50, 10,1000);
hist_xy = hist2(x,y,10); % Use histogram2
H_xy = mutual(hist_xy) % Use mutual to get mutual information