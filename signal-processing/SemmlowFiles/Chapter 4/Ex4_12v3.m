% Example 4.12 Frequency response of four 8th-order lowpass filters
%
clear all; close all;
N = 256;                % Padding
fs = 2000;			    % Sampling frequency
L = 8;				    % Filter order
fc = 200/(fs/2);		    % Filter cutoff frequency
rp = 3;			        % Maximum passband ripple in dB
rs = 60;				% Stopband ripple in dB
% Determine filter coefficients 
[b,a] = butter(L,fc);
[H,f] = freqz(b,a,N,fs);
subplot(2,2,1);
H = 20*log10(abs(H));       % Convert to dB
semilogx(f,H,'k');          % Plot spectrum in dB vs log freq.
axis([100 1000 -80 10]);
xlabel('Frequency (Hz)','FontSize',12);
ylabel('|X(f)| (dB)','FontSize',12);
title('Butterworth','FontSize',12);
[b,a] = cheby1(L,rp,fc);
[H,f] = freqz(b,a,N,fs);
subplot(2,2,2);
H = 20*log10(abs(H));       % Convert to dB
semilogx(f,H,'k');          % Plot spectrum in dB vs log freq.
axis([100 1000 -80 10]);
xlabel('Frequency (Hz)','FontSize',12);
ylabel('|X(f)| (dB)','FontSize',12);
title('Chebyshev I','FontSize',12);
[b,a] = cheby2(L,rs,fc);
[H,f] = freqz(b,a,N,fs);
subplot(2,2,3);
H = 20*log10(abs(H));       % Convert to dB
semilogx(f,H,'k');          % Plot spectrum in dB vs log freq.
axis([100 1000 -80 10]);
xlabel('Frequency (Hz)','FontSize',12);
ylabel('|X(f)|(dB)','FontSize',12);
title('Chebyshev II','FontSize',12);
[b,a] = ellip(L,rp,rs,fc);
[H,f] = freqz(b,a,N,fs);
subplot(2,2,4);
H = 20*log10(abs(H));       % Convert to dB
semilogx(f,H,'k');          % Plot spectrum in dB vs log freq.
axis([100 1000 -80 10]);
xlabel('Frequency (Hz)','FontSize',12);
ylabel('|X(f)| (dB)','FontSize',12);
title('Elliptic','FontSize',12);
