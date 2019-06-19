function mainOptions(scr,~,dataList,puVarOpt,puVar,dataOpt)
% mainOptions Opens window to input data specification
%   mainOptions(scr,event,puVarOpt,puVar,dataOpt) executes the callback
%   function for a popupmenu scr. It opens a window that allows the user to
%   supply information about the data being entered. The options displayed
%   depend on the values indicated in scr and puVarOpt, which specify the
%   data type of the variable indicated in puVar's value. The 
%   specifications are returned as a struct in dataOpt's userData property.
%
% original Matlab code: Luisa Santiago C. B. da Silva, Feb. 2017

set(scr,'userData',get(scr,'value')); % store new previous value

dataType = get(puVarOpt,'value');
dataSpec = get(scr,'value');
  
optionsWindow = [];
if dataSpec == 2 && dataType ~= 3 % filtered ECG/BP

    optionsWindow = figure(4);
    set(optionsWindow,'Position',[300 300 325 260]);

    % indicate filters used by indicating their cut-off fq.
    uicontrol('parent',optionsWindow,'style','text','hor','left',...
        'string','Indicate applied filters'' cut-off frequency',...
        'fontsize',10,'position',[25 185 250 20]);
    teNotch = uicontrol('parent',optionsWindow,'style','edit','tag',...
        'notch','callback',{@checkNum,dataOpt},'backgroundcolor',...
        [1 1 1],'position',[240 130 60 25]);
    uicontrol('parent',optionsWindow,'style','text','String',...
        'Notch filter:','hor','left','position',[50 135 100 15]);
    teLow = uicontrol('parent',optionsWindow,'style','edit','tag',...
        'lowPass','callback',{@checkNum,dataOpt},'backgroundcolor',...
        [1 1 1],'position',[240 100 60 25]);
    uicontrol('parent',optionsWindow,'style','text','String',...
        'Low-pass filter:','hor','left','position',[50 105 100 15]);
    teHigh = uicontrol('parent',optionsWindow,'style','edit','tag',...
        'highPass','callback',{@checkNum,dataOpt},'backgroundcolor',...
        [1 1 1],'position',[240 70 60 25]);
    uicontrol('parent',optionsWindow,'style','text','hor','left',...
        'String','High-pass filter (baseline wander):','position',...
        [50 75 170 15]); 

    % OK button
    uicontrol('parent',optionsWindow,'style','push','string','OK',...
        'callback',{@storeFilt,dataOpt},'position',...
        [170 25 60 30]);
    openFcnFilt(teNotch,teLow,teHigh,dataType,dataOpt);

elseif (dataSpec == 3 || (dataSpec == 4 && dataType == 2)) && ...
        dataType ~= 3 %RRI/SBP/DBP

    optionsWindow = figure(4);

    %OK button
    pbOk = uicontrol('parent',optionsWindow,'style','push',...
        'string','OK','position',[170 25 60 30]);

    set(optionsWindow,'Position',[300 300 325 300]);

    % indicate algorithm used for variable detection
    txAlg =uicontrol('parent',optionsWindow,'style','text','string',...
        'Indicate algorithm used to extract the variable:',...
        'fontsize',10,'hor','left','position',[25 255 275 20]);
    rbAlg1 = uicontrol('parent',optionsWindow,'style','radio',...
        'string',' ','userData',0,'tag','var','hor','left','value',...
        0,'position',[50 255 120 15]);
    rbAlg2 = uicontrol('parent',optionsWindow,'style','radio',...
        'string',' ','userData',1,'tag','var','hor','left','value',...
        0,'position',[50 230 190 15]);
    rbAlg3 = uicontrol('parent',optionsWindow,'style','radio',...
        'string',' ','userData',2,'tag','var','hor','left','value',...
        0,'position',[50 205 190 15]);
    teOther = uicontrol('parent',optionsWindow,'style','edit','hor',...
        'left','backgroundcolor',[1 1 1],'position',[170 175 130 25]);
    rbOther =uicontrol('parent',optionsWindow,'style','radio','hor',...
        'left','String','Other:','userData',3,'tag','var','value',0,...
        'position',[50 180 50 15]);

    % choose variable indicating ectopic markings
    uicontrol('parent',optionsWindow,'style','text','String',...
        'Ectopic markings:','hor','left','position',[50 140 90 15]);
    puEct = uicontrol('parent',optionsWindow,'style','popupmenu',...
        'hor','left','string',' ','value',1,'backgroundcolor',...
        [1 1 1],'callback',{@checkPu,dataList,puVar},'position',...
        [170 145 130 15]);

    % indicate from which record the variable was extracted
    txOrig = uicontrol('parent',optionsWindow,'style','text','hor',...
        'left','string',' ','fontsize',10,'position',[25 100 265 20]);
    rbRaw = uicontrol('parent',optionsWindow,'style','radio','hor',...
        'left','userData',0,'value',0,'tag','or','position',...
        [50 75 95 15]);
    rbFilt = uicontrol('parent',optionsWindow,'style','radio','hor',...
        'left','userData',1,'value',0,'tag','or','position',...
        [170 75 95 15],'callback',{@radioCb,dataOpt,rbRaw,[],[]});

    % define callback functions
    set(rbAlg1,'callback',{@radioCb,dataOpt,rbAlg2,rbAlg3,rbOther});
    set(rbAlg2,'callback',{@radioCb,dataOpt,rbAlg1,rbAlg3,rbOther});
    set(rbAlg3,'callback',{@radioCb,dataOpt,rbAlg1,rbAlg2,rbOther});
    set(rbOther,'callback',{@radioCb,dataOpt,rbAlg1,rbAlg2,rbAlg3});
    set(rbRaw,'callback',{@radioCb,dataOpt,rbFilt,[],[]});
    set(pbOk,'callback',{@storeVar,dataOpt,dataType,dataSpec,...
        teOther,puEct,dataList});
    openFcnVar(puVar,puEct,txOrig,rbRaw,rbFilt,txAlg,rbAlg1,rbAlg2,...
        rbAlg3,rbOther,teOther,dataType,dataSpec,dataOpt,optionsWindow)

