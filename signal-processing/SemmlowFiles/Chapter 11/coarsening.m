function resamp_x = coarsening(x,L)
% Function performs a coarse graining algorithm given by Valenciaet. al. (2009). 
% resamp_x = coarsening2(x,L)
% Inputs
%   L     level of coarse graining
%   x     is the original data

   cutoff = 1/(L+1);     % cutoff frequency relative to Fs/2
    [B,A]=butter(6,cutoff,'low');  % Make filter to remove data
                                 % Greater than half fs/2
    resamp_x=filtfilt(B,A,x);        % Filter the data
    resamp_x = resamp_x(1:(L+1):end);        % resample by half

       