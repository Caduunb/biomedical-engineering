classdef ilvUnit < dataPkg.dataUnit
    properties
        aligned = dataPkg.alignedUnit;
    end
    methods
        function obj = set.aligned(obj,aligned)
            if isa(aligned,'dataPkg.alignedUnit')
                obj.aligned = aligned;
            else
                error('aligned must be an alignedUnit object (dataPkg.alignedUnit)')
            end
        end
    end
end