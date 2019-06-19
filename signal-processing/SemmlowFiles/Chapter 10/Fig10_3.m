clear
x1 = logistic(3.9999,100,.1);
x2 = .5-rand(1,100);
t=1:100;
subplot(3,1,1)
    plot(t,x2,'k','linewidth',2)
    axis tight
    grid on
    xlabel('Samples (n)')
    title('Random Signal')
    text(10,.4,'A')
subplot(3,1,2),plot(t,x1,'k','linewidth',2)
    title('Chaotic Signal (Logistic Map)')
    xlabel('Samples (n)')
    axis tight
    grid on
  
    text(4,.2,'B')
subplot(3,1,3)
    p=load('ECGtest.csv');
    fs = 22099/10;
    [b,a]=butter(2,[5/fs/2,100/fs/2]);
    p = filtfilt(b,a,p);
    plot(p,'k','linewidth',2)
    title('Deterministic Signal (ECG)')
    xlabel('Samples (n)')
    ylabel('Volts (V)')
    grid on
    axis tight
    text(100,.2,'C')
    set(findall(gcf,'type','text'),'FontSize',12) 
    