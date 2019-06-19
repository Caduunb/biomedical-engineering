function imrespPlotModel(pHandle,pMod,valData)
% imrespPlotModel Plots model output data in imrespMenu
%   identPlotModel(pHandle,pMod,valData) plots the system output along with
%   the output predicted by the generated model, stored in pMod's userData
%   porperty to handle pHandle.
%
% Original Matlab code: Luisa Santiago C. B. da Silva, April 2017.
% Based on plotting funtions from ECGLab (Carvalho,2001)
% ident_plotamodelo Plots ARX/AR model output with measured output

model = get(pMod,'userData');

if strcmp(get(pHandle,'tag'),'est')
    time = model.simOutEst.SamplingInstants-model.simOutEst.ts;
    data = model.simOutEst.OutputData;
    if valData
        out = model.OutputData{1};
    else
        out = model.OutputData;
    end
    yLabel = ['Estimation (',model.OutputName{:},')'];
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
end