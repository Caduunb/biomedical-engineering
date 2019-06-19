x = cumsum(randn(1,2^10));
t1 = 1:2^10
subplot(4,1,1)
  plot(t1,x)
   axis tight
   title('A (Original Signal)')
coarse1 = coarsening(x,1);
t = t1(1:2:end)
set(gca,'fontsize',12)
subplot(4,1,2)
  plot(t,coarse1)
   axis tight
   title('B (2 Scaling Steps)')
  coarse2 = coarsening(x,2);
  t = t1(1:3:end)
  set(gca,'fontsize',12)
subplot(4,1,3)

  plot(t,coarse2)
  title('C (3 Scaling Steps)')
   axis tight
    coarse10 = coarsening(x,6);
    set(gca,'fontsize',12)
subplot(4,1,4)

 t = t1(1:(7):end)
  plot(t,coarse10)
  xlabel('samples [n]')
  title('D (6 Scaling Steps)')
   axis tight
   set(findall(gcf,'type','line'),'color','k')
   set(findall(gcf,'type','text'),'fontsize',12)
   
   set(gca,'fontsize',12)