function cluster_boundaries(X,d,Proto)
% Evauates clusters defined by Proto
[r,c] = size(X);        % Determine number of input patterns
[r1,c1] = size(Proto);
resolution = 100;    %Number of evaluated net output points per dimension
correct = 0; incorrect = 0;         % Initialize counters
%figure; clf; 
hold on;
marker_type = ['sk'; 'ok'; 'dr'; 'vk'; '^k'];
if max(max(d)) > 1
    marker_color = ['m'; 'c'; 'b'; 'r'; 'c'];  % More colerful makers
else 
    marker_color = ['m'; 'c'; 'b'; 'r'; 'y'];
end
 for i = 1:r
    for i1 = 1:r1
         distance(i1) = norm(Proto(i1,1:2)-X(i,:));
    end
    [~,i_close] = min(distance);
    y(i) = Proto(i_close,3);
end
%  Plots results
for i = 1:r
    if y(i) == d(i)
        plot(X(i,1),X(i,2),marker_type(d(i)+1,:),'MarkerFaceColor',marker_color(d(i)+1,:));
        correct = correct + 1;
    else
        plot(X(i,1),X(i,2), marker_type(d(i)+1,:),'MarkerFaceColor','k');
        incorrect = incorrect + 1;
    end
end
% Determine range for boundary plot
x1_max = max([max(X(:,1)), max(Proto(:,1))]);   
x1_min = min([min(X(:,1)), min(Proto(:,1))]);
x2_max = max([max(X(:,2)), max(Proto(:,2))]);
x2_min = min([min(X(:,2)), min(Proto(:,2))]);
x1_incr = (x1_max - x1_min)/resolution; 
x2_incr = (x2_max - x2_min)/resolution;
i = 0; 
% Now evaluate and plot the boundaries using an exhaustive search
for x1 = x1_min:x1_incr:x1_max
    i = i + 1;
    j = 0;
    x1_axis(i) = x1;
    for x2 = x2_min:x2_incr:x2_max
        j = j + 1;
        x2_axis(j) = x2;
        for i1 = 1:r1
            distance(i1) = sqrt((Proto(i1,1)-x1)^2 + (Proto(i1,2)-x2)^2);
        end
        [~,i_close] = min(distance);
        y1(i,j) = Proto(i_close,3);
        %plot(x1,x2,'.','MarkerFaceColor',marker_color(Proto(i_close,3)+1));
    end
end
contour(x1_axis,x2_axis,y1');
map = [0 1 0; .5 .5 .5; 0 0 1; 1 0 0];
colormap(map); 
xlabel('x_1','FontSize',14); ylabel('x_2','FontSize',14);
%
%  Draw cluster centers
for i = 1:r1
    plot(Proto(i,1),Proto(i,2),marker_type(Proto(i,3)+1),'MarkerFaceColor',marker_color(Proto(i,3)+1),'MarkerSize',12,'LineWidth',2);
    plot(Proto(i,1),Proto(i,2),'xk','MarkerSize',12,'LineWidth',2);
end