function respMenu(pnResp,pFile,pSig,userOpt)
% RespMenu - CRSIDLab
%   Menu for conditioning instantaneous lung volume (ILV) data. Performs
%   integration and detrending of airflow data to obtain ILV data and 
%   allows filtering of ILV when necessary.
%
% Original Matlab code: Luisa Santiago C. B. da Silva, April 2017.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Data visualization and slider
%

uicontrol('parent',pnResp,'style','text','string','Select register:',...
    'hor','left','units','normalized','position',[.032 .93 .1 .03]);
puVar = uicontrol('parent',pnResp,'style','popupmenu','string',...
    'No data available','value',1,'backgroundColor',[1 1 1],'units',...
    'normalized','position',[.13 .93 .2 .04]);

pHandle = axes('parent',pnResp,'Units','pixels','Units','normalized',...
    'Position',[.057 .2 .77 .68]);

uicontrol('parent',pnResp,'style','text','hor','right','string',...
    'Time (seconds) ','fontSize',10,'units','normalized','position',...
    [.73 .12 .1 .035]);

slWindow = uicontrol('parent',pnResp,'Style','slider','Min',0,'Max',1,...
    'Units','Normalized','Position',[.057 .06 .77 .04]);

pbZoom = zoom;
tbZoom = uicontrol('parent',pnResp,'Style','toggle','String','Zoom',...
    'value',0,'CallBack',{@zoomFcn,pbZoom},'Units','Normalized',...
    'Position',[.848 .93 .12 .05]);
zoomFcn(tbZoom,[],pbZoom);

pbFixY = uicontrol('parent',pnResp,'Style','push','String','Fix Y axis',...
    'value',0,'Units','Normalized','Position',[.848 .88 .06 .05]);

