function respPlot(pHandle,pSig,userOpt)
% respPlot Plots a segment of data in respMenu
%   respPlot(pHandle,pSig,userOpt) plots a segment of the signal in pSig's
%   userData property, as indicated by options in userOpt's userData
%   property to handle pHandle.
%
% Original Matlab code: Luisa Santiago C. B. da Silva, April 2017.
% Based on plotting funtions from ECGLab (Carvalho,2001)

options = get(userOpt,'userData');

if ~isempty(options.session.resp.sigLen)
    type = options.session.resp.sigSpec;
    signals = get(pSig,'userData');
    
    data = signals.rsp.(type).data;
    time = signals.rsp.(type).time;
    fs = signals.rsp.(type).fs;    

    %adapts labels
    if ismember(type,{'int','ilv','filt'})
        unit = ' (L)';
    else
        unit = ' (L/s)';
    end
    
    % axes limits
    if ~isempty(options.session.resp.lo_lim)
        lo_lim = options.session.resp.lo_lim;
    else
        lo_lim = min(data)-0.05*abs(max(data)-min(data));
        options.session.resp.lo_lim = lo_lim;
    end
    if ~isempty(options.session.resp.hi_lim)
        hi_lim = options.session.resp.hi_lim;
    else
        hi_lim = max(data)+0.05*abs(max(data)-min(data));
        options.session.resp.hi_lim = hi_lim;
    end
    
    curPos = options.session.resp.curPos;
    windowLen = options.session.resp.windowLen;
    
    %gets first sample after curPos and no of samples in window
    curPos = curPos+1/fs;
    curWindow = floor(windowLen*fs);

    %repeats last sample
    data = [data;data(end)];

    %limits signals to plotted region
    ss = round(curPos*fs);
    data = data(ss:ss+curWindow);
    time = time(ss:ss+curWindow);

    plot(pHandle,time,data,'b-');

    grid(pHandle,'on');

    axis(pHandle,[time(1) time(end) lo_lim hi_lim]);
    ylabel(pHandle,strcat('Amplitude', unit))
    set(get(pHandle,'children'),'visible','on');
else
    ylabel(pHandle,'');
    set(get(pHandle,'children'),'visible','off');
end
end