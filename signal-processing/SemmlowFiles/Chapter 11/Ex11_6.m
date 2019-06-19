% Example 11.6 Generate 1000 samples of correlated noise and then determine the
% automutual information function.  Use a maximum number of lags of 300 and
% a quantization factor of 8

clf
clear 
y0=[8,9,25]';                    % Initial values of x
tspan=linspace(.01,100,10000);   % Time interval for solution
[t,sol]=ode45(@lorenzeq,tspan,y0);   % Solve the differential equation in   
% loreneq                                                                    
x = sol(:,1); % Get x,y and z solutions from output sol
                                  
max_lags = 300;          % Set the maximum number of lags and histogram bin size
nu_bin = 10
[AMIF_curve,lag_tau, PD, lag_PD] = amif(x,max_lags,nu_bin); % Perform the AIF calculation
%%
%.....Label and Plot...
lag_vec = 0:1:(max_lags);
subplot(2,1,1)
     plot(lag_vec,AMIF_curve,'k','linewidth',2);
     title('Auto-mutual information function') 
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

[xcorr_curve,lag_tau,lag_PD,PD]= xcorr_amif(x,max_lags); % Perform the xcorr calculation
lag_vec = 0:(length(xcorr_curve)-1); 
%.....Label and Plot...

subplot(2,1,2)
    plot(lag_vec,xcorr_curve,'k','linewidth',2);
    title('Autocorrelation information function') 
    hold on
    stem(lag_tau,xcorr_curve(lag_tau+1),'--k','linewidth',2)
    stem(lag_PD,xcorr_curve(lag_PD+1),'*k','linewidth',2)
    grid on
    legend('Mutual Information',\it{'Lag_\tau','Lag_{PD}'})
    xlabel('Lag')
    ylabel('Mutual Information')
    set(findall(gcf,'type','text'),'FontSize',12) 
    set(gca,'FontSize',12) 
    text(25,.8,'B','fontsize',12)
