%example 7
clear
close all
%create signal
rng('default');
rng(127);
randn('seed',127);
y=cumsum(randn(1,10000));
y2  = y
b=1;
 subplot(1,2,1)
%do curve fits for each section, plot
for i=1:9
    a=b;
    b=a+10;
    lf=polyfit(a:b,y(a:b),1);
    lf=polyval(lf,a:b);
    hold on
    plot(a:b,y(a:b),'k--',[a,b],lf(1,[1,10])','k-o','linewidth',2)
    set(gca,'Xtick',1:10:100)
    set(gca,'XGrid','on')  
     set(gca,'fontsize',14)
end
 
   hl=legend('y_{int}(k)','y_{lf}(k)');   
  
   xlabel('samples [n]')
   %do curve fits for each section, plot
   subplot(1,2,2)
   b = 1
for i=1:9
    a=b;
    b=a+10;
    lf=polyfit(a:b,y(a:b),1);
    lf=polyval(lf,a:b);
    hold on
    %plot(a:b,y(a:b),'k--',[a,b],lf(1,[1,10])','k-o','linewidth',2)
    % plot(a:b,y(a:b)-lf,'k--','linewidth',2)
    y(a:b) = y(a:b)-lf
   
end
plot(1:91,y(1:91),'--k','linewidth',2)
 set(gca,'Xtick',1:10:100)
    set(gca,'XGrid','on')  
     set(gca,'fontsize',14)
 
   hl=legend('y_{int}(k)-y_{lf}(k)');   
   
   
   
   figure
   i=2;
   n=1;
     set(findall(gcf,'type','text'),'fontsize',14)
    set(gca,'fontsize',12)
   %perform fluctuation analysis for several 
   %interval lengths
   while i<length(y2)       
       k(n)=DFA(y2,i,1);
       n=n+1;
       i=i*2;
   end
   
   %plot
   plot(log(1:length(k)),log(k),'k-o','linewidth',2)
   xlabel('segment length n')
   ylabel('F(m), RMS value')
   
  set(findall(gcf,'type','text'),'fontsize',18)
    set(gca,'fontsize',18)
