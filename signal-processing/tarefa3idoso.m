load('f2o08m.mat')
%Informações presentes no arquivo f2o08m.info
fs = 250;
base = 0; 
gain = 163.84; 

%Gerando os vetores de dados e o vetor de tempo
resp = val(1,:);
ecg = val(2,:);
bp = val(3,:);
timeVec = (0:length(ecg)-1)/fs;

%Ajustes
resp = (resp-base)./gain;
ecg = (ecg-base)./gain; 
bp = (bp-base)./gain;
timeVec = timeVec';
timeVec = timeVec(75000:150000); %Intervalo de [5,10]min
resp = resp(75000:150000);
ecg = ecg(75000:150000);
bp = bp(75000:150000);
resp = resp'; %O programa exige que seja um vetor coluna
ecg = ecg';
bp = bp';

%Gráficos
figure;
subplot(3,1,1);
plot(timeVec,resp);
xlabel('time (s)');
ylabel('RESP (mV)');
subplot(3,1,2);
plot(timeVec,ecg);
xlabel('time (s)');
ylabel('ECG (mV)');
subplot(3,1,3);
plot(timeVec,bp);
xlabel('time (s)');
ylabel('BP (mV)');

%Salvando dados
save('idoso_ecg.mat','ecg','fs');
save('idoso_bp.mat','bp','fs');
save('idoso_resp.mat','resp','timeVec','fs');