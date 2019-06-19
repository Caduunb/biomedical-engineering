% Example 9,4 Apply the Jade ICA algorithm to the matrix of mixed signals,
% X, in file mix_sig.mat.
%
% Use this in PCA and ICA Analysis
% 
% Assign constants
clear all; close all;
load mix_sig.mat;       % Get data
N = 1000;	% Number points (2 sec of data)
fs = 500;	% Sample frequency
t = (1:N)/fs;               % Time vector
%
% Do PCA  and plot Eigenvalues
[U,S,pc]= svd(X,'econ');
eigen = diag(S).^2;
for i = 1:5   
   pc(:,i) = pc(:,i) * sqrt(eigen(i));
end
plot(eigen,'k');
xlabel('N','FontSize',14);
ylabel('Eigenvalue','FontSize',14);
title('Scree Plot','FontSize',14);
%
total_eigen = sum(eigen);
for i = 1:5
   pct(i) = 100 * sum(eigen(i:5))/total_eigen;
end 
disp(pct)
figure;		% Now plot Scatter Plot of first two PC's
subplot(1,2,1);
plot(pc(:,1),pc(:,2),'xk');
hold on;
plot([0 0],[-2.5 2.5],'k');	% Plot axis
plot([-2 2],[0 0],'k');
xlabel('\it{X1}','FontSize',14);
ylabel('\it{X2}','FontSize',14);
axis([-2 2 -2.5 2.5]);
title('Scatter Plot PCs','FontSize',14)
nu_ICA = input('Enter the number of independent components');
%
% Compute ICA 
W = jadeR(X,nu_ICA);	% Determine the first 3 IC's
ic = W*X;
subplot(1,2,2);
hold on;
plot(ic(1,:),ic(2,:),'xk');
plot([0 0],[-2.5 2.5],'k');	% Plot axis
plot([-2 2],[0 0],'k');
title('Scatter Plot Independent Components','FontSize',14)
xlabel('IC_1','FontSize',14);
ylabel('IC_2','FontSize',14);
axis([-2 2 -2.5 2.5]);
%
figure; hold on;		% Plot Independent Components
for k = 1:nu_ICA
   plot(t,ic(k,:)+4*(k-1),'k');
end   
xlabel('Time (sec)','FontSize',14);
ylabel ('x(t)','FontSize',14);
title('Independent Components','FontSize',14);