elseif dataSpec == 3 && dataType == 3 % ILV (detrended airflow)

    optionsWindow = figure(4);
    set(optionsWindow,'Position',[300 300 325 300]);

    %OK button
    pbOk = uicontrol('parent',optionsWindow,'style','push','string',...
        'OK','position',[170 25 60 30]); 

    % indicate algorithm used for detrending
    uicontrol('parent',optionsWindow,'style','text','hor','left',...
        'string','Detrending method used on integrated airflow:',...
        'fontsize',10,'position',[25 255 275 20]);
    rbLin = uicontrol('parent',optionsWindow,'style','radio','hor',...
        'left','string','Linear detrend','userData',0,'tag','resp',...
        'position',[50 230 95 15]);
    tePoly = uicontrol('parent',optionsWindow,'style','edit','tag',...
        'poly','callback',{@checkNum,dataOpt},'backgroundcolor',...
        [1 1 1],'position',[240 200 60 25]);
    rbPoly = uicontrol('parent',optionsWindow,'style','radio','tag',...
        'resp','string','Polynomial detrend of order:','hor','left',...
        'userData',1,'position',[50 205 160 15]);
    teHigh = uicontrol('parent',optionsWindow,'style','edit','tag',...
        'high','callback',{@checkNum,dataOpt},'backgroundcolor',...
        [1 1 1],'position',[240 175 60 25]);
    rbHigh = uicontrol('parent',optionsWindow,'style','radio',...
        'string','High-pass with cut-off frequency:','tag','resp',...
        'hor','left','userData',2,'position',[50 180 185 15]);
    teOther = uicontrol('parent',optionsWindow,'style','edit','tag',...
        'other','backgroundcolor',[1 1 1],'position',[170 150 130 25]);
    rbOther = uicontrol('parent',optionsWindow,'style','radio',...
        'String','Other:','hor','left','userData',3,'position',...
        [50 155 50 15]);

    % define callback functions
    set(rbLin,'callback',{@radioCb,dataOpt,rbPoly,rbHigh,rbOther});
    set(rbPoly,'callback',{@radioCb,dataOpt,rbLin,rbHigh,rbOther});
    set(rbHigh,'callback',{@radioCb,dataOpt,rbLin,rbPoly,rbOther});
    set(rbOther,'callback',{@radioCb,dataOpt,rbLin,rbPoly,rbHigh});

    % indicate filters used by indicating their cut-off f.
    uicontrol('parent',optionsWindow,'style','text','string',...
        'Indicate applied filter''s cut-off frequency','fontsize',...
        10,'hor','left','position',[25 105 250 20]);
    uicontrol('parent',optionsWindow,'style','text','String',...
        'Low-pass filter:','hor','left','position',[50 75 170 15]);
    teLow = uicontrol('parent',optionsWindow,'style','edit','tag',...
        'low','callback',{@checkNum,dataOpt},'backgroundcolor',...
        [1 1 1],'position',[240 70 60 25]);

    set(pbOk,'callback',{@storeILV,dataOpt});
    openFcnResp(rbLin,tePoly,rbPoly,teHigh,rbHigh,teOther,rbOther,...
        teLow,dataOpt);
