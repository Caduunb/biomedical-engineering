close all; clear variables; clc;

load('data_llm.mat');

fs = 1/T; %sampling frequency [Hz]
lgth = length(y);

%Impulse response parameters
M = p; %system memory [no. of samples]
th = (0:M-1)'/fs; %time vector of impulse response [sec]
alpha = genAlphacoef(10,M,5e-3); %damping coefficients of basis functions


%% Estimate the impulse response: 1-input linear model

IN.signal = u;
  IN.nbf    = [1,6];
  IN.ndelay = [0,5]; %[no. of samples]
  IN.M      = M;
  IN.alpha  = alpha;
[ypred,nmse,kernel,model] = stationaryLinear_1in1out(y,IN);
h = kernel{1}/T; %scale estimated impulse response by sampling period


%% Compare results

%Plot estimated impulse response
figure; hold on;
  plot(th,htrue,'Color',[0.5,0.5,0.5],'LineWidth',2);
  plot(th,h,'k','LineWidth',0.5);
  legend('True','Estimated'); box on;
  xlabel('Time (sec)'); ylabel('Impulse Response');

%Plot data vs. prediction
figure; hold on;
plot(t,y,'Color',[0.5,0.5,0.5],'LineWidth',2);
plot(t,ypred,'k','LineWidth',0.5);
legend('True','Prediction'); box on;
xlabel('Time (sec)'); ylabel('Data and prediction');


function varargout = stationaryLinear_1in1out(varargin)

% [ypred,nmse,kernel,model,allmdl] = stationaryLinear_1in1out(out,in)
%
% stationaryLinear_1in1out returns the optimal impulse response determined
% by the basis function expansion technique. Use Laguerre functions as the 
% basis functions. Optimization of model parameters uses minimum 
% description length criteria.
% Model: y = h1*x1 (* denotes convolution in this case)
%
% Input arguments: [out,in]
% out = output signal of the system
% in  = input struct
%   .signal = input signal
%   .nbf = range of model order (no. of basis functions) [from, to] e.g.
%          range for x1 = [3,5] then .nbf = [3,5]
%   .ndelay = range of delays [from to] in no. of samples.
%             Positive ndelay means output LAGS input by ndelay samples.
%             Negative ndelay means output LEADS input by ndelay samples.
%             e.g. range for x1 = [-2,2] then .ndelay = [-2,2]
%   .M = system length = memory length = length of kernel [no. of samples]
%        e.g. M of x1 = 50 then .M = 50
%   .alpha = matrix of damping coefficients for Laguerre functions,
%            determine how fast BF decays 
%            e.g. alpha1 for x1 then .alpha = alpha
%
% Output arguments: [ypred,nmse,kernel,model,allmdl]
% ypred = predicted output
% nmse = normalized mean squared error of output prediction
% kernel = impulse response
% model = model-related parameters
%   .bf = optimal sets of basis functions
%   .ndelay = optimal delay [no. of samples]
%   .c = expansion coefficients
% allmdl = all combinations of model parameters and corresponding MDL


%% Check input and output arguments

[y,in1,flagRow] = checkFunccall(varargin,nargout);
if isempty(y)
    error('Incorrect function call. Check input and/or output arguments.');
end

lgth  = length(y); %length of signal [samples]
delay1 = (in1.ndelay(1):in1.ndelay(2)); %delays [no. of samples]

%% Generate BFs for all possible model orders

bf1 = cell(in1.nbf(2));
for m=in1.nbf(1):in1.nbf(2) %model order
    %Generate BFs based on specified parameters:
    %1. model order, m
    %2. damping coefficient, alpha
    %3. system length or memory, M
     bf1{m} = laguer(m, in1.alpha(m), in1.M);
end %end for m
clear m;


%% Generate Vxfor all possible combinations of model parameters
%  where Vx = the convolution of BFs with the input

Vx1 = cell(in1.nbf(2), length(delay1));
for d=1:length(delay1) %delay
    
    %Adjust input signal with different delays
    xx = zeros(1,lgth);
    if delay1(d) > 0 %output LAGS input
        xx(1+delay1(d):lgth) = in1.signal(1:lgth-delay1(d));
    else %output LEADS input
        xx(1:lgth+delay1(d)) = in1.signal(1-delay1(d):lgth);
    end
    
    for m=in1.nbf(1):in1.nbf(2) %model order
        vv = zeros(length(xx),m);
        for k=1:m
            vv(:,k) = filter(bf1{m}(:,k),1,xx); %convolve each BF (from current set of BF) with input
        end
        
        %Exclude the first M points because convolution doesn't use the full length of BFs
        if lgth>(3*in1.M)
            Vx1{m,d} = vv(in1.M+1:lgth,:); %get rid of the first M points because convolution doesn't use the full length of BFs
        else
            Vx1{m,d} = vv; %use all the points due to short data length
        end

        clear vv;
    end %end for m
    clear xx;
end %end for d
clear d m k;

%Update data length and output lgth
if lgth>3*in1.M
    y = y(in1.M+1:lgth);
    lgth = lgth - in1.M;
end


%% Optimization process

allmdl = zeros(1e6,3); %m1, d1, mdl
counter = 0;

