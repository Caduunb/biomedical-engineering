
% Example 10_12 Draw the Koch curve for 1,3, and 5 iterations
%
subplot(3,1,1);  	% Draw each curve in a subplot
make_koch(1);		% Draw curve for 1 iteration
subplot(3,1,2);
make_koch(3);		% Draw curve for 2 iterations
subplot(3,1,3);
make_koch(5);		% Draw curve for 3 iterations

