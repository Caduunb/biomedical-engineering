clear all
close all

load SemmlowFiles\'Chapter 2'\data_c1.mat; % Load the data. Signal in variable x

% Apply detrend to x
x = detrend(x);

% Compute de variance and the mean of x
for k = 1:4 % Segment signal into 4 segments
    m = 250*(k-1) + 1; % Index of first segment sample
    segment = x(m:m + 249); % Extract segment
    avg(k) = mean(segment); % Evaluate segment mean
    variance(k) = var(segment); % and segment variance
end
disp('Mean Segment 1 Segment 2 Segment 3 Segment 4') % Display heading
disp(avg) % Output means
disp('Variance Segment 1 Segment 2 Segment 3 Segment 4') % Heading
disp(variance)
