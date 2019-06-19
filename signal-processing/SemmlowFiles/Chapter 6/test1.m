fs = 1000;                  % Sampling frequency 
N = 256;
f = (1:N)*fs/N;             % Freqency vector.
x = sig_noise([320 340],-12,N);
x1 = sig_noise([320 340],-14,N);
x2 = sig_noise([320 340],-18,N);
PS = abs(fft(x)).^2;
PS1 = abs(fft(x1)).^2;
PS2 = abs(fft(x2)).^2;
subplot(3,1,1);
plot(f(1:N/2),PS(1:N/2),'k');
xlabel('Frequency (Hz)'); ylabel('Power Spectrum');
title('SNR -12 dB','FontSize',12);
subplot(3,1,2);
plot(f(1:N/2),PS1(1:N/2),'k');
xlabel('Frequency (Hz)'); ylabel('Power Spectrum'); 
title('SNR -14 dB','FontSize',12);
subplot(3,1,3);
plot(f(1:N/2),PS2(1:N/2),'k');
xlabel('Frequency (Hz)'); ylabel('Power Spectrum'); 
title('SNR -18 dB','FontSize',12);