for m1=in1.nbf(1):in1.nbf(2)
for d1=1:length(delay1)
    
    counter = counter + 1;
	  
    %Input kernel
    vv = Vx1{m1,d1}'; %input1 kernel (for model order = m1 and delay = delay1(d1))

    %Estimate expansion coefficients using least-squares method
    c = y*pinv(vv); %estimated coefficients of BFs
    
    %Prediction and NMSE
    ypred = c*vv;            %predicted output
    err   = y - ypred;       %estimation error
    nmse  = var(err)/var(y); %normalized mean squared error
    
    %Minimum Description Length
    %MDL = log(NMSE) + (no. of estimated coefficients)*log(signal length)/(signal length)
    %where NMSE = var(error)/var(output)
    mdl = log(nmse) + m1*log(lgth)/lgth;
    
    %Collect model parameters and MDL
    allmdl(counter,1) = m1;
    allmdl(counter,2) = d1;
    allmdl(counter,3) = mdl;

end %end for d1
end %end for m1

%Get rid of extra rows in allMDL
allmdl = allmdl(1:counter,:);


%% Optimization: lowest MDL

%Find optimal combination (lowest MDL)
[junk,ii] = min(allmdl(:,size(allmdl,2)));

%Optimal model parameters
m1 = allmdl(ii,1);
d1 = allmdl(ii,2);

clear junk ii;


%% Generate output

%BFs
mm1 = bf1{m1};

%Optimal delay [no. of samples]
ndelay1 = delay1(d1);

%Convolution of optimal sets of BFs with inputs
vv = Vx1{m1, d1}';

%Coefficients
c = y*pinv(vv);

%Impulse responses
h1 = c*mm1';
if ~flagRow
    h1 = h1(:);
end
kernel = {h1};

%Predicted output
ypred = c*vv;
if ~flagRow
    ypred = ypred(:);
end

%Normalized mean squared error
err  = ypred(:) - y(:);
nmse = var(err)/var(y);

%Collect model-related outputs
model.bf     = {mm1};
model.ndelay = ndelay1;
model.c      = {c};


%% Function outputs: [ypred,nmse,kernel,model,allmdl]

varargout{1} = ypred;
varargout{2} = nmse;
varargout{3} = kernel;
varargout{4} = model;
varargout{5} = allmdl;

end %end for stationaryLinear_1in1out(varargin)


function b = laguer(m,alpha,M)

%laguer returns a set of Laguerre basis functions based on the selected
%model order (m) and system length (M).
%Implementation of Laguerre functions is based on Jo et al., Ann Biomed Eng
%2007 - eq. 4.
%
%Input arguments:
% m = model order = no. of basis functions to be used
%     e.g. if m = 4 then order goes from 0 to 3 i.e. has 4 functions total
% alpha = damping coefficient (0 < alpha < 1) = exponential decline of the 
%         Laguerre functions
% M = system length (memory)

b = zeros(M,m);
t = (1:M)';
b(:,1) = sqrt(alpha.^t*(1-alpha)); %b0
for mm=2:m
    b(1,mm) = sqrt(alpha)*b(1,mm-1); %initial value
    for t=2:M
        b(t,mm) = sqrt(alpha)*b(t-1,mm) + sqrt(alpha)*b(t,mm-1) - b(t-1,mm-1);  
    end
end %end for mm

%Flip sign at every odd order (1,3,5,...)
%(See Jo et al., Ann. Biomed. Eng. 2007 - eq. 3)
ii = (2:2:2*floor(m/2));
b(:,ii) = -b(:,ii);

end % end for laguer(m,alpha,M)

function alpha = genAlphacoef(mMax, M, tolerance)

% function genAlphacoef generates a matrix of the damping coefficients of
% the Laguerre basis functions such that the basis functions decay to zero
% after M samples.
%
% Input arguments:
% M = system memory [no. of samples]
% mMax = maximum model order (no. of Laguerre basis functions)
% tolerance = value that all LBFs need to decay to

alpha = zeros(mMax,1);
a0 = 0.99; %initial value of p
for m=1:mMax

    for a=a0:-0.001:0.01
        b = laguer(m, a, M);
        maxend = max(abs(b(M,:)));
        
        if maxend<tolerance %last points in MBF are lower than tolerance
            alpha(m) = a;
            break
        end
    end %end for pp
    a0 = alpha(m); %new initial value of alpha
    
end %end for m
end %end for genAlphacoef(mMax, M, tolerance)

function [y,in,flagRow] = checkFunccall(varin,nvarout)

%Check if trying to call old function
if length(varin)>3 || nvarout>5
    warndlg({'Input and output arguments of "stationaryLinear_1in1out" function were modified (1/15/2016).';...
             'Please update the function call.'},...
            'Check input and output arguments');
    y = [];
    in = [];
    flagRow = [];
    return
end

%Split input arguments
y  = varin{1};
in = varin{2};

%Output
flagRow = 1;
if size(y,1) > size(y,2)
    %Output is a column vector
    flagRow = 0;
    y = y'; %transpose out into a row vector
end
lgth = size(y,2); %length of signal [no. of samples]

%Input
x = in.signal;
if size(x,1) > size(x,2) %Each input is a column vector
    x = x'; %transpose x into a row vector
end
nx = size(x,1); %number of inputs
if nx~=1
    error('Incorrect number of input signals (requires 1 input signal).');
end

%Check input length
if lgth<size(x,2)
    %Output length is shorter than input length --> trim input at the end
    x = x(:,1:lgth);
elseif lgth>size(x,2)
    %Output length is longer than input length --> trim output at the end
    lgth = size(x,2);
    y = y(1:lgth);
end

%Check model parameters for inputs
if size(in.nbf,1)~=nx || size(in.ndelay,1)~=nx
    error('Parameters in input struct are not correctly entered.');
end

%Update signal in input struct
in.signal = x;

end % end for checkFunccall(varin,nvarout)
