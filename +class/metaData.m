classdef metaData < handle

    properties
        %-----------------------------------------------------------------%
        File    char
        Type    char {mustBeMember(Type, {'Spectral data', 'Project data'})} = 'Spectral data'
        Data    class.specData
        Samples double
        Memory  double
    end


    methods
        %-----------------------------------------------------------------%
        function InitialFileReading(obj)            
            [~, fileName, fileExt] = fileparts(obj.File);
            
            switch lower(fileExt)
                % O formato .BIN é muito comum, sendo gerado pelo Logger, appColeta
                % e outras tantas aplicações. Essencial, portanto, ler os primeiros
                % bytes do arquivo, identificando no cabeçalho do arquivo o formato.
                case '.bin'
                    fileID = fopen(obj.File);
                    Format = fread(fileID, [1 36], '*char');
                    fclose(fileID);
    
                    if contains(Format, 'CRFS', 'IgnoreCase', true)
                        obj.Data = fileReader.CRFSBin(obj.File, 'MetaData', []);
                    elseif contains(Format, 'RFlookBin v.1', 'IgnoreCase', true)
                        obj.Data = fileReader.RFlookBinV1(obj.File, 'MetaData');
                    elseif contains(Format, 'RFlookBin v.2', 'IgnoreCase', true)
                        obj.Data = fileReader.RFlookBinV2(obj.File, 'MetaData');
                    else
                        Error(obj, 'metaData:Read:NotImplementedReader', fileName, fileExt)
                    end
                
                case '.dbm'
                    obj.Data = fileReader.CellPlanDBM(obj.File, 'MetaData', []);
                case '.sm1809'
                    obj.Data = fileReader.SM1809(obj.File,      'MetaData', []);
                case '.csv'
                    obj.Data = fileReader.ArgusCSV(obj.File,    'MetaData', []);
                case '.mat'
                    obj.Data = fileReader.MAT(obj.File,         'MetaData', []);
                otherwise
                    Error(obj, 'metaData:Read:UnexpectedFileFormat', fileName, fileExt)
            end

            obj.Samples = SamplesArray(obj, 1);
            obj.Memory  = EstimatedMemory(obj, 1);
            
            if isempty(obj.Samples)
                Error(obj, 'metaData:Read:EmptySpectralData', fileName, fileExt)
            end
        end


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


    methods (Access = private)
        %-----------------------------------------------------------------%
        function Error(obj, errorID, fileName, fileExt)
            switch errorID
                case 'metaData:Read:NotImplementedReader'
                    errorMsg = 'O arquivo indicado a seguir parece não ser de um dos formatos binários cuja leitura foi implantada no appAnalise.';
                case 'metaData:Read:UnexpectedFileFormat'
                    errorMsg = 'Não foi implementado leitor para o formato do arquivo indicado a seguir.';
                case 'metaData:Read:EmptySpectralData'
                    errorMsg = 'O arquivo indicado a seguir não possui informação espectral.';
            end
            error(errorID, [errorMsg '\n• %s'], [fileName fileExt])
        end


        %-----------------------------------------------------------------%
        function samplesArray = SamplesArray(obj, idx)
            samplesArray = arrayfun(@(x) sum(x.RelatedFiles.nSweeps), obj(idx).Data)';
        end
    end
end