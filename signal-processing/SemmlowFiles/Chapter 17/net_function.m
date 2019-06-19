function error = net_function(X,d,W1,b1,W2,b2,W3,b3)
% Evaluates the net function curve over the parameter space
% Plots only two variable input data for 2 or 3 layer nets
% Determines net size based on the number of input arguments
%
%Inputs
%     X   input variables a matrix
%     d   class associated with each variable (i.e. desired output)
%     W1  weights of hidden layer: The weights are a matrix where the  
%           column indicates the neuron number and row is input channel. 
%     b1  bias of layer 1: a vector of biases for the neurons in hidden
%           layer 
%     w2  weights of output layer neuron (a vector)  
%     b2  bias of layer 2: a scalor of bias for the neuron in the output
%           layer
%     fig figure number for plot (default = figure 1)
type = 's';
resolution = 50;    %Number of evaluated net output points per dimension
if type == 's'
    test = .5;
else 
    test = 0;
end
figure(1);
clf; hold on;       % Plot the results 
correct = 0; incorrect = 0; 
[r,c] = size(X);
% Now plot the function space
x1_max = max(X(:,1));   %Find the limits of function space
x1_min = min(X(:,1));
x2_max = max(X(:,2));
x2_min = min(X(:,2));
x1_incr = (x1_max - x1_min)/resolution; 
x2_incr = (x2_max - x2_min)/resolution;
i = 0; 
for x1 = x1_min:x1_incr:x1_max
    i = i + 1;
    j = 0;
    x1_axis(i) = x1;
    for x2 = x2_min:x2_incr:x2_max
        j = j + 1;
        x2_axis(j) = x2;
        y_hl1 = net_layer([x1,x2],W1,b1,type);    %First layer 
        if nargin < 8
            y1(i,j) = neuron(y_hl1,W2,b2,type);       %Output layer
        else 
            y_hl2 = net_layer(y_hl1,W2,b2,type); %Second layer
            y1(i,j) = neuron(y_hl2,W3,b3,type);      %Output layer
        end
    end
end
p = mesh(x1_axis,x2_axis,y1');
set(p,'facealpha',.8);
view(3); grid on; view([120,20]);
colormap('bone');
%For better printing
% Determine response to X
for i = 1:r
    [y_hl1, der_hl1]  = net_layer(X(i,:),W1,b1,type);    %Calculate the first layer of actan neurons
    if nargin < 8
        y(i) = neuron(y_hl1,W2,b2,type);       %Output layer
    else 
        y_hl2 = net_layer(y_hl1,W2,b2,type); %Second layer
        y(i) = neuron(y_hl2,W3,b3,type);      %Output layer
    end
end

for i = 1:r
    if d(i) > test & y(i) > test
        plot3(X(i,1),X(i,2),d(i),'sqk','MarkerFaceColor','w','LineWidth',1);
        correct = correct + 1;
    elseif d(i) > test & y(i) <= test
        plot3(X(i,1),X(i,2),d(i),'sqk','MarkerFaceColor','r');
         incorrect = incorrect + 1;
    elseif d(i) <= test & y(i) <= test
        plot3(X(i,1),X(i,2),d(i)+.1,'ok','MarkerFaceColor','c');
         correct = correct + 1;
    elseif d(i) <= test & y(i) > test
        plot3(X(i,1),X(i,2),d(i)+.1,'ok','MarkerFaceColor','r');
         incorrect = incorrect + 1;
    end
end
xlabel('x1','FontSize',16); ylabel('x2','FontSize',16);
error = incorrect/(incorrect+correct);
figure; clf; hold on;
for i = 1:r
    if d(i) > test & y(i) > test
        plot(X(i,1),X(i,2),'sqk','MarkerFaceColor','w','LineWidth',1);
        correct = correct + 1;
    elseif d(i) > test & y(i) <= test
        plot(X(i,1),X(i,2),'sqk','MarkerFaceColor','r');
         incorrect = incorrect + 1;
    elseif d(i) <= test & y(i) <= test
        plot(X(i,1),X(i,2),'ok','MarkerFaceColor','c');
         correct = correct + 1;
    elseif d(i) <= test & y(i) > test
        plot(X(i,1),X(i,2),'ok','MarkerFaceColor','r');
         incorrect = incorrect + 1;
    end
end
contour(x1_axis,x2_axis,y1');
colormap('bone'); caxis([0,1.5]);
xlabel('x1','FontSize',16); ylabel('x2','FontSize',16);
specificity = (1-incorrect/(incorrect+correct))*100;
sensitivity = (correct/(incorrect+correct))*100;
title(['Sensitivity: ',num2str(sensitivity), ' Specificity: ',num2str(specificity)]);

