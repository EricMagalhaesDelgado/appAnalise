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

        %-----------------------------------------------------------------%
        function estimatedMemory = EstimatedMemory(obj, idx)        
            estimatedMemory = 0;
            for ii = 1:numel(obj(idx).Data)
                estimatedMemory = estimatedMemory + 4 * sum(obj(idx).Data(ii).RelatedFiles.nSweeps) .* obj(idx).Data(ii).MetaData.DataPoints .* 1e-6;
            end
        end
    end
end