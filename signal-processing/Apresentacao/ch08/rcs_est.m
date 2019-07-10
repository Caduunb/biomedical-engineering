%  Matlab Script File "rcs_est.m" for closed-loop estimation of the 
%    Respiratory Control System, using measurements made during administration
%    of a pseudorandom binary sequence (PRBS) of inhaled PCO2
%  A breath-number time-base is assumed (ie. sampling interval, T = 1)
%  See Section 8.5.2 for details of the methodology

% Load data
fname_ascii=input('Enter data filename >>  ','s');
if length(fname_ascii)>0
   load(fname_ascii);
   N=length(PACO2);
end;
fname_array=abs(fname_ascii);

% Detrend data
DPACO2 = detrend(PACO2);
DPICO2 = detrend(PICO2);
DVe = detrend(Ve);

% Identification of Plant parameters

thetap = zeros(3,1);  % initialize parameter vector
%    Form matrix of observations ("U") 
U = [ [0 -DPACO2(1:N-1)']'  DPICO2  -DVe ];
UprimeU = U'*U ;
thetap = UprimeU\U'*DPACO2 ;
alpha = thetap(1); beta1 = thetap(2); beta2 = thetap(3);
%  Deduce plant gains & time-constant from estimated discrete-time parameters
tauL = -1/log(-alpha) 
G1 = tauL*beta1
G2 = tauL*beta2

disp(' ');
disp(' Press <Enter> to continue with calculation >>');
pause;

% Identification of Controller Parameters

%   Impulse response of controller, including delay, is estimated for
%      delays ranging from 1 to 4 breaths -
%      the "optimal" impulse response is that which minimizes criterion function J
h = zeros(ceil(N/4),1); % initialize impulse response
J = zeros(4,1);
for Nd = 1:4 
    thetac = zeros(4,1);  % initialize parameter vector
    U = zeros(N,4); % initialize observation matrix
 %  Form observation matrix "U"
    z = zeros(1,Nd);   
    U = [ [0 -DVe(1:N-1)']'  [0 0 -DVe(1:N-2)']'  [z DPACO2(1:N-Nd)']' [0 z DPACO2(1:N-Nd-1)']'];
    UprimeU = U'*U ;
    thetac = UprimeU\U'*DVe;
    a1=thetac(1);a2=thetac(2);b0=thetac(3);b1=thetac(4);
    %  Determine quality of fit (ie. size of residuals and value of J)
    DVepred = zeros(size(DVe));
    for n=1:N
       if n>1
          DVepast=DVe(n-1);
       else
          DVepast=0;
       end;
       if n>2
          DVepast2 = DVe(n-2);
       else
          DVepast2 = 0;
       end;
       if n > Nd
          if n > Nd+1
             DVepred(n)=-a1*DVepast -a2*DVepast2 +b0*DPACO2(n-Nd) +b1*DPACO2(n-Nd-1);
          else
             DVepred(n)=-a1*DVepast-a2*DVepast2+b0*DPACO2(n-Nd);
          end;
       else
          DVepred(n)=DVe(n);
       end;
    end;
    J(Nd) = J(Nd) + (DVe(n)-DVepred(n))^2;
 end;
 
 [Jmin,Ndopt] = min(J); %Select model with minimum J
 
 % Compute unit impulse response of estimated controller 
 %   (note that this estimated impulse response incorporates the estimated delay)
 for n=1:N/4
       if n>1
          hpast=h(n-1);
       else
          hpast=0;
       end;
       if n>2
          hpast2 = h(n-2);
       else
          hpast2 = 0;
       end;
       if n > Nd
          if n==Nd+1
             h(n) = -a1*hpast -a2*hpast2 +b0;
          else
             if n==Nd+2
                h(n) = -a1*hpast -a2*hpast2 + b1;
             else
                h(n) = -a1*hpast -a2*hpast2;
             end;
          end;
       else
          h(n)=0;
       end;
 end;
 t=[0:1:length(h)-1]';
 plot(t,h);
 xlabel(' Time in # breaths');
 ylabel(' Controller Impulse response in L/min/mmHg');
 
 
 

