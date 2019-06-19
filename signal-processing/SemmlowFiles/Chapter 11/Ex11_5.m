% Example 11.5 Generate 1000 samples of correlated noise and then determine the
% automutual information function.  Use a maximum number of lags of 300 and
% a quantization factor of 8

clf
rng(2); %  Set the random number generator so everyone gets the same values
x=cumsum(randn(1,1000)); % Create a correlated noise vector 
max_lags = 300;          % Set the maximum number of lags and histogram bin size
nu_bin = 10;

[AMIF_curve,lag_tau, PD, lag_PD] = amif(x,max_lags,nu_bin); % Perform the AIF calculation

%.....Label and Plot...
lag_vec = 0:1:(max_lags);
subplot(2,1,1)
     plot(lag_vec,AMIF_curve,'k','linewidth',2);
     title('Automutual information function') 
     hold on
     stem(lag_tau,AMIF_curve(lag_tau+1),'--k','linewidth',2)
     stem(lag_PD,PD,'*k','linewidth',2)
     grid on
     legend('Mutual Information','Lag_\tau','Lag_{PD}')
     xlabel('Lag')
     ylabel('Mutual Information')
     set(findall(gcf,'type','text'),'FontSize',12) 
      set(gca,'FontSize',12) 
    text(25,.8,'A','fontsize',12)
AMIF_sum_cornoise = sum(AMIF_curve);  % Get the sum of the curve
  %%  
x=(randn(1,1000)); % Create a uncorrelated noise vector 
[AMIF_curve,lag_tau, PD, lag_PD] = amif(x,max_lags,nu_bin); % Perform the AMIF calculation
%.....Label and Plot...

subplot(2,1,2)
    plot(lag_vec,AMIF_curve,'k','linewidth',2);
    title('Automutual information function') 
    hold on
    stem(lag_tau,AMIF_curve(lag_tau+1),'--k','linewidth',2)
    stem(lag_PD,AMIF_curve(lag_PD+1),'*k','linewidth',2)
    grid on
    legend('Mutual Information','Lag_\tau','Lag_{PD}')
    xlabel('Lag')
    ylabel('Mutual Information')
    set(findall(gcf,'type','text'),'FontSize',12) 
    set(gca,'FontSize',12) 
    text(25,.8,'B','fontsize',12)
AMIF_sum_gauss = sum(AMIF_curve);