% Example 4.8  Program to determine the frequency response of
%    the two point central difference algorithm used for differentiation%

clear all, close all;
Ts = .001;			% Assume a Ts of 1 msec.
N = 1000;			% Assume 1 second of data;hence, N = 1000
Ln = [1 3];			% Define two different skip factors
for m = 1:2         % Repeat for each skip factor
   L = Ln(m);
   b = [1 zeros(1,2*L-1) -1]/(2*L*Ts);
   H = abs(fft(b,N));	% Calculate frequency response using FFT
   subplot(1,2,m);	    % Plot the result
   hold on;
   plot(H(1:500),'k');	%Plot to fs/2
   axis([0 500 0 max(H)+.2*max(H)]);
   text(100,max(H),['Skip Factor = ',num2str(L)],'FontSize',14);
	xlabel('Freqency (Hz)','FontSize',14);
   ylabel('Magnitude','FontSize',14);
   y = (1:500) * 2 * pi;
   plot(y,'--k','LineWidth',2);	% Plot ideal derivative function
end
     
   