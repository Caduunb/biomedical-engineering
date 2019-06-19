% Example 10.2 Plot the first 50 generations predicted by Eq. 10.2 using
% four values of r: 1.25 2.75 3.2 3.6.  Start with an initial population,
% x0, of 0.02.
%
clear all; close all;
x(1) = 0.02;         % Initial population value
r1 = [1.25 2.75 3.2 3.6]; % Values of driving parameter
for k = 1:length(r1)
    r = r1(k);       % Set driving parameter
    for n = 1:50
        x(n+1) = r*x(n)*(1 - x(n)); % Logistic equation
    end
    subplot(2,2,k);     % Select subplot
    plot(x,'k');        %  and plot
    title(['r = ',num2str(r)],'FontSize',14);
    xlabel('n','FontSize',14);
    ylabel('x(n)','FontSize',14);
    xlim([1 50]);
end