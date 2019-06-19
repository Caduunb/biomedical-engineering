classdef alignedUnit < dataPkg.dataUnit
    properties
        psd = dataPkg.psdUnit;
    end
    methods
        function obj = set.psd(obj,psd)
            if isa(psd,'dataPkg.psdUnit')
                obj.psd = psd;
            else
                error('psd must be a psdUnit object (dataPkg.psdUnit)')
            end
        end
    end
end