end
if ~isempty(optionsWindow)
    set(optionsWindow,'MenuBar','none','Name',['(ENE/UnB) CRSIDLab',...
        ' - Data Options'],'color',[.94 .94 .94],'NumberTitle',...
        'off','WindowStyle','modal');
    % cancel button
    uicontrol('parent',optionsWindow,'style','push','string',...
        'Cancel','callback',{@cancelButton,dataOpt},'position',[240 25 60 30]);
    set(optionsWindow,'CloseRequestFcn',{@cancelButton,dataOpt});
    uiwait(optionsWindow);
end

end
 
function openFcnFilt(teNotch,teLow,teHigh,dataType,dataOpt)

options = get(dataOpt,'userData');
% high-pass filter only for ECG
if dataType == 1
    set(teHigh,'enable','on');
else
    set(teHigh,'enable','off');
    options.create.filt.highPass = [];
end

set(teNotch,'string',num2str(options.create.filt.notch));
set(teLow,'string',num2str(options.create.filt.lowPass));
set(teHigh,'string',num2str(options.create.filt.highPass));

set(dataOpt,'userData',options);
end

function openFcnVar(puVar,puEct,txOrig,rbRaw,rbFilt,txAlg,rbAlg1,rbAlg2,...
    rbAlg3,rbOther,teOther,dataType,dataSpec,dataOpt,optionsWindow)

options = get(dataOpt,'userData');

% string to choose variable indicating ectopic markings
varString = get(puVar,'string');
if get(puVar,'value')~=1
    varString(get(puVar,'value'))=[];
end
set(puEct,'string',varString);

% set origin options label and algorithm options
if dataType == 1
    set(rbAlg1,'visible','off');
    set(rbAlg2,'String','Fast algorithm');
    set(rbAlg3,'String','Slow algorithm');
    if options.create.var.selection==0, options.create.var.selection=1; end
    set(txOrig,'string','RRI extracted from:');
    set(rbRaw,'string','Raw ECG'); set(rbFilt,'string','Filtered ECG');
elseif dataSpec == 3
    set(rbAlg1,'visible','off');
    set(rbAlg2,'String','Waveform algorithm');
    set(rbAlg3,'String','Extraction from RRI');
    if options.create.var.selection==0, options.create.var.selection=1; end
    set(txOrig,'string','SBP extracted from:');
    set(rbRaw,'string','Raw BP'); set(rbFilt,'string','Filtered BP');
else
    set(optionsWindow,'Position',[300 300 325 325]);
    set(txAlg,'position',[25 280 275 20]);
    set(rbAlg1,'visible','on','String','Waveform algorithm');
    set(rbAlg2,'String','Extraction from SBP');
    set(rbAlg3,'String','Extraction from RRI & SBP ');
    set(txOrig,'string','DBP extracted from:');
    set(rbRaw,'string','Raw BP'); set(rbFilt,'string','Filtered BP');
end
            
% record from which the variable was extracted            
if options.create.var.origin == 0
    set(rbRaw,'value',1);
else
    set(rbFilt,'value',1);
end

% algorithm selection
if options.create.var.selection == 0
    set(rbAlg1,'value',1);
elseif options.create.var.selection == 1
    set(rbAlg2,'value',1);
elseif options.create.var.selection == 2
    set(rbAlg3,'value',1);
else
    set(rbOther,'value',1);
    set(teOther,'string',options.create.specs.algorithm);
end

set(dataOpt,'userData',options);
end

function storeFilt(~,~,userOpt)
% storeFilt Stores filtered data specifications
%     storeFilt(scr,event,optionsWindow,dataOpt,teNotch,teLow,teHigh)
%     stores cut-off frequency of the applied filters in a struct in 
%     dataOpt's userData property. Each filter is stored in a struct field: 
%     notch for the cut-off frequency in teNotch, lowpass for the one in 
%     teLow and highpass for the one in teHigh. If the text edit is empty,
%     then the correspondig filter was not used and the field is not
%     created. Closes optionsWindow.
%
% original Matlab code: Luisa Santiago C. B. da Silva, Feb. 2017

