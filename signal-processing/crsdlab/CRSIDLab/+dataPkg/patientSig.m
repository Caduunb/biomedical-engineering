classdef patientSig
    properties
        ecg = dataPkg.ecgData;
        bp = dataPkg.bpData;
        rsp = dataPkg.rspData;
    end
    methods
        function obj = set.ecg(obj,ecg)
            if isa(ecg,'dataPkg.ecgData')
                obj.ecg = ecg;
            else
                error('ecg must be a ecgData object (dataPkg.ecgData)')
            end
        end
        function obj = set.bp(obj,bp)
            if isa(bp,'dataPkg.bpData')
                obj.bp = bp;
            else
                error('bp must be a bpData object (dataPkg.bpData)')
            end
        end
        function obj = set.rsp(obj,rsp)
            if isa(rsp,'dataPkg.rspData')
                obj.rsp = rsp;
            else
                error('rsp must be a rspData object (dataPkg.rspData)')
            end
        end   
    end
end