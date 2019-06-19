function crsidlab
% CRSIDLab - Cardiorespiratory System Identification Lab
%
%   CRIDLab is a toolbox for cardiorespiratory system identification,
%   providing quanitative indicators for the autonomic nervous system
%   (ANS) modulation assessment. The variables used for system 
%   identification are obtained from electrocardiogram (ECG), arterial 
%   blood pressure (BP) and airflow or instantaneous lung volume (ILV) 
%   continuous measurements.
%
%   The toolbox has preprocessing tools to extract and condition the
%   variables for system identification. ECG may be filtered before QRS
%   detection, allowing the extraction of R-R Intervals (RRI). BP may be
%   filtered before systolic blood pressure (SBP) and/or diastolic blood
%   pressure (DBP) extraction. Ectopic (extrasystole) beats may be removed
%   or interpolated through manual inspection. Airflow data has to be 
%   integrated, then detrended to present instantaneous lung volume (ILV) 
%   information, which may then be filtered if needed. Preprocessing ends 
%   with the alignment and resampling of the variables chosen from those 
%   mentioned above to compose a system.
%
%   The toolbox also presents analysis tools. Spectral analysis through
%   power spectral density (PSD) is available, using the Fourier transform
%   (FFT), the Welch method, or an autoregressive (AR) model, allowing the
%   usage of different parameters. Information on the power (areas under 
%   the curve of the PSD) of three frequency bands is provided. When 
%   performed on RRI or hear rate (HR) it is an indicator of heart rate 
%   variability (HRV).
%
%   Finally, system identification is available, using up to three 
%   variables in any combination. If more than one variable is used, user
%   must indicate which one is to be used as system output. The system may
%   be estimated based on the following models:
%   - Autoregressive (AR) model, for a single variable;
%   - Autoregressive with exogenous output (ARX) model, for multiple
%     variables;
%   - Laguerre basis function (LBF) model, for multiple variables;
%   - Meixner basis function (MBF) model, for multiple variables.
%
%
% Original Matlab code: Luisa Santiago C. B. da Silva, September 2017
% based on modules from ECGLab (Carvalho,2001) - more info on manual

clc
warning('off','MATLAB:hg:uicontrol:ParameterValuesMustBeValid');
warning('off','MATLAB:legend:IgnoringExtraEntries');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% window configuration
%

scrSize = get(0,'ScreenSize');          % screen resolution
taskbarSize = 41;                       % value used to compensate task bar
scrSize(2) = scrSize(2)+taskbarSize;    % compensates task bar at bottom
scrSize(4) = scrSize(4)-taskbarSize;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% main window
%

mainWindow = figure(1); clf(1);
set(mainWindow, 'MenuBar', 'none','Units','Pixels','OuterPosition',...
    scrSize,'Name',['(ENE/UnB) CRSIDLab - Cardiorespiratory System ',...
    'Identification Lab'],'NumberTitle','off','color',[.94 .94 .94]);

% Tab group: main window, pre-processing, analysis
tbMain = uicontrol('parent',mainWindow,'style','toggle','tag','main',...
    'string','Main page','value',1,'units','normalized','Position',...
    [0 .9586 .06 .04],'backgroundcolor',[1 1 1]);
pnMain = uipanel('parent',mainWindow,'units','normalized','position',...
    [0 0 1 .96],'visible','on');

tbPre = uicontrol('parent',mainWindow,'style','toggle','tag','pre',...
    'string','Pre-processing','units','normalized','Position',...
    [.0595 .9586 .085 .04],'enable','off');
pnPre = uipanel('parent',mainWindow,'units','normalized','position',...
    [0 0 1 .96],'visible','off');

tbAn = uicontrol('parent',mainWindow,'style','toggle','tag','an',...
    'string','Analysis','units','normalized','Position',...
    [.144 .9586 .06 .04],'enable','off');
