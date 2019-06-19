% Example 3.6
% Frequency analysis of heart rate data in the 
%   normal and mediative state
%  After loading the data, the program converts the data 
%  to evenly spaced time data using interpolation
%
clear all; close all;
%
fs = 100.0;             % Sample frequency
ts = 1/fs;              % Sample interval
load Hr_pre;            % Load normal and meditagtive data

%
% Convert to evenly spaced time data using interpolation
% First generate an evenly space time vectors having 
%   one second intervals and extending over the time range of the data
xi = (ceil(t_pre(1)):ts:floor(t_pre(end)));
yi = interp1(t_pre,hr_pre,xi');        % Interpolate
yi = diff(yi);                          % Take difference
N2 = round(length(yi)/2) ;             % Get half data length
f = (1:N2)*fs/N2;                      % Frequency vector for ploting
YI = abs((fft(yi)).^2);                % Calculate power spectrum
subplot(1,2,1);
plot(f,YI(2:N2+1),'k');                % Plot frequency spectrum (No DC term)
    xlabel('Frequency (Hz)','FontSize',14); ylabel('Power Spectrum','FontSize',14);
    axis([0 .15 0 30000 ]);
%
% Repeat for meditative data
load Hr_med;                           % Load normal and meditative data
%
% Convert to evenly spaced time data using interpolation
% First generate and evenly space time vectors having 
%   one second intervals and extending over the time range of the data
xi = (ceil(t_med(1)):ts:floor(t_med(end)));
yi = interp1(t_med,hr_med,xi');          % Interpolate
yi = diff(yi);                            % Take difference in HR
f = (0:length(yi)-1)*fs/(length(yi)-1);  % Frequency vector for ploting
YI = abs((fft(yi)).^2);
subplot(1,2,2);
plot(f,YI,'k');                          % Plot frequency spectrum
    xlabel('Frequency (Hz)','FontSize',14); ylabel('Power Spectrum','FontSize',14);
    xlim([0 .15]);
%