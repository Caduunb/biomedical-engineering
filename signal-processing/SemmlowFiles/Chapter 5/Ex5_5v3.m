%  Example 5.5  and Figure 5.8
%  Program to demonstrate the use of the scree plot to 
%   determine the number of components.
%  Constructs 1, 2, 4 sinusoids in noise and evaluates 
%    the scree plot for each. 
clear all; close all;
N = 1200;                           % Size of arrays
x(1,:) = sig_noise(100,-12,N);
x(2,:) = sig_noise([100 200],-12,N);
x(3,:) = sig_noise([100 200 300],-12,N);
x(4,:) = sig_noise([100 200 300 400],-12,N);
for k = 1:4
     [X, Rxx] = corrmtx(x(k,:),20);            % Const. autocorr matrix
     [U,D,V] = svd(Rxx,0);              % Get singular values
	 eigen = diag(D);                   %  and extract eigenvalues
     subplot(2,2,k);                % Select subplot
       plot(eigen,'k');		    % Plot eigenvalues and label 
     xlabel('Component Number','FontSize',12);  ylabel('Eigenvalue','FontSize',12);
     title([num2str(k),' sinusoids'],'FontSize', 12); 
     xlim([0 20]);
end
