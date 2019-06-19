% Example 9.2  and Figure 9.6, 9.7, and 9.8
% Example of PCA
%  Create a mixture using two differnt signals mixed five ways plus noise
% Use this in PCA  Analysis
% 
% Assign constants
clear all; close all;
N = 1000;	% Number points (2 sec of data)
fs = 500;	% Sample frequency
t = (1:N)/fs;
% Generate data
x = .75 *sin(10*pi*t);			% One component a sine
y = sawtooth(7*pi*t,0.5);		% One component a sawtooth
n = randn(1,N);				% Noise component				
% Combine data
X(1,:) = .5*y + .5*x + .1* rand(1,N);
X(2,:) = .2*y + .75*x +.15* rand(1,N);
X(3,:) = .7*y + .25*x + .1* rand(1,N);
X(4,:) = -.5*y + .4*x + .2* rand(1,N);
X(5,:) = .6* rand(1,N);   %Noise only
for i = 1:5		% Center data (i.e., remove means) 
   X(i,:) = X(i,:) - mean(X(i,:));
end   
for i = 1:5
     plot(t,X(i,:)+2*(i-1),'k');
      hold on;
end
xlabel('Time (sec)','FontSize',14)

ylabel('Mixed Components','FontSize',14);
figure;
[U,S,pc]= svd(X,'econ');
eigen = diag(S).^2;
for i = 1:5   
   pc(:,i) = pc(:,i) * sqrt(eigen(i));
end
eigen = eigen/N;
plot(eigen,'k');
xlabel('N','FontSize',14);
ylabel('Eigenvalues','FontSize',14);
title('Scree Plot','FontSize',14);
% Calculate Eigenvlaue ratio
total_eigen = sum(eigen);
for i = 1:5
   pct(i) = 100 * sum(eigen(i:5))/total_eigen;
end 
disp(pct)
% Print Scaled Eigenvalues and Covariance matrix of Principal components 
%	for comparison
%
S = cov(pc)	% Display covariance matrix
% Plot Principal Components and Original Data
figure;
subplot(1,2,1);
plot(t,pc(:,1)-2,'k',t,pc(:,2)+2,'k');	%Displace for clarity
xlabel('Time (sec)','FontSize',14)
ylabel('Principal Components','FontSize',14);
subplot(1,2,2);
plot(t,x-2,'k',t,y+2,'k');
xlabel('Time (sec)','FontSize',14);
ylabel('x(t) & y(t)','FontSize',14);
title('Original Components','FontSize',14);
