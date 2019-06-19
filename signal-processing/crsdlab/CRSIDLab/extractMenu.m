function extractMenu(pnExt,pFile,pSig,userOpt)
% ExtractMenu - CRSIDLab
%   Menu for automatic extraction of R-R intervals (RRI) from
%   electrocardiogram (ECG) data and systolic blood pressure (SBP) as well
%   as diastolic blood pressure (DBP) from blood pressure (BP) data. Allows
%   manual correction. Allows both individual and simultaneous viewing of
%   ECG and BP records. Allows manual simultaneous marking of ectopic-beat
%   corresponding SBP and DBP.
%
% Original Matlab code(RRI extraction from ECG and ectopic-beat marking):
% João Luiz Azevedo de Carvalho, 2002.
% Adapted to extract SBP and DBP from BP data, ectopic-beat related marking
% and simultaneous viewing: Luisa Santiago C. B. da Silva, April 2017.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Data visualization and slider
%

pHandle = struct;

uicontrol('parent',pnExt,'style','text','string','Select registers:',...
    'hor','left','units','normalized','position',[.032 .93 .1 .03]);
puVarECG = uicontrol('parent',pnExt,'style','popupmenu','tag','ecg',...
    'string','No data available','value',1,'backgroundColor',[1 1 1],...
    'units','normalized','position',[.13 .93 .2 .04]);

uicontrol('parent',pnExt,'style','text','string','and / or:','units',...
    'normalized','position',[.34 .93 .04 .03]);
puVarBP = uicontrol('parent',pnExt,'style','popupmenu','tag','bp',...
    'string','No data available','value',1,'backgroundColor',[1 1 1],...
    'units','normalized','position',[.39 .93 .2 .04]);

pHandle.full = axes('parent',pnExt,'Units','normalized','Position',...
    [.057 .2 .77 .68],'nextPlot','replaceChildren','visible','on');
pHandle.ecg = axes('parent',pnExt,'tag','ecg','Units','normalized',...
    'Position',[.057 .56 .77 .32],'nextPlot','replaceChildren',...
    'visible','off');
pHandle.bp = axes('parent',pnExt,'tag','bp','Units','normalized',...
    'Position',[.057 .2 .77 .32],'nextPlot','replaceChildren',...
    'visible','off');

uicontrol('parent',pnExt,'style','text','hor','right','string',...
    'Time (seconds) ','fontSize',10,'units','normalized','position',...
    [.73 .12 .1 .035]);

slWindow = uicontrol('parent',pnExt,'Style','slider','Min',0,'Max',1,...
    'Units','Normalized','Position',[.057 .06 .77 .04]);

pbZoom = zoom;
tbZoom = uicontrol('parent',pnExt,'Style','toggle','String','Zoom',...
    'value',0,'CallBack',{@zoomFcn,pbZoom},'Units','Normalized',...
    'Position',[.848 .93 .12 .05]);
zoomFcn(tbZoom,[],pbZoom);

pbFixY = uicontrol('parent',pnExt,'Style','push','String','Fix Y axis',...
    'value',0,'Units','Normalized','Position',[.848 .88 .06 .05]);

