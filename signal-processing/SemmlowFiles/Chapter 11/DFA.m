function F = DFA(x,win_length,order)
% Fm = DFA(DATA,win_length,order)
% Function DFA performs detrended fluctuation analysis on signal DATA
% Inputs
%   x             signal to be analyzed
%   win_length    signal segments of this length
%   order:        order of the fit used to remove the trends, 1 is a linear fit
% Outputs
%  F              summed RMS of detended segments
x = x(:);
x = x';
N = length(x);         % Get length of data
n = floor(N/win_length);  % n = number of segments
N1 = n*win_length;        % Length truncated data
y = zeros(N1,1);         
Yn = zeros(N1,1);

fitcoef = zeros(n,order+1);   % Initialize variable to hold fit coef 
mean1 = mean(x(1:N1));   % Mean of truncated data
y = cumsum(x(1:N1)-mean1); % cumulative sum of data

for j=1:n  % Gives a row of a fit for each segment
    fitcoef(j,:)=polyfit(1:win_length,y(((j-1)*win_length+1):j*win_length),order);
end

for j=1:n % Gives a row of fitted values for segment(using the summed
          % values)
    Yn(((j-1)*win_length+1):j*win_length)=polyval(fitcoef(j,:),1:win_length);
end


F = sum((y'-Yn).^2)/N1; % Remove the trends and get RMS (Eq. 11.17)
F = sqrt(F);      % Remove the trends and get RMS (Eq. 11.17)     


