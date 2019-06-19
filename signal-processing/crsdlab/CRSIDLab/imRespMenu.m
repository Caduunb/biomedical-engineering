function imRespMenu(pnImResp,pFile,pMod,userOpt)
% imRespMenu - CRSIDLab
%   Menu for generating or viewing the impulse response, or responses if
%   there are multiple inputs, of the models generated in identMenu for
%   the systems created in systemMenu. Quantitative indicators are
%   extracted from the impulse response, such as the dynamic gain (DG) in
%   low and high frequency bands, the impulse response magnitude (IRM), the
%   response latency and its time-to-peak. These indicators may be exported
%   to a text file.
%
% Original Matlab code: Luisa Santiago C. B. da Silva, April 2017.
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Data visualization (model output or impulse response)
%

pHandle = struct;

uicontrol('parent',pnImResp,'style','text','string','Select system:',...
    'hor','left','units','normalized','position',[.032 .93 .7 .03]);
puVar = uicontrol('parent',pnImResp,'style','popupmenu','tag','ecg',...
    'string','Indicate system model','value',1,'userData',1,'units',...
    'normalized','position',[.13 .93 .649 .04],'backgroundColor',[1 1 1]);

pHandle.single = axes('parent',pnImResp,'Units','normalized','Position',...
    [.057 .14 .675 .74],'nextPlot','replaceChildren','visible','on');
pHandle.double1 = axes('parent',pnImResp,'Units','normalized',...
    'Position',[.057 .53 .675 .35],'nextPlot','replaceChildren',...
    'visible','off');
pHandle.double2 = axes('parent',pnImResp,'Units','normalized',...
    'Position',[.057 .14 .675 .35],'nextPlot','replaceChildren',...
    'visible','off');

