function alignMenu(pnAlign,pFile,pSig,userOpt,tbAn)
% AlignMenu - CRSIDLab
%   Menu for resampling and aligning any combination of the following
%   physiological variables: R-R intervals (RRI), systolic blood pressure
%   (SBP) or diastolic blood pressure (DBP) and instantaneous lung volume
%   (ILV). RRI output can be set to heart rate (HR). Ectopic (extrasystole)
%   beats and related BP variables can be removed or interpolated.
%
% Original Matlab code: Luisa Santiago C. B. da Silva, April 2017.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Data visualization
%

pHandle = struct; puVar = struct;

uicontrol('parent',pnAlign,'style','text','string','Select registers:',...
    'hor','left','units','normalized','position',[.032 .93 .1 .03]);
puVar.ecg = uicontrol('parent',pnAlign,'style','popupmenu','tag','ecg',...
    'string','No data available','value',1,'userData',1,'units',...
    'normalized','position',[.13 .93 .2 .04],'backgroundColor',[1 1 1]);

uicontrol('parent',pnAlign,'style','text','string','and / or:','units',...
    'normalized','position',[.34 .93 .04 .03]);
puVar.bp = uicontrol('parent',pnAlign,'style','popupmenu','tag','bp',...
    'string','No data available','value',1,'userData',1,'units',...
    'normalized','position',[.39 .93 .2 .04],'backgroundColor',[1 1 1]);

uicontrol('parent',pnAlign,'style','text','string','and / or:','units',...
    'normalized','position',[.6 .93 .04 .03]);
puVar.rsp = uicontrol('parent',pnAlign,'style','popupmenu','tag','rsp',...
    'string','No data available','value',1,'userData',1,'units',...
    'normalized','position',[.65 .93 .2 .04],'backgroundColor',[1 1 1]);

pHandle.single = axes('parent',pnAlign,'Units','normalized','Position',...
    [.057 .14 .67 .74],'nextPlot','replaceChildren','visible','on');
pHandle.double1 = axes('parent',pnAlign,'Units','normalized','Position',...
    [.057 .53 .67 .35],'nextPlot','replaceChildren','visible','off');
pHandle.double2 = axes('parent',pnAlign,'Units','normalized','Position',...
    [.057 .14 .67 .35],'nextPlot','replaceChildren','visible','off');
pHandle.triple1 = axes('parent',pnAlign,'tag','ecg','visible','off',...
    'Units','normalized','Position',[.057 .66 .68 .22],'nextPlot',...
    'replaceChildren');
pHandle.triple2 = axes('parent',pnAlign,'tag','bp','visible','off',...
    'Units','normalized','Position',[.057 .397 .68 .22],'nextPlot',...
    'replaceChildren');
pHandle.triple3 = axes('parent',pnAlign,'tag','rsp','visible','off',...
    'Units','normalized','Position',[.057 .14 .68 .22],'nextPlot',...
    'replaceChildren');

