function psdPlot(pHandle,pSig,userOpt)
% psdPlot Plots a segment of data in psdMenu
%   psdPlot(pHandle,pSig,userOpt) plots a segment of the signal in pSig's
%   userData property, as indicated by options in userOpt's userData
%   property to handle pHandle.
%
% Original Matlab code: João Luiz Azevedo de Carvalho, 2002
% Adapted to fit new GUI: Luisa Santiago C. B. da Silva, April 2017.

options = get(userOpt,'userData');

if ~isempty(options.session.psd.sigLen)
    id = options.session.psd.sigSpec{1};
    type = options.session.psd.sigSpec{2};
    sig = get(pSig,'userData');
    
    % set labels according to data type
    if strcmp(id,'bp')
        yLabel = 'amplitude (mmHg²/Hz)';
    elseif strcmp(id,'rsp')
        yLabel = 'amplitude (L²/Hz)';
    else
        if strcmp(sig.(id).(type).aligned.specs.type,'rri')
            yLabel = 'amplitude (ms²/Hz)';
        else
            yLabel = 'amplitude (bpm²/Hz)';
        end
    end
    
    % plot all PSDs according to selected methods
    psdType = {'psdFFT','psdWelch','psdAR'};
    psdColor = {[0 0 1],[0 .5 0],[0 0 0]};
    switch options.session.psd.rbScale
        case 0
            for i = 1:3
                if options.session.psd.cbSelection(i)
                    plot(pHandle,sig.(id).(type).aligned.psd.freq,...
                        sig.(id).(type).aligned.psd.(psdType{i}),...
                        'color',psdColor{i})
                    hold(pHandle,'on');
                end
            end
        case 1
            for i = 1:3
                if options.session.psd.cbSelection(i)
                    semilogy(pHandle,sig.(id).(type).aligned.psd.freq,...
                        sig.(id).(type).aligned.psd.(psdType{i}),...
                        'color',psdColor{i})
                    hold(pHandle,'on');
                end
            end
        case 2
            for i = 1:3
                if options.session.psd.cbSelection(i)
                    loglog(pHandle,sig.(id).(type).aligned.psd.freq,...
                        sig.(id).(type).aligned.psd.(psdType{i}),...
                        'color',psdColor{i})
                    hold(pHandle,'on');
                end
            end
    end
    hold(pHandle,'off');

    % VLF, LF and HF band limits
    line([options.session.psd.vlf options.session.psd.lf ...
        options.session.psd.hf; options.session.psd.vlf ...
        options.session.psd.lf options.session.psd.hf],...
        [options.session.psd.minP options.session.psd.minP ...
        options.session.psd.minP; options.session.psd.maxP ...
        options.session.psd.maxP options.session.psd.maxP],'parent',...
        pHandle,'color','r');
    
    % fill areas
    if options.session.psd.fill
        
        % select PSD to fill area
        PSD = [];
        if options.session.nav.psd == 0 && ...
                ~isempty(sig.(id).(type).aligned.psd.psdFFT)
            PSD = sig.(id).(type).aligned.psd.psdFFT;
        elseif options.session.nav.psd == 1 && ...
               ~isempty(sig.(id).(type).aligned.psd.psdAR)
            PSD = sig.(id).(type).aligned.psd.psdAR;
        elseif options.session.nav.psd == 2 && ...
                ~isempty(sig.(id).(type).aligned.psd.psdWelch)
            PSD = sig.(id).(type).aligned.psd.psdWelch;   
        end
        
        if ~isempty(PSD)
            freq = sig.(id).(type).aligned.psd.freq;

            % finds frequency band limit indexes
            indVlf = round(options.session.psd.vlf/freq(2))+1;
            indLf = round(options.session.psd.lf/freq(2))+1;
            indHf = round(options.session.psd.hf/freq(2))+1;
            indEnd = round(options.session.psd.maxF/freq(2))+1;
            if indHf>length(freq), indHf=length(freq); end

            % fill areas
            if options.session.psd.rbScale == 2
              patch([freq(2),freq(2:indVlf)',freq(indVlf)],...
                  [options.session.psd.minP,PSD(2:indVlf)',...
                  options.session.psd.minP],[0 .5 0],'parent',pHandle);
            else
              patch([freq(1),freq(1:indVlf)',freq(indVlf)],...
                  [options.session.psd.minP,PSD(1:indVlf)',...
                  options.session.psd.minP],[0 .5 0],'parent',pHandle);
            end   

           patch([freq(indVlf),freq(indVlf:indLf)',freq(indLf)],...
               [options.session.psd.minP,PSD(indVlf:indLf)',...
               options.session.psd.minP],[.9 0 0],'parent',pHandle);
           patch([freq(indLf),freq(indLf:indHf)',freq(indHf)],...
               [options.session.psd.minP,PSD(indLf:indHf)',...
               options.session.psd.minP],[0 0 .8],'parent',pHandle);
           patch([freq(indHf),freq(indHf:indEnd)',freq(indEnd)],...
               [options.session.psd.minP,PSD(indHf:indEnd)',...
               options.session.psd.minP],[0.4 0.4 0.4],'parent',pHandle);
        end
    end
    
    axis(pHandle,[options.session.psd.minF options.session.psd.maxF ...
        options.session.psd.minP options.session.psd.maxP]);
    
    legendText = {'Fourier Transform','Welch method','AR Model'};
    legend(pHandle,legendText(logical(options.session.psd.cbSelection)),...
        'location',[.605 .12 .13 .1]);
    legend(pHandle,'boxoff');

    ylabel(pHandle,yLabel)
    grid(pHandle,'on'); 
    
    set(pSig,'userData',sig);
    set(userOpt,'userData',options);
    set(get(pHandle,'children'),'visible','on');
else
    ylabel(pHandle,'');
    set(get(pHandle,'children'),'visible','off');
end
end