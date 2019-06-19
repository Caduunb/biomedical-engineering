function [hist,bins] = histogram(x,nu_bins)
% function [hist,bins] = histogram(x,nu_bins)
% Function to calculate histogram of data in x.
% Scales data in x so mnimum value is 0 and maximum value equals the 
%  maximum bin. u_bins
% Then the rounded value of the scaled data is the index of the histogram
% bin to be incremented.  
% Also generates a vector, bins, which is the number of desired bins (+1)
% long and is scaled to the range of the original data.  This vector can be
% useful for plotting an accurately scales horizontal axis. 
%  
% Inputs
%     x         Data for histogram
%     nu_bins   Number of bins desired
% Outputs
%     h         Histogram (length = nu_bins)
%     bins      Bin values. Useful in ploting
%
range = max(x) - min(x);
data = (x-min(x)) * nu_bins/range;   % Scale data as discribed above
bins = (1:nu_bins+1)*range/nu_bins  + min(x);  % Construct bins vector 
hist = zeros(nu_bins+1,1);           % Zero histogram
for k = 1: length(x);                % Construct histogram
    k1 = round(data(k)) + 1;         % Find appropriate bin to increment
    hist(k1) = hist(k1) +1;          %   and increment.
end


