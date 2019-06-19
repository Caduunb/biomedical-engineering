function preTab(pnPre,pFile,pSig,userOpt,tbAn)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Preprocessing tab
%

tbFilt = uicontrol('parent',pnPre,'style','toggle','tag','filt',...
    'string','Filter ECG/BP data','units','normalized','Position',...
    [0 .9565 .1 .042]);
pnFilt = uipanel('parent',pnPre,'units','normalized','position',...
    [0 0 1 .958],'visible','off');

tbExt = uicontrol('parent',pnPre,'style','toggle','tag','ext','string',...
    'Extract variables from ECG/BP','units','normalized','Position',...
    [.099 .9565 .155 .042]);
pnExt = uipanel('parent',pnPre,'units','normalized','position',...
    [0 0 1 .958],'visible','off');

tbResp = uicontrol('parent',pnPre,'style','toggle','tag','resp',...
    'string','Pre-process respiration data','units','normalized',...
    'Position',[.253 .9565 .145 .042]);
pnResp = uipanel('parent',pnPre,'units','normalized','position',...
    [0 0 1 .958],'visible','off');

tbAlign = uicontrol('parent',pnPre,'style','toggle','tag','align',...
    'string','Align and resample data set','units','normalized',...
    'Position',[.397 .9565 .145 .042]);
