%  Example 7-4  Application of DWT to nonlinear filtering
%  Construct the waveform in Example 7.3
%  Decompose the waveform in 4 levels, plot each level, then reconstruct
%    Use Daubechies 4 element filter 
%     Evaluate the two highest resolution highpass subbands and zero 
%           out those samples below some threshold value. 
%
close all; clear all;
fs = 1000;                      % Sample frequency
N = 1024;                       % Number of points in waveform
%		
freqsin = [.63 1.1 2.7 5.6]; 	    % Sinusoid frequencies
ampl = [1.2 1 1.2 .75 ];		    % Amplitude of sinusoids
[x t] = signal(freqsin,ampl,N);     % Construct signal
x = x + (.25 * randn(1,N));         %  and add noise
h0 = daub(4);
figure;
an = analyze(x,h0,4);       % Analytic Filter Bank of level 4
% Set the threshold times based on the variance of the two higher resolution
%     highpass subbands.  
threshold =    7* var(an(N/4:N)); 
for k = (N/4:N)         % Test two highest subbands
  if abs(an(k)) < threshold
      an(k) = 0;
  end
end
y = synthesize(an,h0,4);              % Reconstruct original signal
figure;
plot(t,x-4,'k',t,y,'k');    % Plot signals seperated
xlabel('Time (sec)','FontSize',14);
ylabel('x(t) & y(t)','FontSize',14);
text(.8,2,'Output','FontSize',16);
text(.8,-7,'Input','FontSize',16);
xlim([0 1.1]);
