function x = tf_signal(signal_type)
% Function x = tf_signal(type)
% Inputs: signal type
%   'ss'   Sequential sinusiods
%   'ch'   Chirp
%   's2    Simultaneous sinusoids
%   'ms'   Moduslated sinusoid
%   'cs'   Chrip + constant
% Otuput
%   x      Output signal (N = 512, fs = 500 Hz)
% 
N = 512;				% Signal length 
fs = 500;               % Sampling frequency
f1 = 40;				% First frequency in Hz
f2 = 100;               % Second frequency in Hz
%
if strcmp(signal_type,'ss')
    N_4 = round(N/4);
	tn = (1:N_4)/fs;
	x = [zeros(N_4,1); sin(2*pi*f1*tn)'; sin(2*pi*f2*tn)'; zeros(N_4,1)];
elseif strcmp(signal_type,'ch') || strcmp(signal_type, 'cs');
    tn = (1:N)/fs;
    x = chirp(tn,f1,N/fs,f2)';       % Chirp
    if strcmp(signal_type, 'cs');
        x = x + sin(2*pi*f1*tn)';   % Chirp + sine
    end
elseif strcmp(signal_type,'s2')
    n1 = round(N/4);
    N_2 = round(N/2);
    t = (1:N)/fs; 
    x = sin(2*pi*f1*t)';            % Continuous signal
    tn = (1:N_2)/fs;
    x2 = zeros(N,1);                % Added signal
    x2(n1:n1+N_2-1) = sin(2*pi*f2*tn)';
    x = x + x2;                     % Add signals
elseif strcmp(signal_type,'ms')     % Modulated signal
    t = (1:N)/fs;
    fm = fs/N;                    % Generate two cycles
    fc = mean([f1 f2]);             % Base frequency (70 Hz)
    f = (fc/8)*sin(2*pi*fm*t) + fc; % Modulation 
    x = sin(2*pi*f.*t)';
else
    disp('Error in Signal type, no output generated')
    x = [];
end 

