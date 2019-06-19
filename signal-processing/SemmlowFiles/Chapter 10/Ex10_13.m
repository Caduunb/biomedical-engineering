% Example 10.14 Construct correlated noise using the MATLAB cumulative summation routine
% cumsum. For a vector input, this routine produces a vector output that is 
% the cumulative sum of input elements, thus performing a simplified
% numerical integration. Apply this routine to a random vector of 10,000 
% samples uniformly distributed between -0.5 to 0.5.  Plot the 
% autocorrelation to show that this signal does indeed contain correlated
% samples. Use the GPA to estimate the Dc of the correlated noise signal.  
% For delay embedding, use 3 dimensions and a delay of 3000 samples.  Test
% logarithmically spaced radius values between 10-3 and 103 when computing
% the correlation sum.  Estimate the correlation dimension from a plot of 
% the log of the correlation sum versus log radius by observing a scaling
% region and taking the slope.


sol = cumsum(rand(1,10000)-.5);  % Takes the integral of Gaussian noise to make correlated noise
%%
[x_cor,lags] = xcorr(sol,'coeff'); % Determine autocorrelation normalized to 1
subplot(1,2,1);
    plot(lags,x_cor,'k','linewidth',2) % Plot the autocorrelation 
    set(gca,'fontsize',14)
    set(findall(gcf,'type','text'),'FontSize',14) 
    grid on
    m = 3; tau = 3000; % Embedding parameters 
    x_emb = delay_emb(sol,m,tau); % Perform delay embedding
    ylabel('Correlation')
    xlabel('Lags[n]')
    t=title('A')
    set(t, 'horizontalAlignment', 'left')
    set(t, 'units', 'normalized')
    h1 = get(t, 'position');
    set(t, 'position', [0 h1(2) h1(3)])
subplot(1,2,2)
    plot3(x_emb(:,1),x_emb(:,2),x_emb(:,3),'k') % Plot the trajectory, note that it fills the phase-space (characteristic of noise)
    grid on
    xlabel('x[n]')
    ylabel('y[n]')
    zlabel('z[n]')
    set(gca,'fontsize',12)
    set(findall(gcf,'type','text'),'FontSize',12) 
    t=title('B')
   
    set(t, 'horizontalAlignment', 'left')
set(t, 'units', 'normalized')
h1 = get(t, 'position');
set(t, 'position', [0 h1(2) h1(3)])
    axis image
    
%%
figure
R=exp(linspace(-3,3,200)); % Setup R values to test using GPA
CR=cordim(sol,tau,m,R); % Use cordim to compute C^d(R)
%%
x1 = 53; xf = 76; % Start and stop points of observed scaling region
method = 1;
Cd=cor_dim_plot(R,CR,x1,xf,method); % Compute D^c and plot
