classdef varUnit < dataPkg.ilvUnit
    properties
        ectopic
        index
    end
    methods   
        function obj = set.index(obj,index)
            valid = configIndex(obj,index);
            if valid
                if islogical(index), index = find(index); end
                obj.index = index(:);
            else
                error(['Index must be an array of positive integer',...
                    'or logical values'])
            end
        end 
        function obj = set.ectopic(obj,ectopic)
            valid = configEctopic(obj,ectopic);
            if valid
                if islogical(ectopic), ectopic = find(ectopic); end
                obj.ectopic = ectopic(:);
            else
                error(['Ectopic index must be an array of positive ',...
                    'integer or logical values that reference the ',...
                    'index property'])
            end
        end
    end
end

function valid = configIndex(obj,index)
valid = 1;
if ~isempty(obj.data) && ~isempty(index)
    if ~islogical(index) && ~all(index>0)
            valid = 0;
    end
end
end

function valid = configEctopic(obj,ectopic)
valid = 1;
if ~isempty(obj.data) && ~isempty(ectopic)
    try
        obj.data(ectopic);
    catch
        valid = 0;
    end
end
 end