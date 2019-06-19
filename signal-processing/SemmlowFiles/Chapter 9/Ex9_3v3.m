% Example 9.3 Generation of a set of 3 signals mixed 5 ways. Construct a
% data set, X, consisting of 5 observed signals that are linear
% combinations of 3 different waveforms.   Assume fs = 500 Hz and use N =
% 1000 which will generate 2 sec signals.  The three source signals should
% consist of:  a double sine wave, sawtooth wave, and a rectified sine
% wave, all with added noise.  Plot the original source signals and the
% mixture. Save the mixed signals for use in the next example.
% 
% Assign constants
clear all; close all;
N = 1000;                   % Number points (2 sec of data)
fs = 500;                   % Sample frequency
w = (1:N) * 2*pi/fs;		% Normalized frequency vector 
t = (1:N)/fs;               % Time vector
f1 = 8;                     % Freq sine wave 1
f2 = 26;                    % Freq sine wave 2

%
% Generate data
s1 = 0.5*sin(2*pi*f1*t) + 0.5*sin(2*pi*f2*t) + .07*randn(1,N);	% One component a double sin
s2 = sawtooth(14*pi*t,.5)+ .05*randn(1,N);		% One component a sawtooth		%
s3 = sign(sin(2*pi*t)).*sin(2*pi*t) + .07*randn(1,N);	% Half rectified sine
%
% Plot original signals
plot(t,s1-2.5,'k',t,s2,'k',t,s3+1.8,'k');   % Plot source signals displaced
xlabel('Time (sec)','FontSize',14);
ylabel('s(t)','FontSize',14);
title('Original Components (Before mixing)','FontSize',14);
%
% Combine data.  Define mixing matrix
A = [.5 .5 .5; .2 .7 .7; .7 .4 .2; -.5 .2 -.6; .7 -.5 -.4];
s = [s1; s2; s3];           % Signal matrix
X = A * s;                  % Generate mixed signal output
save mix_sig.mat X A;       % Save waveform and mixing matrix
figure; hold on;
% Center data and plot mixed signals
for i = 1:5
   X(i,:) = X(i,:) - mean(X(i,:));  % Remove mean
   plot(t,X(i,:)+2*(i-1),'k');
end
xlabel('Time (sec)','FontSize',14);
ylabel ('x(t)','FontSize',14);
title('Mixed Signals','FontSize',14);
