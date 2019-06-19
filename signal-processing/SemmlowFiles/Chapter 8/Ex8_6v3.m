% Example 8.6 Phase Sensitive Detection
%
% Set constants
close all;clear all;
fs = 2000;                      % Sampling frequency
fc = 250;                       % Carrier frequency
fsig = 5;                       % Signal frequency
N = 2000;                       % Use 1 sec of data
t = (1:N)/fs;                   % Time axis for plotting
wn = 80/(2*fs);                 % PSD low pass filter
order = 2;                      % Filter order
[b,a] = butter(order,wn);       % Design lowpass filter
                                % Generate AM signal
w = (1:N)* 2*pi*fc/fs;          % Carrier frequency = 500 Hz
w1 = (1:N)*2*pi*fsig/fs;        % Signal frequency = 5 Hz
vc = sin(w);                    % Define carrier 
vsig = .5*sawtooth(w1,.5);		% Define signal
vm = (1 + vsig) .* vc;          % Modulation constant = .5
subplot(3,1,1);	
    plot(t,vm,'k');			% Plot AM Signal
    xlabel('Time (sec)','FontSize',14);
    ylabel('V_m(t)','FontSize',14);
   ylim([-2 2]);
title('Modulated Signal','FontSize',14);
% Add noise with 3.16 times power (10 dB)
noise = randn(1,N);
scale = (var(vsig)/var(noise)) * 3.16;
vm = vm + noise * scale;
subplot(3,1,2);
    plot(t,vm,'k');                 % Plot AM Signal
    xlabel('Time (sec)','FontSize',14);
    ylabel('V_m(t)','FontSize',14);
    ylim([-2.2 2.2]);
title('Modulated Signal with Noise','FontSize',14);
                                    % Phase sensitive detection
ishift = round((45/360) * fs/fc);   % Shift carrier by 45 deg 
vc = [vc(ishift:N) vc(1:ishift-1)];
v1 = vc .* vm;                      % Multiply
vout = filter(b,a,v1);
subplot(3,1,3);
    plot(t,vout,'k');               % Plot AM Signal
    xlabel('Time (sec)','FontSize',14);
    ylabel('V(t)','FontSize',14);
    title( 'Demodulated Signal','FontSize',14);

