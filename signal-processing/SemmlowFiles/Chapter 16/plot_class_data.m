function plot_class_data(X,Y)
% Function to display class data
% Will be expanded to include boundries and FP & FN
%
hold on;
npts = length(Y);           % Determine data size
[r,c] = size(X);
if r < c
    X = X';                 % Arrange X 
end
for i = 1:npts
    if Y(i) > 0
        plot(X(i,1), X(i,2),'ob','MarkerFaceColor','r');
    else 
         plot(X(i,1), X(i,2),'ob','MarkerFaceColor','b');
    end
end
xlabel('X1'); ylabel('X2');