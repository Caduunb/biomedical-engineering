function filtMenu(pnFilt,pFile,pSig,userOpt)
% FiltMenu - CRSIDLab 
%   Menu for filtering electrocardiogram (ECG) and continuous blood
%   pressure (BP) data. Any combination of the following filters may be
%   applied, except the high-pass fitler for BP data:
%   - Notch filter: 60Hz power grid noise removal
%   - Low-pass filter: EMG noise removal (cut-off from 20 to 60 Hz)
%   - High-pass filter: baseline wander removal (cut-off up to 1 Hz)
%
% Original Matlab code: João Luiz Azevedo de Carvalho, 2002.
% Adapted to filter BP data and fit new GUI: Luisa Santiago C. B. da Silva,
% April 2017.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Data visualization and slider
%

uicontrol('parent',pnFilt,'style','text','string','Select register:',...
    'hor','left','units','normalized','position',[.032 .93 .1 .03]);
puVar = uicontrol('parent',pnFilt,'style','popupmenu','string',...
    'No data available','value',1,'backgroundColor',[1 1 1],'units',...
    'normalized','position',[.13 .93 .2 .04]);

pHandle = axes('parent',pnFilt,'Units','pixels','Units','normalized',...
    'Position',[.057 .2 .77 .68]);

uicontrol('parent',pnFilt,'style','text','hor','right','string',...
    'Time (seconds) ','fontSize',10,'units','normalized','position',...
    [.73 .12 .1 .035]);

slWindow = uicontrol('parent',pnFilt,'Style','slider','Min',0,'Max',1,...
    'Units','Normalized','Position',[.057 .06 .77 .04]);

pbZoom = zoom;
tbZoom = uicontrol('parent',pnFilt,'Style','toggle','String','Zoom',...
    'value',0,'CallBack',{@zoomFcn,pbZoom},'Units','Normalized',...
    'Position',[.848 .93 .12 .05]);
zoomFcn(tbZoom,[],pbZoom);

pbFixY = uicontrol('parent',pnFilt,'Style','push','String','Fix Y axis',...
    'value',0,'Units','Normalized','Position',[.848 .88 .06 .05]);

