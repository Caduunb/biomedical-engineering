% Example 2.11 Use of autocovariance to determine the correlation 
%  of heart rate variation between heart beats
%
clear all; close all;
load Hr_pre;
load HR_med;
[cov_pre,lags_pre] = axcor(hr_pre-mean(hr_pre));        % Determine autocovariance
% Plot and label data.  Limit lags to +- 30 seconds
plot(lags_pre,cov_pre,'k'); hold on;
plot([lags_pre(1) lags_pre(end)], [0 0],'k');   % Plot a zero line
    xlabel('Lags (beats)','FontSize',14); ylabel('Auto-covariance','FontSize',14);
    axis([-30 30 -.2 1.2]);
    grid on;

