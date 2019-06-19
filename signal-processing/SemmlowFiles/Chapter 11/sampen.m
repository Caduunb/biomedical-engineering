function samp=sampen(x,tau,m,r)
% samp=sampen(x,tau,m,r)
% Function to compute the sample entropy
% x:  The signal to be evaluated
% tau: the embedding delay
% m: the embedding dimension
% r: the cutoff radius
N = length(x);  % Length of the signal
y1 = delay_emb(x,m,tau);   % Get embedding in m and m + 1 dimensions
y2 = delay_emb(x,m+1,tau);
[N1,~]=size(y1);           % Number of rows in each 
 N2 = N1 - 1;              % Embedded signal
An=zeros(1,N2);            % Initialize Ai and Bi
Bn=An;
   for n=1:N-m
        vec=repmat(y1(n,:),N1,1);
        dist=sqrt(sum((y1-vec).^2,2));
        numc=r>dist;
        Bn(n)=(sum(numc))-1; % Get number of neighbors but subtract for
                              % the self match
  
        vec2=repmat(y2(n,:),N2,1);
        dist2=sqrt(sum((y2-vec2).^2,2));
        numc2=r>dist2;
        An(n)=sum(numc2)-1;  % Repeat for m + 1 dimensions to get Ai
        
   end
   % Get one more sample for Bi
   n = n + 1;
   vec=repmat(y1(n,:),N1,1);
   dist=sqrt(sum((y1-vec).^2,2));
   numc=r>dist;
   Bn(n)=(sum(numc))-1;  
  
  B=sum(Bn)/(N-m+1);  % Eq. 11.13
  A=sum(An)/(N-m);    % Eq. 11.14
  samp=-log(A/B);     % Eq. 11.15
      