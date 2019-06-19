function [AMIF_curve,lag_tau, PD, lag_PD] = amif(x,max_lags,nu_bin)
% Takes the mutual information (MI) between the signal and a delayed version of itself
% then takes the difference between the MI with no delay and with 
% varying delays from 1 to max_lags points (default = half the signal length)
% Outputs the AMIF_curve, the lag for 63% decay of the AMIF_curve and the lag
% and value of the first peak following a minimum if it exists.


% Inputs:
%   x          Data
%   max_lags   Maximum lag (optional  default = N/2);
%
% Outputs
%   AMIF_curve        Mutual information as a function of lag
%   lag_tau    Lag when AMIF_curve equal 37% of maximum (zero lag)
%   PD         Value of AMIF_curve at first peak
%   lag_PD     Lag of first peak.  
% 

N = length(x);             % Get length of vectors
if nargin < 2
    max_lags = floor(N/2); % Default number of lags is half                       
end                                

x = x(:);     % Make a column vector  
x = x';       % Enforce row vector

%  Construct AMIF curve
 AMIF_curve = zeros(1,max_lags);      % Initialize AMIF curve
 x1 = x;                              % Initial x and delayed version of x
 del_x = x;                                      
 AMIF_curve(1) = inform2(x,del_x,nu_bin);   % Mutual info at zero delay
for k = 2:(max_lags+1)                      
    x1(end)=[];                             % Remove last value from x
    del_x(1) = [];                          % Delay x by 1
    AMIF_curve(k) = inform2(x1,del_x,nu_bin); % Get mutual information between x1 and del_x
end
AMIF_curve=AMIF_curve-min(AMIF_curve);      
AMIF_curve = AMIF_curve/(AMIF_curve(1));     % Normalize maximum value to 1.0


% Now find peaks 
lag_tau = find(AMIF_curve < 0.37,1)-1; % Find the lag at which AIF is less than 0.37 
                                       % Subtract one since matlab indices
                                       % start at 1
ii=0;                         % Initialize ii to 0;
while ii < (length(AMIF_curve)-10);
 ii=ii+1;
 if sum(AMIF_curve(ii:(ii+5))) < sum(AMIF_curve((ii+6):(ii+10))) % Find first local minimum
     break;
 end
end
[PD,i_PD] = max(AMIF_curve(ii:end));   % find first local maximum 

lag_PD = i_PD + ii-2;




