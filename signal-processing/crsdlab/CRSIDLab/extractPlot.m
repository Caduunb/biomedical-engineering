function extractPlot(pHandle,pSig,userOpt)
% extractPlot Plots a segment of data in extractMenu
%   extractPlot(pHandle,pSig,userOpt) plots a segment of the signal in 
%   pSig's userData property with highlighted extracted and ectopic-related 
%   variables, when available, as indicated by options in userOpt's 
%   userData property to handle pHandle.
%
% Original Matlab code (ECG only): João Luiz Azevedo de Carvalho, 2002
% Adapted to plot BP data and fit new GUI: Luisa Santiago C. B. da Silva,
% April 2017.

options = get(userOpt,'userData');

if ~isempty(options.session.ext.sigLen)
    
    id = get(pHandle,'tag');
    
    if strcmp(id,'ecg')
        type = options.session.ext.sigSpec{1};
        var = {'rri'};
    else
        type = options.session.ext.sigSpec{2};
        var = {'sbp','dbp'};
    end
    ind = struct; val = struct; varTime = struct; ect = struct;
    signals = get(pSig,'userData');
    
    data = signals.(id).(type).data;
    time = signals.(id).(type).time;
    fs = signals.(id).(type).fs;

    for i = 1:length(var)
        ind.(var{i}) = signals.(id).(var{i}).index;
        val.(var{i}) = signals.(id).(var{i}).data;
        varTimeOrig.(var{i}) = signals.(id).(var{i}).time;
        varTime.(var{i}) = signals.(id).(var{i}).time;
        ect.(var{i}) = signals.(id).(var{i}).ectopic;
    end
    if strcmp(id,'ecg') && ~strcmp(type,'rri')
        ect.(var{i}) = ect.(var{i})+1; 
    end

    % axes limits
    if ~isempty(options.session.ext.lo_lim.(id))
        lo_lim = options.session.ext.lo_lim.(id);
    else
        lo_lim = min(data)-0.05*abs(max(data)-min(data));
        options.session.ext.lo_lim.(id) = lo_lim;
    end
    if ~isempty(options.session.ext.hi_lim.(id))
        hi_lim = options.session.ext.hi_lim.(id);
    else
        hi_lim = max(data)+0.05*abs(max(data)-min(data));
        options.session.ext.hi_lim.(id) = hi_lim;
    end
    
    curPos = options.session.ext.curPos;
    windowLen = options.session.ext.windowLen;
    
    if ~strcmp(type,'rri') && ~strcmp(type,'sbp') && ~strcmp(type,'dbp')
        %gets first sample after curPos and no of samples in window
        curPos = curPos+1/fs;
        curWindow = floor(windowLen*fs);

        %limits signal to plot region (window size)
        ss = round(curPos*fs);
    else
        if curPos < time(1), ss = 1;
        else, ss = find(time <= curPos,1,'last'); end
        if curPos+windowLen > time(end), curWindow = length(time);
        else, curWindow = find(time>=curPos+windowLen,1)-ss;
        end
    end

    
    %adjust signal length for plotting only (not processing)
    data = [data;data(end)]; time = [time;time(end)];
    %limits signal to plot region (window size)
    data = data(ss:ss+curWindow); time = time(ss:ss+curWindow);

    %limits indexes
    for i = 1:length(var)
        if ~isempty(ind.(var{i}))
            index = find(varTime.(var{i}) >= time(1) & ...
                varTime.(var{i}) <= time(end));
            varTime.(var{i}) = varTime.(var{i})(index);
            val.(var{i}) = val.(var{i})(index);
            auxInd = ind.(var{i}) >= ss & ind.(var{i}) <= ss+curWindow;
            ind.(var{i}) = ind.(var{i})(auxInd);
            ind.(var{i}) = ind.(var{i}) - ss + 1;  
            if ~strcmp(type,'rri') && ~strcmp(type,'sbp') && ...
                    ~strcmp(type,'dbp')
                ect.(var{i}) = ect.(var{i})(auxInd(ect.(var{i})));
                ect.(var{i}) = ect.(var{i}) - find(auxInd == 1,1) + 1;
            else
                auxInd = ect.(var{i}) >= ss & ect.(var{i}) <= ss+curWindow;
                ect.(var{i}) = ect.(var{i})(auxInd);
                if ~isempty(ect.(var{i}))
                    ect.(var{i}) = ect.(var{i})-ss+1;
                end
            end
        else
            ind.(var{i}) = []; val.(var{i}) = [];
            varTime.(var{i}) = []; ect.(var{i}) = [];
        end
    end
    
    % plot data
    if strcmp(id,'ecg')
        if ~strcmp(type,'rri')
            plot(pHandle,time,data,'b-',time(ind.rri),data(ind.rri),...
                'r.',time(ind.rri(ect.rri)),data(ind.rri(ect.rri)),'ko');
            ylabel(pHandle,'Normalized amplitude');
        else
            plot(pHandle,varTime.rri,val.rri,'b-',varTime.rri,val.rri,...
                'r.',varTime.rri(ect.rri),val.rri(ect.rri),'ko')
            ylabel(pHandle,'RRI (ms)');
        end
        if ~isempty(options.session.ext.sigSpec{2})
            if options.session.ext.grid.(id) == 2
                auxTime = signals.bp.sbp.time;
            elseif options.session.ext.grid.(id) == 3
                auxTime = signals.bp.dbp.time;
            end
        else
            auxTime = [];
        end
    else
        if ~strcmp(type,'sbp') && ~strcmp(type,'dbp')
            plot(pHandle,time,data,'b-',time(ind.sbp),data(ind.sbp),...
                'r.',time(ind.dbp),data(ind.dbp),'r*',time(ind.sbp(...
                ect.sbp)),data(ind.sbp(ect.sbp)),'ko',time(ind.dbp(...
                ect.dbp)),data(ind.dbp(ect.dbp)),'ko');
        elseif strcmp(type,'sbp')
            plot(pHandle,varTime.(type),val.(type),'b.-',varTime.(type),...
                val.(type),'r.',varTime.(type)(ect.(type)),...
                val.(type)(ect.(type)),'ko')
        else
            plot(pHandle,varTime.(type),val.(type),'b.-',varTime.(type),...
                val.(type),'r*',varTime.(type)(ect.(type)),...
                val.(type)(ect.(type)),'ko')
        end
        ylabel(pHandle,'Amplitude (mmHg)');
        if options.session.ext.showTs && ~strcmp(type,'sbp') && ...
                ~strcmp(type,'dbp')
            line([time(1) time(end)],[options.session.ext.ts ...
                options.session.ext.ts],'parent',pHandle,'color',...
                [.5 .5 .5]);
        end   
        if options.session.ext.grid.(id) == 2 && ...
                ~isempty(options.session.ext.sigSpec{1})
            auxTime = signals.ecg.(options.session.ext.sigSpec{1}).time;
            if ~strcmp(options.session.ext.sigSpec{1},'rri')
                auxTime = auxTime(signals.ecg.rri.index);
            end
        else
            auxTime = [];
        end
    end
    
    % plots grid if selected
    if options.session.ext.grid.(id) ~= 1
        auxTime = auxTime(auxTime >= time(1) & auxTime <= time(end));
        for i=1:length(auxTime)
            line([auxTime(i) auxTime(i)],[lo_lim hi_lim],'parent',...
                pHandle,'Color',[.5 .5 .5]);
        end
    end
    
    % plots variables indexes and values according to user option
    if windowLen <= options.session.ext.label
        for i = 1:length(var)
            if (strcmp(type,'sbp') && i==1) || (strcmp(type,'dbp') && ...
                    i==2) || (~strcmp(type,'sbp') && ~strcmp(type,'dbp'))
                index = find(varTimeOrig.(var{i}) >= curPos & ...
                    varTimeOrig.(var{i}) <= curPos+windowLen);
                if length(ind.(var{i})) ~= length(varTime.(var{i})) && ...
                        ~strcmp(type,'rri') && ~strcmp(type,'sbp') && ...
                        ~strcmp(type,'dbp')
                    ind.(var{i})(1) = [];
                end
                for j = 1:length(index)
                    if varTime.(var{i})(1)<curPos
                        auxInd = j+1;
                    else
                        auxInd = j;
                    end
                    if ~strcmp(type,'rri') && ~strcmp(type,'sbp') && ...
                            ~strcmp(type,'dbp')
                        text(varTime.(var{i})(auxInd),data(ind.(var{i})(...
                            auxInd)),sprintf([num2str(val.(var{i})(...
                            auxInd)),'[',num2str(index(j)),']-']),...
                            'parent',pHandle,'fontname','Courier New',...
                            'fontsize',9,'hor','right');
                    else
                        text(varTime.(var{i})(auxInd),data(auxInd),...
                            sprintf([num2str(val.(var{i})(auxInd)),'[',...
                            num2str(index(j)),']-']),'parent',pHandle,...
                            'fontname','Courier New','fontsize',9,'hor',...
                            'right');
                    end
                end
            end
        end
    end
    
    axis(pHandle,[curPos curPos+windowLen lo_lim hi_lim]);
    grid(pHandle,'off');
    set(pHandle,'tag',id);
end
end