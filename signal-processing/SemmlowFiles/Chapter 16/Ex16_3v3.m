% Example 16.3 Construction of an ROC curve using the
%   least squares linear classifier.
%  
clear all; close all;
distance = 2;       % Distance between distribution centers
[X,d] = gen_data2(distance);  % Generate data
[r,c] = size(X);
X = [X,ones(r,1)];          % To account for bias
w = inv(X'*X)*(X'*d');      % Train on small training set
for k = 1:18
    threshold(k) = .05*k;   % Set threshold between ,05 and .9
    figure;
    [sensitivity(k), specificity(k)] = linear_eval(X,d,w,threshold(k));  
    title(['Threshold: ',num2str(threshold(k),2)]);
end
figure;				% Plot ROC curve
plot(100-specificity, sensitivity,'k','LineWidth',2);
for k = 1:2:18			% Put threshold value on ROC curve
    text(100-specificity(k),sensitivity(k),num2str(threshold(k),2));
end
xlabel('100% - Specificity','FontSize',14); ylabel('Sensitivity','FontSize',14);
axis([ 0 100 0 100]);


