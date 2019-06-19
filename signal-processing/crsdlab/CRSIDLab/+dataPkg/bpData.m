classdef bpData
    properties
        raw = dataPkg.dataUnit;
        filt = dataPkg.dataUnit;
        sbp = dataPkg.varUnit;
        dbp = dataPkg.varUnit;
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
        function obj = set.sbp(obj,sbp)
            if isa(sbp,'dataPkg.varUnit')
                obj.sbp = sbp;
            else
                error('sbp must be a varUnit object (dataPkg.varUnit)')
            end
        end
        function obj = set.dbp(obj,dbp)
            if isa(dbp,'dataPkg.varUnit')
                obj.dbp = dbp;
            else
                error('dbp must be a varUnit object (dataPkg.varUnit)')
            end
        end 
    end
end