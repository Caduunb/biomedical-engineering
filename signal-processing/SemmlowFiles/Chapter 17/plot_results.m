function [sensitivity, specificity] = plot_results(X,d,y,test)

hold on;       % Plot the results
tp = 0; tn = 0; fp = 0; fn = 0; 
[r,dimension] = size(X);
if dimension == 2           % Two-dimensional data
    % Assumes Class 1 is negative and Class 0 is positive
    for i = 1:r
        if d(i) > test && y(i) > test
            plot(X(i,1),X(i,2),'sqk','MarkerFaceColor',[.8 .8 .8],'LineWidth',1);
            tn = tn + 1;        %True negative 
        elseif d(i) > test && y(i) <= test
            plot(X(i,1),X(i,2),'sqk','MarkerFaceColor','k');
            fp = fp + 1;       % False positive
        elseif d(i) <= test && y(i) <= test
            plot(X(i,1),X(i,2),'ok','MarkerFaceColor','c');
            tp = tp + 1;       % True positive 
        elseif d(i) <= test && y(i) > test
            plot(X(i,1),X(i,2),'ok','MarkerFaceColor','k');
            fn = fn + 1;        % False negative
        end
    end
   
elseif dimension == 3         % Three-dimensional data
    for i = 1:r
        if d(i) > test && y(i) > test
            plot3(X(i,1),X(i,2),X(i,3),'sqk','MarkerFaceColor','b','LineWidth',1);
            tn = tn + 1;        %True negative 
        elseif d(i) > test && y(i) <= test
            plot3(X(i,1),X(i,2),X(i,3),'sqk','MarkerFaceColor','k');
            fp = fp + 1;       % False positive
         elseif d(i) <= test && y(i) <= test
            plot3(X(i,1),X(i,2),X(i,3),'ok','MarkerFaceColor','r');
             tp = tp + 1;       % True positive 
        elseif d(i) <= test && y(i) > test
            plot3(X(i,1),X(i,2),X(i,3),'ok','MarkerFaceColor','k');
            fn = fn + 1;        % False negative
        end
    end
    grid on; view(3);
end
specificity = (tn/(tn+fp))*100;
sensitivity = (tp/(tp+fn))*100;
xlabel('x_1','FontSize',14); ylabel('x_2','FontSize',14);

 