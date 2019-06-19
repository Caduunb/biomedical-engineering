% Example 3.2 Perform a discrete Fourier series analysis on
%  the triangular waveform defined by the equation given
%
clear all; close all;
fs = 500;           % Sampling frequency
Tt = 1;             % Total time
N = Tt*fs;          % Determine N
f1 = 1/Tt;          % Fundamental frequency
t = (1:N)/fs;       % Time vector
% Construct waveform
x = zeros(1,N);     % Constuct waveform
x(1:N/2) = t(1:N/2);
% Fourier decomposition
a0 = 2*mean(x);     % Calculate a(0)
for m = 1:10
    f(m) = m*f1;        % Sinusoidal frequencies
    a = (2/N)*sum(x.*cos(2*pi*f(m)*t));     % Cosine coeff., Eq. 3.3
    b = (2/N)*sum(x.*sin(2*pi*f(m)*t));     % Sine coeff., Eq. 3.4
    X_mag(m) = sqrt(a^2 + b^2);        % Magnitude spectrum Eq. 3.6
    X_phase(m) = -atan2(b,a);           % Phase spectrum, Eq. 3.7
end
% Reconstructions
x1 = zeros(1,N);        
for m = 1:5
    f(m) = m*f1;        % Sinusoidal frequencies
    x1 = x1 + X_mag(m)*cos(2*pi*f(m)*t + X_phase(m)); % Eq. 3.15
end
x1 = x1 + a0/2;         % Add in DC term
subplot(2,1,1);
plot(t,x1,'k'); hold on;
plot(t,x,'--k');     % Plot reconstructed and original waveform
xlabel('Time(sec)','FontSize',14);
ylabel('x(t)','FontSize',14);
title('5 components','FontSize',12);
%
x2 = zeros(1,N); 
for m = 1:10
    f(m) = m*f1;        % Sinusoidal frequencies
    x2 = x2 + X_mag(m)*cos(2*pi*f(m)*t + X_phase(m));
end
x2 = x2 + a0/2;         % Add in DC term
subplot(2,1,2);
plot(t,x2,'k'); hold on
plot(t,x,'--k');     % Plot reconstructed and original waveform
xlabel('Time(sec)','FontSize',14);
ylabel('x(t)','FontSize',14);
title('10 components','FontSize',12);


