function an = analyze(x,h0,L) 
%  an = analyze(x,h,L)
% Function to calculate analyze filter bank
% 
%  Inputs
%	x 	 input waveform (must be longer than 2^L + L and power of two)
%	h0   filter coefficients (low pass)
%	L    decomposition level (number of High pass filter in bank)
%
%  Outputs
%   an   array of combined filtered outputs
%
lf = length(h0);		% Filter length
lx = length(x);		    % Data length
an = x;					% Initialize output 
% Calculate High pass coefficients from low pass coefficients
for k = 0:(lf-1)
   h1(k+1) = (-1)^k * h0(lf-k);  % Uses Eq 7.20
end
% Calculate filter outputs for all levels
for k = 1:L
   lpf = conv(an(1:lx),h0,'same');			% Low pass FIR filter 
   hpf = conv(an(1:lx),h1,'same');			% High pass FIR filter
   lpfd = lpf(1:2:end);                     % Downsample
   hpfd = hpf(1:2:end); 
   an(1:lx) = [lpfd hpfd];		% Low pass output at beginning of array, but now
   lx = lx/2;					%  occupies only half the data points as last pass
   subplot(L+1,2,2*k-1);		% Plot both filter outputs
   plot(an(1:lx),'k');				% Lowpass output
   if k == 1
      title('Low Pass Outputs');
   end   
   subplot(L+1,2,2*k);
   plot(an(lx+1:2*lx),'k');			% Highpass output
   if k == 1 
      title('High Pass Outputs')
   end
end 
%
% This section for plotting
HPF = abs(fft(h1,256));             % Calculate and plot filter Transfer Functions
LPF = abs(fft(h0,256));
freq = (1:128)* 1000/256;           % Assume fs = 1000 Hz
subplot(L+1,2,2*k+1);
plot(freq, LPF(1:128),'k');				% Plot from 0 to fs/2 Hz 
text(1,1.7,'Low Pass Filter');
xlabel('Frequency (Hz.)');
subplot(L+1,2,2*k+2);
plot(freq, HPF(1:128),'k');
text(1,1.7,'High Pass Filter');
xlabel('Frequency (Hz.)');
