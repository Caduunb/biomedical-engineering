% Example 2.2 Evaluate a signal to determine if it is stationarity. 
% If not, attempt to modify the signal to remove the nonstationarity if 
% possible.  The file data_c1.mat contains the signal in variable x.  
% The signal is 1000 points long and the sample interval is Ts = 0.001 sec.  
%
%Solution, Part 1: In Part 1 of this example we want to determine this signal 
% is stationary.  If it is not, we will modify the signal in Part 2 to make
% it approximately stationary. There are a number of approaches we could try,
% but one straightforward method would be to segment the data and evaluate the 
% mean and variance of the segments.  If they are the same for all segments, 
% the data is probably stationary.  If these measures change segment-to-segment, 
% the signal is clearly nonstationary. 
close all; clear all;
% Example 2.2, Part 1. Evaluate a signal for stationarity.
load data_c1;                   % Load the data. Signal in variable x
for k = 1:4                     % Segment signal into 4 segments
    m = 250*(k-1) + 1;          % Index of first segment sample 
    segment = x(m:m+249);       % Extract segment
    avg(k) = mean(segment);     % Evaluate segment mean
    variance(k) = var(segment); %   and segment variance
end
disp('Mean   Segment 1 Segment 2 Segment 3 Segment 4')  % Display heading
disp(avg)								  % Output means
disp('Variance Segment 1 Segment 2 Segment 3 Segment 4')% Heading 
disp(variance)							  % Output variance	
%
% Solution, Part 2:  One trick is to transform the signal by taking the 
% derivative: just taking the difference between each point.  
% Example 2.8, Part 2. Modify a nonstationary signal to become stationary
%
y = [diff(x);0];                % Take difference between points.
for k = 1:4                     % Segment signal into 4 segments
    m = 250*(k-1) + 1;          % Index of first segement sample 
    segment = y(m:m+249);       % Extract segment
    avg(k) = mean(segment);     % Evaluate segment mean
    variance(k) = var(segment); %   and segment variance
end
disp('Mean   Segment 1 Segment 2 Segment 3 Segment 4')  % Display heading
disp(avg)								  % Output means
disp('Variance Segment 1 Segment 2 Segment 3 Segment 4')% Heading 
disp(variance)							  % Output variance	
