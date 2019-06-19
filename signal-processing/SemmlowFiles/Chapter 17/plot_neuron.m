% Plot the function and derivative of various neuron fucntions
clear all; close all;
type = input('Input neuron type: l(inear), s(igmoid), h(hyper tan), m(cCollough_Pitts)','s');
x = [-5:.05:5];
for i = 1:length(x)
    [y(i),der(i)]  = neuron(1,0,x(i),type);
end
clf; hold on;
plot(x,y,'k');
plot(x,der,':k','LineWidth',2')
xlabel('Input Sum and Bias','FontSize',14);
ylabel('Output','FontSize',14);
plot([x(1) x(end)],[0 0],'k')
plot([0 0], [-2 2],'k');

