function analysisTab(pnAn,pFile,pSig,pSys,pMod,userOpt)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Analysis tab
%

tbPsd = uicontrol('parent',pnAn,'style','toggle','tag','psd','string',...
    'Power Spectral Density (PSD)','units','normalized','Position',...
    [0 .9565 .15 .042]);
pnPsd = uipanel('parent',pnAn,'units','normalized','position',...
    [0 0 1 .958],'visible','on');

tbIdent = uicontrol('parent',pnAn,'style','toggle','tag','ident',...
    'string','System Identification','units','normalized','Position',...
    [.149 .9565 .11 .042]);
pnIdent = uipanel('parent',pnAn,'units','normalized','position',...
    [0 0 1 .958],'visible','off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Set callback functions
%

set(tbPsd,'callback',{@tabChange,tbPsd,pnPsd,tbIdent,pnIdent,pFile,pSig,...
    pSys,pMod,userOpt});
set(tbIdent,'callback',{@tabChange,tbPsd,pnPsd,tbIdent,pnIdent,pFile,...
    pSig,pSys,pMod,userOpt});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Set current selected tab
%

options = get(userOpt,'userData');
switch options.session.nav.an
    case 0
        set(tbPsd,'value',1);
        tabChange(tbPsd,[],tbPsd,pnPsd,tbIdent,pnIdent,pFile,pSig,pSys,...
            pMod,userOpt);
    case 1
        set(tbIdent,'value',1);
        tabChange(tbIdent,[],tbPsd,pnPsd,tbIdent,pnIdent,pFile,pSig,...
            pSys,pMod,userOpt);
end
end

function tabChange(scr,~,tbPsd,pnPsd,tbIdent,pnIdent,pFile,pSig,pSys,...
    pMod,userOpt)
% changes between tabs: PSD tab & system identification tab

% verifiy if there is unsaved data in the previous tab before changing
errStat = 0; dispDialog = 0;
options = get(userOpt,'userData');
switch options.session.nav.an
    case 0                                  % PSD analysis tab
        if ~strcmp(get(scr,'tag'),'psd') && ...
                ~isempty(options.session.psd.sigLen)
            pat = get(pFile,'userData');
            signals = get(pSig,'userData');
            id = options.session.psd.sigSpec{1};
            type = options.session.psd.sigSpec{2};
            if ~options.session.psd.saved && ...
                    ((options.session.psd.cbSelection(1) && ~isequal(...
                    pat.sig.(id).(type).aligned.psd.psdFFT,...
                    signals.(id).(type).aligned.psd.psdFFT)) || ...
                    (options.session.psd.cbSelection(2) && ~isequal(...
                    pat.sig.(id).(type).aligned.psd.psdAR,...
                    signals.(id).(type).aligned.psd.psdAR)) || ...
                    (options.session.psd.cbSelection(1) && ~isequal(...
                    pat.sig.(id).(type).aligned.psd.psdWelch,...
                    signals.(id).(type).aligned.psd.psdWelch)))
                dispDialog = 1;
            end
        end
    case 1                                  % system identification tab
        if ~strcmp(get(scr,'tag'),'ident')
            switch options.session.nav.ident
                case 0                      % create new system
                    if ~options.session.sys.saved && (...
                            options.session.sys.filtered || ...
                            options.session.sys.detrended)
                        dispDialog = 1;
                    end
                case 1                      % model estimation
                    saved = 0;
                    if options.session.ident.sysLen(1) ~= 0
                        patient = get(pFile,'userData');
                        model = get(pMod,'userData');
                        sysName = options.session.ident.sysKey{...
                            options.session.ident.sysValue-1};
                        prevMod = fieldnames(patient.sys.(sysName).models);
                        if ~isempty(prevMod)
                            for i = 1:length(prevMod)
                                if isequal(patient.sys.(...
                                        sysName).models.(prevMod{...
                                        i}).Theta,model.Theta) && ...
                                        isequal(patient.sys.(...
                                        sysName).models.(prevMod{...
                                        i}).Type,model.Type)
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
if get(scr,'value') == 1 && dispDialog
    [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
        'changeTabAnPref','Change tabs',sprintf(['Warning!\nThe ',... 
        'current data has not been saved. Any modifications will ',...
        'be lost if the tabs are switched at this point.\nAre you ',...
        'sure you wish to proceed?']),{'Yes','No'},'DefaultButton',...
        'No');
    if strcmp(selButton,'no') && dlgShow
        errStat = 1;        % set up flags if user chooses to move on
    elseif options.session.nav.an == 1      % system identification tab
        switch options.session.nav.ident
            case 0                          % create new system
                options.session.sys.filtered = 0;
                options.session.sys.detrended = 0;
            case 1                          % model estimation
                options.session.ident.modelGen = 0;
                options.session.ident.sysLen = [0 0 0];
        end
    end  
end

% switch tabs (adjust toggle buttons and call tab script)
if get(scr,'value') == 1 && ~errStat
    set(scr,'backgroundcolor',[1 1 1]);
    switch get(scr,'tag')
        case 'psd'                          % PSD tab
            options.session.nav.an = 0;
            set(userOpt,'userData',options);
            set(tbIdent,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnIdent,'visible','off'); delete(get(pnIdent,'children'));
            psdMenu(pnPsd,pFile,pSig,userOpt);
            set(pnPsd,'visible','on');
        case 'ident'                        % system identification tab
            options.session.nav.an = 1;
            set(userOpt,'userData',options);
            set(tbPsd,'value',0,'backgroundcolor',[.94 .94 .94]);
            set(pnPsd,'visible','off'); delete(get(pnPsd,'children'));
            identTab(pnIdent,pFile,pSys,pMod,userOpt);
            set(pnIdent,'visible','on');
    end
else
    if get(scr,'value') == 1
        set(scr,'value',0);
    else
        set(scr,'value',1);
    end
end
end