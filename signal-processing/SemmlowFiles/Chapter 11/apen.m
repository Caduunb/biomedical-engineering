function Ap=apen(x,tau,m,r)
% Ap = apen(x,tau,m,r)
% Function to determine the Approximate entropy of a signa;
% x: Signal to be evaluated
% tau: delay for embedding
% m:   embedding dimension (in this case length of comparison template)
% r:   radius cutoff for nearest neighbors
N = length(x);
y1 = delay_emb(x,m,tau);  % Delay in dimension m
y2 = delay_emb(x,m+1,tau); % Delay in dimension m + 1

Bn=zeros(1,N-m+1);
An=zeros(1,N-m);
for n=1:N-m
   % Get the number of nearest neighbors (same as in Lyapunov and
   % GPA, Chapter 10)
   vec1=repmat(y1(n,:),length(y1(:,1)),1);  % Create array for subtraction
   dist1=sqrt(sum((y1-vec1).^2,2)); % Get the Euclidean distance
   numc1=r>dist1;                   % Perform the distance test
   Bn(n)=sum(numc1);          % Count the neighbors (Eq. 11.10

   % Repeat for m = m + 1;
   vec2=repmat(y2(n,:),length(y2(:,1)),1);
   dist2=sqrt(sum((y2-vec2).^2,2));
   numc2=r>dist2;
   An(n)=sum(numc2);          % Count the neighbors (Eq. 11.11
end
% Get one more sample for rcount1 
n = n + 1;
vec1=repmat(y1(n,:),length(y1(:,1)),1);  
dist1=sqrt(sum((y1-vec1).^2,2)); 
numc1=r>dist1;                   
Bn(n)=sum(numc1);          
Ap=-(sum(log(An))/(N-m)-sum(log(Bn))/(N-m+1));           % Entropy is determined via Eq. 11.12

