function psdMenu(pnPsd,pFile,pSig,userOpt)
% PsdMenu - CRSIDLab
%   The psdMenu presents options for PSD analysis of any available
%   resampled variable: R-R interval (RRI), heart rate (HR), systolic blood
%   pressure (SBP), diastolic blood pressure (DBP) and instantaneous lung
%   volume (ILV). PSD can be estimated through the Fourier transform, the
%   Welch method and/or the AR model. Absolute, relative and normalized
%   areas are given as a measure of power on three frequency bands, that
%   can be delimited by the user.
%
% Original Matlab code: Luisa Santiago C. B. da Silva, April 2017.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Data visualization and slider
%

uicontrol('parent',pnPsd,'style','text','string','Select register:',...
    'hor','left','units','normalized','position',[.032 .93 .1 .03]);
puVar = uicontrol('parent',pnPsd,'style','popupmenu','string',...
    'No data available','value',1,'backgroundColor',[1 1 1],'units',...
    'normalized','position',[.13 .93 .2 .04]);

pHandle = axes('parent',pnPsd,'Units','pixels','Units','normalized',...
    'Position',[.057 .14 .515 .74]);

uicontrol('parent',pnPsd,'style','text','hor','right','string',...
    'Frequency (Hz) ','fontSize',10,'units','normalized','position',...
    [.476 .06 .1 .035]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PSD Parameters
%

pnParams = uipanel('parent',pnPsd,'Units','Normalized','Position',...
    [.748 .67 .23 .21]);

uicontrol('parent',pnParams,'Style','text','String',['Spectrogram ',...
    'parameters:'],'Units','Normalized','Position',[.05 .825 .9 .13]);

% # of points for fourier transform
uicontrol('parent',pnParams,'Style','text','String','# of Points:',...
    'hor','left','Units','Normalized','Position',[.05 .63 .3 .15]);

teN = uicontrol('parent',pnParams,'Style','edit','tag','N','Units',...
    'Normalized','Position',[.3 .63 .15 .15],'backgroundColor',[1 1 1]);

txN = uicontrol('parent',pnParams,'Style','text','String',...
    '(Suggested: -) ','hor','right','Units','Normalized','Position',...
    [.45 .63 .5 .15]);

% AR model order
uicontrol('parent',pnParams,'Style','text','String','AR Order:','hor',...
    'left','Units','Normalized','Position',[.05 .435 .3 .15]);

teArOrder = uicontrol('parent',pnParams,'Style','edit','tag','arOrder',...
    'Units','Normalized','Position',[.3 .435 .15 .15],'backgroundColor',...
    [1 1 1]);

% # of overlapping samples for Welch method
uicontrol('parent',pnParams,'Style','text','String',['Overlapping ',...
    'samples:'],'hor','left','Units','Normalized','Position',...
    [.05 .045 .5 .15]);

txOverlap = uicontrol('parent',pnParams,'Style','text','String',...
    '(max: ----) ','hor','right','Units','Normalized','Position',...
    [.7 .045 .3 .15]);

teOverlap = uicontrol('parent',pnParams,'Style','edit','tag','overlap',...
    'Units','Normalized','Position',[.55 .045 .15 .15],...
    'backgroundColor',[1 1 1]);

% # of samples per segment for Welch method
uicontrol('parent',pnParams,'Style','text','String',['Samples per ',...
    'segment:'],'hor','left','Units','Normalized','Position',...
    [.05 .24 .5 .15]);

txSegments = uicontrol('parent',pnParams,'Style','text','String',...
    '(max: ----) ','hor','right','Units','Normalized','Position',...
    [.7 .24 .3 .15]);

teSegments = uicontrol('parent',pnParams,'Style','edit','tag',...
    'segments','Units','Normalized','Position',[.55 .24 .15 .15],...
    'backgroundColor',[1 1 1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Window
%

pnWindow = uipanel('parent',pnPsd,'Units','Normalized','Position',...
    [.748 .53 .23 .14]);

uicontrol('parent',pnWindow,'Style','text','String','Window:','Units',...
    'Normalized','Position',[.05 .76 .9 .2]);

rbRec = uicontrol('parent',pnWindow,'Style','radio','tag','window',...
    'String','Rectangular','userData',0,'Units','Normalized','Position',...
    [.05 .52 .4 .2]);

rbBar = uicontrol('parent',pnWindow,'Style','radio','tag','window',...
    'String','Bartlett','userData',1,'Units','Normalized','Position',...
    [.05 .28 .4 .2]);

rbHam = uicontrol('parent',pnWindow,'Style','radio','tag','window',...
    'String','Hamming','userData',2,'Units','Normalized','Position',...
    [.05 .04 .4 .2]);

rbHan = uicontrol('parent',pnWindow,'Style','radio','tag','window',...
    'String','Hanning','userData',3,'Units','Normalized','Position',...
    [.55 .52 .4 .2]);

rbBla = uicontrol('parent',pnWindow,'Style','radio','tag','window',...
    'String','Blackman','userData',4,'Units','Normalized','Position',...
    [.55 .28 .4 .2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PSD methods (Fourier, Welch method, AR model)
%

pnMethod = uipanel('parent',pnPsd,'Units','Normalized','Position',...
    [.748 .39 .135 .14]);

uicontrol('parent',pnMethod,'Style','text','String','Method:','Units',...
    'Normalized','Position',[.05 .76 .9 .2]);

cbDft = uicontrol('parent',pnMethod,'Style','check','String',['Fourier',...
    ' Transform'],'userData',1,'Units','Normalized','Position',...
    [.05 .52 .9 .2]);

cbWelch = uicontrol('parent',pnMethod,'Style','check','String',['Welch',...
    ' Method'],'userData',2,'Units','Normalized','Position',...
    [.05 .28 .9 .2]);

cbAR = uicontrol('parent',pnMethod,'Style','check','String','AR Model',...
    'userData',3,'Units','Normalized','Position',[.05 .04 .9 .2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot Scale
%

pnScale = uipanel('parent',pnPsd,'Units','Normalized','Position',...
    [.883 .39 .095 .14]);

uicontrol('parent',pnScale,'Style','text','String','Scale:','Units',...
    'Normalized','Position',[.1 .76 .8 .2]);

rbNormal = uicontrol('parent',pnScale,'Style','radio','tag','scale',...
    'String','Normal','userData',0,'Units','Normalized','Position',...
    [.1 .52 .8 .2]);

rbMonolog = uicontrol('parent',pnScale,'Style','radio','tag','scale',...
    'String','Monolog','userData',1,'Units','Normalized','Position',...
    [.1 .28 .8 .2]);

rbLoglog = uicontrol('parent',pnScale,'Style','radio','tag','scale',...
    'String','Log-Log','userData',2,'Units','Normalized','Position',...
    [.1 .04 .8 .2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Axes limits
%

frAxes = uipanel('parent',pnPsd,'Units','Normalized','Position',...
    [.748 .275 .23 .115]);

uicontrol('parent',frAxes,'Style','text','String','Plot axes:','Units',...
    'Normalized','Position',[.05 .75 .9 .2]);

uicontrol('parent',frAxes,'Style','text','String','Freq. From:','hor',...
    'left','Units','Normalized','Position',[.05 .4 .3 .3]);

teMinF = uicontrol('parent',frAxes,'Style','edit','tag','minF','Units',...
    'Normalized','Position',[.32 .4 .15 .3],'BackgroundColor',[1 1 1]);

uicontrol('parent',frAxes,'Style','text','String','Hz             To:',...
    'Units','Normalized','Position',[.47 .4 .35 .28]);

teMaxF = uicontrol('parent',frAxes,'Style','edit','tag','maxF','Units',...
    'Normalized','Position',[.8 .4 .15 .3],'BackgroundColor',[1 1 1]);

uicontrol('parent',frAxes,'Style','text','String','Ampl. From:','hor',...
    'left','Units','Normalized','Position',[.05 .05 .3 .3]);

teMinP = uicontrol('parent',frAxes,'Style','edit','tag','minP',...
    'Callback',{@teCallback,userOpt,pHandle,pSig},'Units','Normalized',...
    'Position',[.32 .05 .15 .3],'BackgroundColor',[1 1 1]);

txUnit = uicontrol('parent',frAxes,'Style','text','string',['ms²/Hz   ',...
    '   To:'],'Units','Normalized','Position',[.47 .05 .35 .28]);

teMaxP = uicontrol('parent',frAxes,'Style','edit','tag','maxP',...
    'Callback',{@teCallback,userOpt,pHandle,pSig},'Units','Normalized',...
    'Position',[.8 .05 .15 .3],'BackgroundColor',[1 1 1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Frequency band definition (VLF,LF and HF)
%

pnBands = uipanel('parent',pnPsd,'Units','Normalized','Position',...
    [.748 .145 .23 .13]);

% very low frequency (VLF) upper limit
uicontrol('parent',pnBands,'Style','text','String','Very  Low Freqs.:',...
    'hor','left','Units','Normalized','Position',[.05 .685 .4 .26]);
uicontrol('parent',pnBands,'Style','text','string','0','Units',...
    'Normalized','Position',[.45 .685 .15 .26]);
uicontrol('parent',pnBands,'Style','text','String','to','Units',...
    'Normalized','Position',[.6 .685 .1 .26]);
teVlf = uicontrol('parent',pnBands,'Style','edit','tag','vlf','Units',...
    'Normalized','Position',[.7 .685 .15 .26],'BackgroundColor',[1 1 1]);
uicontrol('parent',pnBands,'Style','text','String','Hz','Units',...
    'Normalized','Position',[.85 .685 .1 .26]);

% low frequency (LF) upper limit
uicontrol('parent',pnBands,'Style','text','String','Low Frequencies:',...
    'hor','left','Units','Normalized','Position',[.05 .37 .4 .26]);
txLf = uicontrol('parent',pnBands,'Style','text','Units','normalized',...
    'Position',[.45 .37 .15 .26]);
uicontrol('parent',pnBands,'Style','text','String','to','Units',...
    'Normalized','Position',[.6 .37 .1 .26]);
teLf = uicontrol('parent',pnBands,'Style','edit','tag','lf','Units',...
    'Normalized','Position',[.7 .37 .15 .26],'BackgroundColor',[1 1 1]);
uicontrol('parent',pnBands,'Style','text','String','Hz','Units',...
    'Normalized','Position',[.85 .37 .1 .26]);

% high frequency (HF) upper limit
uicontrol('parent',pnBands,'Style','text','String','High Frequencies:',...
    'hor','left','Units','Normalized','Position',[.05 .055 .4 .26]);
txHf = uicontrol('parent',pnBands,'Style','text','Units','Normalized',...
    'Position',[.45 .055 .15 .26]);
uicontrol('parent',pnBands,'Style','text','String','to','Units',...
    'Normalized','Position',[.6 .055 .1 .26]);
teHf = uicontrol('parent',pnBands,'Style','edit','tag','hf','units',...
    'Normalized','Position',[.7 .055 .15 .26],'BackgroundColor',[1 1 1]);
uicontrol('parent',pnBands,'Style','text','String','Hz','Units',...
    'Normalized','Position',[.85 .055 .1 .26]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Export areas and save spectrogram
%

pnButtons = uipanel('parent',pnPsd,'Units','Normalized','Position',...
    [.748 .06 .23 .085]);

uicontrol('parent',pnButtons,'Style','push','String','Save Spectrogram',...
    'CallBack',{@saveSig,userOpt,pFile,pSig},'Units','Normalized',...
    'Position',[.05 .2 .425 .6]);

uicontrol('parent',pnButtons,'Style','push','String','Export Areas',...
    'CallBack',{@exportTxt,userOpt,pSig},'Units','Normalized',...
    'Position',[.525 .2 .425 .6]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Show areas on each frequency band for each method
%

tbFFT = uicontrol('parent',pnPsd,'style','toggle','tag','fft','string',...
    'Fourier','value',1,'units','normalized','Position',...
    [.593 .877 .045 .046],'backgroundcolor',[1 1 1]);
pnFFT = uipanel('parent',pnPsd,'Units','Normalized','Position',...
    [.593 .275 .155 .605],'visible','on');

tbWelch = uicontrol('parent',pnPsd,'style','toggle','tag','welch',...
    'string','Welch','units','normalized','Position',...
    [.637 .877 .045 .046]);
pnWelch = uipanel('parent',pnPsd,'Units','Normalized','Position',...
    [.593 .275 .155 .605],'visible','off');

tbAR = uicontrol('parent',pnPsd,'style','toggle','tag','ar','string',...
    'AR Model','units','normalized','Position',[.681 .877 .06 .046]);
pnAR = uipanel('parent',pnPsd,'Units','Normalized','Position',...
    [.593 .275 .155 .605],'visible','off');

txAreas = struct;

areasString = sprintf(['Absolute Areas\n\nVLF: ----\nLF:  ----\nHF',...
    ':  ----\n\nTotal: ----\n\nRelative Areas\n\nVLF:  ---- %%\nLF',...
    ':   ---- %%\nHF:   ---- %%\n\nNormalized Areas\n\nLF:  ---- ',...
    'n.u.\nHF:  ---- n.u.\n\nLF/HF Ratio: ----\n\n']);

txAreas.psdFFT = uicontrol('parent',pnFFT,'Style','text','String',...
    areasString,'FontName','Courier New','FontSize',9,'hor','left',...
    'Units','Normalized','Position',[.05 .05 .9 .9]);
txAreas.psdAR = uicontrol('parent',pnAR,'Style','text','String',...
    areasString,'FontName','Courier New','FontSize',9,'hor','left',...
    'Units','Normalized','Position',[.05 .05 .9 .9]);
txAreas.psdWelch = uicontrol('parent',pnWelch,'Style','text','String',...
    areasString,'FontName','Courier New','FontSize',9,'hor','left',...
    'Units','Normalized','Position',[.05 .05 .9 .9]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot legend and option to fill areas on plot
%

pnPlot = uipanel('parent',pnPsd,'Units','Normalized','Position',...
    [.593 .06 .155 .215]);

uicontrol('parent',pnPlot,'style','text','string','Plot Options:',...
    'Units','Normalized','Position',[.05 .8 .9 .15]);

cbFill = uicontrol('parent',pnPlot,'Style','checkbox','String',['Show ',...
    'areas on plot'],'CallBack',{@cbFillCallback,userOpt,pSig,pHandle},...
    'Units','Normalized','Position',[.05 .05 .9 .15]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Set final callbacks and call opening function (setup)
%

set(teMinF,'Callback',{@teCallback,userOpt,pHandle,pSig,[],[],[],teMinP,...
    teMaxP});
set(teMaxF,'Callback',{@teCallback,userOpt,pHandle,pSig,[],[],[],teMinP,...
    teMaxP});

set(teN,'Callback',{@teCallback,userOpt,pHandle,pSig,txAreas,[],[],...
    teMinP,teMaxP});
set(teArOrder,'Callback',{@teCallback,userOpt,pHandle,pSig,txAreas,[],...
    [],teMinP,teMaxP});
set(teOverlap,'Callback',{@teCallback,userOpt,pHandle,pSig,txAreas,...
    txOverlap,[],teMinP,teMaxP});
set(teSegments,'Callback',{@teCallback,userOpt,pHandle,pSig,txAreas,...
    txOverlap,teOverlap,teMinP,teMaxP});

set(teVlf,'Callback',{@teCallback,userOpt,pHandle,pSig,txAreas,txLf,[],...
    teMinP,teMaxP});
set(teLf,'Callback',{@teCallback,userOpt,pHandle,pSig,txAreas,txHf,[],...
    teMinP,teMaxP});
set(teHf,'Callback',{@teCallback,userOpt,pHandle,pSig,txAreas,[],[],...
    teMinP,teMaxP});

set(rbRec,'Callback',{@rbCallback,userOpt,pHandle,pSig,txAreas,teMinP,...
    teMaxP,rbBar,rbHam,rbHan,rbBla});
set(rbBar,'Callback',{@rbCallback,userOpt,pHandle,pSig,txAreas,teMinP,...
    teMaxP,rbRec,rbHam,rbHan,rbBla});
set(rbHam,'Callback',{@rbCallback,userOpt,pHandle,pSig,txAreas,teMinP,...
    teMaxP,rbRec,rbBar,rbHan,rbBla});
set(rbHan,'Callback',{@rbCallback,userOpt,pHandle,pSig,txAreas,teMinP,...
    teMaxP,rbRec,rbBar,rbHam,rbBla});
set(rbBla,'Callback',{@rbCallback,userOpt,pHandle,pSig,txAreas,teMinP,...
    teMaxP,rbRec,rbBar,rbHam,rbHan});

set(rbNormal,'Callback',{@rbCallback,userOpt,pHandle,pSig,txAreas,...
    teMinP,teMaxP,rbMonolog,rbLoglog});
set(rbMonolog,'Callback',{@rbCallback,userOpt,pHandle,pSig,txAreas,...
    teMinP,teMaxP,rbNormal,rbLoglog});
set(rbLoglog,'Callback',{@rbCallback,userOpt,pHandle,pSig,txAreas,...
    teMinP,teMaxP,rbNormal,rbMonolog});

set(cbAR,'Callback',{@cbCallback,userOpt,pHandle,pSig,txAreas,cbDft,...
    cbWelch,teMinP,teMaxP});
set(cbDft,'Callback',{@cbCallback,userOpt,pHandle,pSig,txAreas,cbAR,...
    cbWelch,teMinP,teMaxP});
set(cbWelch,'Callback',{@cbCallback,userOpt,pHandle,pSig,txAreas,cbDft,...
    cbAR,teMinP,teMaxP});

set(tbFFT,'callback',{@tabChange,tbFFT,pnFFT,tbAR,pnAR,tbWelch,pnWelch,...
    userOpt,pSig,pHandle});
set(tbAR,'callback',{@tabChange,tbFFT,pnFFT,tbAR,pnAR,tbWelch,pnWelch,...
    userOpt,pSig,pHandle});
set(tbWelch,'callback',{@tabChange,tbFFT,pnFFT,tbAR,pnAR,tbWelch,...
    pnWelch,userOpt,pSig,pHandle});

set(puVar,'callback',{@changeVar,userOpt,pFile,pSig,teMinP,teMaxP,...
    teSegments,txSegments,teOverlap,txOverlap,txN,txUnit,txAreas,pHandle});

openFnc(userOpt,pFile,pSig,puVar,teN,txN,teArOrder,teSegments,...
    txSegments,teOverlap,txOverlap,cbDft,cbAR,cbWelch,rbRec,rbBar,rbHam,...
    rbHan,rbBla,rbNormal,rbMonolog,rbLoglog,teVlf,txLf,teLf,txHf,teHf,...
    teMinP,teMaxP,teMinF,teMaxF,txUnit,tbFFT,pnFFT,tbAR,pnAR,tbWelch,...
    pnWelch,txAreas,cbFill,pHandle);
end

function openFnc(userOpt,pFile,pSig,puVar,teN,txN,teArOrder,teSegments,...
    txSegments,teOverlap,txOverlap,cbDft,cbAR,cbWelch,rbRec,rbBar,rbHam,...
    rbHan,rbBla,rbNormal,rbMonolog,rbLoglog,teVlf,txLf,teLf,txHf,teHf,...
    teMinP,teMaxP,teMinF,teMaxF,txUnit,tbFFT,pnFFT,tbAR,pnAR,tbWelch,...
    pnWelch,txAreas,cbFill,pHandle)
% adjust initial values of objects

options = get(userOpt,'userData');
patient = get(pFile,'userData');

% string for variable selection popupmenu from available patient data
stringPU = cell(5,1);
id = {'ecg','bp','rsp'};
count = 1;
for i = 1:3
    if i == 1, var = {'rri'};
    elseif i == 2, var = {'sbp','dbp'};
    else var = {'ilv','filt'}; 
    end
    for j = 1:length(var)
        if ~isempty(patient.sig.(id{i}).(var{j}).aligned.data)
            stringPU{count} = patient.sig.(id{i}).(var{j}).aligned.specs.tag;
            count = count+1;
        end
    end
end
stringPU = stringPU(~cellfun(@isempty,stringPU));
if isempty(stringPU)
    stringPU{1} = 'No aligned & resampled data available';
end

% adjust selection value if the variables list has changed
if ~isequal(options.session.psd.varString,stringPU)
    if ~isempty(options.session.psd.varString)
        if ismember(options.session.psd.varString{...
                options.session.psd.varValue},stringPU)
            options.session.psd.varValue = find(ismember(stringPU,...
                options.session.psd.varString{...
                options.session.psd.varValue}));
        else
            options.session.psd.varValue = 1;
        end
    end
    options.session.psd.varString = stringPU;
end

set(puVar,'string',options.session.psd.varString);
set(puVar,'value',options.session.psd.varValue);
set(puVar,'userData',options.session.psd.varValue);

% open data and setup options that depend on the data
set(userOpt,'userData',options);
setup(userOpt,pFile,pSig,teSegments,txSegments,teOverlap,txOverlap,txN,...
    txUnit);
options = get(userOpt,'userData');

% setup options that don't depend on the data
switch options.session.nav.psd
    case 0
        set(tbFFT,'value',1);
        tabChange(tbFFT,[],tbFFT,pnFFT,tbAR,pnAR,tbWelch,pnWelch,...
            userOpt,pSig,pHandle);
    case 1
        set(tbAR,'value',1);
        tabChange(tbAR,[],tbFFT,pnFFT,tbAR,pnAR,tbWelch,pnWelch,userOpt,...
            pSig,pHandle);
    case 2
        set(tbWelch,'value',1);
        tabChange(tbWelch,[],tbFFT,pnFFT,tbAR,pnAR,tbWelch,pnWelch,...
            userOpt,pSig,pHandle);
end

options.session.psd.vlf = checkLim(userOpt,options.session.psd.vlf,'vlf');
set(teVlf,'string',num2str(options.session.psd.vlf));
set(txLf,'string',num2str(options.session.psd.vlf));
options.session.psd.lf = checkLim(userOpt,options.session.psd.lf,'lf');
set(teLf,'string',num2str(options.session.psd.lf));
set(txHf,'string',num2str(options.session.psd.lf));
options.session.psd.hf = checkLim(userOpt,options.session.psd.hf,'hf');
set(teHf,'string',num2str(options.session.psd.hf));
options.session.psd.minP = checkLim(userOpt,options.session.psd.minP,...
    'minP');
set(teMinP,'string',num2str(options.session.psd.minP));
options.session.psd.maxP = checkLim(userOpt,options.session.psd.maxP,...
    'maxP');
set(teMaxP,'string',num2str(options.session.psd.maxP));
options.session.psd.minF = checkLim(userOpt,options.session.psd.minF,...
    'minF');
set(teMinF,'string',num2str(options.session.psd.minF));
options.session.psd.maxF = checkLim(userOpt,options.session.psd.maxF,...
    'maxF');
set(teMaxF,'string',num2str(options.session.psd.maxF));
options.session.psd.arOrder = checkLim(...
    userOpt,options.session.psd.arOrder,'arOrder');
set(teArOrder,'string',num2str(options.session.psd.arOrder));
options.session.psd.N = checkLim(userOpt,options.session.psd.N,'N');
set(teN,'String',num2str(options.session.psd.N));
set(cbFill,'value',options.session.psd.fill);

set(cbDft,'value',options.session.psd.cbSelection(1));
set(cbWelch,'value',options.session.psd.cbSelection(2));
set(cbAR,'value',options.session.psd.cbSelection(3));

set(rbRec,'value',0); set(rbBar,'value',0); set(rbHam,'value',0);
set(rbHan,'value',0); set(rbBla,'value',0);
if options.session.psd.rbWindow == 0, set(rbRec,'value',1);
elseif options.session.psd.rbWindow == 1, set(rbBar,'value',1);
elseif options.session.psd.rbWindow == 2, set(rbHam,'value',1);
elseif options.session.psd.rbWindow == 3, set(rbHan,'value',1);
elseif options.session.psd.rbWindow == 4, set(rbBla,'value',1);
end

set(rbNormal,'value',0); set(rbMonolog,'value',0); set(rbLoglog,'value',0);
if options.session.psd.rbScale == 0, set(rbNormal,'value',1);
elseif options.session.psd.rbScale == 1, set(rbMonolog,'value',1);
elseif options.session.psd.rbScale == 2, set(rbLoglog,'value',1);
end   

set(userOpt,'userData',options);
psdCalc(userOpt,pSig,teMinP,teMaxP);
psdPlot(pHandle,pSig,userOpt);
calcAreas(userOpt,pSig,txAreas);
end

function setup(userOpt,pFile,pSig,teSegments,txSegments,teOverlap,...
    txOverlap,txN,txUnit)
% open data and setup options that depend on the data

options = get(userOpt,'userData');

% identify selected data
auxVar = options.session.psd.varString{options.session.psd.varValue};
options.session.psd.sigLen = [];
options.session.psd.sigSpec = [];
id = ''; type = '';
if ~isempty(strfind(auxVar,'RRI')) || ~isempty(strfind(auxVar,'HR'))
    id = 'ecg'; type = 'rri';
elseif ~isempty(strfind(auxVar,'BP'))
    id = 'bp';
    if ~isempty(strfind(auxVar,'SBP'))
        type = 'sbp';
    else
        type = 'dbp';
    end
elseif ~isempty(strfind(auxVar,'ILV'))
    id = 'rsp';
    if ~isempty(strfind(auxVar,'Filtered'))
        type = 'filt';
    else
        type = 'ilv';
    end
end

% open data and setup options
if ~isempty(type)
    options.session.psd.sigSpec = {id, type};
    patient = get(pFile,'userData');
    signals = get(pSig,'userData');

    % adjust optional inputs
    if isempty(patient.sig.(id).(type).aligned.fs)
        if ~isempty(patient.sig.(id).(type).aligned.time)
            patient.sig.(id).(type).aligned.fs = round(1 / ...
                mean(diff(patient.sig.(id).(type).aligned.time))); 
        else
            patient.sig.(id).(type).aligned.fs = 1;
        end
    end
    if isempty(patient.sig.(id).(type).aligned.time)
        patient.sig.(id).(type).aligned.time = ...
            (0:(length(patient.sig.(id).(type).aligned.data)-1))/...
            patient.sig.(id).(type).aligned.fs;
    end 
    signals.(id).(type).aligned = patient.sig.(id).(type).aligned;
    options.session.psd.fs = signals.(id).(type).aligned.fs;
    
    options.session.psd.sigLen = length(signals.(id).(type).aligned.data);
    
    if options.session.psd.segments > options.session.psd.sigLen
        options.session.psd.segments = options.session.psd.sigLen;
    elseif options.session.psd.segments <= 0
        options.session.psd.segments = 1;
    end
    set(txSegments,'string',['(max: ',num2str(...
        options.session.psd.sigLen),') ']);
    
    if options.session.psd.overlap < 0
        options.session.psd.overlap = 0;
    elseif options.session.psd.overlap > options.session.psd.segments-1
        options.session.psd.overlap = options.session.psd.segments-1;
    end
    set(txOverlap,'string',['(max: ',num2str(...
        options.session.psd.segments-1),') ']);
    
    set(txN,'String',['(Suggested: ',num2str(2^nextpow2(...
        options.session.psd.sigLen)),') ']);
    
    if strcmp(id,'ecg')
        if ~isfield(signals.(id).(type).aligned.specs,'type')
            signals.(id).(type).aligned.specs.type = 'rri';
        end
        if strcmp(signals.(id).(type).aligned.specs.type,'rri')
            set(txUnit,'string','ms²/Hz      To:');
        else
            set(txUnit,'string','bpm²/Hz    To:');
        end
    elseif strcmp(id,'bp')
        set(txUnit,'string','mmHg²/Hz To:');
    elseif strcmp(id,'rsp')
        set(txUnit,'string','L²/Hz        To:');
    end
    
    options.session.psd.saved = 0;
    set(userOpt,'userData',options);
    set(pFile,'userData',patient);
    set(pSig,'userData',signals);
end

set(teSegments,'string',num2str(options.session.psd.segments));
set(teOverlap,'string',num2str(options.session.psd.overlap));
set(userOpt,'userData',options);
end

function changeVar(scr,~,userOpt,pFile,pSig,teMinP,teMaxP,teSegments,...
    txSegments,teOverlap,txOverlap,txN,txUnit,txAreas,pHandle)
% change record for variable extraction

errStat = 0;
oldValue = get(scr,'userData');
newValue = get(scr,'value');

if oldValue ~= newValue
    options = get(userOpt,'userData');
    if ~isempty(options.session.psd.sigLen)
        pat = get(pFile,'userData');
        signals = get(pSig,'userData');
        id = options.session.psd.sigSpec{1};
        type = options.session.psd.sigSpec{2};
        if ~options.session.psd.saved && ...
                ((options.session.psd.cbSelection(1) && ~isequal(...
                pat.sig.(id).(type).aligned.psd.psdFFT,...
                signals.(id).(type).aligned.psd.psdFFT)) || ...
                (options.session.psd.cbSelection(2) && ~isequal(...
                pat.sig.(id).(type).aligned.psd.psdWelch,...
                signals.(id).(type).aligned.psd.psdWelch)) || ...
                (options.session.psd.cbSelection(3) && ~isequal(...
                pat.sig.(id).(type).aligned.psd.psdAR,...
                signals.(id).(type).aligned.psd.psdAR)))
            [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
                'changeVarPsdPref','Change data',sprintf([...
                'Warning!','\nThe current data has not been saved. Any',...
                ' modifications will be lost if other data is opened ',...
                'before saving.\nAre you sure you wish to proceed?']),...
                {'Yes','No'},'DefaultButton','No');
            if strcmp(selButton,'no') && dlgShow
                errStat = 1;
            end  
        end
    end
    if ~errStat
        options.session.psd.varValue = newValue;
        set(scr,'userData',newValue);
        set(userOpt,'userData',options);

        setup(userOpt,pFile,pSig,teSegments,txSegments,teOverlap,...
            txOverlap,txN,txUnit);
        options = get(userOpt,'userData');
        if ~isempty(options.session.psd.sigLen)
            psdCalc(userOpt,pSig,teMinP,teMaxP);
            psdPlot(pHandle,pSig,userOpt);
            calcAreas(userOpt,pSig,txAreas);
        else
            set(get(pHandle,'children'),'visible','off');
            areasString = sprintf(['Absolute Areas\n\nVLF: ----\nLF:  ',...
                '----\nHF:  ----\n\nTotal: ----\n\nRelative Areas\n\n',...
                'VLF:  ---- %%\nLF:   ---- %%\nHF:   ---- %%\n\n',...
                'Normalized Areas\n\nLF:  ---- n.u.\nHF:  ---- n.u.\n',...
                '\nLF/HF Ratio: ----\n\n']);
            set(txAreas.psdFFT,'string',areasString);
            set(txAreas.psdAR,'string',areasString);
            set(txAreas.psdWelch,'string',areasString);
        end
    else
        set(scr,'value',oldValue);
    end
end
end

function saveSig(~,~,userOpt,pFile,pSig)
% save selected data

options = get(userOpt,'userData');
if ~isempty(options.session.psd.sigLen)
    
    errStat = 0; saved = 0;
    id = options.session.psd.sigSpec{1};
    type = options.session.psd.sigSpec{2};
    
    % verify if there's already PSD data saved
    patient = get(pFile,'userData');
    signals = get(pSig,'userData');
    psdType = {'psdFFT','psdAR','psdWelch'};
    for i = 1:3
        if ~isempty(patient.sig.(id).(type).aligned.psd.(psdType{i})) &&...
                ~isempty(signals.(id).(type).aligned.psd.(psdType{i}))
            saved = 1;
        end
    end
    
    if saved
        fftString = ''; arString = ''; welchString = '';
        if ~isempty(patient.sig.(id).(type).aligned.psd.(psdType{1})) &&...
                ~isempty(signals.(id).(type).aligned.psd.(psdType{1}))
            fftString = '\n Fourier Transform';
        end
        if ~isempty(patient.sig.(id).(type).aligned.psd.(psdType{2})) &&...
                ~isempty(signals.(id).(type).aligned.psd.(psdType{2}))
            arString = '\n AR Model';
        end
        if ~isempty(patient.sig.(id).(type).aligned.psd.(psdType{3})) &&...
                ~isempty(signals.(id).(type).aligned.psd.(psdType{3}))
            welchString = '\n Welch method';
        end
        psdString = [fftString,arString,welchString];
        [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
            'savePsdOWPref','Saving PSD data',sprintf([...
            'Warning!','\nIt appears that there''s already data saved',...
            ' for the following PSD(s) generated:',psdString,'\nAre ',...
            'you sure you wish to overwrite it?']),{'Yes','No'},...
            'DefaultButton','No');
        if strcmp(selButton,'no') && dlgShow
            errStat = 1;
        end     
    end
    
    if ~errStat
        filename = options.session.filename;
        
        % data specifications
        spec = struct;
        
        spec.N = options.session.psd.N;
        switch options.session.psd.rbWindow
            case 0
                spec.window = 'Rectangular';
            case 1
                spec.window = 'Bartlett';
            case 2
                spec.window = 'Hamming';
            case 3
                spec.window = 'Hanning';
            case 4
                spec.window = 'Blackman';
        end
        spec.vlf = [0 options.session.psd.vlf];
        spec.lf = [options.session.psd.vlf options.session.psd.lf];
        spec.hf = [options.session.psd.lf options.session.psd.hf];
        spec.areas = options.session.psd.areas;
        if ~isempty(signals.(id).(type).aligned.psd.(psdType{2}))
            spec.arOrder = options.session.psd.arOrder;
        end
        if ~isempty(signals.(id).(type).aligned.psd.(psdType{3}))
            spec.welchSegments = options.session.psd.segments;
            spec.welchOverlap = options.session.psd.overlap;
        end
        
        % save data
        signals.(id).(type).aligned.psd.specs = spec;
        patient.sig.(id).(type).aligned.psd = ...
            signals.(id).(type).aligned.psd;
        
        options.session.psd.saved = 1;
        set(userOpt,'userData',options);
        set(pSig,'userData',signals);
        set(pFile,'userData',patient);
        
        save(filename,'patient');
        
        stringFFT = []; stringWelch = []; stringAR = [];
        if options.session.psd.cbSelection(1)
            stringFFT = '\n Fourier Transform';
        end
        if options.session.psd.cbSelection(2)
            stringWelch = '\n Welch Method';
        end
        if options.session.psd.cbSelection(3)
            stringAR = '\n AR Model';
        end
        saveConfig(userOpt);
        msgString = [stringFFT,stringAR,stringWelch];
        uiwait(msgbox(sprintf(['The following PSDs have been ',...
            'saved:',msgString]),'PSDs saved','modal'));
    end
end
end

function exportTxt(~,~,userOpt,pSig)
% export information of areas for each frequency band to a text file
% formatted to be imported to a spreadsheet

options = get(userOpt,'userData');
if ~isempty(options.session.psd.sigLen)
    signals = get(pSig,'userData');
    
    % set units and labels according to data type
    id = options.session.psd.sigSpec{1};
    type = options.session.psd.sigSpec{2};
    if strcmp(id,'bp')
        varName = upper(type);
        unit = '(mmHg²)';  
    elseif strcmp(id,'rsp')
        varName = 'ILV';
        unit = '(L²)';
    else
        if strcmp(signals.(id).(type).aligned.specs.type,'rri')
            varName = 'RRI';
            unit = '(ms²)';
        else
            varName = 'HR';
            unit = '(bpm²)';
        end
    end
    
    % set window name according to radio button selection
    switch options.session.psd.rbWindow
        case 0
            auxWindow = 'Rectangular';
        case 1
            auxWindow = 'Bartlett';
        case 2
            auxWindow = 'Hamming';
        case 3
            auxWindow = 'Hanning';
        case 4
            auxWindow = 'Blackman';     
    end
    
    % set filename and optional inputs according to method chosen
    [path,name,~] = fileparts(options.session.filename);
    psdType = {'psdFFT','psdWelch','psdAR'};
    for i = 1:3
        if ~isempty(signals.(id).(type).aligned.psd.(psdType{i}))
            arOrder = '----'; segw = '----'; olw = '----'; window = '----';
            if i == 1
                filenameTxt = fullfile(path,[name,'_',type,...
                    '_infofreq_fft.txt']); 
                method = 'Fourier';
                window = auxWindow;
            elseif i == 2
                filenameTxt = fullfile(path,[name,'_',type,...
                    '_infofreq_welch.txt']); 
                method = 'Welch method';
                window = auxWindow;
                if options.session.psd.segments == length(...
                        signals.(id).(type).aligned.psd.(psdType{i}))
                    segw = [num2str(options.session.psd.segments),'\t1',...
                        ' segment of ',num2str(...
                        options.session.psd.segments),' samples'];
                    olw = '0\tno overlapping samples';
                elseif mod(length(...
                        signals.(id).(type).aligned.psd.(psdType{i})) - ...
                        options.session.psd.overlap,...
                        options.session.psd.segments - ...
                        options.session.psd.overlap) ~=0
                    segw = [num2str(options.session.psd.segments),'\t',...
                        num2str(ceil((length(...
                        signals.(id).(type).aligned.psd.(psdType{i})) - ...
                        options.session.psd.overlap) / ...
                        (options.session.psd.segments - ...
                        options.session.psd.overlap))),' segments, ',...
                        'last with ',num2str(mod(length(...
                        signals.(id).(type).aligned.psd.(psdType{i})) - ...
                        options.session.psd.overlap,...
                        options.session.psd.segments - ...
                        options.session.psd.overlap) + ...
                        options.session.psd.overlap),' samples'];
                    olw = [num2str(options.session.psd.overlap),'\t',...
                        num2str(round(10000*options.session.psd.overlap/...
                        options.session.psd.segments)/100),'%%'];
                else
                    segw = [num2str(options.session.psd.segments),'\t',...
                        num2str(round((length(...
                        signals.(id).(type).aligned.psd.(psdType{i})) - ...
                        options.session.psd.overlap) / ...
                        (options.session.psd.segments - ...
                        options.session.psd.overlap))),' segments'];
                    olw = [num2str(options.session.psd.overlap),'\t',...
                        num2str(round(10000*options.session.psd.overlap/...
                        options.session.psd.segments)/100),'%%'];
                end
            else
                filenameTxt = fullfile(path,[name '_' type ...
                    '_infofreq_ar.txt']);
                method = 'AR model';
                arOrder = num2str(options.session.psd.arOrder);
            end
            windowName = ['Save ',method,' PSD information to text file'];

            % set string to be written to file
            fileString=['\tTotal\tVLF\tLF\tHF\tLF/HF\na.a.\t',num2str(...
                options.session.psd.areas.(psdType{i}).total),'\t',...
                num2str(options.session.psd.areas.(psdType{i}).vlf),...
                '\t',num2str(options.session.psd.areas.(psdType{i}).lf),...
                '\t',num2str(options.session.psd.areas.(psdType{i}).hf),...
                '\t',num2str(options.session.psd.areas.(psdType{...
                i}).ratio),'\nr.a.\t100\t',num2str(...
                options.session.psd.areas.(psdType{i}).relVlf),...
                '\t',num2str(options.session.psd.areas.(psdType{...
                i}).relLf),'\t',num2str(options.session.psd.areas.(...
                psdType{i}).relHf),'\t',num2str(...
                options.session.psd.areas.(psdType{i}).ratio),...
                '\nn.a.\t1\t\t',num2str(options.session.psd.areas.(...
                psdType{i}).normLf),'\t',num2str(...
                options.session.psd.areas.(psdType{i}).normHf),'\t',...
                num2str(options.session.psd.areas.(psdType{...
                i}).ratio),'\n\nFrequency-Domain Analysis of ',varName,...
                '\nfs (Hz)\t',num2str(options.session.psd.fs),...
                '\nMethod\t',method,'\n# of Pts\t',num2str(...
                options.session.psd.N),'\nWindow\t',window,'\nWelch ',...
                'method samples per segment\t',segw,'\nWelch method ',...
                'overlapping samples\t',olw,'\nAR order\t',arOrder,...
                '\n\nLegends\nVLF\tVery low frequency (0-',num2str(...
                options.session.psd.vlf),' Hz)\nLF\tLow frequency (',...
                num2str(options.session.psd.vlf),'-',num2str(...
                options.session.psd.lf),' Hz)\nHF\tHigh frequency (',...
                num2str(options.session.psd.lf),'-',num2str(...
                options.session.psd.hf),' Hz)\na.a.\tabsolute area ',...
                unit,'\nr.a.\trelative area (%%)\nn.a.\tnormalized ',...
                'area (n.u.)\n'];

            [fileName,pathName,~] = uiputfile('*.txt',windowName,...
                filenameTxt);
            if (any(fileName~=0) || length(fileName)>1) && ...
                    (any(pathName ~=0) || length(pathName)>1)
                filename = fullfile(pathName,fileName);
                [fid, message] = fopen(filename,'w');
                if fid == -1
                    uiwait(errordlg(['Could not create file: ',message,...
                        '. Verify if the file is opened in another ',...
                        'program or try again with a different ',...
                        'filename.'],'TXT export error','modal'));
                else
                    fprintf(fid,fileString,'char');
                    fclose(fid);
                end
            end  
        end
    end    
end
end

function teCallback(scr,~,userOpt,pHandle,pSig,txAreas,tx,te,teMinP,teMaxP)
% set VLF, LF and HF upper limits, axes limits, # of points for fourier
% transform, AR model order and # of samples per segment and # of
% overlapping samples for Welch method

errStat = 0;
options = get(userOpt,'userData');
if ~isempty(options.session.psd.sigLen)
    A=str2double(get(scr,'string'));
    
    if ~isnan(A)
        % set boundries according to text edit tag
        switch get(scr,'tag')
            case 'vlf'
                loLim = 0; hiLim = options.session.psd.lf-0.01;
                varName = 'very low frequency limit';
            case 'lf'
                loLim = options.session.psd.vlf+0.01; 
                hiLim = options.session.psd.hf-0.01;
                varName = 'low frequency limit';
            case 'hf'
                loLim = options.session.psd.lf+0.01; 
                hiLim = options.session.psd.maxF;
                varName = 'high frequency limit';
            case 'minF'
                loLim = 0; hiLim = options.session.psd.maxF-0.05;
                varName = 'minimum frequency';
            case 'maxF'
                loLim = options.session.psd.minF+0.05; 
                hiLim = (options.session.psd.fs/2);
                varName = 'maximum frequency';
            case 'minP'
                loLim = 0; hiLim = options.session.psd.maxP/10;
                varName = 'minimum power';
            case 'maxP'
                loLim = options.session.psd.minP*10; hiLim = inf;
                varName = 'maximum power';
            case 'N'
                loLim = 32; hiLim = 2^18; A = round(A);
                varName = 'number of points';
            case 'arOrder'
                loLim = 1; hiLim = 150; A = round(A);
                varName = 'AR order';
            case 'segments'
                loLim = 1; hiLim = options.session.psd.sigLen;
                varName = 'number of samples per segment';
                A = round(A);
            case 'overlap'
                loLim = 0; hiLim = options.session.psd.segments - 1;
                varName = 'number of overlapping samples';
                A = round(A);
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
            % condition value according to text edit tag and set 
            % corresponding variables
            if strcmp(get(scr,'tag'),'N')
                value = 2.^ceil(log(value)/log(2));
            end
            options.session.psd.(get(scr,'tag')) = value;

            % adjust maximum overlapping samples value when number of 
            % samples per segment is updated
            if strcmp(get(scr,'tag'),'segments')
                if options.session.psd.overlap >= value
                    options.session.psd.overlap = value-1;
                    set(te,'string',num2str(options.session.psd.overlap));
                end
                if strcmp(get(scr,'tag'),'segments')
                    set(tx,'string',['(max: ',num2str(value-1),') ']);
                end
            end

            set(userOpt,'userData',options);
            set(scr,'string',num2str(value));

            % recalculate areas if the altered values affect the PSD
            if ismember(get(scr,'tag'),{'vlf','lf','hf','N','arOrder',...
                    'segments','overlap'})
                psdCalc(userOpt,pSig,teMinP,teMaxP);
                calcAreas(userOpt,pSig,txAreas);
                if ismember(get(scr,'tag'),{'vlf','lf'})
                    set(tx,'string',num2str(value));
                end
            end     
            
            if ismember(get(scr,'tag'),{'minF','maxF'})
                calcPSDlim(userOpt,pSig,teMinP,teMaxP);
            end
            
            psdPlot(pHandle,pSig,userOpt);
        end
    end
    set(scr,'string',num2str(options.session.psd.(get(scr,'tag'))));
end
end

function rbCallback(scr,~,userOpt,pHandle,pSig,txAreas,teMinP,teMaxP,...
    rb1,rb2,rb3,rb4)
% set window for fourier transform and plot scale

options = get(userOpt,'userData');
if strcmp(get(scr,'tag'),'scale')
    options.session.psd.rbScale = get(scr,'userData');
else
    options.session.psd.rbWindow = get(scr,'userData');
    set(rb3,'value',0);
    set(rb4,'value',0);
end
set(userOpt,'userData',options);

set(scr,'value',1);
set(rb1,'value',0);
set(rb2,'value',0);

if strcmp(get(scr,'tag'),'window')
    psdCalc(userOpt,pSig,teMinP,teMaxP);
    calcAreas(userOpt,pSig,txAreas);
else
    calcPSDlim(userOpt,pSig,teMinP,teMaxP);
end      
psdPlot(pHandle,pSig,userOpt);
end

function cbCallback(scr,~,userOpt,pHandle,pSig,txAreas,cb1,cb2,teMinP,...
    teMaxP)
% select methods to calculate PSD to be shown on plot

options = get(userOpt,'userData');
options.session.psd.cbSelection(get(scr,'userData')) = get(scr,'value');
set(userOpt,'userData',options);

if get(scr,'value')==0
    if get(cb1,'value')==0
        set(cb2,'enable','off');
    elseif get(cb2,'value')==0
        set(cb1,'enable','off');
    end
else
    set(cb1,'enable','on');
    set(cb2,'enable','on');
end

psdCalc(userOpt,pSig,teMinP,teMaxP);
psdPlot(pHandle,pSig,userOpt);
calcAreas(userOpt,pSig,txAreas);  
end

function cbFillCallback(scr,~,userOpt,pSig,pHandle)
% fill or not PSD areas on plot

options = get(userOpt,'userData');
options.session.psd.fill = get(scr,'value');
set(userOpt,'userData',options);
psdPlot(pHandle,pSig,userOpt);
end

function psdCalc(userOpt,pSig,teMinP,teMaxP)
options = get(userOpt,'userData');

if ~isempty(options.session.psd.sigLen)
    id = options.session.psd.sigSpec{1};
    type = options.session.psd.sigSpec{2};
    sig = get(pSig,'userData');
    signal = sig.(id).(type).aligned.data;
    
    % remove mean before performing PSD
    signal = signal-mean(signal);
    sigw = signal;
    
    % prepare window for each method
    switch options.session.psd.rbWindow
        case 0
            windowf = rectwin(options.session.psd.sigLen);
            windoww = rectwin(options.session.psd.segments);
%             sigw = signal;
        case 1
            windowf = bartlett(options.session.psd.sigLen);
            windoww = bartlett(options.session.psd.segments);
%             sigw = signal.*bartlett(options.session.psd.sigLen);
        case 2
            windowf = hamming(options.session.psd.sigLen);
            windoww = hamming(options.session.psd.segments);
%             sigw = signal.*hamming(options.session.psd.sigLen);
        case 3
            windowf = hanning(options.session.psd.sigLen);
            windoww = hanning(options.session.psd.segments);
%             sigw = signal.*hanning(options.session.psd.sigLen);
        case 4
            windowf = blackman(options.session.psd.sigLen);
            windoww = blackman(options.session.psd.segments);
%             sigw = signal.*blackman(options.session.psd.sigLen);  
    end
        
    % calculate PSD according to methods selected
    sig.(id).(type).aligned.psd = dataPkg.psdUnit;
    if options.session.psd.cbSelection(1)
        [sig.(id).(type).aligned.psd.psdFFT,...
            sig.(id).(type).aligned.psd.freq] = periodogram(signal,...
            windowf,options.session.psd.N,options.session.psd.fs);
    end
    if options.session.psd.cbSelection(2)
        [sig.(id).(type).aligned.psd.psdWelch,...
            sig.(id).(type).aligned.psd.freq] = pwelch(signal,windoww,...
            options.session.psd.overlap,options.session.psd.N,...
            options.session.psd.fs);
    end
    if options.session.psd.cbSelection(3)
        [sig.(id).(type).aligned.psd.psdAR,...
            sig.(id).(type).aligned.psd.freq] = pburg(sigw,...
            options.session.psd.arOrder,options.session.psd.N,...
            options.session.psd.fs);
    end 
    
    set(pSig,'userData',sig);
    set(userOpt,'userData',options);
    calcPSDlim(userOpt,pSig,teMinP,teMaxP);
end
end

function calcPSDlim(userOpt,pSig,teMinP,teMaxP)
options = get(userOpt,'userData');

if ~isempty(options.session.psd.sigLen)
    id = options.session.psd.sigSpec{1};
    type = options.session.psd.sigSpec{2};
    sig = get(pSig,'userData');
    
    % set frequency range to define min and max values
    loLim = find(sig.(id).(type).aligned.psd.freq >= ...
        options.session.psd.minF,1);
    hiLim = find(sig.(id).(type).aligned.psd.freq <= ...
        options.session.psd.maxF,1,'last');
    if loLim == 1, loLim = 2; end %DC removed
    
    maxP = -inf; minP = inf;
    psdVar = {'psdFFT','psdWelch','psdAR'};
    for i = 1:3
        if options.session.psd.cbSelection(i)
            maxP = max([maxP; ...
                sig.(id).(type).aligned.psd.(psdVar{i})(loLim:hiLim)]);
            minP = min([minP; ...
                sig.(id).(type).aligned.psd.(psdVar{i})(loLim:hiLim)]);
        end
    end
    
    % plot all PSDs according to selected methods
    if options.session.psd.rbScale == 0
        options.session.psd.minP = 0;
        options.session.psd.maxP = 1.02*maxP; 
    else
        options.session.psd.maxP = 10^ceil(log10(maxP)); 
        options.session.psd.minP = 10^floor(log10(minP));
    end
    
    set(userOpt,'userData',options);
    set(teMinP,'string',num2str(options.session.psd.minP));
    set(teMaxP,'string',num2str(options.session.psd.maxP));
end
end

function calcAreas(userOpt,pSig,txAreas)
% calculate PSD areas for all selected methods and all frequency bands

options = get(userOpt,'userData');
signals = get(pSig,'userData');

if ~isempty(options.session.psd.sigLen)
    id = options.session.psd.sigSpec{1};
    type = options.session.psd.sigSpec{2};
    freq = signals.(id).(type).aligned.psd.freq;
    N = length(freq);
    
    % adjust HF limit if its greater than the maximum frequency
    if options.session.psd.hf > freq(end)
        options.session.psd.hf = freq(end);
        if options.session.psd.lf > options.session.psd.hf
            options.session.psd.lf = freq(end-1);
            if options.session.psd.vlf > options.session.psd.lf
                options.session.psd.vlf=freq(end-2);
            end
        end
    end
    
    % finds band limit indexes
    indVlf = round(options.session.psd.vlf/freq(2))+1;
    indLf = round(options.session.psd.lf/freq(2))+1;
    indHf = round(options.session.psd.hf/freq(2))+1;
    if indHf > N, indHf = N; end
    
    % calculate areas between indexes for each selected method
    psdType = {'psdFFT','psdAR','psdWelch'};
    for i = 1:3
        if ~isempty(signals.(id).(type).aligned.psd.(psdType{i}))
            % total area: 0 to HF upper limit
            options.session.psd.areas.(psdType{i}).total = freq(2)*sum(...
                signals.(id).(type).aligned.psd.(psdType{i})(1:indHf-1));

            % VLF area: 0 to VLF upper limit
            options.session.psd.areas.(psdType{i}).vlf = freq(2)*sum(...
                signals.(id).(type).aligned.psd.(psdType{i})(1:indVlf-1));

            % LF area: VLF upper limit to LF upper limit
            options.session.psd.areas.(psdType{i}).lf = freq(2)*sum(...
                signals.(id).(type).aligned.psd.(psdType{i})(...
                indVlf:indLf-1));

            % HF area: LF upper limit to HF upper limit
            options.session.psd.areas.(psdType{i}).hf = freq(2)*sum(...
                signals.(id).(type).aligned.psd.(psdType{i})(...
                indLf:indHf-1));

            % relative areas (VLF, LF and HF) and LF/HF ratio
            options.session.psd.areas.(psdType{i}).relVlf = round((...
                options.session.psd.areas.(psdType{i}).vlf/...
                options.session.psd.areas.(psdType{i}).total)*100000)/1000;
            options.session.psd.areas.(psdType{i}).relLf = round((...
                options.session.psd.areas.(psdType{i}).lf/...
                options.session.psd.areas.(psdType{i}).total)*100000)/1000;
            options.session.psd.areas.(psdType{i}).relHf = round((...
                options.session.psd.areas.(psdType{i}).hf/...
                options.session.psd.areas.(psdType{i}).total)*100000)/1000;
            options.session.psd.areas.(psdType{i}).ratio = round((...
                options.session.psd.areas.(psdType{i}).lf/...
                options.session.psd.areas.(psdType{i}).hf)*10000)/10000;

            % normalized areas (LF and HF)
            options.session.psd.areas.(psdType{i}).normLf = ...
                100*options.session.psd.areas.(psdType{i}).lf / ...
                (options.session.psd.areas.(psdType{i}).lf + ...
                options.session.psd.areas.(psdType{i}).hf);
            options.session.psd.areas.(psdType{i}).normHf = ...
                100*options.session.psd.areas.(psdType{i}).hf / ...
                (options.session.psd.areas.(psdType{i}).lf + ...
                options.session.psd.areas.(psdType{i}).hf);
        end
    end
    set(userOpt,'userData',options);
    buildAreaString(userOpt,pSig,txAreas);
end
end

function buildAreaString(userOpt,pSig,txAreas)
% build string with areas of frequency bands to display on GUI

options = get(userOpt,'userData');
if ~isempty(options.session.psd.sigLen)
    signals = get(pSig,'userData');
    id = options.session.psd.sigSpec{1};
    type = options.session.psd.sigSpec{2};
    
    % set labels and units according to data type
    if strcmp(id,'bp')
        sig = [' ',upper(type),'s'];
        unit = ' mmHg';  
    elseif strcmp(id,'rsp')
        sig = ' ILVs';
        unit = ' L';
    else
        if strcmp(signals.(id).(type).aligned.specs.type,'rri')
            sig = ' R-R intervals';
            unit = ' ms';
        else
            sig=' HRs';
            unit = ' bpm';
        end
    end

    % build string for each method
    psdType = {'psdFFT','psdAR','psdWelch'};
    areaString = struct;
    for i = 1:3
        if ~isempty(signals.(id).(type).aligned.psd.(psdType{i}))
            areaString.(psdType{i}) = sprintf(['Absolute Areas\n\nVLF:',...
                ' ',num2str(options.session.psd.areas.(psdType{i}).vlf),...
                unit,'²\nLF:  ',num2str(...
                options.session.psd.areas.(psdType{i}).lf),unit,...
                '²\nHF:  ',num2str(...
                options.session.psd.areas.(psdType{i}).hf),unit,'²\n\n',...
                'Total: ',num2str(...
                options.session.psd.areas.(psdType{i}).total),unit,...
                '²\n\nRelative Areas\n\nVLF:  ',num2str(...
                options.session.psd.areas.(psdType{i}).relVlf),...
                ' %%\nLF:   ',num2str(...
                options.session.psd.areas.(psdType{i}).relLf),...
                ' %%\nHF:   ',num2str(...
                options.session.psd.areas.(psdType{i}).relHf),' %%\n\n',...
                'Normalized Areas\n\nLF:  ',num2str(...
                options.session.psd.areas.(psdType{i}).normLf),...
                ' n.u.\nHF:  ',num2str(...
                options.session.psd.areas.(psdType{i}).normHf),...
                ' n.u.\n\nLF/HF Ratio: ',num2str(...
                options.session.psd.areas.(psdType{i}).ratio),'\n\n',...
                num2str(options.session.psd.sigLen),sig]);
            set(txAreas.(psdType{i}),'string',areaString.(psdType{i}));
        else
            areaString.(psdType{i}) = sprintf(['Absolute Areas\n\nVLF:',...
                ' ----\nLF:  ----\nHF:  ----\n\nTotal: ----\n\n',...
                'Relative Areas\n\nVLF:  ---- %%\nLF:   ---- %%\nHF:  ',...
                ' ---- %%\n\nNormalized Areas\n\nLF:  ---- n.u.\nHF:  ',...
                '---- n.u.\n\nLF/HF Ratio: ----\n\n---- ',sig]);
            set(txAreas.(psdType{i}),'string',areaString.(psdType{i}));
        end
    end  
end
end

function tabChange(scr,~,tbFFT,pnFFT,tbAR,pnAR,tbWelch,pnWelch,userOpt,...
    pSig,pHandle)

if get(scr,'value') == 1
    set(scr,'backgroundcolor',[1 1 1]);
    options = get(userOpt,'userData');
    switch get(scr,'tag')
        case 'fft'
            options.session.nav.psd = 0;
            set(userOpt,'userData',options);
            set(tbAR,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnAR,'visible','off');
            set(tbWelch,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnWelch,'visible','off');
             set(pnFFT,'visible','on');
        case 'ar'
            options.session.nav.psd = 1;
            set(userOpt,'userData',options);
            set(tbFFT,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnFFT,'visible','off');
            set(tbWelch,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnWelch,'visible','off');
            set(pnAR,'visible','on');
        case 'welch'
            options.session.nav.psd = 2;
            set(userOpt,'userData',options);
            set(tbFFT,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnFFT,'visible','off');
            set(tbAR,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnAR,'visible','off');
            set(pnWelch,'visible','on');
    end
    psdPlot(pHandle,pSig,userOpt);
else
    set(scr,'value',1);
end
end

function value = checkLim(userOpt,value,tag)

options = get(userOpt,'userData');
switch tag
    case 'vlf'
        loLim = 0; hiLim = options.session.psd.lf;
    case 'lf'
        loLim = options.session.psd.vlf;
        hiLim = options.session.psd.hf;
    case 'hf'
        loLim = options.session.psd.lf;
        hiLim = options.session.psd.maxF;
    case 'minF'
        loLim = 0; hiLim = options.session.psd.maxF;
    case 'maxF'
        loLim = options.session.psd.minF;
        hiLim = options.session.psd.fs/2;
    case 'minP'
        loLim = 0; hiLim = options.session.psd.maxP;
    case 'maxP'
        loLim = options.session.psd.minP; hiLim = inf;
    case 'N'
        loLim = 32; hiLim = 2^18; value = round(value);
    case 'arOrder'
        loLim = 1; hiLim = 150; value = round(value);
end

if value < loLim, value = loLim; end
if value > hiLim, value = hiLim; end
end

function saveConfig(userOpt)
% save session configurations for next session

options = get(userOpt,'userData');
options.psd.vlf = options.session.psd.vlf;
options.psd.lf = options.session.psd.lf;
options.psd.hf = options.session.psd.hf;
options.psd.minP = options.session.psd.minP;
options.psd.maxP = options.session.psd.maxP;
options.psd.minF = options.session.psd.minF;
options.psd.maxF = options.session.psd.maxF;
options.psd.arOrder = options.session.psd.arOrder;
options.psd.N = options.session.psd.N;
options.psd.cbSelection = options.session.psd.cbSelection;
options.psd.rbWindow = options.session.psd.rbWindow;
options.psd.rbScale = options.session.psd.rbScale;
options.psd.segments = options.session.psd.segments;
options.psd.overlap = options.session.psd.overlap;
options.psd.fill = options.session.psd.fill;
set(userOpt,'userData',options);
end