% Example 4.9  To evaluate the two point central difference algorithm 
%   using different  skip factors
%
close all; clear all,
load eye;                       % Get data
fs = 200;                       % Sampling frequency
Ts = 1/fs;                      % Calculate Ts
t = (1:length(eye_move))/fs;    % Time vector for plotting
L = [1 2 5 10];                 % Filter skip factors
for m = 1:4
    b = [1 zeros(1,2*L(m)-1) -1]/(2*L(m)*Ts);  % Generate filter
    der = conv(eye_move,b,'same');  % Filter using convolution
    subplot(2,2,m);
    plot(t,der,'k');                % Plot filtered data
    text(1,22,['L = ',num2str(L(m))],'FontSize',12);
    text(1,18,['Peak = ',num2str(max(der),2)],'FontSize',12);
    axis([0 2 -5 25]);
    xlabel('Time (sec)','FontSize',12);
    ylabel('Velocity (deg/sec)','FontSize',12);
end