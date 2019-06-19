% Example 4.1 Example of ensemble averaging
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
xlabel('Time (sec)','FontSize',14); ylabel('EEG','FontSize',14); 
% Construct and plot the ensemble average
avg = mean(ver);                % Take ensemble average 
subplot(2,1,2);
plot(t,avg,'k');                	  % Plot ensemble average other data
xlabel('Time (sec)','FontSize',14); ylabel('EEG','FontSize',14);
%
% Estimate the noise components
unaveraged_noise = ver(1,:) - actual_ver; % Noise in signal
averaged_noise = avg - actual_ver;        % Noise in ensemble avg.
std_unaveraged = std(unaveraged_noise);   % Std or noise in signal
std_averaged = std(averaged_noise);     	% Std of noise in ensemble avg.
theoretical =  std_unaveraged/sqrt(100);  % Theoretical noise reduction
disp(' Unaveraged Averaged Theroetical')	% Output results
disp([std_unaveraged std_averaged theoretical])