uicontrol('parent',pnImResp,'style','text','hor','right','string',...
    'Time (seconds) ','fontSize',10,'units','normalized','position',...
    [.635 .06 .1 .035]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Buttons (generate/view impulse response, save impulse response)
%

pnSave = uipanel('parent',pnImResp,'Units','normalized','Position',...
    [.753 .06 .225 .08]);

% impulse response
pbImResp = uicontrol('parent',pnSave,'Style','push','String',['Impulse',...
    ' Response'],'Units','Normalized','Position',[.05 .15 .425 .7]);

% save
uicontrol('parent',pnSave,'Style','push','String','SAVE','CallBack',...
    {@saveImResp,userOpt,pFile,pMod},'Units','Normalized',...
    'Position',[.525 .15 .425 .7]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Impulse Response information
%

pnInfo = uipanel('parent',pnImResp,'Units','Normalized','Position',...
    [.753 .14 .225 .74]);

txInfo = uicontrol('parent',pnInfo,'Style','text','hor','left','Units',...
    'normalized','position',[.05 .13 .9 .838]);

uicontrol('parent',pnInfo,'style','push','String','Export to TXT',...
    'CallBack',{@exportTxt,userOpt,pMod,txInfo},'Units','normalized',...
    'position',[.05 .03 .425 .07]);

uicontrol('parent',pnInfo,'style','push','String','View DG Plot',...
    'CallBack',{@showDG,userOpt,pMod},'Units','normalized','position',...
    [.525 .03 .425 .07]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Set final callbacks and call opening function
%

set(pbImResp,'callback',{@impulseResponse,userOpt,pMod,txInfo,pHandle});

set(puVar,'callback',{@changeMod,userOpt,pFile,pMod,txInfo,pHandle});

openFnc(userOpt,pFile,pMod,puVar,txInfo,pHandle);
end

function plotFcn(pHandle,userOpt,pMod)
% adjust handles visibility and plot all selected signals

options = get(userOpt,'userData');
model = get(pMod,'userData');
if options.session.imresp.modOpen
    if (options.session.imresp.viewImresp && ...
            length(model.imResp.impulse) == 2) ...
            || (~options.session.imresp.viewImresp && ...
        ~isempty(model.simOutVal))
        set(pHandle.single,'visible','off');
        set(get(pHandle.single,'children'),'visible','off');

        set(pHandle.double1,'visible','on');
        set(get(pHandle.double1,'children'),'visible','on');
        set(pHandle.double2,'visible','on');
        set(get(pHandle.double2,'children'),'visible','on');

        if ~options.session.imresp.viewImresp
            set(pHandle.double1,'tag','est');
            set(pHandle.double2,'tag','val');
            imrespPlotModel(pHandle.double1,pMod,1);
            imrespPlotModel(pHandle.double2,pMod,1);
        else
            set(pHandle.double1,'tag','in1');
            set(pHandle.double2,'tag','in2');
            imrespPlot(pHandle.double1,pMod);
            imrespPlot(pHandle.double2,pMod);
        end
    else
        set(pHandle.double1,'visible','off');
        set(get(pHandle.double1,'children'),'visible','off');
        set(pHandle.double2,'visible','off');
        set(get(pHandle.double2,'children'),'visible','off');

        set(pHandle.single,'visible','on');
        set(get(pHandle.single,'children'),'visible','on');

        if options.session.imresp.modOpen
            if ~options.session.imresp.viewImresp
                set(pHandle.single,'tag','est');
                imrespPlotModel(pHandle.single,pMod,0);
            else
                set(pHandle.single,'tag','in1');
                imrespPlot(pHandle.single,pMod);
            end
        end
    end
else
    set(pHandle.double1,'visible','off');
    set(get(pHandle.double1,'children'),'visible','off');
    set(pHandle.double2,'visible','off');
    set(get(pHandle.double2,'children'),'visible','off');
    
    set(pHandle.single,'visible','on');
    ylabel(pHandle.single,'');
    set(get(pHandle.single,'children'),'visible','off');
end
end

function openFnc(userOpt,pFile,pMod,puVar,txInfo,pHandle)
% adjust initial values of objects

options = get(userOpt,'userData');
patient = get(pFile,'userData');

% string for model selection popupmenu from available patient data
prevSys = fieldnames(patient.sys);
noModels = 0;
for i = 1:length(prevSys)
    prevMod = fieldnames(patient.sys.(prevSys{i}).models);
    noModels = noModels + length(prevMod);
end
modKey = cell(noModels,2); stringPU = cell(noModels+1,1);
stringPU{1} = 'Indicate system model'; count = 1;
for i = 1:length(prevSys)
    prevMod = fieldnames(patient.sys.(prevSys{i}).models);
    for j = 1:length(prevMod)
        count = count+1;
        stringPU{count} = [patient.sys.(prevSys{i}).data.Note,' - ',...
            patient.sys.(prevSys{i}).models.(prevMod{j}).Notes];
        modKey{count-1,1} = prevSys{i};
        modKey{count-1,2} = prevMod{j};
    end
end
stringPU = stringPU(~cellfun(@isempty,stringPU));

if length(stringPU) <= 1
    stringPU{2} = 'No models available';
end

% adjust selection value if the variables list has changed
if ~isequal(options.session.imresp.modString,stringPU)
    if ~isempty(options.session.imresp.modString)
        if ismember(options.session.imresp.modString{...
                options.session.imresp.modValue},stringPU)
            options.session.imresp.modValue = find(ismember(stringPU,...
                options.session.imresp.modString{...
                options.session.imresp.modValue}));
        else
            options.session.imresp.modValue = 1;
        end
    end
    options.session.imresp.modString = stringPU;
    options.session.imresp.modKey = modKey;
end

set(puVar,'string',options.session.imresp.modString);
set(puVar,'value',options.session.imresp.modValue);
set(puVar,'userData',options.session.imresp.modValue);

% open data and setup options that depend on the data
set(userOpt,'userData',options);
setup(userOpt,pFile,pMod,txInfo);
options = get(userOpt,'userData');

% setup options that don't depend on the data
set(userOpt,'userData',options);
plotFcn(pHandle,userOpt,pMod);
end

function setup(userOpt,pFile,pMod,txInfo)
% open data and setup options that depend on the data

options = get(userOpt,'userData');

% identify selected data
modValue = options.session.imresp.modValue-1;
auxMod = options.session.imresp.modString{modValue+1};

% open data and setup options
if ~strcmp(auxMod,'Indicate system model') && ...
        ~strcmp(auxMod,'No systems or models available')
    patient = get(pFile,'userData');
    
    modKey = options.session.imresp.modKey;
    model = patient.sys.(modKey{modValue,1}).models.(modKey{modValue,2});
    options.session.imresp.modOpen = 1;
    
    set(pFile,'userData',patient);
    set(pMod,'userData',model);
    
    if isempty(model.imResp.time)
        options.session.imresp.imrespGen = 0;
    else
        options.session.imresp.imrespGen = 1;
    end
else
    options.session.imresp.imrespGen = 0;
    options.session.imresp.modOpen = 0;
end
options.session.imresp.viewImresp = 0;
options.session.imresp.saved = 0;

set(userOpt,'userData',options);
buildInfoString(userOpt,pMod,txInfo);
end

function changeMod(scr,~,userOpt,pFile,pMod,txInfo,pHandle)
% change model selected to generate/view impulse response

errStat = 0;
oldValue = get(scr,'userData');
newValue = get(scr,'value');
if oldValue ~= newValue
    options = get(userOpt,'userData');
    
    saved = 0;
    if options.session.imresp.modOpen
        patient = get(pFile,'userData');
        modKey = options.session.imresp.modKey;
        modValue = options.session.imresp.modValue-1;
        if ~isempty(patient.sys.(modKey{modValue,1}).models.(modKey{...
                modValue,2}).imResp.time)
            saved = 1;
        end
    end
    if ~saved && ~options.session.imresp.saved && ...
            options.session.imresp.imrespGen
        [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
            'changeModImRespPref','Change model',sprintf(['Warning!',...
            '\nThe current impulse response has not been saved.\nAre ',...
            'you sure you wish to proceed?']),{'Yes','No'},...
            'DefaultButton','No');
        if strcmp(selButton,'no') && dlgShow
            errStat = 1;
        end  
    end
    if ~errStat
        options.session.imresp.modValue = newValue;
        set(scr,'userData',newValue);
        set(userOpt,'userData',options);

        setup(userOpt,pFile,pMod,txInfo);
        plotFcn(pHandle,userOpt,pMod);
    else
        set(scr,'value',oldValue);
    end
end
end

function saveImResp(~,~,userOpt,pFile,pMod)
% save impulse response

options = get(userOpt,'userData');
if options.session.imresp.imrespGen
    
    model = get(pMod,'userData');
    patient = get(pFile,'userData');
    
    % verify if the impulse response is already saved
    modKey = options.session.imresp.modKey;
    modValue = options.session.imresp.modValue-1;
    if ~isempty(patient.sys.(modKey{modValue,1}).models.(modKey{...
            modValue,2}).imResp.time)
        uiwait(errordlg('Impulse response already saved!',...
            'Impulse response already saved','modal'));
    else
        filename = options.session.filename;
        patient.sys.(modKey{modValue,1}).models.(modKey{...
            modValue,2}).imResp = model.imResp;
        set(pFile,'userData',patient);
        save(filename,'patient');
        options.session.imresp.saved = 1;
        set(userOpt,'userData',options);
        saveConfig(userOpt);
        uiwait(msgbox(['The impulse response has been saved ',...
            'successfully.'],'Impulse response saved','modal'));
    end  
end
end

function impulseResponse(~,~,userOpt,pMod,txInfo,pHandle)
% generate/view impulse response or switch back to model output

options = get(userOpt,'userData');
model = get(pMod,'userData');

if options.session.imresp.modOpen && ~options.session.imresp.viewImresp
    if ~options.session.imresp.imrespGen
        options.session.imresp.imrespGen = 1;
        set(userOpt,'userData',options);
        if strcmp(model.Type,'AR') || strcmp(model.Type,'ARX')
            imrespArx(userOpt,pMod,txInfo);
        else
            imrespObf(userOpt,pMod,txInfo);
        end
        options = get(userOpt,'userData');
    end
    options.session.imresp.viewImresp = 1;
    set(userOpt,'userData',options);
    plotFcn(pHandle,userOpt,pMod);
end
end

function imrespArx(userOpt,pMod,txInfo)
% ARX model impulse response

%get data from model
model = get(pMod,'userData');
nn = model.Order;
nn = [nn zeros(1,3-length(nn))];
nk = model.Delay;
fs = 1/model.Ts;
theta = model.Theta(:)';

%build idpoly object to get impulse response
m = idpoly; 
m.A  = [1 theta(1:nn(1))];
if nn(2) ~= 0 && nn(3) ~= 0
    B = cell(1,2);
    B{1,1} = theta(nn(1)+1:nn(1)+nn(2));
    B{1,2} = theta(nn(1)+nn(2)+1:end);
    m.B = B;
else
    if nn(2) ~= 0
            m.B = theta(nn(1)+1:nn(1)+nn(2));
    elseif nn(3) ~= 0
            m.B = theta(nn(1)+nn(2)+1:nn(1)+nn(2)+nn(3));
    else
        m.B = [];
    end
end
if nn(2) ~= 0 || nn(3) ~= 0
    if nn(2) == 0
        m.InputDelay = nk(2);
    elseif nn(3) == 0
        m.InputDelay = nk(1);
    else
        m.InputDelay = nk;
    end
end
m.Ts = 1; %impulse response from impulse with amplitude 1 (1/Ts)

%impulse response
[im,t]=impulse(m);

%add 4 samples before responses (easier to see)
t = (1/fs)*[t(1)-(4:-1:1)'; t]; %scale by 1/fs
im = [zeros(4,1,size(im,3)); im];

%build outputs
if length(model.Order) <= 2
    model.imResp.impulse = cell(1);
    model.imResp.impulse{1} = im(:,:,1);
else
    model.imResp.impulse = cell(2,1);
    model.imResp.impulse{1} = im(:,:,1);
    model.imResp.impulse{2} = im(:,:,2);
end
model.imResp.time = t;

set(pMod,'userData',model);
imRespIndicators(pMod,userOpt,txInfo);
end

function imrespObf(userOpt,pMod,txInfo)
% Orthogonal basis function model impulse response

% get data from model
model = get(pMod,'userData');
mtd = model.Type;
nn = model.Order;
nk = model.Delay;
fs = 1/model.Ts;
theta = model.Theta(:);
M = model.SysMem;
p = model.Pole;
gen = model.GenOrd;
if length(nk) == 1, nk = [nk 0]; end
if length(nn) == 2, nn = [nn 0]; end
if length(gen) == 1, gen = [gen 0]; end

% offset due to delays, so responses are on te same time axis
off = max(nk)-min(nk);

% impulse
in = zeros(M+off,1); in(1)=1;

% filter data according to model (Larguerre or Meixner)
if strcmp(mtd,'LBF')
    if nn(2) ~=0, in1 = laguerreFilt(in,nn(2),p,M); end
    if nn(3) ~=0, in2 = laguerreFilt(in,nn(3),p,M); end
else
    if nn(2) ~=0, in1 = meixnerFilt(in,nn(2),p,gen(1),M); end
    if nn(3) ~=0, in2 = meixnerFilt(in,nn(3),p,gen(2),M); end
end

% generate impulse response for valid inputs
if nn(2) ~=0, im1 = in1*theta(nn(1)+1:nn(1)+nn(2));
else im1 = zeros(M+off,1);
end
if nn(3) ~=0, im2 = in2*theta(nn(1)+nn(2)+1:nn(1)+nn(2)+nn(3)); 
else im2 = zeros(M+off,1);
end

% adjust time axis offset
if nk(1)<nk(2)
    if nk(1)>0
        im1 = [zeros(4+nk(1),1); im1];
        im2 = [zeros(4+nk(1)+off,1); im2(1:end-off)];
    else
        im1 = [zeros(4,1); im1];
        im2 = [zeros(4+off,1); im2(1:end-off)];
    end
else 
    if nk(2)>0
        im2 = [zeros(4+nk(2),1); im2];
        im1 = [zeros(4+nk(2)+off,1); im1(1:end-off)];
    else
        im2 = [zeros(4,1); im2];
        im1 = [zeros(4+off,1); im1(1:end-off)];
    end
end

if min(nk)<0
    t = (-4+min(nk))/fs:1/fs:(M-1+min(nk)+off)/fs;
else
    t = -4/fs:1/fs:(M-1+off+min(nk))/fs; %sample 5 => t = 0
end
    
%build outputs
if length(model.Order) == 2
    model.imResp.impulse = cell(1);
    model.imResp.impulse{1} = im1;
else
    model.imResp.impulse = cell(2,1);
    if nn(2) ~= 0, model.imResp.impulse{1} = im1;
    else model.imResp.impulse{1} = [];
    end
    if all(nn(2:3) ~= 0), model.imResp.impulse{2} = im2;
    elseif nn(3) == 0, model.imResp.impulse{2} = im1;
    else model.imResp.impulse{2} = [];
    end
end
model.imResp.time = t;

set(pMod,'userData',model);
imRespIndicators(pMod,userOpt,txInfo);
end

function imRespIndicators(pMod,userOpt,txInfo)
% calculate quantitative indicators from impulse response

options = get(userOpt,'userData');
model = get(pMod,'userData');
freq = options.session.imresp.freq;

im = model.imResp.impulse;
t = model.imResp.time;
nk = model.Delay;
fs = 1/model.Ts;

irm2 = []; dg2tot = []; dg2lf = []; dg2hf = [];
tDel2 = []; sampDel2 = []; tPeak2 = []; sampPeak2 = [];
   
% response latency (in seconds and samples)
tDel1 = t(find(im{1}~=0,1)-1);
sampDel1 = tDel1*fs;

% IRM
valMax1 = max(im{1});
valMin1 = min(im{1});
irm1 = valMax1 - valMin1;

% time-to-peak (in seconds and samples)
if valMax1 ~= 0
    a = find(im{1}==valMax1,1);
else
    a = inf;
end
if valMin1 ~= 0
    b = find(im{1}==valMin1,1);
else
    b = inf;
end
if valMin1 ~= 0 || valMax1 ~= 0
    if a < b
        sampPeak1 = a-sampDel1-5;
    else
        sampPeak1 = b-sampDel1-5;
    end
    if min(nk)<0
        sampPeak1 = sampPeak1+min(nk);
    end
else
    sampPeak1 = 0;
end
tPeak1 = sampPeak1/fs;

% dynamic gain
dg1 = identDG(im{1},t,freq(1),freq(2),freq(3));

if length(im) == 2
    % response latency (in samples and seconds)
    tDel2 = t(find(im{2}~=0,1)-1);
    sampDel2 = tDel2*fs;

    % IRM
    valMax2 = max(im{2});
    valMin2 = min(im{2});
    irm2 = valMax2 - valMin2;

    % time-to-peak (in samples and seconds)
    if valMax2 ~= 0
        a = find(im{2}==valMax2,1);
    else
        a = inf;
    end
    if valMin2 ~= 0
        b = find(im{2}==valMin2,1);
    else
        b = inf;
    end
    if valMin2 ~= 0 || valMax2 ~= 0
        if a < b 
            sampPeak2 = a-sampDel2-5;
        else
            sampPeak2 = b-sampDel2-5;  
        end
        if ~isempty(nk)
            if min(nk)<0
                sampPeak2 = sampPeak2+min(nk);
            end
        end
    else
        sampPeak2 = 0;
    end
    tPeak2 = sampPeak2/fs;

    % dynamic gain
    dg2 = identDG(im{2},t,freq(1),freq(2),freq(3));
    dg2tot = dg2(1); dg2lf = dg2(2); dg2hf = dg2(3);
end

% set information to model object
model.imResp.indicators.irm = [irm1 irm2];
model.imResp.indicators.dg.total = [dg1(1) dg2tot];
model.imResp.indicators.dg.lf = [dg1(2) dg2lf];
model.imResp.indicators.dg.hf = [dg1(3) dg2hf];
model.imResp.indicators.latency.time = [tDel1 tDel2];
model.imResp.indicators.latency.samp = [sampDel1 sampDel2];
model.imResp.indicators.ttp.time = [tPeak1 tPeak2];
model.imResp.indicators.ttp.samp = [sampPeak1 sampPeak2];
    
set(pMod,'userData',model);
buildInfoString(userOpt,pMod,txInfo);
end

function buildInfoString(userOpt,pMod,txInfo)
% build string to display quantitative indicators

model = get(pMod,'userData');
options = get(userOpt,'userData');
freq = options.session.imresp.freq;

% generate labels and string indicators for empty tab
outName = '----'; outUn = '----'; in1Name = 'Input 1'; in1Un = '----';
in2Name = 'Input 2'; in2Un = '----';
irm1 = '----'; dgTot1 = '----'; dgLf1 = '----'; dgHf1 = '----';
tDel1 = '----'; sampDel1 = '----'; tPeak1 = '----'; sampPeak1 = '----';
irm2 = '----'; dgTot2 = '----'; dgLf2 = '----'; dgHf2 = '----';
tDel2 = '----'; sampDel2 = '----'; tPeak2 = '----'; sampPeak2 = '----';

% generate labels for output and first input
if options.session.imresp.modOpen
    outName = model.OutputName{:}; outUn = model.OutputUnit{:};
    if length(model.InputName) >= 1
        in1Name = model.InputName{1}; in1Un = model.InputUnit{1};
        if length(model.InputName) == 2
            in2Name = model.InputName{2}; in2Un = model.InputUnit{2};
        end
    else
        in1Name = model.OutputName{:}; in1Un = model.OutputUnit{:};
    end
end

% prepare first input indicators for string
if options.session.imresp.imrespGen
    irm1 = num2str(model.imResp.indicators.irm(1)); 
    dgTot1 = num2str(model.imResp.indicators.dg.total(1)); 
    dgLf1 = num2str(model.imResp.indicators.dg.lf(1)); 
    dgHf1 = num2str(model.imResp.indicators.dg.hf(1));
    tDel1 =  num2str(model.imResp.indicators.latency.time(1)); 
    sampDel1 = num2str(model.imResp.indicators.latency.samp(1));
    tPeak1 = num2str(model.imResp.indicators.ttp.time(1)); 
    sampPeak1 = num2str(model.imResp.indicators.ttp.samp(1));
    if length(model.InputName) == 2
        if ~isempty(model.imResp.impulse{1})
            irm2 = num2str(model.imResp.indicators.irm(2));
            dgTot2 = num2str(model.imResp.indicators.dg.total(2)); 
            dgLf2 = num2str(model.imResp.indicators.dg.lf(2)); 
            dgHf2 = num2str(model.imResp.indicators.dg.hf(2));
            tDel2 = num2str(model.imResp.indicators.latency.time(2));
            sampDel2 = num2str(model.imResp.indicators.latency.samp(2));
            tPeak2 = num2str(model.imResp.indicators.ttp.time(2));
            sampPeak2 = num2str(model.imResp.indicators.ttp.samp(2));
        end
    end
end

% information string to be displayed on screen
infoString = sprintf(['Impulse response information:\n\nImpulse ',...
    'Response Magnitude (IRM):\n',in1Name,': ',irm1,' ',outUn,'/',in1Un,...
    '\n',in2Name,': ',irm2,' ',outUn,'/',in2Un,'\n\nDynamic Gain (DG) ',...
    '- ',num2str(freq(1)),' to ',num2str(freq(3)),' Hz:\n',in1Name,': ',...
    dgTot1,' ',outUn,'/',in1Un,'\n',in2Name,': ',dgTot2,' ',outUn,'/',...
    in2Un,'\n\nDG - LF (',num2str(freq(1)),' to ',num2str(freq(2)),...
    ' Hz):\n',in1Name,': ',dgLf1,' ',outUn,'/',in1Un,'\n',in2Name,': ',...
    dgLf2,' ',outUn,'/',in2Un,'\n\nDG - HF',' (',num2str(freq(2)),...
    ' to ',num2str(freq(3)),' Hz):\n',in1Name,': ',dgHf1,' ',outUn,'/',...
    in1Un,'\n',in2Name,': ',dgHf2,' ',outUn,'/',in2Un,'\n\nResponse ',...
    'latency:\n',in1Name,': ',tDel1,' s (',sampDel1,' samples)\n',...
    in2Name,': ',tDel2,' s (',sampDel2,' samples)\n\nTime-to-peak:\n',...
    in1Name,': ',tPeak1,' s (',sampPeak1,' samples)\n',in2Name,': ',...
    tPeak2,' s (',sampPeak2,' samples)']);
set(txInfo,'string',infoString);

% information string to be written to file
if options.session.imresp.modOpen
    info = [model.Type,' model impulse response information:\n\nOutput',...
        ' data:\t',outName,'\t',outUn,'\nInput 1 data:\t',in1Name,'\t',...
        in1Un,'\nInput 2 data:\t',in2Name,'\t',in2Un,'\n\nImpulse ',...
        'Response Magnitude (IRM):\n',in1Name,'\t',irm1,'\t',outUn,'/',...
        in1Un,'\n',in2Name,'\t',irm2,'\t',outUn,'/',in2Un,'\n\nDynamic',...
        ' Gain (DG) - ',num2str(freq(1)),' to ',num2str(freq(3)),...
        ' Hz\n',in1Name,'\t',dgTot1,'\t',outUn,'/',in1Un,'\n',in2Name,...
        '\t',dgTot2,'\t',outUn,'/',in2Un,'\n\nDG - LF (',num2str(...
        freq(1)),' to ',num2str(freq(2)),' Hz):\n',in1Name,'\t',dgLf1,...
        '\t',outUn,'/',in1Un,'\n',in2Name,'\t',dgLf2,'\t',outUn,'/',...
        in2Un,'\n\nDG - HF (',num2str(freq(2)),' to ',num2str(freq(3)),...
        ' Hz):\n',in1Name,'\t',dgHf1,'\t',outUn,'/',in1Un,'\n',in2Name,...
        '\t',dgHf2,'\t',outUn,'/',in2Un,'\n\nResponse latency:\n',...
        in1Name,'\t',tDel1,'\ts\t',sampDel1,'\tsamples\n',in2Name,'\t',...
        tDel2,'\ts\t',sampDel2,'\tsamples\n\nTime-to-peak:\n',in1Name,...
        '\t',tPeak1,'\ts\t',sampPeak1,'\tsamples\n',in2Name,'\t',tPeak2,...
        '\ts\t',sampPeak2,'\tsamples'];
    set(txInfo,'userData',info);
end
end

function M = meixnerFilt(in,n,p,gen,sysMem)
% meixnerFilt Filters data using Meixner-like filter
%
%   M = meixnerFilt(in,n,pole,gen,sysMem) applies the Meixner-like filter 
%   of pole position given by 'p' (0<=p<=1), generalization order given by
%   'gen' and filter length (system memory) given by 'sysMem' to data 'in'. 
%   The data in must be uniformly sampled for the filter to be applied. 
%   Returns matrix M with 'n' columns, containing the data filtered by 'n'
%   Meixner-like filters with orders ranging from 0 to n-1.

% no of Laguerre functions needed to generate 'n' Meixner-like functions
j = max(gen)+n+1;

% Laguerre filter
lag = laguerreFilt(in,j,p,sysMem)';

% transformation from Laguerre to Meixner
U = eye(j-1)*p;
U = [zeros(j-1,1) U];
U = [U; zeros(1,j)];
U = U+eye(j);
U_aux = U;

fSolve = @idpack.mldividecov;
M = zeros(length(in),n,(max(gen)-min(gen)+1));
    
if min(gen)~=0
    U = U^min(gen);
    L = chol(U*U','lower');
    A = fSolve(L,U);
    M(:,:,1) = (A(1:n,:)*lag)';
else
    U = U^0;
    M(:,:,1) = lag(1:n,:)';
end
for i = min(gen)+1:max(gen)
    U = U*U_aux;
    L = chol(U*U','lower');
    A = fSolve(L,U);
    M(:,:,i-min(gen)+1) = (A(1:n,:)*lag)';
end
end

function L = laguerreFilt(in,n,p,sysMem)
% laguerreFilt Filters data using Laguerre filter
%
%   L = laguerreFilt(in,n,p,sysMem) applies the Laguerre filter of pole 
%   position given by 'p' (0<=p<=1) and filter length (system memory) given 
%   by 'sysMem' to data 'in'. The data in must be uniformly sampled for the
%   filter to be applied. Returns matrix L with 'n' columns, containing the
%   data filtered by 'n' Laguerre filters with orders ranging from 0 to
%   n-1.

z = tf('z',1); %allows writing TF as an expression of the variable 'z'
               %without specifying numerator and denominator separately

L = zeros(n,length(in));
imp = zeros(1,sysMem+1);
imp(1) = 1;

for j = 0 : n-1
    if j == 0 %order n=0
        LF = sqrt(1-p^2)*z/(z-p);
    else
        LF = LF*(1-p*z)/(z-p);
    end
    [B,A]=tfdata(LF);
    B = B{1,1};
    A = A{1,1};
    L_aux = filter(B,A,imp);
    L(j+1,:) = filter(L_aux,1,in);
end
L = L';

% This implementation is based on the paper "Use of Meixner Functions in 
% Estimation of Volterra Kernels of Nonlinear Systems With Delay" by Musa
% H. Asyali and Mikko Juusola, published on IEE Transactions on Biomedical
% Engineering vol. 52, no. 2, February 2005.
end

function [dg,freq,absIR] = identDG(im,t,f1,f2,f3)
% identDG Calculates dynamic gain
%
%  [dg,freq,absIR] = identDG(im,t,f1,f2) calculates single-sided spectrum
%  'absIR' and frequency axis 'freq' from impulse response 'im' in time 
%   axis 't' and uses it to calculate the dynamic gain 'dg' in three bands:
%   'f1' to 'f3', correpondig to total DG, 'f1' to 'f2', corresponding to
%   low frequency DG, and 'f2' to 'f3', corresponding to high frequency DG.
%
% original Matlab code: Luisa Santiago C. B. da Silva, Jul. 2015

% removes sampples before 0 (added for viewing in impulseResponse)
t = t(5:length(t));
im = im(5:length(im));
% parameters
ts = t(2)-t(1); fs = 1/ts; n = 1024;
% fft
freq = fs/2*linspace(0,1,n/2+1);
absIR = abs(freqz(im,1,freq,fs));
% dg
freq2 = sort([freq, f1, f2, f3]);
absIR2 = spline(freq,absIR,freq2);
i = find(freq2 == f1,1);
j = find(freq2 == f2,1);
k = find(freq2 == f3,1);

dg(1) = (sum(absIR2(i:k))*fs/n)/(f3-f1); %total dynamic gain
dg(2) = (sum(absIR2(i:j))*fs/n)/(f2-f1); %LF dynamic gain
dg(3) = (sum(absIR2(j:k))*fs/n)/(f3-f2); %HF dynamic gain
end

function showDG(~,~,userOpt,pMod)
% open window to show dynamic gain plots

options = get(userOpt,'userData');
if options.session.imresp.imrespGen
    model = get(pMod,'userData');
    freq = options.session.imresp.freq;
    if length(model.InputName) == 2
        [~,freq1,absIR1] = identDG(model.imResp.impulse{1},...
            model.imResp.time,freq(1),freq(2),freq(3));
        [~,freq2,absIR2] = identDG(model.imResp.impulse{2},...
            model.imResp.time,freq(1),freq(2),freq(3));
        plotDG(freq1,absIR1,model.InputName{1},freq(1),freq(2),freq(3),...
            freq2,absIR2,model.InputName{2});
    else
        [~,freq1,absIR1] = identDG(model.imResp.impulse{1},...
            model.imResp.time,freq(1),freq(2),freq(3));
        if isempty(model.InputName)
            plotDG(freq1,absIR1,model.OutputName{:},freq(1),freq(2),freq(3));
        else
            plotDG(freq1,absIR1,model.InputName{:},freq(1),freq(2),freq(3));
        end
    end
end
end

function plotDG(freq1,absIR1,tipoIn1,f1,f2,f3,freq2,absIR2,tipoIn2)
% plots dynamic gain

dgWindow = figure(2); clf(dgWindow);
set(dgWindow,'toolbar','none','Name','Dynamic Gain plot','Position',...
    [50,200,760,465],'Color',[.95 .95 .95])
axes('Units','pixels','Position',[60 45 680 390]);

% generate label for first input according to its type
switch tipoIn1
    case 'RRI', y1label='|FFT hRRI|';
    case 'SBP', y1label='|FFT hSBP|';
    case 'DBP', y1label='|FFT hDBP|';
    case 'HR', y1label='|FFT hHR|';
    otherwise, y1label='|FFT hILV|';
end
    
if nargin > 6
    subplot(2,1,1), plot(freq1,absIR1);
    axis([0 .5 0 max(absIR1)+.01]);
    title('Dynamic Gain (DG)');
    ylabel(y1label)
    % lines that show band limits on first plot
    line1=line([f1 f1],[0 max(absIR1)+.01]);
    set(line1,'color',[1 0 0]);
    line2=line([f2 f2],[0 max(absIR1)+.01]);
    set(line2,'color',[1 0 0]);
    line3=line([f3 f3],[0 max(absIR1)+.01]);
    set(line3,'color',[1 0 0]);
    
    % generate labels for second input according to its type
    switch tipoIn2
        case 'RRI', y2label='|FFT hRRI|';
        case 'SBP', y2label='|FFT hSBP|';
        case 'DBP', y2label='|FFT hDBP|';
        case 'HR', y2label='|FFT hHR|';
        otherwise, y2label='|FFT hILV|';
    end
    
    subplot(2,1,2), plot(freq2,absIR2);
    axis([0 .5 0 max(absIR2)+.01]);
    % lines that show band limits on second plot
    line1=line([f1 f1],[0 max(absIR2)+.01]);
    set(line1,'color',[1 0 0]);
    line2=line([f2 f2],[0 max(absIR2)+.01]);
    set(line2,'color',[1 0 0]);
    line3=line([f3 f3],[0 max(absIR2)+.01]);
    set(line3,'color',[1 0 0]);
    ylabel(y2label)
    xlabel('Frequency (Hz)');
else
    plot(freq1,absIR1)
    axis([0 .5 0 max(absIR1)+.01]);
    
    % lines that show band limits on fist and only plot
    line1=line([f1 f1],[0 max(absIR1)+.01]);
    set(line1,'color',[1 0 0]);
    line2=line([f2 f2],[0 max(absIR1)+.01]);
    set(line2,'color',[1 0 0]);
    line3=line([f3 f3],[0 max(absIR1)+.01]);
    set(line3,'color',[1 0 0]);
    
    title('Dynamic Gain (DG)');
    ylabel(y1label)
    xlabel('Frequency (Hz)');
end
end

function exportTxt(~,~,userOpt,pMod,txInfo)
% export quantitative indicators from impulse response to text file

options = get(userOpt,'userData');
if options.session.imresp.imrespGen
    model = get(pMod,'userData');
    % suggested file name
    modKey = options.session.imresp.modKey;
    modValue = options.session.imresp.modValue-1;
    [path,name,~] = fileparts(options.session.filename);
    filenameTxt = fullfile(path,[name '_' modKey{modValue,1} '_' lower(...
        model.Type) '_' modKey{modValue,2} '_imresp_info.txt']);
    [fileName,pathName,~] = uiputfile('*.txt',['Save impulse response ',...
        'information to text file'],filenameTxt);
    if (any(fileName~=0) || length(fileName)>1) && ...
            (any(pathName ~=0) || length(pathName)>1)
        filename = fullfile(pathName,fileName);
        fid = fopen(filename,'w');
        fprintf(fid,get(txInfo,'userData'),'char');
        fclose(fid);
    end
end
end

function saveConfig(userOpt)
% save session configurations for next session

options = get(userOpt,'userData');
options.imresp.freq = options.session.imresp.freq;
set(userOpt,'userData',options);
end