pbResetY = uicontrol('parent',pnExt,'Style','push','String','Reset Y axis',...
    'value',0,'Units','Normalized','Position',[.908 .88 .06 .05]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% User options (select variables, plot grid)
%

pnOptions = uipanel('parent',pnExt,'Units','Normalized','Position',...
    [.848 .815 .12 .065]);

uicontrol('parent',pnOptions,'Style','push','String','Edit preferences',...
    'CallBack',{@extUserPref,userOpt,pSig,pHandle},'Units','Normalized',...
    'Position',[.05 .15 .9 .7]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Extract variables from record
%

pnExtract = uipanel('parent',pnExt,'Units','Normalized','Position',...
    [.848 .61 .12 .205]);

% text that indicates variables extraction
uicontrol('parent',pnExtract,'Style','text','String',['Extract ',...
    'variables:'],'Units','Normalized','Position',[.05 .77 .9 .19]);

% popupmenu to choose algorithm to extract RRI
puRRI = uicontrol('parent',pnExtract,'Style','popupmenu','String',...
    {'R-R Interval','Fast algorithm','Slow algorithm'},'value',1,...
    'userData',1,'callback',{@puRRICallback,userOpt,pSig,pHandle,pbZoom},...
    'Units','Normalized','Position',[.05 .54 .9 .19],'backgroundColor',...
    [1 1 1]);

% popupmenu to choose algorithm to extract SBP
puSBP = uicontrol('parent',pnExtract,'Style','popupmenu','String',...
    {'Systolic BP','Waveform algorithm'},'value',1,'userData',1,...
    'callback',{@puSBPCallback,userOpt,pSig,pHandle,pbZoom},'Units',...
    'Normalized','Position',[.05 .31 .9 .19],'backgroundColor',[1 1 1]);

% popupmenu to choose algorithm to extract DBP
puDBP = uicontrol('parent',pnExtract,'Style','popupmenu','String',...
    {'Diastolic BP','Waveform algorithm','From SBP'},'value',1,...
    'userData',1,'callback',{@puDBPCallback,userOpt,pSig,pHandle,pbZoom},...
    'Units','Normalized','Position',[.05 .08 .9 .19],'backgroundColor',...
    [1 1 1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% (Un)mark ectopic-beat related variables
%

pnEctopic = uipanel('parent',pnExt,'Units','Normalized','Position',...
    [.848 .47 .12 .14]);

%text that indicates signal selection
uicontrol('parent',pnEctopic,'Style','text','String',['Ectopic ',...
    'Markings'],'Units','Normalized','Position',[.05 .76 .9 .2]);

%button to mark ectopic
uicontrol('parent',pnEctopic,'Style','push','String','Mark','CallBack',...
    {@markEct,userOpt,pSig,pHandle,pbZoom},'Units','Normalized','Position',...
    [.05 .4 .425 .3]);

%button to unmark ectopic
uicontrol('parent',pnEctopic,'Style','push','String','Unmark',...
    'CallBack',{@unmarkEct,userOpt,pSig,pHandle,pbZoom},'Units','Normalized',...
    'Position',[.525 .4 .425 .3]);

uicontrol('parent',pnEctopic,'Style','push','String','Copy from ECG',...
    'CallBack',{@copyEct,userOpt,pSig,pHandle,pbZoom},'Units','Normalized',...
    'Position',[.05 .06 .9 .3]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% SBP/DBP threshold
%

pnThreshold = uipanel('parent',pnExt,'Units','Normalized','Position',...
    [.848 .345 .12 .125]);

%text indicating SBP/DBP threshold
uicontrol('parent',pnThreshold,'Style','text','String',['SBP/DBP ',...
    'threshold:'],'Units','Normalized','Position',[.05 .725 .9 .225]);

%text edit that shows/modifies SBP/DBP threshold
teThreshold = uicontrol('parent',pnThreshold,'Style','edit','CallBack',...
    {@teCallback,userOpt,pSig,pHandle,pbZoom},'Units','Normalized','Position',...
    [.15 .365 .4 .3],'backgroundColor',[1 1 1]);

%text with SBP/DBP unit (mmHg)
uicontrol('parent',pnThreshold,'Style','text','hor','left','String',...
    'mmHg','Units','Normalized','Position',[.6 .375 .32 .25]);

%check box to show SBP/DBP threshold on plot
cbThreshold = uicontrol('parent',pnThreshold,'Style','checkbox',...
    'String','Show on plot','CallBack',{@cbThresholdCallback,userOpt,...
    pHandle,pSig,pbZoom},'Units','Normalized','Position',[.05 .05 .9 .225]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Restore raw data / Save filtered data
%

pnSave = uipanel('parent',pnExt,'Units','normalized','Position',...
    [.848 .225 .12 .12]);

uicontrol('parent',pnSave,'style','push','string','Restore','callback',...
    {@restoreSig,userOpt,pbZoom,pFile,pSig,pHandle,puRRI,puSBP,puDBP},'units',...
    'normalized','position',[.15 .635 .7 .27]);

uicontrol('parent',pnSave,'style','push','string','Clear','callback',...
    {@clearMarks,userOpt,pbZoom,pSig,pHandle,puRRI,puSBP,puDBP},'units',...
    'normalized','position',[.15 .365 .7 .27]);

uicontrol('parent',pnSave,'Style','push','String','SAVE','CallBack',...
    {@saveSig,userOpt,pFile,pSig},'Units','Normalized','Position',...
    [.15 .095 .7 .27]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot window length and position options
%

pnViewControl = uipanel('parent',pnExt,'Units','normalized','Position',...
    [.848 .06 .12 .165]);

uicontrol('parent',pnViewControl,'Style','text','String',['Cur. ',...
    'Position:'],'Units','Normalized','Position',[.11 .8 .78 .15]);

% show / modify current window position
teCurPos = uicontrol('parent',pnViewControl,'Style','edit','CallBack',...
    {@curPosCallback,pSig,userOpt,slWindow,pHandle,pbZoom},'Units',...
    'Normalized','Position',[.3 .55 .4 .2],'backgroundColor',[1 1 1]);

% shift window left / right
uicontrol('parent',pnViewControl,'Style','text','String',['Window ',...
    'Length:'],'Units','Normalized','Position',[.11 .35 .78 .15]);

uicontrol('parent',pnViewControl,'Style','push','String','<','tag',...
    'left','Callback',{@shiftCallback,pSig,userOpt,slWindow,...
    teCurPos,pHandle,pbZoom},'Units','normalized','Position',[.11 .1 .18 .2]);

uicontrol('parent',pnViewControl,'Style','push','String','>','tag',...
    'right','Callback',{@shiftCallback,pSig,userOpt,slWindow,...
    teCurPos,pHandle,pbZoom},'Units','Normalized','Position',[.71 .1 .18 .2]);

% show / modify window length
teShift = uicontrol('parent',pnViewControl,'Style','edit','Callback',...
    {@windowLenCallback,pSig,userOpt,teCurPos,slWindow,pHandle,pbZoom},'units',...
    'Normalized','Position',[.3 .1 .4 .2],'backgroundColor',[1 1 1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Set final callbacks and call opening function (setup)
%

set(pHandle.full,'ButtonDownFcn',{@correctClick,userOpt,pSig,pHandle,pbZoom});
set(pHandle.ecg,'ButtonDownFcn',{@correctClick,userOpt,pSig,pHandle,pbZoom});
set(pHandle.bp,'ButtonDownFcn',{@correctClick,userOpt,pSig,pHandle,pbZoom});

set(puVarECG,'callback',{@changeVar,userOpt,pFile,pSig,puRRI,puSBP,...
    puDBP,teThreshold,cbThreshold,teCurPos,teShift,slWindow,pHandle,pbZoom});
set(puVarBP,'callback',{@changeVar,userOpt,pFile,pSig,puRRI,puSBP,puDBP,...
    teThreshold,cbThreshold,teCurPos,teShift,slWindow,pHandle,pbZoom});

set(slWindow,'callback',{@sliderCallback,pSig,userOpt,pHandle,teCurPos,pbZoom});

set(pbFixY,'callback',{@fixY,pHandle,pSig,userOpt,tbZoom,pbZoom});
set(pbResetY,'callback',{@resetY,pHandle,pSig,userOpt,tbZoom,pbZoom});

openFnc(userOpt,pFile,pSig,puVarECG,puVarBP,puRRI,puSBP,puDBP,...
    teThreshold,cbThreshold,slWindow,teCurPos,teShift,pHandle,pbZoom);
end

function plotFcn(pHandle,pSig,pbZoom,userOpt)
% adjust handles visibility and plot all selected signals

options = get(userOpt,'userData');
if ~isempty(options.session.ext.sigSpec{1}) && ...
        ~isempty(options.session.ext.sigSpec{2})
    set(pHandle.full,'visible','off');
    set(get(pHandle.full,'children'),'visible','off');
    setAllowAxesZoom(pbZoom,pHandle.full,0);
    
    set(pHandle.ecg,'visible','on');
    set(get(pHandle.ecg,'children'),'visible','on');
    set(pHandle.bp,'visible','on');
    set(get(pHandle.bp,'children'),'visible','on');
    linkaxes([pHandle.ecg, pHandle.bp],'x');
    setAllowAxesZoom(pbZoom,pHandle.ecg,1);
    setAllowAxesZoom(pbZoom,pHandle.bp,1);
    
    extractPlot(pHandle.ecg,pSig,userOpt);
    extractPlot(pHandle.bp,pSig,userOpt);
    set(get(pHandle.ecg,'Children'),'hitTest','off');
    set(get(pHandle.bp,'Children'),'hitTest','off');
else
    set(pHandle.ecg,'visible','off');
    set(get(pHandle.ecg,'children'),'visible','off');
    set(pHandle.bp,'visible','off');
    set(get(pHandle.bp,'children'),'visible','off');
    setAllowAxesZoom(pbZoom,pHandle.ecg,0);
    setAllowAxesZoom(pbZoom,pHandle.bp,0);
    
    set(pHandle.full,'visible','on');
    setAllowAxesZoom(pbZoom,pHandle.full,1);
    
    if ~isempty(options.session.ext.sigSpec{1})
        set(pHandle.full,'tag','ecg');
        extractPlot(pHandle.full,pSig,userOpt);
        set(get(pHandle.full,'children'),'visible','on');
    elseif ~isempty(options.session.ext.sigSpec{2})
        set(pHandle.full,'tag','bp');
        extractPlot(pHandle.full,pSig,userOpt);
        set(get(pHandle.full,'children'),'visible','on');
    else
        set(get(pHandle.full,'children'),'visible','off');
    end
    set(get(pHandle.full,'Children'),'hitTest','off');
end
end

function openFnc(userOpt,pFile,pSig,puVarECG,puVarBP,puRRI,puSBP,puDBP,...
    teThreshold,cbThreshold,slWindow,teCurPos,teShift,pHandle,pbZoom)
% adjust initial values of objects

options = get(userOpt,'userData');
patient = get(pFile,'userData');

% string for variable selection popupmenus (ECG and BP) from available
% patient data
id = {'ecg','bp'};
for i = 1:2
    stringPU = cell(1,1);
    if ~isempty(patient.sig.(id{i}).filt.data)
        stringPU{1} = ['Filtered ',upper(id{i}),' data'];
    end
    if ~isempty(patient.sig.(id{i}).raw.data)
        stringPU{2} = ['Raw ',upper(id{i}),' data'];
    end
    if i == 1 %% add RRI/SBP/DBP viewing
        if ~isempty(patient.sig.(id{i}).rri.data)
            stringPU{3} = 'RRI series';
        end
    else
        if ~isempty(patient.sig.(id{i}).sbp.data)
            stringPU{3} = 'SBP series';
        end
        if ~isempty(patient.sig.(id{i}).dbp.data)
            stringPU{4} = 'DBP series';
        end
    end
    stringPU = stringPU(~cellfun(@isempty,stringPU));
    
    if isempty(stringPU)
        stringPU{1} = ['No ',upper(id{i}),' data available'];
    else
        stringPU(2:end+1) = stringPU(1:end);
        stringPU{1} = ['Indicate ',upper(id{i}),' data'];
    end
    
    % adjust selection value if the variables list has changed
    if ~isequal(options.session.ext.varString.(id{i}),stringPU)
        if ~isempty(options.session.ext.varString.(id{i}))
            if ismember(options.session.ext.varString.(id{i}){...
                    options.session.ext.varValue.(id{i})},stringPU)
                options.session.ext.varValue.(id{i}) = find(ismember(...
                    stringPU,options.session.ext.varString.(id{i}){...
                    options.session.ext.varValue.(id{i})}));
            else
                options.session.ext.varValue.(id{i}) = 1;
            end
        end
        options.session.ext.varString.(id{i}) = stringPU;
    end
end

% open data and setup options that depend on the data
set(userOpt,'userData',options);
setup(userOpt,pFile,pSig,puRRI,puSBP,puDBP,teThreshold,...
    cbThreshold,teCurPos,teShift,slWindow,[1 1]);
options = get(userOpt,'userData');

% setup options that don't depend on the data
set(puVarECG,'string',options.session.ext.varString.ecg);
set(puVarECG,'value',options.session.ext.varValue.ecg);
set(puVarECG,'userData',options.session.ext.varValue.ecg);
set(puVarBP,'string',options.session.ext.varString.bp);
set(puVarBP,'value',options.session.ext.varValue.bp);
set(puVarBP,'userData',options.session.ext.varValue.bp);

set(userOpt,'userData',options);
plotFcn(pHandle,pSig,pbZoom,userOpt);
end

function setup(userOpt,pFile,pSig,puRRI,puSBP,puDBP,teThreshold,...
    cbThreshold,teCurPos,teShift,slWindow,sigShift)
% open data and setup options that depend on the data

options = get(userOpt,'userData');

% identify selected data
auxVarECG = options.session.ext.varString.ecg{...
    options.session.ext.varValue.ecg};
auxVarBP = options.session.ext.varString.bp{...
    options.session.ext.varValue.bp};

type = cell(2,1);
if contains(auxVarECG,'Raw'), type{1} = 'raw';
elseif contains(auxVarECG,'Filtered'), type{1} = 'filt'; 
elseif contains(auxVarECG,'RRI'), type{1} = 'rri'; 
end
if contains(auxVarBP,'Raw'), type{2} = 'raw';
elseif contains(auxVarBP,'Filtered'), type{2} = 'filt';
elseif contains(auxVarBP,'SBP'), type{2} = 'sbp';
elseif contains(auxVarBP,'DBP'), type{2} = 'dbp'; 
end
options.session.ext.sigSpec = type;

set(teThreshold,'enable','off');
set(cbThreshold,'enable','off');

% open data and setup options
if ~isempty(type{1}) || ~isempty(type{2})
    patient = get(pFile,'userData');
    signals = get(pSig,'userData');
    if sigShift(1)
        if ~isempty(type{1}) 
            signals.ecg.(type{1}) = patient.sig.ecg.(type{1});
            signals.ecg.rri = patient.sig.ecg.rri;
        end
        options.session.ext.proc.ecg = 0;
    end
    if sigShift(2)
        if ~isempty(type{2})
            signals.bp.(type{2}) = patient.sig.bp.(type{2});
            signals.bp.sbp = patient.sig.bp.sbp;
            signals.bp.dbp = patient.sig.bp.dbp;
        end
        options.session.ext.proc.bp = 0;
    end
    
    % adjust optional inputs
    id = {'ecg','bp'};
    init = 1; final = 2;
    if isempty(type{1}) || ~sigShift(1), init = 2; end
    if isempty(type{2}) || ~sigShift(2), final = 1; end
    
    for i = init:final
        if isempty(signals.(id{i}).(type{i}).fs)
            if ~isempty(signals.(id{i}).(type{i}).time)
                signals.(id{i}).(type{i}).fs = round(1 / ...
                    mean(diff(signals.(id{i}).(type{i}).time)));
            else
                signals.(id{i}).(type{i}).fs = 1;
            end
        end
        if isempty(signals.(id{i}).(type{i}).time)
            signals.(id{i}).(type{i}).time = ...
                (0:(length(signals.(id{i}).(type{i}).data)-1)) / ...
                signals.(id{i}).(type{i}).fs;
        end
    end
    
    auxSigLen = [0 0];
    stringSBP = get(puSBP,'string'); stringDBP = get(puDBP,'string');
    if ~isempty(type{1})
        if sigShift(1)
            patient.sig.ecg.(type{1}) = signals.ecg.(type{1});
            patient.sig.ecg.rri = signals.ecg.rri;
            if ~strcmp(type{2},'rri')
                options.session.ext.cbSelection(1) = options.ext.cbSelection(1);
            end
        end
        if ~strcmp(type{1},'rri')
            set(puRRI,'enable','on'); 
            auxSigLen(1) = (length(signals.(id{1}).(type{1}).data) - 1) / ...
                signals.(id{1}).(type{1}).fs;
        else
            set(puRRI,'enable','off','value',1); 
            auxSigLen(1) = signals.(id{1}).(type{1}).time(end);
        end
        
        
        prevValSBP = get(puSBP,'value');
        prevVarSBP = stringSBP{prevValSBP};
        prevValDBP = get(puDBP,'value');
        prevVarDBP = stringDBP{prevValDBP};
        if ~isempty(type{2})
            stringSBP{end+1} = 'From RRI';
            stringSBP = unique(stringSBP,'stable');
            stringDBP{end+1} = 'From RRI & SBP';
            stringDBP = unique(stringDBP,'stable');
        end
        set(puSBP,'value',find(ismember(stringSBP,prevVarSBP)));
        set(puDBP,'value',find(ismember(stringDBP,prevVarDBP)));
    else
        set(puRRI,'enable','off','value',1);
        if ~isempty(type{2})
            if ~isempty(find(ismember(stringSBP,'From RRI'),1))
                if get(puSBP,'value') == ...
                        find(ismember(stringSBP,'From RRI'),1)
                    set(puSBP,'value',1);
                end
                stringSBP(find(ismember(stringSBP,'From RRI'),1)) = [];
            end
            if ~isempty(find(ismember(stringDBP,'From RRI & SBP'),1))
                if get(puDBP,'value') == ...
                        find(ismember(stringDBP,'From RRI & SBP'),1)
                    set(puDBP,'value',1);
                end
                stringDBP(find(ismember(stringDBP,'From RRI & SBP'),1))=[];
            end
        end
    end
    set(puSBP,'string',stringSBP);
    set(puDBP,'string',stringDBP);
    
    if ~isempty(type{2})
        if  sigShift(2)
            patient.sig.bp.(type{2}) = signals.bp.(type{2});
            patient.sig.bp.sbp = signals.bp.sbp;
            patient.sig.bp.dbp = signals.bp.dbp;
            if ~strcmp(type{2},'sbp') && ~strcmp(type{2},'dbp')
                options.session.ext.cbSelection(2) = options.ext.cbSelection(2);
                options.session.ext.cbSelection(3) = options.ext.cbSelection(3);
            end
        end
        if ~strcmp(type{2},'sbp') && ~strcmp(type{2},'dbp')
            set(puSBP,'enable','on');
            set(puDBP,'enable','on');
            auxSigLen(2) = (length(signals.(id{2}).(type{2}).data) - 1) / ...
                signals.(id{2}).(type{2}).fs;
            set(teThreshold,'enable','on');
            set(cbThreshold,'enable','on');
        else
            set(puSBP,'enable','off','value',1);
            set(puDBP,'enable','off','value',1);
            auxSigLen(2) = signals.(id{2}).(type{2}).time(end);
            set(puSBP,'enable','off','value',1);
            set(puDBP,'enable','off','value',1);
            if strcmp(type{2},'sbp')
                options.session.ext.cbSelection(3) = 0;
                if options.session.ext.grid.ecg == 3
                    options.session.ext.grid.ecg = 1;
                end
            else
                options.session.ext.cbSelection(2) = 0;
                if options.session.ext.grid.ecg == 2
                    options.session.ext.grid.ecg = 1;
                end
            end
        end
        
        if options.session.ext.ts >= max(signals.bp.(type{2}).data) || ...
                options.session.ext.ts <= min(signals.bp.(type{2}).data)
            options.session.ext.ts = round(mean(signals.bp.(type{2}).data));
        end
    else
        set(puSBP,'enable','off','value',1);
        set(puDBP,'enable','off','value',1);
    end
    set(pFile,'userData',patient);
    set(pSig,'userData',signals);
    
    if max(auxSigLen) ~= 0
        options.session.ext.sigLen = max(auxSigLen); 
    end
    
    if options.session.ext.sigLen - options.session.ext.windowLen > 0
        set(slWindow,'Max',options.session.ext.sigLen - ...
            options.session.ext.windowLen);
    else
        options.session.ext.windowLen = options.session.ext.sigLen;
        set(teShift,'String',num2str(options.session.ext.windowLen));
        set(slWindow,'Max',0);
    end
    if options.session.ext.windowLen + options.session.ext.curPos > ...
            options.session.ext.sigLen
        options.session.ext.curPos = options.session.ext.sigLen - ...
            options.session.ext.windowLen;
    end
    
    set(slWindow,'value',options.session.ext.curPos);
    options.session.ext.slider = [0.2 0.4]*...
        (options.session.ext.windowLen/options.session.ext.sigLen);
    set(slWindow,'sliderStep',options.session.ext.slider);
else
    options.session.ext.sigLen = [];
    options.session.ext.proc.ecg = 0;
    options.session.ext.proc.ecg = 0;
    set(puRRI,'enable','off','value',1);
    set(puSBP,'enable','off','value',1);
    set(puDBP,'enable','off','value',1);
end

options.session.ext.saved = 0;
set(teCurPos,'string',num2str(options.session.ext.curPos));
set(teShift,'string',num2str(options.session.ext.windowLen));
set(teThreshold,'string',num2str(options.session.ext.ts));
set(cbThreshold,'value',options.session.ext.showTs);
set(userOpt,'userData',options);
end

function changeVar(scr,~,userOpt,pFile,pSig,puRRI,puSBP,puDBP,...
    teThreshold,cbThreshold,teCurPos,teShift,slWindow,pHandle,pbZoom)
% change record for variable extraction

errStat = 0;
oldValue = get(scr,'userData');
newValue = get(scr,'value');

if oldValue ~= newValue
    options = get(userOpt,'userData');
    if oldValue~=1 && ~options.session.ext.saved && ...
            options.session.ext.proc.(get(scr,'tag'))
        [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
            'changeVarExtPref','Change data',sprintf([...
            'Warning!','\nThe current data has not been saved. Any ',...
            'modifications will be lost if other data is opened before',...
            ' saving.\nAre you sure you wish to proceed?']),...
            {'Yes','No'},'DefaultButton','No');
        if strcmp(selButton,'no') && dlgShow
            errStat = 1;
        end
    end
    if ~errStat
        options.session.ext.varValue.(get(scr,'tag')) = newValue;
        set(scr,'userData',newValue);
        set(userOpt,'userData',options);
        
        % indicate which of the signals was changed
        if strcmp(get(scr,'tag'),'ecg')
            sigShift = [1 0];
        else
            sigShift = [0 1];
        end
        setup(userOpt,pFile,pSig,puRRI,puSBP,puDBP,teThreshold,...
            cbThreshold,teCurPos,teShift,slWindow,sigShift);
        plotFcn(pHandle,pSig,pbZoom,userOpt);
    else
        set(scr,'value',oldValue);
    end
end
end

function restoreSig(~,~,userOpt,pbZoom,pFile,pSig,pHandle,puRRI,puSBP,puDBP)
% restore selected records from disk

options = get(userOpt,'userData');
type = options.session.ext.sigSpec;
if ~isempty(options.session.ext.sigLen)
    signals = get(pSig,'userData');
    patient = get(pFile,'userData');
    
    % restore popupmenus indicating variables extraction
    if options.session.ext.cbSelection(1) && ~isempty(type{1})
        signals.ecg.(type{1}) = patient.sig.ecg.(type{1});
        signals.ecg.rri = patient.sig.ecg.rri;
        set(puRRI,'value',1);
    end
    if options.session.ext.cbSelection(2) && ~isempty(type{2})
        signals.bp.(type{2}) = patient.sig.bp.(type{2});
        signals.bp.sbp = patient.sig.bp.sbp;
        set(puSBP,'value',1);
    end
    if options.session.ext.cbSelection(3) && ~isempty(type{2})
        signals.bp.(type{2}) = patient.sig.bp.(type{2});
        signals.bp.dbp = patient.sig.bp.dbp;
        set(puDBP,'value',1);
    end
    
    options.session.ext.proc.ecg = 0;
    options.session.ext.proc.bp = 0;
    options.session.ext.saved = 0;
    
    set(userOpt,'userData',options);
    set(pSig,'userData',signals);
    
    plotFcn(pHandle,pSig,pbZoom,userOpt);
end
end

function saveSig(~,~,userOpt,pFile,pSig)
% save selected data

options = get(userOpt,'userData');
type = options.session.ext.sigSpec;
if ~isempty(options.session.ext.sigLen) && ...
        (~isempty(type{1}) || ~isempty(type{2}))
    
    errStat = 0; saved = 0;
    
    % verify if there's already rri/sbp/dbp data saved
    patient = get(pFile,'userData');
    if (options.session.ext.cbSelection(1) && ~isempty(type{1}) && ...
            ~isempty(patient.sig.ecg.rri.data)) || ...
            (options.session.ext.cbSelection(2) && ~isempty(type{2}) && ...
            ~isempty(patient.sig.bp.sbp.data)) || ...
            (options.session.ext.cbSelection(3) && ~isempty(type{2}) && ...
            ~isempty(patient.sig.bp.dbp.data))
        saved = 1;
    end
    
    rriString = []; sbpString = []; dbpString = [];
    signals = get(pSig,'userData');
    if (options.session.ext.cbSelection(1) && ~isempty(type{1}) && ...
            isempty(signals.ecg.rri.data)) || ...
            (options.session.ext.cbSelection(2) && ~isempty(type{2}) && ...
            isempty(signals.bp.sbp.data)) || ...
            (options.session.ext.cbSelection(3) && ~isempty(type{2}) && ...
            isempty(signals.bp.dbp.data))
        if (options.session.ext.cbSelection(1) && ...
                ~isempty(signals.ecg.rri.data)) || ...
                (options.session.ext.cbSelection(2) && ...
                ~isempty(signals.bp.sbp.data)) || ...
                (options.session.ext.cbSelection(3) && ...
                ~isempty(signals.bp.dbp.data))
            [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
                'saveExtPref','Saving variables',sprintf([...
                'Warning!','\nAt least one of the variables selected ',...
                'for\nsaving has not been extracted.\n',...
                'Are you sure you wish to proceed?']),{'Yes','No'},...
                'DefaultButton','No');
            if strcmp(selButton,'no') && dlgShow
                errStat = 1;
            end
        else
            uiwait(errordlg(['No changes made! You must extract the ',...
                'variables from at least one of the signals before ',...
                'saving.'],'No changes made','modal'));
            errStat = 1;
        end
    end
    if ~errStat && saved
        futureData = 0;
        if (options.session.ext.cbSelection(1) && ~isempty(type{1}) && ...
                ~isempty(patient.sig.ecg.rri.data))
            if ~isempty(patient.sig.ecg.rri.aligned.data)
                futureData = 1;
            end
            rriString = '\n RRI';
        end
        if (options.session.ext.cbSelection(2) && ~isempty(type{2}) && ...
                ~isempty(patient.sig.bp.sbp.data))
            if ~isempty(patient.sig.bp.sbp.aligned.data)
                futureData = 1;
            end
            sbpString = '\n SBP';
        end
        if (options.session.ext.cbSelection(3) && ~isempty(type{2}) && ...
                ~isempty(patient.sig.bp.dbp.data))
            if ~isempty(patient.sig.bp.dbp.aligned.data)
                futureData = 1;
            end
            dbpString = '\n DBP';
        end
        varString = [rriString,sbpString,dbpString];
        if futureData
            [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
                'saveExtOW1Pref','Saving variables',sprintf(...
                ['Warning!','\nIt appears that there''s already ',...
                'data saved for the following variable(s):',varString,...
                '\n\nATENTION: There is data saved as at least one of',...
                'the indicated record''s Aligned & Resample data.\n',...
                'Overwriting this record will erase all data derived ',...
                'from it, including any systems or models.\n\nAre you ',...
                'sure you wish to overwrite it?']),{'Yes','No'},...
                'DefaultButton','No');
        else
            [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
                'saveExtOW2Pref','Saving variables',sprintf([...
                'Warning!','\nIt appears that there''s already data ',...
                'saved for the following variable(s):',varString,'.\n',...
                'Are you sure you wish to overwrite it?']),{'Yes','No'},...
                'DefaultButton','No');
        end
        if strcmp(selButton,'no') && dlgShow
            errStat = 1;
        end
    end
    
    if ~errStat
        filename = options.session.filename;
        stringRRI = []; stringSBP = []; stringDBP = [];
        % save data from selected signals
        if (options.session.ext.cbSelection(1) && ~isempty(type{1}) && ...
                ~isempty(signals.ecg.rri.data))
            spec = struct; spec.type = type{1};
            spec.algorithm = options.session.ext.alg.rri;
            saveAux(userOpt,pFile,pSig,spec,'ecg','rri',type{1});
            stringRRI = '\n RRI';
        end
        if (options.session.ext.cbSelection(2) && ~isempty(type{2}) && ...
                ~isempty(signals.bp.sbp.data))
            spec = struct; spec.type = type{2};
            spec.algorithm = options.session.ext.alg.sbp;
            saveAux(userOpt,pFile,pSig,spec,'bp','sbp',type{2});
            stringSBP = '\n SBP';
        end
        if (options.session.ext.cbSelection(3) && ~isempty(type{2}) && ...
                ~isempty(signals.bp.dbp.data))
            spec = struct; spec.type = type{2};
            spec.algorithm = options.session.ext.alg.dbp;
            saveAux(userOpt,pFile,pSig,spec,'bp','dbp',type{2});
            stringDBP = '\n DBP';
        end
        
        options.session.ext.saved = 1;
        
        set(userOpt,'userData',options);
        patient = get(pFile,'userData'); %#ok<NASGU>
        save(filename,'patient');
        saveConfig(userOpt);
        msgString = [stringRRI,stringSBP,stringDBP];
        uiwait(msgbox(sprintf(['The following variables have been ',...
            'saved:',msgString]),'Variables saved','modal'));
    end
end
end

function saveAux(userOpt,pFile,pSig,spec,id,var,type)
% move selected data to patient file before saving

options = get(userOpt,'UserData');
patient = get(pFile,'userData');
signals = get(pSig,'userData');
signals.(id).(var).specs = spec;
signals.(id).(var).fs = signals.(id).(type).fs;
patient.sig.(id).(var) = signals.(id).(var);

% remove corresponding future data (aligned, systems)
patient.sig.(id).(var).aligned = dataPkg.alignedUnit;
prevSys = fieldnames(patient.sys);
for i = 1:length(prevSys)
    if strcmpi(var,patient.sys.(prevSys{i}).data.OutputName) || ...
            any(ismember(patient.sys.(prevSys{i}).data.InputName,...
            upper(var)))
        patient.sys = rmfield(patient.sys,prevSys{i});
    end
end

% adjust 'align & resample' and 'create system' data selection
puOpt = {'out','in1','in2'}; erasedFlag = 0;
for i = 1:3
    if ~isempty(options.session.sys.varString.(puOpt{i}))
        auxVar = options.session.sys.varString.(puOpt{i}){...
            options.session.sys.varValue.(puOpt{i})};
        if erasedFlag || contains(auxVar,upper(var)) || ...
                (strcmp(var,'rri') && contains(auxVar,'HR'))
            options.session.sys.varValue.(puOpt{i}) = 1;
        end
        erasedFlag = 1;
    end
end
if ~isempty(options.session.align.varString.(id))
    auxVar = options.session.align.varString.(id){...
        options.session.align.varValue.(id)};
    if contains(auxVar,upper(var)) || (strcmp(var,'rri') && ...
            contains(auxVar,'HR'))
        options.session.align.varValue.(id) = 1;
    end
end

set(userOpt,'UserData',options);
set(pFile,'userData',patient);
set(pSig,'userData',signals);

end

function clearMarks(~,~,userOpt,pbZoom,pSig,pHandle,puRRI,puSBP,puDBP)
% clear variables extracted from selected signals

options = get(userOpt,'userData');
signals = get(pSig,'userData');
type = options.session.ext.sigSpec;

errStat = 0;
if (options.session.ext.cbSelection(1) && strcmp(type{1},'rri')) || ...
        (options.session.ext.cbSelection(2) && strcmp(type{2},'sbp')) ||...
        (options.session.ext.cbSelection(3) && strcmp(type{2},'dbp'))
    uiwait(errordlg(['Variables can only be cleared from ECG and ',...
        'continuous BP records, not when the variables themselves ',...
        'are displayed. Either go to "Edit preferences" and unmark '...
        'the variables that are not displayed in relation to ',...
        'continuous records or select the continuous record from the ',...
        'popup menu.'],...
        'Clear selected variable','modal'));
    errStat = 1;
end

if ~errStat
    if options.session.ext.cbSelection(1) && ~isempty(type{1})
        signals.ecg.rri = dataPkg.varUnit;
        set(puRRI,'value',1);
        options.session.ext.proc.ecg = 1;
    end
    if options.session.ext.cbSelection(2) && ~isempty(type{2})
        signals.bp.sbp = dataPkg.varUnit;
        set(puSBP,'value',1);
        options.session.ext.proc.bp = 1;
    end
    if options.session.ext.cbSelection(3) && ~isempty(type{2})
        signals.bp.dbp = dataPkg.varUnit;
        set(puDBP,'value',1);
        options.session.ext.proc.bp = 1;
    end

    set(userOpt,'userData',options);
    set(pSig,'userData',signals);

    plotFcn(pHandle,pSig,pbZoom,userOpt);
end
end

function sliderCallback(scr,~,pSig,userOpt,pHandle,teCurPos,pbZoom)
% adjust settings according to slider dislocation

options = get(userOpt,'userData');

if ~isempty(options.session.ext.sigLen)
    options.session.ext.curPos = round(1000*get(scr,'Value'))/1000;
    set(userOpt,'userData',options);
    
    plotFcn(pHandle,pSig,pbZoom,userOpt);
    set(teCurPos,'String',num2str(options.session.ext.curPos));
end
end

function curPosCallback(scr,~,pSig,userOpt,slWindow,pHandle,pbZoom)
% adjust current window position

options = get(userOpt,'userData');
A=str2double(get(scr,'String'));
if ~isnan(A)
    if ~isempty(options.session.ext.sigLen)
        hiLim = get(slWindow,'Max');
    else
        hiLim = inf;
    end
    
    if A <= hiLim && A >= 0
        options.session.ext.curPos = A;
    elseif A > hiLim
        options.session.ext.curPos = hiLim;
    else
        options.session.ext.curPos = 0;
    end
    
    if ~isempty(options.session.ext.sigLen)
        set(slWindow,'Value',options.session.ext.curPos);
    end
    set(userOpt,'userData',options);
    
    plotFcn(pHandle,pSig,pbZoom,userOpt);
end
set(scr,'String',num2str(options.session.ext.curPos));
end

function shiftCallback(scr,~,pSig,userOpt,slWindow,teCurPos,pHandle,pbZoom)
% move a full window to the left or right

options = get(userOpt,'userData');
if ~isempty(options.session.ext.sigLen)
    if strcmp(get(scr,'tag'),'left')
        if options.session.ext.curPos-options.session.ext.windowLen >= 0
            options.session.ext.curPos = options.session.ext.curPos - ...
                options.session.ext.windowLen;
        else
            options.session.ext.curPos = 0;
        end
    else
        if options.session.ext.curPos+options.session.ext.windowLen <=...
                get(slWindow,'Max')
            options.session.ext.curPos = options.session.ext.curPos + ...
                options.session.ext.windowLen;
        else
            options.session.ext.curPos = get(slWindow,'Max');
        end
    end
    
    set(slWindow,'Value',options.session.ext.curPos);
    set(userOpt,'userData',options);
    
    plotFcn(pHandle,pSig,pbZoom,userOpt);
    set(teCurPos,'String',num2str(options.session.ext.curPos));
end
end

function windowLenCallback(scr,~,pSig,userOpt,teCurPos,slWindow,pHandle,pbZoom)
% modify window length (in seconds)

options = get(userOpt,'userData');
if ~isempty(options.session.ext.sigLen)
    A = str2double(get(scr,'String'));
    if  ~isnan(A)
        if A >= 1 && A <= options.session.ext.sigLen
            options.session.ext.windowLen = round(1000*A)/1000;
            %adapts values for last window
            if A+options.session.ext.curPos >= options.session.ext.sigLen
                options.session.ext.curPos=options.session.ext.sigLen-...
                    options.session.ext.windowLen;
                set(teCurPos,'String',...
                    num2str(options.session.ext.curPos));
                set(slWindow,'Value',options.session.ext.curPos);
            end
        elseif A < 1
            options.session.ext.windowLen = 1;
        else
            options.session.ext.windowLen = options.session.ext.sigLen;
            options.session.ext.curPos = 0;
            set(teCurPos,'String',num2str(0));
            set(slWindow,'Value',options.session.ext.curPos);
        end
        if options.session.ext.sigLen - options.session.ext.windowLen >=0
            set(slWindow,'Max',options.session.ext.sigLen - ...
                options.session.ext.windowLen);
        else
            set(slWindow,'Max',0);
        end
        
        set(userOpt,'userData',options);
        plotFcn(pHandle,pSig,pbZoom,userOpt);
        
    end
    
    options.session.ext.slider = [0.2 0.4]*...
        (options.session.ext.windowLen/options.session.ext.sigLen);
    set(slWindow,'sliderstep',options.session.ext.slider);
    set(scr,'String',num2str(options.session.ext.windowLen));
    set(userOpt,'userData',options);
end
end

function teCallback(scr,~,userOpt,pSig,pHandle,pbZoom)
% set SBP/DBP threshold

options = get(userOpt,'userData');

if ~isempty(options.session.ext.sigLen)
    A=str2double(get(scr,'string'));
    
    type = options.session.ext.sigSpec;
    signals = get(pSig,'userData');
    
    % set boundries according current SBP and DBP values
    if ~isempty(signals.bp.sbp.index)
        hiLim = max(signals.bp.(type{2}).data(signals.bp.sbp.index));
    else
        hiLim = max(signals.bp.(type{2}).data);
    end
    if ~isempty(signals.bp.dbp.index)
        loLim = min(signals.bp.(type{2}).data(signals.bp.dbp.index));
    else
        loLim = min(signals.bp.(type{2}).data);
    end
    
    if ~isnan(A)
        if A >= loLim && A <= hiLim
            options.session.ext.ts = A;
        elseif A < loLim
            options.session.ext.ts = loLim;
        else
            options.session.ext.ts = hiLim;
        end
    end
    
    set(userOpt,'userData',options);
    set(scr,'string',num2str(options.session.ext.ts));
    
    if options.session.ext.showTs
        plotFcn(pHandle,pSig,pbZoom,userOpt);
    end
end
end

function cbThresholdCallback(scr,~,userOpt,pHandle,pSig,pbZoom)
% show SBP/DBP threshold on plot

options = get(userOpt,'userData');
options.session.ext.showTs = get(scr,'value');
set(userOpt,'userData',options);
plotFcn(pHandle,pSig,pbZoom,userOpt);
end

function puRRICallback(scr,~,userOpt,pSig,pHandle,pbZoom)
% extract RRI using algorithm indicated in popupmenu

signals = get(pSig,'userData');
oldValue = get(scr,'userData');
newValue = get(scr,'value');

errStat = 0;
if ~isempty(signals.ecg.rri.data) && newValue ~= 1
    uiwait(errordlg(['RRI already extracted! If you wish to try ',...
        'another algorithm, please clear the RRI first.'],...
        'RRI already extracted','modal'));
    set(scr,'value',oldValue);
    errStat = 1;
end

if ~errStat
    options = get(userOpt,'userData');
    type = options.session.ext.sigSpec;
    
    % 17 hz filter
    w0=17.5625*2*pi; NUM=1.2*w0^2; DEN=[1,(w0/3),w0^2];
    [B,A] = bilinear(NUM,DEN,signals.ecg.(type{1}).fs);
    auxECG = filtfilt(B,A,signals.ecg.(type{1}).data);
    
    % derivative
    auxECG = filter([1 -1],1,auxECG);
    
    % 30 Hz low-pass filter
    [B,A] = butter(8,30/(signals.ecg.(type{1}).fs/2));
    auxECG = filter(B,A,auxECG);
    auxECG = auxECG /max(abs(auxECG));
    
    auxECG=auxECG.^2;
    
    % integrator (moving window)
    N = round(0.150*signals.ecg.(type{1}).fs);
    auxECG = 1/N*filter(ones(1,N),1,auxECG);
    
    % execute indicated algorithm
    if newValue == 2
        signals.ecg.rri.index = fastAlg(signals.ecg.(type{1}).data,...
            auxECG,signals.ecg.(type{1}).fs);
        options.session.ext.alg.rri = 'Fast algorithm';
    elseif newValue == 3
        signals.ecg.rri.index = slowAlg(signals.ecg.(type{1}).data,...
            auxECG,signals.ecg.(type{1}).fs);
        options.session.ext.alg.rri = 'Slow algorithm';
    end
    
    if ~isempty(signals.ecg.rri.index)
        % time stamp
        auxTime = signals.ecg.(type{1}).time(signals.ecg.rri.index);
        % R-R intervals in milliseconds
        signals.ecg.rri.data = round(diff(round(1000*auxTime)));
        signals.ecg.rri.time = auxTime(2:end);
    end
    signals.ecg.rri.ectopic = [];
    set(scr,'userData',newValue);
    set(pSig,'userData',signals);
    options.session.ext.proc.ecg = 1;
    set(userOpt,'userData',options);
    
    plotFcn(pHandle,pSig,pbZoom,userOpt);
end
end

function rriIndex = fastAlg(ecg,ecgFilt,fs)
% fast algorithm for extracting RRI
% Original Matlab code: João Luiz Azevedo de Carvalho, 2002

searchReg = round(0.070*fs);
gain = 0.15;
compThres = round(2*fs);
leap = round(0.350*fs);
leap10=round(0.01*fs);
interval = round(0.030*fs);
ecgLen = length(ecg);
n=1;
rWaves = zeros(ecgLen,1);

% for each R wave
while n < ecgLen
    % calculates threshold for current R wave, based on next 2 seconds
    if (n+compThres) <= ecgLen
        threshold = gain*max(ecgFilt(n:n+compThres));
    else
        threshold = gain*max(ecgFilt(ecgLen-compThres:ecgLen));
    end
    
    % seaches for R wave region
    if ((ecgFilt(n) > threshold) && (n < ecgLen))
        rWaves(n) = n;
        n = n+leap;
    else
        n = n+leap10;
    end
end
rWaves = rWaves(rWaves ~= 0);

% high pass filter to remove baseline wander
[B,A] = butter(4,1/(fs/2),'high');
ecgFilt = filtfilt(B,A,ecg);

% look back to search for R wave within region
rWaves = rWaves-interval;
if rWaves(1) < 1, rWaves(1) = 1; end

rriIndex = zeros(length(rWaves),1);

% find R wave
for i=1:length(rWaves)
    % find highest point
    if ecgLen>=rWaves(i)+searchReg
        [~,marks]=max(ecgFilt(rWaves(i):rWaves(i)+searchReg));
    else
        [~,marks]=max(ecgFilt(rWaves(i):ecgLen));
    end
    
    % find its position
    marks = marks+rWaves(i)-1;
    rriIndex(i) = marks;
end
rriIndex = rriIndex(rriIndex~=0);
end

function rriIndex = slowAlg(ecg,ecgFilt,fs)
% slow algorithm for extracting RRI
% Original Matlab code: João Luiz Azevedo de Carvalho, 2002

leap = round(0.200*fs); % min 200 ms between R waves
thresArea = round(2*fs);
delay = round(0.160*fs);

ecgLen = length(ecg);
auxECG = -1500*ones(ecgLen,1);
n=1; rriIndex = zeros(ecgLen,1);

% for each R wave
while n < ecgLen
    maximum = 0; index = 0;
    
    % calculates threshold for current R wave, based on next 2 seconds
    if (n+thresArea) <= ecgLen
        threshold = 0.15*max(ecgFilt(n:n+thresArea));
    else
        threshold = 0.15*max(ecgFilt(ecgLen-thresArea:ecgLen));
    end
    
    % looks for R wave region
    while ((ecgFilt(n) > threshold) && (n < ecgLen))
        % finds max point in region
        if ecgFilt(n) > maximum
            maximum = ecgFilt(n); index = n;
        end
        n = n+1;
    end
    
    % stores max if found
    if index ~=0
        auxECG(index) = 1;
        n = index + leap;
    else
        n=n+1;
    end
end

% mean for 1 sec. regions
for i = 1:round(fs):ecgLen-round(fs)
    ecg(i:i+round(fs)-1) = ecg(i:i+round(fs)-1)-mean(ecg(i:i+round(fs)-1));
end

n=1;
while n<=ecgLen
    while ((auxECG(n) == 1) && (n <= ecgLen))
        
        % goeas back up to 160ms searching for R wave
        if (n-delay)>0
            inicio = n-delay;
        else
            inicio = 1;
        end
        [~,index] = max(ecg(inicio:n));
        index = fix(inicio+index-1);
        rriIndex(n) = index;
        n=n+1;
    end
    n=n+1;
end
rriIndex = rriIndex(rriIndex ~= 0);
end

function puSBPCallback(scr,~,userOpt,pSig,pHandle,pbZoom)
% extract SBP using algorithm indicated in popupmenu

signals = get(pSig,'userData');
oldValue = get(scr,'userData');
newValue = get(scr,'value');

errStat = 0;
if newValue == 3 && isempty(signals.ecg.rri.index)
    uiwait(errordlg(['No RRI extracted! To extract SBP based on RRI, ',...
        'RRI must be extracted first.'],'No RRI extracted','modal'));
    set(scr,'value',1);
    errStat = 1;
elseif ~isempty(signals.bp.sbp.data) && newValue ~=1
    uiwait(errordlg(['SBP already extracted! If you wish to try ',...
        'another algorithm, please clear the SBP first.'],...
        'SBP already extracted','modal'));
    set(scr,'value',oldValue);
    errStat = 1;
end

if ~errStat
    
    options = get(userOpt,'userData');
    type = options.session.ext.sigSpec;
    
    % execute indicated algorithm
    if newValue == 2
        [~,signals.bp.sbp.index,~] = delineator( ...
            signals.bp.(type{2}).data,signals.bp.(type{2}).fs);
        signals.bp.sbp.index = signals.bp.sbp.index(:);
        options.session.ext.alg.sbp = 'Waveform algorithm';
    elseif newValue == 3
        rriTime = signals.ecg.(type{1}).time;
        rriTime = rriTime(signals.ecg.rri.index);
        signals.bp.sbp.index = findSBP(signals.bp.(type{2}).data,...
            signals.bp.(type{2}).time,rriTime,options.session.ext.ts);
        options.session.ext.alg.sbp = 'From RRI';
    end
    
    signals.bp.sbp.ectopic = [];
    signals.bp.sbp.index(~ismember(signals.bp.sbp.ectopic,...
        signals.bp.sbp.index))=[];
    
    if ~isempty(signals.bp.sbp.index)
        % time stamp
        signals.bp.sbp.time = signals.bp.(type{2}).time(...
            signals.bp.sbp.index);
        % systolic blood pressure
        signals.bp.sbp.data = signals.bp.(type{2}).data(...
            signals.bp.sbp.index);
    end
    options.session.ext.proc.bp = 1;
    set(userOpt,'userData',options);
    set(scr,'userData',newValue);
    set(pSig,'userData',signals);
    plotFcn(pHandle,pSig,pbZoom,userOpt);
end
end

function sbpIndex = findSBP(bp,bpTime,rri,TS)
% find SBP indexes from RRI indexes
% original Matlab code: Luisa Santiago C. B. da Silva, Jul. 2015

sbpIndex = [];
leftLen = zeros(length(rri)-1,1);
rightLen = zeros(length(rri)-1,1);
for i=0:length(rri)
    %creates intervals
    if i == 0 %includes space between 0s and first R wave point
        minLim = 1;
        auxLim = rri(i+1);
        maxLim = find(bpTime<=auxLim,1,'last');
        init_int = maxLim-minLim;
    elseif i<= length(rri)-1
        auxLim = rri(i);
        minLim = find(bpTime>=auxLim,1);
        auxLim = rri(i+1);
        maxLim = find(bpTime<=auxLim,1,'last');
    else %includes space between last R wave point and data end
        auxLim = rri(i);
        minLim = find(bpTime>=auxLim,1);
        maxLim = length(bp);
        fin_int = maxLim-minLim;
    end
    maximum = max(bp(minLim:maxLim));
    index = find(bp(minLim:maxLim)==maximum,1)+minLim-1;
    %stores distance between each SBP and the RRI to its left and right
    if i<= length(rri)-1 && i ~= 0
        leftLen(i) = index-rri(i);
        rightLen(i) = rri(i+1)-index;
    end
    sbpIndex=sort([sbpIndex;index]);
end

%discards first and/or last SBP if it is the first or last point of the
%plot, since there's no way to know if the signal would be higher on
%instants before the first or after the last points of the plot

%discards first SBP if the distance between it and the beggining of the
%data (0s) is bigger than the smallest distance found between a SBP and
%its previous DBP, because it is likely that the point found is a high
%point, but not a SBP and therefore the point is discarded (conclusion from
%observation)

%discards last SBP if the distance between it and the end of the data is
%bigger than the smallest distance found between a SBP and its following
%DBP, because it is likely that the point found is a high point, but not a
%SBP and therefore the point is discarded (conclusion from observation)

%discards first and/or last SBP if it is below the SBP/DBP threshold or
%below the lowest SBP found on the rest of the data, because it is likely
%that the point found is a high point, but not a SBP and therefore the
%point is discarded (conclusion from observation)

if init_int < min(rightLen) || sbpIndex(1) == 1
    sbpIndex = sbpIndex(2:length(sbpIndex));
elseif bp(sbpIndex(1)) < min(bp(sbpIndex(2:length(sbpIndex)-1))) || ...
        bp(sbpIndex(1)) < TS
    sbpIndex = sbpIndex(2:length(sbpIndex));
end

if fin_int < min(leftLen) || sbpIndex(length(sbpIndex)) == length(bp)
    sbpIndex = sbpIndex(1:length(sbpIndex)-1);
elseif bp(sbpIndex(length(sbpIndex))) < ...
        min(bp(sbpIndex(2:length(sbpIndex)-1))) || bp(sbpIndex(1)) < TS
    sbpIndex = sbpIndex(1:length(sbpIndex)-1);
end
end

function puDBPCallback(scr,~,userOpt,pSig,pHandle,pbZoom)
% extract DBP using algorithm indicated in popupmenu

signals = get(pSig,'userData');
oldValue = get(scr,'userData');
newValue = get(scr,'value');

errStat = 0;
if newValue == 3 && isempty(signals.bp.sbp.index)
    uiwait(errordlg(['No SBP extracted! To extract DBP based on SBP, ',...
        'SBP must be extracted first.'],'No RRI extracted','modal'));
    set(scr,'value',1);
    errStat = 1;
elseif newValue == 4 && (isempty(signals.ecg.rri.index) || ...
        isempty(signals.bp.sbp.index))
    uiwait(errordlg(['No RRI and/or SBP extracted! To extract DBP ',...
        'based on RRI and SBP, both RRI and SBP must be extracted ',...
        'first.'],'No SBP extracted','modal'));
    set(scr,'value',1);
    errStat = 1;
elseif ~isempty(signals.bp.dbp.data) && newValue ~=1
    uiwait(errordlg(['DBP already extracted! If you wish to try ',...
        'another algorithm, please clear the DBP first.'],...
        'DBP already extracted','modal'));
    set(scr,'value',oldValue);
    errStat = 1;
end

if ~errStat
    options = get(userOpt,'userData');
    type = options.session.ext.sigSpec;
    
    % execute indicated algorithm
    if newValue == 2
        [signals.bp.dbp.index,~,~] = delineator(...
            signals.bp.(type{2}).data,signals.bp.(type{2}).fs);
        signals.bp.dbp.index = signals.bp.dbp.index(:);
        options.session.ext.alg.dbp = 'Waveform algorithm';
    elseif newValue == 3
        signals.bp.dbp.index = findDBP(signals.bp.(type{2}).data,[],...
            signals.bp.sbp.index,1,options.session.ext.ts);
        options.session.ext.alg.dbp = 'From SBP';
    elseif newValue == 4
        rriTime = signals.ecg.(type{1}).time;
        rriTime = rriTime(signals.ecg.rri.index);
        signals.bp.dbp.index = findDBP(signals.bp.(type{2}).data,...
            rriTime,signals.bp.sbp.index,0,options.session.ext.ts,...
            signals.bp.(type{2}).time);
        options.session.ext.alg.dbp = 'From RRI & SBP';
    end
    
    signals.bp.dbp.ectopic = [];
    signals.bp.dbp.index(~ismember(signals.bp.dbp.ectopic,...
        signals.bp.dbp.index))=[];
    
    if ~isempty(signals.bp.dbp.index)
        % time stamp
        signals.bp.dbp.time = signals.bp.(type{2}).time(...
            signals.bp.dbp.index);
        % diastolic blood pressure
        signals.bp.dbp.data = signals.bp.(type{2}).data(...
            signals.bp.dbp.index);
    end
    options.session.ext.proc.bp = 1;
    set(userOpt,'userData',options);
    set(scr,'userData',newValue);
    set(pSig,'userData',signals);
    plotFcn(pHandle,pSig,pbZoom,userOpt);
end
end

function dbpIndex = findDBP(bp,rri,sbp,alg,TS,bpTime)
% find DBP indexes from RRI, SBP or both RRI and SBP indexes
% original Matlab code: Luisa Santiago C. B. da Silva, Jul. 2015

dbpIndex=[];
rightLen=zeros(length(sbp)-1,1);

if alg == 1   %checks between SBPs
    for i=0:length(sbp)-1
        %creates intervals
        if i == 0 %includes space between 0s and first SBP
            minLim = 1;
            maxLim = sbp(i+1);
        else
            minLim = sbp(i);
            maxLim = sbp(i+1);
        end
        %finds lowest point in interval
        minimum = min(bp(minLim:maxLim));
        index = find(bp(minLim:maxLim)==minimum,1)+minLim-1;
        if i ~= 0 %stores distance between the first DBP and the SBP to its right
            rightLen(i) = sbp(i+1)-index;
        end
        dbpIndex=sort([dbpIndex;index]);
    end
    
    %if the distance between the first DBP found (on the 0s-first SBP
    %interval) and the SBP to its right is smaller than the smallest
    %difference found on the rest of the data between DBP points and the SBP
    %points to its right, it is likely that the point found is a low point,
    %but not a DBP and therefore the point is discarded (conclusion from
    %observation)
    if sbp(1)- dbpIndex(1) < min(rightLen)
        dbpIndex = dbpIndex(2:length(dbpIndex));
    end
    
else %checks between R wave point and SBP point to its right
    edges = [-Inf, mean([bpTime(2:end) bpTime(1:end-1)],2)', +Inf];
    [~, ind] = histc(rri,edges);  ind(end) = [];
    %creates intervals
    int = sort([ind;sbp]);
    if sbp(1)<ind(1)
        int = sort([1;int]);
    end
    if sbp(length(sbp))<ind(length(ind))
        int = int(1:length(int)-1);
    end
    
    %finds lowest point in intervals
    for i=1:2:length(int)-1
        minimum = min(bp(int(i):int(i+1)));
        index = find(bp(int(i):int(i+1))==minimum,1)+int(i)-1;
        dbpIndex=sort([dbpIndex;index]);
    end
end

%discards first DBP if it is the first point of the plot, since there's no
%way to know if the signal would be lower on instants before that
%discards first DBP if it is above the SBP/DBP threshold
if dbpIndex(1) == 1
    dbpIndex = dbpIndex(2:length(dbpIndex));
elseif bp(dbpIndex(1)) > TS
    dbpIndex = dbpIndex(2:length(dbpIndex));
end
end

function markEct(~,~,userOpt,pSig,pHandle,pbZoom)
% mark ectopic-beat related variables from mouse click

errStat = 0;
options = get(userOpt,'userData');
signals = get(pSig,'userData');

type = options.session.ext.sigSpec;
curPos = options.session.ext.curPos;
windowLen = options.session.ext.windowLen;
TS = options.session.ext.ts;
if ~isempty(type{2})
    fs = signals.bp.(type{2}).fs;
    ind1 = round((curPos+1/fs)*fs); ind2 = floor(windowLen*fs)-1;
end

if options.session.ext.cbSelection(1) && ~isempty(type{1}) && ...
        isempty(signals.ecg.rri.index)
    uiwait(errordlg(['No RRI extracted! When RRI is selected, ectopic ',...
        'beats must be marked on RRI. RRI must be extracted before ',...
        'marking.'],'No RRI extracted','modal'));
    errStat = 1;
elseif options.session.ext.cbSelection(2) && ~isempty(type{2}) && ...
        isempty(signals.bp.sbp.index) && ...
        (~options.session.ext.cbSelection(1) || isempty(type{1}))
    uiwait(errordlg(['No SBP extracted! When RRI is not selected ',...
        'and SBP is, ectopic beats must be marked on SBP. SBP must',...
        'be extracted before marking.'],'No SBP extracted','modal'));
    errStat = 1;
elseif options.session.ext.cbSelection(3) && ~isempty(type{2}) && ...
        isempty(signals.bp.dbp.index) && ...
        (~options.session.ext.cbSelection(1) || isempty(type{1})) && ...
        ~options.session.ext.cbSelection(2)
    uiwait(errordlg(['No DBP extracted! When only DBP is selected,',...
        ' ectopic beats must be marked on DBP. DBP must be ',...
        'extracted before marking.'],'No DBP extracted','modal'));
    errStat = 1;
elseif (~options.session.ext.cbSelection(1) || isempty(type{1})) && ...
        options.session.ext.cbSelection(2) && ~isempty(type{2}) && ...
        isempty(find(signals.bp.(type{2}).data(signals.bp.sbp.index(...
        signals.bp.sbp.index >= ind1 & signals.bp.sbp.index <= ...
        (ind1+ind2))) > TS,1))
    if floor(0.9*min(signals.bp.(type{2}).data(signals.bp.sbp.index)))>=10
        tsSug = floor(0.9*min(signals.bp.(type{2}).data(...
            signals.bp.sbp.index)));
    else
        tsSug = floor(90*min(signals.bp.(type{2}).data(...
            signals.bp.sbp.index)))/100;
    end
    uiwait(errordlg(['No SBP above threshold! Please adjust the ',...
        'SBP/DBP threshold so there are SBP markings above it in the ',...
        'current window. Check the ''Show on plot'' checkbox to view ',...
        'the threshold. (Suggested SBP/DBP threshold: ',num2str(tsSug),...
        ' mmHg).'],'No SBP above threshold','modal'));
    errStat = 1;
elseif (~options.session.ext.cbSelection(1) || isempty(type{1})) && ...
        ~options.session.ext.cbSelection(2) && ...
        options.session.ext.cbSelection(3) && ~isempty(type{2}) && ...
        isempty(find(signals.bp.(type{2}).data(signals.bp.dbp.index(...
        signals.bp.dbp.index >= ind1 & signals.bp.dbp.index <= ...
        (ind1+ind2)))<TS,1))
    if ceil(1.1*max(signals.bp.(type{2}).data(signals.bp.dbp.index)))>=10
        tsSug = ceil(1.1*max(signals.bp.(type{2}).data(ind1 & ...
            signals.bp.dbp.index)));
    else
        tsSug = ceil(110*max(signals.bp.(type{2}).data(ind1 & ...
            signals.bp.dbp.index)))/100;
    end
    uiwait(errordlg(['No DBP below threshold! Please adjust the ',...
        'SBP/DBP threshold so there are DBP markings below it in the ',...
        'current window. Check the ''Show on plot'' checkbox to view ',...
        'the threshold. (Suggested SBP/DBP threshold: ',num2str(tsSug),...
        ' mmHg).'],'No DBP below threshold','modal'));
    errStat = 1;
elseif options.session.ext.cbSelection(2) && ~isempty(type{2}) && ...
        isempty(signals.bp.sbp.index)
    [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
        'markSBPPref','Marking ectopic variables',sprintf([...
        'Warning!','\nSBP is selected for simultaneous ectopic ',...
        'marking, but SBP has not been extracted yet.\nIf SBP is ',...
        'extracted after marking ectopics, these markings will not',...
        ' be automatically updated.\nThere is an option to later ',...
        'copy the ECG markings from the RRI variables to the ',...
        'corresponding BP variables.\nAre you sure you wish',...
        ' to proceed without extracting SBP first?']),{'Yes','No'},...
        'DefaultButton','No');
    if strcmp(selButton,'no') && dlgShow
        errStat = 1;
    end
elseif options.session.ext.cbSelection(3) && ~isempty(type{2}) && ...
        isempty(signals.bp.dbp.index)
    [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
        'markDBPPref','Marking ectopic variables',sprintf([...
        'Warning!','\nDBP is selected for simultaneous ectopic ',...
        'marking, but DBP has not been extracted yet.\nIf DBP is ',...
        'extracted after marking ectopics, these markings will not',...
        ' be automatically updated.\nThere is an option to later ',...
        'copy the ECG markings from the RRI variables to the ',...
        'corresponding BP variables.\nAre you sure you wish',...
        ' to proceed without extracting DBP first?']),{'Yes','No'},...
        'DefaultButton','No');
    if strcmp(selButton,'no') && dlgShow
        errStat = 1;
    end
end

if ~errStat
    % mark ectopic on RRI
    if options.session.ext.cbSelection(1) && ~isempty(type{1})
        if ~strcmp(type{1},'rri'), aux = 'ecg';
        else, aux = type{1}; end
        index = signals.ecg.rri.ectopic;
        signals.ecg.rri.ectopic = clickMark(index,signals.ecg.rri.index,...
            signals.ecg.(type{1}).data,curPos,windowLen,...
            signals.ecg.(type{1}).fs,[],aux); %type{1} = 'rri'
        options.session.ext.proc.ecg = 1;
    end
    % mark ectopic on SBP
    if options.session.ext.cbSelection(2) && ~isempty(type{2}) && ...
            ~isempty(signals.bp.sbp.index)
        options.session.ext.proc.bp = 1;
        if options.session.ext.cbSelection(1) && ~isempty(type{1})   % from ECG reference
            signals.bp.sbp.ectopic = markFrom(signals.ecg.rri.ectopic+1,...
                signals.ecg.rri.index,signals.ecg.(type{1}).time,...
                signals.bp.sbp.ectopic,signals.bp.sbp.index,...
                signals.bp.(type{2}).time,index+1,1,type{1},type{2});
        else                                      % directly
            index = signals.bp.sbp.ectopic;
            signals.bp.sbp.ectopic = clickMark(index,...
                signals.bp.sbp.index,signals.bp.(type{2}).data,curPos,...
                windowLen,fs,TS,'sbp');
        end
    end
    % mark ectopic on DBP
    if options.session.ext.cbSelection(3) && ~isempty(type{2}) && ...
            ~isempty(signals.bp.dbp.index)
        options.session.ext.proc.bp = 1;
        if options.session.ext.cbSelection(1) && ~isempty(type{1})     % from ECG reference
            signals.bp.dbp.ectopic = markFrom(signals.ecg.rri.ectopic+1,...
                signals.ecg.rri.index,signals.ecg.(type{1}).time,...
                signals.bp.dbp.ectopic,signals.bp.dbp.index,...
                signals.bp.(type{2}).time,index+1,1,type{1},type{2});
        elseif options.session.ext.cbSelection(2) % from SBP reference
            signals.bp.dbp.ectopic = markFrom(signals.bp.sbp.ectopic,...
                signals.bp.sbp.index,signals.bp.(type{2}).time,...
                signals.bp.dbp.ectopic,signals.bp.dbp.index,[],index,2,[],[]);
        else                                      % directly
            signals.bp.dbp.ectopic = clickMark(signals.bp.dbp.ectopic,...
                signals.bp.dbp.index,signals.bp.(type{2}).data,curPos,...
                windowLen,fs,TS,'dbp');
        end
    end
    set(userOpt,'userData',options);
    set(pSig,'userData',signals);
    plotFcn(pHandle,pSig,pbZoom,userOpt);
end
end

function ectIndex = clickMark(ectIndex,varInd,signal,curPos,...
    windowLen,fs,TS,id)
% mark ectopic-beat related variables from mouse click
% Original Matlab code: João Luiz Azevedo de Carvalho, 2002

if ~isempty(TS)
    if strcmp(id,'sbp')
        infLim=TS;
        supLim=max(signal)+10;
    elseif strcmp(id,'dbp')
        infLim=min(signal)-10;
        supLim=TS;
    end
else
    if strcmp(id,'ecg')
        infLim=-1;
        supLim=1;
    else
        infLim=min(signal)-100;
        supLim=max(signal)+100;
    end
end

i = 0;
while i == 0
    [x,y]=ginput(1); % read from mouse
    if (x>=curPos && x<curPos+windowLen && y>=infLim && y<=supLim)
        tol = round(mean(0.15*diff(varInd)));
        mark = round(x*1000)/1000;
        index = round(mark*fs)+1; % sample index
        
        % finds closest variable
        next = find(varInd>=index & varInd<=index+tol,1);
        prev = find(varInd<=index & varInd>=index-tol,1,'last');
        
        if isempty(next) && isempty(prev)
            index = [];
        else
            if isempty(next), next = inf; end
            if isempty(prev), prev = -inf; end
            if next-index < index-prev
                index = next;
            else
                index = prev;
            end
        end
        
        if ~isempty(index)
            if (strcmp(id,'ecg') || strcmp(id,'rri')) && ...
                    isempty(find(ectIndex==index-1, 1))
                ectIndex = sort([ectIndex;index-1]);
                i = 1;
            elseif isempty(find(ectIndex==index, 1))
                ectIndex = sort([ectIndex;index]);
                i = 1;
            end
        end
    else
        i = 1;
    end
end
end

function ectIndex = markFrom(refEct,refIndex,refTime,ectIndex,varIndex,...
    varTime,index,id,type1,type2)
% mark ectopic-beat related variables from click on another variable

for i=1:length(refEct)
    newInd = [];
    %verify if index has been added to ref_indices
    if isempty(find(index==refEct(i),1))
        if isempty(varTime), varTime = refTime; end
        index = find(~ismember(refEct,index),1);
        if id == 1
            if strcmp(type1,'rri')
                lim = [refTime(refEct(index)-1) refTime(refEct(index))];
            else
                lim = [refTime(refIndex(refEct(index))) 0];
                if refIndex(refEct(index)+1) > length(refTime)
                    lim(2) = inf;
                else
                    lim(2) = refTime(refIndex(refEct(index)+1)); 
                end
            end
            if strcmp(type2,'sbp') || strcmp(type2,'dbp')
                newInd = find(varTime>=lim(1) & varTime<=lim(2),1);
            else
                lim1 = find(varTime>=lim(1),1);
                lim2 = find(varTime<=lim(2),1,'last');
            end
        elseif id == 2
            lim2 = find(varTime<=refTime(refIndex(refEct(index))),1,'last');
            if refIndex(refEct(index)-1) < 1
                lim1 = -inf;
            else
                lim1 = find(varTime>=refTime(refIndex(refEct(index)-1)),1);
            end
        end
        if ~strcmp(type2,'sbp') && ~strcmp(type2,'dbp') && ...
                ~isempty(find(varIndex>=lim1 & varIndex<=lim2,1))
            if length(find(varIndex>=lim1 & varIndex<=lim2)) > 1 && id == 2
                newInd = find(varIndex>=lim1 & varIndex<=lim2,1,'last');
            else
                newInd = find(varIndex>=lim1 & varIndex<=lim2,1);
            end
        end
        if ~isempty(newInd)
            ectIndex = sort([ectIndex;newInd]);
        end
    end
end
end

function unmarkEct(~,~,userOpt,pSig,pHandle,pbZoom)
% mark ectopic-beat related variables from mouse click

errStat = 0;
options = get(userOpt,'userData');
signals = get(pSig,'userData');

type = options.session.ext.sigSpec;
curPos = options.session.ext.curPos;
windowLen = options.session.ext.windowLen;
TS = options.session.ext.ts;
if ~isempty(type{2})
    fs = signals.bp.(type{2}).fs;
    ind1 = round((curPos+1/fs)*fs); ind2 = floor(windowLen*fs)-1;
end

if options.session.ext.cbSelection(1) && ~isempty(type{1}) && ...
        isempty(signals.ecg.rri.ectopic)
    uiwait(errordlg(['No ectopic marked on RRI! When RRI is selected, ',...
        'ectopic beats must be unmarked on RRI. To unmark ectopics on ',...
        'other variables, please uncheck RRI from variables selection.',...
        ],'No ectopic on RRI','modal'));
    errStat = 1;
elseif options.session.ext.cbSelection(2) && ~isempty(type{2}) && ...
        isempty(signals.bp.sbp.ectopic)
    if ~options.session.ext.cbSelection(1) || isempty(type{1})
        uiwait(errordlg(['No ectopic marked on SBP! When RRI is not ',...
            'selected and SBP is, ectopic beats must be unmarked on ',...
            'SBP. To unmark ectopics on other variables, please adjust',...
            'variable selection.'],'No ectopic on SBP','modal'));
        errStat = 1;
    end
elseif options.session.ext.cbSelection(3) && ~isempty(type{2}) && ...
        isempty(signals.bp.dbp.ectopic)
    if (~options.session.ext.cbSelection(1) || isempty(type{1})) && ...
            ~options.session.ext.cbSelection(2)
        uiwait(errordlg(['No ectopic marked on DBP! When only DBP is ',...
            'selected, ectopic beats must be unmarked on DBP.'],...
            'No ectopic on DBP','modal'));
        errStat = 1;
    end
elseif (~options.session.ext.cbSelection(1) || isempty(type{1})) && ...
        ~isempty(type{2}) && options.session.ext.cbSelection(2) && ...
        isempty(find(signals.bp.(type{2}).data(signals.bp.sbp.index(...
        signals.bp.sbp.index >= ind1 & signals.bp.sbp.index <= ...
        (ind1+ind2))) > TS,1))
    if floor(0.9*min(signals.bp.(type{2}).data(signals.bp.sbp.index)))>=10
        tsSug = floor(0.9*min(signals.bp.(type{2}).data(...
            signals.bp.sbp.index)));
    else
        tsSug = floor(90*min(signals.bp.(type{2}).data(...
            signals.bp.sbp.index)))/100;
    end
    uiwait(errordlg(['No SBP above threshold! Please adjust the ',...
        'SBP/DBP threshold so there are SBP markings above it in the ',...
        'current window. Check the ''Show on plot'' checkbox to view ',...
        'the threshold. (Suggested SBP/DBP threshold: ',num2str(tsSug),...
        ' mmHg).'],'No SBP above threshold','modal'));
    errStat = 1;
elseif (~options.session.ext.cbSelection(1) || isempty(type{1})) && ...
        ~options.session.ext.cbSelection(2) && ~isempty(type{2}) && ...
        options.session.ext.cbSelection(3) && isempty(find(...
        signals.bp.(type{2}).data(signals.bp.dbp.index(...
        signals.bp.dbp.index > ind1 & signals.bp.dbp.index <= ...
        (ind1+ind2)))<TS,1))
    if ceil(1.1*max(signals.bp.(type{2}).data(signals.bp.dbp.index)))>=10
        tsSug = ceil(1.1*max(signals.bp.(type{2}).data(ind1 & ...
            signals.bp.dbp.index)));
    else
        tsSug = ceil(110*max(signals.bp.(type{2}).data(ind1 & ...
            signals.bp.dbp.index)))/100;
    end
    uiwait(errordlg(['No DBP below threshold! Please adjust the ',...
        'SBP/DBP threshold so there are DBP markings below it in the ',...
        'current window. Check the ''Show on plot'' checkbox to view ',...
        'the threshold. (Suggested SBP/DBP threshold: ',num2str(tsSug),...
        ' mmHg).'],'No DBP below threshold','modal'));
    errStat = 1;
end

if ~errStat
    % unmark ectopic on RRI
    if options.session.ext.cbSelection(1) && ~isempty(type{1})
        if ~strcmp(type{1},'rri'), aux = 'ecg';
        else, aux = type{1}; end
        options.session.ext.proc.ecg = 1;
        index = signals.ecg.rri.ectopic+1;
        signals.ecg.rri.ectopic = clickUnmark(signals.ecg.rri.ectopic,...
            signals.ecg.rri.index,signals.ecg.(type{1}).data,curPos,...
            windowLen,signals.ecg.(type{1}).fs,[],aux);
    end
    % unmark ectopic on SBP
    if options.session.ext.cbSelection(2) && ~isempty(type{2})
        options.session.ext.proc.bp = 1;
        if options.session.ext.cbSelection(1) && ~isempty(type{1})
            if ~isempty(signals.bp.sbp.ectopic)
                signals.bp.sbp.ectopic = unmarkFrom(...
                    signals.ecg.rri.ectopic+1,signals.ecg.rri.index,...
                    signals.ecg.(type{1}).time,signals.bp.sbp.ectopic,...
                    signals.bp.sbp.time,index,1,type{1},type{2});
            end
        else
            index = signals.bp.sbp.ectopic;
            signals.bp.sbp.ectopic = clickUnmark(signals.bp.sbp.ectopic,...
                signals.bp.sbp.index,signals.bp.(type{2}).data,curPos,...
                windowLen,fs,TS,'sbp');
        end
    end
    %unmark ectopic on DBP
    if options.session.ext.cbSelection(3) && ~isempty(type{2})
        options.session.ext.proc.bp = 1;
        if options.session.ext.cbSelection(1) && ~isempty(type{1})
            if ~isempty(signals.bp.dbp.ectopic)
                signals.bp.dbp.ectopic = unmarkFrom(...
                    signals.ecg.rri.ectopic+1,signals.ecg.rri.index,...
                    signals.ecg.(type{1}).time,signals.bp.dbp.ectopic,...
                    signals.bp.dbp.time,index,1,type{1},type{2});
            end
        elseif options.session.ext.cbSelection(2)
            if ~isempty(signals.bp.dbp.ectopic)
                signals.bp.dbp.ectopic = unmarkFrom(...
                    signals.bp.sbp.ectopic,signals.bp.sbp.index,...
                    signals.bp.(type{2}).time,signals.bp.dbp.ectopic,...
                    signals.bp.dbp.time,index,2,type{1},type{2});
            end
        else
            signals.bp.dbp.ectopic = clickUnmark(signals.bp.dbp.ectopic,...
                signals.bp.dbp.index,signals.bp.(type{2}).data,curPos,...
                windowLen,fs,TS,'dbp');
        end
    end
    set(userOpt,'userData',options);
    set(pSig,'userData',signals);
    plotFcn(pHandle,pSig,pbZoom,userOpt);
end
end

function ectIndex = clickUnmark(ectIndex,varIndex,signal,curPos,...
    windowLen,fs,TS,id)
% unmark ectopic-beat related variables from mouse click
% Original Matlab code: João Luiz Azevedo de Carvalho, 2002

if ~isempty(TS)
    if strcmp(id,'sbp')
        infLim=TS;
        supLim=max(signal)+10;
    elseif strcmp(id,'dbp')
        infLim=min(signal)-10;
        supLim=TS;
    end
else
    if strcmp(id,'ecg')
        infLim=-1;
        supLim=1;
    else
        infLim=min(signal)-100;
        supLim=max(signal)+100;
    end
end
if (strcmp(id,'rri') || strcmp(id,'ecg')), ectIndex = ectIndex+1; end

i = 0;
while i == 0
    [x,y]=ginput(1);  % read from mouse
    %se o click foi na area valida...
    if (x>=curPos && x<curPos+windowLen && y>=infLim && y<=supLim)
        tol = round(mean(0.15*diff(varIndex)));
        mark=round(x*1000)/1000;
        index=round(mark*fs)+1; % closest index
        
        % looks for ectopics marked nearby
        nextInd = find(varIndex(ectIndex) >= index & ...
            varIndex(ectIndex) <= index+tol,1);
        next = varIndex(ectIndex(nextInd));
        prevInd = find(varIndex(ectIndex) <= index & ...
            varIndex(ectIndex) >= index-tol,1,'last');
        prev = varIndex(ectIndex(prevInd));
        if ~isempty(next) || ~isempty(prev)
            if isempty(next), nextInd = inf; end
            if isempty(prev), prevInd = -inf; end
            if nextInd-index < index-prevInd
                ectIndex(nextInd)=[];
            else
                ectIndex(prevInd)=[];
            end
            i = 1;
        end
    else
        i = 1;
    end
end
if (strcmp(id,'rri') || strcmp(id,'ecg')), ectIndex = ectIndex-1; end
end

function ectIndex = unmarkFrom(refEct,refIndex,refTime,ectIndex,...
    varTime,index,id,type1,type2)
% unmark ectopic-beat related variables from click on another variable

if ~isempty(find(~ismember(index,refEct),1))
    auxIndex = find(~ismember(index,refEct),1);
    if id == 1      
        if strcmp(type1,'rri')
            lim = [refTime(index(auxIndex)-1) refTime(index(auxIndex))];
        else
            lim = [refTime(refIndex(index(auxIndex))) 0];
            if refIndex(index(auxIndex)+1) > length(refTime)
                lim(2) = inf;
            else
                lim(2) = refTime(refIndex(index(auxIndex)+1));
            end
        end
        if strcmp(type2,'sbp') || strcmp(type2,'dbp')
            newInd = find(varTime>=lim(1) & varTime<=lim(2),1);
        else
            lim1 = find(varTime>=lim(1),1);
            lim2 = find(varTime<=lim(2),1,'last');
        end
    elseif id == 2
        lim2 = find(varTime<=refTime(refIndex(index(auxIndex))),1,'last');
        if refIndex(index(auxIndex)-1) < 1
            lim1 = -inf;
        else
            lim1 = find(varTime>=refTime(refIndex(index(auxIndex)-1)),1);
        end
    end
    if ~strcmp(type2,'sbp') && ~strcmp(type2,'dbp') && ...
            ~isempty(find(varTime>=varTime(lim1) & varTime<=varTime(lim2),1))
        if id == 2 && length(find(varTime>=varTime(lim1) & ...
                varTime<=varTime(lim2)))>1
            newInd = find(varTime>=varTime(lim1) & ...
                varTime<=varTime(lim2),1,'last');
        else
            newInd = find(varTime>=varTime(lim1) & ...
                varTime<=varTime(lim2),1);
        end
    end
    if ~isempty(newInd)
        ectIndex = ectIndex(ectIndex ~= newInd);
    end
end
end

function copyEct(~,~,userOpt,pSig,pHandle,pbZoom)
% copy ectopic variables marked on RRI to selected corresponding variables

errStat = 0;
options = get(userOpt,'userData');
signals = get(pSig,'userData');
type = options.session.ext.sigSpec;

if isempty(signals.ecg.rri.ectopic)
    uiwait(errordlg(['No ectopic marked on RRI! To copy ectopic marks ',...
        'from RRI to other variables, the ectopics must be marked ',...
        'RRI first.'],'No ectopic on RRI','modal'));
    errStat = 1;
elseif isempty(type{2})
    uiwait(errordlg(['No BP opened! The ectopic marks from RRI are ',...
        'copied to SBP or DBP variables extracted from the BP record. ',...
        'The BP record must be opened first.'],...
        'No BP opened','modal'));
    errStat = 1;
elseif sum(options.session.ext.cbSelection(2:3)) == 0
    uiwait(errordlg(['No variables selected! The ectopic marks from ',...
        'RRI are copied to the other variables selected. These ',...
        'other variables must be selected first.'],...
        'No variables selected','modal'));
    errStat = 1;
elseif (options.session.ext.cbSelection(3) && ~isempty(type{2}) && ...
        isempty(signals.bp.dbp.index)) && isempty(signals.bp.sbp.index) ...
        && options.session.ext.cbSelection(2)        
    [selButton, dlgShow] = uigetpref('CRSIDLabPref','copyBothPref',...
        'Marking ectopic variables',sprintf(['Warning!','\nSBP and DBP',...
        ' are selected for copying ectopic marks from RRI, but have ',...
        'not been extracted yet.\nAre you sure you wish to proceed ',...
        'without extracting SBP first?']),{'Yes','No'},'DefaultButton',...
        'No');
    if strcmp(selButton,'no') && dlgShow
        errStat = 1;
    end
elseif ~errStat && options.session.ext.cbSelection(2) && ...
         ~isempty(type{2}) && isempty(signals.bp.sbp.index)
    [selButton, dlgShow] = uigetpref('CRSIDLabPref','copySBPPref',...
        'Marking ectopic variables',sprintf(['Warning!','\nSBP is ',...
        'selected for copying ectopic marks from RRI, but SBP has not ',...
        'been extracted yet.\nAre you sure you wish to proceed without',...
        ' extracting SBP first?']),{'Yes','No'},'DefaultButton','No');
    if strcmp(selButton,'no') && dlgShow
        errStat = 1;
    end
elseif options.session.ext.cbSelection(3) && ~isempty(type{2}) && ...
        isempty(signals.bp.dbp.index)
    [selButton, dlgShow] = uigetpref('CRSIDLabPref','copyDBPPref',...
        'Marking ectopic variables',sprintf(['Warning!','\nDBP is ',...
        'selected for copying ectopic marks from RRI, but DBP has not ',...
        'been extracted yet.\nAre you sure you wish to proceed without',...
        ' extracting DBP first?']),{'Yes','No'},'DefaultButton','No');
    if strcmp(selButton,'no') && dlgShow
        errStat = 1;
    end
end

if ~errStat
    % copy on SBP
    if options.session.ext.cbSelection(2) && ~isempty(signals.bp.sbp.index)
        signals.bp.sbp.ectopic = copyEctAlg(signals.ecg.rri.ectopic+1,...
            signals.ecg.rri.index,signals.bp.sbp.ectopic,...
            signals.bp.sbp.index);
    end
    % copy on DBP
    if options.session.ext.cbSelection(3) && ~isempty(signals.bp.dbp.index)
        signals.bp.dbp.ectopic = copyEctAlg(signals.ecg.rri.ectopic+1,...
            signals.ecg.rri.index,signals.bp.dbp.ectopic,...
            signals.bp.dbp.index);
    end
    options.session.ext.proc.bp = 1;
    set(userOpt,'userData',options);
    set(pSig,'userData',signals);
    plotFcn(pHandle,pSig,pbZoom,userOpt);
end
end

function ectIndex = copyEctAlg(rriEct,rri,ectIndex,varEct)
% ecg_bp_marcaeb2 Generates fiducial points vector and time stamps vector
%
% cur_indices=ecg_bp_marcaeb2(ebs_indices,ebs_ondar,cur_indices,cur_fid)
%   returns vector of indexes of ectopic points correspondig exactly to
%   a vector of fiducial points on a reference signal (ECG)
%
%Inputs:
%   ebs_indices = vector of indexes of ectopic R wave points
%   ecg_ondar = vector of indexes of R wave points
%   cur_indices = vector of indexes of signal to be updated
%   cur_fid = vector of indexes of signal to be updated
%
%Output:
%   cur_indices = updated vector of indexes of ectopic signal points

% original Matlab code: Luisa Santiago C. B. da Silva, Jul. 2015
% based on modules from ECGLab (Carvalho,2001) - more info on manual

for i=1:length(rriEct)
    lim1 = rri(rriEct(i));
    if rriEct(i)+1>length(rri)
        lim2 = inf;
    else
        lim2 = rri(rriEct(i)+1);
    end
    if ~isempty(find(varEct>lim1 & varEct<lim2,1))
        newInd = find(varEct>lim1 & varEct<lim2,1);
        ectIndex = sort([ectIndex;newInd]);
    end
end
end

function correctClick(scr,~,userOpt,pSig,pHandle,pbZoom)
% corrects variables extracted by mouse click
% Original Matlab code: João Luiz Azevedo de Carvalho, 2002

options = get(userOpt,'userData');

if ~isempty(options.session.ext.sigLen) && ...
        ~strcmp(options.session.ext.sigSpec{1},'rri') && ...
        ~strcmp(options.session.ext.sigSpec{2},'sbp') && ...
        ~strcmp(options.session.ext.sigSpec{2},'dbp') 
    
    id = get(scr,'tag');
    signals = get(pSig,'userData');
    
    if strcmp(id,'ecg')
        type = options.session.ext.sigSpec{1};
        varInd = signals.(id).rri.index;
    else
        type = options.session.ext.sigSpec{2};
        ts = options.session.ext.ts;
        varInd = sort([signals.(id).sbp.index;signals.(id).dbp.index]);
    end
    
    signal = signals.(id).(type).data;
    time = signals.(id).(type).time;
    fs = signals.(id).(type).fs;
    
    curPos = options.session.ext.curPos;
    windowLen = options.session.ext.windowLen;
    
    % click position
    clickPoint = get(scr,'CurrentPoint');
    xClick = clickPoint(1,1);
    yClick = clickPoint(2,2);
    
    % click range to look for closest plot element
    yRange = 0.04*abs(max(signal)-min(signal));
    finalPos = curPos+windowLen;
    xRange = 0.01*(finalPos-curPos);
    sRange = round(xRange*fs);
    
    validReg = find(signal >= yClick-yRange & signal <= yClick+yRange & ...
        time >= xClick-xRange & time <= xClick+xRange);
    
    if ~isempty(validReg)
        
        % finds closest indexes (MSE)
        msError = ((xClick-time(validReg))/(finalPos-curPos)).^2 + ...
            ((yClick-signal(validReg))/abs(max(signal)-min(signal))).^2;
        validReg = validReg(msError==min(msError));
        
        % checks for variables marked nearby
        prevVar = find(varInd>=validReg-sRange & varInd<=validReg+sRange);
        varFound = 0;
        if ~isempty(prevVar)
            curVar = signal(varInd(prevVar));
            if any(curVar >= yClick-yRange & curVar <= yClick+yRange)
                varFound = 1;
                % choose closest if there are multiple variables
                if sum(curVar>=yClick-yRange & curVar<=yClick+yRange) >= 2
                    minDist = inf;
                    for i= 1:sum(curVar >= yClick-yRange & curVar <= ...
                            yClick+yRange)
                        distance = sqrt((xClick-time(varInd(...
                            prevVar(i))))^2 + (yClick-curVar(i))^2);
                        if distance <= minDist
                            minDist = distance; index = i;
                        end
                    end
                    prevVar = prevVar(index);
                else
                    prevVar = prevVar(curVar >= yClick-yRange & ...
                        curVar <= yClick+yRange);
                end
            end
        end
        
        % if there's no variable found, mark the closest point
        % if there's a variables found, erase it
        if ~varFound
            if strcmp(id,'ecg')
                varName = 'rri';
            else
                if signal(validReg) >= ts, varName = 'sbp';
                else, varName = 'dbp'; end
            end
            if ~isempty(validReg)
                options.session.ext.proc.(id) = 1;
                varInd = sort([signals.(id).(varName).index;validReg]);
                ectopic = signals.(id).(varName).ectopic;
                if ~isempty(ectopic)
                    addedInd = find(varInd == validReg);
                    if strcmp(id,'ecg'), addedInd = addedInd-1; end
                    ectopic(ectopic >= addedInd) = ...
                        ectopic(ectopic >= addedInd) + 1;
                end
            end
        else
            eraseVar = varInd(prevVar);
            if strcmp(id,'ecg')
                varName = 'rri';
            else
                if signal(eraseVar) >= ts, varName = 'sbp';
                else, varName = 'dbp'; end
            end
            varInd = signals.(id).(varName).index(...
                signals.(id).(varName).index ~= eraseVar);
            ectopic = signals.(id).(varName).ectopic;
            if ~isempty(ectopic)
                eraseInd = find(signals.(id).(varName).index == eraseVar);
                if ~isempty(eraseInd)
                    if strcmp(id,'ecg'), eraseInd = eraseInd-1; end
                    ectopic = ectopic(ectopic ~= eraseInd);
                    ectopic(ectopic>eraseInd) =ectopic(ectopic>eraseInd)-1;
                end
            end
            options.session.ext.proc.(id) = 1;
        end
        
        % clear object properties before adding new ones
        signals.(id).(varName).index = [];
        signals.(id).(varName).ectopic = [];
        signals.(id).(varName).time = [];
        signals.(id).(varName).data = [];
        
        % new object properties
        signals.(id).(varName).index = varInd;
        signals.(id).(varName).ectopic = ectopic;
        if strcmp(id,'ecg')
            auxTime = signals.ecg.(type).time(signals.ecg.rri.index);
            signals.ecg.rri.data = round(diff(round(1000*auxTime)));
            signals.ecg.rri.time = auxTime(2:end);
        else
            signals.(id).(varName).time = signals.(id).(type).time(...
                signals.(id).(varName).index);
            signals.(id).(varName).data = signals.(id).(type).data(...
                signals.(id).(varName).index);
        end
        
        set(userOpt,'userData',options);
        set(pSig,'userData',signals);
        plotFcn(pHandle,pSig,pbZoom,userOpt)
    end
end
end

function zoomFcn(scr,~,pbZoom)
if get(scr,'value') == 0
    set(pbZoom,'enable','off');
else
     set(pbZoom,'enable','on');
end
end

function fixY(~,~,pHandle,pSig,userOpt,tbZoom,pbZoom)

options = get(userOpt,'userData');

if ~isempty(options.session.ext.sigSpec{1}) && ...
        ~isempty(options.session.ext.sigSpec{2})    
    lim = ylim(pHandle.ecg);
    options.session.ext.lo_lim.ecg = lim(1);
    options.session.ext.hi_lim.ecg = lim(2);
    lim = ylim(pHandle.bp);
    options.session.ext.lo_lim.bp = lim(1);
    options.session.ext.hi_lim.bp = lim(2);
else
    id = get(pHandle.full,'tag');
    lim = ylim(pHandle.full);
    options.session.ext.lo_lim.(id) = lim(1);
    options.session.ext.hi_lim.(id) = lim(2);
end

set(userOpt,'userData',options);
set(tbZoom,'value',0);
zoomFcn(tbZoom,[],pbZoom);
plotFcn(pHandle,pSig,pbZoom,userOpt);
end

function resetY(~,~,pHandle,pSig,userOpt,tbZoom,pbZoom)

options = get(userOpt,'userData');
signals = get(pSig,'userData');

if ~isempty(options.session.ext.sigSpec{1}) && ...
        ~isempty(options.session.ext.sigSpec{2})    
    data = signals.ecg.(options.session.ext.sigSpec{1}).data;
    options.session.ext.lo_lim.ecg = min(data)-0.05*abs(max(data)-min(data)); 
    options.session.ext.hi_lim.ecg = max(data)+0.05*abs(max(data)-min(data));
    data = signals.bp.(options.session.ext.sigSpec{2}).data;
    options.session.ext.lo_lim.bp = min(data)-0.05*abs(max(data)-min(data)); 
    options.session.ext.hi_lim.bp = max(data)+0.05*abs(max(data)-min(data));
else
    id = get(pHandle.full,'tag');
    if strcmp(id,'ecg')
        type = options.session.ext.sigSpec{1};
    else
        type = options.session.ext.sigSpec{2};
    end
    data = signals.(id).(type).data;
    options.session.ext.lo_lim.(id) = min(data)-0.05*abs(max(data)-min(data)); 
    options.session.ext.hi_lim.(id) = max(data)+0.05*abs(max(data)-min(data));
end

set(userOpt,'userData',options);
set(tbZoom,'value',0);
zoomFcn(tbZoom,[],pbZoom);
plotFcn(pHandle,pSig,pbZoom,userOpt);
end

function saveConfig(userOpt)
% save session configurations for next session

options = get(userOpt,'userData');
options.ext.windowLen = options.session.ext.windowLen;
options.ext.ts = options.session.ext.ts;
options.ext.showTs = options.session.ext.showTs;
options.ext.cbSelection = options.session.ext.cbSelection;
options.ext.grid.ecg = options.session.ext.grid.ecg;
options.ext.grid.bp = options.session.ext.grid.bp;
options.ext.label = options.session.ext.label;
set(userOpt,'userData',options);
end