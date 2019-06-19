function [error, residual] = neuron_eval(X,y,w,b,type)
% Evaluates net performance and plots outut classification
% Plots only two variable input data
% Tests classification performance of a peceptron with weights w and bias b
%   and plots the linear classfication along with the actual class as 
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
if type == 's' % |type == 'p'
    test = .5;
else 
    test = 0;
end
correct = 0; incorrect = 0; 
[r,c] = size(X);
% Determine linear response to X
for i = 1:r
    a(i) = neuron(X(i,:),w,b,type);
end
residual = mean(abs(y - a));
figure(1);
clf; hold on;       % Plot the results 
for i = 1:r
    if y(i) > 0 & a(i) > test
        plot(X(i,1),X(i,2),'sqk','MarkerFaceColor','b');
        correct = correct + 1;
    elseif y(i) > 0 & a(i) <= test
        plot(X(i,1),X(i,2),'sqk','MarkerFaceColor','r');
         incorrect = incorrect + 1;
    elseif y(i) <=0 & a(i) <= test
        plot(X(i,1),X(i,2),'ok','MarkerFaceColor','b');
         correct = correct + 1;
    elseif y(i) <= 0 & a(i) > test
        plot(X(i,1),X(i,2),'ok','MarkerFaceColor','r');
         incorrect = incorrect + 1;
    end
end
xlabel('Parameter 1','FontSize',14); ylabel('Parameter 2','FontSize',14);
y_lim = get(gca,'YLim');
x_lim = get(gca,'XLim');
% Plot decision boundary W.P + b = 0
y = -b./w';
plot([0 y(1)],[y(2),0],'k','LineWidth',2);      %Plot boundary line
axis([xlim, ylim]);
error = incorrect/correct;