function [htmlContent, emissionTag, userDescription, stationInfo] = htmlCode_EmissionInfo(specData, idxThread, idxEmission, projectData, idxPeak, idxException)

    peaksTable      = projectData.peaksTable(idxPeak, :);
    exceptionList   = projectData.exceptionList(idxException, :);
    emissionTag     = sprintf('%.3f MHz ⌂ %.1f kHz', peaksTable.Frequency, peaksTable.BW);

    % Destacando em VERMELHO registros que possuem situação diferente de 
    % "Licenciada" e, também, registros cujo número da estação é igual a -1.
    % Este último caso, contudo, é feito apenas se a tabela exceptionList 
    % estiver vazia.
    if ~strcmp(peaksTable.Regulatory{1}, 'Licenciada')
        peaksTable.Regulatory{1} = sprintf('<font style="color: red;">%s</font>', peaksTable.Regulatory{1});
    end

    if ~isempty(exceptionList) 
        if ~strcmp(exceptionList.Regulatory{1}, 'Licenciada')
            exceptionList.Regulatory{1} = sprintf('<font style="color: red;">%s</font>', exceptionList.Regulatory{1});
        end
    end

    % Identificando registros que foram editados pelo usuário:
    columns2Compare = {'Regulatory', 'Service', 'Station', 'Description', 'Distance', 'Type', 'Irregular', 'RiskLevel'};
    stationInfo = [];
    for ii = 1:numel(columns2Compare)
        columnName = columns2Compare{ii};
        if isempty(exceptionList) || isequal(peaksTable.(columnName), exceptionList.(columnName))
            columnsDiff.(columnName) = string(peaksTable.(columnName));
            stationInfo.(columnName) = peaksTable.(columnName);
        else
            columnsDiff.(columnName) = sprintf('<del>%s</del> → <font style="color: red;">%s</font>', string(peaksTable.(columnName)), string(exceptionList.(columnName)));
            stationInfo.(columnName) = exceptionList.(columnName);
        end
    end

    if strcmp(columnsDiff.Station, '-1')
        columnsDiff.Station = '<font style="color: red;">-1</font>';
    end

    % stationInfo 
    regexpTokens = regexp(stationInfo.Description, 'Fistel=(\d+),.*ID=#(\d+), Latitude=(-?\d+\.\d+)º, Longitude=(-?\d+\.\d+)º', 'tokens');
    if ~isempty(regexpTokens{1})
        stationInfo.Fistel    = int64(str2double(regexpTokens{1}{1}{1}));
        stationInfo.ID        = int32(str2double(regexpTokens{1}{1}{2}));
        stationInfo.Latitude  = str2double(regexpTokens{1}{1}{3});
        stationInfo.Longitude = str2double(regexpTokens{1}{1}{4});
    else
        stationInfo.ID        = [];
    end

    % HTML
    dataStruct(1) = struct('group', 'RECEPTOR',            'value', specData(idxThread).Receiver);
    dataStruct(2) = struct('group', 'TEMPO DE OBSERVAÇÃO', 'value', sprintf('%s - %s', datestr(specData(idxThread).Data{1}(1),   'dd/mm/yyyy HH:MM:SS'), datestr(specData(idxThread).Data{1}(end), 'dd/mm/yyyy HH:MM:SS')));    
    dataStruct(3) = struct('group', 'CLASSIFICAÇÃO',       'value', struct('Regulatory',      columnsDiff.Regulatory,  ...
                                                                           'Service',         columnsDiff.Service,     ...
                                                                           'Station',         columnsDiff.Station,     ...
                                                                           'Description',     columnsDiff.Description, ...
                                                                           'Distance',        columnsDiff.Distance,    ...
                                                                           'Type',            columnsDiff.Type,        ...
                                                                           'Irregular',       columnsDiff.Irregular,   ...
                                                                           'RiskLevel',       columnsDiff.RiskLevel));
    dataStruct(4)  = struct('group', 'ALGORITMOS',         'value', struct('Occupancy',       jsondecode(peaksTable.occMethod{1}), ...
                                                                           'Detection',       jsondecode(peaksTable.Detection{1}), ...
                                                                           'Classification',  jsondecode(peaksTable.Classification{1})));

    userDescription = specData(idxThread).UserData.Emissions.UserData(idxEmission).Description;
    if ~isempty(userDescription)
        dataStruct(3).value.userDescription = sprintf('<font style="color: blue;">%s</font>', userDescription);
    end

    htmlContent    = [sprintf('<p style="font-family: Helvetica, Arial, sans-serif; font-size: 16px; text-align: justify; line-height: 12px; margin: 5px; padding-top: 5px; padding-bottom: 10px;"><b>%s</b></p>', emissionTag) ...
                      textFormatGUI.struct2PrettyPrintList(dataStruct(1:3)), ...
                      '<p style="font-family: Helvetica, Arial, sans-serif; color: gray; font-size: 10px; text-align: justify; line-height: 12px; margin: 5px; padding-bottom: 10px;">&thinsp;&thinsp;&thinsp;&thinsp;&thinsp;&thinsp;&thinsp;____________________<br>&thinsp;̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ <br>A seguir são apresentadas informações acerca do método de aferição da ocupação e dos algoritmos de detecção e classificação da emissão.</p>' ...
                      textFormatGUI.struct2PrettyPrintList(dataStruct(4))];
end