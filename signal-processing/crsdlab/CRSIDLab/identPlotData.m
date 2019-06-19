function identPlotData(pHandle,pSys,userOpt)
% identPlotData Plots system data in identMenu
%   identPlotData(pHandle,pSys,userOpt) plots the signals that compose the
%   system, stored in pSys's userData property to handle pHandle.
%
% Original Matlab code: Luisa Santiago C. B. da Silva, April 2017.
% Based on plotting funtions from ECGLab (Carvalho,2001)

options = get(userOpt,'userData');
if options.session.ident.sysLen(1) > 0
    sys = get(pSys,'userData');
    opt = get(pHandle,'tag');
    if strcmp(opt,'out')
        var = 'y'; name = 'OutputName'; unit = 'OutputUnit';
        type = 'OUT';
    else
        var = 'u'; name = 'InputName'; unit = 'InputUnit';
        if strcmp(opt,'in1')
            type = 'IN1';
        else
            type = 'IN2';
        end
    end
    if options.session.ident.sysLen(2) == 2
        dataEst = sys.data(:,:,:,1).(var);
        dataVal = sys.data(:,:,:,2).(var);
        if strcmp(opt,'in1')
            data = [dataEst(:,1);dataVal(:,1)];
            tam = length(dataEst(:,1));
        elseif strcmp(opt,'in2')
            data = [dataEst(:,2);dataVal(:,2)];
            tam = length(dataEst(:,2));
        else
            data = [dataEst;dataVal];
            tam = length(dataEst);
        end
        ts = sys.data.ts{1};
    else
        if strcmp(opt,'in1')
            data = sys.data.(var)(:,1);
        elseif strcmp(opt,'in2')
            data = sys.data.(var)(:,2);
        else
            data = sys.data.(var);
        end
        tam = length(data);
        ts = sys.data.ts;
    end
    if strcmp(opt,'in1')
        yLabel = [sys.data.(name){1},' (',sys.data.(unit){1},') - ',type];
    elseif strcmp(opt,'in2')
        yLabel = [sys.data.(name){2},' (',sys.data.(unit){2},') - ',type];
    else
        yLabel = [sys.data.(name){:},' (',sys.data.(unit){:},') - ',type];
    end
    
    time = (0:length(data)-1)*ts;
    
    % axes limits
    lo_lim = min(data) - 0.05*abs(max(data) - min(data));
    hi_lim = max(data) + 0.05*abs(max(data) - min(data));
    
    plot(pHandle,time,data);
    
    % shows line on plots indicating the estimation/validation data sets
    pos = time(tam);
    line([pos pos],[lo_lim hi_lim],'parent',pHandle,'Color',[.5 .5 .5]);
    
    ylabel(pHandle,yLabel);
    axis(pHandle,[0 time(end) lo_lim hi_lim]);
    grid(pHandle,'on');
end