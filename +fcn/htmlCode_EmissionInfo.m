function [htmlContent, emissionTag, userDescription] = htmlCode_EmissionInfo(specData, idx, projectData, idxPeak, idxException)

    peaksTable      = projectData.peaksTable(idxPeak, :);
    exceptionList   = projectData.exceptionList(idxException, :);
    emissionTag     = sprintf('%.3f MHz ⌂ %.1f kHz', peaksTable.Frequency, peaksTable.BW);

    % Registrando registros diferentes de "Licenciada" em vermelho:
    if ~strcmp(peaksTable.Regulatory{1}, 'Licenciada')
        peaksTable.Regulatory{1} = sprintf('<font style="color: #c94756;">%s</font>', peaksTable.Regulatory{1});
    end

    if ~isempty(exceptionList) && ~strcmp(exceptionList.Regulatory{1}, 'Licenciada')
        exceptionList.Regulatory{1} = sprintf('<font style="color: #c94756;">%s</font>', exceptionList.Regulatory{1});
    end

    % Identificando registros que foram editados pelo usuário:
    columns2Compare = {'Regulatory', 'Service', 'Station', 'Description', 'Distance', 'Type', 'Irregular', 'RiskLevel'};
    for ii = 1:numel(columns2Compare)
        columnName = columns2Compare{ii};
        if isempty(exceptionList) || isequal(peaksTable.(columnName), exceptionList.(columnName))
            columnsDiff.(columnName) = string(peaksTable.(columnName));
        else
            columnsDiff.(columnName) = sprintf('<del>%s</del> → <font style="color: #c94756;">%s</font>', string(peaksTable.(columnName)), string(exceptionList.(columnName)));
        end
    end

    userDescription = '';
    detectionInfo   = jsondecode(peaksTable.Detection{1});    
    if isfield(detectionInfo, 'Description')
        userDescription = detectionInfo.Description;
        detectionInfo   = rmfield(detectionInfo, 'Description');        
    end

    dataStruct(1)  = struct('group', 'RECEPÇÃO',      'value', struct('Receiver', specData(idx).Receiver, ...
                                                                      'ObservationTime', sprintf('%s - %s', datestr(specData(idx).Data{1}(1),   'dd/mm/yyyy HH:MM:SS'), datestr(specData(idx).Data{1}(end), 'dd/mm/yyyy HH:MM:SS'))));
    
    dataStruct(2)  = struct('group', 'CLASSIFICAÇÃO', 'value', struct('Regulatory',      columnsDiff.Regulatory,  ...
                                                                      'Service',         columnsDiff.Service,     ...
                                                                      'Station',         columnsDiff.Station,     ...
                                                                      'Description',     columnsDiff.Description, ...
                                                                      'Distance',        columnsDiff.Distance,    ...
                                                                      'Type',            columnsDiff.Type,        ...
                                                                      'Irregular',       columnsDiff.Irregular,   ...
                                                                      'RiskLevel',       columnsDiff.RiskLevel));
    if ~isempty(userDescription)
        dataStruct(2).value.userDescription = sprintf('<font style="color: blue;">%s</font>', strjoin(userDescription));
    end
    
    dataStruct(3)  = struct('group', 'ALGORITMOS',    'value', struct('Occupancy',       jsondecode(peaksTable.occMethod{1}), ...
                                                                      'Detection',       detectionInfo,                       ...
                                                                      'Classification',  jsondecode(peaksTable.Classification{1})));

    htmlContent    = [sprintf('<p style="font-family: Helvetica, Arial, sans-serif; font-size: 16px; text-align: justify; line-height: 12px; margin: 5px; padding-top: 5px; padding-bottom: 10px;"><b>%s</b></p>', emissionTag) ...
                      textFormatGUI.struct2PrettyPrintList(dataStruct(1:2)), ...
                      '<p style="font-family: Helvetica, Arial, sans-serif; color: gray; font-size: 10px; text-align: justify; line-height: 12px; margin: 5px; padding-bottom: 10px;">&thinsp;&thinsp;&thinsp;&thinsp;&thinsp;&thinsp;&thinsp;____________________<br>&thinsp;̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ <br>A seguir são apresentadas informações acerca do método de aferição da ocupação e dos algoritmos de detecção e classificação da emissão.</p>' ...
                      textFormatGUI.struct2PrettyPrintList(dataStruct(3))];
end