function [CD,f,t,Rxx,CD1,G] = cohen(x,fs,type,L)
% Function to compute several of Cohen's class of time-frequencey distributions
%	
%   Outputs
%		CD  Time Frequency Distribution
%		f   Frequency vector for plotting
%		t   Time vector for plotting
%       Rxx instantaneous autocorrelation
%       CD1 filtered instantaneous autocorrelation
%       G  Determining function
%	 Inputs
%		x	 Complex signal
%		fs  Sample frequency
%		type of distribution. Valid arguements are:
%			'c' (Choi-Williams), 'b' (Born-Jorden-Cohen);
%			and 'j  (Born-Jorden); JLS (Mod Choi-Williams
%           Default is Wigner-Ville
%
alpha = 0.5;              % Choi-Williams const
%
[N, xcol] = size(x);
if N < xcol                 % Make signal a row vector if necessary
   x = x';
   N = xcol;
end  
t = (1:N)/fs;		       % Calculate time and frequency vectors
f = (1:N) *(fs/(2*N));
Rxx = int_autocorr(x,fs);          % Instantaneous autocorrelation
if strcmp(type, 'c')			 	   % Get appropriate determining function
   G = choi_williams(alpha,L);	 % Choi-Williams
elseif strcmp(type,'b')	  
   G = BJC(L);					       % Born-Jorden-Cohen
elseif strcmp(type,'j')
    G = BJD(L);                        % Born-Jorden
elseif strcmp(type,'m');    
    G = JLS(alpha,L);                % Author's mod of Choi-Williams
elseif strcmp(type,'w')
    G = zeros(L,L);
    G = 1;						          % Wigner-Ville (no filter) 
else 
    disp('ERROR No filter specified')
    return
end   
CD1 = conv2(Rxx,G,'same');		 % 2-D convolution
CD = abs(fft(CD1)); 
