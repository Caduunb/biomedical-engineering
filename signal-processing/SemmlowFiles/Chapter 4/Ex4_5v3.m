% Example 4.5 Find the actual magnitude spectrum of the rectangular window
%   filter given by Eq. 4.19 for two different window lengths:  L = 18 
%   and L = 66.   Then apply a Blackman window before takeing the Fourier 
%   transform.  Use a cutoff frequency of 400 Hz assuming a sampling
%   frequency of 1 kHz (i.e, a relative frequency of 0.4).
%
close all; clear all;
N = 256;                    % Number of points for plotting
fs = 1000;                  % Sampling freqeuncy
f = (1:N)*fs/N;             % Frequency vector for plotting
fc = 300/fs;                % Cutoff frequency (normalized)
L = [18 66];                % Filter lengths requested
for m = 1:2
    k  = -floor(L(m)/2):-1;      % Construct k for negative b[k];
    b = sin(2*pi*fc*k)./(pi*k); % Construct negative b[k]
    b =  [b 2*fc, fliplr(b)];   % Rest of b
    N_w = length(b);            % Window length
    n = -floor(L(m)/2):floor(L(m)/2);         % Window vector
    w_B = 0.35875 + 0.48829*cos(2*pi*n/N_w) + 0.14128*cos(4*pi*n/N_w)...
       + 0.01168*cos(6*pi*n/N_w);
    b = b .* w_B;           % Apply window
    H = fft(b,N);           % Calculate spectrum 
    subplot(1,2,m);         % Plot magnitude spectrum
    plot(f(1:N/2),abs(H(1:N/2)),'k');
    text(150,.9,['Length = ',num2str(length(b))],'FontSize',14);
        xlabel('Frequency (Hz)','FontSize',14);
        axis([0 600 0 1.2]);
    ylabel('B(f)','FontSize',14);
    disp(length(b))
end

