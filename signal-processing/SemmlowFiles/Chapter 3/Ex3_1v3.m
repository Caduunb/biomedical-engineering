% Example 3.1 Use Fourier series analysis to generate the magnitude and 
%  phase plot of the ECG signal originally shown in Figure 2.16 and repeated below. 
%
clear all; close all;
fs = 50;                 % Sample frequency
load eeg_data
N = length(eeg);        % Get N
Tt = N/fs;               % Calculate total time
f1 = 1/Tt;               % Calculate fundamental frequency
t = (1:N)/fs;           % Time vector for plotting
for m = 1:round(N/2)
    f(m) = m*f1;        % Sinusoidal freqeuncies
    a = sum(eeg.*cos(2*pi*f(m)*t));     % Cosine coeff., Eq. 3.3
    b = sum(eeg.*sin(2*pi*f(m)*t));     % Sine coeff., Eq. 3.4
    X_mag(m) = sqrt(a^2 + b^2);        % Magnitude spectrum Eq. 3.6
    X_phase(m) = -atan2(b,a);           % Phase spectrum, Eq. 3.7
end
X_phase = unwrap(X_phase);      % Compenstes for shifts > 2 pi
X_phase = X_phase*360/(2*pi);   % Convert phase to deg.
subplot(2,1,1);
plot(f,X_mag,'k');              % Plot magnitude spectrum
xlabel('Frequency (Hz)','FontSize',14);
ylabel('|X(m)|','FontSize',14);
subplot(2,1,2);
plot(f,X_phase,'k');            % Plot phase spectrum
xlabel('Frequency (Hz)','FontSize',14);
ylabel('Phase (deg)','FontSize',14);
% Confimation using the FFT
figure;
N2 = round(N/2);
f = (1:N2)*fs/(2*N2);
X = fft(eeg); 
X_mag = abs(X);
X_phase = angle(X);
X_phase = unwrap(X_phase);      % Compenstes for shifts > 2 pi
X_phase = X_phase*360/(2*pi);   % Convert phase to deg.
subplot(2,1,1);
plot(f,X_mag(1:N2),'k');              % Plot magnitude spectrum
xlabel('Frequency (Hz)','FontSize',14);
ylabel('|X(m)|','FontSize',14); title('FFT')
subplot(2,1,2);
plot(f,X_phase(1:N2),'k');            % Plot phase spectrum
xlabel('Frequency (Hz)','FontSize',14);
ylabel('Phase (deg)','FontSize',14);
