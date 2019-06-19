% Ex 11.11
% Create a test signal of two sine waves and correlated noise and perform
% MSE
clear all
fs = 2000;  
f1 = 100;
N = 10000;
m = 2;              % Embedding dimension (or template length)
tau = 1;            % Delay (or skip factor)
L = 30;             % number of coarse graining steps
xnoise = cumsum(randn(1,N)/10);
t = linspace(1/fs,N/fs,N);
y = sin(2*pi*f1*t);
x = y + xnoise;  % Make test signal correalted noise with sine wave
r = 0.15*std(x); % Get the cutoff value

MSE(1) = sampen(x,tau,m,r); % Get SampEn for original signal
for k = 1:L
    resamp = coarsening(x,k); % Perform coarse graining
    r = 0.15*std(resamp);  % Recalculate the cutoff
    MSE(1+k) = sampen(resamp,tau,m,r); % Get the entropy
end
%...plotting and labels
subplot(2,1,1)
   plot(t,x,'k','linewidth',.5)
   xlabel('time [sec]')
   set(gca,'fontsize',12)
subplot(2,1,2)
    plot(0:L,MSE,'k','linewidth',2)
    xlabel('Scale Level')
    ylabel('Sample Entropy')
    set(findall(gcf,'type','text'),'fontsize',12)
    set(gca,'fontsize',12)