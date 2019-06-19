function Cd=cor_dim_plot(R,CR,x1,xf,method)
% cor_dim_plot computes the correlation dimension from the correlation sum
% cuve and plots the curve well as the linear fit the curve.
% R: is the range of r values used in the correlation plot
% CR:  The mean correlation sum values as a function of R
% CR_stat:  The correlation sum values used to compute the linear fit error
% x1: The start of the observerd linear segment
% xf: The end of the obsereved linear segment
% Uses fit_error to compute the error of the linear fit.
% If method is 1, this uses the slope, if method 2 two, it uses the y intercept
% 1 is suitable for using the logR Vs Log CR curve, 2 is when using log R Vs dLogCr/dR
logR = log(R); % Get values for R axis plot results and perform curve fit
logCR = log(CR); % Get log C^d(R)

if method ==1
	logR = logR(x1:xf); % Get X and Y values for curve fitting
	logCR = logCR(x1:xf);
	P = polyfit(logR,logCR,1); % Use polyfit to get curve fit for C^d;

	Cd = P(method); % Slope is the Correlation Dimension 
	  
	
		plot(log(R),log(CR),'--k','linewidth',2,'markersize', 6)
		hold
		plot(logR,polyval(P,logR),'k','linewidth',5)
		grid on
		xlabel('Log R','fontsize',12,'fontweight','bold')
		ylabel('Log Counts','fontsize',12,'fontweight','bold')
		P=round(1000*P)/1000;
		text(logR(2),logCR(2), ['D^c=',num2str(Cd)],...
		'fontsize',12,'fontweight','bold')
		legend('Log Correlation Sum','Fit')
		set(findall(gcf,'type','text'),'FontSize',12) 
		set(gca,'fontsize',12)
	
elseif method == 2
    dlogR = diff(logR); % Get values for R axis plot results and perform curve fit
    dlogCR = diff(logCR)./dlogR; % Get log C^d(R)
    logR = logR(x1:xf); % Get X and Y values for curve fitting
	logCR = dlogCR(x1:xf);
	P = polyfit(logR,logCR,1); % Use polyfit to get curve fit for C^d;

	Cd = P(method); % Slope is the Correlation Dimension 
	  

		plot(log(R(2:end)),dlogCR,'--k','linewidth',2,'markersize', 6)
		hold
		plot(logR,polyval(P,logR),'k','linewidth',5)
		grid on
		xlabel('Log R','fontsize',12,'fontweight','bold')
		ylabel('d Log Counts/dlog R','fontsize',12,'fontweight','bold')
		P=round(1000*P)/1000;
		text(logR(1),Cd/1.1, ['D^c=',num2str(Cd)],...
		'fontsize',12,'fontweight','bold')
		legend('dLog Correlation Sum','Fit')
		set(findall(gcf,'type','text'),'FontSize',12) 
		set(gca,'fontsize',12)
    end
end
