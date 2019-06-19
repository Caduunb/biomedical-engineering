% Example 2.12 Convolution of a first-order system with a step

fs = 500; % Sample frequency
N = 2500; % Construct 5 seconds worth of data
t = (0:N-1)/fs; % Time vector 0 to 5
tau = 1; % Time constant
h = exp(-t./tau); % Construct impulse response
x = ones(1,N); % Construct step stimulus
y = conv(x,h); % Get output (convolution)
subplot(1,2,1);
plot(t,h); % Plot impulse response
subplot(1,2,2);
plot(t,y(1:N)); % Plot the step response
