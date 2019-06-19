% Example 2.7 and Fig. 2.14  Find the Pearson correlation coefficient 
%  between the two waveforms shown in Figure 2.14.  
% Solution:  Find the un-normalized correlation as in Example 2.4 and apply Eq. 2.45.
%
clear all; close all;
% First generate signal.
N = 500;                % Number of points
fs = 500;               % Sample frequency
t = (1:N)/fs;           % Time vector
x = 2* sin(2*pi*t) + 1* sin(2*pi*2*t) + .5*sin(2*pi*4*t);
y = 4*[t(1:250) -t(251:end)];
plot(t,x,'k',t,y,'k');
xlabel('Time (sec)','FontSize',14); ylabel('x(t) & y(t)','FontSize',14);
save ('Ex2_7.mat', 'x', 'y');
%
clear all;
load Ex2_7
N = length(x);
rxy = sum((x-mean(x)).*(y-mean(y)));
rxy = rxy/((N-1)*sqrt(var(x)*var(y)));
title(['Correlation: ',num2str(rxy)],'FontSize',14);

