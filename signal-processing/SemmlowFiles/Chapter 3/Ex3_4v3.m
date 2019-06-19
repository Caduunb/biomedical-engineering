% Example 3.4 Generate a 1.0 second wave symmetrical triangle wave.  Make fs = 100 Hz so 
% N = 100 points.  Calculate and plot the magnitude spectrum.
% Zero pad so the period is extended to 2 and 8 sec. and recalculate and plot the
% magnitude spectrum.  Since fs = 100 Hz the signal should be padded to 200 and 600 Points  
%
clear all, close all;
fs = 100;                           % Sample frequencies
N1 = [0 150 750];                   % Padding added to the original 50 point signal
x =[(0:25) (24:-1:0)];              % Generate basic test signal, 50 pts long
for k = 1:3
    x1 = [x zeros(1,N1(k))];         % Zero pad signal
    N = length(x1);                  % Data length
    t = (1:N)/fs;
    f = (0:N-1)*fs/N;                 % Frequency vector
    subplot(3,2,k*2-1);
    plot(t,x1,'k');                  % Plot test signal 
    xlabel('Time (sec)','FontSize',14);
    ylabel('x(t)','FontSize',14);
    if k == 1
        title('Time Domain','FontSize',14);
    end
    xlim([0 t(end)]);
    subplot(3,2,k*2);
    X1 = abs(fft(x1));                % Calculate the magnitude spectrum
    plot(f, X1,'.k');                % Plot magnitude spectrum
    xlabel('Frequency (Hz)','FontSize',14);
    ylabel('|X(f)|','FontSize',14);
    xlim([0 10]);
    % axis([0 10 0 max(X1)*1.2]);
    if k == 1 
        title('Frequency Domain','FontSize',14);
    end
end
