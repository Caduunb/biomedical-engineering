% Example 10.11   Determine the Lyapunov exponent for the logistic map over a range 
%    of driving force values, r.   Find the equilibrium population values 
%    of the logistic map after a number of generations.  In this case, 
%    use 200 generations.  The plot showing the equilibrium state for a 
%    number of generations as a function of the driving parameter, r, is 
%    known as the bifurcation plot, because it shows how these equilibrium 
%    values behave and these values will bifurcate for certain ranges of r.
%    The value of r should range between 3 and 4 since these values produce 
%    the most interesting behaviors.  For each value of r use the 
%    function max_lyp to determine the Lyapunov exponent. Plot both 
%    the population values from the logistic equation (xn+1 in Eq. 10.4) 
%    and lambda as function of the driving parameter r.  Lastly, determine the 
%    variance of the estimate for the logistic map when r = 4 by using fit_error.

clear 
close all
r = linspace(3,4,1000);  % Create vector of tested range of r values
N=200;                 % Length of Logistic map function
 m = 2; tau = 1;                  % Embedding Parameters
  fs = 1;                          % Sampling Frequency
             % Nearest Neighbor cutoff
for k=1:length(r)
    x(1) = .1;
    for n=1:(N-1);                 % Iterate Logistic map to get values
       x(n+1)=r(k)*x(n)*(1-x(n));
    end
   cutoff = 0.1*std(x); 
   Lyapunov(k)=max_lyp(x,m,tau,fs,cutoff);   % Use function max_lyp to get maximum 
                                   % Lyapunov exponent
   x_end(k,1:20)=x(181:200);                    % Save end values for bifurcation plot 
end
 
 [L_r4]=max_lyp(x,m,tau,fs,cutoff);   % Get vector of mean divergences
 
%......Label and Plot......
subplot(2,1,1)
plot(r,x_end,'.k','markersize',3)
title('Bifurcation Plot for Logistic Equation','fontsize',14,'fontweight','bold')
ylabel('X_{200}','fontsize',14,'fontweight','bold')
xlabel('Logistic Parameter (\it{r})','fontsize',14,'fontweight','bold')
text(3.05,.75,'A')
  set(gca,'FontSize',14)
subplot(2,1,2)
plot(r,Lyapunov,'.k','markersize',3)
title('Lyapunov Exponent','fontsize',14,'fontweight','bold')
grid on
ylabel('\lambda','fontsize',14,'fontweight','bold')
xlabel('Logistic Parameter (\it{r})','fontsize',14,'fontweight','bold')
text(3.05,1.75,'B')
  set(gca,'FontSize',14)
 set(findall(gcf,'type','text'),'FontSize',14) 