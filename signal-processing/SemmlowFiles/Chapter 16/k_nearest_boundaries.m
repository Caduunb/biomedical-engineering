function k_nearest_boundaries(X,K,Xt,dt);
% Determines boundaries over a grid and plots
%
[r,c] = size(X);         % Size of test set
[rt,c] = size(Xt);       % Size of training set
resolution = 100;    %Number of evaluated net output points per dimension
 hold on;
marker_type = ['sk'; 'ok'; 'dk'; 'vk'; '^k'];
if max(max(dt)) > 1
    marker_color = ['g'; 'y'; 'b'; 'r'; 'c'];  % More colerful makers
else 
    marker_color = ['m'; 'c'; 'b'; 'r'; 'y'];
end
 
% %  Plots results
% for i = 1:r
%     if y(i) == d(i)
%         plot(X(i,1),X(i,2),marker_type(d(i)+1,:),'MarkerFaceColor',marker_color(d(i)+1,:));
%         correct = correct + 1;
%     else
%         plot(X(i,1),X(i,2), marker_type(d(i)+1,:),'MarkerFaceColor','k');
%         incorrect = incorrect + 1;
%     end
% end
% Determine range for boundary plot
x1_max = max(max(X(:,1)));   
x1_min = min(min(X(:,1)));
x2_max = max(max(X(:,2)));
x2_min = min(min(X(:,2)));
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
        for i1 = 1:rt         % Find nearest K points 
            Distance(i1,1) = norm([x1,x2] - Xt(i1,:));
            Distance(i1,2) = dt(i1);      % Save Xi class
        end
        Distance = sortrows(Distance,1); % First row assending
        majority = mean(Distance(1:K,2));  % Distance to K closest pts
        y1(i,j) = round(majority);     % Assign class
    end
end
contour(x1_axis,x2_axis,y1');
map = [0 1 0; .5 .5 .5; 0 0 1; 1 0 0];
colormap(map); 
%xlabel('x_1','FontSize',14); ylabel('x_2','FontSize',14);
