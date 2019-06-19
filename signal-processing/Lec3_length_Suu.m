% Lec3_length_Suu
%
% visualizes the relation between different methods to obtain the spectral
% density
%
% Alfred C. Schouten
% February 16, 2010
clear all
close all
clc

%% A) estimate Suu
dt=0.01;        % sample frequency
N=1000;         % # of samples
ua=randn(N,1);  % signal u: white noise
ta=(0:N-1).'*dt;% time vector

U=fft(ua);      % Fourier transform
U=U(2:N/2+1);   % use only halve the vector. Note that U(1) represents the average value
SuuA=1/N*real(conj(U).*U);   %autospectral density is real by definition (the imag part should be very small)
fa=(1:N/2).'/N/dt;

%% B) increase # samples (longer recording)
Nb=N*7;         % # of samples
ub=randn(Nb,1);
tb=(0:Nb-1).'*dt;
U=fft(ub);
U=U(2:Nb/2+1);
SuuB=1/Nb*real(conj(U).*U);
fb=(1:Nb/2).'/Nb/dt;

%% C) increase fs (decrease dt)
dtc=dt/5;
Nc=N*5;
uc=randn(Nc,1);
tc=(0:Nc-1).'*dtc;
U=fft(uc);
U=U(2:Nc/2+1);
SuuC=1/Nc*real(conj(U).*U);
fc=(1:Nc/2).'/Nc/dtc;

figure
subplot(311),plot(ta,ua),title('default.')
subplot(312),plot(tb,ub),title('increase T')
subplot(313),plot(tc,uc),title('increase fs')
xlabel('time [s]')

figure
loglog(fa,SuuA),hold on
loglog(fb,SuuB,'r')
loglog(fc,SuuC,'m')
legend({'default.','increase T','increase fs'})
ylabel('S_{uu}'),xlabel('frequency [Hz]')

%% calculate average power and variance in power
% calculated in range between 0 and 1 Hz
% find first value above 1 Hz
na=find(fa>10,1);
nb=find(fb>10,1);
nc=find(fc>10,1);

matrix=[mean(SuuA(2:na)) mean(SuuB(2:nb)) mean(SuuC(2:nc));...
    var(SuuA(2:na)) var(SuuB(2:nb)) var(SuuC(2:nc));...
    na-1 nb-1 nc-1];

txt=cell(4,4);
txt(1,1:4)={'Suu' 'A' 'B' 'C'};
txt(2:4,1)={'mean';'std';'n'};
txt(2:4,2:4)=num2cell(matrix);

disp(' ')
disp('Average power in Suu between 0 and 10 Hz')
disp(txt)
disp(' ')