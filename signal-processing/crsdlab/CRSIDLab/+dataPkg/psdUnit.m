classdef psdUnit
    properties
        psdFFT
        psdAR
        psdWelch
        freq
        specs = struct;
    end
    methods
        function obj = set.psdFFT(obj,psdFFT)
            if (isnumeric(psdFFT) && length(psdFFT)>1) || isempty(psdFFT)
                valid = configData(obj,psdFFT,'fft');
                if valid || isempty(psdFFT)
                    obj.psdFFT = psdFFT(:);
                else
                    error(['All PSD''s and the frequency array must be',...
                        ' the same length'])
                end
            else
                error('PSD must be a numeric array')
            end
        end
        
        function obj = set.psdAR(obj,psdAR)
            if (isnumeric(psdAR) && length(psdAR)>1) || isempty(psdAR)
                valid = configData(obj,psdAR,'ar');
                if valid || isempty(psdAR)
                    obj.psdAR = psdAR(:);
                else
                    error(['All PSD''s and the frequency array must be',...
                        ' the same length'])
                end
            else
                error('PSD must be a numeric array')
            end
        end
        
        function obj = set.psdWelch(obj,psdWelch)
            if (isnumeric(psdWelch) && length(psdWelch)>1) || isempty(psdWelch)
                valid = configData(obj,psdWelch,'welch');
                if valid || isempty(psdWelch)
                    obj.psdWelch = psdWelch(:);
                else
                    error(['All PSD''s and the frequency array must be',...
                        ' the same length'])
                end
            else
                error('PSD must be a numeric array')
            end
        end
        
        function obj = set.freq(obj,freq)
            if (isnumeric(freq) && length(freq)>1) || isempty(freq)
                valid = configData(obj,freq,'freq');
                if valid
                    obj.freq = freq(:);
                else
                    error(['All PSD''s and the frequency array must be',...
                        ' the same length'])
                end
            else
                error('PSD must be a numeric array')
            end
        end
    end
end

 function valid = configData(obj,arg,nameArg)
    valid = 1;
    
    fft = obj.psdFFT;
    ar = obj.psdAR;
    welch = obj.psdWelch;
    freq = obj.freq;
    
    if strcmpi(nameArg,'fft'), fft = [];
    elseif strcmpi(nameArg,'ar'), ar = [];
    elseif strcmpi(nameArg,'welch'), welch = [];
    else freq = [];
    end
    
    lenRef = max([length(fft), length(ar), length(welch), length(freq)]);
    
    if lenRef > 0
        if lenRef ~= length(arg)
            valid = 0;
        end
    end
 end