% Example 2.4 This example evaluates the noise reduction provided by ensemble
% averaging. An ensemble of simulated visual evoked responses is found as
% matrix variable ver in MATLAB file ver.mat.  The actual, noise-free VER
% signal is found as variable actual_ver in the same file.  Ts = 0.005 sec. 
% Construct an ensemble average of 100 responses.  Subtract out the noise-free
% VER from a selected individual VER and form the ensemble average to get
% the noise in each record.  Compare the reduction in standard deviation
% produced by averaging with that predicted theoretically. 
%
load ver;                       % Get visual evoked response data;
Ts = 0.005;                     % Sample interval = 5 msec
[nu,N] = size(ver);             % Get data matrix size 
if nu > N
    ver = ver';
    t = (1:nu)*Ts;              % Generate time vector 
else
    t = (1:N)*Ts;               % Time vector if no transpose   
end 
%
subplot(2,1,1);
plot(t,ver(4,:),'k');           	  % Plot individual record (Number 4)
  xlabel('Time (sec)','FontSize',14);
 ylabel('VER','FontSize',14);
% Construct and plot the ensemble average
avg = mean(ver);                % Take ensemble average 
subplot(2,1,2);
plot(t,avg,'k');                	  % Plot ensemble average other data
xlabel('Time (sec)','FontSize',14);
 ylabel('VER','FontSize',14);
%
% Estimate the noise components
unaveraged_noise = ver(4,:) - actual_ver; % Noise in signal
averaged_noise = avg - actual_ver;        % Noise in ensemble avg.
std_unaveraged = std(unaveraged_noise);   % Std or noise in signal
std_averaged = std(averaged_noise);     	% Std of noise in ensemble avg.
theoretical =  std_unaveraged/sqrt(100);  % Theoretical noise reduction
disp(' Unaveraged Averaged Theroetical')	% Output results
disp([std_unaveraged std_averaged theoretical])
