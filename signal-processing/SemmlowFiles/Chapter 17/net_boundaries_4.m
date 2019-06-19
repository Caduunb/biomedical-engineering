function net_boundaries_4(X,d,W1,b1,W2,b2,W3,b3,area_in)
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
%     area_in optional defines range of function analysis as described for
%           outputs.  This will be argument nu. 7 if two layer net
%
% Outputs
%     confusion: Confusion matrix
%     area_out: area of net boundary evaluation [x1_min x1_max x2_min x2_max]
type = 's';
resolution = 50;    %Number of evaluated net output points per dimension
if type == 's'
    test = .5;
else 
    test = 0;
end
[r,c] = size(X);
[dum,nu_ol] = size(W2);     % Determine number of output neurons
figure; clf; hold on;       
% Now plot the function space  Find the limits of function space
if nargin > 8
   x1_max = max(area_in(1));   
    x1_min = min(area_in(2));
    x2_max = max(area_in(3));
    x2_min = min(area_in(4));
elseif nargin == 7
    x1_max = max(w3(1));   
    x1_min = min(w3(2));
    x2_max = max(w3(3));
    x2_min = min(w3(4));
else
    x1_max = max(X(:,1));   
    x1_min = min(X(:,1));
    x2_max = max(X(:,2));
    x2_min = min(X(:,2));
end
area = [x1_min x1_max x2_min x2_max];
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
            for k = 1:nu_ol                                 % Output neurons
                j1 = (k-1)*2 + 1;           % Conneted to only two first layer neurons
                y1(i,j,k) = neuron(y_hl1(j1:j1+1),W2(:,k),b2(k),'s');   
            end       
        else 
            y_hl2 = net_layer(y_hl1,W2,b2,type); %Second layer
            for k = 1:nu_ol                                 % Output neurons
                j1 = (k-1)*2 + 1;           % Conneted to only two first layer neurons
                y1(i,j,k) = neuron(y_hl2(j1:j1+1),W2(:,k),b2(k),'s');   
            end
        end
    end
end
% Determine response to X
for i = 1:r
    y_hl1 = net_layer(X(i,:),W1,b1,type);    %Calculate the first layer of actan neurons
    if nargin < 8
        for j = 1:nu_ol                                 % Output neurons
            j1 = (j-1)*2 + 1;           % Conneted to only two first layer neurons
            y(i,j) = neuron(y_hl1(j1:j1+1),W2(:,j),b2(j),'s');   
        end
    else 
        y_hl2 = net_layer(y_hl1,W2,b2,type); %Second layer
       for j = 1:nu_ol                                 % Output neurons
            j1 = (j-1)*2 + 1;           % Conneted to only two first layer neurons
            y(i,j) = neuron(y_hl2(j1:j1+1),W2(:,j),b2(j),'s');   
        end
    end
end
%
marker_type = ['sk'; 'ok'; 'dk'; 'vk'];
% marker_color = ['b'; 'r'; 'g'; 'y'];   % Colorful marker 
marker_color = ['m'; 'c'; 'm'; 'c'];    % Less colorful for publication
for i = 1:r                         % Index over patterns
    for k = 1:4        % Index over classes
        if d(i,k) == 1;
            if d(i,k) == 1 & y(i,k) > test
                plot(X(i,1),X(i,2),marker_type(k,:),'MarkerFaceColor',marker_color(k,:));
            else 
                plot(X(i,1),X(i,2),marker_type(k,:),'MarkerFaceColor','c');
            end
        end
    end
end
%
for i= 1:4
    contour(x1_axis,x2_axis,y1(:,:,i)');
    contour(x1_axis,x2_axis,y1(:,:,i)',[test test],'LineWidth',2,'LineColor',marker_color(i)); % Draw solid line
    colormap('copper'); caxis([0,1.5]);
    xlabel('x1','FontSize',16); ylabel('x2','FontSize',16);
end
