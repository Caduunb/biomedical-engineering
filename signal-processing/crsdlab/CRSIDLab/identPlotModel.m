function identPlotModel(pHandle,pMod,userOpt)
% identPlotModel Plots model output data in identMenu
%   identPlotModel(pHandle,pMod,userOpt) plots the system output along with
%   the output predicted by the generated model, stored in pMod's userData
%   porperty to handle pHandle.
%
% Original Matlab code: Luisa Santiago C. B. da Silva, April 2017.
% Based on plotting funtions from ECGLab (Carvalho,2001)

model = get(pMod,'userData');
options = get(userOpt,'userData');

if strcmp(get(pHandle,'tag'),'est')
    time = model.simOutEst.SamplingInstants-model.simOutEst.ts;
    data = model.simOutEst.OutputData;
    if options.session.ident.sysLen(2) == 2
        out = model.OutputData{1};
    else
        out = model.OutputData;
    end
    yLabel = ['Estimation (',model.OutputName{:},')'];
    legendText = {['Measured ',model.OutputName{:}],...
        ['Predicted ',model.OutputName{:}]};
else
    time = model.simOutVal.SamplingInstants-model.simOutVal.ts;
    data = model.simOutVal.OutputData;
    out = model.OutputData{2};
    yLabel = ['Validation (',model.OutputName{:},')'];
end

lo_lim=min(out)-0.05*abs(max(out)-min(out)); 
hi_lim=max(out)+0.05*abs(max(out)-min(out));

plot(pHandle,time,out,time,data);
axis(pHandle,[time(1) time(end) lo_lim hi_lim]);
ylabel(pHandle,yLabel);
if strcmp(get(pHandle,'tag'),'est')
    legend(pHandle,legendText,'location',[.6205 .1 .13 .07]);
    legend(pHandle,'boxoff')
end
end