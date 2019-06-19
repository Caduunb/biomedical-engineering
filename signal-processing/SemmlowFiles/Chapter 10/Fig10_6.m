%make rectangle
%show iterates
clear
height = 100;
lengthb = 100;
a = 1.4;
b = 0.3;
N = 100;
h= .1;
w = .1
x=[-w*ones(1,height),linspace(-w,w,lengthb),linspace(-w,w,lengthb),w*ones(1,height)];
y=[linspace(-h,h,height),-h*ones(1,lengthb),h*ones(1,lengthb),linspace(-h,h,height)];
yn_1 = y;
    subplot(2,2,1)
    plot(x,y,'k.')
title(['A            0 Iterations'], 'Units', 'normalized', ...
'Position', [0 1], 'HorizontalAlignment', 'left') 
axis ([-1.1*w,1.1*w,-1.1*h,1.1*h])
xlabel('x[n]')
ylabel('y[n]')
 %set(gca,'xtick',[],'ytick',[])
N = 3
p = 1;
t=('ABCD')
 set(gca,'FontSize',12)
for i=1:N
    xn_1=y+1-a.*x.^2;
     yn_1=b.*x;
%      subplot(3,2,p)
%     plot(xn_1,yn_1,'.')
   % 
   
   if p < 6
    p = p + 1;
 
    
     subplot(2,2,p)
    plot(xn_1,yn_1,'k.')
   %  if p == 2
  title([t(p),'            ',num2str(p-1),' Iterations'], 'Units', 'normalized', ...
'Position', [0 1], 'HorizontalAlignment', 'left') 
xlabel('x[n]')
ylabel('y[n]')
   %end
 %axis ([-1.1*w,1.1*w,-1.1*h,1.1*h])
  % p = p + 1;    
    end
    x = xn_1;
    y = yn_1;
 set(gca,'FontSize',12) 
% set(gca,'xtick',[],'ytick',[])
   % axis off
end

   set(findall(gcf,'type','text'),'FontSize',12)     


 