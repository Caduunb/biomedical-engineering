% Example 2.9 File neural data.mat contains two waveforms, x and y, that were recorded from two 
%  different neurons in the brain with a sampling interval of 0.2 msec.  They are believed to be
%  involved in the same function, but separated by one or more neuronal junctions that would impart 
%  a delay to the signal.  Plot the original data, determine if they are related, and if so the time
%  delay between them.  
%
clear all; close all;
fs = 1/0.0002;                          % Sampling freq. (1/Ts)
% Construct the data set
%t = (1:200);
% z = exp(-.1*t).*sin(.2*t);
% y1 = zeros(5000,1);
% x1 = zeros(5000,1);
% int =round( [50 180 300 475 600 900 1150 1400 1650 1821] * 2.5);
% int1 = round([60 176 310 470 610 915 1140 1398 1655 1815] *2.5+ 150);
% for k = 1:length(int)
%     y1(int(k):int(k)+199) = z';
%     x1(int1(k):int1(k)+199) = z';
% end 
% y = y1 + .025*randn(length(y1),1);
% x = x1 + 0.05*rand(length(x1),1);
% save p2 x y;
%
load neural_data.mat;                       % Load data
t = (1:length(x))/fs;                       % Calc. time vector
subplot(2,1,1);
    plot(t,y,'k',t,x,':k');                 % Plot data
    xlabel('Time(sec)','FontSize',14); ylabel('x(t) and y(t)','FontSize',14);
[rxy,lags] = axcor(x,y);                    % Compute crosscorrelation
subplot (2,1,2);
plot(lags/fs,rxy,'k');              % and plot crosscorrelation 
[max_corr, max_shift] = max(rxy);
max_shift = lags(max_shift)/fs;          % Convert max shift to sec
disp([max_corr max_shift])         % Output delay in sec
plot(max_shift,max_corr,'*k');     % Plot max correlation
hold on; 
xlabel('Lags (sec)','FontSize',14); ylabel('rxy','FontSize',14);
title(['Max corr: ',num2str(max_corr,2),'  Delay: ',num2str(max_shift),' sec'],'FontSize',12);
axis([-.15 .15 0 .6]);

