function [sensitivity, specificity] = net_boundaries(X,d,W1,b1,W2,b2,W3,b3,type)
% Evaluates the net function curve over the parameter space
% Plots only two variable input data for 2 or 3 layer nets
% Determines net size based on the number of input arguments
% Calulates and outputs the confusion matrix
%
%Inputs
% Inputs
%     X   input variables a matrix
%     d   class associated with each variable (i.e. desired output)
%     W1  weights of hidden layer 1: The weights are a matrix where the  
%           column indicates the neuron number and row is input channel. 
%     b1  bias of layer 1: a vector of biases for the neurons in hidden
%           layer
%     W2  weights of hidden layer 2: The weights are a matrix where the  
%           column indicates the neuron number and row is input channel. 
%     b2  bias of layer 2: a vector of biases for the neurons in hidden
%           layer or a scalor 
%     w3  weights of output layer 3 neuron (a vector) if a three layer net  
%     b3  bias of layer 3: a scalor of bias for the neuron in the output
%           layer if a three layer net
%     type  (optional) neuron type: 'm' McCullough-Pitts, 'l' linear, 
%           's' Sigmoid (default), 'h' hyperpolic tangent
% Outputs
%     Sensitivity 
%     Specificity
if nargin == 5 
    type = W2;
elseif nargin == 7
    type = W3;
elseif nargin == 4 || nargin == 6 || nargin == 8
    type = 's';
end
if type == 'l' || type == 's'   % Set threshold
    test = .5;      
else
    test = 0.;
end
figure; clf; hold on;       
resolution = 50;
[r,c] = size(X);
% Now plot the function space  Find the limits of function space
x1_max = max(X(:,1));   
x1_min = min(X(:,1));
x2_max = max(X(:,2));
x2_min = min(X(:,2));

x1_incr = (x1_max - x1_min)/resolution; 
x2_incr = (x2_max - x2_min)/resolution;
i = 0; 
% Now plot the function space
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
            y_hl2 = net_layer(y_hl1,W2,b2,type);    %Second layer
            y1(i,j) = neuron(y_hl2,W3,b3,type);      %Output layer
        end
    end
end
p = mesh(x1_axis,x2_axis,y1');
set(p,'facealpha',.8);       %Some tranparency
view(3); grid on; view([120,20]);
cmap_new = flipud(colormap(copper)); %Invert bone colormap
colormap(cmap_new);
caxis([-.5,1.5]);         %For better printing
% Determine response to X
for i = 1:r
    [y_hl1, der_hl1]  = net_layer(X(i,:),W1,b1,type);    %Calculate the first layer 
    if nargin < 8
        y(i) = neuron(y_hl1,W2,b2,type);        %Output layer
    else 
        y_hl2 = net_layer(y_hl1,W2,b2,type);    %Second layer
        y(i) = neuron(y_hl2,W3,b3,type);        %Output layer
    end
end
 for i = 1:r
        if d(i) > test && y(i) > test
            plot3(X(i,1),X(i,2),d(i),'sk','MarkerFaceColor','w','LineWidth',1);
        elseif d(i) > test && y(i) <= test
            plot3(X(i,1),X(i,2),d(i),'sk','MarkerFaceColor','k');
        elseif d(i) <= test && y(i) <= test
            plot3(X(i,1),X(i,2),d(i),'ok','MarkerFaceColor','c');
        elseif d(i) <= test && y(i) > test
            plot3(X(i,1),X(i,2),d(i),'ok','MarkerFaceColor','k');
        end
    end
figure; clf; hold on;
[sensitivity, specificity] = plot_results(X,d,y,test); %Plot data
%
% Plot error of contours
contour(x1_axis,x2_axis,y1');
contour(x1_axis,x2_axis,y1',[test test],'LineWidth',2,'LineColor','k'); % Draw solid line
colormap('bone'); caxis([0,1.5]);


