% Example 7.6 Example of "Balance Tree Decomposition"
%  Construct a waveform of 4 sinusoids plus noise
%  Decompose the waveform in 3 levels, plot outputs at the terminal level
%  Use a Daubeches 4 element filter
%
clear all; close all;
fs = 1000;						% Sample frequency
N = 1024;						% Number of points in waveform
levels = 3;                      % Number of levels
nu_seg = 2^levels;              % Number of decomposed segments
freqsin = [1 12 44 200];        % Sinusoid frequencies
ampl = [1 1 1 1 ];              % Amplitude of sinusoid
t = (1:N/nu_seg)/fs;            % Time vector for plotting
h0 = daub(10);                  % Get filter coefficients: Daubechies 10
%
x = signal(freqsin,ampl,N); % Construct signal
a = w_packet(x,h0,levels);      % Decompose signal, Balanced Tree, 3 levels 
for k = 1:nu_seg
    i_s = 1 + (N/nu_seg) * (k-1);    % Location for this segment
    a_p = a(i_s:i_s+(N/nu_seg)-1);
    subplot(nu_seg/2,2,k);             % Plot decompositions
        plot(t,a_p,'k');  
        xlabel('Time (sec)','FontSize',12);
        xlim([0 t(end)]);
end    
   

