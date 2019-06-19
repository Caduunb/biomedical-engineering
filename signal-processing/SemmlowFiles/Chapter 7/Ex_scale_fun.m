% Example 7_x Determination of Scaling function from Filter coefficients
%   Uses Daubechies filter of order 7
%   Implements Ex 7-
%
clear all; close all;
N = 32;    % Data size
% Get filter coefficients
h = daub(7);
Hw = fft(h,N);
Hw = Hw(1:N/2)';    % Eliminate redundent points
subplot(2,2,1);
plot(abs(Hw));
hold on; plot(angle(Hw))
title('Daubechies 7th order');
Hw2 = Hw(1:N/4);
subplot(2,2,2);
for i = 1:3  % Limit series to 4
    plot(abs(Hw2));
   plot(angle(Hw));
    hold on;
    x1 = (1:.5:(N+2)/4);
    y = interp1(Hw2,x1,'spline',0);
    plot(abs(y),'r');
    plot(angle(y),'r');
    Hw2 = y(1:N/4);
        keyboard;
                % Construct product
    Hw = Hw .* y;
end
Hw = [Hw fliplr(Hw)];
Hw(1) = Hw(2); Hw(32) = Hw(31);
subplot(2,2,3)
plot(abs(Hw));
plot(angle(Hw),'r');
sf = ifft(Hw);
subplot(2,2,4)
plot(sf);
title('Scaling Function');
    
    

