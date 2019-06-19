% Example 11.9  Use the ApEn method to determine the entropy of the Henon map.  Compare
% that with the entropy of the surrogate of the Henon map.
clear all
N = 1000;    % Number of samples
f = 50;                                % fs and f for sine wave
fs = 1000;
xint = 0.01; % Initial values for the Henon map
yint = 0.01;
a = 1.4;     % a and b parameters for Chaotic Henon map
b = 0.3;    
[y,x_hennon]=henon(xint,yint,N-1,a,b); % Get Henon map
x_rand = randn(1,N);                   % Random signal


x_sine = sin(2*pi*f*(1:N)/fs);

test = [x_sine;x_hennon;x_rand];      % Make matrix of test signals
m = 2;
tau = 1;
for k = 1:3
    x = test(k,:);
    r = 0.15*std(x);
    Ap(k)=apen(x,tau,m,r);  % Get ApEn 
end
disp(Ap)