classdef sysModel
    properties
        Name
        Type
        OutputData
        OutputName
        OutputUnit
        InputName
        InputUnit
        Ts
        Order
        Delay
        Theta
        SysMem
        Pole
        GenOrd
        fit
        simOutEst = iddata;
        simOutVal = iddata;
        imResp = dataPkg.imResp;
        Notes
    end
    methods
        function obj = set.Type(obj,Type)
            if ismember(Type,{'AR','ARX','LBF','MBF'}) || isempty(Type)
                obj.Type = Type;
            else
                error(['Model Type must be one of the following: AR, ',...
                    'ARX, LBF or MBF.']);
            end
        end  
        function obj = set.OutputName(obj,OutputName)
            if ismember(OutputName,{'RRI','HR','ILV','Filtered ILV',...
                    'SBP','DBP'}) || isempty(OutputName)
                obj.OutputName = OutputName;
            else
                error(['Model OutputName must be one of the following:',...
                    ' RRI, HR, ILV, Filtered ILV, SBP or DBP.']);
            end
        end 
        function obj = set.InputName(obj,InputName)
            if (all(ismember(InputName,{'RRI','HR','ILV','Filtered ILV',...
                    'SBP','DBP'})) && length(InputName) <= 2)  || ...
                    isempty(InputName)
                obj.InputName = InputName;
            else
                error(['Model InputName must be a cell array of size ',...
                    'equal to the number of system inputs and each ',...
                    'cell must correspond to one of the following: ',...
                    'RRI, HR, ILV, Filtered ILV, SBP or DBP.']);
            end
        end
        function obj = set.OutputUnit(obj,OutputUnit)
            if ismember(OutputUnit,{'ms','bpm','L','mmHg'}) || ...
                    isempty(OutputUnit)
                obj.OutputUnit = OutputUnit;
            else
                error(['Model OutputUnit must be one of the following:',...
                    ' ms, bpm, L or mmHg.']);
            end
        end
        function obj = set.InputUnit(obj,InputUnit)
            if (all(ismember(InputUnit,{'ms','bpm','L','mmHg'})) && ...
                    length(InputUnit) <= 2) || isempty(InputUnit)
                obj.InputUnit = InputUnit;
            else
                error(['Model InputUnit must be a cell array of size ',...
                    'equal to the number of system inputs and each ',...
                    'cell must correspond to one of the following: ',...
                    'ms, bpm, L or mmHg.']);
            end
        end
        function obj = set.Ts(obj,Ts)
            if (isnumeric(Ts) && length(Ts)==1 && Ts>=0) || isempty(Ts)
                obj.Ts = Ts;
            else
                error(['Model Ts (sampling period) must be a positive',...
                    ' numeric value.']);
            end
        end
        function obj = set.Order(obj,Order)
            if (isnumeric(Order) && all(Order>=0)) || isempty(Order)
                obj.Order = Order;
            else
                error('Model Order must be positive numeric values.');
            end
        end
        function obj = set.Delay(obj,Delay)
            if isnumeric(Delay) || isempty(Delay)
                obj.Delay = Delay;
            else
                error('Model Delay must be numeric values.');
            end
        end
        function obj = set.Theta(obj,Theta)
            if isnumeric(Theta) || isempty(Theta)
                obj.Theta = Theta;
            else
                error('Model Delay must be an array of numeric values.');
            end
        end
        function obj = set.SysMem(obj,SysMem)
            if (isnumeric(SysMem) && length(SysMem) == 1 && SysMem>=0)||...
                    isempty(SysMem)
                obj.SysMem = SysMem;
            else
                error('Model SysMem must be a postive numeric value.');
            end
        end
        function obj = set.Pole(obj,Pole)
            if (isnumeric(Pole) && length(Pole) == 1 && Pole>=0 && ...
                    Pole<=1) || isempty(Pole)
                obj.Pole = Pole;
            else
                error('Model Pole must be a numeric value between 0 and 1.');
            end
        end
        function obj = set.GenOrd(obj,GenOrd)
            if (isnumeric(GenOrd) && all(GenOrd>=0)) || isempty(GenOrd)
                obj.GenOrd = GenOrd;
            else
                error('Model GenOrd must be positive numeric values.');
            end
        end
        function obj = set.fit(obj,fit)
            if (isnumeric(fit) && all(fit>=-100) && all(fit<=100)) || ...
                    isempty(fit)
                obj.fit = fit;
            else
                error('Model fit must be numeric values between -100 and 100.');
            end
        end
        function obj = set.simOutEst(obj,simOutEst)
            if isa(simOutEst,'iddata') || isempty(simOutEst)
                obj.simOutEst = simOutEst;
            else
                error('simOutEst must be an iddata object')
            end
        end
        function obj = set.simOutVal(obj,simOutVal)
            if isa(simOutVal,'iddata')
                obj.simOutVal = simOutVal;
            else
                error('simOutVal must be an iddata object')
            end
        end
        function obj = set.imResp(obj,imResp)
            if isa(imResp,'dataPkg.imResp')
                obj.imResp = imResp;
            else
                error('imResp must be a sysImResp object (dataPkg.imResp)')
            end
        end
    end
end