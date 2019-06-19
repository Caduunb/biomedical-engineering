% Example 8.2 and Figure 8.4 System idetification using Weiner Filter Theory
%  Uses optimal filter implemented using Weiner-Hoft equations
%		to identify unknown system
%	
% Initialize parameters
close all; clear all;
fs = 500;	                         % Sampling frequency
N = 1024;	                        % Number of points
L = 8;                                 % Optimnal filter order
f = (1:N) * fs/N;                   % Construct freq. vector for plotting
% Generate unknown system and noise input
b_unknown = [.5 .75 1.2];      % Define unknown process
xn = randn(1,N);
xd = conv(b_unknown,xn);      % Generate unknown system output
xd = xd(3:N+2);                     % Compensate for convolution delay
%
% Apply Weiner filter
b  = wiener_hopf(xn,xd,L);          % Compute matching filter coefficients
%
% Calculate frequency charactoristics
ps_match = (abs(fft(b,N))).^2;
ps_unknown = (abs(fft(b_unknown,N))).^2;
ps_out = (abs(fft(xd))).^2;
% 
% Plot frequency characteristic of unknown and idetified processes

subplot(1,2,1);
    plot(f(1:N/2),ps_unknown(1:N/2),'k');		% Plot filtered data
    xlabel('Frequency (Hz)','FontSize',14);   ylabel('|H(z)|','FontSize',14);
    title('Unknown Process','FontSize',14);
subplot(1,2,2);
    plot(f(1:N/2),ps_match(1:N/2),'k');			% Plot filtered data
    xlabel('Frequency (Hz)','FontSize',14); ylabel('|H(z)|','FontSize',12);
    title('Matching Process','FontSize',14);
    % Print out first 4 coefficients
    text(50,max(ps_match),['Coefficients: ',num2str(b(1),3)],'FontSize',12); 
    text(50,5.5,num2str(b(2),3),'FontSize',12);
    text(50,5,num2str(b(3),3),'FontSize',12);