pbResetY = uicontrol('parent',pnResp,'Style','push','String','Reset Y axis',...
    'value',0,'Units','Normalized','Position',[.908 .88 .06 .05]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Integration (L/s to L)
%

pnInt = uipanel('parent',pnResp,'Units','Normalized','Position',...
    [.848 .79 .12 .09]);

%text explaining purpose of integration
uicontrol('parent',pnInt,'style','text','String','Airflow to ILV',...
    'Units','Normalized','Position',[.05 .45 .9 .5]);

%button to integrate
uicontrol('parent',pnInt,'Style','push','String','Integrate','CallBack',...
    {@integrateAirflow,pSig,userOpt,pHandle},'Units','Normalized',...
    'Position',[.05 .05 .9 .45]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Tab group: detrend integrated data or filter ILV data
%

tbDetResp = uicontrol('parent',pnResp,'style','toggle','tag','det',...
    'string','Detrend','units','normalized','Position',...
    [ .848 .7425 .05 .044]);

tbFiltResp = uicontrol('parent',pnResp,'style','toggle','tag','filt',...
    'string','Filter','units','normalized','Position',...
    [ .897 .7425 .05 .044]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Detrend panel
%

% high-pass filter
pnDetrend = uipanel('parent',pnResp,'Units','Normalized',...
    'Position',[.848 .345 .12 .399],'visible','on');

cbHigh = uicontrol('parent',pnDetrend,'style','check','String',...
    'High-pass at:','userData',1,'Units','Normalized','Position',...
    [.05 .9 .9 .09]);

teHigh = uicontrol('parent',pnDetrend,'style','edit','tag','highPass',...
    'Callback',{@teCallback,userOpt},'backgroundcolor',[1 1 1],'Units',...
    'Normalized','Position',[.3 .81 .4 .09]);

uicontrol('parent',pnDetrend,'style','text','String',['(0.01 to ',...
    '0.15 Hz)'],'Units','Normalized','Position',[.05 .74 .9 .07]);

% polynomial detrend
cbPoly = uicontrol('parent',pnDetrend,'style','check','String',...
    'Polynomial','userData',2,'Units','Normalized','Position',...
    [.05 .65 .9 .09]);

txPoly = uicontrol('parent',pnDetrend,'style','text','String',...
    'detrend of order:','Units','Normalized','Position',[.05 .58 .9 .07]);

tePoly = uicontrol('parent',pnDetrend,'style','edit','tag','polyOrd',...
    'callback',{@teCallback,userOpt},'backgroundcolor',[1 1 1],'Units',...
    'Normalized','Position',[.3 .49 .4 .09]);

uicontrol('parent',pnDetrend,'style','text','String','(1 to 10)',...
    'Units','Normalized','Position',[.05 .42 .9 .07]);

% linear detrend
cbLinear = uicontrol('parent',pnDetrend,'style','check','String',...
    'Linear detrend','Callback',{@cbCallback,userOpt,cbPoly,cbHigh,...
    txPoly},'userData',3,'Units','Normalized','Position',[.05 .33 .9 .09]);

% compare methods
uicontrol('parent',pnDetrend,'Style','push','String','Compare Methods',...
    'CallBack',{@compDetrend,pSig,userOpt,pHandle},'Units','Normalized',...
    'Position',[.05 .22 .9 .09]);

% exit comparison
uicontrol('parent',pnDetrend,'Style','push','tag','det','String',...
    'Exit Comparison','CallBack',{@exitComp,pSig,userOpt,pHandle},...
    'Units','Normalized','Position',[.05 .12 .9 .09]);

% detrend
uicontrol('parent',pnDetrend,'Style','push','String','Detrend',...
    'callback',{@applyDetrend,pSig,userOpt,pHandle},'Units',...
    'Normalized','Position',[.05 .02 .9 .09]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Filter panel
%

pnFilt = uipanel('parent',pnResp,'Units','Normalized','Position',...
    [.848 .345 .12 .399],'visible','off');

% first low-pass filter
rbFilt1 = uicontrol('parent',pnFilt,'style','radio','String',...
    'Cut-off freq.','userData',1,'Units','Normalized','Position',...
    [.05 .88 .9 .09]);

uicontrol('parent',pnFilt,'style','text','String',['for first filter ',...
    'at:'],'Units','Normalized','Position',[.05 .81 .9 .07]);

teFilt1 = uicontrol('parent',pnFilt,'style','edit','tag','lowPass1',...
    'Callback',{@teCallback,userOpt},'backgroundColor',[1 1 1],'Units',...
    'Normalized','Position',[.3 .72 .4 .09]);

uicontrol('parent',pnFilt,'style','text','String','(1 to 4 Hz)','Units',...
    'Normalized','Position',[.05 .65 .9 .07]);

% second low-pass filter
rbFilt2 = uicontrol('parent',pnFilt,'style','radio','String',...
    'Cut-off freq.','callback',{@rbCallback,userOpt,rbFilt1},'userData',...
    2,'Units','Normalized','Position',[.05 .56 .9 .09]);

uicontrol('parent',pnFilt,'style','text','String',['for second filter ',...
    'at:'],'Units','Normalized','Position',[.05 .49 .9 .07]);

teFilt2 = uicontrol('parent',pnFilt,'style','edit','tag','lowPass2',...
    'Callback',{@teCallback,userOpt},'backgroundColor',[1 1 1],'Units',...
    'Normalized','Position',[.3 .4 .4 .09]);

uicontrol('parent',pnFilt,'style','text','String','(1 to 4 Hz)','Units',...
    'Normalized','Position',[.05 .33 .9 .07]);

% compare filters
uicontrol('parent',pnFilt,'Style','push','String','Compare Filters',...
    'CallBack',{@compFilt,pSig,userOpt,pHandle},'Units','normalized',...
    'Position',[.05 .22 .9 .09]);

% exit comparison
uicontrol('parent',pnFilt,'Style','push','tag','filt','String',...
    'Exit Comparison','CallBack',{@exitComp,pSig,userOpt,pHandle},...
    'Units','normalized','Position',[.05 .12 .9 .09]);

% apply filter
uicontrol('parent',pnFilt,'Style','push','String','Filter HF noise',...
    'CallBack',{@applyFilter,pSig,userOpt,pHandle},'Units','normalized',...
    'Position',[.05 .02 .9 .09]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Restore raw data / Save filtered data
%

pnSave = uipanel('parent',pnResp,'Units','normalized','Position',...
    [.848 .225 .12 .12]);

uicontrol('parent',pnSave,'style','push','string','Restore','callback',...
    {@restoreSig,userOpt,pSig,pHandle},'units','normalized','position',...
    [.15 .5225 .7 .38]);

uicontrol('parent',pnSave,'Style','push','String','SAVE','CallBack',...
    {@saveSig,userOpt,pFile,pSig,puVar},'Units','Normalized','Position',...
    [.15 .1 .7 .38]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot window length and position options
%

pnViewControl = uipanel('parent',pnResp,'Units','normalized','Position',...
    [.848 .06 .12 .165]);

uicontrol('parent',pnViewControl,'Style','text','String',['Cur. ',...
    'Position:'],'Units','Normalized','Position',[.11 .8 .78 .15]);

% show / modify current window position
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

set(cbHigh,'callback',{@cbCallback,userOpt,cbPoly,cbLinear,txPoly});
set(cbPoly,'callback',{@cbCallback,userOpt,cbHigh,cbLinear,[]});

set(rbFilt1,'callback',{@rbCallback,userOpt,rbFilt2});

set(tbDetResp,'callback',{@tabChange,tbDetResp,pnDetrend,tbFiltResp,...
    pnFilt,userOpt});
set(tbFiltResp,'callback',{@tabChange,tbDetResp,pnDetrend,tbFiltResp,...
    pnFilt,userOpt});

set(puVar,'callback',{@changeVar,userOpt,pFile,pSig,pHandle});
set(slWindow,'callback',{@sliderCallback,pSig,userOpt,pHandle,teCurPos});

set(pbFixY,'callback',{@fixY,pHandle,pSig,userOpt,tbZoom,pbZoom});
set(pbResetY,'callback',{@resetY,pHandle,pSig,userOpt,tbZoom,pbZoom});

openFnc(userOpt,pFile,pSig,puVar,slWindow,tbDetResp,pnDetrend,cbHigh,...
    teHigh,cbPoly,tePoly,txPoly,cbLinear,tbFiltResp,pnFilt,rbFilt1,...
    teFilt1,rbFilt2,teFilt2,teCurPos,teShift,pHandle);
end

function openFnc(userOpt,pFile,pSig,puVar,slWindow,tbDetResp,pnDetrend,...
    cbHigh,teHigh,cbPoly,tePoly,txPoly,cbLinear,tbFiltResp,pnFilt,...
    rbFilt1,teFilt1,rbFilt2,teFilt2,teCurPos,teShift,pHandle)
% adjust initial values of objects

options = get(userOpt,'userData');
patient = get(pFile,'userData');

% string for variable selection popupmenu from available patient data
id = {'raw','int','ilv','filt'};
name = {'Raw airflow data','Integrated airflow data','ILV data',...
    'Filtered ILV data'};
stringPU = cell(4,1);
for i = 1:4
    if ~isempty(patient.sig.rsp.(id{i}).data)
        stringPU{i} = name{i};
    end
end
stringPU = stringPU(~cellfun(@isempty,stringPU));
if isempty(stringPU), stringPU{1} = 'No data available'; end

if ~isequal(options.session.resp.varString,stringPU)
    if ~isempty(options.session.resp.varString)
        if ismember(options.session.resp.varString{...
                options.session.resp.varValue},stringPU)
            options.session.resp.varValue = find(ismember(stringPU,...
                options.session.resp.varString{...
                options.session.resp.varValue}));
        else
            options.session.resp.varValue = 1;
        end
    end
    options.session.resp.varString = stringPU;
end

% open data and setup options that depend on the data
set(userOpt,'userData',options);
setup(userOpt,pFile,pSig);
options = get(userOpt,'userData');

% setup options that don't depend on the data
switch options.session.nav.resp
    case 0
        set(tbDetResp,'value',1);
        tabChange(tbDetResp,[],tbDetResp,pnDetrend,tbFiltResp,pnFilt,...
            userOpt);
    case 1
        set(tbFiltResp,'value',1);
        tabChange(tbFiltResp,[],tbDetResp,pnDetrend,tbFiltResp,pnFilt,...
            userOpt);
end

set(puVar,'string',options.session.resp.varString);
set(puVar,'value',options.session.resp.varValue);
set(puVar,'userData',options.session.resp.varValue);

options.session.resp.highPass = checkLim(options.session.resp.highPass,...
    'high');
set(teHigh,'string',options.session.resp.highPass);

options.session.resp.polyOrd = checkLim(options.session.resp.polyOrd,...
    'poly');
set(tePoly,'string',options.session.resp.polyOrd);

options.session.resp.lowPass1 = checkLim(options.session.resp.lowPass1,...
    'filt');
set(teFilt1,'string',options.session.resp.lowPass1);

options.session.resp.lowPass2 = checkLim(options.session.resp.lowPass2,...
    'filt');
set(teFilt2,'string',options.session.resp.lowPass2);
set(teCurPos,'string',num2str(options.session.resp.curPos));
set(teShift,'string',num2str(options.session.resp.windowLen));

if options.session.resp.rbSelection == 1
    set(rbFilt1,'value',1);
    set(rbFilt2,'value',0);
elseif options.session.resp.rbSelection == 2
    set(rbFilt1,'value',0);
    set(rbFilt2,'value',1);
end

set(cbHigh,'value',options.session.resp.cbSelection(1));
set(cbPoly,'value',options.session.resp.cbSelection(2));
set(cbLinear,'value',options.session.resp.cbSelection(3));
if sum(options.session.resp.cbSelection) == 1
    if options.session.resp.cbSelection(1)
        set(cbHigh,'enable','off');
    elseif options.session.resp.cbSelection(2)
        set(cbPoly,'enable','off'); set(txPoly,'enable','off');
    else
        set(cbLinear,'enable','off');
    end
else
    set(cbHigh,'enable','on'); set(cbLinear,'enable','on');
    set(cbPoly,'enable','on'); set(txPoly,'enable','on');
end

if ~isempty(options.session.resp.sigLen)
    if options.session.resp.sigLen - options.session.resp.windowLen > 0
        set(slWindow,'Max',options.session.resp.sigLen - ...
            options.session.resp.windowLen,'Value',0);
    else
        options.session.resp.windowLen = options.session.resp.sigLen;
        set(teShift,'String',num2str(options.session.resp.windowLen));
        set(slWindow,'Max',0,'Value',0);
    end
    options.session.resp.slider = [0.2 0.4]*...
        (options.session.resp.windowLen/options.session.resp.sigLen);
    set(slWindow,'sliderStep',options.session.resp.slider);
end

set(userOpt,'userData',options);
respPlot(pHandle,pSig,userOpt);
end

function setup(userOpt,pFile,pSig)
% open data and setup options that depend on the data

options = get(userOpt,'userData');

% identify selected data
auxVar = options.session.resp.varString{options.session.resp.varValue};

type = '';
if ~isempty(strfind(auxVar,'airflow'))
    if ~isempty(strfind(auxVar,'Raw')), type='raw';
    else type='int'; end
elseif ~isempty(strfind(auxVar,'ILV'))
    if ~isempty(strfind(auxVar,'Filtered')), type = 'filt';
    else type = 'ilv'; end
end
options.session.resp.sigSpec = type;

% open data and setup options
if ~isempty(type)
    patient = get(pFile,'userData');
    signals = get(pSig,'userData');
    
    if isempty(patient.sig.rsp.(type).fs)
        if ~isempty(patient.sig.rsp.(type).time)
            patient.sig.rsp.(type).fs = round(1 / mean(diff(...
                patient.sig.rsp.(type).time)));
        else
            patient.sig.rsp.(type).fs = 1;
        end
    end
    if isempty(patient.sig.rsp.(type).time)
        patient.sig.rsp.(type).time = (0:(length(...
            patient.sig.rsp.(type).data)-1)) / patient.sig.rsp.(type).fs;
    end
    signals.rsp.(type) = patient.sig.rsp.(type);
    options.session.resp.sigLen = (length(signals.rsp.(type).data) - 1) / ...
        signals.rsp.(type).fs;
    
    options.session.resp.flags.int = 0;
    options.session.resp.flags.det = 0;
    options.session.resp.flags.filt = 0;
    options.session.resp.flags.compMode = 0;
    
    patient.sig.rsp.(type) = signals.rsp.(type);
    set(pFile,'userData',patient);
    set(pSig,'userData',signals);
end
options.session.resp.saved = 0;
set(userOpt,'userData',options);
end

function changeVar(scr,~,userOpt,pFile,pSig,pHandle)
% change record for variable extraction

errStat = 0;
oldValue = get(scr,'userData');
newValue = get(scr,'value');

if oldValue ~= newValue
    options = get(userOpt,'userData');
    if ~options.session.resp.saved && (options.session.resp.flags.int ||...
            options.session.resp.flags.det || ...
            options.session.resp.flags.filt)
        [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
            'changeVarRespPref','Change data',sprintf([...
            'Warning!','\nThe current data has not been saved. Any ',...
            'modifications will be lost if other data is opened before',...
            ' saving.\nAre you sure you wish to proceed?']),...
            {'Yes','No'},'DefaultButton','No');
        if strcmp(selButton,'no') && dlgShow
            errStat = 1;
        end
    end
    if ~errStat
        options = get(userOpt,'userData');
        options.session.resp.varValue = newValue;
        options.session.resp.flags.compMode = 0;
        set(scr,'userData',newValue);
        set(userOpt,'userData',options);
        
        setup(userOpt,pFile,pSig);
        respPlot(pHandle,pSig,userOpt);
    else
        set(scr,'value',oldValue);
    end
end
end

function restoreSig(~,~,userOpt,pSig,pHandle)
% restore selected records from disk

errStat = 0;
options = get(userOpt,'userData');
type = options.session.resp.sigSpec;

if options.session.resp.flags.compMode
    uiwait(errordlg(['Comparison mode! To restore the data, first exit',...
        ' comparison mode.'],'Comparison mode','modal'));
    errStat = 1;
end

if ~errStat && ~isempty(options.session.resp.sigLen) && ...
        (options.session.resp.flags.int || ...
        options.session.resp.flags.det || options.session.resp.flags.filt)
    signals = get(pSig,'userData');
    
    if strcmp(type,'filt') && ~isempty(signals.rsp.ilv.data)
        type = 'ilv'; signals.rsp.filt = dataPkg.ilvUnit;
    end
    if strcmp(type,'ilv') && ~isempty(signals.rsp.int.data)
        type = 'int'; signals.rsp.ilv = dataPkg.ilvUnit;
    end
    if strcmp(type,'int') && ~isempty(signals.rsp.raw.data)
        type = 'raw'; signals.rsp.int = dataPkg.dataUnit;
    end
    options.session.resp.sigSpec = type;
    options.session.resp.flags.int = 0;
    options.session.resp.flags.det = 0;
    options.session.resp.flags.filt = 0;
    options.session.resp.saved = 0;
    
    set(userOpt,'userData',options);
    set(pSig,'userData',signals);
    
    respPlot(pHandle,pSig,userOpt);
end
end

function saveSig(~,~,userOpt,pFile,pSig,puVar)
% save selected data

options = get(userOpt,'userData');
type = options.session.resp.sigSpec;
flags = options.session.resp.flags;
if ~isempty(options.session.resp.sigLen) && ...
        (~strcmp(type,'filt') || flags.filt)
    
    errStat = 0; saved = 0;
    
    % verify if there's already integrated/ilv data saved
    patient = get(pFile,'userData');
    if ~isempty(patient.sig.rsp.(type).data)
        saved = 1;
    end
    
    if flags.compMode
        uiwait(errordlg(['Comparison mode! To save the data, first ',...
            'exit comparison mode or apply a detrending method.'],...
            'Comparison mode','modal'));
        errStat = 1;
    elseif ~flags.int && ~flags.det && ~flags.filt
        uiwait(errordlg(['No changes made! You must at least integrate',...
            ' raw aiflow data or detrend integrated data or filter ILV',...
            ' data before saving. If you do not wish to process your ',...
            'data, skip this step.'],'No changes made','modal'));
        errStat = 1;
    end
    
    if saved && ~errStat
        if (~isempty(patient.sig.rsp.ilv.aligned.data) && ...
                flags.det) || (flags.filt && ...
                ~isempty(patient.sig.rsp.filt.aligned.data))
            [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
                'saveRespOW1Pref','Saving respiration data',sprintf(...
                ['Warning!','\nIt appears that there''s already ',...
                'data saved as this record''s processed data.\n\n',...
                'ATENTION: There is data saved as this record''s ',...
                'Aligned & Resample data.\nOverwriting this record ',...
                'will erase all data derived from it, including ',...
                'any systems or models.\n\nAre you sure you wish ',...
                'to overwrite it?']),{'Yes','No'},'DefaultButton',...
                'No');
        else
            [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
                'saveRespOW2Pref','Saving respiration data',sprintf(...
                ['Warning!','\nIt appears that there''s already ',...
                'data saved as this record''s processed data.\nAre',...
                ' you sure you wish to overwrite it?']),...
                {'Yes','No'},'DefaultButton','No');
        end
        if strcmp(selButton,'no') && dlgShow
            errStat = 1;
        end
    end
    if ~errStat && (~flags.int || ~flags.det || ~flags.filt)
        intString = ''; detString = ''; filtString = '';
        if ~flags.int && strcmp(type,'raw')
            intString='\n Integration';
        end
        if ~flags.det && strcmp(type,'int')
            detString='\n Detrending';
        end
        if ~flags.filt && strcmp(type,'ilv')
            filtString='\n Filtering';
        end
        respString = [intString,detString,filtString];
        if ~isempty(respString)
            [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
                'saveRespPref','Saving respiration data',sprintf([...
                'Warning!','\nThe following processing steps have not ',...
                'been performed:',respString,'\nAre you sure you wish ',...
                'to save ?']),{'Yes','No'},'DefaultButton','No');
            if strcmp(selButton,'no') && dlgShow
                errStat = 1;
            end
        end
    end
    
    if ~errStat
        filename = options.session.filename;
        signals = get(pSig,'userData');
        intSaved = ''; detSaved = ''; filtSaved = '';
        
        % save data from selected signals
        if flags.int
            if ~isempty(signals.rsp.raw.data)
                spec = struct; type = 'int';
                newString = 'Integrated airflow data';
                options.session.resp.sigSpec = type;
                set(userOpt,'userData',options);
                saveAux(userOpt,pFile,pSig,spec,puVar,type,newString);
                intSaved = ' \nIntegrated airflow';
            end
        end
        if flags.det
            if ~isempty(signals.rsp.int.data)
                spec = struct; type = 'ilv';
                spec.method.id = options.session.resp.method;
                options.session.resp.sigSpec = type;
                newString = 'ILV data';
                if strcmp(spec.method.id,'High-pass filter')
                    spec.method.fc = options.resp.highPass;
                elseif strcmp(spec.method.id,'Polynomial')
                    spec.method.order = options.resp.polyOrd;
                end
                set(userOpt,'userData',options);
                saveAux(userOpt,pFile,pSig,spec,puVar,type,newString);
                detSaved = ' \nILV';
            end
        end
        if flags.filt
            if ~isempty(signals.rsp.ilv.data)
                type = 'filt';
                options.session.resp.sigSpec = type;
                newString = 'Filtered ILV data';
                if ~flags.det,  spec = struct; end
                if options.resp.rbSelection == 1
                    spec.filterFc = options.resp.lowPass1;
                else
                    spec.filterFc = options.resp.lowPass2;
                end
                set(userOpt,'userData',options);
                saveAux(userOpt,pFile,pSig,spec,puVar,type,newString);
                filtSaved = ' \nFiltered ILV';
            end
        end
        options = get(userOpt,'userData');
        
        % clear prev data from temp object: no more restoring on the GUI
        signals.rsp.raw = dataPkg.dataUnit;
        if ~strcmp(type,'int')
            signals.rsp.int = dataPkg.dataUnit;
        elseif ~strcmp(type,'ilv')
            signals.rsp.ilv = dataPkg.ilvUnit;
        end        
        
        % clear filtered and detrended ILV if detrended ILV was changed
        patient = get(pFile,'userData');
        if strcmp(type,'ilv')
            patient.sig.rsp.filt = dataPkg.ilvUnit;
            signals.rsp.filt = dataPkg.ilvUnit;
        end
        
        % remove corresponding future data (aligned, systems)
        if strcmp(type,'ilv') || strcmp(type,'filt')
            if flags.det
                patient.sig.rsp.ilv.aligned = dataPkg.alignedUnit; 
            end
            if flags.filt
                patient.sig.rsp.filt.aligned = dataPkg.alignedUnit; 
            end
            prevSys = fieldnames(patient.sys);
            for i = 1:length(prevSys)
                if strcmp('Filtered ILV',patient.sys.(prevSys{...
                        i}).data.OutputName) || any(ismember(...
                        patient.sys.(prevSys{i}).data.InputName,...
                        'Filtered ILV'))
                    patient.sys = rmfield(patient.sys,prevSys{i});
                elseif strcmp('ILV',patient.sys.(prevSys{...
                        i}).data.OutputName) || any(ismember(...
                        patient.sys.(prevSys{i}).data.InputName,'ILV'))...
                        && flags.det
                    patient.sys = rmfield(patient.sys,prevSys{i});
                end
            end
            
            % adjust 'align & resample' and 'create system' data selection
            puOpt = {'out','in1','in2'}; erasedFlag = 0;
            for j = 1:3
                if ~isempty(options.session.sys.varString.(puOpt{j}))
                    auxVar = options.session.sys.varString.(puOpt{j}){...
                        options.session.sys.varValue.(puOpt{j})};
                    if erasedFlag || ~isempty(strfind(auxVar,...
                            'Filtered ILV')) || (flags.det && ... % aqui
                            ~isempty(strfind(auxVar,'ILV')))
                        options.session.sys.varValue.(puOpt{j}) = 1;
                    end
                    erasedFlag = 1;
                end
            end
            if ~isempty(options.session.align.varString.rsp)
                auxVar = options.session.align.varString.rsp{...
                    options.session.align.varValue.rsp};
                if ~isempty(strfind(auxVar,'Filtered ILV')) || (flags.det... %aqui
                    && ~isempty(strfind(auxVar,'ILV')))
                    options.session.align.varValue.rsp = 1;
                end
            end
            
            % remove variables from the popup menu to choose data
            stringPU = get(puVar,'string'); auxString = stringPU;
            if ismember('Filtered ILV data',auxString) && ...
                    strcmp(type,'ilv')
                varInd=ismember(auxString,'Filtered ILV data');
                auxString(varInd) = [];
            end
            set(puVar,'string',auxString);
        end
        
        options.session.resp.flags.int = 0;
        options.session.resp.flags.det = 0;
        options.session.resp.flags.filt = 0;
        options.session.resp.saved = 1;
        
        set(pFile,'UserData',patient);
        set(pSig,'userData',signals);
        set(userOpt,'userData',options);
        save(filename,'patient');
        saveConfig(userOpt);
        msgString = [intSaved,detSaved,filtSaved];
        uiwait(msgbox(sprintf(['The following variables have been ',...
            'saved:',msgString]),'Variables saved','modal'));
    end
end
end

function saveAux(userOpt,pFile,pSig,spec,puVar,type,newString)
% move selected data to patient file before saving

options = get(userOpt,'userData');
patient = get(pFile,'userData');
signals = get(pSig,'userData');
patient.sig.rsp.(type).data = signals.rsp.(type).data;
patient.sig.rsp.(type).time = signals.rsp.(type).time;
patient.sig.rsp.(type).fs = signals.rsp.(type).fs;
patient.sig.rsp.(type).specs = spec;

% add saved data to the popupmenu to choose data
stringPU = get(puVar,'string');
stringPU{end+1} = newString;
stringPU = unique(stringPU,'stable');
options.session.resp.varValue = find(ismember(stringPU,...
    newString));

options.session.resp.varString = stringPU;

set(puVar,'string',options.session.resp.varString);
set(puVar,'value',options.session.resp.varValue);
set(puVar,'userData',options.session.resp.varValue);
set(userOpt,'userData',options);
set(pFile,'userData',patient);
set(pSig,'userData',signals);
end

function sliderCallback(scr,~,pSig,userOpt,pHandle,teCurPos)
% adjust settings according to slider dislocation

options = get(userOpt,'userData');
if ~isempty(options.session.resp.sigLen)
    options.session.resp.curPos = round(1000*get(scr,'Value'))/1000;
    set(userOpt,'userData',options);
    
    if ~options.session.resp.flags.compMode
        respPlot(pHandle,pSig,userOpt);
    else
        respPlotComp(pHandle,userOpt);
    end
    set(teCurPos,'String',num2str(options.session.resp.curPos));
end
end

function curPosCallback(scr,~,pSig,userOpt,slWindow,pHandle)
% adjust current window position

options = get(userOpt,'userData');
A=str2double(get(scr,'String'));
if ~isnan(A)
    if ~isempty(options.session.resp.sigLen)
        hiLim = get(slWindow,'Max');
    else
        hiLim = inf;
    end
    
    if A <= hiLim && A >= 0
        options.session.resp.curPos = A;
    elseif A > hiLim
        options.session.resp.curPos = hiLim;
    else
        options.session.resp.curPos = 0;
    end
    
    if ~isempty(options.session.resp.sigLen)
        set(slWindow,'Value',options.session.resp.curPos);
    end
    set(userOpt,'userData',options);
    
    if ~options.session.resp.flags.compMode
        respPlot(pHandle,pSig,userOpt);
    else
        respPlotComp(pHandle,userOpt);
    end
end
set(scr,'String',num2str(options.session.resp.curPos));
end

function shiftCallback(scr,~,pSig,userOpt,slWindow,teCurPos,pHandle)
% move a full window to the left or right

options = get(userOpt,'userData');
if ~isempty(options.session.resp.sigLen)
    if strcmp(get(scr,'tag'),'left')
        if options.session.resp.curPos-options.session.resp.windowLen >= 0
            options.session.resp.curPos = options.session.resp.curPos - ...
                options.session.resp.windowLen;
        else
            options.session.resp.curPos = 0;
        end
    else
        if options.session.resp.curPos+options.session.resp.windowLen <=...
                get(slWindow,'Max')
            options.session.resp.curPos = options.session.resp.curPos + ...
                options.session.resp.windowLen;
        else
            options.session.resp.curPos = get(slWindow,'Max');
        end
    end
    
    set(slWindow,'Value',options.session.resp.curPos);
    set(userOpt,'userData',options);
    
    if ~options.session.resp.flags.compMode
        respPlot(pHandle,pSig,userOpt);
    else
        respPlotComp(pHandle,userOpt);
    end
    set(teCurPos,'String',num2str(options.session.resp.curPos));
end
end

function windowLenCallback(scr,~,pSig,userOpt,teCurPos,slWindow,pHandle)
% modify window length (in seconds)

options = get(userOpt,'userData');
if ~isempty(options.session.resp.sigLen)
    A = str2double(get(scr,'String'));
    if  ~isnan(A)
        if A >= 1 && A <= options.session.resp.sigLen
            options.session.resp.windowLen = round(1000*A)/1000;
            %adapts values for last window
            if A+options.session.resp.curPos >= options.session.resp.sigLen
                options.session.resp.curPos=options.session.resp.sigLen-...
                    options.session.resp.windowLen;
                set(teCurPos,'String',...
                    num2str(options.session.resp.curPos));
                set(slWindow,'Value',options.session.resp.curPos);
            end
        elseif A < 1
            options.session.resp.windowLen = 1;
        else
            options.session.resp.windowLen = options.session.resp.sigLen;
            options.session.resp.curPos = 0;
            set(teCurPos,'String',num2str(0));
            set(slWindow,'Value',options.session.resp.curPos);
        end
        if options.session.resp.sigLen - options.session.resp.windowLen > 0
            set(slWindow,'Max',options.session.resp.sigLen - ...
                options.session.resp.windowLen);
        else
            set(slWindow,'Max',0);
        end
        
        set(userOpt,'userData',options);
        if ~options.session.resp.flags.compMode
            respPlot(pHandle,pSig,userOpt);
        else
            respPlotComp(pHandle,userOpt);
        end
    end
    
    options.session.resp.slider = [0.2 0.4]*...
        (options.session.resp.windowLen/options.session.resp.sigLen);
    set(slWindow,'sliderstep',options.session.resp.slider);
    set(scr,'String',num2str(options.session.resp.windowLen));
    set(userOpt,'userData',options);
end
end

function teCallback(scr,~,userOpt)
% set cut-off frequency for high and low-pass filters and polynomial order

options = get(userOpt,'userData');
if ~isempty(options.session.resp.sigLen)
    A=str2double(get(scr,'string'));
    
    % set boundries according to filter tag
    switch get(scr,'tag')
        case 'highPass'
            loLim = 0.01; hiLim = 0.15;
        case 'polyOrd'
            A = round(A);
            loLim = 1; hiLim = 10;
        case {'lowPass1','lowPass2'}
            loLim = 1; hiLim = 4;
    end
    
    if ~isnan(A)
        if A >= loLim && A <= hiLim
            value = A;
        elseif A < loLim
            value = loLim;
        else
            value = hiLim;
        end
        options.session.resp.(get(scr,'tag')) = value;
    end
    
    % attribute corresponding variables
    set(scr,'string',num2str(options.session.resp.(get(scr,'tag'))));
    set(userOpt,'userData',options);
end
end

function integrateAirflow(~,~,pSig,userOpt,pHandle)
% integrate airflow data

errStat = 0;
options = get(userOpt,'userData');
type = options.session.resp.sigSpec;

if isempty(options.session.resp.sigLen)
    errStat = 1;
elseif options.session.resp.flags.int || ~strcmp(type,'raw')
    uiwait(errordlg(['Integration already performed! Please move on to',...
        ' detrending the integrated airflow, then filtering the ILV as',...
        ' needed, then save.'],'Integration already performed','modal'));
    errStat = 1;
end

if ~errStat
    signals = get(pSig,'userData');
    signals.rsp.int = signals.rsp.(type);
    intData = signals.rsp.(type).data;
    time = signals.rsp.(type).time;
    
    intData = cumtrapz(time,intData);
    
    signals.rsp.int.data = intData;
    options.session.resp.flags.int = 1;
    options.session.resp.sigSpec = 'int';
    set(userOpt,'userData',options);
    set(pSig,'userData',signals);
    
    respPlot(pHandle,pSig,userOpt);
end
end

function cbCallback(scr,~,userOpt,cb1,cb2,tx1)
% select detrending method to compare/apply

options = get(userOpt,'userData');
options.session.resp.cbSelection(get(scr,'userData')) = get(scr,'value');
set(userOpt,'userData',options);

if get(scr,'value')==0
    if get(cb1,'value')==0
        set(cb2,'enable','off');
    elseif get(cb2,'value')==0
        set(cb1,'enable','off');
        if ~isempty(tx1), set(tx1,'enable','off'); end
    end
else
    set(cb1,'enable','on');
    set(cb2,'enable','on');
    if ~isempty(tx1), set(tx1,'enable','on'); end
end
end

function rbCallback(scr,~,userOpt,rb)
% select filter cut-off frequency to be applied

options = get(userOpt,'userData');
options.session.resp.rbSelection = get(scr,'userData');
set(userOpt,'userData',options);

set(scr,'value',1);
set(rb,'value',0);
end

function exitComp(scr,~,pSig,userOpt,pHandle)
% exit comparison mode without applying any changes

options = get(userOpt,'userData');
plotData = get(pHandle,'userData');
if options.session.resp.flags.compMode && strcmp(plotData.tag,get(scr,'tag'))
    options.session.resp.flags.compMode = 0;
    set(userOpt,'userData',options);
    
    set(pHandle,'userData',[]);
    respPlot(pHandle,pSig,userOpt);
end
end

function compDetrend(~,~,pSig,userOpt,pHandle)
% compare detrending methods

errStat = 0;
options = get(userOpt,'userData');
type = options.session.resp.sigSpec;

if isempty(options.session.resp.sigLen)
    errStat = 1;
elseif strcmp(type,'raw')
    uiwait(errordlg(['Integration not performed! The airflow must be ',...
        'integrated before detrended.'],'Integration not performed',...
        'modal'));
    errStat = 1;
elseif options.session.resp.flags.det || strcmp(type,'ilv')
    uiwait(errordlg(['Detrending already performed! Please move on to',...
        ' filtering the ILV signal, if needed, then save.'],...
        'Detrending already performed','modal'));
    errStat = 1;
elseif sum(options.session.resp.cbSelection)==1
    uiwait(errordlg(['Single method selected! Please select at least ',...
        'two methods to compare for detrending the integrated ',...
        'airflow.'],'Single method selected','modal'));
    errStat = 1;
end

if ~errStat
    signals = get(pSig,'userData');
    intSig = signals.rsp.(type).data;
    intTime = signals.rsp.(type).time;
    fs = signals.rsp.(type).fs;
    
    % apply selected detrending methods
    det1 = []; det2 = []; det3 = [];
    if options.session.resp.cbSelection(1)
        det1 = highPassDetrend(options,intSig,fs);
        options.resp.highPass = options.session.resp.highPass;
    end
    if options.session.resp.cbSelection(2)
        det2 = polyDetrend(options,intSig,intTime);
        options.resp.polyOrd = options.session.resp.polyOrd;
    end
    if options.session.resp.cbSelection(3)
        det3 = detrend(intSig);
    end
    
    options.session.resp.flags.compMode = 1;
    options.session.resp.flags.det = 0;
    options.resp.cbSelection = options.session.resp.cbSelection;
    set(userOpt,'userData',options);
    
    % plot all data for comparison
    plotData = struct; plotData.tag = 'det'; plotData.fs = fs;
    plotData.signal1 = det1; plotData.signal2 = det2;
    plotData.signal3 = det3; plotData.time = intTime;
    set(pHandle,'userData',plotData);
    respPlotComp(pHandle,userOpt);
end
end

function applyDetrend(~,~,pSig,userOpt,pHandle)
% detrend data using selected method

errStat = 0;
options = get(userOpt,'userData');
type = options.session.resp.sigSpec;

if isempty(options.session.resp.sigLen)
    errStat = 1;
elseif strcmp(type,'raw')
    uiwait(errordlg(['Integration not performed! The airflow must be',...
        ' integrated before detrended.'],'Integration not performed',...
        'modal'));
    errStat = 1;
elseif options.session.resp.flags.det || ~strcmp(type,'int')
    uiwait(errordlg(['Detrending already performed! Please move on to',...
        ' filtering the ILV signal, if needed, then save.'],...
        'Detrending already performed','modal'));
    errStat = 1;
elseif sum(options.session.resp.cbSelection)~=1
    uiwait(errordlg(['Multiple methods selected! Please select a ',...
        'single method to detrend the integrated airflow.'],...
        'Multiple methods selected','modal'));
    errStat = 1;
end

if ~errStat
    signals = get(pSig,'userData');
    signals.rsp.ilv.data = signals.rsp.(type).data;
    signals.rsp.ilv.time = signals.rsp.(type).time;
    signals.rsp.ilv.fs = signals.rsp.(type).fs;
    signals.rsp.ilv.specs = signals.rsp.(type).specs;
    intSig = signals.rsp.(type).data;
    intTime = signals.rsp.(type).time;
    
    % apply selected method
    if options.session.resp.cbSelection(1)
        intFs = signals.rsp.(type).fs;
        signals.rsp.ilv.data = highPassDetrend(options,intSig,intFs);
        options.resp.highPass = options.session.resp.highPass;
        options.session.resp.method = 'High-pass filter';
    elseif options.session.resp.cbSelection(2)
        signals.rsp.ilv.data = polyDetrend(options,intSig,intTime);
        options.resp.polyOrd = options.session.resp.polyOrd;
        options.session.resp.method = 'Polynomial';
    elseif options.session.resp.cbSelection(3)
        signals.rsp.ilv.data = detrend(intSig);
        options.session.resp.method = 'Linear';
    end
    
    options.resp.cbSelection = options.session.resp.cbSelection;
    options.session.resp.sigSpec = 'ilv';
    options.session.resp.flags.compMode = 0;
    options.session.resp.flags.det = 1;
    set(pHandle,'userData',[]);
    set(userOpt,'userData',options);
    set(pSig,'userData',signals);
    respPlot(pHandle,pSig,userOpt);
end
end

function detSig = highPassDetrend(options,intSig,fs)
% detrend signal using a high-pass filter

fc = options.session.resp.highPass;
if (fc*2/fs)<0.00005
    butterOrd=3;
elseif (fc*2/fs)<0.0005
    butterOrd=4;
else
    butterOrd=5;
end
[B,A] = butter(butterOrd,fc*2/fs,'high');
detSig = filtfilt(B,A,intSig);
end

function detSig = polyDetrend(options,intSig,intTime)
% detrend signal using polynomial fit

pOrd = options.session.resp.polyOrd;
[p,~,m] = polyfit(intTime,intSig,pOrd);
polyEst = polyval(p,intTime,[],m);
detSig = intSig-polyEst;
end

function compFilt(~,~,pSig,userOpt,pHandle)
% compare low-pass filter with different cut-off frequencies

errStat = 0;
options = get(userOpt,'userData');
type = options.session.resp.sigSpec;

if isempty(options.session.resp.sigLen)
    errStat = 1;
elseif strcmp(type,'raw') || strcmp(type,'int')
    uiwait(errordlg(['Detrending not performed! The integrated airflow',...
        ' must be detrended before filtered.'],...
        'Detrending not performed','modal'));
    errStat = 1;
elseif options.session.resp.flags.filt || strcmp(type,'filt')
    uiwait(errordlg(['Filtering already performed! Please move on to',...
        ' saving the signal.'],'Filtering already performed','modal'));
    errStat = 1;
end

if ~errStat
    signals = get(pSig,'userData');
    detSig = signals.rsp.(type).data;
    detTime = signals.rsp.(type).time;
    fs = signals.rsp.(type).fs;
    
    filt1 = filterResp(options,detSig,fs,1);
    filt2 = filterResp(options,detSig,fs,2);
    
    options.session.resp.flags.compMode = 1;
    options.session.resp.flags.filt = 0;
    options.resp.lowPass1 = options.session.resp.lowPass1;
    options.resp.lowPass2 = options.session.resp.lowPass2;
    set(userOpt,'userData',options);
    
    plotData = struct; plotData.tag = 'filt'; plotData.fs = fs;
    plotData.signal1 = detSig; plotData.signal2 = filt1;
    plotData.signal3 = filt2; plotData.time = detTime;
    set(pHandle,'userData',plotData);
    respPlotComp(pHandle,userOpt);
end
end

function applyFilter(~,~,pSig,userOpt,pHandle)
% apply selected low-pass filter

errStat = 0;
options = get(userOpt,'userData');
type = options.session.resp.sigSpec;

if isempty(options.session.resp.sigLen)
    errStat = 1;
elseif strcmp(type,'raw') || strcmp(type,'int')
    uiwait(errordlg(['Detrending not performed! The integrated airflow',...
        ' must be detrended before filtered.'],...
        'Detrending not performed','modal'));
    errStat = 1;
elseif options.session.resp.flags.filt || ~strcmp(type,'ilv')
    uiwait(errordlg(['Filtering already performed! Please move on to',...
        ' saving the signal.'],'Filtering already performed','modal'));
    errStat = 1;
end

if ~errStat
    signals = get(pSig,'userData');
    signals.rsp.filt = signals.rsp.(type);
    detSig = signals.rsp.(type).data;
    fs = signals.rsp.(type).fs;
    
    id = options.session.resp.rbSelection;
    signals.rsp.filt.data = filterResp(options,detSig,fs,id);
    
    options.session.resp.flags.compMode = 0;
    options.session.resp.flags.filt = 1;
    options.session.resp.sigSpec = 'filt';
    options.resp.rbSelection = options.session.resp.rbSelection;
    set(pHandle,'userData',[]);
    set(pSig,'userData',signals);
    set(userOpt,'userData',options);
    respPlot(pHandle,pSig,userOpt);
end
end

function filtSig = filterResp(options,detSig,fs,id)
% filter signal with low-pass filter

if id == 1
    fc = options.session.resp.lowPass1;
else
    fc = options.session.resp.lowPass2;
end
[B,A] = butter(6,fc*2/fs);
filtSig = filtfilt(B,A,detSig);
end

function tabChange(scr,~,tbDetResp,pnDetrend,tbFiltResp,pnFilt,userOpt)

if get(scr,'value') == 1
    set(scr,'backgroundcolor',[1 1 1]);
    options = get(userOpt,'userData');
    switch get(scr,'tag')
        case 'det'
            options.session.nav.resp = 0;
            set(userOpt,'userData',options);
            set(tbFiltResp,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnFilt,'visible','off');
            set(pnDetrend,'visible','on');
        case 'filt'
            options.session.nav.resp = 1;
            set(userOpt,'userData',options);
            set(tbDetResp,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnDetrend,'visible','off');
            set(pnFilt,'visible','on');
    end
else
    set(scr,'value',1);
end
end

function value = checkLim(value,tag)

switch tag
    case 'high'
        loLim = 0.01; hiLim = 0.15;
    case 'poly'
        loLim = 1; hiLim = 10;
    case 'filt'
        loLim = 1; hiLim = 4;
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
options.session.resp.lo_lim = lim(1);
options.session.resp.hi_lim = lim(2);

set(userOpt,'userData',options);
set(tbZoom,'value',0);
zoomFcn(tbZoom,[],pbZoom);
respPlot(pHandle,pSig,userOpt);
end

function resetY(~,~,pHandle,pSig,userOpt,tbZoom,pbZoom)

options = get(userOpt,'userData');

type = options.session.resp.sigSpec;
signals = get(pSig,'userData');
data = signals.rsp.(type).data;

options.session.resp.lo_lim = min(data)-0.05*abs(max(data)-min(data)); 
options.session.resp.hi_lim = max(data)+0.05*abs(max(data)-min(data));

set(userOpt,'userData',options);
set(tbZoom,'value',0);
zoomFcn(tbZoom,[],pbZoom);
respPlot(pHandle,pSig,userOpt);
end

function saveConfig(userOpt)
% save session configurations for next session

options = get(userOpt,'userData');
options.resp.windowLen = options.session.resp.windowLen;
options.resp.highPass = options.session.resp.highPass;
options.resp.polyOrd = options.session.resp.polyOrd;
options.resp.lowPass1 = options.session.resp.lowPass1;
options.resp.lowPass2 = options.session.resp.lowPass2;
options.resp.cbSelection = options.session.resp.cbSelection;
options.resp.rbSelection = options.session.resp.rbSelection;
set(userOpt,'userData',options);
end