pbResetY = uicontrol('parent',pnFilt,'Style','push','String','Reset Y axis',...
    'value',0,'Units','Normalized','Position',[.908 .88 .06 .05]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Filtering options
%

% 60Hz notch filter
pnNotch = uipanel('parent',pnFilt,'Units','Normalized','Position',...
    [.848 .72 .12 .16]);

uicontrol('parent',pnNotch,'style','text','String','Width of Notch',...
    'Units','Normalized','Position',[.11 .78 .78 .2]);

teNotch = uicontrol('parent',pnNotch,'style','edit','tag','notch',...
    'Callback',{@teCallback,userOpt},'Units','Normalized','Position',...
    [.3 .55 .4 .23],'backgroundColor',[1 1 1]);

uicontrol('parent',pnNotch,'style','text','String','(1% to 20%)',...
    'Units','Normalized','Position',[.11 .35 .78 .2]);

uicontrol('parent',pnNotch,'Style','push','String','Filter 60 Hz',...
    'CallBack',{@notch,pSig,userOpt,pHandle},'Units','Normalized',...
    'Position',[.05 .1 .9 .25]);

% Low-pass filter (EMG noise)
pnLowPass = uipanel('parent',pnFilt,'Units','Normalized','Position',...
    [.848 .56 .12 .16]);

uicontrol('parent',pnLowPass,'style','text','String','Low-pass at:',...
    'Units','Normalized','Position',[.11 .78 .78 .2]);

teLow = uicontrol('parent',pnLowPass,'style','edit','tag','lowPass',...
    'Callback',{@teCallback,userOpt},'Units','Normalized','Position',...
    [.3 .55 .4 .23],'backgroundColor',[1 1 1]);

uicontrol('parent',pnLowPass,'style','text','String','(20 to 60 Hz)',...
    'Units','Normalized','Position',[.11 .35 .78 .2]);

uicontrol('parent',pnLowPass,'Style','push','String','Filter HF Noise',...
    'CallBack',{@lowPass,pSig,userOpt,pHandle},'Units','Normalized',...
    'Position',[.05 .1 .9 .25]);

% High-pass filter (baseline wander)
pnHighPass = uipanel('parent',pnFilt,'Units','Normalized','Position',...
    [.848 .4 .12 .16]);

uicontrol('parent',pnHighPass,'style','text','String','High-pass at:',...
    'Units','Normalized','Position',[.11 .78 .78 .2]);

teHigh = uicontrol('parent',pnHighPass,'style','edit','tag','highPass',...
    'Callback',{@teCallback,userOpt},'Units','Normalized','Position',...
    [.3 .55 .4 .23],'backgroundColor',[1 1 1]);

uicontrol('parent',pnHighPass,'style','text','String','(0.001 to 1 Hz)',...
    'Units','Normalized','Position',[.11 .35 .78 .2]);

pbHigh = uicontrol('parent',pnHighPass,'Style','push','String',...
    'F. Baseline Wander','CallBack',{@highPass,pSig,userOpt,pHandle},...
    'Units','Normalized','Position',[.05 .1 .9 .25]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Flip ECG
%

pnFlip = uipanel('parent',pnFilt,'Units','Normalized','Position',...
    [.848 .345 .12 .055]); 

%check box to show SBP/DBP threshold on plot
pbFlip = uicontrol('parent',pnFlip,'Style','push','String','Flip ECG',...
    'CallBack',{@flipECG,pSig,userOpt,pHandle},'Units','Normalized',...
    'Position',[.05 .15 .9 .7]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Restore raw data / Save filtered data
%

pnSave = uipanel('parent',pnFilt,'Units','normalized','Position',...
    [.848 .225 .12 .12]); 

uicontrol('parent',pnSave,'style','push','string','Restore','callback',...
    {@restoreSig,userOpt,pSig,pFile,pHandle},'units','normalized',...
    'position',[.15 .5225 .7 .38]);

uicontrol('parent',pnSave,'Style','push','String','SAVE','CallBack',...
    {@saveSig,userOpt,pFile,pSig,puVar},'Units','Normalized','Position',...
    [.15 .1 .7 .38]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot window length and position options
%

pnViewControl = uipanel('parent',pnFilt,'Units','normalized','Position',...
    [.848 .06 .12 .165]); 

uicontrol('parent',pnViewControl,'Style','text','String',['Cur. ',...
    'Position:'],'Units','Normalized','Position',[.11 .8 .78 .15]);

% window position
teCurPos = uicontrol('parent',pnViewControl,'Style','edit','CallBack',...
    {@curPosCallback,pSig,userOpt,slWindow,pHandle},'Units',...
    'Normalized','Position',[.3 .55 .4 .2],'backgroundColor',[1 1 1]);

% shift window left / right
uicontrol('parent',pnViewControl,'Style','text','String',['Window ',...
    'Length:'],'Units','Normalized','Position',[.11 .35 .78 .15]);

uicontrol('parent',pnViewControl,'Style','push','String','<','tag',...
    'left','Callback',{@shiftCallback,pSig,userOpt,slWindow,...
    teCurPos,pHandle},'Units','normalized','Position',[.11 .1 .18 .2]);

uicontrol('parent',pnViewControl,'Style','push','String','>','tag',...
    'right','Callback',{@shiftCallback,pSig,userOpt,slWindow,...
    teCurPos,pHandle},'Units','Normalized','Position',[.71 .1 .18 .2]);

% show / modify window length
teShift = uicontrol('parent',pnViewControl,'Style','edit','Callback',...
    {@windowLenCallback,pSig,userOpt,teCurPos,slWindow,pHandle},'Units',...
    'Normalized','Position',[.3 .1 .4 .2],'backgroundColor',[1 1 1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Set final callbacks and call opening function (setup)
%

set(puVar,'callback',{@changeVar,userOpt,pFile,pSig,teHigh,pbHigh,...
    pbFlip,teShift,slWindow,pHandle});
set(slWindow,'callback',{@sliderCallback,pSig,userOpt,pHandle,teCurPos});
set(pbFixY,'callback',{@fixY,pHandle,pSig,userOpt,tbZoom,pbZoom});
set(pbResetY,'callback',{@resetY,pHandle,pSig,userOpt,tbZoom,pbZoom});

openFnc(userOpt,pFile,pSig,puVar,slWindow,teNotch,teLow,teCurPos,...
    teShift,teHigh,pbHigh,pbFlip,pHandle);
end

function openFnc(userOpt,pFile,pSig,puVar,slWindow,teNotch,teLow,teCurPos,...
    teShift,teHigh,pbHigh,pbFlip,pHandle)
% adjust initial values of objects

options = get(userOpt,'userData');
patient = get(pFile,'userData');

% string for variable selection popupmenu from available patient data
stringPU = cell(4,1); id = {'ecg','bp'};
for i = 1:2
    if ~isempty(patient.sig.(id{i}).raw.data)
        stringPU{i} = ['Raw ',upper(id{i}),' data'];
    end
    if ~isempty(patient.sig.(id{i}).filt.data)
        stringPU{i+2} = ['Filtered ',upper(id{i}),' data'];
    end
end
stringPU = stringPU(~cellfun(@isempty,stringPU));
if isempty(stringPU), stringPU{1} = 'No data available'; end

% adjust selection value if the variables list has changed
if ~isequal(options.session.filt.varString,stringPU)
    if ~isempty(options.session.filt.varString)
        if ismember(options.session.filt.varString{...
                options.session.filt.varValue},stringPU)
            options.session.filt.varValue = find(ismember(stringPU,...
                options.session.filt.varString{...
                options.session.filt.varValue}));
        else
            options.session.filt.varValue = 1;
        end
    end
    options.session.filt.varString = stringPU;
end

% open data and setup options that depend on the data
set(userOpt,'userData',options);
setup(userOpt,pFile,pSig,teHigh,pbHigh,pbFlip,teShift,slWindow);
options = get(userOpt,'userData');

% setup options that don't depend on the data
set(puVar,'string',options.session.filt.varString);
set(puVar,'value',options.session.filt.varValue);
set(puVar,'userData',options.session.filt.varValue);

options.session.filt.notch = checkLim(options.session.filt.notch,'notch');
set(teNotch,'string',num2str(options.session.filt.notch));

options.session.filt.lowPass = checkLim(options.session.filt.lowPass,...
    'lowPass');
set(teLow,'string',num2str(options.session.filt.lowPass));

options.session.filt.highPass = checkLim(options.session.filt.highPass,...
    'highPass');
set(teHigh,'string',num2str(options.session.filt.highPass));
set(teCurPos,'string',num2str(options.session.filt.curPos));
set(teShift,'string',num2str(options.session.filt.windowLen));

filtPlot(pHandle,pSig,userOpt);
end

function setup(userOpt,pFile,pSig,teHigh,pbHigh,pbFlip,teShift,slWindow)
% open data and setup options that depend on the data

options = get(userOpt,'userData');

% identify selected data
id = ''; type = '';
auxVar = options.session.filt.varString{options.session.filt.varValue};
if ~isempty(strfind(auxVar,'ECG'))
    id = 'ecg'; set(pbFlip, 'Enable', 'on');
    set(teHigh, 'Enable', 'on'); set(pbHigh, 'Enable', 'on');
elseif ~isempty(strfind(auxVar,'BP'))
    id = 'bp'; set(pbFlip, 'Enable', 'off');
    set(teHigh, 'Enable', 'off'); set(pbHigh, 'Enable', 'off');
end
if ~isempty(strfind(auxVar,'Raw')), type = 'raw'; 
elseif ~isempty(strfind(auxVar,'Filtered')), type = 'filt'; end
options.session.filt.sigSpec = {id, type};

% open data and setup options
if ~isempty(type)
    patient = get(pFile,'userData');
    
    % setup optional data if not available
    if isempty(patient.sig.(id).(type).fs)
        if ~isempty(patient.sig.(id).(type).time)
            patient.sig.(id).(type).fs = round(1 / ...
                mean(diff(patient.sig.(id).(type).time))); 
        else
            patient.sig.(id).(type).fs = 1;
        end
    end
    if isempty(patient.sig.(id).(type).time)
        patient.sig.(id).(type).time = ...
            (0:(length(patient.sig.(id).(type).data)-1)) / ...
            patient.sig.(id).(type).fs;
    end
    if strcmp(id,'ecg'), var = {'rri'};
    else var = {'sbp','dbp'}; end
    for i = 1:length(var)
        if ~isempty(patient.sig.(id).(var{i}).data)
            if ~isfield(patient.sig.(id).(var{i}).specs,'type')
                patient.sig.(id).(var{i}).specs.type = 'raw';
            end
        end
    end

    % normalize ECG data
    if strcmp(id,'ecg')
        patient.sig.(id).(type).data = patient.sig.(id).(type).data - ...
            mean(patient.sig.(id).(type).data);
        patient.sig.(id).(type).data = patient.sig.(id).(type).data / ...
            max(patient.sig.(id).(type).data);
    end
    
    % load data
    signals = get(pSig,'userData');
    signals.(id).(type) = patient.sig.(id).(type);
    
    % setup options that depend on the data
    options.session.filt.sigLen = (length(signals.(id).(type).data)-1)/ ...
        signals.(id).(type).fs;
    
    if options.session.filt.sigLen - options.session.filt.windowLen > 0
        set(slWindow,'Max',options.session.filt.sigLen - ...
            options.session.filt.windowLen,'Value',0);
    else
        options.session.filt.windowLen = options.session.filt.sigLen;
        set(teShift,'String',num2str(options.session.filt.windowLen));
        set(slWindow,'Max',0,'Value',0);
    end
    options.session.filt.slider = [0.2 0.4]*...
        (options.session.filt.windowLen/options.session.filt.sigLen);
    set(slWindow,'sliderStep',options.session.filt.slider);
    
    % setup flags
    options.session.filt.flags.notch = 0;
    options.session.filt.flags.lowPass = 0;
    if strcmp(id,'bp'), options.session.filt.flags.highPass = 1;
    else options.session.filt.flags.highPass = 0;
    end
    options.session.filt.flags.flip = 0;

    set(pSig,'userData',signals);
end
options.session.filt.saved = 0;
set(userOpt,'userData',options);
end

function changeVar(scr,~,userOpt,pFile,pSig,teHigh,pbHigh,pbFlip,...
    teShift,slWindow,pHandle)
% change record for filtering

errStat = 0;
oldValue = get(scr,'userData');
newValue = get(scr,'value');

if oldValue ~= newValue
    options = get(userOpt,'userData');
    if ~options.session.filt.saved && ...
            (options.session.filt.flags.notch ||... 
            options.session.filt.flags.lowPass || ...
            options.session.filt.flags.flip || ...
            (options.session.filt.flags.highPass && ...
            strcmp(options.session.filt.sigSpec{1},'ecg')))
        [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
            'changeVarFiltPref','Change data',sprintf([...
            'Warning!','\nThe current data has not been saved. Any ',...
            'modifications will be lost if other data is opened before',...
            ' saving.\nAre you sure you wish to proceed?']),...
            {'Yes','No'},'DefaultButton','No');
        if strcmp(selButton,'no') && dlgShow
            errStat = 1;
        end  
    end
    if ~errStat
        options.session.filt.varValue = newValue;
        set(scr,'userData',newValue);
        set(userOpt,'userData',options);

        setup(userOpt,pFile,pSig,teHigh,pbHigh,pbFlip,teShift,slWindow);
        filtPlot(pHandle,pSig,userOpt);
    else
        set(scr,'value',oldValue);
    end
end
end

function restoreSig(~,~,userOpt,pSig,pFile,pHandle)
% restore record

options = get(userOpt,'userData');
type = options.session.filt.sigSpec{2};
if ~isempty(options.session.filt.sigLen) && ~strcmp(type,'filt')
    id = options.session.filt.sigSpec{1};
    patient = get(pFile,'userData');
    signals = get(pSig,'userData');
    signals.(id).(type) = patient.sig.(id).(type);
    
    options.session.filt.sigLen = (length(signals.(id).(type).data)-1)/ ...
        signals.(id).(type).fs;
    options.session.filt.flags.notch = 0;
    options.session.filt.flags.lowPass = 0;
    options.session.filt.flags.highPass = 0;
    options.session.filt.flags.flip = 0;
    options.session.filt.saved = 0;
    set(userOpt,'userData',options);
    set(pSig,'userData',signals);
    
    filtPlot(pHandle,pSig,userOpt);
end
end

function saveSig(~,~,userOpt,pFile,pSig,puVar)
% save filtered data

options = get(userOpt,'userData');
id = options.session.filt.sigSpec{1};
type = options.session.filt.sigSpec{2};
if ~isempty(options.session.filt.sigLen) && (~strcmp(type,'filt') || ...
        strcmp(id,'ecg'))
    
    errStat = 0; saved = 0;
    flags = options.session.filt.flags;
    
    % verify if there's already filtered data saved
    patient = get(pFile,'userData');
    if ~isempty(patient.sig.(id).filt.data)
        saved = 1;
    end
    
    if ~flags.notch && ~flags.lowPass && ~flags.highPass && ...
            (strcmp(id,'bp') || (strcmp(id,'ecg') && ~flags.flip))
        uiwait(errordlg(['No action performed! You must either filter ',...
            ' or flip (if ECG) the data before saving. Raw data will ',...
            'be made available for the next processing steps. If you ',...
            'do not wish to filter your data, skip this step.'],...
            'No action performed','modal'));
        errStat = 1;
    end
    if ~errStat && saved
        futureData = 0;
        if strcmp(id,'ecg'), var = {'rri'};
        else var = {'sbp','dbp'}; end
        for i = 1:length(var)
            if ~isempty(patient.sig.(id).(var{i}).data)
                if strcmp('filt',patient.sig.(id).(var{i}).specs.type)
                    futureData = 1;
                end
            end
        end
        if futureData
            [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
                'saveFiltOW1Pref','Saving filtered data',sprintf(...
                ['Warning!','\nIt appears that there''s already ',...
                'data saved as this record''s filtered data.\n\n',...
                'ATENTION: There is data saved as at least one of ',...
                'the indicated record''s extracted variable.\n',...
                'Overwriting this record will erase all data derived ',...
                'from it, including any systems or models.\n\nAre you ',...
                'sure you wish to overwrite it?']),{'Yes','No'},...
                'DefaultButton','No');
        else
            [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
                'saveFiltOW2Pref','Saving filtered data',sprintf([...
                'Warning!','\nIt appears that there''s already data ',...
                'saved as this record''s filtered data.\nAre you sure ',...
                'you wish to overwrite it?']),{'Yes','No'},...
                'DefaultButton','No');
        end
        if strcmp(selButton,'no') && dlgShow
            errStat = 1;
        end  
    end
    if ~errStat && (~flags.notch || ~flags.lowPass ||(~flags.highPass &&...
            ~strcmp(options.session.filt.sigSpec{1},'bp'))) && ...
            ~strcmp(type,'filt')
        notchString = ''; lowString = ''; highString = '';
        if ~flags.notch, notchString = '\n Notch'; end
        if ~flags.lowPass, lowString = '\n Low-pass'; end
        if ~flags.highPass, highString = '\n High-pass'; end
        filtString = [notchString,lowString,highString];
        [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
            'saveFiltPref','Saving filtered data',sprintf([...
            'Warning!','\nThe following filters have not been applied:',...
            filtString,'\nAre you sure you wish to save the filtered ',...
            'data?']),{'Yes','No'},'DefaultButton','No');
        if strcmp(selButton,'no') && dlgShow
            errStat = 1;
        end        
    end
    
    if ~errStat
        filename = options.session.filename;
        
        % data specifications
        spec = struct;

        if options.session.filt.flags.notch 
            spec.notch = options.filt.notch;
        end
        if options.session.filt.flags.lowPass
            spec.lowPass = options.filt.lowPass;
        end
        if options.session.filt.flags.highPass && strcmp(id,'ecg')
            spec.highPass = options.filt.highPass;
        end
                
        signals = get(pSig,'userData');
        signals.(id).(type).specs = spec;
        signals.(id).filt = signals.(id).(type);
        patient.sig.(id).filt = signals.(id).filt;
        
        if strcmp(id,'ecg'), var = {'rri'};
        else var = {'sbp','dbp'}; end
        for i = 1:length(var)
            % remove corresponding future data (variables, aligned, sys)
            if ~isempty(patient.sig.(id).(var{i}).data)
                if strcmp('filt',patient.sig.(id).(var{i}).specs.type)
                    patient.sig.(id).(var{i}) = dataPkg.varUnit;
                    prevSys = fieldnames(patient.sys);
                    for j = 1:length(prevSys)
                        if strcmpi(var{i},patient.sys.(prevSys{...
                                j}).data.OutputName) || ...
                                any(ismember(patient.sys.(prevSys{...
                                j}).data.InputName,...
                                upper(var{i})))
                            patient.sys = rmfield(patient.sys,prevSys{j});
                        end
                    end
                end
            
                % adjust 'align & resample' and 'create system' data selection
                puOpt = {'out','in1','in2'}; erasedFlag = 0;
                for j = 1:3
                    if ~isempty(options.session.sys.varString.(puOpt{j}))
                        auxVar = options.session.sys.varString.(puOpt{...
                            j}){options.session.sys.varValue.(puOpt{j})};
                        if erasedFlag || ~isempty(strfind(auxVar,...
                                upper(var{i}))) || (strcmp(var{i},'rri')...
                                && ~isempty(strfind(auxVar,'HR')))
                            options.session.sys.varValue.(puOpt{j}) = 1;
                        end
                        erasedFlag = 1;
                    end
                end
                if ~isempty(options.session.align.varString.(id))
                    auxVar = options.session.align.varString.(id){...
                        options.session.align.varValue.(id)};
                    if ~isempty(strfind(auxVar,upper(var{i}))) || ...
                            (strcmp(var{i},'rri') && ~isempty(strfind(...
                            auxVar,'HR')))
                        options.session.align.varValue.(id) = 1;
                    end
                end
            end
        end

        % add saved data to the popupmenu to choose data
        stringPU = get(puVar,'string');
        if strcmp(options.session.filt.sigSpec{1},'ecg')
            stringPU{end+1} = 'Filtered ECG data';
            stringPU = unique(stringPU,'stable');
            options.session.filt.varValue = find(ismember(stringPU,...
                'Filtered ECG data'));
        else
            stringPU{end+1} = 'Filtered BP data';
            stringPU = unique(stringPU,'stable');
            options.session.filt.varValue = find(ismember(stringPU,...
                'Filtered BP data'));
        end
        
        options.session.filt.saved = 1;
        options.session.filt.varString = stringPU;
        set(puVar,'string',options.session.filt.varString);
        set(puVar,'value',options.session.filt.varValue);
        set(puVar,'userData',options.session.filt.varValue);
        set(userOpt,'userData',options);
        
        set(pFile,'userData',patient);
        save(filename,'patient');
        set(pSig,'userData',signals);
        options.session.filt.sigSpec = {id,'filt'};
        set(userOpt,'userData',options);
        saveConfig(userOpt);
        uiwait(msgbox(['The filtered ',upper(id),' has been saved'],...
            'Variables saved','modal'));
    end
end
end

function sliderCallback(scr,~,pSig,userOpt,pHandle,teCurPos)
% adjust settings according to slider dislocation

options = get(userOpt,'userData');
if ~isempty(options.session.filt.sigLen)
    options.session.filt.curPos = round(1000*get(scr,'Value'))/1000;
    set(userOpt,'userData',options);

    filtPlot(pHandle,pSig,userOpt);
    set(teCurPos,'String',num2str(options.session.filt.curPos));
end      
end

function curPosCallback(scr,~,pSig,userOpt,slWindow,pHandle)
% adjust current window position

options = get(userOpt,'userData');
A=str2double(get(scr,'String'));
if ~isnan(A)
    if ~isempty(options.session.filt.sigLen)
        hiLim = get(slWindow,'Max');
    else
        hiLim = inf;
    end
    
    if A <= hiLim && A >= 0
        options.session.filt.curPos = A;
    elseif A > hiLim
        options.session.filt.curPos = hiLim;
    else
        options.session.filt.curPos = 0;
    end
    
    if ~isempty(options.session.filt.sigLen)
        set(slWindow,'Value',options.session.filt.curPos);
    end
    set(userOpt,'userData',options);

    filtPlot(pHandle,pSig,userOpt);
end
set(scr,'String',num2str(options.session.filt.curPos));
end

function shiftCallback(scr,~,pSig,userOpt,slWindow,teCurPos,pHandle)
% move a full window to the left or right

options = get(userOpt,'userData');
if ~isempty(options.session.filt.sigLen)
    if strcmp(get(scr,'tag'),'left')
        if options.session.filt.curPos-options.session.filt.windowLen >= 0
            options.session.filt.curPos = options.session.filt.curPos - ...
                options.session.filt.windowLen;
        else
            options.session.filt.curPos = 0;
        end
    else
        if options.session.filt.curPos+options.session.filt.windowLen <=...
                get(slWindow,'Max')
            options.session.filt.curPos = options.session.filt.curPos + ...
                options.session.filt.windowLen;
        else
            options.session.filt.curPos = get(slWindow,'Max');
        end
    end

    set(slWindow,'Value',options.session.filt.curPos);
    set(userOpt,'userData',options);

    filtPlot(pHandle,pSig,userOpt);
    set(teCurPos,'String',num2str(options.session.filt.curPos));
end
end

function windowLenCallback(scr,~,pSig,userOpt,teCurPos,slWindow,pHandle)
% modify window length (in seconds)

options = get(userOpt,'userData');
if ~isempty(options.session.filt.sigLen)
    A = str2double(get(scr,'String'));
    if  ~isnan(A)
        if A >= 1 && A <= options.session.filt.sigLen
            options.session.filt.windowLen = round(1000*A)/1000;
            %adapts values for last window
            if A+options.session.filt.curPos >= options.session.filt.sigLen
                options.session.filt.curPos=options.session.filt.sigLen-...
                    options.session.filt.windowLen;
                set(teCurPos,'String',...
                    num2str(options.session.filt.curPos));
                set(slWindow,'Value',options.session.filt.curPos);
            end
        elseif A < 1
            options.session.filt.windowLen = 1;
        else
            options.session.filt.windowLen = options.session.filt.sigLen;
            options.session.filt.curPos = 0;
            set(teCurPos,'String',num2str(0));
            set(slWindow,'Value',options.session.filt.curPos);
        end
        if options.session.filt.sigLen - options.session.filt.windowLen >=0
            set(slWindow,'Max',options.session.filt.sigLen - ...
                options.session.filt.windowLen);
        else
            set(slWindow,'Max',0);
        end

        set(userOpt,'userData',options);
        filtPlot(pHandle,pSig,userOpt);

    end

    options.session.filt.slider = [0.2 0.4]*...
        (options.session.filt.windowLen/options.session.filt.sigLen);
    set(slWindow,'sliderstep',options.session.filt.slider);
    set(scr,'String',num2str(options.session.filt.windowLen));
    set(userOpt,'userData',options);
end
end

function teCallback(scr,~,userOpt)
% adjust filter options

options = get(userOpt,'userData');
if ~isempty(options.session.filt.sigLen)
    A=str2double(get(scr,'string'));
    
    % set boundries according to filter tag
    switch get(scr,'tag')
        case 'notch'
            loLim = 1; hiLim = 20;
            A=round(A);
        case 'lowPass'
            loLim = 20; hiLim = 60;
            A=round(A);
        case 'highPass'
            loLim = 0.001; hiLim = 1;
            A = round(1000*A)/1000;
    end

    if ~isnan(A)
        if A >= loLim && A <= hiLim
            value = A;
        elseif A < loLim
            value = loLim;
        else
            value = hiLim;
        end
        options.session.filt.(get(scr,'tag')) = value;
    end
    
    set(userOpt,'userData',options);
    set(scr,'string',num2str(options.session.filt.(get(scr,'tag'))));
end
end

function flipECG(~,~,pSig,userOpt,pHandle)
% flips ECG if record is upside down

options = get(userOpt,'userData');
if ~isempty(options.session.filt.sigLen)
    signals = get(pSig,'userData');

    id = options.session.filt.sigSpec{1};
    type = options.session.filt.sigSpec{2};
    signals.(id).(type).data = -signals.(id).(type).data;
    
    options.session.filt.flags.flip = 1;
    
    set(userOpt,'userData',options);
    set(pSig,'userData',signals);
    filtPlot(pHandle,pSig,userOpt);
end
end

function notch(~,~,pSig,userOpt,pHandle)
% notch filter: 60 Hz power grid noise removal

errStat = 0;
options = get(userOpt,'userData');
type = options.session.filt.sigSpec{2};

if isempty(options.session.filt.sigLen)
    errStat = 1;
elseif strcmp(type,'filt')
    uiwait(errordlg(['View only! This is already a filtered signal. ',...
        'Only raw data can be filtered. Filtered ECG may still  be ',...
        'flipped.'],'View only','modal'));
    errStat = 1;
elseif options.session.filt.flags.notch
    uiwait(errordlg(['Filter already applied! Notch filter has already',...
        ' been applied to the signal. To apply the filter with a ',...
        'different width, please restore the data fist.'],...
        'Filter already applied','modal'));
    errStat = 1;
end

if ~errStat
    id = options.session.filt.sigSpec{1};
    
    signals = get(pSig,'userData');
    filtData = signals.(id).(type).data;
    fs = signals.(id).(type).fs;
    
    % distance between poles and zeros
    notchWidth = options.session.filt.notch;
    d = notchWidth/100;

    % angles for poles and zeros
    fo = zeros(floor((fs/2)/60),1);
    for k=60:60:fs/2
       fo(k/60)=k;
    end
    theta=fo*pi/(fs/2);

    % find poles and zeros
    z = [exp(1i*theta);exp(-1i*theta)];
    p = (1-d)*z;

    % zero phase filtering
    [B,A] = zp2tf(z,p,1);
    filtData=filtfilt(B,A,filtData);

    % normalize ECG
    if strcmp(id,'ecg')
        filtData=filtData-mean(filtData);
        filtData=filtData/max(filtData);
    end
    
    signals.(id).(type).data = filtData;
    options.session.filt.flags.notch = 1;
    options.filt.notch = options.session.filt.notch;
    set(userOpt,'userData',options);
    set(pSig,'userData',signals);
    
    filtPlot(pHandle,pSig,userOpt);
end
end

function lowPass(~,~,pSig,userOpt,pHandle)
% low-pass filter: EMG noise removal

errStat = 0;
options = get(userOpt,'userData');
type = options.session.filt.sigSpec{2};

if isempty(options.session.filt.sigLen)
    errStat = 1;
elseif strcmp(type,'filt')
    uiwait(errordlg(['View only! This is already a filtered signal. ',...
        'Only raw data can be filtered. Filtered ECG may still be ',...
        'flipped.'],'View only','modal'));
    errStat = 1;
elseif options.session.filt.flags.lowPass
    uiwait(errordlg(['Filter already applied! Low-pass filter has ',...
        'already been applied to the signal. To apply the filter with ',...
        'a different cut-off frequency, please restore the data fist.'],...
        'Filter already applied','modal'));
    errStat = 1;
end

if ~errStat
    id = options.session.filt.sigSpec{1};
    
    signals = get(pSig,'userData');
    filtData = signals.(id).(type).data;
    
    % zero phase filtering
    [B,A] = butter(2,options.session.filt.lowPass/...
        (signals.(id).(type).fs/2));
    filtData=filtfilt(B,A,filtData);

    if strcmp(id,'ecg')
        filtData=filtData-mean(filtData);
        filtData=filtData/max(filtData);
    end
    
    signals.(id).(type).data = filtData;
    options.session.filt.flags.lowPass = 1;
    options.filt.lowPass = options.session.filt.lowPass;
    set(userOpt,'userData',options);
    set(pSig,'userData',signals);
    
    filtPlot(pHandle,pSig,userOpt);
end
end

function highPass(~,~,pSig,userOpt,pHandle)
% high-pass filter: baseline wander removal

errStat = 0;
options = get(userOpt,'userData');
type = options.session.filt.sigSpec{2};

if isempty(options.session.filt.sigLen)
    errStat = 1;
elseif strcmp(type,'filt')
    uiwait(errordlg(['View only! This is already a filtered signal. ',...
        'Only raw data can be filtered. Filtered ECG may still be ',...
        'flipped.'],'View only','modal'));
    errStat = 1;
elseif options.session.filt.flags.highPass
    uiwait(errordlg(['Filter already applied! High-pass filter has ',...
        'already been applied to the signal. To apply the filter with ',...
        'a different cut-off frequency, please restore the data fist.'],...
        'Filter already applied','modal'));
    errStat = 1;
end

if ~errStat
    id = options.session.filt.sigSpec{1};
    signals = get(pSig,'userData');
    
    % zero phase filtering
    filtData = signals.(id).(type).data;
    [B,A] = butter(2,options.session.filt.highPass / ...
        (signals.(id).(type).fs/2),'high');
    filtData=filtfilt(B,A,filtData);

    % normalize ECG data
    filtData=filtData-mean(filtData);
    filtData=filtData/max(filtData);
    
    signals.(id).(type).data = filtData;
    options.session.filt.flags.highPass = 1;
    options.filt.highPass = options.session.filt.highPass;
    set(userOpt,'userData',options);
    set(pSig,'userData',signals);
    
    filtPlot(pHandle,pSig,userOpt);
end
end

function value = checkLim(value,tag)

switch tag
    case 'notch'
        loLim = 1; hiLim = 20;
    case 'lowPass'
        loLim = 20; hiLim = 60;
    case 'highPass'
        loLim = 0.001; hiLim = 1;
end

if value < loLim, value = loLim; end
if value > hiLim, value = hiLim; end
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
lim = ylim;
options.session.filt.lo_lim = lim(1);
options.session.filt.hi_lim = lim(2);

set(userOpt,'userData',options);
set(tbZoom,'value',0);
zoomFcn(tbZoom,[],pbZoom);
filtPlot(pHandle,pSig,userOpt);
end

function resetY(~,~,pHandle,pSig,userOpt,tbZoom,pbZoom)

options = get(userOpt,'userData');

id = options.session.filt.sigSpec{1};
type = options.session.filt.sigSpec{2};
signals = get(pSig,'userData');
data = signals.(id).(type).data;

options.session.filt.lo_lim = min(data)-0.05*abs(max(data)-min(data)); 
options.session.filt.hi_lim = max(data)+0.05*abs(max(data)-min(data));

set(userOpt,'userData',options);
set(tbZoom,'value',0);
zoomFcn(tbZoom,[],pbZoom);
filtPlot(pHandle,pSig,userOpt);
end

function saveConfig(userOpt)
% save session configurations for next session

options = get(userOpt,'userData');
options.filt.windowLen = options.session.filt.windowLen;
options.filt.notch = options.session.filt.notch;
options.filt.lowPass = options.session.filt.lowPass;
options.filt.highPass = options.session.filt.highPass;
set(userOpt,'userData',options);
end