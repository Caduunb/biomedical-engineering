function basisFunctionMenu(userOpt,teSysMem,tePole,teGenMin,teGenMax,...
    teNb1Min,teNb1Max,teNb2Min,teNb2Max)
% basisFunctionMenu Opens a window to display basis functions in identMenu
%
% Original Matlab code: Luisa Santiago C. B. da Silva, April 2017.
% Based on plotting funtions from ECGLab (Carvalho,2001)

options = get(userOpt,'userData');

sysMem = options.session.ident.sysMem;
p = options.session.ident.pole;
if options.session.ident.orMax
    ord = max(options.session.ident.param([3 5]));
    del = options.session.ident.gen(1);
else
    ord = max(options.session.ident.param([4 6]));
    del = max(options.session.ident.gen);
end

bfWindow = figure(3); clf(bfWindow);
set(bfWindow,'Position',[50 200 850 395],'Color',[.95 .95 .95]);

pHandle=axes('parent',bfWindow,'Units','normalized','Position',...
    [.076 .105 .76 .83]);

pnMenu=uipanel('parent',bfWindow,'Units','Normalized','Position',...
    [.855 .105 .12 .83],'BackgroundColor',[1 1 1]);
%[.855 .49 .12 .445] [.855 .105 .12 .385]
uicontrol('parent',pnMenu,'Style','text','String',sprintf(['System\n',...
    'memory']),'Units','Normalized','Position',[.05 .865 .9 .09],...
    'BackgroundColor',[1 1 1]);
tePoints=uicontrol('parent',pnMenu,'Style','edit','tag','points',...
    'String',num2str(sysMem),'CallBack','ident_bfcallbacks(1);','Units',...
    'Normalized','Position',[.25 .78 .5 .08],'BackgroundColor',[1 1 1]);

uicontrol('parent',pnMenu,'Style','text','String','Pole','Units',...
    'Normalized','Position',[.05 .705 .9 .05],'BackgroundColor',[1 1 1]);
teP=uicontrol('parent',pnMenu,'Style','edit','tag','pole','String',...
    num2str(p),'Units','Normalized','Position',[.25 .62 .5 .08],...
    'BackgroundColor',[1 1 1]);

uicontrol('parent',pnMenu,'Style','text','String',['Maximum number of',...
    ' functions'],'Units','Normalized','Position',[.05 .505 .9 .09],...
    'BackgroundColor',[1 1 1]);
teOrd=uicontrol('parent',pnMenu,'Style','edit','tag','order','String',...
    num2str(ord),'Units','Normalized','Position',[.25 .42 .5 .08],...
    'BackgroundColor',[1 1 1]);

txDelay=uicontrol('parent',pnMenu,'Style','text','String',['Maximum ',...
    'generalization order'],'Units','Normalized','Position',...
    [.05 .255 .9 .14],'BackgroundColor',[1 1 1]);
teDelay=uicontrol('parent',pnMenu,'Style','edit','tag','gen','String',...
    num2str(del),'CallBack',{@teCallback,tePoints,teP,teOrd,userOpt,...
    pHandle},'Units','Normalized','Position',[.25 .17 .5 .08],...
    'BackgroundColor',[1 1 1]);

uicontrol('parent',pnMenu,'Style','push','String','Apply','Callback',...
    {@setValues,userOpt,teSysMem,tePole,teGenMin,teGenMax,teNb1Min,...
    teNb1Max,teNb2Min,teNb2Max,tePoints,teP,teDelay,teOrd},'Units',...
    'Normalized','Position',[.2 .045 .6 .08]);

if options.session.ident.model == 1
    set(bfWindow,'Name','CRSIDLab - Laguerre basis functions')
    set(txDelay,'Enable','off');
    set(teDelay,'Enable','off');
else
    set(bfWindow,'Name','CRSIDLab - Meixner basis functions')
    set(txDelay,'Enable','on');
    set(teDelay,'Enable','on');
end

set(tePoints,'CallBack',{@teCallback,teP,teOrd,teDelay,userOpt,pHandle});
set(teP,'CallBack',{@teCallback,tePoints,teOrd,teDelay,userOpt,pHandle});
set(teOrd,'CallBack',{@teCallback,tePoints,teP,teDelay,userOpt,pHandle});

basisFcnPlot(pHandle,userOpt,sysMem,p,ord,del);
end

function teCallback(scr,~,te1,te2,te3,userOpt,pHandle)

A = str2double(get(scr,'string'));
switch get(scr,'tag')
    case 'points'
        loLim = 1; hiLim = inf;
        A = round(A);
    case 'pole'
        loLim = 0.001; hiLim = 0.999;
    case 'order'
        loLim = 1; hiLim = inf;
        A = round(A);
    case 'gen'
        loLim = 0; hiLim = inf;
        A = round(A);
end

if ~isnan(A)
    if (A >= loLim && A <= hiLim)
        value = A;
    elseif A < loLim
        value = loLim;
    else
        value = hiLim;
    end
