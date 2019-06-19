function mse = net_eval3D(X,y,w,b)
% Evaluates performance of a single neuron and plots results
% Plots for three-variable input data
% Tests classification performance of a neuron with weights w and bias b
%   and plots the classfication of data X along with the actual class as 
%   given in y
%
%Inputs
%   X   inputs (assumed a matrix where the number or rows are different)
%       samples and the number of columns are the input dimension 
%   y   correct outputs; i.e., targets (assumed a vector)
%   w   neuron weights (vector)
%   b   neuron bias 
%   type neuron type: l(inear); p(ecpt); s(igmoid); t(arctan)
% Outputs
%   error Percent missclassified
test = .5;
[r,c] = size(X);
% Determine linear response to X
for i = 1:r
    a(i) = neuron(X(i,:),w,b,'s');
end
mse = mean((y - a).^2);
figure(1);
clf; hold on;       % Plot the results 
for i = 1:r
    if y(i) > 0 & a(i) > test
        plot3(X(i,1),X(i,2),X(i,3),'sqk','MarkerFaceColor',[.8 .8 .8],'LineWidth',1);
    elseif y(i) > 0 & a(i) <= test
        plot3(X(i,1),X(i,2),X(i,3),'sqk','MarkerFaceColor','k');
    elseif y(i) <=0 & a(i) <= test
        plot3(X(i,1),X(i,2),X(i,3),'ok','MarkerFaceColor','c');
    elseif y(i) <= 0 & a(i) > test
        plot3(X(i,1),X(i,2),X(i,3),'ok','MarkerFaceColor','k');
    end
end
view(3);       % View in 3D
xlabel('x1','FontSize',14); ylabel('x2','FontSize',14);
y_lim = get(gca,'YLim');
x_lim = get(gca,'XLim');
grid on;
% Plot decision boundary W.P + b = 0
x_axis = 0:max(X(:,1))/20:max(X(:,1));
y_axis = 0:max(X(:,2))/22:max(X(:,2));
for i = 1:length(x_axis)
    for  j = 1:length(y_axis)
        Z(i,j) = -w(2)*x_axis(i)/w(3)+ -w(1)*y_axis(j)/w(3) -b/w(3);
    end
end
p = mesh(y_axis,x_axis,Z);
axis([xlim, ylim]);
colormap('bone');
