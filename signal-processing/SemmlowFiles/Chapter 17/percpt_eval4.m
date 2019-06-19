function [error, y] = percpt_eval4(X,d,W,b)
% Evaluates perceptron performance on 4 distributions and plots
% Plots only two variable input data
% Tests classification performance of a peceptron with weights w and bias b
%   and plots the peceptron classfication along with the actual class as 
%   given in y
%
%Inputs
%   X   inputs (assumed a matrix where the number or rows are different)
%       samples and the number of columns are the input dimension 
%   y   correct outputs; i.e., targets (assumed a vector)
%   w   peceptron weights (vector)
%   b   peceptron bias (default = 0)
%
[r,c] = size(X);
correct = 0; incorrect = 0;
% Determine percptron response to X
y = zeros(r,4);
for i = 1:r
    y(i,d(i)) = percpt(X(i,:),W(:,d(i)),b(d(i)));
end
figure(1); clf; hold on;       % Plot the results
marker = ['sk'; 'ok'; 'dk'; 'vk'];     %Plot maker types
for i = 1:r
    if y(i,d(i)) == 1
        plot(X(i,1),X(i,2),marker(d(i),:),'MarkerFaceColor','b');
        correct = correct + 1;
    else
        plot(X(i,1),X(i,2),marker(d(i),:),'MarkerFaceColor','r');
        incorrect = incorrect + 1;
    end
end
xlabel('Parameter 1','FontSize',14); ylabel('Parameter 2','FontSize',14);
y_lim = get(gca,'YLim');
x_lim = get(gca,'XLim');
color = ['r'; 'b'; 'g'; 'k'];     %Plot maker types
x = [0 3];
for i = 1:4
    y1 = W(1,i)*x/W(2,i) -b(i)/W(2,i);
    plot(x,y1,color(i,:),'LineWidth',2);      %Plot boundary line
end
axis([xlim, ylim]);
error = incorrect/(incorrect+correct);
