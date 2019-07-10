function J=fn_gmm(p)
%  Function "fn_gmm.m" computes the sum of squares of the
%    residuals between the observed glucose concn (x) and
%    the glucose concn (xpred) predicted by the Bergman
%     glucose-insulin minimal model

global t x u z xpred Nresamp N

num=[p(3)]; den=[1  p(2)];
Hs = tf(num,den);
z = lsim(Hs,u,t);

xhat=zeros(Nresamp,1);
xhat(1)=p(5)*x(1);
for i=2:Nresamp
   dxdt = p(4) - (p(1)+z(i-1))*xhat(i-1);
   xhat(i)=xhat(i-1) + dxdt*0.01;
end;

xpred=xhat(1:100:Nresamp);    
e = x(5:N) - xpred(5:N); %compute criterion function starting from minute #4 only
J = sum(e.^2)/length(e); 