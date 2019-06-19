% Make vergenc respone currpeted by 60 Hz noise
%
clear all; close all;
load vergence;
N = 400;            % sec of data
fs = 200;           % Sample frequency
t = (1:N)/fs;       % Time vector
f_n = 60;           % nosie frequency
x = data_out(2,:) + .2 * sin(2*pi*f_n*t);
plot(t,x);
save verg_noise x;