% Example 10.16  Use sig_noise2 to create a noisy 10 Hz sine wave with 10 dB SNR, 
% (N = 2000 and fs = 100 Hz).  This represents a deterministic signal with some 
% stochastic properties added, as often found in biological signals. Determine 
% if this signal has nonlinear behavior using the correlation dimension and 
% compare the value from the original signal with those determined found a data 
% set consisting of 10 surrogate signals.  
clear all
fs =100   %  Signal sample rate
x = sig_noise2(10, 10, fs*20,fs);  % Use sig noise to
                                                     % Add noise to
                                                     % simulate real
                                                     % measured data

m=2; tau=round(fs/10/4); % Embedding vector for sine wave
                  % tau at quarter wavelength

R=exp(linspace(-4,3,100)); % Setup R values to test using GPA

CR=cordim(x,tau,m,R); % Use cordim to compute C^d(R)
%%
 x1 = 40;xf = 50;  % Indices for scaling region
 method = 1;
 Cd=cor_dim_plot(R,CR,x1,xf,method) % Get D^c and plot

for k = 2:11
    surrogate = gauss_surrogate(x);
    CR=cordim(surrogate,tau,m,R); % Use cordim to compute C^d(R)
    Cd(k)=cor_dim_plot(R,CR,x1,xf,method) % Get D^c and plot
end
 
 figure
[ranked,ord] = sort(Cd);  %  Order the Correlation Dimension from lowest 
                       %  to greatest
original_rank  = find (ord==1)      %  Find rank of sine wave data
%....plotting....%
hold on
bar(ranked,'k')
bar(original_rank ,ranked(original_rank),'w','linewidth',2)
legend('Surrogates','Measured')
xlabel('Rank Order')
ylabel('Correlation Dimension')
set(findall(gcf,'type','text'),'FontSize',14) 
set(gca,'fontsize',14)