end

set(scr,'string',num2str(value));

switch get(scr,'tag')
    case 'points'
        basisFcnPlot(pHandle,userOpt,value,str2double(get(te1,...
            'string')),str2double(get(te2,'string')),str2double(get(...
            te3,'string')));
    case 'pole'
        basisFcnPlot(pHandle,userOpt,str2double(get(te1,'string')),...
            value,str2double(get(te2,'string')),str2double(get(te3,...
            'string')));
    case 'order'
        basisFcnPlot(pHandle,userOpt,str2double(get(te1,'string')),...
            str2double(get(te2,'string')),value,str2double(get(te3,...
            'string')));
    case 'gen'
        basisFcnPlot(pHandle,userOpt,str2double(get(te1,'string')),...
            str2double(get(te2,'string')),str2double(get(te3,'string')),...
            value);
end
end

function setValues(~,~,userOpt,teSysMem,tePole,teGenMin,teGenMax,...
    teNb1Min,teNb1Max,teNb2Min,teNb2Max,tePoints,teP,teDelay,teOrd)

errStat = 0;
options = get(userOpt,'userData');
if strcmp(get(teNb2Min,'enable'),'on')
    showWarning = 0;
    if options.session.ident.orMax
        auxString = 'number';
        if str2double(get(teNb1Min,'string')) ~= ...
                str2double(get(teOrd,'string')) || ...
                str2double(get(teNb2Min,'string')) ~= ...
                str2double(get(teOrd,'string'))
            showWarning = 1;
        end
    else
        auxString = 'maximum number';
        if str2double(get(teNb1Max,'string')) ~= ...
                str2double(get(teOrd,'string')) || ...
                str2double(get(teNb2Max,'string')) ~= ...
                str2double(get(teOrd,'string'))
            showWarning = 1;
        end
    end
    if showWarning
        [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
            'changeOBFParameters2In','Change OBF orders',sprintf([...
            'Warning!','\nThe ',auxString,' of basis functions will be',...
            ' applied to both inputs.\n\nAre you sure you wish to ',...
            'continue?']),{'Yes','No'},'DefaultButton','No');
        if strcmp(selButton,'no') && dlgShow
            errStat = 1;
        end
    end
end

if ~options.session.ident.orMax
    genString = ''; ordString1 = ''; ordString2 = '';
    if str2double(get(teDelay,'string')) < options.session.ident.gen(1)
        genString = '\n Generalization order';
    end
    if str2double(get(teOrd,'string')) < options.session.ident.param(3)
        ordString1 = '\n Number of basis functions for the 1st input' ;
    end
    if strcmp(get(teNb2Min,'enable'),'on') && ...
            str2double(get(teOrd,'string'))< options.session.ident.param(5)
        ordString2 = '\n Number of basis functions for the 2nd input' ;
    end
    finalString = [genString,ordString1,ordString2];

    if ~ isempty(finalString)
        [selButton, dlgShow] = uigetpref('CRSIDLabPref',...
            'changeOBFParameters','Change OBF parameters',sprintf([...
            'Warning!','\nThe maximum value you are trying to set is ',...
            'lower\nthan the minimum value for the following ',...
            'parameters:',finalString,'\n\nAre you sure you wish to ',...
            'continue? If so, the minimum values\nwill be set equal to',...
            ' the maximum indicated.']),{'Yes','No'},'DefaultButton','No');
        if strcmp(selButton,'no') && dlgShow
            errStat = 1;
        end
    end
end

if ~errStat
    options.session.ident.sysMem = str2double(get(tePoints,'string'));
    options.session.ident.pole = str2double(get(teP,'string'));
    set(teSysMem,'String',get(tePoints,'string'));
    set(tePole,'String',get(teP,'string')); 
    
    if options.session.ident.orMax
        options.session.ident.gen(1) = str2double(get(teDelay,'string'));
        options.session.ident.param(3)=str2double(get(teOrd,'string'));
        options.session.ident.paramTru(3)=str2double(get(teOrd,'string'));
        options.session.ident.param(4) = str2double(get(teOrd,'string'));
        options.session.ident.paramTru(4)=str2double(get(teOrd,'string'));

        if strcmp(get(teNb2Min,'enable'),'on') 
            options.session.ident.param(5)=str2double(get(teOrd,'string'));
            options.session.ident.paramTru(5) = ...
                str2double(get(teOrd,'string'));
            set(teNb2Min,'String',get(teOrd,'string'));
        end
        
        set(teNb1Min,'String',get(teOrd,'string'));
        set(teGenMin,'String',get(teDelay,'string'));
    else
        if str2double(get(teDelay,'string')) < options.session.ident.gen(1)
            options.session.ident.gen(1)=str2double(get(teDelay,'string'));
            set(teGenMin,'String',get(teDelay,'string'));
        end
        options.session.ident.gen(2) = str2double(get(teDelay,'string'));

        if str2double(get(teOrd,'string')) < options.session.ident.param(3)
            options.session.ident.param(3)=str2double(get(teOrd,'string'));
            options.session.ident.paramTru(3)=...
                str2double(get(teOrd,'string'));
            set(teNb1Min,'String',get(teOrd,'string'));
        end
        options.session.ident.param(4) = str2double(get(teOrd,'string'));
        options.session.ident.paramTru(4)=str2double(get(teOrd,'string'));

        if strcmp(get(teNb2Min,'enable'),'on')
            if str2double(get(teOrd,'string')) < ...
                    options.session.ident.param(5)
                options.session.ident.param(5) = ...
                    str2double(get(teOrd,'string'));
                options.session.ident.paramTru(5) = ...
                    str2double(get(teOrd,'string'));
                set(teNb2Min,'String',get(teOrd,'string'));
            end
            options.session.ident.param(6)=str2double(get(teOrd,'string'));
            options.session.ident.paramTru(6) = ...
                str2double(get(teOrd,'string'));
            set(teNb2Max,'String',get(teOrd,'string'));
        end

        set(teNb1Max,'String',get(teOrd,'string'));
        set(teGenMax,'String',get(teDelay,'string'));
    end
    set(userOpt,'userData',options);