pnAn = uipanel('parent',mainWindow,'units','normalized','position',...
    [0 0 1 .96],'visible','off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% variables setup
%

% temporary patient data objects
data = dataPkg.patientData; sig = dataPkg.patientSig;
sys = dataPkg.patientSys; model = dataPkg.sysModel;

pTemp = uicontrol('visible','off','userData',data);
pFile = uicontrol('visible','off','userData',data);
pSig = uicontrol('visible','off','userData',sig);
pSys = uicontrol('visible','off','userData',sys);
pMod = uicontrol('visible','off','userData',model);

data1 = struct; 
% list of variables and values imported from workspace
dataList = uicontrol('visible','off','userData',data1);
% list of variables that have been added to file
addedData = uicontrol('visible','off','userData',data1);

% user options saved from previous sessions
load('userOptions.mat','options');

% add session info used to manage data between tabs
options.session.filename = options.main.file; %#ok<NODEF>

% navigation
options.session.nav.main = 0;
options.session.nav.info = 0;
options.session.nav.pre = 0;
options.session.nav.resp = 0;
options.session.nav.an = 0;
options.session.nav.psd = 0;
options.session.nav.ident = 0;
options.session.nav.imresp = 0;

% options for creating new patient
options.create = struct;
options.create.specs = struct;
options.create.filt.notch = [];
options.create.filt.lowPass = [];
options.create.filt.highPass = [];
options.create.var.selection = 0;
options.create.var.origin = 0;
options.create.var.ectopic = [];
options.create.resp.selection = 0;
options.create.resp.poly = [];
options.create.resp.high = [];
options.create.resp.other = [];
options.create.resp.low = [];

% main tab
options.session.main.opened = 0;
if exist(options.main.path,'dir')
    options.session.main.prevPath = options.main.path;
else
    options.session.main.prevPath = pwd;
end
options.session.main.teID = '';
options.session.main.teDir = '';
options.session.main.lbVar = '';
options.session.main.listString = '';
options.session.main.done = 0;
options.session.main.txRecord = sprintf(['\n        Patient ID:\n\n   ',...
    '     Name:\n        Age:\n        Gender:\n        Place of ',...
    'origin:\n        Address:\n        Phone:\n        E-mail ',...
    'address:\n\n        Exam date:\n\n        Experimental protocol:',...
    '\n\n        Physical exam:\n\n        Clinical history:\n\n      ',...
    '  Family history:']);

% filter ECG/BP
options.session.filt.saved = 0;
options.session.filt.varString = '';
options.session.filt.varValue = 1;
options.session.filt.curPos = 0;
options.session.filt.windowLen = options.filt.windowLen;
options.session.filt.slider = [0.01 0.1];
options.session.filt.notch = options.filt.notch;
options.session.filt.lowPass = options.filt.lowPass;
options.session.filt.highPass = options.filt.highPass;
options.session.filt.flags.notch = 0;
options.session.filt.flags.lowPass = 0;
options.session.filt.flags.highPass = 0;
options.session.filt.flags.flip = 0;
options.session.filt.sigLen = [];
options.session.filt.sigSpec = [];
options.session.filt.lo_lim = [];
options.session.filt.hi_lim = [];

% extract variables (RRI/HR/SBP/DBP)
options.session.ext.saved = 0;
options.session.ext.varString.ecg = '';
options.session.ext.varString.bp = '';
options.session.ext.varValue.ecg = 1;
options.session.ext.varValue.bp = 1;
options.session.ext.curPos = 0;
options.session.ext.windowLen = options.ext.windowLen;
options.session.ext.slider = [0.01 0.1];
options.session.ext.ts = options.ext.ts;
options.session.ext.showTs = options.ext.showTs;
options.session.ext.cbSelection = options.ext.cbSelection;
options.session.ext.grid.ecg = options.ext.grid.ecg;
options.session.ext.grid.bp = options.ext.grid.bp;
options.session.ext.label = options.ext.label;
options.session.ext.alg.rri = [];
options.session.ext.alg.sbp = [];
options.session.ext.alg.dbp = [];
options.session.ext.sigLen = [];
options.session.ext.sigSpec = [];
options.session.ext.proc.ecg = 0;
options.session.ext.proc.bp = 0;
options.session.ext.lo_lim.ecg = [];
options.session.ext.hi_lim.ecg = [];
options.session.ext.lo_lim.bp = [];
options.session.ext.hi_lim.bp = [];

% preprocess respiration data
options.session.resp.saved = 0;
options.session.resp.varString = '';
options.session.resp.varValue = 1;
options.session.resp.curPos = 0;
options.session.resp.windowLen = options.resp.windowLen;
options.session.resp.slider = [0.01 0.1];
options.session.resp.highPass = options.resp.highPass;
options.session.resp.polyOrd = options.resp.polyOrd;
options.session.resp.lowPass1 = options.resp.lowPass1;
options.session.resp.lowPass2 = options.resp.lowPass2;
options.session.resp.cbSelection = options.resp.cbSelection;
options.session.resp.method = [];
options.session.resp.rbSelection = options.resp.rbSelection;
options.session.resp.flags.compMode = 0;
options.session.resp.flags.int = 0;
options.session.resp.flags.det = 0;
options.session.resp.flags.filt = 0;
options.session.resp.sigLen = [];
options.session.resp.sigSpec = [];
options.session.resp.lo_lim = [];
options.session.resp.hi_lim = [];

% align and resample data sets
options.session.align.saved = 0;
options.session.align.varString.ecg = '';
options.session.align.varString.bp = '';
options.session.align.varString.rsp = '';
options.session.align.varValue.ecg = 1;
options.session.align.varValue.bp = 1;
options.session.align.varValue.rsp = 1;
options.session.align.curPos = 0;
options.session.align.windowLen = options.align.windowLen;
options.session.align.rbMethod = options.align.rbMethod;
options.session.align.rbEctopic = options.align.rbEctopic;
options.session.align.rbBorder = options.align.rbBorder;
options.session.align.rbRRIOut = options.align.rbRRIOut;
options.session.align.rbStart = options.align.rbStart;
options.session.align.rbEnd = options.align.rbEnd;
options.session.align.resampFs = options.align.resampFs;
options.session.align.points = options.align.points;
options.session.align.startPoint = -1;
options.session.align.endPoint = -1;
options.session.align.proc = 0;
options.session.align.resampled = 0;
options.session.align.sigLen = [];
options.session.align.sigSpec = [];

% PSD analysis
options.session.psd.saved = 0;
options.session.psd.exp = 0;
options.session.psd.varString = '';
options.session.psd.varValue = 1;
options.session.psd.vlf = options.psd.vlf;
options.session.psd.lf = options.psd.lf;
options.session.psd.hf = options.psd.hf;
options.session.psd.minP = options.psd.minP;
options.session.psd.maxP = options.psd.maxP;
options.session.psd.minF = options.psd.minF;
options.session.psd.maxF = options.psd.maxF;
options.session.psd.arOrder = options.psd.arOrder;
options.session.psd.N = options.psd.N;
options.session.psd.cbSelection = options.psd.cbSelection;
options.session.psd.rbWindow = options.psd.rbWindow;
options.session.psd.rbScale = options.psd.rbScale;
options.session.psd.segments = options.psd.segments;
options.session.psd.overlap = options.psd.overlap;
options.session.psd.fill = options.psd.fill;
options.session.psd.areas = struct;
options.session.psd.fs = [];
options.session.psd.sigLen = [];
options.session.psd.sigSpec = [];

% create new system
options.session.sys.saved = 0;
options.session.sys.varString.out = '';
options.session.sys.varString.in1 = '';
options.session.sys.varString.in2 = '';
options.session.sys.varValue.out = 1;
options.session.sys.varValue.in1 = 1;
options.session.sys.varValue.in2 = 1;
options.session.sys.perc = options.sys.perc;
options.session.sys.poly = options.sys.poly;
options.session.sys.filtered = 0;
options.session.sys.viewFilter = 0;
options.session.sys.detrended = 0;
options.session.sys.viewDetrend = 0;
options.session.sys.sigLen = [];
options.session.sys.sigSpec = [];

% system identification
options.session.ident.modelGen = 0;
options.session.ident.saved = 0;
options.session.ident.sysString = '';
options.session.ident.sysValue = 1;
options.session.ident.sysKey = [];
options.session.ident.model = options.ident.model;
options.session.ident.criteria = options.ident.criteria;
options.session.ident.orMax = options.ident.orMax;
options.session.ident.param = options.ident.param;
options.session.ident.gen = options.ident.gen;
options.session.ident.pole = options.ident.pole;
options.session.ident.sysMem = options.ident.sysMem;
options.session.ident.sysLen = [0 0 0];
options.session.ident.freq = options.ident.freq;

userOpt = uicontrol('visible','off','userData',options);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Set final callbacks
%

set(mainWindow,'CloseRequestFcn',{@closeFcn,userOpt});
set(tbMain,'callback',{@tabChange,tbMain,pnMain,tbPre,pnPre,tbAn,pnAn,...
    pFile,pTemp,pSig,pSys,pMod,userOpt,dataList,addedData});
set(tbPre,'callback',{@tabChange,tbMain,pnMain,tbPre,pnPre,tbAn,pnAn,...
    pFile,pTemp,pSig,pSys,pMod,userOpt});
set(tbAn,'callback',{@tabChange,tbMain,pnMain,tbPre,pnPre,tbAn,pnAn,...
    pFile,pTemp,pSig,pSys,pMod,userOpt});

tabChange(tbMain,[],tbMain,pnMain,tbPre,pnPre,tbAn,pnAn,pFile,pTemp,...
    pSig,pSys,pMod,userOpt,dataList,addedData);

end

function tabChange(scr,~,tbMain,pnMain,tbPre,pnPre,tbAn,pnAn,pFile,...
    pTemp,pSig,pSys,pMod,userOpt,dataList,addedData)
% changes between tabs: main tab, preprocessing tab & analysis tab

% verifiy if there is unsaved data in the previous tab before changing
errStat = 0; dispDialog = 0;
options = get(userOpt,'userData');
switch options.session.nav.main
    case 1                                  % preprocessing tab
        if ~strcmp(get(scr,'tag'),'pre')
            switch options.session.nav.pre
                case 0                      % filter ECG/BP
                    if ~options.session.filt.saved && ...
                            (options.session.filt.flags.notch ||... 
                            options.session.filt.flags.lowPass || ...
                            (options.session.filt.flags.highPass && ...
                            strcmp(options.session.filt.sigSpec{1},'ecg')))
                        dispDialog = 1;
                    end
                case 1                      % extract variables
                    if ~options.session.ext.saved && ...
                            (options.session.ext.proc.ecg || ...
                            options.session.ext.proc.bp)
                        dispDialog = 1;
                    end
                case 2                      % preprocess respiration
                    if ~options.session.resp.saved && ...
                            (options.session.resp.flags.int ||... 
                            options.session.resp.flags.det || ...
                            options.session.resp.flags.filt)
                        dispDialog = 1;
                    end
                case 3                      % align & resample
                    if ~options.session.align.saved && ...
                            options.session.align.proc
                        dispDialog = 1;
                    end
            end
        end
    case 2                                  % analysis tab
        if ~strcmp(get(scr,'tag'),'an')
            switch options.session.nav.an
                case 0                      % PSD
                    if ~isempty(options.session.psd.sigLen)
                        pat = get(pFile,'userData');
                        signals = get(pSig,'userData');
                        id = options.session.psd.sigSpec{1};
                        type = options.session.psd.sigSpec{2};
                        if ~options.session.psd.saved && ...
                                ((options.session.psd.cbSelection(1) && ...
                                ~isequal(pat.sig.(id).(...
                                type).aligned.psd.psdFFT,signals.(id).(...
                                type).aligned.psd.psdFFT)) || ...
                                (options.session.psd.cbSelection(2) && ...
                                ~isequal(pat.sig.(id).(...
                                type).aligned.psd.psdAR,signals.(id).(...
                                type).aligned.psd.psdAR)) || ...
                                (options.session.psd.cbSelection(1) && ...
                                ~isequal(pat.sig.(id).(...
                                type).aligned.psd.psdWelch,...
                                signals.(id).(type).aligned.psd.psdWelch)))
                            dispDialog = 1;
                        end
                    end
                case 1                      % system identification
                    switch options.session.nav.ident
                        case 0              % create new system
                            if ~options.session.sys.saved && (...
                                    options.session.sys.filtered || ...
                                    options.session.sys.detrended)
                                dispDialog = 1;
                            end
                        case 1              % model estimation
                            saved = 0;
                            if options.session.ident.sysLen(1) ~= 0
                                patient = get(pFile,'userData');
                                model = get(pMod,'userData');
                                sysName = options.session.ident.sysKey{...
                                    options.session.ident.sysValue-1};
                                prevMod = fieldnames(patient.sys.(...
                                    sysName).models);
                                if ~isempty(prevMod)
                                    for i = 1:length(prevMod)
                                        if isequal(patient.sys.(...
                                                sysName).models.(...
                                                prevMod{i}).Theta,...
                                                model.Theta) && ...
                                                isequal(patient.sys.(...
                                                sysName).models.(...
                                                prevMod{i}).Type,...
                                                model.Type)
                                            saved = 1;
                                        end
                                    end
                                end
                            end

                            if ~saved && options.session.ident.modelGen
                                dispDialog = 1;
                            end
                    end
            end
        end
end
if get(scr,'value') == 1 && dispDialog
    [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
        'changeTabMainPref','Change tabs',sprintf(['Warning!\nThe ',... 
        'current data has not been saved. Any modifications will ',...
        'be lost if the tabs are switched at this point.\nAre you ',...
        'sure you wish to proceed?']),{'Yes','No'},'DefaultButton',...
        'No');
    if strcmp(selButton,'no') && dlgShow
        errStat = 1;
    else                      % set up flags if user chooses to move on
        switch options.session.nav.main
            case 1                          % preprocessing tab
                switch options.session.nav.pre
                    case 0                  % filter ECG/BP
                        options.session.filt.flags.notch = 0;
                        options.session.filt.flags.lowPass = 0;
                        options.session.filt.flags.highPass = 0;
                    case 1                  % extract variables
                        options.session.ext.proc.ecg = 0;
                        options.session.ext.proc.bp = 0;
                    case 2                  % preprocess respiration
                        options.session.resp.flags.int = 0;
                        options.session.resp.flags.det = 0;
                        options.session.resp.flags.filt = 0;
                    case 3                  % align & resample
                        options.session.align.proc = 0;
                end
            case 2                          % analysis tab
                switch options.session.nav.an
                    case 0                  % PSD
                        options.session.psd.sigLen = [];
                    case 1                  % system identification
                        switch options.session.nav.ident
                            case 0          % create new system
                                options.session.sys.filtered = 0;
                                options.session.sys.detrended = 0;
                            case 1          % model estimation
                                options.session.ident.modelGen = 0;
                                options.session.ident.sysLen = [0 0 0];
                        end
                end
        end
    end  
end

% switch tabs (adjust toggle buttons and call tab script)
if get(scr,'value') == 1 && ~errStat
    set(scr,'backgroundcolor',[1 1 1]);
    switch get(scr,'tag')
        case 'main'                         % main tab
            options.session.nav.main = 0;
            set(userOpt,'userData',options);
            set(tbPre,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnPre,'visible','off'); delete(get(pnPre,'children'));
            set(tbAn,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnAn,'visible','off'); delete(get(pnAn,'children'));
            mainTab(pnMain,pFile,pTemp,pSig,pSys,pMod,userOpt,...
                tbPre,tbAn,dataList,addedData);
            set(pnMain,'visible','on');
        case 'pre'                          % preprocessing tab
            options.session.nav.main = 1;
            set(userOpt,'userData',options);
            set(tbMain,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnMain,'visible','off'); delete(get(pnMain,'children'));
            set(tbAn,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnAn,'visible','off'); delete(get(pnAn,'children'));
            preTab(pnPre,pFile,pSig,userOpt,tbAn);
            set(pnPre,'visible','on');
        case 'an'                           % analysis tab
            options.session.nav.main = 2;
            set(userOpt,'userData',options);
            set(tbMain,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnMain,'visible','off'); delete(get(pnMain,'children'));
            set(tbPre,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnPre,'visible','off'); delete(get(pnPre,'children'));
            analysisTab(pnAn,pFile,pSig,pSys,pMod,userOpt);
            set(pnAn,'visible','on');
    end
else
    if get(scr,'value') == 1
        set(scr,'value',0);
    else
        set(scr,'value',1);
    end
end
end

function closeFcn(~,~,userOpt)
% function called before closing CRSIDLab window

% confirm closing
[selButton, dlgShow] = uigetpref('CRSIDLabPref','closeCRSIDLab',...
    'Close window',sprintf(['Are you sure you want to leave? Any ',...
    'unsaved progress will be lost.']),{'Yes','No'},'DefaultButton','No');

if strcmp(selButton,'yes') || ~dlgShow
    % save user options for next sessions
    options = get(userOpt,'userData');
    options.main.file = options.session.filename;
    options.main.path = options.session.main.prevPath;
    options = rmfield(options,'session'); %#ok<NASGU>
    save('userOptions.mat','options');
    
    % reset warnings
    warning('on','MATLAB:uitabgroup:OldVersion');
    warning('on','MATLAB:hg:uicontrol:ParameterValuesMustBeValid');
    warning('on','MATLAB:legend:IgnoringExtraEntries');
    
    handles = findall(groot, 'Type', 'figure');
    delete(handles);
end  
end