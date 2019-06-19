% Example 6.3 Compute and plot the instantaneous autocorrelation fucntion
% of a 2 Hz sine wave.  Make N = 2000 pts and fs = 2 kHz.   
%
clear all; close all;

N = 500;                        % Number of points
fs = 500;                       % Sampling frequency
t = (1:N)/fs;                   % Time vector
f1 = 2;                         % Signal frequency
x = sin(2*pi*f1*t)';            % Construct signal as row vector
% Inst autocorr: tau (lags) is in columns and time is in rows
N_2 = N/2;                      % Half data length
%
Rxx = zeros(N,N);               % Inst. auto. output array
% Compute instantaneous autocorrelation:  Eq. 6.5
for n = 1:N                     % Increment over time 
   k_max = min([n-1,N-n]);      % Limit lags to available data
   k = -k_max:k_max;            % Shift tau in both directions
   Rxx(N_2+k,n) = x(n+k) .* conj(x(n-k));    % Eq. 6.5
end
lags = (-N_2:N_2-1)/fs;         % Lags (in columns) for plotting
subplot(1,2,1);
mesh(t,lags,Rxx); colormap(copper);    % 3-D plot
xlabel('Time(sec)','FontSize',14); ylabel('Lags (sec)','FontSize',14); 
zlabel('Rxx','FontSize',14); title('A','FontSize',16);
%
subplot(1,2,2);
contour(t,lags,Rxx); colormap(copper);    % Contour plot
xlabel('Time(sec)','FontSize',14); ylabel('Lags (sec)','FontSize',14); title('B','FontSize',16);