uicontrol('parent',pnAlign,'style','text','hor','right','string',...
    'Time (seconds) ','fontSize',10,'units','normalized','position',...
    [.634 .06 .1 .035]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Resampling method
%

pnResamp = uipanel('parent',pnAlign,'Units','normalized',...
    'Position',[.848 .715 .13 .165]);

uicontrol('parent',pnResamp,'Style','text','String','Resampling method',...
    'Units','Normalized','Position',[.05 .76 .9 .2]);

rbLinear = uicontrol('parent',pnResamp,'Style','radio','String',...
    'Linear interpolation','tag','rbMethod','userData',0,'Units',...
    'Normalized','Position',[.05 .52 .9 .2]);

rbCubic = uicontrol('parent',pnResamp,'Style','radio','String',...
    'Cubic interpolation','tag','rbMethod','userData',1,'Units',...
    'Normalized','Position',[.05 .28 .9 .2]);

rbBerger = uicontrol('parent',pnResamp,'Style','radio','String',...
    'Berger algorithm','CallBack',{@rbCallback,userOpt,rbCubic,...
    rbLinear},'tag','rbMethod','userData',2,'Units','Normalized',...
    'Position',[.05 .04 .9 .2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Removal/intepolation of ectopic beats and related BP variables
%

pnEct = uipanel('parent',pnAlign,'Units','normalized','Position',...
    [.748 .715 .1 .165]);

uicontrol('parent',pnEct,'Style','text','String','Ectopic Marks:',...
    'Units','Normalized','Position',[.05 .76 .9 .2]);

rbRemove = uicontrol('parent',pnEct,'Style','radio','String','Remove',...
    'tag','rbEctopic','userData',0,'Units','Normalized','Position',...
    [.05 .52 .9 .2]);

rbInterp = uicontrol('parent',pnEct,'Style','radio','String',...
    'Interpolate','tag','rbEctopic','userData',1,'Units','Normalized',...
    'Position',[.05 .28 .9 .2]);

rbDontRemove = uicontrol('parent',pnEct,'Style','radio','String',...
    'Don''t Remove','tag','rbEctopic','userData',2,'CallBack',...
    {@rbCallback,userOpt,rbRemove,rbInterp,[],pSig,pHandle,pFile},...
    'Units','Normalized','Position',[.05 .04 .9 .2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Start/end points for resampled signal
%

pnPoints = uipanel('parent',pnAlign,'Units','normalized','Position',...
    [.748 .435 .23 .28]);

uicontrol('parent',pnPoints,'Style','text','String',['Choose limits ',...
    'for resampling:'],'Units','Normalized','Position',...
    [.025 .845 .95 .105]);

uicontrol('parent',pnPoints,'Style','text','String','Start points',...
    'hor','left','Units','Normalized','Position',[.025 .71 .45 .105]);

uicontrol('parent',pnPoints,'Style','text','String','End points','hor',...
    'left','Units','Normalized','Position',[.5 .71 .475 .105]);

rbStartRRI = uicontrol('parent',pnPoints,'Style','radio','String',...
    'RRI: - s','tag','rbStart','userData',0,'Units','Normalized',...
    'Position',[.025 .585 .45 .105]);

rbStartBP = uicontrol('parent',pnPoints,'Style','radio','String',...
    'BP: - s','tag','rbStart','userData',1,'Units','Normalized',...
    'Position',[.025 .46 .45 .105]);

rbStartILV = uicontrol('parent',pnPoints,'Style','radio','String',...
    'ILV: - s','tag','rbStart','userData',2,'Units','Normalized',...
    'Position',[.025 .335 .45 .105]);

rbEndRRI = uicontrol('parent',pnPoints,'Style','radio','String',...
    'RRI: - s','tag','rbEnd','userData',0,'Units','Normalized',...
    'Position',[.5 .585 .475 .105]);

rbEndBP=uicontrol('parent',pnPoints,'Style','radio','String',...
    'BP: - s','tag','rbEnd','userData',1,'Units','Normalized',...
    'Position',[.5 .46 .475 .105]);

rbEndILV=uicontrol('parent',pnPoints,'Style','radio','String',...
    'ILV: - s','tag','rbEnd','userData',2,'Units','Normalized',...
    'Position',[.5 .335 .475 .105]);

rbEndSamp=uicontrol('parent',pnPoints,'Style','radio','String',...
    'No. of samples','tag','rbEnd','userData',3,'CallBack',...
    {@rbCallback,userOpt,rbEndRRI,rbEndBP,rbEndILV,pSig,pHandle},...
    'Units','Normalized','Position',[.5 .21 .475 .105]);

txEndSamp = uicontrol('parent',pnPoints,'Style','text','string',...
    '(Max: -)','Units','Normalized','Position',[.72 .03 .265 .13]);

teEndSamp=uicontrol('parent',pnPoints,'Style','edit','CallBack',...
    {@teEndCallback,userOpt,txEndSamp,pSig,pHandle},'Units',...
    'Normalized','Position',[.535 .05 .185 .13],'backgroundColor',[1 1 1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Method to treat signal borders
%

pnBorder = uipanel('parent',pnAlign,'Units','normalized','Position',...
    [.748 .315 .23 .12]);

uicontrol('parent',pnBorder,'Style','text','String',['Method to fill ',...
    'data borders:'],'Units','Normalized','Position',[.05 .685 .9 .26]);

rbConst = uicontrol('parent',pnBorder,'Style','radio','String',...
    'Constant padding (border values)','tag','rbBorder','userData',0,...
    'Units','Normalized','Position',[.05 .375 .9 .26]);

rbSymm = uicontrol('parent',pnBorder,'Style','radio','String',...
    'Symmetric extension','CallBack',{@rbCallback,userOpt,rbConst,[],[],...
    pSig,pHandle},'tag','rbBorder','userData',1,'Units','Normalized',...
    'Position',[.05 .06 .9 .26]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% RRI output signal (RRI or HR)
%

pnRRIOut = uipanel('parent',pnAlign,'Units','normalized','Position',...
    [.748 .225 .1 .09]);

uicontrol('parent',pnRRIOut,'Style','text','String','RRI output:',...
    'Units','Normalized','Position',[.05 .5 .9 .4]);

rbRRI = uicontrol('parent',pnRRIOut,'Style','radio','String','RRI',...
    'tag','rbRRIOut','userData',0,'Units','Normalized','Position',...
    [.05 .15 .425 .4]);

rbHR = uicontrol('parent',pnRRIOut,'Style','radio','String','HR',...
    'CallBack',{@rbCallback,userOpt,rbRRI},'tag','rbRRIOut','userData',...
    1,'Units','Normalized','Position',[.475 .15 .425 .4]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Resampling
%

pnFreq = uipanel('parent',pnAlign,'Units','normalized','Position',...
    [.848 .225 .13 .09]);

uicontrol('parent',pnFreq,'Style','text','String',['Resampling ',...
    'Frequency'],'Units','Normalized','Position',[.05 .5 .9 .4]);

teFreq = uicontrol('parent',pnFreq,'Style','edit','CallBack',...
    {@teFsCallback,userOpt,teEndSamp,txEndSamp,pSig,pHandle},'Units',...
    'Normalized','Position',[.08 .15 .35 .4],'backgroundColor',[1 1 1]);

uicontrol('parent',pnFreq,'Style','text','String','(1 to 10 Hz)',...
    'Units','Normalized','Position',[.45 .05 .5 .45]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot window length and position options
%

pnViewControl = uipanel('parent',pnAlign,'Units','normalized','Position',...
    [.748 .06 .1 .165]);

uicontrol('parent',pnViewControl,'Style','text','String',['Cur. ',...
    'Position:'],'Units','Normalized','Position',[.11 .8 .78 .15]);

teCurPos = uicontrol('parent',pnViewControl,'Style','edit','CallBack',...
    {@curPosCallback,pSig,userOpt,pHandle},'Units','Normalized',...
    'Position',[.3 .55 .4 .2],'backgroundColor',[1 1 1]);

uicontrol('parent',pnViewControl,'Style','text','String',['Window ',...
    'Length:'],'Units','Normalized','Position',[.11 .35 .78 .15]);

uicontrol('parent',pnViewControl,'Style','push','String','<','tag',...
    'left','Callback',{@shiftCallback,pSig,userOpt,teCurPos,...
    pHandle},'Units','normalized','Position',[.11 .1 .18 .2]);

uicontrol('parent',pnViewControl,'Style','push','String','>','tag',...
    'right','Callback',{@shiftCallback,pSig,userOpt,teCurPos,...
    pHandle},'Units','Normalized','Position',[.71 .1 .18 .2]);

teShift = uicontrol('parent',pnViewControl,'Style','edit','Callback',...
    {@windowLenCallback,pSig,userOpt,teCurPos,pHandle},'Units',...
    'Normalized','Position',[.3 .1 .4 .2],'backgroundColor',[1 1 1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Buttons (resample, save and restore)
%

pnSave = uipanel('parent',pnAlign,'Units','normalized','Position',...
    [.848 .06 .13 .165]);

uicontrol('parent',pnSave,'Style','push','String','Resample','CallBack',...
    {@resample,userOpt,pSig,pHandle,teCurPos,teShift},'Units',...
    'Normalized','Position',[.15 .635 .7 .27]);

uicontrol('parent',pnSave,'Style','push','String','Restore','CallBack',...
    {@restoreSig,userOpt,pFile,pSig,pHandle},'Units','Normalized',...
    'Position',[.15 .365 .7 .27]);

uicontrol('parent',pnSave,'Style','push','String','SAVE','CallBack',...
    {@saveSig,userOpt,pFile,pSig,puVar,tbAn,pHandle},'Units',...
    'Normalized','Position',[.15 .095 .7 .27]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Set final callbacks and call opening function (setup)
%

set(rbLinear,'callback',{@rbCallback,userOpt,rbCubic,rbBerger});
set(rbCubic,'callback',{@rbCallback,userOpt,rbLinear,rbBerger});

set(rbRemove,'CallBack',{@rbCallback,userOpt,rbDontRemove,rbInterp,[],...
    pSig,pHandle,pFile});
set(rbInterp,'CallBack',{@rbCallback,userOpt,rbRemove,rbDontRemove,[],...
    pSig,pHandle,pFile});

set(rbStartRRI,'CallBack',{@rbCallback,userOpt,rbStartBP,rbStartILV,[],...
    pSig,pHandle,[],teEndSamp,txEndSamp});
set(rbStartBP,'CallBack',{@rbCallback,userOpt,rbStartRRI,rbStartILV,[],...
    pSig,pHandle,[],teEndSamp,txEndSamp});
set(rbStartILV,'CallBack',{@rbCallback,userOpt,rbStartRRI,rbStartBP,[],...
    pSig,pHandle,[],teEndSamp,txEndSamp});

set(rbEndRRI,'CallBack',{@rbCallback,userOpt,rbEndSamp,rbEndBP,rbEndILV,...
    pSig,pHandle});
set(rbEndBP,'CallBack',{@rbCallback,userOpt,rbEndRRI,rbEndILV,rbEndSamp,...
    pSig,pHandle});
set(rbEndILV,'CallBack',{@rbCallback,userOpt,rbEndRRI,rbEndBP,rbEndSamp,...
    pSig,pHandle});

set(rbConst,'callback',{@rbCallback,userOpt,rbSymm,[],[],pSig,pHandle});

set(rbRRI,'callback',{@rbCallback,userOpt,rbHR});

set(puVar.ecg,'callback',{@changeVar,userOpt,pFile,pSig,rbBerger,...
    rbStartRRI,rbStartBP,rbStartILV,rbEndRRI,rbEndBP,rbEndILV,teEndSamp,...
    txEndSamp,teFreq,teShift,puVar,pHandle});
set(puVar.bp,'callback',{@changeVar,userOpt,pFile,pSig,rbBerger,...
    rbStartRRI,rbStartBP,rbStartILV,rbEndRRI,rbEndBP,rbEndILV,teEndSamp,...
    txEndSamp,teFreq,teShift,puVar,pHandle});
set(puVar.rsp,'callback',{@changeVar,userOpt,pFile,pSig,rbBerger,...
    rbStartRRI,rbStartBP,rbStartILV,rbEndRRI,rbEndBP,rbEndILV,teEndSamp,...
    txEndSamp,teFreq,teShift,puVar,pHandle});

openFnc(userOpt,pFile,pSig,puVar,rbLinear,rbCubic,rbBerger,rbRemove,...
    rbInterp,rbDontRemove,rbStartRRI,rbStartBP,rbStartILV,rbEndRRI,...
    rbEndBP,rbEndILV,rbEndSamp,teEndSamp,txEndSamp,rbConst,rbSymm,rbRRI,...
    rbHR,teFreq,teCurPos,teShift,pHandle);
end

function plotFcn(pHandle,pSig,userOpt)
% adjust handles visibility and plot all selected signals

options = get(userOpt,'userData');

% find how many of the three slots have valid variable identification (are
% selected)
aux = options.session.align.sigSpec(~cellfun(@isempty,...
    options.session.align.sigSpec));
if length(aux) == 3     % three plots must be showed on screen
    
    % set single and double plots visibility off
    set(pHandle.single,'visible','off');
    set(get(pHandle.single,'children'),'visible','off');
    set(pHandle.double1,'visible','off');
    set(get(pHandle.double1,'children'),'visible','off');
    set(pHandle.double2,'visible','off');
    set(get(pHandle.double2,'children'),'visible','off');
    
    % set triple plots visibility on
    set(pHandle.triple1,'visible','on');
    set(get(pHandle.triple1,'children'),'visible','on');
    set(pHandle.triple2,'visible','on');
    set(get(pHandle.triple2,'children'),'visible','on');
    set(pHandle.triple3,'visible','on');
    set(get(pHandle.triple3,'children'),'visible','on');
    
    % call plotting functions
    alignPlot(pHandle.triple1,pSig,userOpt);
    alignPlot(pHandle.triple2,pSig,userOpt);
    alignPlot(pHandle.triple3,pSig,userOpt);
    
elseif length(aux) == 2 % two plots must be shown on screeen
    
    % set single and triple plots visibility off
    set(pHandle.single,'visible','off');
    set(get(pHandle.single,'children'),'visible','off');
    set(pHandle.triple1,'visible','off');
    set(get(pHandle.triple1,'children'),'visible','off');
    set(pHandle.triple2,'visible','off');
    set(get(pHandle.triple2,'children'),'visible','off');
    set(pHandle.triple3,'visible','off');
    set(get(pHandle.triple3,'children'),'visible','off');
    
    % set double plots visibility on
    set(pHandle.double1,'visible','on');
    set(get(pHandle.double1,'children'),'visible','on');
    set(pHandle.double2,'visible','on');
    set(get(pHandle.double2,'children'),'visible','on');
    
    % identify the variable on each plot
    if ~isempty(options.session.align.sigSpec{1})
        set(pHandle.double1,'tag','ecg');
        if ~isempty(options.session.align.sigSpec{2})
            set(pHandle.double2,'tag','bp');
        else
            set(pHandle.double2,'tag','rsp');
        end
    else
        set(pHandle.double1,'tag','bp');
        set(pHandle.double2,'tag','rsp');
    end
    
    % call plotting functions
    alignPlot(pHandle.double1,pSig,userOpt);
    alignPlot(pHandle.double2,pSig,userOpt);
else    
    % set double and triple plots visibility off
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
    
    % set single plots visibility on
    set(pHandle.single,'visible','on');
    
    if length(aux) == 1
        % identify the variable on the plot
        if ~isempty(options.session.align.sigSpec{1})
            set(pHandle.single,'tag','ecg');
        elseif ~isempty(options.session.align.sigSpec{2})
            set(pHandle.single,'tag','bp');
        elseif ~isempty(options.session.align.sigSpec{3})
            set(pHandle.single,'tag','rsp');
        end
        % call plotting function
        alignPlot(pHandle.single,pSig,userOpt);
        set(get(pHandle.single,'children'),'visible','on');
    else
        % no variables displayed
        ylabel(pHandle.single,'');
        set(get(pHandle.single,'children'),'visible','off');
    end
end
end

function openFnc(userOpt,pFile,pSig,puVar,rbLinear,rbCubic,rbBerger,...
    rbRemove,rbInterp,rbDontRemove,rbStartRRI,rbStartBP,rbStartILV,...
    rbEndRRI,rbEndBP,rbEndILV,rbEndSamp,teEndSamp,txEndSamp,rbConst,...
    rbSymm,rbRRI,rbHR,teFreq,teCurPos,teShift,pHandle)
% adjust initial values of objects when tab opens

options = get(userOpt,'userData');
patient = get(pFile,'userData');

% create string for variable selection popupmenus (ECG, BP and ILV) from 
% available patient data
id = {'ecg','bp','rsp'};
for i = 1:3
    if i == 1, var = {'rri'};
    elseif i == 2, var = {'sbp','dbp'};
    else var = {'ilv','filt'};
    end
    stringPU = cell(2*length(var),1);
    for j = 1:length(var)
        if ~isempty(patient.sig.(id{i}).(var{j}).data)
            % create variable text identifiers
            if strcmp(id{i},'rsp')
                if strcmp(var{j},'filt')
                    stringPU{j} = 'Filtered ILV data';
                else
                    stringPU{j} = 'ILV data';
                end
            else
                stringPU{j} = [upper(var{j}),' data'];
            end
        end
        % build list
        if ~isempty(patient.sig.(id{i}).(var{j}).aligned.data)
            stringPU{j+length(var)} = patient.sig.(id{i}).(...
                var{j}).aligned.specs.tag;
        end
    end
    stringPU = stringPU(~cellfun(@isempty,stringPU)); % clear empty slots
    
    if isempty(stringPU)
        % indicate user if no data is available for each popup menu
        if strcmp(id{i},'rsp')
            stringPU{1} = 'No respiration data available';
        else
            stringPU{1} = ['No ',upper(id{i}),' data available'];
        end
        options.session.align.varString.(id{i}) = stringPU;
    else
        % add instruction on first line if there is data available
        stringPU(2:end+1) = stringPU(1:end);
        if strcmp(id{i},'rsp')
            stringPU{1} = 'Indicate respiration data';
        else
            stringPU{1} = ['Indicate ',upper(id{i}),' data'];
        end
    end
    
    % adjust selection value if the variables list has changed
    if ~isequal(options.session.align.varString.(id{i}),stringPU)
        if length(options.session.align.varString.(id{i})) > 1
            if ismember(options.session.align.varString.(id{i}){...
                    options.session.align.varValue.(id{i})},stringPU)
                % find position of the selected variable on the list
                options.session.align.varValue.(id{i}) = find(ismember(...
                    stringPU,options.session.align.varString.(id{i}){...
                    options.session.align.varValue.(id{i})}));
            else
                % if no valid variable is found, select no variable
                options.session.align.varValue.(id{i}) = 1;
            end
        end
        options.session.align.varString.(id{i}) = stringPU;
    end
    
    % update popup menus list and values
    set(puVar.(id{i}),'string',...
        options.session.align.varString.(id{i}));
    set(puVar.(id{i}),'value',options.session.align.varValue.(id{i}));
    set(puVar.(id{i}),'userData',...
        options.session.align.varValue.(id{i}));
end

% open data and setup options that depend on the data
set(userOpt,'userData',options);
setup(userOpt,pFile,pSig,rbBerger,rbStartRRI,rbStartBP,rbStartILV,...
    rbEndRRI,rbEndBP,rbEndILV,teEndSamp,txEndSamp,teFreq,teShift);
options = get(userOpt,'userData');

% setup options that don't depend on the data from previous user settings
set(teCurPos,'string',num2str(options.session.align.curPos));
set(teShift,'string',num2str(options.session.align.windowLen));

set(rbLinear,'value',0);
set(rbCubic,'value',0);
set(rbBerger,'value',0);
if options.session.align.rbMethod == 0, set(rbLinear,'value',1);
elseif options.session.align.rbMethod == 1, set(rbCubic,'value',1);
else set(rbBerger,'value',1);
end

set(rbRemove,'value',0);
set(rbInterp,'value',0);
set(rbDontRemove,'value',0);
if options.session.align.rbEctopic == 0, set(rbRemove,'value',1);
elseif options.session.align.rbEctopic == 1, set(rbInterp,'value',1);
else set(rbDontRemove,'value',1);
end

set(rbStartRRI,'value',0);
set(rbStartBP,'value',0);
set(rbStartILV,'value',0);
if options.session.align.rbStart == 0, set(rbStartRRI,'value',1);
elseif options.session.align.rbStart == 1, set(rbStartBP,'value',1);
else set(rbStartILV,'value',1);
end

set(rbEndRRI,'value',0);
set(rbEndBP,'value',0);
set(rbEndILV,'value',0);
set(rbEndSamp,'value',0);
if options.session.align.rbEnd == 0, set(rbEndRRI,'value',1);
elseif options.session.align.rbEnd == 1, set(rbEndBP,'value',1);
elseif options.session.align.rbEnd == 2, set(rbEndILV,'value',1);
else set(rbEndSamp,'value',1);
end

set(rbConst,'value',0);
set(rbSymm,'value',0);
if options.session.align.rbBorder == 0, set(rbConst,'value',1);
else set(rbSymm,'value',1);
end

set(rbRRI,'value',0);
set(rbHR,'value',0);
if options.session.align.rbRRIOut == 0, set(rbRRI,'value',1);
else set(rbHR,'value',1);
end

set(userOpt,'userData',options);
plotFcn(pHandle,pSig,userOpt);
end

function setup(userOpt,pFile,pSig,rbBerger,rbStartRRI,rbStartBP,...
    rbStartILV,rbEndRRI,rbEndBP,rbEndILV,teEndSamp,txEndSamp,teFreq,...
    teShift)
% open data and setup options that depend on the data

options = get(userOpt,'userData');

% identify selected data
auxVarECG = options.session.align.varString.ecg{...
    options.session.align.varValue.ecg};
auxVarBP = options.session.align.varString.bp{...
    options.session.align.varValue.bp};
auxVarRSP = options.session.align.varString.rsp{...
    options.session.align.varValue.rsp};

% create internal identifiers for opened variables
type = cell(3,1);
if ~isempty(strfind(auxVarECG,'RRI')) || ~isempty(strfind(auxVarECG,'HR'))
    type{1} = 'rri';
end
if ~isempty(strfind(auxVarBP,'SBP')), type{2} = 'sbp';
elseif ~isempty(strfind(auxVarBP,'DBP')), type{2} = 'dbp'; end
if ~isempty(strfind(auxVarRSP,'Filtered')), type{3} = 'filt';
elseif ~isempty(strfind(auxVarRSP,'ILV')), type{3} = 'ilv'; end
options.session.align.sigSpec = type;
options.session.align.sigLen = [];

% verify if opened data is already resampled (opened for viewing)
if ~isempty(strfind(auxVarECG,'A&R')) || ~isempty(strfind(auxVarBP,...
        'A&R')) || ~isempty(strfind(auxVarRSP,'A&R'))
    options.session.align.resampled = 1;
else
    options.session.align.resampled = 0;
end

% open data and setup options
if ~isempty(type{1}) || ~isempty(type{2}) || ~isempty(type{3})
    patient = get(pFile,'userData');
    signals = get(pSig,'userData');
    
    % load variables, initial time and length
    id = {'ecg','bp','rsp'};
    auxSigLen = zeros(1,3); auxInit = ones(1,3)*inf;
    for i = 1:3
        if ~isempty(type{i})
            if options.session.align.resampled
                signals.(id{i}).(type{i}).aligned = ...
                    patient.sig.(id{i}).(type{i}).aligned;
                auxInit(i) = signals.(id{i}).(type{i}).aligned.time(1);
                auxSigLen(i) = signals.(id{i}).(type{i}).aligned.time(end);
                options.session.align.resampled = 1;
            else
                signals.(id{i}).(type{i}) = patient.sig.(id{i}).(type{i});
                
                % adjust fs & time array, if not provided by user)
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
                        (0:(length(signals.(id{i}).(type{i}).data)-1)) /...
                        signals.(id{i}).(type{i}).fs;
                end
                signals.(id{i}).(type{i}).aligned = dataPkg.alignedUnit;
                auxInit(i) = signals.(id{i}).(type{i}).time(1);
                auxSigLen(i) = signals.(id{i}).(type{i}).time(end);
            end
        end
    end
    options.session.align.sigLen = max(auxSigLen);  % signal length
    options.session.align.offset = min(auxInit);    % data set t(0)
    
    if max(auxSigLen) ~= 0
        % total length, considering time displacement between variables
        options.session.align.sigLen = max(auxSigLen) - min(auxInit);
    else
        options.session.align.sigLen = [];
    end
    
    % adjus time arrays (min t(0) is set to 0)
    for i = 1:3
        if ~isempty(type{i})
            signals.(id{i}).(type{i}).time = ...
                signals.(id{i}).(type{i}).time - min(auxInit);
        end
    end
    
    % adjust window length if it is larger than the signal length
    if options.session.align.sigLen - options.session.align.windowLen <= 0
        options.session.align.windowLen = options.session.align.sigLen;
        set(teShift,'String',num2str(options.session.align.windowLen));
    end
    
    set(pFile,'userData',patient);
    set(pSig,'userData',signals);
end

% Berger algorithm is only an option if ECG or BP variable is opened
if isempty(type{1}) && isempty(type{2})
    set(rbBerger,'enable','off');
else
    set(rbBerger,'enable','on');
end

% set up options depending on ECG data
if ~isempty(type{1})
    set(rbStartRRI,'enable','on');
    set(rbEndRRI,'enable','on');
    if ~options.session.align.resampled
        set(rbStartRRI,'String',sprintf('RRI: %g s',round(1000*...
            signals.ecg.(type{1}).time(1))/1000));
        set(rbEndRRI,'String',sprintf('RRI: %g s',round(1000*...
            signals.ecg.(type{1}).time(end))/1000));
    else
        set(rbStartRRI,'String',sprintf('RRI: %g s',round(1000*...
            signals.ecg.(type{1}).aligned.time(1))/1000));
        set(rbEndRRI,'String',sprintf('RRI: %g s',round(1000*...
            signals.ecg.(type{1}).aligned.time(end))/1000));
    end
else
    set(rbStartRRI,'enable','off');
    set(rbStartRRI,'String','RRI: - s');
    set(rbEndRRI,'enable','off');
    set(rbEndRRI,'String','RRI: - s');
end

% set up options depending on BP data
if ~isempty(type{2})
    set(rbStartBP,'enable','on');
    set(rbEndBP,'enable','on');
    if ~options.session.align.resampled
        set(rbStartBP,'String',sprintf([upper(type{2}),': %g s'],round(...
            1000*signals.bp.(type{2}).time(1))/1000));
        set(rbEndBP,'String',sprintf([upper(type{2}),': %g s'],round(...
            1000*signals.bp.(type{2}).time(end))/1000));
    else
        set(rbStartBP,'String',sprintf([upper(type{2}),': %g s'],round(...
            1000*signals.bp.(type{2}).aligned.time(1))/1000));
        set(rbEndBP,'String',sprintf([upper(type{2}),': %g s'],round(...
            1000*signals.bp.(type{2}).aligned.time(end))/1000));
    end
else
    set(rbStartBP,'enable','off');
    set(rbStartBP,'String','BP: - s');
    set(rbEndBP,'enable','off');
    set(rbEndBP,'String','BP: - s');
end

% set up options depending on respiration data
if ~isempty(type{3})
    set(rbStartILV,'enable','on');
    set(rbEndILV,'enable','on');
    if ~options.session.align.resampled
        set(rbStartILV,'String',sprintf('ILV: %g s',round(1000*...
            signals.rsp.(type{3}).time(1))/1000));
        set(rbEndILV,'String',sprintf('ILV: %g s',round(1000*...
            signals.rsp.(type{3}).time(end))/1000));
    else
        set(rbStartILV,'String',sprintf('ILV: %g s',round(1000*...
            signals.rsp.(type{3}).aligned.time(1))/1000));
        set(rbEndILV,'String',sprintf('ILV: %g s',round(1000*...
            signals.rsp.(type{3}).aligned.time(end))/1000));
    end
else
    set(rbStartILV,'enable','off');
    set(rbStartILV,'String','ILV: - s');
    set(rbEndILV,'enable','off');
    set(rbEndILV,'String','ILV: - s');
end

if ~isempty(options.session.align.sigLen)
    if ~options.session.align.resampled
        % set up start point for the data set from current options
        if ~isempty(type{options.session.align.rbStart+1})
            options.session.align.startPoint = signals.(id{...
                options.session.align.rbStart+1}).(type{...
                options.session.align.rbStart+1}).time(1);
        else
            options.session.align.startPoint = 0;
        end
        % set up end point for the data set from current options
        if options.session.align.rbEnd ~= 3
            if ~isempty(type{options.session.align.rbEnd+1})
                options.session.align.endPoint = signals.(id{...
                    options.session.align.rbEnd+1}).(type{...
                    options.session.align.rbEnd+1}).time(end);
            else
                options.session.align.endPoint = ...
                    (options.session.align.sigLen-1)/...
                    options.session.align.resampFs;
            end
        end
    else
        if ~isempty(type{options.session.align.rbStart+1})
            options.session.align.startPoint = signals.(id{...
                options.session.align.rbStart+1}).(type{...
                options.session.align.rbStart+1}).aligned.time(1);
        else
            options.session.align.startPoint = 0;
        end
        if options.session.align.rbEnd ~= 3
            if ~isempty(type{options.session.align.rbEnd+1})
                options.session.align.endPoint = signals.(id{...
                    options.session.align.rbEnd+1}).(type{...
                    options.session.align.rbEnd+1}).aligned.time(end);
            else
                options.session.align.endPoint = ...
                    (options.session.align.sigLen-1)/...
                    options.session.align.resampFs;
            end
        end
    end
    
    % set maximum points possible from current configurations
    pointsMax = floor((options.session.align.sigLen - ...
        options.session.align.startPoint) * ...
        options.session.align.resampFs) + 1;
    if options.session.align.points > pointsMax
        options.session.align.points = pointsMax;
    end
    if options.session.align.rbEnd == 3
        options.session.align.endPoint = ...
            options.session.align.startPoint + ...
            (options.session.align.points - 1) /...
            options.session.align.resampFs;
    end
end

% maximum number of points indicated on screen
if exist('pointsMax','var')
    set(txEndSamp,'string',sprintf('(Max: %g)',pointsMax));
else
    set(txEndSamp,'string','(Max: -)');
end

options.session.align.saved = 0;
options.session.align.proc = 0;

% ensure values are within the appropriate range
if options.session.align.resampFs<1, options.session.align.resampFs = 1;end
if options.session.align.resampFs>10,options.session.align.resampFs=10;end
if options.session.align.points<2, options.session.align.points = 2;end

set(teFreq,'string',num2str(options.session.align.resampFs));
set(teEndSamp,'string',num2str(options.session.align.points));
set(userOpt,'userData',options);
ectopic(userOpt,pSig,pFile); % plot ectopics according to selected handling
end

function changeVar(scr,~,userOpt,pFile,pSig,rbBerger,rbStartRRI,...
    rbStartBP,rbStartILV,rbEndRRI,rbEndBP,rbEndILV,teEndSamp,txEndSamp,...
    teFreq,teShift,puVar,pHandle)
% change record for variable extraction

oldValue = get(scr,'userData');
newValue = get(scr,'value');
if oldValue ~= newValue
    options = get(userOpt,'userData');
    errStat = 0;
    
    % find other PU tags
    tags = {'ecg','bp','rsp'};
    tags = tags(~ismember(tags,get(scr,'tag')));

    % number of opened signals besides the current in exchange
    noSignals = 0;
    for i = 1:2
        if options.session.align.varValue.(tags{i})~=1
            noSignals = noSignals+1;
        end
    end
    
    auxVar = options.session.align.varString.(get(scr,'tag')){newValue};
    type = {'ecg','bp','rsp'};
    if ~options.session.align.saved && options.session.align.proc
        [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
            'changeVarAlignPref','Change data',sprintf([...
            'Warning!','\nThe current data has not been saved. Any ',...
            'modifications will be lost if other data is opened before',...
            ' saving.\nAre you sure you wish to proceed?']),...
            {'Yes','No'},'DefaultButton','No');
        if strcmp(selButton,'no') && dlgShow
            errStat = 1;
        end
    end
    if ~isempty(strfind(auxVar,'A&R')) && ...
            ~options.session.align.resampled && ...
            ~isempty(options.session.align.sigLen) && noSignals>0
        [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
            'openViewOnlyPref','Opening variables',sprintf([...
            'Warning!','\nAligned and resampled data may not be viewed',...
            ' along with data that has not been aligned and resampled.',...
            '\nOpening aligned and resampled data, for viewing only, ',...
            'will automatically close any data that is not aligned and',...
            ' resampled and open its aligned and resampled version, ',...
            'when available.\nAre you sure you wish to proceed?']),...
            {'Yes','No'},'DefaultButton','No');
        if strcmp(selButton,'no') && dlgShow
            set(scr,'value',oldValue);
            errStat = 1;
        else
            for i = 1:3
                if ~strcmp(get(scr,'tag'),type{i})
                    auxVar2 = options.session.align.varString.(type{i}){...
                        options.session.align.varValue.(type{i})};
                    if isempty(strfind(auxVar2,'A&R'))
                        auxVar2 = ['A&R ',auxVar2]; %#ok<AGROW>
                        auxInd = strfind(options.session.align.varString.(...
                            type{i}), auxVar2);
                        if any(~cellfun(@isempty,auxInd))
                            options.session.align.varValue.(type{i}) = ...
                                find(~cellfun(@isempty,auxInd),1);
                        else
                            options.session.align.varValue.(type{i}) = 1;
                        end
                        set(puVar.(type{i}),'value',...
                            options.session.align.varValue.(type{i}));
                        set(puVar.(type{i}),'userData',...
                            options.session.align.varValue.(type{i}));
                    end
                end
            end
        end
    elseif isempty(strfind(auxVar,'A&R')) && newValue~=1 && ...
            options.session.align.resampled && ...
            ~isempty(options.session.align.sigLen) && noSignals>0
        [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
            'openVarPref','Opening variables',sprintf([...
            'Warning!','\nData that is not aligned and resampled may ',...
            'not be viewed along with aligned and resampled data.',...
            '\nOpening data that is not aligned and resampled will ',...
            'automatically close any resampled and aligned data and ',...
            'open its original version, when available.\nAre you sure ',...
            ' you wish to proceed?']),{'Yes','No'},'DefaultButton','No');
        if strcmp(selButton,'no') && dlgShow
            set(scr,'value',oldValue);
            errStat = 1;
        else
            options.session.align.resampled = 0;
            for i = 1:3
                if ~strcmp(get(scr,'tag'),type{i})
                    auxVar2 = options.session.align.varString.(type{i}){...
                        options.session.align.varValue.(type{i})};
                    if ~isempty(strfind(auxVar2,'A&R'))
                        auxStr = (options.session.align.varString.(...
                            type{i}));
                        auxInd = strfind(auxStr, auxVar2);
                        auxInd = find(~cellfun(@isempty,auxInd),1);
                        auxStr(auxInd) = [];
                        auxInd = strfind(auxStr, auxVar2(5:12));
                        if any(~cellfun(@isempty,auxInd))
                            options.session.align.varValue.(type{i}) = ...
                                find(~cellfun(@isempty,auxInd),1);
                        else
                            options.session.align.varValue.(type{i}) = 1;
                        end
                        set(puVar.(type{i}),'value',...
                            options.session.align.varValue.(type{i}));
                        set(puVar.(type{i}),'userData',...
                            options.session.align.varValue.(type{i}));
                    end
                end
            end
        end
    end
    
    if ~errStat
        options.session.align.varValue.(get(scr,'tag')) = newValue;
        set(scr,'userData',newValue);
        set(userOpt,'userData',options);
        
        setup(userOpt,pFile,pSig,rbBerger,rbStartRRI,rbStartBP,...
            rbStartILV,rbEndRRI,rbEndBP,rbEndILV,teEndSamp,txEndSamp,...
            teFreq,teShift);
        plotFcn(pHandle,pSig,userOpt);
    else
        set(scr,'value',oldValue);
    end
end
end

function restoreSig(~,~,userOpt,pFile,pSig,pHandle)
% restore selected records from disk

errStat = 0;
options = get(userOpt,'userData');
if ~isempty(options.session.align.sigLen)
    id = {'ecg','bp','rsp'};
    for i = 1:3
        auxVar = options.session.align.varString.(id{i}){...
            options.session.align.varValue.(id{i})};
        if ~isempty(strfind(auxVar,'A&R'))
            errStat = 1;
        end
    end
    
    if errStat
        uiwait(errordlg(['View only! The Aligned and Resampled ',...
            'variables have been saved. Restoring is not possible. ',...
            'If you wish, open the unprocessed data through the ',...
            'selection menu.'],'No changes made','modal'));
    else
        signals = get(pSig,'userData');
        patient = get(pFile,'userData');
        
        type = options.session.align.sigSpec;
        auxSigLen = zeros(3,1);
        for i = 1:3
            if ~isempty(type{i})
                signals.(id{i}).(type{i}) = patient.sig.(id{i}).(type{i});
                signals.(id{i}).(type{i}).time = ...
                    signals.(id{i}).(type{i}).time - ...
                    options.session.align.offset;
                auxSigLen(i) = signals.(id{i}).(type{i}).time(end);
            end
        end
        
        options.session.align.sigLen = max(auxSigLen);
        options.session.align.resampled = 0;
        options.session.align.saved = 0;
        set(userOpt,'userData',options);
        set(pSig,'userData',signals);
        ectopic(userOpt,pSig,pFile);
        plotFcn(pHandle,pSig,userOpt);
    end
end
end

function saveSig(~,~,userOpt,pFile,pSig,puVar,tbAn,pHandle)
% save selected data

options = get(userOpt,'userData');
if ~isempty(options.session.align.sigLen) && ~options.session.align.saved
    errStat = 0; saved = 0;
    type = options.session.align.sigSpec;
    prevType = [];
    
    % verify if there's already rri/sbp/dbp data saved
    patient = get(pFile,'userData');
    if ~isempty(type{1})
        if ~isempty(patient.sig.ecg.(type{1}).aligned.data)
            saved = 1;
        end
    end
    if ~isempty(type{2})
        if ~isempty(patient.sig.bp.(type{2}).aligned.data)
            saved = 1;
        end
    end
    if ~isempty(type{3})
        if ~isempty(patient.sig.rsp.(type{3}).aligned.data)
            saved = 1;
        end
    end
    
    ecgString = []; bpString = []; rspString = [];
    if ~options.session.align.resampled
        uiwait(errordlg(['No changes made! You must resample the ',...
            'variables before saving.'],'No changes made','modal'));
        errStat = 1;
    end
    if ~errStat && saved
        futureData = 0;
        prevSys = fieldnames(patient.sys);
        for i = 1:3
            for j = 1:length(prevSys)
                if ~isempty(type{i})
                    if strcmp(type{i},'filt')
                        if strcmpi('Filtered ILV',patient.sys.(prevSys{...
                                j}).data.OutputName) || any(ismember(...
                                patient.sys.(prevSys{j}).data.InputName,...
                                'Filtered ILV'))
                            futureData = 1;
                        end
                    else
                        if strcmpi(type{i},patient.sys.(prevSys{...
                                j}).data.OutputName) || any(ismember(...
                                patient.sys.(prevSys{j}).data.InputName,...
                                upper(type{i})))
                            futureData = 1;
                        end
                    end
                end
            end
        end
        if ~isempty(type{1})
            if ~isempty(patient.sig.ecg.rri.aligned.data)
                ecgString = '\n RRI';
            end
        end
        if ~isempty(type{2})
            if ~isempty(patient.sig.bp.(type{2}).aligned.data)
                bpString = ['\n ',upper(type{2})];
            end
        end
        if ~isempty(type{3})
            if ~isempty(patient.sig.rsp.(type{3}).aligned.data)
                if strcmp(type{3},'filt')
                    rspString = '\n Filtered ILV';
                else
                    rspString = '\n ILV';
                end
            end
        end
        varString = [ecgString,bpString,rspString];
        if futureData
            [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
                'saveAlignOW1Pref','Saving variables',sprintf(...
                ['Warning!','\nIt appears that there''s already ',...
                'data saved for the following variable(s):',varString,...
                '\n\nATENTION: There is at least one system saved ',...
                'containing at least one of the indicated variables.\n',...
                'Overwriting this record will erase all data derived ',...
                'from it, including any systems or models.\n\nHow ',...
                'would you like to proceed?\n(Obs.: To save only the ',...
                'variables that have no previous data saved, click ',...
                '''Save new'')']),{'Save new','Save all','Don''t save'},...
                'DefaultButton','Don''t save');
        else
            [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
                'saveAlignOW2Pref','Saving variables',sprintf([...
                'Warning!','\nIt appears that there''s already data ',...
                'saved for the following variable(s):',varString,'.\n',...
                '\nHow would you like to proceed?\n(Obs.: To save only',...
                ' the variables that have no previous data saved,\n',...
                'click ''Save new'')']),{'Save new','Save all',...
                'Don''t save'},'DefaultButton','Don''t save');
        end
        if strcmp(selButton,'don''t save') && dlgShow
            errStat = 1;
        elseif strcmp(selButton,'save new')
            prevType = type;
            if ~isempty(ecgString), type{1} = []; end
            if ~isempty(bpString), type{2} = []; end
            if ~isempty(rspString), type{3} = []; end
        end
    end
    
    if ~errStat
        % save all available signals
        filename = options.session.filename;
        patient = get(pFile,'userData');
        signals = get(pSig,'userData');
        id = {'ecg','bp','rsp'};
        for i = 1:3
            if ~isempty(type{i})
                patient.sig.(id{i}).(type{i}).aligned = ...
                    signals.(id{i}).(type{i}).aligned;
                curVar = options.session.align.varString.(id{i}){...
                    options.session.align.varValue.(id{i})};
                
                % remove corresponding future data (systems, models)
                prevSys = fieldnames(patient.sys);
                for j = 1:length(prevSys)
                    if strcmp(curVar(1:end-5),patient.sys.(prevSys{...
                            j}).data.OutputName) || any(ismember(...
                            patient.sys.(prevSys{j}).data.InputName,...
                            curVar(1:end-5)))
                        patient.sys = rmfield(patient.sys,prevSys{j});
                    end
                end
                % adjust 'create system' data selection
                puOpt = {'out','in1','in2'}; erasedFlag = 0;
                for j = 1:3
                    if ~isempty(options.session.sys.varString.(puOpt{j}))
                        auxVar = options.session.sys.varString.(puOpt{...
                            j}){options.session.sys.varValue.(puOpt{j})};
                        if erasedFlag || ~isempty(strfind(auxVar,curVar))
                            options.session.sys.varValue.(puOpt{j}) = 1;
                        end
                        erasedFlag = 1;
                    end
                end
                
                nextVar = signals.(id{i}).(type{i}).aligned.specs.tag;
                stringPU = get(puVar.(id{i}),'string');
                stringPU{end+1} = nextVar; %#ok<AGROW>
                stringPU = unique(stringPU,'stable');
                options.session.align.varValue.(id{i}) = find(ismember(...
                    stringPU,nextVar));
                if isempty(options.session.align.varValue.(id{i}))
                    options.session.align.varValue.(id{i}) = 1;
                end
                
                options.session.align.varString.(id{i}) = stringPU;
                set(puVar.(id{i}),'string',...
                    options.session.align.varString.(id{i}));
                set(puVar.(id{i}),'value',...
                    options.session.align.varValue.(id{i}));
                set(puVar.(id{i}),'userData',...
                    options.session.align.varValue.(id{i}));
            end
        end
        
        % adjust variables if only a selection was saved
        if ~isempty(prevType)
            for i = 1:3 
                if ~isempty(prevType{i}) && ~isempty(type{i})
                    nextVar = signals.(id{i}).(type{i}).aligned.specs.tag;
                    options.session.align.varValue.(id{i}) = find(...
                        ismember(options.session.align.varString.(...
                        id{i}),nextVar));
                else
                    options.session.align.varValue.(id{i}) = 1;
                    options.session.align.sigSpec{i} = [];
                end
                set(puVar.(id{i}),'value',...
                    options.session.align.varValue.(id{i}));
                set(puVar.(id{i}),'userData',...
                    options.session.align.varValue.(id{i}));
            end
        end
        
        options.session.align.saved = 1;
        signals = patient.sig;
        set(pSig,'userData',signals);
        set(userOpt,'userData',options);
        set(tbAn,'enable','on');     % enable analysis tab
        set(pFile,'userData',patient);
        save(filename,'patient');
        plotFcn(pHandle,pSig,userOpt)
        
        ecgSaved = ''; bpSaved = ''; rspSaved='';
        if ~isempty(type{1})
            if options.session.align.rbRRIOut, ecgSaved = ' \nA&R RRI';
            else ecgSaved = ' \nA&R HR';
            end
        end
        if ~isempty(type{2})
            bpSaved = [' \nA&R ',upper(type{2})];
        end
        if ~isempty(type{3})
            if strcmp(type{3},'ilv'), rspSaved = ' \nA&R ILV';
            else rspSaved = ' \nA&R Filtered ILV';
            end
        end
        msgString = [ecgSaved,bpSaved,rspSaved];
        uiwait(msgbox(sprintf(['The following variables have been ',...
            'saved:',msgString]),'Variables saved','modal'));
    end
end
end

function curPosCallback(scr,~,pSig,userOpt,pHandle)
% adjust current window position

options = get(userOpt,'userData');
A=str2double(get(scr,'String'));
if ~isnan(A)
    if ~isempty(options.session.align.sigLen)
        maxLim = options.session.align.sigLen - ...
            options.session.align.windowLen;
    else
        maxLim = inf;
    end
    
    if A <= maxLim && A >= 0
        options.session.align.curPos = round(1000*A)/1000;
    elseif A(1)>maxLim
        options.session.align.curPos = maxLim;
    else
        options.session.align.curPos = 0;
    end
    set(userOpt,'userData',options);
    plotFcn(pHandle,pSig,userOpt);
end
set(scr,'String',num2str(options.session.align.curPos));
end

function shiftCallback(scr,~,pSig,userOpt,teCurPos,pHandle)
% move a full window to the left or right

options = get(userOpt,'userData');
if ~isempty(options.session.align.sigLen)
    if strcmp(get(scr,'tag'),'left')
        if options.session.align.curPos-options.session.align.windowLen>=0
            options.session.align.curPos = options.session.align.curPos-...
                options.session.align.windowLen;
        else
            options.session.align.curPos = 0;
        end
    else
        if options.session.align.curPos + ...
                2*options.session.align.windowLen <= ...
                options.session.align.sigLen
            options.session.align.curPos = options.session.align.curPos+...
                options.session.align.windowLen;
        else
            options.session.align.curPos = options.session.align.sigLen-...
                options.session.align.windowLen;
        end
    end
    
    set(userOpt,'userData',options);
    
    plotFcn(pHandle,pSig,userOpt);
    set(teCurPos,'String',num2str(options.session.align.curPos));
end
end

function windowLenCallback(scr,~,pSig,userOpt,teCurPos,pHandle)
% modify window length (in seconds)

options = get(userOpt,'userData');
A = str2double(get(scr,'String'));
if  ~isnan(A)
    if ~isempty(options.session.align.sigLen)
        hiLim = options.session.align.sigLen;
    else
        hiLim = inf;
    end
    
    if A >= 1 && A <= hiLim
        options.session.align.windowLen = round(1000*A)/1000;
        %adapts values for last window
        if A+options.session.align.curPos >= hiLim
            options.session.align.curPos = hiLim -...
                options.session.align.windowLen;
            set(teCurPos,'String',...
                num2str(options.session.align.curPos));
        end
    elseif A < 1
        options.session.align.windowLen = 1;
    else
        options.session.align.windowLen = options.session.align.sigLen;
        options.session.align.curPos = 0;
        set(teCurPos,'String',num2str(0));
    end
    
    set(userOpt,'userData',options);
    plotFcn(pHandle,pSig,userOpt);
    set(userOpt,'userData',options);
end
set(scr,'string',num2str(options.session.align.windowLen));
end

function rbCallback(scr,~,userOpt,rb1,rb2,rb3,pSig,pHandle,pFile,...
    teEndSamp,txEndSamp)
% adjust options from radiobuttons: resampling method, ectopic-beat related
% variables handling, border handling, border start and end points and RRI
% output

options = get(userOpt,'userData');
if ~options.session.align.resampled
    options.session.align.(get(scr,'tag')) = get(scr,'userData');
    if ismember(get(scr,'tag'),{'rbMethod','rbEctopic','rbStart','rbEnd'})
        set(rb2,'value',0);
        if strcmp(get(scr,'tag'),'rbEnd')
            set(rb3,'value',0);
        end
    end
    set(userOpt,'userData',options);
    
    set(scr,'value',1);
    set(rb1,'value',0);
    
    if ismember(get(scr,'tag'),{'rbEctopic','rbStart','rbEnd','rbBorder'})
        if strcmp(get(scr,'tag'),'rbEctopic')
            ectopic(userOpt,pSig,pFile);
        elseif strcmp(get(scr,'tag'),'rbStart')
            startPoint(userOpt,pSig,teEndSamp,txEndSamp);
        elseif strcmp(get(scr,'tag'),'rbEnd')
            endPoint(userOpt,pSig);
        end
        plotFcn(pHandle,pSig,userOpt);
    end
else
    set(scr,'value',0);
    uiwait(errordlg(['View only! These controls are unavailable ',...
        'while viewing resampled data.'],'View only','modal'));
end
end

function ectopic(userOpt,pSig,pFile)
% handle ectopic related variables on ECG and BP variables

options = get(userOpt,'userData');

if ~isempty(options.session.align.sigLen) && ...
        ~options.session.align.resampled
    id = {'ecg','bp'};
    type = options.session.align.sigSpec;
    for i = 1:2
        if ~isempty(type{i})
            signals = get(pSig,'userData');
            patient = get(pFile,'userData');
            
            % apply selected solution
            signals.(id{i}).(type{i}) = dataPkg.varUnit;
            auxSig = patient.sig.(id{i}).(type{i});
            auxSig.time = auxSig.time - options.session.align.offset;
            if options.session.align.rbEctopic == 0
                normalIndex = setdiff(1:length(auxSig.data),...
                    auxSig.ectopic);
                signals.(id{i}).(type{i}).data = auxSig.data(normalIndex);
                signals.(id{i}).(type{i}).time = auxSig.time(normalIndex);
                signals.(id{i}).(type{i}).index = ...
                    auxSig.index(normalIndex);
                signals.(id{i}).(type{i}).fs = auxSig.fs;
                signals.(id{i}).(type{i}).specs = auxSig.specs;
            elseif options.session.align.rbEctopic == 1
                normalIndex = setdiff(1:length(auxSig.data),...
                    auxSig.ectopic);
                % interpolate time stamps
                signals.(id{i}).(type{i}).time = spline(normalIndex,...
                    auxSig.time(normalIndex),1:length(auxSig.time));
                % interpolate variables
                signals.(id{i}).(type{i}).data = spline(normalIndex,...
                    auxSig.data(normalIndex),1:length(auxSig.data));
                signals.(id{i}).(type{i}).index = auxSig.index;
                signals.(id{i}).(type{i}).ectopic = auxSig.ectopic;
                signals.(id{i}).(type{i}).fs = auxSig.fs;
                signals.(id{i}).(type{i}).specs = auxSig.specs;
            else
                signals.(id{i}).(type{i}) = auxSig;
            end
            set(pSig,'userData',signals);
        end
    end
end
end

function startPoint(userOpt,pSig,teEndSamp,txEndSamp)
% indicate start point for new aligned data

options = get(userOpt,'userData');
signals = get(pSig,'userData');
type = options.session.align.sigSpec;

if options.session.align.rbStart == 0 && ~isempty(type{1})
    options.session.align.startPoint = signals.ecg.(type{1}).time(1);
elseif options.session.align.rbStart == 1 && ~isempty(type{2})
    options.session.align.startPoint = signals.bp.(type{2}).time(1);
elseif options.session.align.rbStart == 2 && ~isempty(type{3})
    options.session.align.startPoint = signals.rsp.(type{3}).time(1);
end

sigLen = options.session.align.sigLen;
fs = options.session.align.resampFs;
%calculates maximum number of points from chosen start point
pointsMax = floor((sigLen-options.session.align.startPoint)*fs)+1;
set(txEndSamp,'String',sprintf('(Max: %g)',pointsMax));
A = str2double(get(teEndSamp,'String'));
if A > pointsMax
    options.session.align.points = pointsMax;
    set(teEndSamp,'String',num2str(options.session.align.points));
end
set(userOpt,'userData',options);
end

function endPoint(userOpt,pSig)
% indicate end point for new aligned data

options = get(userOpt,'userData');
signals = get(pSig,'userData');
type = options.session.align.sigSpec;

if options.session.align.rbEnd == 0
    options.session.align.endPoint = signals.ecg.(type{1}).time(end);
elseif options.session.align.rbEnd == 1
    options.session.align.endPoint = signals.bp.(type{2}).time(end);
elseif options.session.align.rbEnd == 2
    options.session.align.endPoint = signals.rsp.(type{3}).time(end);
elseif options.session.align.rbEnd == 3
    options.session.align.endPoint = ...
        options.session.align.startPoint + ...
        (options.session.align.points-1)/options.session.align.resampFs;
end
set(userOpt,'userData',options);
end

function teEndCallback(scr,~,userOpt,txEndSamp,pSig,pHandle)
% set end point for new aligned data from user input (no. of samples)

errStat = 0;
options = get(userOpt,'userData');

if options.session.align.resampled
    set(scr,'string',num2str(options.session.align.points));
    uiwait(errordlg(['View only! These controls are unavailable ',...
        'while viewing resampled data.'],'View only','modal'));
    errStat = 1;
end

A = round(str2double(get(scr,'string')));
if ~isnan(A) && ~errStat
    if ~isempty(options.session.align.sigLen)
        fs = options.session.align.resampFs;
        pointsMax = floor((options.session.align.sigLen - ...
            options.session.align.startPoint)*fs) + 1;
        set(txEndSamp,'String',sprintf('(Max: %g)',pointsMax));
    else
        pointsMax = inf;
    end
    
    if A >=2 && A <= pointsMax
        options.session.align.points = A;
    elseif A > pointsMax
        options.session.align.points = pointsMax;
    else
        options.session.align.points = 2;
    end
    
    if ~isempty(options.session.align.sigLen)
        options.session.align.endPoint = ...
            options.session.align.startPoint + ...
            (options.session.align.points-1)/fs;
    end
    
    set(userOpt,'userData',options);
    if options.session.align.rbEnd == 3
        plotFcn(pHandle,pSig,userOpt);
    end
end
set(scr,'string',num2str(options.session.align.points));
end

function teFsCallback(scr,~,userOpt,teEndSamp,txEndSamp,pSig,pHandle)
% set resampling frequency

errStat = 0;
options = get(userOpt,'userData');

if options.session.align.resampled
    set(scr,'string',num2str(options.session.align.resampFs));
    uiwait(errordlg(['View only! These controls are unavailable ',...
        'while viewing resampled data.'],'View only','modal'));
    errStat = 1;
end

if ~errStat
    A=str2double(get(scr,'String'));
    if ~isnan(A)
        if A >= 1 && A <= 10 %resample between 1 and 10 Hz
            options.session.align.resampFs = A;
        elseif A < 1
            options.session.align.resampFs = 1;
        else
            options.session.align.resampFs = 10;
        end
    end
    if ~isempty(options.session.align.sigLen)
        %calculates maximum number of points from sampling frequency
        fs = options.session.align.resampFs;
        pointsMax = floor((options.session.align.sigLen - ...
            options.session.align.startPoint)*fs) + 1;
        set(txEndSamp,'String',sprintf('(Max: %g)',pointsMax));
        A = str2double(get(teEndSamp,'String'));
        if A > pointsMax
            options.session.align.points = pointsMax;
            set(teEndSamp,'String',num2str(options.session.align.points));
        end
        if options.session.align.rbEnd == 3
            options.session.align.endPoint = ...
                options.session.align.startPoint + ...
                (options.session.align.points-1)/...
                options.session.align.resampFs;
        end
    end
    set(userOpt,'userData',options);
    if options.session.align.rbEnd == 3, plotFcn(pHandle,pSig,userOpt); end
end
set(scr,'string',num2str(options.session.align.resampFs));
end

function resample(~,~,userOpt,pSig,pHandle,teCurPos,teShift)
% resample signals

errStat = 0;
options = get(userOpt,'userData');
type = options.session.align.sigSpec;

if isempty(options.session.align.sigLen)
    errStat = 1;
elseif options.session.align.resampled
    uiwait(errordlg(['Data already resampled! To resample the data ',...
        'using different parameters, restore it first.'],...
        'Data already resampled','modal'));
    errStat = 1;
elseif (isempty(type{1}) && options.session.align.rbStart == 0) || ...
        (isempty(type{2}) && options.session.align.rbStart == 1) || ...
        (isempty(type{3}) && options.session.align.rbStart == 2)
    uiwait(errordlg(['Invalid start point! Please indicate a start ',...
        'point referring one of the opened data.'],...
        'Invalid start point','modal'));
    errStat = 1;
elseif (isempty(type{1}) && options.session.align.rbEnd == 0) || ...
        (isempty(type{2}) && options.session.align.rbEnd == 1) || ...
        (isempty(type{3}) && options.session.align.rbEnd == 2)
    uiwait(errordlg(['Invalid end point! Please indicate an end point ',...
        'referring one of the opened data.'],'Invalid end point','modal'));
    errStat = 1;
elseif ~isempty(type{3}) && options.session.align.rbMethod == 2
    [selButton, dlgShow] = uigetpref('CRSIDLabPref','resampleILV',...
        'Resampling variables',sprintf(['Warning!','\nWhen the Berger ',...
        'algorithm is indicated as resampling method, it is only ',...
        'applied to the unevenly sampled data,\nsuch as RRI, SBP or ',...
        'DBP. To the ILV, cubic interpolation will be applied.\n',...
        'Are you sure you wish to proceed?']),{'Yes','No'},...
        'DefaultButton','No');
    if strcmp(selButton,'no') && dlgShow
        errStat = 1;
    end
end

if ~errStat
    options.session.align.resampled = 1;
    signals = get(pSig,'userData');
    id = {'ecg','bp','rsp'};
    
    % data specifications
    auxSpec = struct;
    switch options.session.align.rbStart
        case 0,
            if options.session.align.rbRRIOut
                auxSpec.border.start.ref = 'RRI';
            else
                auxSpec.border.start.ref = 'HR';
            end
        case 1, auxSpec.border.start.ref = upper(type{2});
        case 2, auxSpec.border.start.ref = 'ILV';
    end
    auxSpec.border.start.value = options.session.align.startPoint;
    switch options.session.align.rbEnd
        case 0,
            if options.session.align.rbRRIOut
                auxSpec.border.end.ref = 'RRI';
            else
                auxSpec.border.end.ref = 'HR';
            end
        case 1, auxSpec.border.end.ref = upper(type{2});
        case 2, auxSpec.border.end.ref = 'ILV';
        case 3, auxSpec.border.end.ref = 'Samples';
    end
    auxSpec.border.end.value = options.session.align.endPoint;
    switch options.session.align.rbBorder
        case 0, auxSpec.border.method = ...
                'Constant padding (border values)';
        case 1, auxSpec.border.method = 'Symmetric extension';
    end
    
    auxSigLen = zeros(3,1);
    for i = 1:3
        if ~isempty(type{i})
            spec = struct;
            switch options.session.align.rbMethod
                case 0, spec.method = 'Linear interpolation';
                case 1, spec.method = 'Cubic interpolation';
                case 2
                    if i ~= 3
                        spec.method = 'Berger algorithm';
                    else
                        spec.method = 'Cubic interpolation';
                    end
            end
            if i ~= 3
                switch options.session.align.rbEctopic
                    case 0, spec.ectopic = 'Remove';
                    case 1, spec.ectopic = 'Interpolate';
                    case 2, spec.ectopic = 'Don''t Remove';
                end
            end
            if i == 1
                if options.session.align.rbRRIOut
                    spec.type = 'hr';
                else
                    spec.type = 'rri';
                end
            end
            spec.border.start.ref = auxSpec.border.start.ref;
            spec.border.start.value = auxSpec.border.start.value;
            spec.border.end.ref = auxSpec.border.end.ref;
            spec.border.end.value = auxSpec.border.end.value;
            spec.border.method = auxSpec.border.method;
            
            % resample data
            signals.(id{i}).(type{i}).aligned = dataPkg.alignedUnit;
            [signals.(id{i}).(type{i}).aligned.data,...
                signals.(id{i}).(type{i}).aligned.time] = resampData(...
                signals.(id{i}).(type{i}).data,...
                signals.(id{i}).(type{i}).time,userOpt,id{i});
            signals.(id{i}).(type{i}).aligned.fs = ...
                options.session.align.resampFs;
            
            % add tag
            fs = signals.(id{i}).(type{i}).aligned.fs;
            samp = length(signals.(id{i}).(type{i}).aligned.data);
            curVar = options.session.align.varString.(id{i}){...
                options.session.align.varValue.(id{i})};
            spec.tag = ['A&R ',curVar,' (',...
                num2str(fs),' Hz - ',num2str(samp),' samples)'];
            
            signals.(id{i}).(type{i}).aligned.specs = spec;
            auxSigLen(i) = signals.(id{i}).(type{i}).aligned.time(end);
        end
    end
    options.session.align.proc = 1;
    options.session.align.sigLen = max(auxSigLen);
    
    if (options.session.align.curPos + options.session.align.windowLen) ...
            > options.session.align.sigLen
        if options.session.align.windowLen > options.session.align.sigLen
            options.session.align.curPos = 0;
            options.session.align.windowLen = options.session.align.sigLen;
        else
            options.session.align.curPos = options.session.align.sigLen ... 
                - options.session.align.windowLen;
        end
        set(teShift,'string',num2str(options.session.align.windowLen));
        set(teCurPos,'string',num2str(options.session.align.curPos));
    end
    
    set(userOpt,'userData',options);
    set(pSig,'userData',signals);
    saveConfig(userOpt);
    plotFcn(pHandle,pSig,userOpt);
end
end

function [signal,time] = resampData(signal,time,userOpt,id)
% resample signal
% original Matlab code: Luisa Santiago C. B. da Silva, Jul. 2015

options = get(userOpt,'userData');

startPoint = options.session.align.startPoint;
endPoint = options.session.align.endPoint;
method = options.session.align.rbMethod;
border = options.session.align.rbBorder;
fs = options.session.align.resampFs;

if ~strcmp(id,'rsp') || method == 0
    % left border
    if time(1) >= startPoint - 1/fs
        if border == 0 % constant padding (border values)
            if strcmp(id,'ecg') %sample distance
                p1 = signal(1)/1000;
            else
                p1 = time(2)-time(1);
            end
            %a number of extra samples may need to be added to ensure the
            %desired start point for the resampled data
            for i=1:ceil((time(1)-startPoint-(1/fs))/p1)
                time = [time(1)-p1;time]; %#ok<AGROW>
                signal = [signal(1);signal]; %#ok<AGROW>
            end
        else           % symmetric extension of borders
            delay = time(1) - (startPoint - 1/fs);
            lastSamp = find((time-time(1))>= delay,1);
            signal = [flipud(signal(2:lastSamp));signal];
            timeDiff = time(2:lastSamp)-time(1);
            time = [flipud(time(1)-timeDiff);time];
        end
    end
    % right border
    if time(end) < endPoint + 1/fs
        if border == 0 % constant padding (border values)
            p2 = time(end)-time(end-1);
            for i=1:ceil((endPoint+(1/fs)-time(end))/p2)
                time = [time;time(end)+p2]; %#ok<AGROW>
                signal = [signal;signal(end)]; %#ok<AGROW>
            end
        else           % symmetric extension of borders
            delay = (endPoint + 1/fs) - time(end);
            firstSamp = find((time(end)-time)>= delay,1,'last');
            signal = [signal;flipud(signal(firstSamp:end-1))];
            timeDiff = time(end)-time(firstSamp:end-1);
            time = [time;flipud(time(end)+timeDiff)];
        end
    end
end

%adjusts time to remain always positive and saves offset
if time(1)<0
    off = time(1);
    time = time-off;
else
    off = 0;
end

%desired time axis from given start and end points and frequency
newTime = (startPoint-off:1/fs:endPoint-off)';

%resampling
if method == 0  %linear
    signal = interp1(time,signal,newTime);
elseif method == 1 || (method == 2 && strcmp(id,'rsp')) %spline (cubic)
    signal = spline(time,signal,newTime);
else            %berger algorithm
    signal = bergerAlg(signal,time,newTime);
end

if strcmp(id,'ecg')
    if options.session.align.rbRRIOut == 1
        signal = 60000./signal;
    end
end

%readjusts time from offset and reset the zero point
time = newTime+off;
time = time - time(1);
end

function bergSig = bergerAlg(signal,time,newTime)
% Resamples signal with algorithm presented by Berger et al*
%
%*R. D. Berger, S. Askelrod, D. Gordon and R. J. Cohen, "An Efficient
% Algorithm for Spectral Analysis of Heart Rate Variability", IEEE
% Transactions on Biomedical Engineering, Vols. BME-33, no. 9, pp. 900-904,
% September 1986.
%
% Original Matlab code: Luisa Santiago C. B. da Silva, Jul. 2015

%calculates frequency from desired time samples
fs = 1/(newTime(2)-newTime(1));

%adds samples to borders to include values at desired limits
bergTime = [(newTime(1)-1/fs);newTime;(newTime(end)+1/fs)];
bergSig = zeros(length(bergTime));

%window size (in seconds)
windowTime = 2*(1/fs);

%calculates signal
for i = 2:length(bergTime)-1
    %indexes of RRI in which or the SBP/DBP corresponding to the points
    %where the left (jan_i) and right (jan_f) edges of the window are
    %located
    leftEdge = find(time>=bergTime(i-1),1);
    rightEdge = find(time>=bergTime(i+1),1);
    %if the window is interly in a single RRI or has only one corresponding
    %SBP/DBP (simplest case)
    if leftEdge == rightEdge
        bergSig(i) = windowTime.*signal(leftEdge);
    else
        %calculates the portion of the window that is in the first of the
        %RRI or that corresponds to the first SBP/DBP within the window
        a = time(leftEdge)-bergTime(i-1);
        bergSig(i) = (a.*signal(leftEdge));
        %if there's more than two RRIs or SBP/DBP values within the window
        %(most complex case)
        if (rightEdge-leftEdge)>1
            %stores index of the last scanned RRI/SBP/DBP in 'anterior'
            prev = leftEdge;
            for j=1:((rightEdge-leftEdge)-1)
                %stores index of current RRI/SBP/DBP being scanned in 'atual'
                current = leftEdge+j;
                %calculates the portion of the window that is in the
                %(j+1)-th RRI or corresponds to the (j+1)-th SBP/DBP within
                %the window
                a = time(current)-time(prev);
                bergSig(i) = bergSig(i)+a.*signal(current);
                %updated index of last scanned RRI/SBP/DBP
                prev = current;
            end
        else
            %if there are only two RRIs/SBPs/DBPs within the window, the
            %index j is made equal to zero, as it will be used to indicate
            %the number of RRIs/SBPs/DBPs in between the first and last
            %when it applies
            j=0;
        end
        %calculates the portion of the window that is in the last of the
        %RRI or that correspond to the last SBP/DBP within the window
        a = bergTime(i+1)-time(leftEdge+j);
        bergSig(i) = bergSig(i)+(a.*signal(rightEdge));
    end
end
%removes the samples that were added
bergSig = (bergSig(2:length(bergSig)-1)./windowTime)';
end

function saveConfig(userOpt)
% save session configurations for next session

options = get(userOpt,'userData');
options.align.windowLen = options.session.align.windowLen;
options.align.rbMethod = options.session.align.rbMethod;
options.align.rbEctopic = options.session.align.rbEctopic;
options.align.rbBorder = options.session.align.rbBorder;
options.align.rbRRIOut = options.session.align.rbRRIOut;
options.align.rbStart = options.session.align.rbStart;
options.align.rbEnd = options.session.align.rbEnd;
options.align.resampFs = options.session.align.resampFs;
options.align.points = options.session.align.points;
set(userOpt,'userData',options);
end