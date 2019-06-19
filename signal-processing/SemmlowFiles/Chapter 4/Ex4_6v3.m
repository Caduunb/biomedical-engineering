% Example 4.6 Apply a rectangular window lowpass filter to the noisey
%   respiratory signal. Show the signal before and after
%   filtering with filters having 17 and 65 coefficients.  Use a Blackman
%   window to truncate the filter's impulse response.  
%
close all; clear all;
load Resp;                   % Get data 
N = length(resp);            % Get data length
fs = 12.5;                   % Sample frequency
t = (1:N)/fs;                % Time vector for plotting
L = 65;                      % Filter lengths
fc = 1/fs;                   % Cutoff frequency: 1.0 Hz
plot(t,resp+1,'k'); hold on;     % Plot original data
k  = -floor(L/2):-1;         % Construct k for negative b[k];
b = sin(2*pi*fc*k)./(pi*k);  % Construct negative b[k]
b =  [b 2*fc, fliplr(b)];    % Rest of b
b = b.*blackman(L);          % Apply Blackman window
%
y = conv(resp,b,'same');     % Apply filter (causal)
plot(t,y,'k');               % Plot filtered data
ylim([0 2.2]);
xlabel('Time (sec)','FontSize',14);
ylabel('Respiration (arbitrary  units)','FontSize',14);
