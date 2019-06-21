% Exercicio 3.11
clearvars; close all; clc;

load ('SemmlowFiles\Chapter 3\pulses.mat')
fs = 500;        % freq de amostragem
t  = 1;          % tempo total 
f_fund = 1/t;    % freq fundamental
N  = fs*t;       % number of points
freq_vec = 0:f_fund:(fs/2);
%% Fourier
signal = [x1', x2', x3'];
fourier_signal = fft(signal, 1000);
mag_fourier_signal = abs(fourier_signal);
phase_fourier_signal = rad2deg(angle(fourier_signal));
%% Plot data
figure(1)
for cont = 1:3
    hold on;
    plot(signal(:, cont), 'LineWidth', 2);
    if cont == 3
        legend('x1', 'x2', 'x3');
        ylabel('x(t)')
        xlabel('Time (ms)')
    end
end

figure(2);
poi = 251;
for cont = 1:3
    subplot(2,1,1);    hold on;
    title('Freq x Mag');
    plot(freq_vec(1:poi), mag_fourier_signal(1:poi,cont), 'LineWidth', 2);
    if cont == 3
        legend('x1', 'x2', 'x3');
        xlabel('Frequency (Hz)')
        ylabel('|x(f)|')
    end
    
    subplot(2,1,2);    hold on;
    title('Freq x Phase');
    plot(freq_vec(1:poi), phase_fourier_signal(1:poi,cont), 'LineWidth', 2);
    if cont == 3
        legend('x1', 'x2', 'x3');
        xlabel('Frequency (Hz)')
        ylabel('Phase (deg)')
    end
end