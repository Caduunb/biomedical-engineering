function mainRecEdit(~,~,txRecord,pFile,userOpt)
% mainRecEdit Opens window to edit patient record information on mainTab
%     mainRecEdit(~,~,teID,txRecord,pData,pInfo,userOpt) opens a window
%     with a form for the user to fill. If the info property of the patient
%     data object in pData's userData property is already filled, this
%     information is displayed for the user to edit. The edited / new
%     information is stored in pInfo's userData property. txRecord is
%     updated to display the edited / new information on the main tab.
%
% original Matlab code: Luisa Santiago C. B. da Silva, Feb. 2017

patient = get(pFile,'userData');
pID = patient.info.ID;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Create patient record editing window
%

recordWindow = figure(2);
set(recordWindow, 'MenuBar', 'none');
set(recordWindow,'Units','Pixels','Position',[100 100 500 590]);
set(recordWindow,'Name','(ENE/UnB) CRSIDLab - Edit Patient Record');
set(recordWindow,'NumberTitle','off');

% user instructions display
pRecord = sprintf(['Patient ID: \n\n\n\nName:\n\nAge:\n\nGender:\n\n',...
    'Place of Origin:\n\nAddress:\n\nPhone:\n\nE-mail address:\n\n\n\n',...
    'Exam date:\n\nExperimental\nprotocol:\n\n\nPhysical Exam:\n\n\n\n',...
    '\n\nClinical History:\n\n\n\nFamily History:']);

uicontrol('parent',recordWindow,'style','text','string',pRecord,'hor',...
    'left','backgroundcolor',get(0,'defaultfigurecolor'),'Position',...
    [25 45 100 525]);

uicontrol('parent',recordWindow,'style','text','string',pID,'hor',...
    'left','backgroundcolor',get(0,'defaultfigurecolor'),'Position',...
    [110 555 200 15]);

% user editing fields
teName = uicontrol('parent',recordWindow,'style','edit','hor','left',...
    'Position',[110 496 360 25]);
teAge = uicontrol('parent',recordWindow,'style','edit','hor','left',...
    'Position',[110 467 360 25]);
teGender = uicontrol('parent',recordWindow,'style','edit','hor','left',...
    'Position',[110 438 360 25]);
teOrigin = uicontrol('parent',recordWindow,'style','edit','hor','left',...
    'Position',[110 409 360 25]);
teAddress = uicontrol('parent',recordWindow,'style','edit','hor','left',...
    'Position',[110 380 360 25]);
tePhone = uicontrol('parent',recordWindow,'style','edit','hor','left',...
    'Position',[110 351 360 25]);
teEmail = uicontrol('parent',recordWindow,'style','edit','hor','left',...
    'Position',[110 322 360 25]);
teDate = uicontrol('parent',recordWindow,'style','edit','hor','left',...
    'Position',[110 267 360 25]);
teProt = uicontrol('parent',recordWindow,'style','edit','hor','left',...
    'max',2,'Position',[110 213 360 50]);
tePhys = uicontrol('parent',recordWindow,'style','edit','hor','left',...
    'max',2,'Position',[110 159 360 50]);
teClinHis = uicontrol('parent',recordWindow,'style','edit','hor','left',...
    'max',2,'Position',[110 79 360 50]);
teFamHis = uicontrol('parent',recordWindow,'style','edit','hor','left',...
    'max',2,'Position',[110 25 360 50]);

% set text edit strings from patient record
updateEdit(pFile,teName,teAge,teGender,teOrigin,teAddress,tePhone,...
    teEmail,teDate,teProt,tePhys,teClinHis,teFamHis);

% update record button
uicontrol('parent',recordWindow,'style','push','string','Update Record',...
    'callback',{@updateCallback,txRecord,teName,teAge,teGender,teOrigin,...
    teAddress,tePhone,teEmail,teDate,teProt,tePhys,teClinHis,teFamHis,...
    pFile,userOpt,recordWindow},'Position',[370 540 100 25]);

end

