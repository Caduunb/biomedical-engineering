classdef patientSys
    properties
        data = iddata;
        trends = iddata;
        models = struct;
    end
    methods
        function obj = set.data(obj,data)
            if isa(data,'iddata')
                obj.data = data;
            else
                error('data must be an iddata object')
            end
        end
        function obj = set.trends(obj,trends)
            if isa(trends,'iddata')
                obj.trends = trends;
            else
                error('trends must be an iddata object')
            end
        end
        function obj = set.models(obj,models)
            varName = fieldnames(models);
            for i = 1:length(varName)
                if ~isa(models.(varName{i}),'dataPkg.sysModel')
                    error(['models must be a struct and all fields ',...
                        'must be sysModel data objects.'])
                end
            end
            obj.models = models;
        end        
    end
end
