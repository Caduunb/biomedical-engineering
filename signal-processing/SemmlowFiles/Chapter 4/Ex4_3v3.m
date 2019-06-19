% Example 4.3 Spectra of moving average filters.
%
clear all; close all;
fs = 250;               % Sampling frequency              
%  Construct moving average filters
b3 = [1 1 1]/3;
b10 = [1 1 1 1 1 1 1 1 1 1]/10;      % Construct filter impulse response
%
B3 = fft(b3,256);         % Find filter system spectrum
B3_mag = abs(B3);         % Compute magnitude spectrum
Phase3 = unwrap(angle(B3));       % Compute phase angle, unwrap
Phase3 = Phase3*360/(2*pi);       % Phase angle in degrees
%
B10 = fft(b10,256);         % Find filter system spectrum
B10_mag = abs(B10);         % Compute magnitude spectrum
Phase10 = unwrap(angle(B10));       % Compute phase angle, unwrap
Phase10 = Phase10*360/(2*pi);       % Phase angle in degrees
% Plot filter spectrum magnitude and phase
N1 = round(length(B3_mag)/2);        % Number of frequency points to plot
f = (1:N1)*fs/(2*N1);         % Frequency vector for plotting spectrum
subplot(2,1,1); hold on;
    plot(f,B10_mag(1:N1),'k')        % Plot magnitude 
    plot(f,B3_mag(1:N1),':k','LineWidth',1)        % Plot magnitude 
    xlabel('Frequency (Hz)','FontSize',14); ylabel('|B|','FontSize',14);
    xlim([0 f(N1)]);
subplot(2,1,2); hold on;
    plot(f,Phase10(1:N1),'k');       % Plot phase
    plot(f,Phase3(1:N1),':k','LineWidth',1); 
    xlabel('Frequency (Hz)','FontSize',14); ylabel('Phase (deg)','FontSize',14);
    xlim([0 f(N1)]);
    



