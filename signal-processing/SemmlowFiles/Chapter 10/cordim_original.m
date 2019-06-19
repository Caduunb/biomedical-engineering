function [CR,CR_stat]=cordim_original(y,R)
% Usage :  CR = cordim(x,tau,m,R)
% y is a multidimensional time series
% R is the radii used for evaluating the correlation integral
% For example, for the Lorenz system, an appropriate 
% R is R=10.^(linspace(-1,1,50))

[rows,cols]= size(y);
if rows < cols
	y = y';
end

N=length(y(:,1));       % Get the total length of the embedded vector

rcount_stat = zeros(length(y(:,1)),1);
%nearest neighbors are found, as in the Lyapunov exponent 
CR=zeros(1,length(R)); % CR is a vector that will eventually hold the 		               % correlation sum
for jj=1:length(R)     % For each radius value get number of nearest neighbors
    numc=0;            % Initialize the count to 0 
    rcount=0;          % Initialize through the rcount to zero
    for k=1:length(y(:,1)); % For number of points get nearest neighbors
        vec=repmat(y(k,:),length(y(1:end,1)),1); 
        dist=sqrt(sum((y(1:end,:)-vec).^2,2));
        dist(1:k) = [];
        numc=dist<R(jj);
        %count nearest neighbors
        rcount=sum(numc)+rcount; % Compute number of nearest neighbors
        rcount_stat(k) = sum(numc);
        dist=[];                   % Clear dist
    end
    CR(jj)=rcount;                  % Get counts as function of radius
end

CR(CR==0)=1;                       % Set 0 values to 1
CR=2*CR/(N*(N-1));                % Get average count using Eq 10.21
