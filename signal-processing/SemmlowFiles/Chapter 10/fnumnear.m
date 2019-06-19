function [numnear]=fnumnear(x,tau,em,r)
% Usage:  numnear = fnumnear(x,tau,em,r)
% fnumnear computes the average fraction of neighbors in dimension m that are determined to be false. 
%        x:  The input vector
%        tau: The delay used for embedding
%        em:  The maximum number of embedding dimensions to test
%        r:   The cutoff value for the ratio of distances between neighbors
%        in one dimension and the dimension below it.
           sigma = std(x);     
for m = 1:em 
    y = delay_emb(x,m,tau);  %perform embedding
    N2=length(y(:,1));   %get size of embedded vectors
    numfalse = [];
        for i=1:N2-tau   %to N-tau because the embedding at m+1 will have
                         %tau fewer samples
            vec=repmat(y(i,:),N2,1);   %create vectors for subtracting
            dist=sqrt(sum((y-vec).^2,2));  %find the distance of test point
                          %to every other point
            testsr = (dist < sigma/r);
                                           
            y2 = delay_emb(x,m+1,tau);    %get higher dimension embedding
            vec2=repmat(y2(i,:),N2-tau,1); %get new distances
            dist2=sqrt(sum((y2-vec2).^2,2));
           dist(i) = [];
           dist2(i) = [];
           testsr(i) = [];
           numfalse(i)=sum((dist2./dist(1:length(dist2)) > r).*testsr(1:length(dist2)))./sum(testsr(1:length(dist2)));
          
        end
    numnear(m) = mean(numfalse);                 %save mean number of false
end


    