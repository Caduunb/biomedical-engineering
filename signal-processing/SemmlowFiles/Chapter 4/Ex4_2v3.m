%  Example  4.2 and Figures 4-2 and 4-3
%   Plot the Frequency characteristics and impulse response
%    of a linear digital system with the given digital Transfer function
%   Assume a sampling frequency of 1kHz
close all; clear all;
fs = 1000;					% Sampling frequency
N = 512;					% Number of points
%  Define a and b coefficients based on H(z)
a = [1 -.2 .8];
b = [.2 .5];
% Plot the Frequency characteristic of H(z) using the fft
H = fft(b,N)./fft(a,N);		    % Compute H(f)
Hm = 20*log10(abs(H));          % Get magitude in dB
Theta = (angle(H))*360/(2*pi);       %   and phase in deg. 
f = (1:N)*fs/N;				% Frequency vector for plotting
subplot(2,1,1); 
plot(f(1:N/2),Hm(1:N/2),'k');			% Plot and label mag  H(f)
xlabel ('Frequency (Hz)','FontSize',14);
ylabel('|H(z)| (dB)','FontSize',14);
grid on;                        % Plot using grid lines
subplot(2,1,2); 
plot(f(1:N/2),Theta(1:N/2),'k');		% Repeat for phase 
xlabel ('Frequency (Hz)','FontSize',14);
ylabel('Phase (deg)','FontSize',14);
grid on;                        % Plot using grid lines
% Compute the Impulse Response
x = [1, zeros(1,N-1)];		    % Generate an impulse function
y = filter(b,a,x);				% Apply b and a to impulse using Eq. 4-6 
figure;						    % New figure
t = (1:N)/fs;
plot(t(1:60),y(1:60),'k'); hold on;		% Plot only the first 60 points for clarity
plot([t(1) t(60)],[0 0],'k');  % Plot zero line
xlabel('Time (sec)','FontSize',14);			% Labels
ylabel ('Impulse Response','FontSize',14);

