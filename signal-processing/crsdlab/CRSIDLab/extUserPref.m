function extUserPref(~,~,userOpt,pSig,pHandle)
% extUserPref Sets up user preferences in extractMenu
%   extUserPref(~,~,userOpt,pHandle,pSig) opens a window allowing the user 
%   select the variables all actions will affect, indicate whether to show
%   a grid on one of the plots inicating the variables from another and
%   indicate when to show variables' index and value.
%   pSig's userData property with highlighted extracted and ectopic-related 
%   variables, when available, as indicated by options in userOpt's 
%   userData property to handle pHandle.
%
% Original Matlab code: Luisa Santiago C. B. da Silva, April 2017.

prefWindow = figure(2); clf(2);
set(prefWindow, 'MenuBar','none','NumberTitle','off','Units','Pixels',...
    'Position',[750 300 330 250],'Name',['(ENE/UnB) CRSIDLab - ',...
    'Preferences'],'color',[.94 .94 .94]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Select variables
%

pnSelect=uipanel('parent',prefWindow,'title','Select variables',...
    'Units','Normalized','Position',[.05 .55 .425 .35]); 

%check box to select ECG
cbRR=uicontrol('parent',pnSelect,'Style','checkbox','String','R waves',...
    'userData',1,'Units','Normalized','Position',[.05 .7 .9 .2]);

%check box to select SBP
cbSBP=uicontrol('parent',pnSelect,'Style','checkbox','String','SBP',...
    'userData',2,'Units','Normalized','Position',[.05 .4 .9 .2]);

%check box to select DBP
cbDBP=uicontrol('parent',pnSelect,'Style','checkbox','String', 'DBP',...
    'userData',3,'CallBack',{@cbCallback,userOpt,cbRR,cbSBP,3},'Units',...
    'Normalized','Position',[.05 .1 .9 .2]);

options = get(userOpt,'userData');
set(cbRR,'Callback',{@cbCallback,userOpt,cbSBP,cbDBP,1},'value',...
    options.session.ext.cbSelection(1));
set(cbSBP,'CallBack',{@cbCallback,userOpt,cbRR,cbDBP,2},'value',...
    options.session.ext.cbSelection(2));
set(cbDBP,'value',options.session.ext.cbSelection(3));

type = options.session.ext.sigSpec;
if isempty(type{1})
    set(cbRR,'enable','off');
end
if isempty(type{2})
    set(cbSBP,'enable','off');
    set(cbDBP,'enable','off');
end
if strcmp(type{2},'sbp')
    set(cbDBP,'enable','off');
    gridOptions = {'No grid','From SBP'};
elseif strcmp(type{2},'dbp')
    set(cbSBP,'enable','off');
    gridOptions = {'No grid','From DBP'};
else
    gridOptions = {'No grid','From SBP','From DBP'};
end

cbCallback(cbRR,[],userOpt,cbSBP,cbDBP,1);
cbCallback(cbSBP,[],userOpt,cbRR,cbDBP,2);
cbCallback(cbDBP,[],userOpt,cbRR,cbSBP,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot grid from variables
%

pnGrid=uipanel('parent',prefWindow,'title','Plot grid','Units',...
    'Normalized','Position',[.525 .55 .425 .35]);

uicontrol('parent',pnGrid,'Style','text','String','ECG:','hor','left',...
    'Units','Normalized','Position',[.05 .55 .2 .2]);
puECG = uicontrol('parent',pnGrid,'Style','popupmenu','tag','ecg',...
    'String',gridOptions,'value',options.session.ext.grid.ecg,...
    'userData',options.session.ext.grid.ecg,'callback',{@puCallback,...
    userOpt,pSig,pHandle},'Units','Normalized','Position',[.3 .6 .6 .2],...
    'backgroundColor',[1 1 1]);

uicontrol('parent',pnGrid,'Style','text','String','BP:','hor','left',...
    'Units','Normalized','Position',[.05 .15 .2 .2]);
puBP = uicontrol('parent',pnGrid,'Style','popupmenu','tag','bp',...
    'String',{'No grid','From RRI'},'value',options.session.ext.grid.bp,...
    'userData',options.session.ext.grid.bp,'callback',{@puCallback,...
    userOpt,pSig,pHandle},'Units','Normalized','Position',[.3 .2 .6 .2],...
    'backgroundColor',[1 1 1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Show labels on plot
%

pnLabel=uipanel('parent',prefWindow,'title',['Display variable labels ',...
    'on plot'],'Units','Normalized','Position',[.05 .1 .9 .35]);

rbAlways=uicontrol('parent',pnLabel,'style','radio','String','Always',...
    'value',0,'userData',1,'Units','Normalized','Position',...
    [.05 .7 .5 .2]);

rbNever=uicontrol('parent',pnLabel,'style','radio','String','Never',...
    'value',0,'userData',2,'Units','Normalized','Position',...
    [.05 .4 .5 .2]);

rbWindow=uicontrol('parent',pnLabel,'style','radio','String',['Only ',...
    ' when window length is less than:'],'value',0,'userData',3,'Units',...
    'Normalized','Position',[.05 .1 .8 .2]);

teWindow=uicontrol('parent',pnLabel,'style','edit','callback',...
    {@teCallback,userOpt,pSig,pHandle,rbWindow},'Units','Normalized',...
    'Position',[.8 .1 .15 .3],'backgroundColor',[1 1 1]);

set(rbAlways,'callback',{@rbCallback,userOpt,pSig,pHandle,rbWindow,...
    rbNever,[]});
set(rbNever,'callback',{@rbCallback,userOpt,pSig,pHandle,rbAlways,...
    rbWindow,[]});
set(rbWindow,'callback',{@rbCallback,userOpt,pSig,pHandle,rbAlways,...
    rbNever,teWindow});

if options.session.ext.label == inf
    set(rbAlways,'value',1);
elseif options.session.ext.label == 0
    set(rbNever,'value',1);
else
    set(rbWindow,'value',1);
    set(teWindow,'string',num2str(options.session.ext.label));
end

type = options.session.ext.sigSpec;
if ~isempty(type{1}) && ~isempty(type{2})
    set(puECG,'enable','on');
    set(puBP,'enable','on');
else
    set(puECG,'enable','off');
    set(puBP,'enable','off');
end
end

function cbCallback(scr,~,userOpt,cb1,cb2,id)
% select signals actions will affect

options = get(userOpt,'userData');
options.session.ext.cbSelection(get(scr,'userData')) = get(scr,'value');
set(userOpt,'userData',options);
        
if get(scr,'value')==0
    if get(cb1,'value')==0
        set(cb2,'enable','off');
    elseif get(cb2,'value')==0
        set(cb1,'enable','off');
    end
else
    if ~isempty(options.session.ext.sigSpec{2})
        if (~strcmp(options.session.ext.sigSpec{2},'dbp') && id == 3) ...
                || (~strcmp(options.session.ext.sigSpec{2},'sbp') && id ~= 3)
            set(cb2,'enable','on');
        end
        if ~isempty(options.session.ext.sigSpec{1}) && ...
                (~strcmp(options.session.ext.sigSpec{2},'dbp') || id ~= 1)
            set(cb1,'enable','on');
        end
    end
end
end

function puCallback(scr,~,userOpt,pSig,pHandle)
% indicate grid to be shown on plot from a variable from another plot

options = get(userOpt,'userData');
if get(scr,'value') ~= get(scr,'userData')
    options.session.ext.grid.(get(scr,'tag')) = get(scr,'value');
    set(scr,'userData',get(scr,'value'));
    set(userOpt,'userData',options);

    plotFcn(pHandle,pSig,userOpt)
end
end

function rbCallback(scr,~,userOpt,pSig,pHandle,rb1,rb2,teWindow)
% indicate maximum window length to display variable labels on plot

options = get(userOpt,'userData');

prevLabel = options.session.ext.label;
if get(scr,'userData') == 1
    options.session.ext.label = inf;
elseif get(scr,'userData') == 2
    options.session.ext.label = 0;
else
    options.session.ext.label = str2double(get(teWindow,'string'));
end
set(userOpt,'userData',options);

set(scr,'value',1);
set(rb1,'value',0);
set(rb2,'value',0);

if prevLabel ~= options.session.ext.label
    plotFcn(pHandle,pSig,userOpt)
end
end

function teCallback(scr,~,userOpt,pSig,pHandle,rbWindow)
% indicate maximum window length to display variable labels on plot

options = get(userOpt,'userData');
if ~isempty(options.session.ext.sigLen)
    A = round(str2double(get(scr,'string')));

    if ~isnan(A)
        if A >= 1 && A <= options.session.ext.sigLen
            value = A;
        elseif A < 1
            value = 1;
        else
            value = options.session.ext.sigLen;
        end
    end
    set(scr,'string',num2str(value));
end

options.session.ext.label = value;
set(userOpt,'userData',options);
if get(rbWindow,'value')
    plotFcn(pHandle,pSig,userOpt)
end
end

function plotFcn(pHandle,pSig,userOpt)
% adjust handles visibility and plot all selected signals

options = get(userOpt,'userData');
if ~isempty(options.session.ext.sigSpec{1}) && ...
        ~isempty(options.session.ext.sigSpec{2})
    set(pHandle.full,'visible','off');
    set(get(pHandle.full,'children'),'visible','off');
    set(pHandle.ecg,'visible','on');
    set(get(pHandle.ecg,'children'),'visible','on');
    set(pHandle.bp,'visible','on');
    set(get(pHandle.bp,'children'),'visible','on');
    extractPlot(pHandle.ecg,pSig,userOpt);
    extractPlot(pHandle.bp,pSig,userOpt);
    set(get(pHandle.ecg,'Children'),'hitTest','off');
    set(get(pHandle.bp,'Children'),'hitTest','off');
else
    set(pHandle.ecg,'visible','off');
    set(get(pHandle.ecg,'children'),'visible','off');
    set(pHandle.bp,'visible','off');
    set(get(pHandle.bp,'children'),'visible','off');
    set(pHandle.full,'visible','on');
    set(get(pHandle.full,'children'),'visible','on');
    if ~isempty(options.session.ext.sigSpec{1})
        set(pHandle.full,'tag','ecg');
        extractPlot(pHandle.full,pSig,userOpt);
    elseif ~isempty(options.session.ext.sigSpec{2})
        set(pHandle.full,'tag','bp');
        extractPlot(pHandle.full,pSig,userOpt);
    else
        set(get(pHandle.full,'children'),'visible','off');
    end
    set(get(pHandle.full,'Children'),'hitTest','off');
end
end