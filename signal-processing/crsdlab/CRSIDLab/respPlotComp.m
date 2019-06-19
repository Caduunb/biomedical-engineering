function respPlotComp(pHandle,userOpt)
% respPlotComp Plots a segment of data for comparison in respMenu
%   respPlotComp(pHandle,userOpt) plots a segment of the signals in
%   userOpt's userData property to handle pHandle for comparison.
%
% Original Matlab code: Luisa Santiago C. B. da Silva, April 2017.
% Based on plotting funtions from ECGLab (Carvalho,2001)

options = get(userOpt,'userData');
if ~isempty(options.session.resp.sigLen) 
    % get plot data from pHandle's userData
    plotData = get(pHandle,'userData'); 
    tag =  plotData.tag; fs = plotData.fs;
    signal1 = plotData.signal1; signal2 = plotData.signal2;
    signal3 = plotData.signal3; time = plotData.time;

    %plot position and axes limits
    lo_lim = min([signal1;signal2;signal3]) - ...
        0.05*abs(max([signal1;signal2;signal3]) - ...
        min([signal1;signal2;signal3])); 
    hi_lim = max([signal1;signal2;signal3]) + ...
        0.05*abs(max([signal1;signal2;signal3]) - ...
        min([signal1;signal2;signal3]));
    
    curPos = options.session.resp.curPos;
    windowLen = options.session.resp.windowLen;
    
    %gets first sample after 'segundos' and number of samples in the window
    curPos = curPos+1/fs;
    curWindow = floor(windowLen*fs);
    
    %repeats last value after singnals
    time1 = []; time2 = []; time3 = [];
    if ~isempty(signal1)
        signal1 = [signal1;signal1(end)];
        time1 = time;
    end
    if ~isempty(signal2)
        signal2 = [signal2;signal2(end)]; 
        time2 = time;
    end
    if ~isempty(signal3)
        signal3 = [signal3;signal3(end)];
        time3 = time;
    end
    
    %limits signals to plotted region
    ss=round(curPos*fs);
    time = time(ss:ss+curWindow);
    if ~isempty(time1), time1 = time1(ss:ss+curWindow); end
    if ~isempty(time2), time2 = time2(ss:ss+curWindow); end
    if ~isempty(time3), time3 = time3(ss:ss+curWindow); end
    if ~isempty(signal1), signal1=signal1(ss:ss+curWindow); end
    if ~isempty(signal2), signal2=signal2(ss:ss+curWindow); end
    if ~isempty(signal3), signal3=signal3(ss:ss+curWindow); end
    
    plot(pHandle,time1,signal1,'b',time2,signal2,'r',time3,signal3,'k');
    set(pHandle,'userData',plotData);
    
    grid(pHandle,'on');
    
    axis(pHandle,[time(1) time(end) lo_lim hi_lim]);
    ylabel(pHandle,'Instantaneous Lung Volume (L)');
    
    if strcmp(tag,'filt')
        legend(pHandle,'Original signal','Filter 1','Filter 2')
    else
        legend(pHandle,'High-pass','Polynomial','Linear')
    end
    set(get(pHandle,'children'),'visible','on');
else
    ylabel(pHandle,'');
    set(get(pHandle,'children'),'visible','off');
end
end