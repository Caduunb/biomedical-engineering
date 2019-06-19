function x = saw(T,N,fs,type)
% x = saw(T,N)
% Function to generate a sawtooth waveform of period T
% Inputs
%     T    period in sec.
%     N    number of cycles
%     fs   sampling freq.  (100 kHz default) 
% Outputs
%     x   output time signal
%
if nargin < 4
    type = 's';     % Sawtooth (default)
end
if nargin < 3
    fs = 1000;      % fs (default)
end
np = T*fs;      % Points per period
np_2 = round(np/2);
%
for k = 1:N
    ist = (k-1)*np + 1;    % First point in new cycle
    if type == 's'
        x(ist:ist+np_2-1) = 2*(0:np_2-1)/np_2;
        x(ist+np_2:ist+np-1) = 2*(np_2-1:-1:0)/np_2;
    elseif type == 't'
        x(ist:ist+np-1) = (0:np-1)/np_2;
    elseif type == 'd'
        x(ist:ist+np_2-1) = (0:np_2-1)/np_2;
        x(ist+np_2:ist+np-1) = (-np_2+1:0)/np_2;
    elseif type == 'h'      % Half wave symmetry waveform
        x(ist:ist+np_2-1) = (0:np_2-1)/np_2;
        x(ist+np_2:ist+np-1) = (0:-1:-np_2+1)/np_2;
    end
end
x = x - mean(x);        % Zero waveform and scale to +/- 1. 
    
    