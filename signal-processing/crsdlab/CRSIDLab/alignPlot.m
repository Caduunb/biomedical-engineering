function alignPlot(pHandle,pSig,userOpt)
% alignPlot Plots a segment of data in alignMenu
%   alignPlot(pHandle,pSig,userOpt) plots a segment of the signal in pSig's
%   userData property, as indicated by options in userOpt's userData
%   property to handle pHandle.
%
% Original Matlab code: Luisa Santiago C. B. da Silva, April 2017.
% Based on plotting funtions from ECGLab (Carvalho,2001)
    
options = get(userOpt,'userData');
if ~isempty(options.session.align.sigLen)  
    id = get(pHandle,'tag');
    signals = get(pSig,'userData');
    curPos = options.session.align.curPos;
    windowLen = options.session.align.windowLen;
    
    if strcmp(id,'ecg'), type = options.session.align.sigSpec{1};
    elseif strcmp(id,'bp'), type = options.session.align.sigSpec{2};
    else, type = options.session.align.sigSpec{3};
    end
    if  options.session.align.resampled
        data = signals.(id).(type).aligned.data;
        time = signals.(id).(type).aligned.time;
    else
        data = signals.(id).(type).data;
        time = signals.(id).(type).time;
    end

    %defines plot labels according to signal type
    switch(type)
        case 'rri'
            if options.session.align.resampled
                if strcmp(signals.(id).(type).aligned.specs.type,'rri')
                    yLabel = 'RRI (ms)';
                else
                    yLabel = 'HR (bpm)';
                end
            else
                yLabel = 'RRI (ms)';
            end
        case 'sbp', yLabel = 'SBP (mmHg)';
        case 'dbp', yLabel = 'DBP (mmHg)';
        case {'ilv','filt'}, yLabel = 'ILV (L)';
    end

    lo_lim = min(data) - 0.05*abs(max(data) - min(data)); 
    hi_lim = max(data) + 0.05*abs(max(data) - min(data));

    %limits the plotted region according to window size and start point
    bord = []; bordTime = [];
    if curPos < time(1)
        ss = 1;
        if ~options.session.align.resampled
            if options.session.align.rbBorder % symmectric extension
                delay = time(1) - curPos;
                lastSamp = find((time-time(1))>= delay,1);
                bord = flipud(data(1:lastSamp));
                timeDiff = time(1:lastSamp)-time(1);
                bordTime = flipud(time(1)-timeDiff);
            else                              % constant padding
                bord = [data(1) data(1)]; bordTime = [curPos time(1)];
            end
        else
            bord = []; bordTime = [];
        end
    else 
        ss = find(time <= curPos,1);
    end
    if curPos+windowLen > time(end)
        curWindow = length(time);
        if ~options.session.align.resampled
            if options.session.align.rbBorder % symmectric extension
                delay = (curPos+windowLen) - time(end);
                firstSamp = find((time(end)-time)>= delay,1,'last');
                bord = flipud(data(firstSamp:end));
                timeDiff = time(end)-time(firstSamp:end);
                bordTime = flipud(time(end)+timeDiff);
            else                              % constant padding
                bord = [data(end) data(end)]; 
                bordTime = [time(end) curPos+windowLen];
            end
        else
            bord = []; bordTime = [];
        end
    else
        curWindow = find(time>=curPos+windowLen,1);
    end
    data = data(ss:curWindow);
    time = time(ss:curWindow);
    
    if isempty(bord), plot(pHandle,time,data,'b');
    else, plot(pHandle,time,data,'b',bordTime,bord,'r');
    end
    
    % shows lines on plots indicating the chosen start/end point for resamp
    if ~options.session.align.resampled
        startPoint = options.session.align.startPoint;
        if startPoint ~= -1
            line([startPoint startPoint],[lo_lim hi_lim],'parent',...
                pHandle,'Color',[.5 .5 .5]);
        end
        endPoint = options.session.align.endPoint;
        if endPoint ~= -1
            line([endPoint endPoint],[lo_lim hi_lim],'parent',pHandle,...
                'Color',[.5 .5 .5]);
        end
    end

    ylabel(pHandle,yLabel);
    axis(pHandle,[curPos curPos+windowLen lo_lim hi_lim]);
    grid(pHandle,'on');
end