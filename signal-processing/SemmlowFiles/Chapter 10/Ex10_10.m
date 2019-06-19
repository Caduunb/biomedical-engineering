% Example 10.10 Use Eq. 10.14 to estimate the Lyapunov exponent for the 
% logistic map using a driving force, r,  of 4 to put the system into the 
% chaotic range.  Create the two trajectories, xn and yn using the logistic 
% equation, but beginning with two slightly different initial conditions: 0.1 and 0.1001.  
% (To facilitate the code put both trajectories in a matrix variable xmat.)  
% Estimate Lambda from Eq 10.14 by plotting the 
% natural log of dn and finding the slope of the linearly increasing 
% region to estimate ?.  

clear all;close all
%setup the logistic map with r = 4 (highly chaotic)
%Determine 25 samples of two series starting with 0.1 and 0.1001
r=4;  % The driving force is 4, yeilding a highly chaotic solution
N=25; % Number of samples (we don't need very many 
      % since the divergence occurs quickly

xint=[.1,.1001];  % Initial conditions are .1 and .1001
for k=1:2         % Use a loop to create a two row vector of trajectories
clear x
x(1)=xint(k);
    for n=1:(N-1);
       x(n+1)=r*x(n)*(1-x(n));  % Apply Logistic map iteratively
    end
xmat(k,1:N)=x;
end


d=abs(xmat(1,:)-xmat(2,:));        % Determine the vergence between the 
d = log(d);                        % Take the log of the divergence

plot(d,'*k')
x = 1:14                      % Time vector used for linear fit
[p]=polyfit(x,d(x),1)         % Perform linear fit on first 14 samples
lambda_s = p(1);              % Lyapunov exponent is the slope of fit
hold on 
plot(x,p(1)*x+p(2),'k','linewidth',2)
slope = round(lambda_s*100)/100;  % Round for plotting
text(5,-1,['Slope \lambda = ',num2str(slope)])
xlabel( 'Samples (n)')
ylabel( 'Lyapunov Exponent')
title('Lyapunov Exponent for Logistic Equation')
text(1,-2,'B','fontsize',12)
set(findall(gcf,'type','text'),'FontSize',12)  %  Set Font Size to min 12
set(gca,'FontSize',12)  %  Set Font Size to min 12
r2=rsquared(d(x),p(1)*x+p(2)) % Determine the r^2 value of the fit
    
