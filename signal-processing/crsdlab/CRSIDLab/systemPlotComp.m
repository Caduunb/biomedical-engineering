function systemPlotComp(pHandle,pCurVar,userOpt,tag)
% systemPlotComp Plots data for comparison in systemMenu
%   systemPlotComp(pHandle,pCurVar,userOpt,tag) plots the signals in 
%   pCurVar's userData property to handle pHandle, showing the original
%   signal compared to the filtered or detrended signal, as indicated in
%   userOpt's userData property.
%
% Original Matlab code: Luisa Santiago C. B. da Silva, April 2017.
% Based on plotting funtions from ECGLab (Carvalho,2001)

options = get(userOpt,'userData');
if ~isempty(options.session.sys.sigLen)
    curVar = get(pCurVar,'userData');
    opt = get(pHandle,'tag');
    if strcmp(opt,'out'), type = options.session.sys.sigSpec{1};
    elseif strcmp(opt,'in1'), type = options.session.sys.sigSpec{2};
    elseif strcmp(opt,'in2'), type = options.session.sys.sigSpec{3};
    end
    
    % defines plot labels according to indicated signal type
    if strcmp(type,'rri'), yLabel = 'RRI (ms)';
    elseif strcmp(type,'hr'), yLabel = 'HR (bpm)';
    elseif strcmp(type,'ilv') || strcmp(opt,'filt'), yLabel = 'ILV (L)';
    elseif strcmp(type,'sbp'), yLabel = 'SBP (mmHg)';
    elseif strcmp(type,'dbp'), yLabel = 'DBP (mmHg)';
    end
    
     % defines plot labels according to system variable
    if strcmp(opt,'out')
        yLabel = [yLabel,' - OUT'];
        data = curVar.output;
    elseif strcmp(get(pHandle,'tag'),'in1')
        yLabel = [yLabel,' - IN1'];
        data = curVar.input1;
    else strcmp(get(pHandle,'tag'),'in2')
        yLabel = [yLabel,' - IN2'];
        data = curVar.input2;
    end
    time = (0:length(data)-1)/curVar.fs;
    
    if strcmp(tag,'filt')
        dataFilt = pbFilter(data);
        plot(pHandle,time,data,time,dataFilt);
        %plot position and axes limits
        lo_lim = min([data;dataFilt]) - 0.05*abs(max([data;dataFilt]) - ...
            min([data;dataFilt])); 
        hi_lim = max([data;dataFilt]) + 0.05*abs(max([data;dataFilt]) - ...
            min([data;dataFilt]));
    elseif strcmp(tag,'detrend')
        dataDet = identDetrend(data,curVar.fs,options.session.sys.perc,...
            options.session.sys.poly);
        data = data - mean(data);
        tam = round((options.session.sys.perc/100)*length(data));
        plot(pHandle,time,data,time(1:tam),dataDet(1:tam),...
            time(tam+1:end),dataDet(tam+1:end));
        %plot position and axes limits
        lo_lim = min([data;dataDet]) - 0.05*abs(max([data;dataDet]) - ...
            min([data;dataDet])); 
        hi_lim = max([data;dataDet]) + 0.05*abs(max([data;dataDet]) - ...
            min([data;dataDet]));
    end        
    
    % shows line on plots indicating the estimation/validation data sets
    pos = time(round((options.session.sys.perc/100)*length(data)));
    line([pos pos],[lo_lim hi_lim],'parent',pHandle,'Color',[.5 .5 .5]);
    
    grid(pHandle,'on');
    
    axis(pHandle,[time(1) time(end) lo_lim hi_lim]);
    ylabel(pHandle,yLabel);
end
end

function signal = pbFilter(signal)
% Filter signal with a low-pass Kaiser filter (anti-aliasing)

% build Kaiser filter
[n,Wn,beta,ftype] = kaiserord([0.5 0.7],[1 0],[0.01 0.01]);
kf = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');

signal = filtfilt(kf,1,signal);

end

function signal = identDetrend(signal,fs,perc,polyOrd)

tam = round((perc/100)*length(signal));
time = (0:length(signal)-1)/fs; time = time(:);
signalEst = signal(1:tam)-mean(signal(1:tam));
signalVal = signal(tam+1:end)-mean(signal(tam+1:end));

[pe,~,me] = polyfit(time(1:tam),signalEst,polyOrd);
trendEst = polyval(pe,time(1:tam),[],me);
signalEst = signalEst-trendEst;

[pv,~,mv] = polyfit(time(tam+1:end),signalVal,polyOrd);
trendVal = polyval(pv,time(tam+1:end),[],mv);
signalVal = signalVal-trendVal;

signal(1:tam) =  signalEst(:,1);
signal(tam+1:end) =  signalVal(:,1);
end