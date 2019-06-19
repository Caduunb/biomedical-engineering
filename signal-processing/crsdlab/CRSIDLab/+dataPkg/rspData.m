classdef rspData
    properties
        raw = dataPkg.dataUnit;
        int = dataPkg.dataUnit;
        ilv = dataPkg.ilvUnit;
        filt = dataPkg.ilvUnit;
    end

    methods
        function obj = set.raw(obj,raw)
            if isa(raw,'dataPkg.dataUnit')
                obj.raw = raw;
            else
                error('raw must be a dataUnit object (dataPkg.dataUnit)')
            end
        end
        function obj = set.int(obj,int)
            if isa(int,'dataPkg.dataUnit')
                obj.int = int;
            else
                error('int must be a dataUnit object (dataPkg.dataUnit)')
            end
        end
        function obj = set.ilv(obj,ilv)
            if isa(ilv,'dataPkg.ilvUnit')
                obj.ilv = ilv;
            else
                error('ilv must be an ilvUnit object (dataPkg.ilvUnit)')
            end
        end
        function obj = set.filt(obj,filt)
            if isa(filt,'dataPkg.ilvUnit')
                obj.filt = filt;
            else
                error('filt must be an ilvUnit object (dataPkg.ilvUnit)')
            end
        end 
    end
end