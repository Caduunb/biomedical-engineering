%Ex 11.11
clear all
close all
signal = load('ECGtest.csv');  % Load in the sample signal
order = 1  ;                   % Set order of trends
m= 2.^(2:14);                       % Use thirty
for ii = 1:length(m);
    F_m(ii) = DFA(signal,m(ii),order);
end
fit=polyfit(log(m),log(F_m),1);
plot(log(m),log(F_m),'k-o','linewidth',2)
hold on
plot(log(m),polyval(fit,log(m)),'k--','linewidth',3)
legend('log(F(m)','Fit')
ylabel('log(F(m))')
xlabel('log(m)')
set(findall(gcf,'type','text'),'fontsize',12)
set(gca,'fontsize',12)