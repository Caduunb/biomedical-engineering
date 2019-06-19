function systemMenu(pnSystem,pFile,userOpt)
% SystemMenu - CRSIDLab
%   Menu for creating a system from resampled and aligned variables, such
%   as R-R interval (RRI) or heart rate (HR) extracted from 
%   electrocardiogram (ECG) and/or systolic blood pressure (SBP) or
%   diastolic blood pressure (DBP) extracted from continuous blood pressure
%   (BP) and/or instantaneous lung volume (ILV) which may be extracted from
%   airflow data. The system may be composed of any combination of the
%   resampled and aligned available variables. User may indicate system
%   output and input(s). Then the user should indicate the portion of data
%   used for system estimation and validation, apply a low-pass Kaiser
%   filter (anti-aliasing) and apply polynomial detrend to the data.
%
% Original Matlab code: Luisa Santiago C. B. da Silva, April 2017.

var = struct; 
var.output = []; var.input1 = []; var.input2 = []; var.fs = [];
var.outTrend.est = []; var.in1Trend.est = []; var.in2Trend.est = [];
var.outTrend.val = []; var.in1Trend.val = []; var.in2Trend.val = [];
pCurVar = uicontrol('visible','off','userData',var);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Data visualization and slider
%

pHandle = struct; puVar = struct;

uicontrol('parent',pnSystem,'style','text','string','Select registers:',...
    'hor','left','units','normalized','position',[.032 .93 .1 .03]);
puVar.out = uicontrol('parent',pnSystem,'style','popupmenu','tag','out',...
    'string',{'Output variable','No data available'},'value',1,...
    'userData',1,'backgroundColor',[1 1 1],'units','normalized',...
    'position',[.13 .93 .2 .04]);

uicontrol('parent',pnSystem,'style','text','string','and / or:','units',...
    'normalized','position',[.34 .93 .05 .03]);
puVar.in1 = uicontrol('parent',pnSystem,'style','popupmenu','tag','in1',...
    'string',{'First input variable','No data available'},...
    'value',1,'userData',1,'units','normalized','position',...
    [.4 .93 .2 .04],'backgroundColor',[1 1 1]);

uicontrol('parent',pnSystem,'style','text','string','and / or:','units',...
    'normalized','position',[.61 .93 .05 .03]);
puVar.in2 = uicontrol('parent',pnSystem,'style','popupmenu','tag','in2',...
    'string',{'Second input variable','No data available'},...
    'value',1,'userData',1,'units','normalized','position',...
    [.67 .93 .2 .04],'backgroundColor',[1 1 1]);

pHandle.single = axes('parent',pnSystem,'tag','out','visible','on',...
    'Units','normalized','Position',[.057 .14 .765 .74],'nextPlot',...
    'replaceChildren');
pHandle.double1 = axes('parent',pnSystem,'tag','out','visible','off',...
    'Units','normalized','Position',[.057 .5275 .765 .3525],'nextPlot',...
    'replaceChildren');
pHandle.double2 = axes('parent',pnSystem,'tag','in1','visible','off',...
    'Units','normalized','Position',[.057 .14 .765 .3525],'nextPlot',...
    'replaceChildren');
pHandle.triple1 = axes('parent',pnSystem,'tag','out','visible','off',...
    'Units','normalized','Position',[.057 .66 .765 .22],'nextPlot',...
    'replaceChildren');
pHandle.triple2 = axes('parent',pnSystem,'tag','in1','visible','off',...
    'Units','normalized','Position',[.057 .398 .765 .22],'nextPlot',...
    'replaceChildren');
pHandle.triple3 = axes('parent',pnSystem,'tag','in2','visible','off',...
    'Units','normalized','Position',[.057 .14 .765 .22],'nextPlot',...
    'replaceChildren');

