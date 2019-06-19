function [Sensitivity, Specificity] = plot_results(X,d,y,thresh)
% [Sensitivity, Specificity] = plot_results(X,d,y,test)
% Program used plot data obtained from svm routines
%  Taken from the plotting section from liner_eval.
% Also works for 3 variable (i.e., 3-D) data.
%  Inputs
%     X        Test set (or set to be plotted)
%     d        Correct class
%     y        Classifier output
%     thresh   Threshold
%
%  Outputs
%     Sensitivity  (as defined)
%     Specificity
%
hold on;       % Plot the results
tp = 0; tn = 0; fp = 0; fn = 0; 
[r,dimension] = size(X);
if dimension == 2           % Two-dimensional data
    % Assumes Class 1 is negative and Class 0 is positive
    for i = 1:r
        if d(i) > thresh && y(i) > thresh
            plot(X(i,1),X(i,2),'sqk','MarkerFaceColor',[.8 .8 .8],'LineWidth',1);
            tn = tn + 1;        %True negative 
        elseif d(i) > thresh && y(i) <= thresh
            plot(X(i,1),X(i,2),'sqk','MarkerFaceColor','k');
            fp = fp + 1;       % False positive
        elseif d(i) <= thresh && y(i) <= thresh
            plot(X(i,1),X(i,2),'ok','MarkerFaceColor','c');
            tp = tp + 1;       % True positive 
        elseif d(i) <= thresh && y(i) > thresh
            plot(X(i,1),X(i,2),'ok','MarkerFaceColor','k');
            fn = fn + 1;        % False negative
        end
    end
   
elseif dimension == 3         % Three-dimensional data
    for i = 1:r
        if d(i) > thresh && y(i) > thresh
            plot3(X(i,1),X(i,2),X(i,3),'sqk','MarkerFaceColor','b','LineWidth',1);
            tn = tn + 1;        %True negative 
        elseif d(i) > thresh && y(i) <= thresh
            plot3(X(i,1),X(i,2),X(i,3),'sqk','MarkerFaceColor','k');
            fp = fp + 1;       % False positive
         elseif d(i) <= thresh && y(i) <= thresh
            plot3(X(i,1),X(i,2),X(i,3),'ok','MarkerFaceColor','r');
             tp = tp + 1;       % True positive 
        elseif d(i) <= thresh && y(i) > thresh
            plot3(X(i,1),X(i,2),X(i,3),'ok','MarkerFaceColor','k');
            fn = fn + 1;        % False negative
        end
    end
    grid on; view(3);
end
Specificity = (tn/(tn+fp))*100;
Sensitivity = (tp/(tp+fn))*100;
xlabel('x1','FontSize',14); ylabel('x2','FontSize',14);

 