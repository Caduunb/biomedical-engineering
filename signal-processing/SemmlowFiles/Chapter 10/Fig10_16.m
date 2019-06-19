%Example 10.9  Show how nearest neighbors in phase-space can be used as
%surrogates for similar initial conditions


clear 
clf
N= 150
x = logistic(4,N,.1);
i = 10
j = 6
Y = delay_emb(x,2,1);
[r,c]= size(Y)

ytest = repmat(Y(i,:),r,1);

dist = sqrt( sum( ((ytest-Y).^2),2));

temp = (dist < .2*std(x))
t = 1:N;
t=t(temp);
t = [i,t(j)];

nearest = Y((dist < .2*std(x)),:);

subplot(3,1,1);
plot(x,'k','linewidth',2)
hold on
plot(t,[Y(10,1),nearest(j,1)],'ko','markersize',9,'linewidth',3)
axis([0,N,-0.02,1.05])
title('A                          Logistic Map Time Series')
xlabel('n')
    set(gca,'FontSize',12) 

subplot(3,1,2)
plot(Y(:,1),Y(:,2),'.k')
hold on
h=plot([Y(10,1),nearest(j,1)],[Y(10,2),nearest(j,2)],'ko','markersize',9,'linewidth',2)
title('B                          Phase Plane of Logistic Map')
legend(h,'Nearest neighbors')
xlabel('x(n)')
ylabel('x(n+1)')
    set(gca,'FontSize',12) 
subplot(3,1,3)
plot(1:20,x(10:29),'k','linewidth',2)
hold on
plot(1:20,x(t(2):(t(2)+19)),'--k','linewidth',2)
legend('Test point','Neighbor')
title('C                          Test and Neighbor Time Series')
xlabel('n')

    set(findall(gcf,'type','text'),'FontSize',12) 
    
    set(gca,'FontSize',12) 