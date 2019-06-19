function systemPlot(pHandle,pCurVar,userOpt)
% systemPlot Plots a segment of data in systemMenu
%   systemPlot(pHandle,pCurVar,userOpt) plots a segment of the signal in
%   pCurVar's userData property, as indicated by options in userOpt's
%   userData property to handle pHandle.
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
    elseif strcmp(type,'ilv') || strcmp(type,'filt'), yLabel = 'ILV (L)';
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
    elseif strcmp(get(pHandle,'tag'),'in2')
        yLabel = [yLabel,' - IN2'];
        data = curVar.input2;
    end
    time = (0:length(data)-1)/curVar.fs;
    
    % axes limits
    lo_lim = min(data) - 0.05*abs(max(data) - min(data)); 
    hi_lim = max(data) + 0.05*abs(max(data) - min(data));

    plot(pHandle,time,data); 
    
    % shows line on plots indicating the estimation/validation data sets
    pos = time(round((options.session.sys.perc/100)*length(data)));
    line([pos pos],[lo_lim hi_lim],'parent',pHandle,'Color',[.5 .5 .5]);

    ylabel(pHandle,yLabel);
    axis(pHandle,[0 time(end) lo_lim hi_lim]);
    grid(pHandle,'on');
end