uicontrol('parent',pnSystem,'style','text','hor','right','string',...
    'Time (seconds) ','fontSize',10,'units','normalized','position',...
    [.73 .06 .1 .035]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Choose percentage of data for system estimation
%

pnPerc = uipanel('parent',pnSystem,'Units','normalized','Position',...
    [.843 .74 .125 .15]);

uicontrol('parent',pnPerc,'Style','text','string',['Percentage of data',...
    ' for model estimation'],'Units','normalized','Position',...
    [.05 .5 .9 .4]);

tePerc = uicontrol('parent',pnPerc,'Style','edit','tag','perc',...
    'CallBack',{@teCallback,userOpt,pCurVar,pHandle},'Units',...
    'normalized','Position',[.25 .1 .4 .3],'BackgroundColor',[1 1 1]);

uicontrol('parent',pnPerc,'Style','text','String','%','Units',...
    'normalized','Position',[.7 .05 .1 .3]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Kaiser filter (anti-aliasing)
% 

pnKaiser = uipanel('parent',pnSystem,'Units','Normalized','Position',...
    [.843 .54 .125 .2]);

uicontrol('parent',pnKaiser,'Style','text','string',['Low-pass Kaiser ',...
    'filter'],'Units','normalized','Position',[.05 .81 .9 .14]);

uicontrol('parent',pnKaiser,'Style','push','tag','filt','String',...
    'View filtered signals','Callback',{@pbView,userOpt,pCurVar,...
    pHandle},'Units','normalized','Position',[.05 .54 .9 .22]);

uicontrol('parent',pnKaiser,'Style','push','String',['View filter ',...
    'response'],'Callback',@pbFilterResponse,'Units','normalized',...
    'Position',[.05 .32 .9 .22]);

uicontrol('parent',pnKaiser,'Style','push','String','Apply filter',...
    'Callback',{@pbFilter,userOpt,pCurVar,pHandle},'Units','normalized',...
    'Position',[.05 .1 .9 .22]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Polynomial detrend
%

pnDetrend = uipanel('parent',pnSystem,'Units','Normalized','Position',...
    [.843 .25 .125 .29]);

uicontrol('parent',pnDetrend,'Style','text','String',['Polynomial ',...
    'detrend'],'Units','normalized','Position',[.05 .85 .9 .1]);

uicontrol('parent',pnDetrend,'Style','text','hor','left','String',...
    'Polynomial order:','Units','normalized','Position',[.05 .6 .48 .2]);

tePoly=uicontrol('parent',pnDetrend,'Style','edit','tag','poly',...
    'Callback',{@teCallback,userOpt,pCurVar,pHandle},'Units',...
    'normalized','Position',[.525 .62 .4 .15],'backgroundcolor',[1 1 1]);

uicontrol('parent',pnDetrend,'Style','push','tag','det','String',...
    'View det. signals','Callback',{@pbView,userOpt,pCurVar,pHandle},...
    'Units','normalized','Position',[.05 .39 .9 .16]);

uicontrol('parent',pnDetrend,'Style','push','String','View trends',...
    'Callback',{@showTrends,userOpt,pCurVar},'Units','normalized',...
    'Position',[.05 .23 .9 .16]);

uicontrol('parent',pnDetrend,'Style','push','String','Detrend signals',...
    'callback',{@pbDetrend,userOpt,pCurVar,pHandle},'Units',...
    'normalized','Position',[.05 .07 .9 .16]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Exit visualization of filtered or detrended signals
% 

pnExit = uipanel('parent',pnSystem,'Units','normalized','Position',...
    [.843 .17 .125 .08]);

uicontrol('parent',pnExit,'Style','push','String','Exit visualization',...
    'CallBack',{@exitView,userOpt,pCurVar,pHandle},'Units','Normalized',...
    'Position',[.05 .2 .9 .6]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Buttons (resample, save and restore)
% 

pnSave = uipanel('parent',pnSystem,'Units','normalized','Position',...
    [.843 .06 .125 .11]);

% restore
uicontrol('parent',pnSave,'Style','push','String','Restore','CallBack',...
    {@restoreSig,userOpt,pFile,pCurVar,pHandle},'Units','Normalized',...
    'Position',[.15 .5225 .7 .38]);

% save
uicontrol('parent',pnSave,'Style','push','String','SAVE','CallBack',...
    {@saveSys,userOpt,pFile,pCurVar},'Units','Normalized','Position',...
    [.15 .1 .7 .38]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Set final callbacks and call opening function (setup)
%

set(puVar.out,'callback',{@changeVar,userOpt,pFile,pCurVar,puVar,pHandle});
set(puVar.in1,'callback',{@changeVar,userOpt,pFile,pCurVar,puVar,pHandle});
set(puVar.in2,'callback',{@changeVar,userOpt,pFile,pCurVar,puVar,pHandle});

openFcn(userOpt,pFile,pCurVar,puVar,tePerc,tePoly,pHandle);
end

function plotFcn(pHandle,pCurVar,userOpt)
% adjust handles visibility and plot all selected signals

options = get(userOpt,'userData');
aux = options.session.sys.sigSpec(~cellfun(@isempty,...
    options.session.sys.sigSpec));
if length(aux) == 3
    set(pHandle.single,'visible','off');
    set(get(pHandle.single,'children'),'visible','off');
    set(pHandle.double1,'visible','off');
    set(get(pHandle.double1,'children'),'visible','off');
    set(pHandle.double2,'visible','off');
    set(get(pHandle.double2,'children'),'visible','off');
    
    set(pHandle.triple1,'visible','on');
    set(get(pHandle.triple1,'children'),'visible','on');
    set(pHandle.triple2,'visible','on');
    set(get(pHandle.triple2,'children'),'visible','on');
    set(pHandle.triple3,'visible','on');
    set(get(pHandle.triple3,'children'),'visible','on');
    
    if options.session.sys.viewFilter
        systemPlotComp(pHandle.triple1,pCurVar,userOpt,'filt');
        systemPlotComp(pHandle.triple2,pCurVar,userOpt,'filt');
        systemPlotComp(pHandle.triple3,pCurVar,userOpt,'filt');
    elseif options.session.sys.viewDetrend
        systemPlotComp(pHandle.triple1,pCurVar,userOpt,'detrend');
        systemPlotComp(pHandle.triple2,pCurVar,userOpt,'detrend');
        systemPlotComp(pHandle.triple3,pCurVar,userOpt,'detrend');
    else
        systemPlot(pHandle.triple1,pCurVar,userOpt);
        systemPlot(pHandle.triple2,pCurVar,userOpt);
        systemPlot(pHandle.triple3,pCurVar,userOpt);
    end
elseif length(aux) == 2
    set(pHandle.single,'visible','off');
    set(get(pHandle.single,'children'),'visible','off');
    set(pHandle.triple1,'visible','off');
    set(get(pHandle.triple1,'children'),'visible','off');
    set(pHandle.triple2,'visible','off');
    set(get(pHandle.triple2,'children'),'visible','off');
    set(pHandle.triple3,'visible','off');
    set(get(pHandle.triple3,'children'),'visible','off');
    
    set(pHandle.double1,'visible','on');
    set(get(pHandle.double1,'children'),'visible','on');
    set(pHandle.double2,'visible','on');
    set(get(pHandle.double2,'children'),'visible','on');
    
    if options.session.sys.viewFilter
        systemPlotComp(pHandle.double1,pCurVar,userOpt,'filt');
        systemPlotComp(pHandle.double2,pCurVar,userOpt,'filt');
    elseif options.session.sys.viewDetrend
        systemPlotComp(pHandle.double1,pCurVar,userOpt,'detrend');
        systemPlotComp(pHandle.double2,pCurVar,userOpt,'detrend');
    else
        systemPlot(pHandle.double1,pCurVar,userOpt);
        systemPlot(pHandle.double2,pCurVar,userOpt);
    end
else
    set(pHandle.double1,'visible','off');
    set(get(pHandle.double1,'children'),'visible','off');
    set(pHandle.double2,'visible','off');
    set(get(pHandle.double2,'children'),'visible','off');
    set(pHandle.triple1,'visible','off');
    set(get(pHandle.triple1,'children'),'visible','off');
    set(pHandle.triple2,'visible','off');
    set(get(pHandle.triple2,'children'),'visible','off');
    set(pHandle.triple3,'visible','off');
    set(get(pHandle.triple3,'children'),'visible','off');
    
    set(pHandle.single,'visible','on');
    
    if length(aux) == 1
        if options.session.sys.viewFilter
            systemPlotComp(pHandle.single,pCurVar,userOpt,'filt');
        elseif options.session.sys.viewDetrend
            systemPlotComp(pHandle.single,pCurVar,userOpt,'detrend');
        else
            systemPlot(pHandle.single,pCurVar,userOpt);
        end
        set(get(pHandle.single,'children'),'visible','on');
    else
        ylabel(pHandle.single,'');
        set(get(pHandle.single,'children'),'visible','off');
    end
end
end

function openFcn(userOpt,pFile,pCurVar,puVar,tePerc,tePoly,pHandle)
% adjust initial values of objects

options = get(userOpt,'userData');
patient = get(pFile,'userData');

% string for variable selection popupmenus (output and inputs) from 
% available patient data
id = {'ecg','rsp','rsp','bp','bp'};
var = {'rri','filt','ilv','sbp','dbp'};
stringPU = cell(length(var),1);
for i = 1:5
    if ~isempty(patient.sig.(id{i}).(var{i}).aligned.data)
        stringPU{i} = patient.sig.(id{i}).(var{i}).aligned.specs.tag;
    end
end
stringPU = stringPU(~cellfun(@isempty,stringPU));
if isempty(stringPU), stringPU{1} = 'No data available'; end

puOpt = {'out','in1','in2'};
puID = {'Output variable','First input variable',...
    'Second input variable'};
for i = 1:3
    % remove variables selected from other PUs if any
    auxString = stringPU;
    if ~isempty(options.session.sys.varString.(puOpt{i}))
        for j = 1:3
            if j ~= i && options.session.sys.varValue.(puOpt{j})~=1
                prevVar = options.session.sys.varString.(puOpt{j}){...
                    options.session.sys.varValue.(puOpt{j})};
                varInd = find(strcmp(auxString,prevVar),1);
                auxString(varInd) = [];
            end
        end
    end

    % adjust selection value if the variables list has changed
    if ~isequal(options.session.sys.varString.(puOpt{i})(2:end),auxString)
        if ~isempty(options.session.sys.varString.(puOpt{i}))
            if ismember(options.session.sys.varString.(puOpt{i}){...
                options.session.sys.varValue.(puOpt{i})},auxString)
                options.session.sys.varValue.(puOpt{i}) = find(ismember(...
                    auxString,options.session.sys.varString.(puOpt{i}){...
                    options.session.sys.varValue.(puOpt{i})}))+1;
            else
                options.session.sys.varValue.(puOpt{i}) = 1;
            end
        end
        options.session.sys.varString.(puOpt{i}) = [puID(i);auxString];
    end
    
    % setup popupmenus
    set(puVar.(puOpt{i}),'string',...
        options.session.sys.varString.(puOpt{i}));
    set(puVar.(puOpt{i}),'value',...
        options.session.sys.varValue.(puOpt{i}));
    set(puVar.(puOpt{i}),'userData',...
        options.session.sys.varValue.(puOpt{i}));
end

% open data and setup options that depend on the data
set(userOpt,'userData',options);
setup(userOpt,pFile,pCurVar);
options = get(userOpt,'userData');

% setup options that don't depend on the data
options.session.sys.perc = checkLim(options.session.sys.perc,'perc');
set(tePerc,'string',num2str(options.session.sys.perc));
options.session.sys.poly = checkLim(options.session.sys.poly,'poly');
set(tePoly,'string',num2str(options.session.sys.poly));

options.session.align.opened = 1;
set(userOpt,'userData',options);
plotFcn(pHandle,pCurVar,userOpt);
end

function setup(userOpt,pFile,pCurVar)
% open data and setup options that depend on the data

options = get(userOpt,'userData');

% clear variables
curVar = get(pCurVar,'userData');
curVar.output = []; curVar.input1 = []; curVar.input2 = []; curVar.fs = [];
curVar.outTrend.est = []; curVar.in1Trend.est = []; curVar.in2Trend.est=[];
curVar.outTrend.val = []; curVar.in1Trend.val = []; curVar.in2Trend.val=[];


% identify selected data
opt = {'out','in1','in2'};
id = cell(3,1); type = cell(3,1);
for i = 1:3
    auxVar = options.session.sys.varString.(opt{i}){...
        options.session.sys.varValue.(opt{i})};
    if ~isempty(strfind(auxVar,'RRI'))
        id{i} = 'ecg'; type{i} = 'rri'; 
    elseif ~isempty(strfind(auxVar,'HR'))
        id{i} = 'ecg'; type{i} = 'hr'; 
    elseif ~isempty(strfind(auxVar,'SBP'))
        id{i} = 'bp'; type{i} = 'sbp';
    elseif ~isempty(strfind(auxVar,'DBP'))
        id{i} = 'bp'; type{i} = 'dbp';
    elseif ~isempty(strfind(auxVar,'Filtered'))
        id{i} = 'rsp'; type{i} = 'filt';
    elseif ~isempty(strfind(auxVar,'ILV'))
        id{i} = 'rsp'; type{i} = 'ilv';
    end
end
options.session.sys.sigSpec = type;
for i = 1:length(type)
    if strcmp(type{i},'hr')
        type{i} = 'rri';
    end
end

% open data and setup options
if ~isempty(type{1}) || ~isempty(type{2}) || ~isempty(type{3})
    patient = get(pFile,'userData');

    % adjust optional inputs
    opt = {'output','input1','input2'};
    for i = 1:3
        if ~isempty(type{i})
            curVar.(opt{i}) = patient.sig.(id{i}).(type{i}).aligned.data;
            if isempty(curVar.fs)
                if ~isempty(patient.sig.(id{i}).(type{i}).aligned.fs)
                    curVar.fs = patient.sig.(id{i}).(type{i}).aligned.fs;
                end
            end
            if isempty(options.session.sys.sigLen)
                options.session.sys.sigLen = length(curVar.(opt{i}));
            end
        end
    end
end
set(pCurVar,'userData',curVar);
set(userOpt,'userData',options);
end

function changeVar(scr,~,userOpt,pFile,pCurVar,puVar,pHandle)
% change variable to create new system

errStat = 0;
oldValue = get(scr,'userData');
newValue = get(scr,'value');
if oldValue ~= newValue
    options = get(userOpt,'userData');
    if (strcmp(get(scr,'tag'),'in2') && ...
            options.session.sys.varValue.in1 == 1) || ...
            (strcmp(get(scr,'tag'),'in1') && ...
            options.session.sys.varValue.out == 1)
        uiwait(errordlg(['Variables must be selected in the correct ',...
            'order! Please indicate first the output variable, then ',...
            'the first input variable and finally the second input ',...
            'variable. Input variables are optional, but there must ',...
            'always be an output variable.'],...
            'Variables must be selected in the correct order','modal'));
        set(scr,'value',1);
        errStat = 1;
    elseif (strcmp(get(scr,'tag'),'in1') && newValue == 1 && ...
            options.session.sys.varValue.in2 ~= 1) || ...
            (strcmp(get(scr,'tag'),'out') && newValue == 1 && ...
            options.session.sys.varValue.in1 ~= 1)
        uiwait(errordlg(['Variables must be eliminated in the correct ',...
            'order! Please eliminate first the second input variable, ',...
            'then the first input variable and finally the output ',...
            'variable.'],...
            'Variables must be eliminated in the correct order','modal'));
        set(scr,'value',oldValue);
        errStat = 1;
    elseif ~options.session.sys.saved &&(options.session.sys.filtered ||...
            options.session.sys.detrended)
        [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
            'changeVarSysPref','Change system',sprintf([...
            'Warning!','\nThe current system has not been saved. Any ',...
            'modifications will be lost if other system is opened ',...
            'before saving. All other data will be restored.\nAre you ',...
            'sure you wish to proceed?']),{'Yes','No'},'DefaultButton',...
            'No');
        if strcmp(selButton,'no') && dlgShow
            errStat = 1;
        end
    end
else
    errStat = 1;
end

if ~errStat && ~strcmp(get(scr,'tag'),'out')
    % read data from the variable
    id = []; type = [];
    auxVar = options.session.sys.varString.(get(scr,'tag')){...
        get(scr,'value')};
    if ~isempty(strfind(auxVar,'RRI'))
        id = 'ecg'; type = 'rri'; 
    elseif ~isempty(strfind(auxVar,'HR'))
        id = 'ecg'; type = 'hr'; 
    elseif ~isempty(strfind(auxVar,'SBP'))
        id = 'bp'; type = 'sbp';
    elseif ~isempty(strfind(auxVar,'DBP'))
        id = 'bp'; type = 'dbp';
    elseif ~isempty(strfind(auxVar,'Filtered'))
        id = 'rsp'; type = 'filt';
    elseif ~isempty(strfind(auxVar,'ILV'))
        id = 'rsp'; type = 'ilv';
    end
    if ~isempty(id)
        patient = get(pFile,'userData');
        fs = patient.sig.(id).(type).aligned.fs;
        dataLen = length(patient.sig.(id).(type).aligned.time);
        % reference data (output)
        curVar = get(pCurVar,'userData');
        if curVar.fs ~= fs
            uiwait(errordlg(['Variables must have the same sampling ',...
                'frequency! The variable indicated as output has a ',...
                num2str(curVar.fs),' Hz sampling frequency while the ',...
                'variable selected has a ',num2str(fs),' Hz sampling ',...
                'frequency. A system must be composed of variables ',...
                'with aligned samples.'],...
                'Different sampling frequencies','modal'));
            set(scr,'value',oldValue);
            errStat = 1;
        elseif length(curVar.output) ~= dataLen
            uiwait(errordlg(['Variables must have the same length! The',...
                ' variable indicated as output has ',num2str(length(...
                curVar.output)),' samples while the variable selected ',...
                'has ',num2str(dataLen),' samples. A system must be ',...
                'composed of variables with the same time axis.'],...
                'Different lengths','modal'));
            set(scr,'value',oldValue);
            errStat = 1;
        end
    end
end

if ~errStat
    options.session.sys.varValue.(get(scr,'tag')) = newValue;
    set(scr,'userData',newValue);    
    set(userOpt,'userData',options);

    setup(userOpt,pFile,pCurVar);
    options = get(userOpt,'userData');
    
    % store variables selected on the other popupmenus
    prevVar = struct; opt = {'out','in1','in2'};
    for i = 1:3
        if ~strcmp(get(scr,'tag'),opt{i})
            prevVar.(opt{i}) = options.session.sys.varString.(...
                get(puVar.(opt{i}),'tag')){...
                options.session.sys.varValue.(get(puVar.(opt{i}),'tag'))};
        end
    end
    otherPus = fieldnames(prevVar);
    
    oldVar = options.session.sys.varString.(get(scr,'tag')){oldValue};
    newVar = options.session.sys.varString.(get(scr,'tag')){newValue};
    
    % return old variable to other popupmenus in the correct order
    if ~ismember(oldVar,{'No data available','Output variable',...
            'First input variable','Second input variable'})
        index = zeros(2,1);
        for i = 1:length(otherPus)
            auxString = options.session.sys.varString.(otherPus{i});
            if ~isempty(strfind(oldVar,'DBP'))
                index(i) = length(options.session.sys.varString.(...
                    otherPus{i}))+1;
            else
                index(i) = 2;
                if isempty(strfind(oldVar,'RRI'))
                    aux = strfind(auxString,'A&R RRI data');
                    if any(~cellfun(@isempty,aux))
                        index(i) = index(i)+1;
                    end
                end
                if isempty(strfind(oldVar,'RRI')) && ...
                        isempty(strfind(oldVar,'HR'))
                    aux = strfind(auxString,'A&R HR data');
                    if any(~cellfun(@isempty,aux))
                        index(i) = index(i)+1;
                    end
                end
                if isempty(strfind(oldVar,'RRI')) && ...
                        isempty(strfind(oldVar,'HR')) && ...
                        isempty(strfind(oldVar,'Filtered'))
                    aux = strfind(auxString,'A&R ILV data');
                    if any(~cellfun(@isempty,aux))
                        index(i) = index(i)+1;
                    end
                    if isempty(strfind(oldVar,'Filtered'))
                        aux = strfind(auxString,'A&R Filtered ILV data');
                        if any(~cellfun(@isempty,aux))
                            index(i) = index(i)+1;
                        end
                    end
                end
                if isempty(strfind(oldVar,'RRI')) && ...
                        isempty(strfind(oldVar,'HR')) && ...
                        isempty(strfind(oldVar,'ILV')) && ...
                        isempty(strfind(oldVar,'SBP'))
                    aux = strfind(auxString,'A&R SBP data');
                    if any(~cellfun(@isempty,aux))
                        index(i) = index(i)+1;
                    end
                end
            end
            auxString = [auxString(1:index(i)-1);{oldVar}; ...
                auxString(index(i):end)];
            options.session.sys.varString.(otherPus{i}) = auxString;
        end
    end
    
    % remove selected variable from other popupmenus
    for i = 1:length(otherPus)
        auxString = options.session.sys.varString.(otherPus{i});
        varInd = find(strcmp(auxString,newVar),1);
        auxString(varInd) = [];
        newInd = find(strcmp(auxString,prevVar.(otherPus{i})),1);
        options.session.sys.varString.(otherPus{i}) = auxString;
        options.session.sys.varValue.(otherPus{i}) = newInd;
        set(puVar.(otherPus{i}),'string',auxString); 
        set(puVar.(otherPus{i}),'value',newInd); 
        set(puVar.(otherPus{i}),'userData',newInd); 
    end
    
    options.session.sys.filtered = 0;
    options.session.sys.detrended = 0;
    options.session.sys.saved = 0;
    
    set(userOpt,'userData',options);    
    plotFcn(pHandle,pCurVar,userOpt);
else
    set(scr,'value',oldValue);
end
end
    
function restoreSig(~,~,userOpt,pFile,pCurVar,pHandle)
% restore selected records from disk

options = get(userOpt,'userData');
if ~isempty(options.session.sys.sigLen)
    curVar = get(pCurVar,'userData');
    patient = get(pFile,'userData');
    
    type = options.session.sys.sigSpec;
    for i = 1:length(type)
        if strcmp(type{i},'hr')
            type{i} = 'rri';
        end
    end
    opt = {'output','input1','input2'};
    for i = 1:3
        if ~isempty(type{i})
            if strcmp(type{i},'rri'), id = 'ecg';
            elseif ismember(type{i},{'sbp','dbp'}), id = 'bp';
            else id = 'rsp';
            end
            curVar.(opt{i}) = patient.sig.(id).(type{i}).aligned.data;
        end
    end
    
    options.session.sys.filtered = 0;
    options.session.sys.detrended = 0;
    set(userOpt,'userData',options);
    set(pCurVar,'userData',curVar);
    
    plotFcn(pHandle,pCurVar,userOpt);
end     
end

function saveSys(~,~,userOpt,pFile,pCurVar)
% save system

options = get(userOpt,'userData');
if ~isempty(options.session.sys.sigLen) 
    errStat = 0; 
    
    filtString = []; detString = [];
    if ~options.session.sys.filtered || ~options.session.sys.detrended
        if ~options.session.sys.filtered
            filtString = '\n Low-pass Kaiser filter';
        end
        if ~options.session.sys.detrended
            detString = '\n Polynomial detrending';
        end
        fullString = [filtString,detString];
        [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
            'saveSysPref','Saving system',sprintf(['Warning!',...
            '\nThe following have not been applied:',fullString,...
            '\nPlease note that not detrending the estimation data may',...
            ' lead to inaccurate models!.\nAre you sure you wish to ',...
            'proceed']),{'Yes','No'},'DefaultButton','No');
        if strcmp(selButton,'no') && dlgShow
            errStat = 1;
        end     
    end
    
    if ~errStat        
        curVar = get(pCurVar,'userData');
        
        ts =  1/curVar.fs; %period
        %index for final estimation data sample
        tam = round((options.session.sys.perc/100)*length(curVar.output)); 

        %create estimation and validation data sets in iddata object
        patient = get(pFile,'userData');
        prevSys = fieldnames(patient.sys);
        if ~isempty(prevSys), lastNo = str2double(prevSys{end}(4:end));
        else lastNo = 0;
        end
        sysName = ['sys',num2str(lastNo+1)];
        type = options.session.sys.sigSpec;
        varName = struct; varName.input1 = []; varName.input2 = [];
        varUn = struct; varUn.input1 = []; varUn.input2 = [];
        var = struct; 
        var.output.est = []; var.input1.est = []; var.input2.est = [];
        var.output.val = []; var.input1.val = []; var.input2.val = [];
        opt = {'output','input1','input2'};
        for i = 1:3
            if ~isempty(curVar.(opt{i}))
                var.(opt{i}).est = curVar.(opt{i})(1:tam);
                var.(opt{i}).val = curVar.(opt{i})(tam+1:end);
                if ~strcmp(type{i},'filt')
                    varName.(opt{i}) = upper(type{i});
                else
                    varName.(opt{i}) = 'Filtered ILV';
                end
                switch type{i}
                    case 'rri'
                        varUn.(opt{i}) = 'ms';
                    case 'hr'
                        varUn.(opt{i}) = 'bpm';
                    case {'sbp','dbp'}
                        varUn.(opt{i}) = 'mmHg';
                    case {'ilv','filt'}
                        varUn.(opt{i}) = 'L';
                end
            end
        end
        inName = cell(2,1); inUn = cell(2,1);
        if isfield(varName,'input1')
            inName{1} = varName.input1; inUn{1} = varUn.input1;
        end
        if isfield(varName,'input2')
            inName{2} = varName.input2; inUn{2} = varUn.input2;
        end
        inName = inName(~cellfun(@isempty,inName));
        inUn = inUn(~cellfun(@isempty,inUn));
        
        if length(inName) == 2
            noteString = [sysName,': Output (',varName.output,'); ',...
                'Inputs (',varName.input1,' &  ',varName.input2,'); ',...
                num2str(options.session.sys.perc),'% of data for ',...
                'system estimation'];
        elseif length(inName) == 1
            noteString = [sysName,': Output (',varName.output,'); ',...
                'Input (',varName.input1,'); ',num2str(...
                options.session.sys.perc),'% of data for system ',...
                'estimation'];
        else
            noteString = [sysName,': Output (',varName.output,'); ',...
                num2str(options.session.sys.perc),'% of data for ',...
                'system estimation'];
        end
        
        
        ze = iddata(var.output.est-mean(var.output.est),...
            [var.input1.est-mean(var.input1.est) ...
            var.input2.est-mean(var.input2.est)],ts);
        set(ze,'Name',[sysName,' data'],'OutputName',varName.output,...
            'OutputUnit',varUn.output,'InputName',inName,'InputUnit',...
            inUn,'Tstart',0,'TimeUnit','seconds','ExperimentName',...
            'Estimation data','Notes',noteString);
        if options.session.sys.detrended
            te = iddata(curVar.outTrend.est,[curVar.in1Trend.est ...
                curVar.in2Trend.est],ts);
            set(te,'Name',[sysName,' data trends'],'OutputName',...
                varName.output,'OutputUnit',varUn.output,'InputName',...
                inName,'InputUnit',inUn,'Tstart',0,'TimeUnit','seconds',...
                'ExperimentName','Estimation data trends','Notes',...
                ['Polynomial order used: ',...
                num2str(options.session.sys.poly)]);
        end
        if options.session.sys.perc ~= 100
            time = (0:length(curVar.output)-1)/curVar.fs;
            zv = iddata(var.output.val-mean(var.output.val),...
                [var.input1.val-mean(var.input1.val) ...
                var.input2.val-mean(var.input2.val)],ts);
            set(zv,'Name',[sysName,' data'],'OutputName',varName.output,...
                'OutputUnit',varUn.output,'InputName',inName,...
                'InputUnit',inUn,'Tstart',time(tam+1),'TimeUnit',...
                'seconds','ExperimentName','Validation data','Notes',...
                noteString);
            if options.session.sys.detrended
                tv = iddata(curVar.outTrend.val,...
                    [curVar.in1Trend.val curVar.in2Trend.val],ts);
                set(tv,'Name',[sysName,' data trends'],'OutputName',...
                    varName.output,'OutputUnit',varUn.output,'InputName',...
                    inName,'InputUnit',inUn,'Tstart',time(tam+1),...
                    'TimeUnit','seconds','ExperimentName',...
                    'Validation data trends','Notes',...
                    ['Polynomial order used: ',num2str(...
                    options.session.sys.poly)]);
                t = merge(te,tv);
            end
            z = merge(ze,zv);
        else
            z = ze;
            if options.session.sys.detrended, t = te; end
        end
        
        % verify if there's a similar system saved
        saved = 0;
        if ~isempty(prevSys)
            for i = 1:length(prevSys)
                if isequal(patient.sys.(prevSys{i}).data.y,z.y) && ...
                        isequal(patient.sys.(prevSys{i}).data.u,z.u)
                    saved = 1;
                end
            end
        end
        
        if saved
            uiwait(errordlg(['System already saved! It appeareas that ',...
                'there''s already a system identical to this one saved',...
                '. Duplicate systems are not allowed.'],...
                'System already saved','modal'));
        elseif options.session.sys.saved
            [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
                'saveSysRepPref','Saving system',sprintf([...
                'Warning!','\nSince tha last system was saved, ',...
                ' modifications have been made.\nDo you wish to save ',...
                'this modified version as a new system?']),{'Yes','No'},...
                'DefaultButton','No');
            if strcmp(selButton,'no') && dlgShow
                saved = 1;
            end
        end
        
        if ~saved
            filename = options.session.filename; 
            pSys = dataPkg.patientSys;
            pSys.data = z; 
            if options.session.sys.detrended, pSys.trends = t; end
            patient.sys.(sysName) = pSys;
            options.session.sys.saved = 1;
            set(userOpt,'userData',options);
            set(pFile,'userData',patient);
            save(filename,'patient');
            saveConfig(userOpt);
            uiwait(msgbox(['The system has been saved successfully by ',...
                'the name of ',sysName,'. Go to the system ',...
                'identification tab to open the system and generate ',...
                'models.'],'System saved','modal'));
        end  
    end
end
end

function teCallback(scr,~,userOpt,pCurVar,pHandle)
% set percentage of data for system estimation and polynomial order

errStat = 0;
options = get(userOpt,'userData');

if strcmp(get(scr,'tag'),'perc') && options.session.sys.detrended
    uiwait(errordlg(['Invalid operation! Polynomial detrending is ',...
        'applied separately to the estimation and validation data sets',...
        '. To change the percentage of data used for system estimation',...
        ' restore the signals first, so that detrending is performed ',...
        'correctly.'],'Invalid operation','modal'));
    errStat = 1;
end    

A=str2double(get(scr,'string'));
if ~isnan(A) && ~errStat
    % set boundries according to text edit tag
    if strcmp(get(scr,'tag'),'perc')
        loLim = 20; hiLim = 100;
        varName = 'percentage of data for system estimation';
    elseif strcmp(get(scr,'tag'),'poly')
        loLim = 1; hiLim = 10;
        varName = 'polynomial order';
    end

    if A >= loLim && A <= hiLim
        value = A;
    else
        uiwait(errordlg(['Value out of bounds! Please set the ',...
            varName,' between ',num2str(loLim),' and ',...
            num2str(hiLim),'.'],'Value out of bounds','modal'));
        errStat = 1;
    end

    if ~errStat
        if strcmp(get(scr,'tag'),'poly')
            value = round(value);
        end
        options.session.sys.(get(scr,'tag')) = value;

        set(userOpt,'userData',options);
        set(scr,'string',num2str(value));

        if strcmp(get(scr,'tag'),'perc') && ...
                ~isempty(options.session.sys.sigLen)
            plotFcn(pHandle,pCurVar,userOpt);
        end
    end
end
set(scr,'string',num2str(options.session.sys.(get(scr,'tag'))));
end

function pbView(scr,~,userOpt,pCurVar,pHandle)
% view filtered or detrended signal along with unprocessed signal

options = get(userOpt,'userData');
if ~isempty(options.session.sys.sigLen) 
    if strcmp(get(scr,'tag'),'filt') 
        if options.session.sys.filtered
            uiwait(errordlg(['Signals already filtered! The signals ',...
                'have already been filtered.'],...
                'Signals already filtered','modal'));
        else
            options.session.sys.viewFilter = 1;
        end
    elseif strcmp(get(scr,'tag'),'det')
        if options.session.sys.detrended
            uiwait(errordlg(['Signals already detrended! The signals ',...
                'have already been detrended.'],...
                'Signals already detrended','modal'));
        else
            options.session.sys.viewDetrend = 1;
        end
    end
    set(userOpt,'userData',options);

    plotFcn(pHandle,pCurVar,userOpt)
end
end

function pbFilterResponse(~,~)
% show Kaiser filter magnitude response

[n,Wn,beta,ftype] = kaiserord([0.5 0.7],[1 0],[0.01 0.01]);
kf = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
fvtool(kf);
end

function pbFilter(~,~,userOpt,pCurVar,pHandle)
% Filter signals with a low-pass Kaiser filter (anti-aliasing)

errStat = 0;
options = get(userOpt,'userData');

if options.session.sys.filtered
    uiwait(errordlg(['Signals already filtered! The signals have ',...
        'already been filtered.'],'Signals already filtered','modal'));
    errStat = 1;
elseif options.session.sys.viewDetrend
    uiwait(errordlg(['View mode! Please detrend the signals or exit ',...
        'detrended signals view mode before proceeding.'],'View mode',...
        'modal'));
    errStat = 1;
end

if ~errStat 
    % build Kaiser filter
    [n,Wn,beta,ftype] = kaiserord([0.5 0.7],[1 0],[0.01 0.01]);
    kf = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
    
    var = get(pCurVar,'userData');
    opt = {'output','input1','input2'};
    for i = 1:3
        if ~isempty(var.(opt{i}))
            var.(opt{i}) = filtfilt(kf,1,var.(opt{i}));
        end
    end
    
    options.session.sys.viewFilter = 0;
    options.session.sys.filtered = 1;
    
    set(userOpt,'userData',options);
    set(pCurVar,'userData',var);
    plotFcn(pHandle,pCurVar,userOpt);
end
end

function showTrends(~,~,userOpt,pCurVar)
% open window to show polynomial trends

errStat = 0;
options = get(userOpt,'userData');

if options.session.sys.viewFilter || options.session.sys.viewDetrend
    uiwait(errordlg(['View mode! Please filter/detrend the signals or ',...
        'exit view mode before proceeding.'],'View mode','modal'));
    errStat = 1;
elseif ~options.session.sys.detrended
    uiwait(errordlg(['Signals not detrended! Please detrend the ',...
        'signals, so that the trends are generated before proceeding.'],...
        'Signals not detrended','modal'));
    errStat = 1;
end

if ~isempty(options.session.sys.sigLen) && ~errStat
    
    trendWindow = figure(2); clf(trendWindow);
    set(trendWindow,'Position',[50 100 800 550],'Color',[.95 .95 .95],...
        'Name','CRSIDLab - Polynomial trends');

    uicontrol('Style','text','String','Polynomial trends','Position',...
        [340 520 150 20],'BackgroundColor',[.95 .95 .95],'FontSize',12);
    
    curVar = get(pCurVar,'userData');    
    trendLabel = {'outTrend','in1Trend','in2Trend'};
    t = (0:length(curVar.output)-1)/curVar.fs;
    tam = round((options.session.sys.perc/100)*length(t));
    noLines = 0;
    count = 1;
    yString = cell(3,1); trend = cell(6,1); time = cell(6,1);
    limLo = zeros(6,1); limHi = zeros(6,1);
    for i = 1:3
        if ~isempty(curVar.(trendLabel{i}).est)
            if i == 1, yString{i} = 'OUTPUT';
            elseif i == 2, yString{i} = 'INPUT 1';
            else yString{i} = 'INPUT 2';
            end
            noLines = noLines+1;
            trend{count} = curVar.(trendLabel{i}).est;
            time{count} = t(1:tam);
            count = count+1;
            if length(t)-tam>0
                trend{count} = curVar.(trendLabel{i}).val;
                time{count} = t(tam+1:end);
                limLo(count-1) = min([trend{count-1};trend{count}]);
                limHi(count-1) = max([trend{count-1};trend{count}]);
                limLo(count) = limLo(count-1);
                limHi(count) = limHi(count-1);
                count = count+1;
            else
                limLo(count-1) = min(trend{count-1});
                limHi(count-1) = max(trend{count-1});
            end
        end
    end 
    yString = yString(~cellfun(@isempty,yString));
    trend = trend(~cellfun(@isempty,trend));
    time = time(~cellfun(@isempty,time));
    limLo(count:end) = []; limHi(count:end) = [];
    
    if length(t)-tam>0
        noColumn = 2;
        titleString = {'Estimation data','Validation data'};
    else
        noColumn = 1;
        titleString = {'Estimation data'};
    end
    noPlots = noLines*noColumn;
    
    count = 1;
    for i = 1:noPlots
        subplot(noLines,noColumn,i)
        plot(time{i},trend{i});
        if i == 1
            title(titleString{1});
        elseif i == 2 && noColumn == 2
            title(titleString{2});
        end
        if (mod(i,2) && noColumn == 2) || noColumn == 1
            ylabel(yString{count});
            count = count+1;
        end
        axis([time{i}(1) time{i}(end) limLo(i) limHi(i)]);
    end
end
end

function pbDetrend(~,~,userOpt,pCurVar,pHandle)
% Detrend signals using a polynomial of user selected order

errStat = 0;
options = get(userOpt,'userData');

if options.session.sys.detrended
    uiwait(errordlg(['Signals already detrended! The signals have ',...
        'already been detrended. To detrend using a polynomial of ',...
        'different order, restore the signals first.'],...
        'Signals already detrended','modal'));
    errStat = 1;
elseif options.session.sys.viewFilter
    uiwait(errordlg(['View mode! Please filter the signals or exit ',...
        'filtered signals view mode before proceeding.'],'View mode',...
        'modal'));
    errStat = 1;
end

if ~errStat     
    var = get(pCurVar,'userData');
    opt = {'output','input1','input2'};
    trend = {'outTrend','in1Trend','in2Trend'};
    for i = 1:3
        if ~isempty(var.(opt{i}))
            [var.(opt{i}),var.(trend{i})] = identDetrend(var.(opt{i}),...
                var.fs,options.session.sys.perc,options.session.sys.poly);
        end
    end
    
    options.session.sys.viewDetrend = 0;
    options.session.sys.detrended = 1;
    
    set(userOpt,'userData',options);
    set(pCurVar,'userData',var);
    plotFcn(pHandle,pCurVar,userOpt);
end
end

function [signal,trend]=identDetrend(signal,fs,perc,polyOrd)
% polynomial detrend of estimation and validation portion of a signal

trend = struct;
tam = round((perc/100)*length(signal));
time = (0:length(signal)-1)/fs; time = time(:);
signalEst = signal(1:tam)-mean(signal(1:tam));
signalVal = signal(tam+1:end)-mean(signal(tam+1:end));

[pe,~,me] = polyfit(time(1:tam),signalEst,polyOrd);
trend.est = polyval(pe,time(1:tam),[],me);
signalEst = signalEst-trend.est;

[pv,~,mv] = polyfit(time(tam+1:end),signalVal,polyOrd);
trend.val = polyval(pv,time(tam+1:end),[],mv);
signalVal = signalVal-trend.val;

signal(1:tam) =  signalEst(:,1);
signal(tam+1:end) =  signalVal(:,1);
end

function exitView(~,~,userOpt,pCurVar,pHandle)
% eixt viewing of filtered or detrended signal

options = get(userOpt,'userData');
options.session.sys.viewFilter = 0;
options.session.sys.viewDetrend = 0;
set(userOpt,'userData',options);

plotFcn(pHandle,pCurVar,userOpt)
end

function value = checkLim(value,tag)

switch tag
    case 'perc'
        loLim = 20; hiLim = 100;
    case 'poly'
        loLim = 1; hiLim = 10;
end

if value < loLim, value = loLim; end
if value > hiLim, value = hiLim; end
end

function saveConfig(userOpt)
% save session configurations for next session

options = get(userOpt,'userData');
options.sys.perc = options.session.sys.perc;
options.sys.poly = options.session.sys.poly;
set(userOpt,'userData',options);
end