pnAlign = uipanel('parent',pnPre,'units','normalized','position',...
    [0 0 1 .958],'visible','off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Set callback functions
%

set(tbFilt,'callback',{@tabChange,tbFilt,pnFilt,tbExt,pnExt,tbResp,...
    pnResp,tbAlign,pnAlign,pFile,pSig,userOpt});
set(tbExt,'callback',{@tabChange,tbFilt,pnFilt,tbExt,pnExt,tbResp,...
    pnResp,tbAlign,pnAlign,pFile,pSig,userOpt});
set(tbResp,'callback',{@tabChange,tbFilt,pnFilt,tbExt,pnExt,tbResp,...
    pnResp,tbAlign,pnAlign,pFile,pSig,userOpt});
set(tbAlign,'callback',{@tabChange,tbFilt,pnFilt,tbExt,pnExt,tbResp,...
    pnResp,tbAlign,pnAlign,pFile,pSig,userOpt,tbAn});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Set current selected tab
%

options = get(userOpt,'userData');
switch options.session.nav.pre
    case 0
        set(tbFilt,'value',1);
        tabChange(tbFilt,[],tbFilt,pnFilt,tbExt,pnExt,tbResp,pnResp,...
            tbAlign,pnAlign,pFile,pSig,userOpt);
    case 1
        set(tbExt,'value',1);
        tabChange(tbExt,[],tbFilt,pnFilt,tbExt,pnExt,tbResp,pnResp,...
            tbAlign,pnAlign,pFile,pSig,userOpt);
    case 2
        set(tbResp,'value',1);
        tabChange(tbResp,[],tbFilt,pnFilt,tbExt,pnExt,tbResp,pnResp,...
            tbAlign,pnAlign,pFile,pSig,userOpt);
    case 3
        set(tbAlign,'value',1);
        tabChange(tbAlign,[],tbFilt,pnFilt,tbExt,pnExt,tbResp,pnResp,...
            tbAlign,pnAlign,pFile,pSig,userOpt,tbAn);
end
end

function tabChange(scr,~,tbFilt,pnFilt,tbExt,pnExt,tbResp,pnResp,...
    tbAlign,pnAlign,pFile,pSig,userOpt,tbAn)
% changes between tabs: PSD tab & system identification tab

% verifiy if there is unsaved data in the previous tab before changing
errStat = 0; dispDialog = 0;
options = get(userOpt,'userData');
switch options.session.nav.pre
    case 0                                  % filter ECG/BP tab
        if ~strcmp(get(scr,'tag'),'filt') && ~options.session.filt.saved...
                && (options.session.filt.flags.notch ||... 
                options.session.filt.flags.lowPass || ...
                (options.session.filt.flags.highPass && ...
                strcmp(options.session.filt.sigSpec{1},'ecg')))
            dispDialog = 1;
        end
    case 1                                  % extract variables tab
        if ~strcmp(get(scr,'tag'),'ext') && ~options.session.ext.saved ...
                && ((options.session.ext.proc.ecg && ...
                options.session.ext.cbSelection(1)) || ...
                (options.session.ext.proc.bp && ...
                (options.session.ext.cbSelection(2) || ...
                options.session.ext.cbSelection(3))))
            dispDialog = 1;
        end
    case 2                                  % preprocess respiration tab
        if ~strcmp(get(scr,'tag'),'resp') && ~options.session.resp.saved...
                && (options.session.resp.flags.int ||... 
                options.session.resp.flags.det || ...
                options.session.resp.flags.filt)
            dispDialog = 1;
        end
    case 3                                  % align & resample tab
        if ~strcmp(get(scr,'tag'),'align') && ...
                ~options.session.align.saved && options.session.align.proc
            dispDialog = 1;
        end
end
if get(scr,'value') == 1 && dispDialog
    [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
        'changeTabPrePref','Change tabs',sprintf(['Warning!\nThe ',... 
        'current data has not been saved. Any modifications will ',...
        'be lost if the tabs are switched at this point.\nAre you ',...
        'sure you wish to proceed?']),{'Yes','No'},'DefaultButton',...
        'No');
    if strcmp(selButton,'no') && dlgShow
        errStat = 1;
    end  
end
 
% switch tabs (adjust toggle buttons and call tab script)
if get(scr,'value') == 1 && ~errStat
    set(scr,'backgroundcolor',[1 1 1]);
    switch get(scr,'tag')   
        case 'filt'                         % filter ECG/BP tab
            options.session.nav.pre = 0;
            set(userOpt,'userData',options);
            set(tbExt,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnExt,'visible','off'); delete(get(pnExt,'children'));
            set(tbResp,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnResp,'visible','off'); delete(get(pnResp,'children'));
            set(tbAlign,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnAlign,'visible','off'); delete(get(pnAlign,'children'));
            filtMenu(pnFilt,pFile,pSig,userOpt);
            set(pnFilt,'visible','on');
        case 'ext'                          % extract variables tab
            options.session.nav.pre = 1;
            set(userOpt,'userData',options);
            set(tbFilt,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnFilt,'visible','off'); delete(get(pnFilt,'children'));
            set(tbResp,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnResp,'visible','off'); delete(get(pnResp,'children'));
            set(tbAlign,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnAlign,'visible','off'); delete(get(pnAlign,'children'));
            extractMenu(pnExt,pFile,pSig,userOpt);
            set(pnExt,'visible','on');
        case 'resp'                         % preprocess respiration tab
            options.session.nav.pre = 2;
            set(userOpt,'userData',options);
            set(tbFilt,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnFilt,'visible','off'); delete(get(pnFilt,'children'));
            set(tbExt,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnExt,'visible','off'); delete(get(pnExt,'children'));
            set(tbAlign,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnAlign,'visible','off'); delete(get(pnAlign,'children'));
            respMenu(pnResp,pFile,pSig,userOpt);
            set(pnResp,'visible','on');
        case 'align'                        % align & resample tab
            options.session.nav.pre = 3;
            set(userOpt,'userData',options);
            set(tbFilt,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnFilt,'visible','off'); delete(get(pnFilt,'children'));
            set(tbExt,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnExt,'visible','off'); delete(get(pnExt,'children'));
            set(tbResp,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnResp,'visible','off'); delete(get(pnResp,'children'));
            alignMenu(pnAlign,pFile,pSig,userOpt,tbAn);
            set(pnAlign,'visible','on');
    end
else
    if get(scr,'value') == 1
        set(scr,'value',0);
    else
        set(scr,'value',1);
    end
end
end