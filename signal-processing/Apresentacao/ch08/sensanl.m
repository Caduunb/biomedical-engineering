% Program "sensanl_rlc.m" to perform sensitivity analysis for RLC model, given parameters
%  Plots changes in criterion function J +/-50% about nominal/reference value
%        of each parameter

global t u  ypred  y

ians=input('Is the input vector u and time vector t in the workspace? No=1, Yes=1 >>');
if ians==0
   break;
end;

pararef=zeros(2,1);

pararef(1)=input('   Enter nominal/reference value for R >>');
pararef(2)=input('   Enter nominal/reference value for L >>');
pararef(3)=input('   Enter nominal/reference value for C >>');
Np = 3;
% Compute model predictions for nominal parameter values
Jref=fn_rlc(pararef); % replace this with different function in another application
yref = ypred;

para=zeros(size(pararef));
% Perform sensitivity calculations
step=5; % step-size between each computation = 5%
num_steps=2*(50/step)+1;
J=zeros(num_steps,Np);
para_change=[-50:step:50]';
for i=1:Np,
   for k=1:num_steps,
      para=pararef;
      para(i)=pararef(i)*(1 + para_change(k)/100);
      if para_change(k)==0,
         J(k,i)=0;
      else
         Jpred=fn_rlc(para); % replace this with different function in another application
         e = ypred - yref; 
         J(k,i)=sum(e.^2);
      end;
    end;
end;

for i=1:Np,
   plot(para_change,J(:,i));
   hold on;
end;
hold off;
