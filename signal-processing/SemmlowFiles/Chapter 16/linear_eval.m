function [sensitivity, specificity] = linear_eval(X,d,w,threshold)
%  [sensitivity, specificity] = linear_eval(X,d,w,threshold)
% Evaluates performance of a linear discriminator and plots results
%   including the decision boundary
% Plots only two-variable input data, but has been expanded for
%   three-variables in routine 'linear_eval3D'
% Uses the critera of > 0.5 to classify
%
% Inputs
%   X          inputs (assumed a matrix where the number or rows are different)
%                samples and the number of columns are the input dimension 
%   d          correct outputs; i.e., targets (assumed a vector)
%   w          linear weights
%   threshold  decision boundary threshold (default 0.5) 
% Outputs
%   sensitivity     Percent true positives
%   specificity     Percent true negative
%
if nargin < 4
    threshold = .5;
end
tp = 0;                     % True positive count
fp = 0;                     % False positive count
tn = 0;                     % True negative count
fn = 0;                     % False negative count
[r,c] = size(X);
% Determine linear response to X
y = X*w;                    % Evaluate the output 
%
% Plot the results
 hold on;        
% Assumes Class 0 is 0 (positive) and Class 1 is 1 (negative)
% Evaluates each point for all four possibilities
for i = 1:r
    if d(i) > threshold && y(i) > threshold
        plot(X(i,1),X(i,2),'sqk','MarkerFaceColor',[.8 .8 .8],'LineWidth',1);
        tn = tn + 1;        %True negative 
    elseif d(i) > threshold && y(i) <= threshold
        plot(X(i,1),X(i,2),'sqk','MarkerFaceColor','k');
        fp = fp + 1;       % False positive
    elseif d(i) <= threshold && y(i) <= threshold
        plot(X(i,1),X(i,2),'ok','MarkerFaceColor','c');
        tp = tp + 1;       % True positive 
    elseif d(i) <= threshold && y(i) > threshold
        plot(X(i,1),X(i,2),'ok','MarkerFaceColor','k');
        fn = fn + 1;        % False negative
    end
end
%    
V = axis;                               % Get current axis
%
% Plot decision boundary W*x = .5
x1 = [min(X(:,1)),max(X(:,1))];         % Construct x1 over data range
x2 = -w(1)*x1/w(2) + (-w(3)+threshold)/w(2);   % Calculate x2 using Eq. (9)
plot(x1,x2,'k','LineWidth',2);          % Plot boundary line
axis(V);                                % Restore axis
xlabel('x_1','FontSize',14); 
ylabel('x_2','FontSize',14);
% Evaluate sensitivity
specificity = (tn/(tn+fp))*100;
sensitivity = (tp/(tp+fn))*100;