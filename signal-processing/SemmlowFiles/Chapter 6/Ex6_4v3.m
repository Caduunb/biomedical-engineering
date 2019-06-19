% Example 6.4   Example of the use of the Wigner-Ville Distribution
%    Uses wvd.m applied to data similar to that of Ex 6.2
%		Data has been shortened to improve run time
%
clear all; close all;
% Set up constants
N = 500;				% Number of points	
fs = 500;			    % Sample freq;
f1 = 10;				% Minimum frequency
f2 = 100;			    % Maximum frequency 
t = (1:N)/fs;           % Time vector
f = (1:N)*fs/(2*N);     % Frequency vector (Note divided by 2N)
%  Generate chirp signal (i.e., linear change in freq)
fc = ((1:N)*((f2-f1)/N)) + f1; 
x = sin(pi*t.*fc);        % Note 2pi just pi since freq. doubled. 
%  
N_2 = N/2;                      % Half data length
Rxx = zeros(N,N);               % Inst. auto. output array
% Compute instantaneous autocorrelation:  Eq. 6.6
for n = 1:N                     % Increment over time 
   k_max = min([n-1,N-n]);      % Limit lags to available data
   k = -k_max:k_max;            % Shift tau in both directions
   Rxx(N_2+k,n) = x(n+k) .* conj(x(n-k));    % Eq. 6.6
end
lags = (-N_2:N_2-1)/fs;         % Lags (in columns) for plotting
%contour(t,lags,Rxx);
xlabel('Time (sec)','FontSize',14);
ylabel('Lags','FontSize',14);
subplot(1,2,1);
WD = abs(fft(Rxx));             % Calculate the W-V Dist. 
mesh(t,f,WD);                   % Plot W-V Distribution
xlabel('Time (sec)','FontSize',14);
ylabel('Frequency (Hz)','FontSize',14);
zlabel('WD(f,t)','FontSize',14);
title('A','FontSize',16);
view(75,45);
colormap(flipud(gray));     % Make lower values lighter
%caxis([0 60]);
axis([0 1 0 120 0 120]);
%
subplot(1,2,2)
contour(t,f,WD,[25 50 75 100 125 150]);	% Plot W-V as contour plot
xlabel('Time (sec)','FontSize',14);
ylabel('Frequency (Hz)','FontSize',14);
title('B','FontSize',16);
%colormap(gray);
axis([0 1 0 120]);


   
   
