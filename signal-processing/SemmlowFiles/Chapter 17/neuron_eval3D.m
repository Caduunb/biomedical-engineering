function mse = net_eval3D(X,d,w,b,type)
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
if type == 's' 
    test = .5;
else 
    test = 0;
end
[r,c] = size(X);
% Determine linear response to X
for i = 1:r
    if nargin < 6        
        y(i) = neuron(X(i,:),W1,b1,type);      %Single layer
    elseif nargin < 8 
        [y_hl1, der_hl1]  = net_layer(X(i,:),W1,b1,type);    %Calculate the first layer of actan neurons
        y(i) = neuron(y_hl1,W2,b2,type);       %Output layer
    else 
        [y_hl1, der_hl1]  = net_layer(X(i,:),W1,b1,type);    %Calculate the first layer of actan neurons
        y_hl2 = net_layer(y_hl1,W2,b2,type); %Second layer
        y(i) = neuron(y_hl2,w3,b3,type);      %Output layer
    end
mse = mean(y - d(i).^2);
figure(1);
clf; hold on;       % Plot the results 
for i = 1:r
    if y(i) > test & d(i) > test
        plot3(X(i,1),X(i,2),X(i,3),'sqk','MarkerFaceColor','b');
    elseif y(i) > test & d(i) <= test
        plot3(X(i,1),X(i,2),X(i,3),'sqk','MarkerFaceColor','r');
    elseif y(i) <= test & d(i) <= test
        plot3(X(i,1),X(i,2),X(i,3),'ok','MarkerFaceColor','b');
    elseif y(i) <= test & d(i) > test
        plot3(X(i,1),X(i,2),X(i,3),'ok','MarkerFaceColor','r');
    end
end
view(3);       % View in 3D
xlabel('Parameter 1','FontSize',14); ylabel('Parameter 2','FontSize',14);
y_lim = get(gca,'YLim');
x_lim = get(gca,'XLim');
grid on;
% Plot decision boundary W.P + b = 0
y = -b./w';
plot3([0 y(1)],[y(2),0],[y(3) 0],'k','LineWidth',2);      %Plot boundary line
axis([xlim, ylim]);