options = get(userOpt,'userData');
options.create.specs = struct;

fields = {'notch','lowPass','highPass'};
for i = 1:3
    if ~isempty(options.create.filt.(fields{i}))
        options.create.specs.(fields{i}) = options.create.filt.(fields{i});
    end
end

set(userOpt,'userData',options);
closereq;
end

function storeVar(~,~,dataOpt,dataType,dataSpec,teOther,puEct,dataList)
% storeVar Stores variable (RRI/SBP/DBP) data specifications
%     storeVar(scr,event,optionsWindow,dataOpt,dataType,dataSpec,rbAlg1,
%     rbAlg2,rbAlg3,teOther,puEct,dataList) stores algorithm used to
%     extract the variable from the main data record as well as a variable
%     indicating the index of variables resulting from an ectopic beat or
%     its compensatory pause as a struct in dataOpt's userData property.
%     The algorithm is indicated through the value of the radiobuttons
%     rbAlg1, rbAlg2 and rbAlg3. The actual method indicated by each 
%     radiobutton depends on the values of dataType and dataSpec. If 
%     another algorithm was used, none of the radiobuttons are selected and
%     the algorithm is indicated in teOther. The ectopic indexes are in a 
%     variable indicated in puEct, which can be read from dataList's 
%     userData. Closes optionsWindow.
%
% original Matlab code: Luisa Santiago C. B. da Silva, Feb. 2017

curData = get(dataList,'userData'); % list of variables from WS
options = get(dataOpt,'userData');
options.create.specs = struct;

if get(puEct,'value')~=1
    % read ectopic index variable
    var = get(puEct,'string');
    varName = var(get(puEct,'value'));
    varValue = curData.(varName{:});
    if islogical(varValue), varValue = find(varValue); end
    options.create.var.ectopic = varValue(:); %column vector
else
    options.create.var.ectopic = [];
end

if options.create.var.origin == 0
    options.create.specs.type = 'raw';
else
    options.create.specs.type = 'filt';
end

% determine the algorithm selected
if options.create.var.selection == 0
    options.create.specs.algorithm = 'Waveform algorithm';
elseif options.create.var.selection == 1
    if dataType == 1
        options.create.specs.algorithm = 'Fast algorithm';
    elseif dataSpec == 3
        options.create.specs.algorithm = 'Waveform algorithm';
    else
        options.create.specs.algorithm = 'From SBP';
    end
elseif options.create.var.selection == 2
    if dataType == 1
        options.create.specs.algorithm = 'Slow algorithm';
    elseif dataSpec == 3
        options.create.specs.algorithm = 'From RRI';
    else
        options.create.specs.algorithm = 'From RRI & SBP';
    end
else
    if ~isempty(get(teOther,'string'))
        options.create.specs.algorithm = get(teOther,'string');
    end
end

set(dataOpt,'userData',options);
closereq;
end

function openFcnResp(rbLin,tePoly,rbPoly,teHigh,rbHigh,teOther,rbOther,...
    teLow,dataOpt)

options = get(dataOpt,'userData');

set(tePoly,'string',num2str(options.create.resp.poly));
set(teHigh,'string',num2str(options.create.resp.high));
set(teOther,'string',num2str(options.create.resp.other));
set(teLow,'string',num2str(options.create.resp.low));

set(rbLin,'value',0); set(rbPoly,'value',0); 
set(rbHigh,'value',0); set(rbOther,'value',0);
if options.create.resp.selection == 0, set(rbLin,'value',1);
elseif options.create.resp.selection == 1, set(rbPoly,'value',1);
elseif options.create.resp.selection == 2, set(rbHigh,'value',1);
else set(rbOther,'value',1);
end
end

function storeILV(~,~,dataOpt)
% storeILV Stores ILV data specifications
%     storeILV(scr,event,optionsWindow,dataOpt,rbLin,rbPoly,rbHigh,tePoly,
%     teHigh,teOther,teLow) stores method used to detrend the integrated
%     airflow and the cut-off frequency of the low-pass filter used as a
%     struct in dataOpt's user data property. Linear detrend is indicated
%     if the value of rbLin is 1, polinomial detrend through rbPoly and
%     corresponding polynomial order is indicated in tePoly and high-pass
%     filter through rbHigh, with cut-off frequency indicated in teHigh. If
%     another method was used, it is indicated in teOther. If a low-pass
%     filter was used, its cut-off frequency is indicated in teLow. Closes
%     optionsWindow.
%
% original Matlab code: Luisa Santiago C. B. da Silva, Feb. 2017

