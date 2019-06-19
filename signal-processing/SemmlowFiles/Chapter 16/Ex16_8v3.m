% Example 16.8  Example of using the Support Vector Machine software
% on a data set with four classes.  
%
clear all; close all;
global p1;
p1 = 2;                     % Kernel order
ker = 'poly';               % Kernel type
[Xt,Dt] = gen_data4(2.75,[-1 1],200);  % Generate training set
figure;
for i = 1:3
    d = Dt(:,i);            % Select appropriate correct class 
    [nsv,alpha,b] = svc(Xt,d,ker);  % Generate classifier
    svcplot4(Xt,d,ker,alpha,b,i);   % Evaluate classifier and plot 
end
for k = 1:200               % Plot remaining data points
    if Dt(k,4) == 1
        plot(Xt(k,1),Xt(k,2),'kv','MarkerFaceColor','m','LineWidth',2);
    end
end
xlabel('x_1','FontSize',14); ylabel('x_2','FontSize',14);



