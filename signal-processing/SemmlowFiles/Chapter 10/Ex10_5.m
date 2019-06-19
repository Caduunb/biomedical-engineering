%Example 10.5 To demonstrate how the choice of time series to use in embedding
% can effect a phase-space reconstructed from a single dimension, 
% solve the Lorenz equations 10.5-7 using ode45 for x, y, and z and plot
% the various combinations of these variables against N.  Use initial 
% values for y0 as (8,9,25) and a 1000 sample time vector tspan from 
% 0.1 to 100  Use the delay_emb function to determine the embedded vectors

y0=[8,9,25]';                    % Initial values of x, y, and z for ODE45
tspan=linspace(.01,100,10000);   % Time interval for solution
[t,sol]=ode45(@lorenzeq,tspan,y0);   % Solve the differential equation in   
% loreneq                                                                    
x = sol(:,1); % Get x,y and z solutions from output sol
y = sol(:,2)
z = sol(:,3),                                    
 
xyz='xyz';
letter ='ABCD' 
figure
subplot(2,2,1)
plot3(x,y,z,'.k','markersize',1)

title('Runge Kutta Solution','fontweight','bold','fontsize',14)
xlabel('x','fontweight','bold','fontsize',14)
ylabel('y','fontweight','bold','fontsize',14)
zlabel('z','fontweight','bold','fontsize',14)
grid on
set(gca,'fontweight','bold')
m=3;
 text(20,20,50,letter(1),'fontsize',14)
  tau=6;
 axis tight
for i=1:3                         % Loop cycles through each column of sol
    y=delay_emb(sol(:,i),m,tau);  % Use delay_emb to create the delayed 
    subplot(2,2,i+1);             % delayed vectors, then plot
    plot3(y(:,1),y(:,2),y(:,3),'.k','markersize',1)
    title([xyz(i),' axis with delay = ',num2str(tau)],'fontweight','bold','fontsize',14);
    xlabel('x','fontweight','bold','fontsize',14)
    ylabel('y','fontweight','bold','fontsize',14)
    zlabel('z','fontweight','bold','fontsize',14)
    grid on
    set(gca,'fontweight','bold')
    set(findall(gcf,'type','text'),'FontSize',12) 
    set(findall(gca,'type','text'),'FontSize',12) 
    text(0,20,20,letter(i+1),'fontsize',14)
    axis tight
end
  