function updateEdit(pFile,teName,teAge,teGender,teOrigin,teAddress,...
    tePhone,teEmail,teDate,teProt,tePhys,teClinHis,teFamHis)

patient = get(pFile,'userData');

set(teName,'string',patient.info.name);
set(teAge,'string',patient.info.age);
set(teGender,'string',patient.info.gender);
set(teOrigin,'string',patient.info.origin);
set(teAddress,'string',patient.info.address);
set(tePhone,'string',patient.info.phone);
set(teEmail,'string',patient.info.email);
set(teDate,'string',patient.info.date);
set(teProt,'string',patient.info.protocol);
set(tePhys,'string',patient.info.physExam);
set(teClinHis,'string',patient.info.clinHis);
set(teFamHis,'string',patient.info.famHis);
end

function updateCallback(~,~,txRecord,teName,teAge,teGender,teOrigin,...
    teAddress,tePhone,teEmail,teDate,teProt,tePhys,teClinHis,teFamHis,...
    pFile,userOpt,recordWindow)

% get patient record from patientInfo data object
patient = get(pFile,'userData');

% get user input on all fields    
patient.info.name = get(teName,'string');
patient.info.age = get(teAge,'string');
patient.info.gender = get(teGender,'string');
patient.info.origin = get(teOrigin,'string');
patient.info.address = get(teAddress,'string');
patient.info.phone = get(tePhone,'string');
patient.info.email = get(teEmail,'string');
patient.info.date = get(teDate,'string');

% format multiline text input
patient.info.protocol = formatting(get(teProt,'string'));
patient.info.physExam = formatting(get(tePhys,'string'));
patient.info.clinHis = formatting(get(teClinHis,'string'));
patient.info.famHis = formatting(get(teFamHis,'string'));

% save patient record to patientInfo and patient data objects
set(pFile,'userData',patient);
options = get(userOpt,'userData');
filename = options.session.filename;
save(filename,'patient');
info = patient.info;

% display patient record on main window
pRecord = sprintf(['\n        Patient ID:  ',info.ID,'\n\n        ',...
    'Name:  ',info.name,'\n        Age:  ',info.age,'\n        Gender:',...
    '  ',info.gender,'\n        Place of origin:  ',info.origin,'\n   ',...
    '     Address:  ',info.address,'\n        Phone:  ',info.phone,'\n',...
    '        E-mail address:  ',info.email,'\n\n        Exam date:  ',...
    info.date,'\n\n        Experimental protocol:  ',info.protocol,...
    '\n\n        Physical exam:  ',info.physExam,'\n\n        Clinical',...
    ' history:  ',info.clinHis,'\n\n        Family history:  ',...
    info.famHis]);
set(txRecord,'string',pRecord)

pRecord2 = sprintf(['Patient ID:  ',info.ID,'\n\nName:  ',info.name,...
    '\nAge:  ',info.age,'\nGender:',info.gender,'\nPlace of origin:  ',...
    info.origin,'\nAddress:  ',info.address,'\nPhone:  ',info.phone,...
    '\nE-mail address:  ',info.email,'\n\nExam date:  ',info.date,...
    '\n\nExperimental protocol:  ',info.protocol,'\n\nPhysical exam:  ',...
    info.physExam,'\n\nClinical history:  ',info.clinHis,...
    '\n\nFamily history:  ',info.famHis]);

options.session.main.txRecord = pRecord2;
set(userOpt,'userData',options);

% close window
close(recordWindow);
end

function infoForm = formatting(info)

if size(info,1)>1
    infoForm = char(zeros(1,(2+size(info,1))*size(info,2)));
    totalSize = 0;
    for i=1:size(info,1)
        finalInd = find(info(i,:)~=' ',1,'last'); % find last valid index 
        infoForm((1:finalInd+2)+totalSize) = [info(i,1:finalInd),', '];
        totalSize = totalSize+2+length(info(i,1:finalInd));
    end
    infoForm(totalSize-1:end)=[];
else
    infoForm = info;
end
end