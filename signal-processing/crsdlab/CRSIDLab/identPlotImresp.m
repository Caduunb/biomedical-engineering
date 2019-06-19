function identPlotImresp(pHandle,pMod)
% imrespPlot Plots system data in imrespMenu
%   imrespData(pHandle,pMod) plots the model's impulse response in pMod's 
%   userData property to handle pHandle. Displays the point used to 
%   calculate the quantitative indicators extracted from the impulse 
%   response.
%
% Original Matlab code: Luisa Santiago C. B. da Silva, April 2017.
% Based on plotting funtions from ECGLab (Carvalho,2001)

model = get(pMod,'userData');
%Generate labels based on signal types
if strcmp(get(pHandle,'tag'),'in1')
    if ~isempty(model.InputName)
        yLabel = [model.OutputName{:},' from ',model.InputName{1},...
            ' input'];
    else
        yLabel = [model.OutputName{:},' from ',model.OutputName{:},...
            ' input'];
    end
    imresp = model.imResp.impulse{1};
else
    yLabel = [model.OutputName{:},' from ',model.InputName{2},' input'];
    imresp = model.imResp.impulse{2};
end
time = model.imResp.time;
    
% add 4 samples before impulse respose for better viewing
time = [time(1)-(4:-1:1)'*model.Ts; time]; %scale by 1/fs
imresp = [zeros(4,1); imresp];

if max(imresp)~=0, points = find(imresp==max(imresp),1);
else points = [];
end
points = sort([points;find(imresp~=0,1)-1]);
if min(imresp) ~=0
    points = sort([points;find(imresp==min(imresp),1)]);
end
if isempty(points), points = find(time==0); end

plot(pHandle,time,imresp,time(points),imresp(points),'r.');

for i=1:length(points)
    x1=time(points(i));
    y1=imresp(points(i));
    texto1=sprintf(['-[', num2str(x1),',',num2str(y1),']']);
    text(x1,y1,texto1,'fontname','Courier New','fontsize',9,...
        'hor','left','verticalalignment','middle','parent',pHandle);
end

loLim = min(imresp)-((max(imresp)-min(imresp))*.05);
hiLim = max(imresp)+((max(imresp)-min(imresp))*.05);
if loLim == hiLim, loLim = loLim - 1; hiLim = hiLim+1; end

line([0;0],[loLim; hiLim],'Color',[.5 .5 .5],'parent',pHandle)
axis(pHandle,[time(1) time(end) loLim hiLim]);
ylabel(pHandle,yLabel);
end