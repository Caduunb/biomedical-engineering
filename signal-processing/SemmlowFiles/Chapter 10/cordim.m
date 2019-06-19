function [CR,CR_stat]=cordim(x,tau,m,R)
% Usage :  CR = cordim(x,tau,m,R)
% x is a single dimension time series
% tau is the delay for delay embedding
% m is the embedding dimension
% R is the radii used for evaluating the correlation integral
% For example, for the Lorenz system, an appropriate 
% R is R=10.^(linspace(-1,1,50))

[rows,cols]= size(x);
if min([rows,cols]) > 1
	y = x;
else

	% Perform delay embedding and determine the length of the delay vectors
	y = delay_emb(x,m,tau); % Use delay_emb to get the embedded vector
end

N=length(y(:,1));       % Get the total length of the embedded vector

rcount_stat = zeros(N-1,1);
%nearest neighbors are found, as in the Lyapunov exponent 
CR=zeros(1,length(R)); % CR is a vector that will eventually hold the 		               % correlation sum
for jj=1:length(R)     % For each radius value get number of nearest neighbors
    numc=0;            % Initialize the count to 0 
    rcount=0;          % Initialize through the rcount to zero
    for k=1:(N-1); % For number of points get nearest neighbors
        vec=repmat(y(k,:),N,1); 
        dist=sqrt(sum((y-vec).^2,2));
        dist(1:k) = [];
        numc=dist<R(jj);
        
        %count nearest neighbors
        rcount=sum(numc)+rcount; % Compute number of nearest neighbors
        rcount_stat(k) = sum(numc);
        dist=[];                   % Clear dist
    end
    CR(jj)=rcount;                  % Get counts as function of radius
end

                      % Set 0 values to 1
CR=2*CR/(N*(N-1));                % Get average count using Eq 10.21
