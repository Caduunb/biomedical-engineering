classdef ecgData
    properties
        raw = dataPkg.dataUnit;
        filt = dataPkg.dataUnit;
        rri = dataPkg.varUnit;
    end

    methods
        function obj = set.raw(obj,raw)
            if isa(raw,'dataPkg.dataUnit')
                obj.raw = raw;
            else
                error('raw must be a dataUnit object (dataPkg.dataUnit)')
            end
        end
        function obj = set.filt(obj,filt)
            if isa(filt,'dataPkg.dataUnit')
                obj.filt = filt;
            else
                error('filt must be a dataUnit object (dataPkg.dataUnit)')
            end
        end
        function obj = set.rri(obj,rri)
            if isa(rri,'dataPkg.varUnit')
                obj.rri = rri;
            else
                error('rri must be a varUnit object (dataPkg.varUnit)')
            end
        end
    end
end