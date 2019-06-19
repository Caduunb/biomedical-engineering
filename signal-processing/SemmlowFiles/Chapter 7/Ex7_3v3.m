% Example 7-3 and Figure 7-6 and 7-7
%  Dyadic Wavelet Transform Example
%  Construct a waveform of 4 sinusoids plus noise
%  Decompose the waveform in 4 levels, plot each level, then reconstruct
%  Use a Daubeches 6 element filter
%
clear all; close all;
global fs
fig1 = figure('Units','inches','Position',[0 2.5 3 3.5]);
fig2 = figure('Units', 'inches','Position',[6 2 5 5]);
fs = 1000;						% Sample frequency
N = 1024;						% Number of points in waveform
freqsin = [.63 1.1 2.7 5.6]; 	% Sinusoid frequencies
ampl = [1.2 1 1.2 .75 ];			% Amplitude of sinusoid
h0 = daub(6);                  	% Get filter coeff. 
[x t] = signal(freqsin,ampl,N); 	% Construct signal
x = x + (.25 * randn(1,N));		% Add noise
figure(fig2);
a = analyze(x,h0,4);	            % Decompose signal, analytic filter bank 
y = synthesize(a,h0,4);         % Reconstruct original signal
figure(fig1);
plot(t,x-4,'k',t,y,'k');    % Plot signals seperated
xlabel('Time (sec)','FontSize',14);
ylabel('x(t) & y(t)','FontSize',14);
text(.8,2,'Output','FontSize',16);
text(.8,-7,'Input','FontSize',16);
xlim([0 1.1]);



