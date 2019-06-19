function class_error = percpt_eval(X,d,w,b)
% Evaluates perceptron performance and plots
% Plots only two variable input data
% Tests classification performance of a peceptron with weights w and bias b
%   and plots the peceptron classfication along with the actual class as 
%   given in y
%
%Inputs
%   X   input data. A matrix where each row contains an input pattern. 
%   d   correct classification; i.e., desired neuron output(vector)
%   w   perceptron weights (vector)
%   b   perceptron bias (scalor)

%Outputs
%   classification error:  Fraction in inputs misclassified
%
[r,c] = size(X);
test = 0;
tp = 0; tn = 0; fp = 0; fn = 0; % Clear all counts
% Determine perceptron response to all input signals
for i = 1:r
    y(i) = MCP_neuron(X(i,:),w,b);
end
%Evaluate the correctness of the responses
figure(1); clf; hold on;        % Plot the results 
for i = 1:r
    if d(i) > test & y(i) > test
        plot(X(i,1),X(i,2),'sqk','MarkerFaceColor','w','LineWidth',1);
        tn = tn + 1;        %True negative 
    elseif d(i) > test & y(i) <= test
        plot(X(i,1),X(i,2),'sqk','MarkerFaceColor','k');
         fp = fp + 1;       % False positive
    elseif d(i) <= test & y(i) <= test
        plot(X(i,1),X(i,2),'ok','MarkerFaceColor','c');
         tp = tp + 1;       % True positive 
    elseif d(i) <= test & y(i) > test
        plot(X(i,1),X(i,2),'ok','MarkerFaceColor','k');
        fn = fn + 1;        % False negative
    end
end
xlabel('x1','FontSize',16); ylabel('x2','FontSize',16);
% Determine decision boundary w.*x + b = 0
x1 = [min(X(:,1)),max(X(:,1))];     %Set x1 over data range
x2 = -w(1)*x1/w(2) -b/w(2);         %Calculate x2 using Eq. 11-6
plot(x1,x2,'k','LineWidth',2);      %Plot boundary line
class_error = (fn+fp)/(tn+tp+fn+fp);    % Classifcation error
specificity = (tn/(tn+fp))*100;
sensitivity = (tp/(tp+fn))*100;



