classdef MetaData < handle

    properties
        %-----------------------------------------------------------------%
        File    char
        Type    char {mustBeMember(Type, {'Spectral data', 'Project data'})} = 'Spectral data'
        Data    model.SpecData
        Samples double
        Memory  double
    end


    methods
        %-----------------------------------------------------------------%
        function relatedFiles = RelatedFiles(obj)        
            relatedFiles = {};
            for ii = 1:numel(obj)
                for jj = 1:numel(obj(ii).Data)
                    relatedFiles = [relatedFiles; obj(ii).Data(jj).RelatedFiles.File];
                end
            end
            relatedFiles = unique(relatedFiles);
        end
    end
end