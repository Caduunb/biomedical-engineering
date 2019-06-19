% Ex 11.10
% Using functions apen and sampen, estimate the entropy of a signal created using rand for 13
% length sizes. Use lengths in powers of 2 from 2^2 to 2^14, m = 2, and a cutoff radius 0.15 times the
% signal’s standard deviation and tau = 1.

m = 2;   % Setup embedding parameters 
tau = 1;  

% Get the ApEn and the SampEn for each signal legn
for N = 2:14
    x = randn(1,2^N);  % Generate random signal
    r = .15*std(x);  % Radius cutoff value
    Sp(N-1)=sampen(x,tau,m,r);  % Get ApEn 
    Ap(N-1)=apen(x,tau,m,r);  % Get ApEn 
end
N = 2.^(2:14);
semilogx(N,Ap,'kx-',N,Sp,'ks-','linewidth',2)
legend('ApEn','SampEn')
xlabel('Length of Signal (samples)')
ylabel('Entropy')
set(findall(gcf,'type','text'),'fontsize',12)
set(gca,'fontsize',12)