%  Example 10.4 Plot the phase-plane trajectory of the Hénon map defined by
%  Eqs. 10.5 and 10.6.  Also plot the trajectory of random noise for 
%  comparison.  Use starting points of x[1], y[1] = [0.5,0.5] and to ensure
%  a chaotic solution, use a = 1.4 and b = 1.3. 
%  Plot 10,000 individual points of the mapping function (i.e., not connected).  
%  For the plot of random noise use only 1000 samples, otherwise the density 
%  of points in the phase space will be too great to visualize the characteristics of the plot. 


N = 10000;               % Get 10000 values of Henon map
x=.1; y=.1; a=1.4; b=.3; %  Set up constants and initial conditions

for i=1:N  %  Step through N iterations
    x(i+1)=1-a*x(i).^2+y(i);  % x and y equations for Henon map
    y(i+1)=b*x(i);
end
subplot(1,2,1)
    plot(x,y,'.k') 
    xlabel('x [n]')
    ylabel('y [n]')
    text(-1,.1,'A','fontsize',14)
    set(gca,'FontSize',14)
    axis square
N = 1000
V1 = randn(1,N);  % Create two vectors of Guassian noise 
V2 = randn(1,N);    
subplot(1,2,2);
    plot(V1,V2,'.k')
    xlabel( 'Guassian Noise V1')
    ylabel( 'Guassian Noise V2')
    text(-2,3,'B','fontsize',14)
     axis square
set(findall(gcf,'type','text'),'FontSize',14)  %  Set Font Size to min 12
set(gca,'FontSize',14)  %  Set Font Size to min 12