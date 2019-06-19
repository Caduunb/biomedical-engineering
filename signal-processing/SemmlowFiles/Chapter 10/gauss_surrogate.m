function [y]=gauss_surrogate(x)
% [y]=surrogate(x,N)
% A function to construct surrogate data from a time series
% Usage: y = gauss_surrogate(x)
%        x is the test data set
%        y is the surrogate data after applying a Weiner filter
%        y2 is the surrogate data without filtering
x = x(:);
x = x';  %  Enforce row vector
L = length(x);
if mod(L,2)~=0;
    x(end) = [];
    L = L -1;
end
fftx=fft(x);                  % Determine the Fourier transform

mag=abs(fftx);                % Get that magnitude spectrum
phase=unwrap(angle(fftx));    % Get the phase
phase=phase(1:(L/2))-pi;      % Take the first half of the phase and normalize 			      % by pi
phase2=phase(randperm(L/2));  % Randomly vary the phase vectory
phase2=[0,phase2,-phase2(end-1:-1:1)];    % Make phase vector that is an odd function
			       % so that inverse FFT is real

fftn=mag.*exp(j*(phase2));    % Construct the new Fourier transform
y=real(ifft(fftn));                % Compute inverse FFT to get Surrogate