options = get(dataOpt,'userData');
options.create.specs = struct;

% method and corresponding parameters
if options.create.resp.selection == 0
    options.create.specs.method.id = 'Linear';
elseif options.create.resp.selection == 1
    options.create.specs.method.id = 'Polynomial';
    options.create.specs.method.order = options.create.resp.poly;
elseif options.create.resp.selection == 2
    options.create.specs.method.id = 'High-pass filter';
    options.create.specs.method.fc = options.create.resp.high;
else
    options.create.specs.method.id = options.create.resp.other;
end

% low-pass filter
if ~isempty(options.create.resp.low)
    options.create.specs.filterFc = options.create.resp.low; 
end

set(dataOpt,'userData',options);
closereq;
end

function cancelButton(~,~,dataOpt)
% cancelButton Closes window without storing options
%     cancelButton(scr,event,optionsWindow) closes optionsWindow without
%     storing options data.
%
% original Matlab code: Luisa Santiago C. B. da Silva, Feb. 2017

options = get(dataOpt,'userData');
options.create.specs = struct;
set(dataOpt,'userData',options);

closereq;
end

function checkPu(scr,~,dataList,puVar)
% checkPu Verifies variable entered as ectopic markings (RRI/SBP/DBP)
%     checkPu(scr,event,dataList,puVar) checks if ectopic indexes variable,
%     indicated by scr's value, is a valid index for the main variable,
%     indicated by puVar's value. The variables are obtained from
%     dataList's userData property.
%
% original Matlab code: Luisa Santiago C. B. da Silva, Feb. 2017

curData = get(dataList,'userData'); % list of variables from WS

ind = get(scr,'value');
varString = get(scr,'string');
varName = varString(ind);
if ind ~=1
    varValue = curData.(varName{:});
    auxInd = get(puVar,'value'); % get variable to verify indexes
    auxString = get(puVar,'string');
    auxVarName = auxString(auxInd);
    auxVar = curData.(auxVarName{:});
    %checks if the indexes are valied for the main variable
    try
        auxVar(varValue);
    catch
        set(scr,'value',1);
        uiwait(errordlg(sprintf(['Invalid ectopics indexes.\nThe ',...
            'variable with ectopic markings index must be an array of ',...
            'positive integer or logical values.\nLogical indexes may ',...
            'not exceede the main variable''s length.\nNumerical ',...
            'indexes may not contain values greater then the main ',...
            'variable''s length.']),'Options Error','modal'));
    end
end

end

function checkNum(scr,~,dataOpt)
% checkNum Checks if data entered in object scr is valid
%     checkNum(scr,event,pu) checks if value entered in text edit scr is 
%     valid. If the variable is valid (single positive numeric value), the
%     corresponding popupmenu is switched to a blank selection.
%
% original Matlab code: Luisa Santiago C. B. da Silva, Feb. 2017

val = str2double(get(scr,'string'));
if strcmp(get(scr,'tag'),'poly'), val = round(val); end

if (isnan(val) || val<0)
    val = []; set(scr,'string','');
end

options = get(dataOpt,'userData');
if ismember(get(scr,'tag'),{'notch','lowPass','highPass'})
    options.create.filt.(get(scr,'tag')) = val;
else
    options.create.resp.(get(scr,'tag')) = val;
end
set(dataOpt,'userData',options);
end

function radioCb(scr,~,dataOpt,rb1,rb2,rb3)
% radioCb Sets value from all other radiobuttons to 0
%     radioCb(scr,event,rb1,rb2,rb3) sets the value property of radio
%     buttons rb1, rb2 and rb3 to 0 when radiobutton scr is selected.
%
% original Matlab code: Luisa Santiago C. B. da Silva, Feb. 2017

set(rb1,'value',0);
if ~isempty(rb2), set(rb2,'value',0); end
if ~isempty(rb3), set(rb3,'value',0); end

options = get(dataOpt,'userData');
if strcmp(get(scr,'tag'),'or')
    options.create.var.origin = get(scr,'userData');
else
    options.create.(get(scr,'tag')).selection = get(scr,'userData');
end
set(dataOpt,'userData',options);
end