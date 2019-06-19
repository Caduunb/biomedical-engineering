function filtPlot(pHandle,pSig,userOpt)
% filtPlot Plots a segment of data in filtMenu
%   filtPlot(pHandle,pSig,userOpt) plots a segment of the signal in pSig's
%   userData property, as indicated by options in userOpt's userData
%   property to handle pHandle.
%
% Original Matlab code: João Luiz Azevedo de Carvalho, 2002
% Adapted to plot BP data and fit new GUI: Luisa Santiago C. B. da Silva,
% April 2017.

options = get(userOpt,'userData');

if ~isempty(options.session.filt.sigLen)
    
    id = options.session.filt.sigSpec{1};
    type = options.session.filt.sigSpec{2};
    signals = get(pSig,'userData');
    
    data = signals.(id).(type).data;
    time = signals.(id).(type).time;
    fs = signals.(id).(type).fs;
    
    % adjust labels according to data type (ECG/BP)
    if strcmp(id,'ecg')
        unit = ''; norm = 'normalized'; 
    else
        unit = ' (mmHg)'; norm = '';
    end
    
    curPos = options.session.filt.curPos;
    windowLen = options.session.filt.windowLen;
    
    % axes limits
    if ~isempty(options.session.filt.lo_lim)
        lo_lim = options.session.filt.lo_lim;
    else
        lo_lim = min(data)-0.05*abs(max(data)-min(data));
        options.session.filt.lo_lim = lo_lim;
    end
    if ~isempty(options.session.filt.hi_lim)
        hi_lim = options.session.filt.hi_lim;
    else
        hi_lim = max(data)+0.05*abs(max(data)-min(data));
        options.session.filt.hi_lim = hi_lim;
    end

    % gets first sample after curPos and no of samples in window
    curPos = curPos+1/fs;
    curWindow = floor(windowLen*fs);

    % repeats last sample
    data = [data;data(end)];

    % limits signals to plotted region
    ss = round(curPos*fs);
    data = data(ss:ss+curWindow);
    time = time(ss:ss+curWindow);
    
    % plot data
    plot(pHandle,time,data,'b-');

    grid(pHandle,'on');
    axis(pHandle,[time(1) time(end) lo_lim hi_lim]);
    ylabel(pHandle,strcat(norm,' amplitude', unit));
    set(get(pHandle,'children'),'visible','on');
else
    ylabel(pHandle,'');
    set(get(pHandle,'children'),'visible','off');
end
end