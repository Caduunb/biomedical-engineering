function [mse, correct, incorrect, confusion] = cluster_eval(X,d,Proto);
% Evauates clusters defined by Proto
[r,~] = size(X);        % Determine number of input patterns
[r1,~] = size(Proto);
nu_classes = max(d) + 1;
correct = 0; incorrect = 0;     % Zero counters
for i = 1:r
    for i1 = 1:r1               % Find closest prototype center
         distance(i1) = norm(Proto(i1,1:2)-X(i,:));
    end
    [~,i_close] = min(distance);
    y(i) = Proto(i_close,3);    % Predicted class
end
mse = mean((y-d).^2);       
%  Plots for results
clf; hold on;
marker_type = ['ok'; 'sk'; 'dk'; 'vk'; '^k'];
 marker_color = ['m'; 'c'; 'b'; 'r'; 'y'];
 confusion = zeros(nu_classes);
for i = 1:r    % Count correct and incorrect, build confusion and plot
    if y(i) == d(i)
        plot(X(i,1),X(i,2),marker_type(d(i)+1,:),'MarkerFaceColor',marker_color(d(i)+1,:));
        confusion(d(i)+1,d(i)+1) = confusion(d(i)+1,d(i)+1) + 1;
        correct = correct + 1;
    else
        plot(X(i,1),X(i,2), marker_type(d(i)+1,:),'MarkerFaceColor','k');
        confusion(d(i)+1,y(i)+1) = confusion(d(i)+1,y(i)+1) + 1;
        incorrect = incorrect + 1;
    end
end
%  Draw cluster centers
for i = 1:r1
    plot(Proto(i,1),Proto(i,2),'ok','MarkerFaceColor',marker_color(Proto(i,3)+1),'MarkerSize',10);
    plot(Proto(i,1),Proto(i,2),'xk','MarkerSize',10,'LineWidth',2);
end
        