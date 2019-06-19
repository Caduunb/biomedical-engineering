% Example 10.8 Plot the phase trajectory derived from an ECG signal similar
% to that shown in Figure 10.11A.  Use a signal length of 250,000 sample 
% (fs = 2210 Hz).  Use the autocorrelation function to determine an 
% appropriate delay.  Use the nearest neighbor analysis to select the 
% embedding dimension.  
clear all;
close all;
x=load('ECGtest.csv');             % Load the test signal
fs = 2210;                       % Sampling Frequency
t = linspace(0,10,length(x));          % Get time vector
[xcor,lag]=xcorr(x,'coeff');       % Perform autocorrelation

% Plotting
subplot(2,1,1)
   plot(t,x,'k','linewidth',2,'markersize',2);    
   xlabel('Time (s)')
   ylabel('ECG Voltage (mv)')
   grid on
   set(gca,'FontSize',12)
   text(.1,.5,'A','fontsize',12)
subplot(2,1,2)
    plot(lag,xcor,'k','linewidth',2)
    grid on
    axis([0,2800,-.3,1.3])
    xlabel('Lags')
    ylabel('Normalized Correlation')
    set(gca,'FontSize',12)
    text(50,.75,'B','fontsize',12)
    set(findall(gcf,'type','text'),'FontSize',12) 


r = [1.25,1.5, 1.75];
for kk = 1:3;                         % Nearest neighbor ratio cutoff
em = 7;                               % Max tested embedding dimension
tau = 381;                            % Embedding Delay
[numnear(1:7,kk)]=fnumnear(x,tau, em,r(kk));  % Perform false nearest neighbor test
end                                       
figure
hold on
plot(numnear(:,1),'k','linewidth',2)
plot(numnear(:,2),'--k','linewidth',2)
plot(numnear(:,3),'.-k','linewidth',2)
legend('\it{r = 1.25}','\it{r = 1.5}','\it{r = 1.75}')
xlabel('Dimension')
ylabel('Mean Nearest Neighbors')
title('Nearest Neighbors for ECG')

grid on

  set(gca,'FontSize',14)
   set(findall(gcf,'type','text'),'FontSize',14) 
   
figure
m = 3;
y = delay_emb(x,m,tau);  % Perform delay space embedding
plot3(y(:,1),y(:,2),y(:,3),'k:') % Plot the phase space in 3D
  set(gca,'FontSize',14)
   set(findall(gcf,'type','text'),'FontSize',14) 
   axis([-.2,.4  ,-.2,.4,-.15,.35])
   grid on
   xlabel('x1[n]')
   ylabel('x2[n]')
   zlabel('x3[n]')
   
