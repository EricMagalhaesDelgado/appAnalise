function nodeSummary = SelectedNodeSummary(app, Type, idx)

    nodeSummary = struct('group', {}, 'value', {});

    Flag = false;
    switch Type
        case 'app.metaData'
            idx1 = idx{1};
            idx2 = idx{2};

            Data = app.metaData(idx1).Data(idx2);
            if isscalar(idx2)
                Flag = true;
            end

            nodeSummary(end+1) = struct('group', 'GERAL',                                          ...
                                        'value', struct('File',    app.metaData(idx1).File,        ...
                                                        'Type',    app.metaData(idx1).Type,        ...
                                                        'nData',   numel(app.metaData(idx1).Data), ...
                                                        'Memory',  sprintf('%.3f MB', app.metaData(idx1).Memory)));

        case 'app.specData'
            Data = app.specData(idx);
            if isscalar(idx)
                Flag = true;
            end
    end

    
    if Flag
        nodeSummary(end+1) = struct('group', 'RECEPTOR',                       ...
                                    'value', struct('Receiver', Data.Receiver, ...
                                                    'MetaData', rmfield(Data.MetaData, {'DataType', 'FreqStart', 'FreqStop'})));
        
        if Data.MetaData.Resolution ~= -1
            nodeSummary(end).value.MetaData.Resolution = sprintf('%.3f kHz', nodeSummary(end).value.MetaData.Resolution/1000);
        end

        if Data.MetaData.VBW ~= -1
            nodeSummary(end).value.MetaData.VBW = sprintf('%.3f kHz', nodeSummary(end).value.MetaData.VBW/1000);
        end
        
        nodeSummary(end+1) = struct('group', 'GPS', ...
                                    'value', Data.GPS);
        
        nodeSummary(end+1) = struct('group', 'FONTE DA INFORMAÇÃO',                                   ...
                                    'value', struct('File',    strjoin(Data.RelatedFiles.File, ', '), ...
                                                    'nSweeps', sum(Data.RelatedFiles.nSweeps)));

        for ii = 1:height(Data.RelatedFiles)
            BeginTime = datestr(Data.RelatedFiles.BeginTime(ii), 'dd/mm/yyyy HH:MM:SS');
            EndTime   = datestr(Data.RelatedFiles.EndTime(ii),   'dd/mm/yyyy HH:MM:SS');

            nodeSummary(end+1) = struct('group', upper(Data.RelatedFiles.File{ii}),                                ...
                                        'value', struct('ID',              Data.RelatedFiles.ID(ii),               ...
                                                        'Task',            Data.RelatedFiles.Task{ii},             ...
                                                        'Description',     Data.RelatedFiles.Description{ii},      ...
                                                        'ObservationTime', sprintf('%s - %s', BeginTime, EndTime), ...
                                                        'nSweeps',         Data.RelatedFiles.nSweeps(ii),          ...
                                                        'RevisitTime',     sprintf('%.3f segundos', Data.RelatedFiles.RevisitTime(ii))));
        end
    end
end