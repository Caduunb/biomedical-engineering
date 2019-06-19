% Example 10.15 Use an output of the Lorenz system, a signal known to 
% contain nonlinearities, in an evaluation of the surrogate data test.  Take
% the x output of the Lorenz system as a signal and apply correlation 
% dimension analysis.  Construct a surrogate of this signal and again apply
% correlation dimension analysis.  Compare the two results.  Show that the 
% power spectrum of the original and surrogate series are the same despite 
% having different time behavior.

close all
clear

m=3; tau=5; fs=100; % Set up delay parameters using dimension 3 and delay 5 
 y0=[8,9,25]';                    % Initial values of x, y, and z for ODE45
 tspan=linspace(.01,100,10000);   % Time interval for solution
 [t,sol]=ode45(@lorenzeq,tspan,y0);   % Solve the differential equation in   

x = sol(:,1);  % Get X axis values
[sur] = gauss_surrogate(x); % Construct surrogate 
fftX = 20*log10(abs(fft(x))); % Determine the power spectra of the surrogate and 
fftsur =20*log10(abs(fft(sur))); % Measured values.

freq = (1:10000)/10000*fs;       % Make frequency vector
%...label,plot......
subplot(2,2,1)
    plot(t,x,'k');
    xlabel('time (s)')
    ylabel('X Amplitude')
    title('X axis of Lorenz system')
    axis([0,100,-20,20])
    text(5,15,'A')
    set(gca,'fontsize',12)
subplot(2,2,2)
    plot(t,sur,'k');
    xlabel('time (s)')
    ylabel('Amplitude')
    title('Surrogate for X axis')
    axis([0,100,-20,20])
    text(5,15,'B')
    set(gca,'fontsize',12)
subplot(2,2,3)
    plot(freq(1:5000),fftX(1:5000),'k');
    xlabel('Frequency (Hz)')
    ylabel('Power')
    title('Surrogate for X axis')
    text(10,90,'C')
    set(gca,'fontsize',12)
subplot(2,2,4)
    plot(freq(1:5000),fftsur(1:5000),'k');
    xlabel('Frequency (Hz)')
    ylabel('Power')
    title('Surrogate for X axis')
    text(10,90,'D')
set(findall(gcf,'type','text'),'FontSize',12) 
    set(gca,'fontsize',12)
%%    
m=3; tau=5;

R=exp(linspace(-4,3,100)); % Setup R values to test using GPA

CR=cordim(sur,tau,m,R); % Use cordim to compute C^d(R)
figure
%%
x1 = 27;xf = 43;  % Indices for scaling region
method = 1;
Cd=cor_dim_plot(R,CR,x1,xf,method) % Get D^c and plot

        