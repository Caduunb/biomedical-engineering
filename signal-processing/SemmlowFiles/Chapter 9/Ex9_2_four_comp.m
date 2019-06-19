% Problem 9_7 Load the data mix_sig3 which contains the data set in matrix X.   
% fs = 500 Hz.  
% 
% Assign constants
clear all; close all;
N = 1000;	% Number points (4 sec of data)
fs = 500;	% Sample frequency
w = (1:N) * 2*pi/fs;		% Normalized frequency vector 
t = (1:N);
%
% Generate data
s1 = .75 *sin(w*12) + .5*sin(w*8) + .07*randn(1,N);	% One component a double sin
s2 = sawtooth(w*5,.5)+ .05*randn(1,N);		% One component a sawtooth		
s3 = pulstran((0:999),(0:5)'*180,kaiser(100,3)) + .07*randn(1,N);	% Periodic function
s4 = sin(w*5) + .12*rand(1,N);
% Plot original signals
plot(t,s1-2,'k',t,s2,'k',t,s3+2,'k',t,s4+4,'k');
xlabel('Time (sec)');
ylabel('s(t)');
title('Original Components (Before mixing)');
%
% Combine data.  Define mixing matrix
A = [.5 .5 .5 .5; .2 .7 .7 .3; .7 .4 .2 -.5; -.5 .2 -.6 .3; .7 -.5 -.4 .4; .5 -.8 .4 -.7; -.3 .5 .7 -.6];
s = [s1; s2; s3; s4];	% Signal matrix
X = A * s;			% Generate mixed signal output
figure; hold on;
% Center data and plot mixed signals
for i = 1:7
   X(i,:) = X(i,:) - mean(X(i,:));
   plot(t,X(i,:)+2*(i-1),'k');
end
xlabel('Time (sec)');
ylabel ('X(t)');
title('Mixed Signals');
X = X';
save mix_sig3 X s;          % Save data
%
clear all;
fs = 500;
[r c] = size(X);
if r > c
    X = X';
    N = r;
else
    N = c;
end
% Do PCA  and plot Eigenvalues
figure;
[U,S,pc]= svd(X,0);
eigen = diag(S).^2;
plot(eigen,'k');
xlabel('N');
ylabel('Eigenvalue');
title('Scree Plot');
%
nu_ICA = input('Enter the number of independent components');
%
% Compute ICA 
W = jadeR(X,nu_ICA);	% Determine the first 3 IC's
ic = (W * X)';
subplot(1,2,2);
plot(ic(:,1),ic(:,2),'xk');
hold on;
plot([0 0],[-2.5 2.5],'k');	% Plot axis
plot([-2 2],[0 0],'k');
title('Scatter Plot Independent Components')
xlabel('IC 1');
ylabel('IC 2');
axis([-2 2 -2.5 2.5]);
%
figure;		% Plot Independent Components
for i = 1:nu_ICA
   plot(t,ic(:,i)+4*(i-1),'k');
   hold on
end   
xlabel('Time (sec)');
ylabel ('X(t)');
title('Independent Components');



