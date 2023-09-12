classdef metaData < handle

    properties
        %-----------------------------------------------------------------%
        File
        Type
        Data
        Samples
        Memory
    end


    methods
        %-----------------------------------------------------------------%
        function Read_MetaData(obj, RootFolder)
            
            [~, fileName, fileExt] = fileparts(obj.File);
            
            switch lower(fileExt)
                case '.bin'
                    fileID = fopen(obj.File);
                    Format = fread(fileID, [1 36], '*char');
                    fclose(fileID);
    
                    if contains(Format, 'CRFS', "IgnoreCase", true)
                        obj.Data = fileReader.CRFSBin(obj.File, 'MetaData', []);

                    elseif contains(Format, 'RFlookBin v.1/1', "IgnoreCase", true)
                        obj.Data = fileReader.RFlookBinV1(obj.File, 'MetaData');

                    elseif contains(Format, 'RFlookBin v.2/1', "IgnoreCase", true)
                        obj.Data = fileReader.RFlookBinV2(obj.File, 'MetaData');

                    else
                        error('metaData:Read:NotImplementedReader', 'O arquivo indicado a seguir parece não ser de um dos formatos binários cuja leitura foi implantada no appAnalise.\n• %s', [fileName fileExt])
                    end
                
                case '.dbm'
                    obj.Data = fileReader.CellPlanDBM(obj.File, 'MetaData', [], RootFolder);

                case '.sm1809'
                    obj.Data = fileReader.SM1809(obj.File, 'MetaData', []);
                    
                case '.csv'
                    obj.Data = fileReader.ArgusCSV(obj.File, 'SingleFile', []);

                case '.mat'
                    load(obj.File, '-mat', 'prj_metaData')
                    obj.Data = prj_metaData;                
            end

            obj.Samples = SamplesArray(obj, 1);
            obj.Memory  = EstimatedMemory(obj, 1);
            
            if isempty(obj.Samples)
                error('metaData:Read:EmptySpectralData', 'O arquivo indicado a seguir não possui informação espectral.\n• %s', [fileName fileExt])
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
       function fileSummary = FileSummary(obj, idx1, idx2)

            fileSummary = struct('group', 'GERAL',                                  ...
                                  'value', struct('File',    obj(idx1).File,        ...
                                                  'Type',    obj(idx1).Type,        ...
                                                  'nData',   numel(obj(idx1).Data), ...
                                                  'Memory',  sprintf('%.3f MB', obj(idx1).Memory)));

            if numel(idx2) == 1
                BeginTime = datestr(min(obj(idx1).Data(idx2).RelatedFiles.BeginTime), 'dd/mm/yyyy HH:MM:SS');
                EndTime   = datestr(max(obj(idx1).Data(idx2).RelatedFiles.EndTime),   'dd/mm/yyyy HH:MM:SS');
    
                fileSummary(2).group = 'RECEPTOR';
                fileSummary(2).value = struct('Receiver',        obj(idx1).Data(idx2).Receiver, ...
                                              'MetaData',        rmfield(obj(idx1).Data(idx2).MetaData, {'DataType', 'FreqStart', 'FreqStop'}));

                fileSummary(2).value.MetaData.Resolution = sprintf('%.3f kHz', fileSummary(2).value.MetaData.Resolution/1000);
    
                fileSummary(3).group = 'GPS';
                fileSummary(3).value = obj(idx1).Data(idx2).GPS;
    
                fileSummary(4).group = 'OUTROS ASPECTOS';
                fileSummary(4).value = struct('File',            strjoin(obj(idx1).Data(idx2).RelatedFiles.File, ', '),        ...
                                              'Task',            strjoin(obj(idx1).Data(idx2).RelatedFiles.Task, ', '),        ...
                                              'Description',     strjoin(obj(idx1).Data(idx2).RelatedFiles.Description, ', '), ...
                                              'ObservationTime', sprintf('%s - %s', BeginTime, EndTime),                       ...
                                              'nSweeps',         sum(obj(1).Data(1).RelatedFiles.nSweeps),                     ...
                                              'RevisitTime',     sprintf('%.3f segundos', mean(obj(1).Data(1).RelatedFiles.RevisitTime)));
            end
       end


        %-----------------------------------------------------------------%
        function estimatedMemory = EstimatedMemory(obj, idx)

            estimatedMemory = 0;
            for ii = 1:numel(obj(idx).Data)
                estimatedMemory = estimatedMemory + 4 * obj(idx).Data(ii).RelatedFiles.nSweeps .* obj(idx).Data(ii).MetaData.DataPoints .* 1e-6;
            end
        end
    end


    methods (Access = protected)
        %-----------------------------------------------------------------%
        function samplesArray = SamplesArray(obj, idx)

            samplesArray = [];
            for ii = 1:numel(obj(idx).Data)
                samplesArray = [samplesArray; obj(idx).Data(ii).RelatedFiles.nSweeps];
            end
        end
    end
end