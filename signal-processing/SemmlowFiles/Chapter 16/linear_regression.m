% Example of the Linear LS alogrithm
%
% Set up data
clear all; close all;
test = .5;         % Boundary
angle = 45;      %Angle between distributions in deg.
distance = input('Seperation between distribution: ')
[X, d] = gen_data2(distance, angle,'l',[0 1]);  %Generate data
[r,c] = size(X);
X = [ones(r,1), X]; %Add column of ones to account for bias
beta = inv((X'*X))*X'*d';
y = X*beta;
hold on;
correct = 0; incorrect = 0;
for i = 1:r
    if d(i) > test & y(i) > test
        plot(X(i,2),X(i,3),'sqk','MarkerFaceColor','b');
        correct = correct + 1;
    elseif d(i) > test & y(i) <= test
        plot(X(i,2),X(i,3),'sqk','MarkerFaceColor','r');
         incorrect = incorrect + 1;
    elseif d(i) <=test & y(i) <= test
        plot(X(i,2),X(i,3),'ok','MarkerFaceColor','b');
         correct = correct + 1;
    elseif d(i) <= test & y(i) > test
        plot(X(i,2),X(i,3),'ok','MarkerFaceColor','r');
         incorrect = incorrect + 1;
    end
end
x = (min(X(:,1)) max(X(:,1)));
 y1 = beta(2)*x/beta(3) -beta(1))/beta(2);
 plot(x,y1,'k');