function [mse,sensitivity, specificity] = net_eval_1(X,d,w,b)
% Evaluates single neuron net performance using LNMS and plots output classification
% Plots only two variable input data
%
%Inputs
%     X   input variables a matrix
%     d   class associated with each variable (i.e. desired output)
%     w  weights of neuron (vector)
%     b  bias of neuron (scalor)
%    type neuron type: l(inear); p(ecpt); s(igmoid); t(arctan)
% Outputs
%     error Percent missclassified
%     mse mean square error
type = 's';
if type == 's' 
    test = .5;
else 
    test = 0;
end
tp = 0; tn = 0; fp = 0; fn = 0; % Clear all counts
[r,c] = size(X);
% Determine linear response to X
for i = 1:r
    y(i) = neuron(X(r,:),w,b,'s');    %Calculate the neuron output
end
mse = mean((d - y).^2);
figure(1);
clf; hold on;       % Plot the results 
for i = 1:r
    if d(i) > test & y(i) > test
        plot(X(i,1),X(i,2),'sqk','MarkerFaceColor','b');
        tn = tn + 1;        %True negative 
    elseif d(i) > test & y(i) <= test
        plot(X(i,1),X(i,2),'sqk','MarkerFaceColor','r');
         fp = fp + 1;       % False positive
    elseif d(i) <= test & y(i) <= test
        plot(X(i,1),X(i,2),'ok','MarkerFaceColor','b');
         tp = tp + 1;       % True positive 
    elseif d(i) <= test & y(i) > test
        plot(X(i,1),X(i,2),'ok','MarkerFaceColor','r');
        fn = fn + 1;        % False negative
    end
end
xlabel('x1','FontSize',14); ylabel('x2','FontSize',14);
y_lim = get(gca,'YLim');
x_lim = get(gca,'XLim');
x1 = [min(X(:,1)),max(X(:,1))];
x2 = -w(2)*x1/w(1) -b/w(2);      % Calculate boundary line
plot(x1,x2,'k','LineWidth',2);      %Plot boundary line
axis([xlim, ylim]);
specificity = (tn/(tn+fp))*100;
sensitivity = (tp/(tp+fn))*100;