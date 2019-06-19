% Example 7.1 
% Generate 2 sinusoids that change frequency in a step-like manner
% Apply the Continuous Wavelet Transform and plot results
% Use the Mexican Hat Wavelet.
%
clear all;  close all;
colormap(flipud(gray)); % Invert colormap for better viewing 
% Set up constants
fs = 200;		       % Sample frequency
N = 1000;		      % Signal length  and half wavelet length
n = N/4;		       % Signal length divided by 4
f1 = 10;		        % First frequency in Hz
f2 = 20;		        % Second frequency in Hz
resol_level = 40;	% Number of levels of a
decr_a = 2;           % Decrement for a
a_init = 0.5;		   % Initial a
wo = pi * sqrt(2/log2(2));
%
% Generate the two sine waves
tn = (1:n)/fs;		  % Time vector to create signal
b = (1:N)/fs;		  % Time vector for wavelet and plotting
x = [zeros(n,1); sin(2*pi*f1*tn)'; sin(2*pi*f2*tn)'; zeros(n,1)];
%
% Calculate Continuous Wavelet Transform
for k = 1:resol_level
     a(k) = a_init/(k*decr_a);	  % Set scale
     t = b/a(k);                       % Time vector for Wavelet
     wav = (exp(-t.^2).* cos(wo*t))/sqrt(a(k));   % Generate Morlet Wavlet
     psi = [fliplr(wav) wav(2:end)];         %  Make symmetrical about zero
    wlet(k,:) = psi; 
     CW_Trans(:,k) =conv(x,psi,'same');  % Remove extra points from each end
end
%

contour(b,a,CW_Trans');			% Contour plot
ylabel('a (Scale)','FontSize',14);
xlabel('b (sec)','FontSize',14);
caxis([-5 30]);
figure; colormap(flipud(gray));
mesh(a,b,abs(CW_Trans));    % Plot in 3 dimensions
xlabel('a (Scale)','FontSize',14);
ylabel('b (sec)','FontSize',14);
zlabel('CWT','FontSize',14)
view([130 37]);
caxis([-20 40]);