end
end

function basisFcnPlot(pHandle,userOpt,points,p,ord,del)
% ident_plotabf Plots Laguerre/Meixner basis functions for IDENT module

options = get(userOpt,'userData');
in = zeros(1,points); in(1)=1;

if options.session.ident.model == 1
    titleString = 'Laguerre basis functions'; 
    BF = laguerreFilt(in,ord,p,points);
else
    titleString = 'Meixner-like basis functions';
    BF = meixnerFilt(in,ord,p,del,points);
end

plot(pHandle,1:size(BF,1),BF)
title(pHandle,titleString)
xlabel(pHandle,'samples')
ylabel(pHandle,'amplitude')

legString = cell(1,size(BF,2));
for j=0:size(BF,2)-1
    legString{j+1} = num2str(j);
end
legend(pHandle,legString,'Location','EastOutside')
end

function M = meixnerFilt(in,n,p,gen,N)
%meixner_filt Filters data using Meixner-like filter
%
%   M=meixner_filt(in,n,p,gen) applies the Meixner-like filter of pole 'p'
%   (0<=p<=1) to data 'in'. The data in must be uniformly sampled for the
%   filter to be applied. Returns matrix M with 'n' columns, containing the
%   data filtered by 'n' Meixner-like filters with orders ranging from 0 to
%   n-1 and generalization order given by 'gen'.
%
%   Inputs
%   in: data to be filtered.
%   n:  number of applied Meixner-like filters.
%   p:  Meixner-like filter pole (must be a value between 0 and 1).
%   gen:generalization order that determines how late the Meixner-like
%   functions start to fluctuate.
%   N:  filter impulse response length.
%
%   Outputs
%   M:  Matrix containing filtered data with 'n' columns (first column
%   contains data filtered by 0 order Meixner filter, last column contains
%   data filtered by (n-1)-th order Meixner filter).

%número de funções de laguerre necessário para gerar k funções de meixner
j = max(gen)+n+1;

%filtro de laguerre
lag = laguerreFilt(in,j,p,N)';

%matriz U
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

function L = laguerreFilt(in,n,p,N)
%laguerre_filt Filters data using Laguerre filter
%
%   L=laguerre_filt(in,n,p) applies the Laguerre filter of pole 'p'
%   (0<=p<=1) to data 'in'. The data in must be uniformly sampled for the
%   filter to be applied. Returns matrix L with 'n' columns, containing the
%   data filtered by 'n' Laguerre filters with orders ranging from 0 to n-1.
%
%   Inputs
%   in: data to be filtered.
%   n:  number of applied Laguerre filters.
%   p:  Laguerre filter pole (must be a value between 0 and 1).
%   N:  filter impulse response length.
%
%   Outputs
%   L:  Matrix containing filtered data with 'n' columns (first column
%   contains data filtered by 0 order Laguerre filter, last column contains
%   data filtered by (n-1)-th order Laguerre filter).

L=zeros(n,length(in));
imp = zeros(1,N+1);
imp(1) = 1;

for j = 0 : n-1
    if j == 0 %order n=0
        B = [sqrt(1-p^2) 0];
        A = [1 -p];
    else
        B = conv(B,[-p 1]);
        A = conv(A,[1 -p]);
    end
    L_aux = filter(B,A,imp);
    L(j+1,:) = filter(L_aux,1,in);
end

L = L';

% This implementation is based on the paper "Use of Meixner Functions in 
% Estimation of Volterra Kernels of Nonlinear Systems With Delay" by Musa
% H. Asyali and Mikko Juusola, published on IEE Transactions on Biomedical
% Engineering vol. 52, no. 2, February 2005.
end