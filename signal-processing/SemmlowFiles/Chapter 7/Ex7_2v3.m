% Example 7.2  
% Plot of Wavelet boundaries for various values of 'a'
% Determines the time and scale range of various popular Wavelets.
%  Uses the equations for center time and frequency and for time 
%	and frequency spread given in the text
%
%  Does this for various values of 'a'
%
 clear all; close all;
fs = 200;                       % Sample frequency
N = 1024;                        % Wavelet half length
a = [.25 .5 1 2];               % Values of 'a'
wo = pi * sqrt(2/log2(2));
t1 = (0:(N-1))/fs;              % Time vector to generate wavelet
t2 = [-fliplr(t1) t1(2:end)];   % Time vector for wavelet
w = 2*pi*(1:N/2)*fs/N;          % Frequency vector for wavelet
hold on;
%
for k = 1:length(a)
     t = t1/a(k);                   % Set time vector for Wavelet
     wav = exp(-t.^2).* (1-2*t.^2); % Generate Mexican Hat Wavelet
     psi = [fliplr(wav) wav(2:end)];    % Make symmetrical arount t = 0
     psi_sq = abs(psi).^2;             % Square wavelet 
     Psi = abs(fft(psi)/N);			% Get frequency representation
     Psi_sq = Psi(1:N/2).^2;           %   and square. Use only fs/2 range
     t0 = sum(t2.* psi_sq)/sum(psi_sq);	% Center time, Eq. 7.8
     delta_t = sqrt(sum((t2 - t0).^2 .* psi_sq)/sum(psi_sq)); % Time spread, Eq. 7.7
     w0 = sum(w.*Psi_sq)/sum(Psi_sq);	% Center frequency, Eq. 7.10
     delta_w = sqrt(sum((w - w0).^2 .* Psi_sq)/sum(Psi_sq)); % Frequency spread, Eq. 7.9 
     % Plot boundaries
     t01 = a(k);	% Adjust center time, since waveform 
     plot([t01-delta_t/2 t01-delta_t/2],[w0-delta_w/2 w0+delta_w/2],'k');  % Plot box
     plot([t01+delta_t/2 t01+delta_t/2],[w0-delta_w/2 w0+delta_w/2],'k'); 
     plot([t01-delta_t/2 t01+delta_t/2],[w0-delta_w/2 w0-delta_w/2],'k');
     plot([t01-delta_t/2 t01+delta_t/2],[w0+delta_w/2 w0+delta_w/2],'k');
     area(k) = delta_t * delta_w;
     text(t01+delta_t/2, w0+delta_w/2,['\it{a} = ',num2str(a(k))],'FontSize',12);
end 
    xlabel('Time (sec)','FontSize',14);
    ylabel('Frequency (rad/sec)','FontSize',14);
    axis([0 3 0 24]);
    disp(area)