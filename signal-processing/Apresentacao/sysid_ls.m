% Program "sysid_ls.m" to deduce impulse response from input and 
%    noisy output data using least squares estimation
%    "Data" provided in file "data_llm.mat" was generated by simulating
%     the linear lung mechanics model (file "sss_llm.m") and then
%     adding Gaussian white noise to the output
%     The input, u, is a unit step beginning at time t=0;
%     the output, y, is the noisy response to the input step
%     Estimate of impulse response is contained in column vector h

% First,load "data_llm.mat" to enter input-output data into work space
%  For the sample data, T = 0.005 secs and p = 80
%   The "true" impulse response is also provided
load data_llm.mat

if T==0,  % if T is not given, user must provide value
   T = input (' Enter sampling interval, T >>');
end;
disp('  Length of dataset =');
N = min(length(y),length(u))
disp(' ');
if p==0,  % if p is not given, user must provide value
   p=input(' Enter length of system memory, p >>');
end;

% Construct observation matrix UU
UU = zeros(N,p);
for i=1:p,
   if i==1 
      UU(:,1)=u;
   else
      UU(:,i)= [zeros(i-1,1)' u(1:N-i+1)']';
   end
end;
UU = T*UU;

% Construct autocorrelation matrix
AA = UU'*UU;
b = UU'*y;

% Compute estimate of h and model predictions, yhat
h = AA\b;

% Compute estimated standard errors of h
e = y - UU*h;
sigma = std(e);
AAinv = inv(AA);
hse = zeros(size(h));
for i=1:p,
   hse(i) = sqrt(AAinv(i,i))*sigma ;
end;

% Plot input-output data and estimated h with error band 
%    as well as "true" impulse response (for this example)
t=[0:T:(N-1)*T]';
subplot(211); plot(t,u,'k.-',t,y,'k-');
title(' Input and Output Data');
subplot(212); plot(t(1:p),h,'k.-');
title(' Estimated h with error band and true h ');
hold on; plot(t(1:p),h+hse,'k--'); plot(t(1:p),h-hse,'k--');
plot(t(1:p),htrue,'k-'); hold off
