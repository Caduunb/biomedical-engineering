function [sensitivity, specificity, mse] = linear_eval3D(X,d,w)
% Evaluates performance of a linear discriminator and plots results
%   including the decision boundary
% Plots for two or three-variable input data
% Uses the critera of >= 0.5 to classify
%
% Inputs
%   X   inputs (assumed a matrix where the number or rows are different)
%       samples and the number of columns are the input dimension 
%   d   correct outputs; i.e., targets (assumed a vector)
%   w   linear weights
% Outputs
%   sensitivity     Percent ture positives
%   specificity     Percent true negative
%   mse             mean squred error
test = .5;
tp = 0;             % True positive count
fp = 0;             % False positive count
tn = 0;             % True negative count
fn = 0;             % False negative count
[r,c] = size(X);
% Determine linear response to X
y = X*w;
mse = mean((d' - y).^2);
% Plot the results
figure;
clf; hold on;        
for i = 1:r
    if c == 3           % Two-dimensional data
        %Assumes Class 0 is negative and Class 1 is positive
        for i = 1:r
            if d(i) > test & y(i) > test
                plot(X(i,1),X(i,2),'sqk','MarkerFaceColor',[.8 .8 .8],'LineWidth',1);
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
    elseif c == 4         % Three-dimensional data
        for i = 1:r
            if d(i) > test & y(i) > test
                plot3(X(i,1),X(i,2),X(i,3),'sqk','MarkerFaceColor','r','LineWidth',1);
                tn = tn + 1;        %True negative 
            elseif d(i) > test & y(i) <= test
                plot3(X(i,1),X(i,2),X(i,3),'sqk','MarkerFaceColor','k');
                fp = fp + 1;       % False positive
             elseif d(i) <= test & y(i) <= test
                plot3(X(i,1),X(i,2),X(i,3),'ok','MarkerFaceColor','b');
                 tp = tp + 1;       % True positive 
            elseif d(i) <= test & y(i) > test
                plot3(X(i,1),X(i,2),X(i,3),'ok','MarkerFaceColor','k');
                fn = fn + 1;        % False negative
            end
        end
    else
          disp('ERROR in input matrix: to many columns')
          return;
    end
end
V= axis;
%
% Plot decision boundary W*x + b = 0
if c == 3
  x1 = [min(X(:,1)),max(X(:,1))];     %Set x1 over data range
  x2 = -w(1)*x1/w(2) + (-w(3)+.5)/w(2);         %Calculate x2 using Eq. 14-10
  plot(x1,x2,'k','LineWidth',2);      %Plot boundary line
 axis(V);               % Restore axis
 xlabel('x1','FontSize',14); 
 ylabel('x2','FontSize',14);
else 
    view(3);       % View in 3D
    grid on;
    V = axis;
    x1 = 0:2*max(X(:,1))/44:max(X(:,1));  % Find boundary using Eq. 8
    x2 = 0:2*max(X(:,2))/44:max(X(:,2));
    for i = 1:length(x1)
        for  j = 1:length(x2)
            x3(i,j) = (.5 -w(1)*x1(i)  -w(2)*x2(j) -w(4))/w(3);
        end
    end
    p = surf(x2,x1,x3);
    %set(p,'facealpha',.8);       %Some tranparency
    axis(V);            % Restore original axis
    colormap(spring);
    
    
    xlabel('x1','FontSize',14); 
    ylabel('x2','FontSize',14);
    zlabel('x1 * x2','FontSize',14); 
end
specificity = (tn/(tn+fp))*100;
sensitivity = (tp/(tp+fn))*100;