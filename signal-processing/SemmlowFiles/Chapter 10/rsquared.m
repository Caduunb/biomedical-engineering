function rsquare=rsquared(log_disty,f)
% Usage:  rsquare=rsquared(log_disty,f);
% Function to compute R^2 value of a fit f for time series log_dist

a = sum((log_disty-f).^2);
b = sum((log_disty-mean(log_disty)).^2);
rsquare = 1-a/b;