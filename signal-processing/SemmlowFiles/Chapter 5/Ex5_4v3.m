% Example 5.4  Spectural analysis using the MUSIC eigen-decomposition based in Eq.
% 5.14.
%
close all; clear all;
fs = 1000;                   % Sampling frequency
p = 5;                       % Eigenvalue subspace. 
M = 12;                      % Number of noise and signal subspace dimensions
load narrowband_signals;     % Load data
N = length(x);               % Signal length
[cor,Rxx] = corrmtx(x,M);    % Generate the autocorrelation matrix
[U,D,V] = svd(Rxx,0);        % Singular value decomposition
eigen = diag(D);             % Find the eigenvalues
for k = p+1:length(eigen);     % Calculate the indivdual Fourier transforms
    Sxx(k-p,:) = abs(fft(V(:,k),256)).^2/eigen(k);
end
PS = 1./sum(Sxx);            % Take the inverse of the summed Fourier transforms      
PS = PS(1:round(length(PS)/2)); % Remove redundant data
f = (0:length(PS)-1)*fs/(2*length(PS)); % Compute the frequency vector
[PS1,f1] = pmusic(x,p,N,fs);
subplot(1,2,1);
    plot(f,PS,'k');
    xlabel('Frequency (Hz)','FontSize',12); ylabel('Power Spectrum','FontSize',12);
    title('Eq. 5.13','FontSize',14); 
subplot(1,2,2);
    plot(f1,PS1,'k');
    xlabel('Frequency (Hz)','FontSize',12); ylabel('Power Spectrum','FontSize',12);
    title('pmusic','FontSize',14); 



