clear




a = 1.4;
b = .3;
x = -0.0749;
y = 0.2394;
N= 100000;
%%
[y,x] = henon(x,y,N,a,b);

subplot(1,3,1)
plot(x,y,'.k','markersize',3)
axis([-1.4,-.59,0.34 .385])
xlabel('x')
ylabel('y')

rectangle('Position',[-1.17,.367,.1,.0035],'linewidth',2)
subplot(1,3,2)
plot(x,y,'.k','markersize',3)
axis([-1.16,-1.11,0.3689 .37])
xlabel('x')
ylabel('y')

rectangle('Position',[-1.1147,-1.134,0.3695 .3697],'linewidth',2)
subplot(1,3,3)
plot(x,y,'.k','markersize',3)

xlabel('x')
ylabel('y')