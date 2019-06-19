classdef patientInfo
    properties
        ID
        name
        age
        gender
        origin
        address
        phone
        email
        date
        protocol
        physExam
        clinHis
        famHis
    end

    methods
        function obj = set.ID(obj,ID)
            if isvarname(ID)
                obj.ID = ID;
            elseif isempty(ID) || strcmp(ID,'') || srtcmp(ID,' ')
                obj.ID = '';
            else
                error('Patient ID must be a valid file name')
            end
        end
    end
end