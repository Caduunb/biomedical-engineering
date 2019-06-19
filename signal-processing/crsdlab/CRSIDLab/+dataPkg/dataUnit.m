classdef dataUnit
    properties
        data
        time
        fs
        specs = struct;
    end
    
    methods
        function obj = set.data(obj,data)
            if (isnumeric(data) && length(data)>=1) || isempty(data)
                valid = configData(obj,data,'data');
                if valid
                    obj.data = data(:);
                else
                    error('Data must be the same length as time')
                end
            else
                error('Data must be a numeric array')
            end
        end
        function obj = set.time(obj,time)
            if (isnumeric(time) && length(time)>=1) || isempty(time)
                valid = configData(obj,time,'time');
                if valid
                    obj.time = time(:);
                else
                    error('Data must be the same length as time');
                end
            else
                error('Time must be a numeric array')
            end
        end
        function obj = set.fs(obj,fs)
            if (isnumeric(fs) && length(fs)==1 && fs>=0) || isempty(fs)
                obj.fs = fs;
            else
                error(['Sampling frequency (fs) must be a positive ',...
                    'single numeric value'])
            end
        end
    end
end

 function valid = configData(obj,arg,nameArg)
    valid = 1;
    
    if strcmpi(nameArg,'data')
        t = obj.time;
        d = arg;
    else
        t = arg;
        d = obj.data;
    end
    
    if ~isempty(t) && ~isempty(d)
        if length(t) ~= length(d)
            valid = 0;
        end
    end
 end