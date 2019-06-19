function mainVarSel(~,~,pFile,lbVar,userOpt,dataList,addedData)

% mainVarSel Opens window to select variables to compose patient data
%     mainVarSel(scr,event,pData) executes the callback function for a
%     pushbutton scr. It opens a window that reads variables from Matlab's
%     workspace and allows the user to create a new patient file. The
%     patient data is return through the userData field of pData object.
%
% original Matlab code: Luisa Santiago C. B. da Silva, Feb. 2017

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  object used to move information through funcions
%

% temporary patient data
data = dataPkg.patientData;
tempData = uicontrol('visible','off','userData',data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% create window to import data to patient file
%

importWindow = figure(3);
set(importWindow, 'MenuBar', 'none','NumberTitle','off','Units',...
    'Pixels','Position',[300 100 430 405],'Name',['(ENE/UnB) CRSIDLab ',...
    '- Import / Remove variables'],'color',[.94 .94 .94]);

% popupmenu: select main variable
uicontrol('parent',importWindow,'style','text','string','Variable:',...
    'hor','left','position',[25 305 100 15]);

puVar = uicontrol('parent',importWindow,'style','popupmenu','string',...
    '','value',1,'userData',1,'tag','var','position',[25 280 150 15],...
    'backgroundcolor',[1 1 1]);

% popupmenus: select variable type and specification
uicontrol('parent',importWindow,'style','text','string',...
    'Variable type:','hor','left','position',[25 365 100 15]);

uicontrol('parent',importWindow,'style','text','string',...
    'Variable specification:','hor','left','position',[255 365 150 15]);%[25 245 110 15]

puVarType =uicontrol('parent',importWindow,'style','popupmenu','string',...
    {'Electrocardiogram','Blood Pressure','Airflow / ILV'},'value',1,...
    'userData',2,'position',[25 340 150 15],'backgroundcolor',[1 1 1]);

puVarSpec =uicontrol('parent',importWindow,'style','popupmenu','string',...
    '','callback',{@mainOptions,dataList,puVarType,puVar,userOpt},...
    'value',1,'userData',1,'position',[255 340 150 15],'backgroundcolor',...%[25 220 160 15]
    [1 1 1]);

set(puVarType,'callback',{@updateVarSpec,puVarSpec,userOpt});

% popupmenu: select associated time vector
uicontrol('parent',importWindow,'style','text','string','Time vector:',...
    'hor','left','position',[255 305 100 15]);

puTime = uicontrol('parent',importWindow,'style','popupmenu','string',...
    '','value',1,'userData',1,'tag','time','position',[255 280 150 15],...
    'backgroundcolor',[1 1 1]);

% popupmenu and text edit: select or write initial time
uicontrol('parent',importWindow,'style','text','string','Start / End times:',...
    'hor','left','position',[255 245 100 15]);

teT0 = uicontrol('parent',importWindow,'style','edit','hor','left',...
    'backgroundcolor',[1 1 1],'position',[255 214 65 20],'tag','start');

uicontrol('parent',importWindow,'style','text','string','to',...
    'hor','left','Position',[325 217 15 15]);

teTf = uicontrol('parent',importWindow,'style','edit','hor','left',...
    'Position',[340 214 65 20],'backgroundcolor',[1 1 1],'callback',...
    {@checkTime,teT0},'tag','end');

set(teT0,'callback',{@checkTime,teTf});

% popupmenu and text edit: select or write sampling frequency
uicontrol('parent',importWindow,'style','text','string',...
    'Sampling Frequency:','hor','left','position',[25 245 110 15]);

puFs = uicontrol('parent',importWindow,'style','popupmenu','string',...
    '','value',1,'userData',1,'position',[25 220 105 15],... 
    'backgroundcolor',[1 1 1]);

uicontrol('parent',importWindow,'style','text','string','or',...
    'hor','left','Position',[135 217 15 15]); 

teFs = uicontrol('parent',importWindow,'style','edit','hor','left',...
    'callback',{@checkFreq,puFs,puVar,puTime},'Position',...
    [150 214 65 20],'backgroundcolor',[1 1 1]); 

% pushbutton: view data
uicontrol('parent',importWindow,'style','push','string','View data',...
    'callback',{@viewData,dataList,puVar,puVarType,puVarSpec,puTime,...
    teT0,teTf,teFs},'position',[255 170 100 28]);

% pushbutton: update variables from workspace
uicontrol('parent',importWindow,'style','push','tag','pb','string',...
    'Refresh variables from WS','callback',{@updateWSVar,dataList,puVar,...
    puTime,puFs},'position',[25 170 160 28]);

% listbox: patient file current contents
uicontrol('parent',importWindow,'style','text','string',...
    'Patient file contents:','hor','left','Position',[25 135 100 15]);

lbImported = uicontrol('parent',importWindow,'style','listbox','max',2,...
    'string','','Position',[25 25 220 96],'value',[]);

% pushbutton: add data to patient file
uicontrol('parent',importWindow,'style','push','string',...
    'Add to patient file','callback',{@add2file,tempData,dataList,...
    userOpt,addedData,lbImported,puVar,puVarType,puVarSpec,puTime,...
    puFs,teT0,teTf,teFs},'position', [255 93 150 28]);

% pushbutton: remove data from patient file
uicontrol('parent',importWindow,'style','push','string',...
    'Remove from patient file','callback',{@removeVar,tempData,dataList,...
    userOpt,addedData,lbImported,puVar,puTime,puFs},...
    'position',[255 60 150 28]);

% pushbutton: finish adding variables to patient file
uicontrol('parent',importWindow,'style','push','string','Done',...
    'callback',{@doneButton,userOpt,tempData,pFile,lbVar},'position',...
    [255 25 70 30]);

% pushbutton: cancel adding variables to patient file
uicontrol('parent',importWindow,'style','push','string','Cancel',...
    'callback',{@cancelButton,userOpt},'position',[335 25 70 30]);

% set callbacks
set(puVar,'callback',{@varCheck,dataList,userOpt,puTime,puFs});
set(puTime,'callback',{@varCheck,dataList,userOpt,puVar,puFs});
set(puFs,'callback',{@numVarCheck,dataList,puVar,puTime,teFs});
set(importWindow,'CloseRequestFcn',{@cancelButton,userOpt});

openFcn(userOpt,pFile,tempData,lbImported,puVarType,puVarSpec,dataList,...
    puVar,puTime,puFs)
end

function openFcn(userOpt,pFile,tempData,lbImported,puVarType,puVarSpec,...
    dataList,puVar,puTime,puFs)

options = get(userOpt,'UserData');

if ~isempty(options.session.main.listString)
    set(lbImported,'string',options.session.main.listString);    
end

curFile = get(pFile,'userData');
set(tempData,'userData',curFile);

options.session.main.done = 1;
set(userOpt,'userData',options);

prevData = get(dataList,'userData');
if isempty(fieldnames(prevData))
    updateWSVar([],[],dataList,puVar,puTime,puFs);
else
    set(puVar,'string',[' ' ; fieldnames(prevData)]);
    set(puTime,'string',[' ' ; fieldnames(prevData)]);
    set(puFs,'string',[' ' ; fieldnames(prevData)]);
end
updateVarSpec(puVarType,[],puVarSpec,userOpt);
end

function updateWSVar(~,~,dataList,puVar,puTime,puFs)
% updateWSVar Gets variables from workspace and update variable lists
%     updateWSVar(scr,event,dataList,puVar,puTime,puFs) reads
%     variables from workspace and stores variables names and values in the
%     userData property of object dataList. Calls function to updates 
%     variables list on popupmenus adjusting their selected value.
%
% original Matlab code: Luisa Santiago C. B. da Silva, Feb. 2017

baseVariables = evalin('base','who');       % get variable names from WS
data = struct;                              % struct to store new variables

if isempty(baseVariables)                   % no variables in WS
    set(puVar,'string','No variables','enable','inactive');
    set(puTime,'string','No variables','enable','inactive');
    set(puFs,'string','No variables','enable','inactive');
else
    set(puVar,'enable','on');
    set(puTime,'enable','on');
    set(puFs,'enable','on');
    prevData = get(dataList,'userData');     % get previous variables
    
    if isempty(fieldnames(prevData))         % no previous variables
        for i = 1:length(baseVariables)      % get variables from WS
          data.(baseVariables{i}) = evalin('base',baseVariables{i});
        end
        % update strings with variable names
        set(puVar,'string',[' ' ; fieldnames(data)]);
        set(puTime,'string',[' ' ; fieldnames(data)]);
        set(puFs,'string',[' ' ; fieldnames(data)]);
    else 
        prevFields = fieldnames(prevData);   % previous variables names
        swcVarName = cell(length(baseVariables),1);
        addVarName = cell(length(baseVariables),1);
        swcCnt = 1; addCnt = 1;              % counters
        
        for i = 1:length(baseVariables)
            % get variables from WS
            data.(baseVariables{i}) = evalin('base',baseVariables{i});
            % find variables that were added or had its value switched
            if ~isfield(prevData,baseVariables(i))
              addVarName(addCnt) = baseVariables(i);
              addCnt = addCnt+1;
            elseif ~isequal(prevData.(baseVariables{i}),...
                    data.(baseVariables{i}))
              swcVarName(swcCnt) = baseVariables(i);
              swcCnt = swcCnt+1;
            end
        end
        addVarName = unique(addVarName(~cellfun('isempty',addVarName)));
        swcVarName = unique(swcVarName(~cellfun('isempty',swcVarName)));

        % find removed variables
        remVarName = cell(length(prevFields),1);
        contRem = 1;
        for i=1:length(prevFields)
            if ~ isfield(data,prevFields{i})
                remVarName(contRem) = prevFields(i);
                contRem = contRem+1;
            end
        end
        remVarName = unique(remVarName(~cellfun('isempty',remVarName)));
        
        % update all lists
        updateList(puVar,remVarName,addVarName,swcVarName,data);
        updateList(puTime,remVarName,addVarName,swcVarName,data);
        updateList(puFs,remVarName,addVarName,swcVarName,data);
    end
end
set(dataList,'userData',data);  % return new data list
end

function updateList(pu,remVarName,addVarName,swcVarName,data)
% updateList Updates variable lists
%     updateList(pu,remVarName,addVarName,swcVarName,data) calls functions
%     that remove variables for each variable in remVarName and that adds 
%     variables for each variable in addVarName. It also adjusts pu's value
%     if any variable in swcVarName was previously selected, since these
%     are variables that had their value changed in the update.
%
% original Matlab code: Luisa Santiago C. B. da Silva, Feb. 2017

% call function to remove variable for each variable in remVarName
for i = 1:length(remVarName)
    clearList(pu,get(pu,'string'),remVarName{i});
end

% call function to add variable for each variable in addVarName
for i = 1:length(addVarName)
    restoreList(pu,[],addVarName{i});
end

% adjust pu's value if a variable in swcVarName was previously selected
for i = 1:length(swcVarName)
    auxInd = find(strcmp(fieldnames(data),swcVarName),1);
    if get(pu,'value')==auxInd
        set(pu,'value',1);
    end
end
end

function clearList(pu,varString,varName)
% clearList Removes variable from pu's list and updates pu's value
%     clearList(pu,varString,varName) removes variable varName from
%     variables list varString and replaces pu's string, maintaining the
%     variable that was already selected by pu's value and adjusting the
%     value if necessary.
%
% original Matlab code: Luisa Santiago C. B. da Silva, Feb. 2017

% clear variable selected from other popupmenu
varInd = find(strcmp(varString,varName),1);
varString(varInd) = [];

% recover variable selected in this popupmenu (if any) and adjusts index
auxString = get(pu,'string');
auxInd = get(pu,'value');
if auxInd~=1
    auxString = auxString(auxInd);
    finalString = unique([varString ; auxString]);
    finalInd = find(strcmp(finalString,auxString),1);
else
    finalString = varString;
    if auxInd>varInd       % variable removed above variable selected
        finalInd = auxInd-1;
    else                   % variable removed below variable selected
        finalInd = auxInd;
    end
end

% set pu's new properties
set(pu,'value',finalInd);
set(pu,'string',finalString);
end

function restoreList(pu,varString,varName)
% restoreList Restores variable to pu's list and updates pu's value
%     restoreList(pu,varString,varName) if varString is not empty, adds the
%     variable selected in pu to varString and updates pu's value and 
%     string. If varName is not empty, adds varName to pu's string and
%     adjust pu's value.
%
% original Matlab code: Luisa Santiago C. B. da Silva, Feb. 2017

auxInd = get(pu,'value');
auxString = get(pu,'string');
if ~isempty(varString)          % include var. selected in pu on the list
    varName = auxString(auxInd);
    newString = unique([varString ; auxString]);
    if auxInd ~= 1              % adjust index
        finalInd = find(strcmp(newString,varName),1);
        if finalInd>auxInd
            set(pu,'value',auxInd+1);
        end
    end
else                            % include varName on the list
    auxString{end+1} = varName;
    newString = unique(auxString);
    if auxInd ~= 1              % adjust index
        finalInd = find(strcmp(newString,varName),1);
        if finalInd<=auxInd
            set(pu,'value',auxInd+1);
        end
    end
end
set(pu,'string',newString);     % set pu's new string
end

function varCheck(scr,~,dataList,userOpt,pu1,pu2)
% varCheck Checks if data entered in object scr is valid
%     varCheck(scr,event,dataList,pu1,pu2) checks if data matching the
%     selected value in scr is valid as time or main variable. Popupmenu p1
%     must be either puVar or puTime, depending on which is scr. If the
%     variables are valid (numeric array with matching lengths), the
%     variable is removed from dataList. Calls functions to update each of
%     the popupmenu's list.
%
% original Matlab code: Luisa Santiago C. B. da Silva, Feb. 2017

varInd = get(scr,'value');

if varInd~=get(scr,'userData')
    
    % clears data options struct if new variable is selected as main
    if strcmp(get(scr,'tag'),'var')
        options = get(userOpt,'userData');
        options.session.main.specs = struct;
        set(userOpt,'userData',options);
    end
    
    % get list of variables imported from workspace
    curData = get(dataList,'userData');

    % find variable selected in the popupmenu
    varString = get(scr,'string');
    varName = varString(varInd);

    % if the selection isn't blank (ind = 1) test validity
    if varInd ~=1
        varValue = curData.(varName{:}); % get variable value
        if ~isnumeric(varValue) || sum(size(varValue)==[1 1])~=1
            set(scr,'value',1);
            uiwait(errordlg(sprintf(['Invalid variable input.\nThe ',...
                'variable selected must be an array of numeric data ',...
                'with more than one sample.']),'Variable Error','modal'));
        else
            auxInd = get(pu1,'value');% get respective var. to compare size
            if auxInd~=1
                auxString = get(pu1,'string');
                auxVarName = auxString(auxInd);
                auxVar = curData.(auxVarName{:});
            else
                auxVar = varValue;    % no other var., consider eq. size
            end
            if length(auxVar) ~= length(varValue)
                set(scr,'value',1);
                uiwait(errordlg(sprintf(['Variables length mismatch.\n',...
                    'The indicated main variable and time vector have ',...
                    'different lengths. The variable must have the ',...
                    'same length as its matching time vector.']),...
                    'Variable Error','modal'));
            elseif strcmp(get(scr,'tag'),'var')
                % remove "used" variable from available variables list
                clearList(pu1,varString,varName);
                clearList(pu2,varString,varName);
            end
        end
    else
        % return variable to available variables list (blank selection)
        restoreList(pu1,varString,[]);
        restoreList(pu2,varString,[]);
    end
end
set(scr,'userData',varInd); % store new previous value
end

function numVarCheck(scr,~,dataList,pu1,pu2,te)
% numVarCheck Checks if data entered in object scr is valid
%     numVarCheck(scr,event,dataList,pu1,pu2,te) checks if data matching 
%     the selected value in scr is valid as sampling frequency (fs).
%     If the variable is valid (single positive numeric value), the 
%     variable is removed from dataList. Calls functions to update each of 
%     the popupmenu's list.
%
% original Matlab code: Luisa Santiago C. B. da Silva, Feb. 2017

varInd = get(scr,'value');

if varInd~=get(scr,'userData') 
    
    % get list of variables imported from workspace
    curData = get(dataList,'userData');

    % find variable selected in the popupmenu
    varString = get(scr,'string');
    varName = varString(varInd);

    % if the selection isn't blank (ind = 1) test validity
    if varInd ~=1
        varValue = curData.(varName{:}); % get variable value
        if ~isnumeric(varValue) || ~all(varValue>=0) ||...
                ~all(size(varValue)==[1 1])
            set(scr,'value',1);
            uiwait(errordlg(sprintf(['Invalid variable input.\nThe ',...
                'variable selected must contain a single positive ',...
                'numeric value.']),'Variable Error','modal'));
        else
            % show value on text edit
            set(te,'string',num2str(varValue));
            % remove "used" variable from available variables list
            clearList(pu1,varString,varName);
            clearList(pu2,varString,varName);
        end
    else
        % remove any value from text edit
        set(te,'string','');
        % return variable to available variables list (blank selection)
        restoreList(pu1,varString,[]);
        restoreList(pu2,varString,[]);
    end
end
set(scr,'userData',varInd); % store new previous value
end

function checkFreq(scr,~,pu,pu1,pu2)
% checkFreq Checks if data entered in object scr is valid
%     checkFreq(scr,event,pu,pu1,pu2) checks if value entered in text
%     edit scr is valid as sampling frequency (fs). If the variable is
%     valid (single positive numeric value), the corresponding popupmenu is 
%     switched to a blank selection and all popupmenu's lists are restored.
%
% original Matlab code: Luisa Santiago C. B. da Silva, Feb. 2017

val = str2double(get(scr,'string'));
if isnan(val) || val<0
    set(scr,'string','');
else
    ind = get(pu,'value');
    if ind ~=1                  % restore lists
        varString = get(pu,'string');
        varName = varString{ind};
        restoreList(pu1,varName);
        restoreList(pu2,varName);
    end
end
set(pu,'value',1);              % blank selection
end

function checkTime(scr,~,te)
% checkTime Checks if data entered in object scr is valid
%     checkTime(scr,te) checks if value entered in text edit scr is valid 
%     as a time stamp. 
%
% original Matlab code: Luisa Santiago C. B. da Silva, Feb. 2017

val = str2double(get(scr,'string'));
if isnan(val) || val<0
    set(scr,'string','');
else
    val2 = str2double(get(te,'string'));
    if (strcmp(get(scr,'tag'),'start') && val>=val2) || ...
            (strcmp(get(scr,'tag'),'end') && val<=val2)
         set(scr,'string','');
    end
end
end

function updateVarSpec(scr,~,puVarSpec,userOpt)
% updateVarSpec Updates variable specification options
%     updateVarSpec(scr,event,puVarSpec,puVar) updates variable
%     specification options displayed in puVarSpec depending on data type
%     indicated in scr.
%
% original Matlab code: Luisa Santiago C. B. da Silva, Feb. 2017

ind = get(scr,'value');
if ind~=get(scr,'userData')
    % clears options if current selection is different than the previous
    options = get(userOpt,'userData');
    options.session.main.specs = struct;
    set(userOpt,'userData',options);

    switch ind
        case 1      % (ECG / RRI / HR)
            set(puVarSpec,'string',{'Raw ECG','Filtered ECG',...
                'R-R Interval'});
        case 2      % (BP / SBP / DBP)
            set(puVarSpec,'string',{'Raw BP','Filtered BP',...
                'Systolic BP','Diastolic BP'});
        case 3      % (airflow / ILV)
            set(puVarSpec,'string',{'Raw airflow','Integrated airflow',...
                'Instantaneous Lung Volume'});
    end
    set(puVarSpec,'value',1);
    set(scr,'userData',ind);
end
end

function viewData(~,~,dataList,puVar,puVarType,puVarSpec,puTime,teT0,...
    teTf,teFs)

varInd = get(puVar,'value');

if varInd == 1
else
    viewWindow = figure(5);
    set(viewWindow,'Units','Pixels','Position',[300 150 700 300],'Name',...
        '(ENE/UnB) CRSIDLab - View variables','NumberTitle','off',...
        'MenuBar','none','ToolBar','figure');
    
    curData = get(dataList,'userData');
    varString = get(puVar,'string');
    varName = varString(varInd);
    varValue = curData.(varName{:});
    
    timeInd = get(puTime,'value');
    if timeInd~=1
        timeString = get(puTime,'string');
        timeName = timeString(timeInd);
        time = curData.(timeName{:});
    else
        if ~isempty(get(teFs,'string')), fs=str2double(get(teFs,'string'));
        else, fs = 1;
        end
        time = ((0:length(varValue)-1)/fs);
        
    end
    
    % cutoff points
    if ~isempty(get(teT0,'string'))
        [~,ind] = min(abs(str2double(get(teT0,'string'))-time));
        t0 = time(ind);
    else
        t0 = 0;
    end
    if ~isempty(get(teTf,'string'))
        [~,ind] = min(abs(str2double(get(teTf,'string'))-time));
        tf = time(ind);
    else
        tf = time(end);
    end
        
    lo_lim=min(varValue)-0.05*abs(max(varValue)-min(varValue)); 
    hi_lim=max(varValue)+0.05*abs(max(varValue)-min(varValue));
    
    axes('parent',viewWindow,'units','pixels','Position',[70 50 600 200]);

    plot(time,varValue);
    line([t0 t0],[lo_lim hi_lim],'color','r')
    line([tf tf],[lo_lim hi_lim],'color','r')
    axis([time(1) time(end) lo_lim hi_lim]);
    xlabel('Time (s)');
    
    % add corresponding labels
    varType = get(puVarType,'value'); varSpec = get(puVarSpec,'value');
    switch varType
        case 1 % ECG / RRI
            if varSpec == 1
                varId = 'Raw Electrocardiogram (ECG)';
                yLab = 'Amplitude (mV)';
            elseif varSpec == 2
                varId = 'Filtered Electrocardiogram (ECG)';
                yLab = 'Amplitude (mV)';
            else
                varId = 'R-R Interval (RRI)';
                yLab = 'Amplitude (ms)';
            end
        case 2 % BP / SBP / DBP
            yLab = 'BP (mmHg)';
            if varSpec == 1, varId = 'Raw Blood Pressure';
            elseif varSpec == 2, varId = 'Filtered Blood Pressure';
            elseif varSpec == 3, varId = 'Systolic Blood Pressure (SBP)';
            else, varId = 'Diastolic Blood Pressure (DBP)';
            end
        case 3 % airflow / ILV
            if varSpec == 1
                varId = 'Raw airflow';
                yLab = 'Airflow (L/s)';
            elseif varSpec == 2
                varId = 'Integrated airflow (not detrended)';
                yLab = 'Int. airflow (L)';
            elseif varSpec == 3
                varId = 'Instantaneous Lung Volume';
                yLab = 'ILV (L)';
            end
    end
    title(varId); ylabel(yLab);
end
end

function add2file(~,~,tempData,dataList,userOpt,addedData,lbImported,...
    puVar,puVarType,puVarSpec,puTime,puFs,teT0,teTf,teFs)

% add2file Adds data to temporary patient object
%     add2file(scr,event,tempData,dataList,userOpt,addedData,lbImported,
%     puVar,puVarType,puVarSpec,puTime,puFs,teT0,teTf,teFs) checks if all
%     data entered is valid and if so adds data to the corresponding
%     property in the temporary patient object, stored in tempData's 
%     userData property. Adds data set to lbImported's string.
%
% original Matlab code: Luisa Santiago C. B. da Silva, Feb. 2017

errStat = 0;                            % error status
curData = get(dataList,'userData');     % variables names and values
options = get(userOpt,'userData');      % data options
listString = get(lbImported,'string');
patient = get(tempData,'userData');     % patient data object
storedData = get(addedData,'userData'); % store added data

% check for errors before adding data to temp patient object
if get(puVar,'value') == 1
    uiwait(errordlg(sprintf(['No main variable indicated.\nThe main ',...
        'variable must be indicated in order to be added to the ',...
        'patient file.']),'Add to Patient File Error','modal'));
    errStat = 1;
else
    % get variable type
    varType = get(puVarType,'value');
    varSpec = get(puVarSpec,'value');    
    
    if (varType==1 && varSpec==1 && ~isempty(patient.sig.ecg.raw.data)) ...
            || (varType==1 && varSpec==2 && ~isempty(...
            patient.sig.ecg.filt.data)) || (varType==1 && varSpec==3 && ...
            ~isempty(patient.sig.ecg.rri.data)) || (varType==2 && ...
            varSpec==1 && ~isempty(patient.sig.bp.raw.data)) || ...
            (varType==2 && varSpec==2 && ~isempty(...
            patient.sig.bp.filt.data)) || (varType==2 && varSpec==3 && ...
            ~isempty(patient.sig.bp.sbp.data)) || (varType==2 && ...
            varSpec==4 && ~isempty(patient.sig.bp.dbp.data)) || ...
            (varType==3 && varSpec==1 && ~isempty(...
            patient.sig.rsp.raw.data)) || (varType==3 && ...
            varSpec==2 && ~isempty(patient.sig.rsp.int.data)) || ...
            (varType==3 && varSpec==3 && isempty(options.create.resp.low)...
            && ~isempty(patient.sig.rsp.ilv.data)) || (varType==3 && ...
            varSpec==3 && ~isempty(options.create.resp.low) && ...
            ~isempty(patient.sig.rsp.filt.data))
        uiwait(errordlg(sprintf(['Variable already added.\nThe ',...
            'indicated data type was already added to the patient ',...
            'file. If you would like to replace it, first remove the ',...
            'variable from the patient file before adding the new ',...
            'one.']),'Add to Patient File Error','modal'));
        errStat = 1;
    else
        if get(puTime,'value') == 1 && isempty(get(teFs,'string'))
            if ((varType~=1 && varType~=2) || varSpec<3)
                [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
                    'timeSpecPref','Time Specification',sprintf([...
                    'Warning!\nYou have either not selected a time ',...
                    'vector or not defined a sampling frequency.\nSome',...
                    'of the processing performed by this toolbox ',...
                    'requires time reference.\nIf you proceed without ',...
                    'supplying either a time vector or sampling ',...
                    'frequency,\nthe toolbox will consider the missing',...
                    'sampling frequency (fs) to be 1Hz.']),...
                    {'Add to patient file','Return to add information'},...
                    'DefaultButton','Return to add information');
                if strcmp(selButton,'return to add information') && dlgShow
                    errStat = 1;
                end
            else
                uiwait(errordlg(sprintf(['No time vector.\nWhen adding',...
                    'RRI, SBP or DBP, a time vector must be ',...
                    'supplied.']),'Add to Patient File Error','modal'));
                errStat = 1;
            end
        end
    end
end

% check variables validity
if ~errStat
    
    % get associated fs info
    if ~isnan(str2double(get(teFs,'string')))
        fsVal = str2double(get(teFs,'string'));
    else
        fsVal = [];
    end
    
    % get associated time vector info
    if get(puTime,'value')~=1
        timeInd = get(puTime,'value');
        timeString = get(puTime,'string'); 
        timeVal = curData.(timeString{timeInd});
    else
        timeVal = [];
        timeString = {'NoVar'};
        timeInd=1;
    end
    
    %check if sampling freq. is compatible with time array
    if ~isempty(fsVal) && ((varType~=1 && ...
            varType~=2) || varSpec<3)
        if abs(mean(diff(timeVal))-(1/fsVal))>0.001
            [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
                'fsSpecPref','Time Specification',sprintf(['Warning!',...
                '\nThe indicated sampling frequency (fs) differs from ',...
                'the mean frequency\ncalculated from the supplied time',...
                'array. This may be due to the digital\n ',...
                'representation of values, in this case this warning ',...
                'may be ignored.\nCheck if the correct variables were ',...
                'selected.']),{'Add to patient file',...
                'Return to change Fs value'},'DefaultButton',...
                'Return to change Fs value');
            if strcmp(selButton,'return to change fs value') && dlgShow
                errStat = 1;
            end
        end
    end 
end

if ~errStat
    
    % get variable info
    ind = get(puVar,'value');
    varString = get(puVar,'string');
    varName = varString{ind};
    varVal = curData.(varName);
    curData = rmfield(curData,varName);
    storedData.(timeString{timeInd}) = timeVal;
    storedData.(varName) = varVal;
    varName = ['(',varName,')        '];
    
    % build string parts
    timeName = []; fsName = [];
    if ~isempty(timeVal)
        timeName = ['[ Time: (',timeString{timeInd},') ] '];
    end
    if ~isempty(fsVal)
        fsName = ['[ Fs: ',get(teFs,'string'),'Hz ] ']; 
    end
           
    % add data to temporary patient object
    switch varType
        case 1 % ECG / RRI
            id = 'ecg';
            switch varSpec
                case 1, varId = 'Raw ECG data: '; type = 'raw';
                case 2, varId = 'Filtered ECG data: '; type = 'filt';
                case 3, varId = 'RRI data: '; type = 'rri';
            end
        case 2 % BP / SBP / DBP
            id = 'bp';
            switch varSpec
                case 1, varId = 'Raw BP data: '; type = 'raw';
                case 2, varId = 'Filtered BP data: '; type = 'filt';
                case 3, varId = 'SBP data: '; type = 'sbp';
                case 4, varId = 'DBP data: '; type = 'dbp';
            end
        case 3 % airflow / ILV
            id = 'rsp';
            switch varSpec
                case 1, varId = 'Raw airflow data: '; type = 'raw';
                case 2, varId = 'Integrated airflow data: '; type = 'int';
                case 3
                    if ~isempty(options.create.resp.low)
                        varId = 'Filtered ILV data: '; type = 'filt';
                    else
                        varId = 'ILV data: '; type = 'ilv';
                    end
            end
    end
    
    % build time array if not given by the user
    if ~isempty(timeVal) 
        if isempty(fsVal) && ((varType~=1 && varType~=2) || varSpec<3)
            fsVal = round(1 / mean(diff(timeVal)));
        end
    else
        if isempty(fsVal), fsVal = 1; end
        timeVal = ((0:length(varVal)-1)/fsVal);
    end
    
    % get associated t0 info
    if ~isnan(str2double(get(teT0,'string')))
        t0Val = str2double(get(teT0,'string'));
    else
        t0Val = timeVal(1);
    end 
    
    % get associated tf info
    if ~isnan(str2double(get(teTf,'string')))
        tfVal = str2double(get(teTf,'string'));
    else
        tfVal = timeVal(end);
    end 
    
    errMsg1 = [];errMsg2 = []; errStat = 0;
    if t0Val < timeVal(1)
        errMsg1 = ['\nStart time must be equal to or greater than the ',...
            'time array''s first value: ',num2str(timeVal(1)),' s.'];
        errStat = 1;
    end
    if tfVal > timeVal(end)
        errMsg2 = ['\nEnd time must be equal to or less than the ',...
            'time array''s last value: ',num2str(timeVal(end)),' s.'];
        errStat = 1;
    end 
    
    if errStat
        uiwait(errordlg(sprintf(['Time inconsistency:',errMsg1,errMsg2]),...
            'Add to Patient File Error','modal'));
    else
        tName = ['[ T0: ',num2str(t0Val),'s - Tf: ',num2str(tfVal),'s ] '];

        % add data to patient file
        patient.sig.(id).(type).data = varVal(find(timeVal>=t0Val,1):find(timeVal<=tfVal,1,'last'));
        if ~isempty(fsVal), patient.sig.(id).(type).fs = fsVal; end
        patient.sig.(id).(type).time = timeVal(find(timeVal>=t0Val,1):find(timeVal<=tfVal,1,'last'));
        patient.sig.(id).(type).specs = options.create.specs;
        if ismember(type,{'rri','sbp','dbp'})
            patient.sig.(id).(type).ectopic = options.create.var.ectopic;
        end

        % build new list line
        newLine = [varId,varName,timeName,tName,fsName];
        listString{end+1} = newLine;
        set(lbImported,'string',listString);    
        options.session.main.listString = listString;

        options.create.specs = struct;
        set(userOpt,'userData',options);      % clear data options
        set(dataList,'userData',curData);     % variables names and values
        set(tempData,'userData',patient);     % patient data object
        set(addedData,'userData',storedData); % store added data

        set(puVar,'value',1,'userData',1);
        set(puVar,'string',[' ' ; fieldnames(curData)]);
        set(puTime,'value',1,'userData',1);
        set(puTime,'string',[' ' ; fieldnames(curData)]);
        set(puFs,'value',1,'userData',1);
        set(puFs,'string',[' ' ; fieldnames(curData)]);
    end
end
end

function removeVar(~,~,tempData,dataList,userOpt,addedData,lbImported,...
    puVar,puTime,puFs)
% removeVar Removes data from temporary patient object
%     removeVar(scr,event,tempData,dataList,userOpt,addedData,lbImported,
%     puVar,puTime,puFs) removes data set indicated by lbImported's
%     value from the temporary patient object, stored in tempData's 
%     userData property. Returns the variables indicated from addedData's
%     userData property to dataList's userData property. Update all
%     popupmenu's strings.
%
% original Matlab code: Luisa Santiago C. B. da Silva, Feb. 2017

options = get(userOpt,'userData');
options.session.main.specs = struct;
curData = get(dataList,'userData');     % variables names and values
patient = get(tempData,'userData');     % patient data object
storedData = get(addedData,'userData'); % store added data

% remove variable from list
listString = get(lbImported,'string');
listInd = get(lbImported,'value');
if ~isempty(listInd)
    listLine = listString{listInd};
    set(lbImported,'value',[]);
    listString(listInd)=[];
    if isempty(listString), set(lbImported,'string','');
    else, set(lbImported,'string',listString);
    end

    % return variables to variable pool
    varSwc = 0;
    ind1 = strfind(listLine,'(');
    ind2 = strfind(listLine,')');

    varName = listLine(ind1(1)+1:ind2(1)-1);
    if isfield(curData,varName), varSwc = 1; end
    curData.(varName) = storedData.(varName);
    storedData = rmfield(storedData,varName);

    % clear data from patient object
    indVarId = strfind(listLine,':');
    varId = listLine(1:indVarId-1);

    switch varId
        case 'Raw ECG data', id = 'ecg'; type = 'raw';
        case 'Filtered ECG data', id = 'ecg'; type = 'filt';
        case 'RRI data', id = 'ecg'; type = 'rri';
        case 'Raw BP data', id = 'bp'; type = 'raw';
        case 'Filtered BP data', id = 'bp'; type = 'filt';
        case 'SBP data', id = 'bp'; type = 'sbp';
        case 'DBP data', id = 'bp'; type = 'dbp';
        case 'Raw airflow data', id = 'rsp'; type = 'raw';
        case 'Integrated airflow data', id = 'rsp'; type = 'int';
        case 'ILV data', id = 'rsp'; type = 'ilv';
        case 'Filtered ILV data', id = 'rsp'; type = 'filt';
    end
    patient.sig.(id).(type).data = [];
    patient.sig.(id).(type).time = [];
    patient.sig.(id).(type).fs = [];
    patient.sig.(id).(type).specs = struct;

    options.session.main.listString = listString;
    set(userOpt,'userData',options);      % clear options
    set(lbImported,'string',listString);     
    set(addedData,'userData',storedData);
    set(dataList,'userData',curData);     % variables names and values
    set(tempData,'userData',patient);     % patient data object

    % update menus
    swcVarName = cell(0); addVarName = cell(0);
    indSwc = 1; indAdd = 1;
    if varSwc, swcVarName{indSwc} = varName;
    else, addVarName{indAdd} = varName;
    end

    updateList(puVar,[],addVarName,swcVarName,patient);
    updateList(puTime,[],addVarName,swcVarName,patient);
    updateList(puFs,[],addVarName,swcVarName,patient);
end
end

function doneButton(~,~,userOpt,tempData,pFile,lbVar)
% doneButton Transfers data from temporary to main patient object
%     doneButton(scr,event,tempData,pFile,importWindow) transfers data from
%     temporary patient object in tempData's userData property to the main 
%     patient object in pFile's userData property, which is returned to the
%     main function and closes importWindow.
%
% original Matlab code: Luisa Santiago C. B. da Silva, Feb. 2017

temp = get(tempData,'userData');

% verify if ECG and BP records are in the same time axis
id = {'ecg','ecg','bp','bp'}; auxType = {'raw','filt','raw','filt'};
auxTime = []; errStat1 = 0; errStat2=0;
for i = 1:4
    if ~isempty(temp.sig.(id{i}).(auxType{i}).data)
        if ~isempty (auxTime)
            if length(auxTime) ~= length(temp.sig.(id{i}).(auxType{i}).time)
                errStat1 = 1;
            elseif auxTime ~= temp.sig.(id{i}).(auxType{i}).time
                errStat1 = 1;
            end
        end
        auxTime = temp.sig.(id{i}).(auxType{i}).time;
    end
end

% verify if all existing respiration records are in the same time axis
auxType = {'raw','int','ilv'}; auxTime2 = [];
for i = 1:3
    if ~isempty(temp.sig.rsp.(auxType{i}).data)
        if ~isempty (auxTime2)
            if auxTime2 ~= temp.sig.rsp.(auxType{i}).time
                errStat2 = 1;
            end
        end
        auxTime2 = temp.sig.rsp.(auxType{i}).time;
    end
end

errString = [];
if errStat1
    errString = '\nECG and BP records are not on the same time axis.';
end
if errStat2
    errString = [errString '\nAll respiration records are not on the same time axis.'];
end

% verify if variables match record of origin and create index
id = {'ecg','bp','bp'}; type = {'rri','sbp','dbp'};
varString1=struct; varString1.rri=[]; varString1.sbp=[]; varString1.dbp=[];
varString2=struct; varString2.rri=[]; varString2.sbp=[]; varString2.dbp=[];
for i = 1:3

    % check if both variable and original record exist
    if ~isempty(temp.sig.(id{i}).(type{i}).data)
        auxType = temp.sig.(id{i}).(type{i}).specs.type;
        if ~isempty(temp.sig.(id{i}).(auxType).data)
            auxTime = temp.sig.(id{i}).(type{i}).time;

            if i == 1 % add 1st R-wave
                auxTime = [auxTime(1) - ...
                    temp.sig.(id{i}).(type{i}).data(1)/1000;auxTime]; %#ok<AGROW>
            end

            if auxTime(end) >= temp.sig.(id{i}).(auxType).time(end) || ...
                    auxTime(1) <= temp.sig.(id{i}).(auxType).time(1)
                varString1.(type{i}) = ['\n ',upper(type{i})];
            else
                % find closest time stamps
                edges = [-Inf; mean([temp.sig.(id{i}).(auxType).time(2:end) ...
                    temp.sig.(id{i}).(auxType).time(1:end-1)],2); +Inf];
                [~, ind] = histc(auxTime, edges);
                if length(ind)>length(auxTime)
                    ind(length(auxTime)+1:end)=[]; 
                end

                temp.sig.(id{i}).(type{i}).index = ind;
                if max(auxTime-temp.sig.(id{i}).(auxType).time(ind))>0.0005
                    varString2.(type{i}) = ['\n ',upper(type{i})];
                end
            end
        end
    end
end
varStringFinal1 = [varString1.rri varString1.sbp varString1.dbp];
varStringFinal2 = [varString2.rri varString2.sbp varString2.dbp];

errStat3 = 0;
if ~isempty(varStringFinal1)
    if ~errStat1 && ~errStat2
        uiwait(errordlg(sprintf(['Variable does not match record.\n The ',...
            'time stamps provided for the following variables exceed the ',...
            'time range of the record indicated as its origin:',...
            varStringFinal1,'\nPlease adjust the variables before ',...
            'proceeding.']),'Variable Error','modal'));
    else
        uiwait(errordlg(sprintf(['Variable does not match record.\n ',...
            'The time stamps provided for the following variables ',...
            'exceed the time range of the record indicated as its ',...
            'origin:',varStringFinal1,'It has also been found that:',...
            errString,'\nPlease adjust the variables before ',...
            'proceeding.']),'Variable Error','modal'));
    end
    errStat3 = 1;
elseif errStat1 || errStat2
    uiwait(errordlg(sprintf(['It has been found that:',...
            errString,'\nPlease adjust the variables before ',...
            'proceeding.']),'Variable Error','modal'));
    errStat3 = 1;
elseif ~isempty(varStringFinal2)
    [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
        'varIndMainPref','Time stamp precision',sprintf(['Warning!',...
        '\nThe time stamps for the following variables differ from ',...
        'the closest time\nstamp found on the record indicated as its ',...
        'origin by more than 0.005 seconds:',varStringFinal2,...
        '\nWould you like to proceed?']),{'Yes','No'},'DefaultButton',...
        'No');
    if strcmp(selButton,'no') && dlgShow
        errStat3 = 1;
    end
end

if ~errStat3
    % update final variables list lbVar
    varList = cell(8,1); count1 = 1; count2 = 1;
    id = {'ecg','bp','rsp'};
    nameList = {'Raw ECG','Filtered ECG','RRI','Raw BP','Filtered BP',...
        'SBP','DBP','Airflow','Integrated airflow','ILV','Filtered ILV'};
    for i = 1:3
        switch id{i}
            case 'ecg', type = {'raw','filt','rri'};
            case 'bp', type = {'raw','filt','sbp','dbp'};
            case 'rsp', type = {'raw','int','ilv','filt'};
        end
        for j = 1:length(type)
            if ~isempty(temp.sig.(id{i}).(type{j}).data)
                varList{count1} = nameList{count2};
                count1 = count1+1;
                % reference time array to zero
                temp.sig.(id{i}).(type{j}).time = ...
                    temp.sig.(id{i}).(type{j}).time - ...
                    temp.sig.(id{i}).(type{j}).time(1);
            end
            count2 = count2+1;
        end
    end
    % remove empty cells
    varList = varList(~cellfun(@isempty,varList));
    set(lbVar,'string',varList);
    
    % save patient data
    set(tempData,'userData',temp);
    set(pFile,'userData',temp);

    options = get(userOpt,'userData');
    options.session.main.lbVar = varList;
    options.session.main.done = 1;
    set(userOpt,'userData',options);
    closereq;
end
end

function cancelButton(~,~,userOpt)
% cancelButton Clears data from variables list and closes window
%     cancelButton(scr,~,userOpt) clears all variables from 
%     temporary patient data object in tempData's userData property and 
%     closes importWindow.
%
% original Matlab code: Luisa Santiago C. B. da Silva, Feb. 2017

options = get(userOpt,'UserData');
if ~options.session.main.done
    options.session.main.listString = '';
    set(userOpt,'UserData',options);
end

closereq;
end