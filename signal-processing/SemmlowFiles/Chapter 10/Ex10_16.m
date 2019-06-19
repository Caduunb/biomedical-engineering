% Example 10.16  Use 20 surrogates to show that values of the 
% Logistic map for r = 4 are likely not generated from an ARMA process. 
% Use 1000 samples, an m of 2 and a delay tau of 1.  For both the 
% Logistic map and for the surrogates set the cutoff 
% radius value = 0.01std(x) 


close all , clear all
r = 4; N = 1000;  % Logistic map parameters
x(1) = 0.1;  % Initial value for Logistic map
m  = 2; % Embedding dimension
tau = 1; % Embedding delay
fs = 1;  % Sampling frequency

  for n=1:(N-1);                 % Iterate Logistic map to get values
       x(n+1)=r*x(n)*(1-x(n));
  end
  cutoff = .01*std(x);
  Lyapunov(1)=max_lyp(x,m,tau,fs,cutoff);   % Get Lyapunov exponent for map

for k = 2:21                     % Get surrogate and test Lyapunov exponent
    measured_surrogate = gauss_surrogate(x);
 Lyapunov(k)=max_lyp(measured_surrogate,m,tau,fs,cutoff);  % Use optional radius parameter

end

%....plotting similar to 10.15....
[ranked,ord] = sort(Lyapunov)  %  Order the Correlation Dimension from lowest 
                       %  to greatest
original_rank = find (ord==1)      %  Find rank of sine wave data
%....plotting....%
figure
hold on
bar(ranked,'k')
bar(original_rank,ranked(original_rank),'w','linewidth',2)
legend('Surrogates','Measured')
xlabel('Rank Order')
ylabel('Lyapunov Exponent')
set(findall(gcf,'type','text'),'FontSize',14) 
set(gca,'fontsize',14)