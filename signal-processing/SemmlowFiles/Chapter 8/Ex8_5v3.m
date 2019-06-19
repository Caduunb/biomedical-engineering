% Example 8.5 Adaptive Noise Cancellation. A sawtooth waveform is the
% signal and a sinusoid at a frequency 2.33 times the sawtooth frequency is
% the interference signal.  The reference signal is a lowpass filtered
% version of the interfer-ence signal
%
% Generate signal and noise
close all; clear all;
fs = 500;					% Sampling frequency
L = 256;					% Filter order
N = 2000;					% Number of points
t = (1:N)/fs;				% Time vector for plotting
wn = 150/fs;
[b,a] = butter(4,wn);
%
%Generate data: sawtooth
w = (1:N) * 4 * pi/fs;      % Data frequency vector
x = sawtooth(w,.5);         % Signal is a sawtooth
subplot(3,1,1);
    plot(t,x,'k');				% Plot signal without noise
    xlabel('Time(sec)','FontSize',14); ylabel('x(t)','FontSize',14);
    title('Original Signal','FontSize',12);
% Add inteference signal
intefer = sin(w*2.33);      % Frequency = 2.33 time signal freq
x = x + intefer;            % Add interference to signal
ref = filter(b,a,intefer);  %  Ref. is filtered interference
% 
subplot(3,1,2);             % Plot unfiltered data
    plot(t, x,'k');
    xlabel('Time(sec)','FontSize',14); ylabel('x(t) + n(t)','FontSize',14);
    title('Signal + interference','FontSize',12);
Px = mean(x.^2);                    % Calculate waveform power for delta
delta = (1/(10*L*Px)) *.5;              % Convergence gain = .15
[b,y,out] = lms(ref,x,delta,L);         % Apply LMS algorithm
subplot(3,1,3);                     
    plot(t,out,'k');					% Plot filtered data						
    xlabel('Time(sec)','FontSize',14); ylabel('y(t)','FontSize',14,'FontSize',14);
    title('After Adaptive Noise Cancellation','FontSize',12);

