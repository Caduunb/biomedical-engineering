function [lambda,linear_end]=max_lyp(fx,m,tau,fs,radius)
% Function to compute the maximum lyapunov exponent using
% the method given by Kantz et al.
% fx is the data to be analyzed, m is the embedding dimension, 
% tau is the embedding delay, fs is the sample rate, and radius is an
% optional argument to determine the nearest neighbor search radius


count = 0;   % Initial count set to zero


Mx = delay_emb(fx,m,tau); % Perform delay embedding
[r,~] = size(Mx);         % Find number of rows and colums of Mx
time  = linspace(0,r/fs,r); % Create time vector

test_length = floor(.1*r); % Number of samples to examine for divergence

if nargin < 5
    radius =0.1*std(fx);% Radius is 100th of the mean distance from                           % the centroid
end
% Otherwise use the radius that is user inputted

% First loop, find the nearest neighbors of each point
% since we need at least test_length numbers of points
% only loop from 1 to (r-test_length)
N = r-test_length;           % Number of points in phase space used

S_n = zeros(test_length+1,1); % Initialize S_n to speed up code
countjj=0;                    % Initialize counter

for k = 1:N                  
    x_t = Mx(k,:);            % Get test point
    x_tvec = repmat(x_t,r,1);  % Use rep mat so test point can be performed 
                               % as a vector
  
    distance  = sqrt(sum((x_tvec-Mx).^2,2)); % Get distances using norm
    
    nearest_i = find(distance < radius);   % Get index of nearest neighbors
    nearest_i(nearest_i==k)=[];           % Removes test point    
    nearest_i= nearest_i(nearest_i < N); % Remove points in num near 
                                         % longer than test length would be
                                         
    nearest_i(abs(nearest_i-k) <= 10*tau) =[]; % Remove points too close in time
    num_near = length(nearest_i);
    trajectory1 = Mx(k:(test_length+k),:);  % Trajectory of test point
    
    % Second for loop: compute the divergence
    diverge = zeros(test_length+1,1);        % Initialize divergence
    if num_near~=0;               % Only do calculation if neighbor exists
        count = count + 1;        % Count number of nearest neighbors
        countjj = 0;
        for jj = 1:num_near       % For 1 to number of nearest neighbors
            jj_ind=nearest_i(jj); % Get starting point of NN trajectory
            countjj= countjj+1;   % Count neighbors
            trajectory2 = Mx(jj_ind:(test_length+jj_ind),:);  % Get neighbor
                                                              % trajectory
            dive = sqrt(sum( (trajectory1 - trajectory2).^2,2));   % Get
                                                             % divergence
            diverge = diverge + dive+eps;  % Running sum of divergences      
        end %jj
        diverge  = log(diverge/countjj);   % Get average divergence 
            
                                           
    end %end iff
    
    S_n = S_n + diverge;    % Get sum for computing second average 
  
end %% end ii



S_n = S_n/count;       % Get final divergence average
S_n = S_n-S_n(1);      % Divergence starts at 0, not needed but makes plot
                       % easier to read
%%   
% Find the flat region and determine the slope
% Works by finding the region where the slope changes from its initial
% value

if fs <= 1                 % Determine length of appropriate testing region
    lima=2*fs;             % 2 seconds of data of Fs is less than 1 Hz
else                       % 1 second of data otherwise
    lima=fs; 
end




y = S_n(1:lima);          % Construct time vectors for fitting
x = time(1:lima)';
m1=polyfit(x,y,1);        % Use polyfit to do linear fit (1st order fit)
ms1=m1(1);                % Get slope
er=1;                     % Initiate error at 0, to be used for finding
kk=lima;                   % the saturation value

whilecount = 0;           % Initiate counter
while er > .99         % Loop iterates until the r^2 value goes below 0.9
    x = time(1:kk)';   % New vectors for fitting
    y = S_n(1:kk);
    [m2]=polyfit(x,y,1); 
    f = polyval(m2,x);
    er=rsquared(y,f); %Compute percent change of slope
    kk=kk+1;                   % iterate i by test length
     if er <.65 && whilecount == 0 %Break if slope shift never happens
         m2=m1;      
         break
     end 
     whilecount=whilecount+1;   % Break if slope shift doesn't 
     if kk > .2*length(S_n);     % occur after a certain number of points
         break
     end
end
lambda=m2(1); % The Lyapunov exponenet is the last fit.
linear_end = kk;
%plotting
subplot(2,1,1)
plot(x,y,x,x*m2(1)+m2(2))
text((max(x)-min(x))*.1+min(x),(max(y)-min(y))*.95+min(y),['Lyapunov Exponent= ',num2str(m2(1))])

subplot(2,1,2)
plot((1:length(S_n))/fs,S_n)

