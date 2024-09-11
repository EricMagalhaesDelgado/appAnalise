function htmlContent = htmlCode_ThreadInfo(dataSource, varargin)
    
    if isa(dataSource, 'class.metaData')
        idxFile    = varargin{1};
        idxThread  = varargin{2};    
        specData   = dataSource(idxFile).Data(idxThread);
        dataStruct = struct('group', 'GERAL',                                           ...
                            'value', struct('File',    dataSource(idxFile).File,        ...
                                            'Type',    dataSource(idxFile).Type,        ...
                                            'nData',   numel(dataSource(idxFile).Data), ...
                                            'Memory',  sprintf('%.3f MB', dataSource(idxFile).Memory)));
        dataStruct(end+1) = struct('group', 'RECEPTOR',  'value', dataSource(idxFile).Data(1).Receiver);

    else % 'class.specData'
        idxThread  = varargin{1};
        specData   = dataSource(idxThread);
        dataStruct = struct('group', 'RECEPTOR', 'value', specData(1).Receiver);
    end    
    
    if isscalar(specData)
        % Tempo de observação:
        if isa(dataSource, 'class.specData')
            dataStruct(end+1) = struct('group', 'TEMPO DE OBSERVAÇÃO', 'value', sprintf('%s - %s', datestr(specData.Data{1}(1),   'dd/mm/yyyy HH:MM:SS'), datestr(specData.Data{1}(end), 'dd/mm/yyyy HH:MM:SS')));
        end

        % Metadados:
        dataStruct(end+1) = struct('group', 'METADADOS', 'value', rmfield(specData.MetaData, {'DataType', 'FreqStart', 'FreqStop'}));        
        if specData.MetaData.Resolution ~= -1
            dataStruct(end).value.Resolution = sprintf('%.3f kHz', dataStruct(end).value.Resolution/1000);
        end

        if specData.MetaData.VBW ~= -1
            dataStruct(end).value.VBW = sprintf('%.3f kHz', dataStruct(end).value.VBW/1000);
        end

        % GPS e arquivos:
        dataStruct(end+1) = struct('group', 'GPS', 'value', specData.GPS);        
        dataStruct(end+1) = struct('group', 'FONTE DA INFORMAÇÃO',                                   ...
                                   'value', struct('File',    strjoin(specData.RelatedFiles.File, ', '), ...
                                                   'nSweeps', sum(specData.RelatedFiles.nSweeps)));

        for ii = 1:height(specData.RelatedFiles)
            BeginTime = datestr(specData.RelatedFiles.BeginTime(ii), 'dd/mm/yyyy HH:MM:SS');
            EndTime   = datestr(specData.RelatedFiles.EndTime(ii),   'dd/mm/yyyy HH:MM:SS');

            dataStruct(end+1) = struct('group', upper(specData.RelatedFiles.File{ii}),                                ...
                                       'value', struct('ID',              specData.RelatedFiles.ID(ii),               ...
                                                       'Task',            specData.RelatedFiles.Task{ii},             ...
                                                       'Description',     specData.RelatedFiles.Description{ii},      ...
                                                       'ObservationTime', sprintf('%s - %s', BeginTime, EndTime), ...
                                                       'nSweeps',         specData.RelatedFiles.nSweeps(ii),          ...
                                                       'RevisitTime',     sprintf('%.3f segundos', specData.RelatedFiles.RevisitTime(ii))));
        end
    end

    htmlContent = textFormatGUI.struct2PrettyPrintList(dataStruct, 'delete');
end