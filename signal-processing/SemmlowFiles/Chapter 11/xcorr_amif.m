function [xcorr_curve,lag_tau,lag_PD,PD]=xcorr_amif(x,max_lags);

xcorr_curve = xcorr(x,max_lags,'coeff'); % Get the normalized auto correlation
half = floor(length(xcorr_curve)/2);
xcorr_curve = xcorr_curve(half:end);    % Remove the redundant first half

lag_tau = find(xcorr_curve < 0.37,1)-1; % Find the lag at which AIF is less than 0.37 
                                       % Subtract one since matlab indices
                                       % start at 1
ii=0;                         % Initialize ii to 0;
while ii < (length(xcorr_curve)-10);
 ii=ii+1;
 if sum(xcorr_curve(ii:(ii+1))) < sum(xcorr_curve((ii+2):(ii+3))) % Find first local minimum
     break;
 end
end
[PD,i_PD] = max(xcorr_curve(ii:end));   % find first local maximum 

lag_PD = i_PD + ii-2;                   % Subtrac 2 to account for lag and
                                        % matlab indexing
