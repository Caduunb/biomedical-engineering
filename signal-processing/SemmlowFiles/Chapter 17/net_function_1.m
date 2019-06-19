function  net_function_1(X,d,w,b)
% Evaluates the boundary of a single sigmoid neuron
% Used only to produce Figure 11-7.
%     X   input variables a matrix
%     d   class associated with each variable (i.e. desired output)
%     w   weights of output layer neuron (a vector)  
%     b   bias of layer 2: a scalor of bias for the neuron in the output
%           layer

type = 's';
 close all; figure;
clf; hold on;       % Plot the results 
test = .5;
correct = 0; incorrect = 0; 
[r,c] = size(X);% Now plot the function space
x1_max = max(X(:,1));   %Find the limits of function space
x1_min = min(X(:,1));
x2_max = max(X(:,2));
x2_min = min(X(:,2));
x1_incr = (x1_max - x1_min)/40; 
x2_incr = (x2_max - x2_min)/40;
i = 0; 
for x1 = x1_min:x1_incr:x1_max
    i = i + 1;
    j = 0;
    x1_axis(i) = x1;
    for x2 = x2_min:x2_incr:x2_max
        j = j + 1;
       x2_axis(j) = x2;
       y1(i,j) = neuron([x1 x2],w,b,'s');
    end
end

mesh(x1_axis,x2_axis,y1');
view(3); grid on; view([36,40]);
colormap('copper');
caxis([-5 1]);  %For better printing
% Determine neuron's response to all input patterns
for i = 1:r
    y(i) = neuron(X(i,:),w,b,'s');
end
residual = mean(abs(d - y));

for i = 1:r
    if d(i) > test & y(i) > test
        plot3(X(i,1),X(i,2),d(i),'sqk','LineWidth',2);
        correct = correct + 1;
    elseif d(i) > test & y(i) <= test
        plot3(X(i,1),X(i,2),d(i),'sqk','MarkerFaceColor','k');
         incorrect = incorrect + 1;
    elseif d(i) <=test & y(i) <= test
        plot3(X(i,1),X(i,2),d(i),'ok','MarkerFaceColor','c');
         correct = correct + 1;
    elseif d(i) <= test & y(i) > test
        plot3(X(i,1),X(i,2),d(i),'ok','MarkerFaceColor','k');
         incorrect = incorrect + 1;
    end
end
xlabel('x1','FontSize',14); ylabel('x2','FontSize',14);
error = incorrect/(incorrect+correct);
figure; clf; hold on;
for i = 1:r
    if d(i) > test & y(i) > test
        plot(X(i,1),X(i,2),'sqk','MarkerFaceColor','b');
        correct = correct + 1;
    elseif d(i) > test & y(i) <= test
        plot(X(i,1),X(i,2),'sqk','MarkerFaceColor','r');
         incorrect = incorrect + 1;
    elseif d(i) <=test & y(i) <= test
        plot(X(i,1),X(i,2),'ok','MarkerFaceColor','b');
         correct = correct + 1;
    elseif d(i) <= test & y(i) > test
        plot(X(i,1),X(i,2),'ok','MarkerFaceColor','r');
         incorrect = incorrect + 1;
    end
end
contour(x1_axis,x2_axis,y1');
xlabel('x1','FontSize',14); ylabel('x2','FontSize',14);
specificity = (1-incorrect/(incorrect+correct))*100;
sensitivity = (correct/(incorrect+correct))*100;
title(['Sensitivity: ',num2str(sensitivity), ' Specificity: ',num2str(specificity)]);

