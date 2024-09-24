function htmlContent = htmlCode_StationInfo(rfDataHub, idxRFDataHub, rfDataHubLOG)

    % RFDataHub
    stationInfo    = table2struct(rfDataHub(idxRFDataHub,:));
    if stationInfo.BW <= 0
        stationTag = sprintf('%.3f MHz',            stationInfo.Frequency);
    else
        stationTag = sprintf('%.3f MHz ⌂ %.1f kHz', stationInfo.Frequency, stationInfo.BW);
    end

    stationURL = '';
    if stationInfo.URL ~= "-1"
        [imgExt, imgString] = Base64Link();
        stationURL = sprintf('<img id="RelatorioCanalMosaico" src="data:image/%s;base64,%s" style="width:12px; height:12px; cursor: pointer;"/>', imgExt, imgString);
    end

    % ToDo: agregar o nome do serviço à informação...
    stationService = sprintf('%d', stationInfo.Service);
    
    mergeCount = str2double(string(stationInfo.MergeCount));

    if stationInfo.Station == -1
        stationNumber = sprintf('<font style="color: red;">%d</font>', stationInfo.Station);
    else
        stationNumber = num2str(stationInfo.Station);
        if mergeCount > 1
            stationNumber = sprintf('%s*', stationNumber);
        end
    end

    % RFDataHubLOG
    stationLOG = class.RFDataHub.queryLog(rfDataHubLOG, stationInfo.Log);
    if isempty(stationLOG)
        stationLOG = 'Registro não editado';
    end

    % dataStruct2HTMLContent
    dataStruct(1) = struct('group', 'ID',            'value', stationInfo.ID);
    dataStruct(2) = struct('group', 'Service',       'value', stationService);
    dataStruct(3) = struct('group', 'Station',       'value', stationNumber);
    dataStruct(4) = struct('group', 'OUTROS ASPECTOS TÉCNICOS', 'value', rmfield(stationInfo, {'AntennaPattern', ...
                                                                                               'BW',             ...
                                                                                               'Description',    ...
                                                                                               'Distance',       ...
                                                                                               'Fistel',         ...
                                                                                               'Frequency',      ...
                                                                                               'ID',             ...
                                                                                               'Latitude',       ...
                                                                                               'LocationID',     ...
                                                                                               'Location',       ...
                                                                                               'Log',            ...
                                                                                               'Longitude',      ...
                                                                                               'MergeCount',     ...
                                                                                               'Name',           ...
                                                                                               'Station',        ...
                                                                                               'StationClass',   ...
                                                                                               'Status',         ...
                                                                                               'Service',        ...
                                                                                               'Source',         ...
                                                                                               'State',          ...
                                                                                               'URL'}));

    if mergeCount > 1
        dataStruct(end+1) = struct('group', 'NÚMERO ESTAÇÕES AGRUPADAS', 'value', string(mergeCount));
    end

    try
        if isstruct(stationLOG) || ischar(stationLOG)
            dataStruct(end+1) = struct('group', 'LOG', 'value', stationLOG);
        elseif iscell(stationLOG)
            for ii = 1:numel(stationLOG)
                dataStruct(end+1) = struct('group', sprintf('LOG #%d', ii), 'value', stationLOG{ii});
            end
        end
    catch
    end

    htmlContent   = [sprintf('<p style="font-family: Helvetica, Arial, sans-serif; font-size: 10px; margin: 5px; color: white; background-color: red; display: inline-block; vertical-align: middle; padding: 5px; border-radius: 5px;">%s</p>', stationInfo.Source) ...
                     sprintf('<p style="font-family: Helvetica, Arial, sans-serif; font-size: 16px; text-align: justify; margin: 5px;"><b>%s</b>&thinsp;&thinsp;&thinsp;%s</p>', stationTag, stationURL) ...
                     sprintf('<p style="font-family: Helvetica, Arial, sans-serif; font-size: 11px; text-align: justify; margin: 5px; padding-bottom: 10px;">%s</p>', stationInfo.Description) ...
                     textFormatGUI.struct2PrettyPrintList(dataStruct, 'delete')];
end

%-------------------------------------------------------------------------%
function [imgExt, imgString] = Base64Link()
    imgExt    = 'png';
    imgString = 'iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAFSSURBVEhL5ZXNKkVRGECvhCiRiYniEZgaGRiYmMmYDIx4gDtBKVF+ylQyMBTeAC+AgTyEkoGfImGte86ufW/3Dva510BWrfbe3zl9Z5/vfO1T+vO05WNRJnAcO/EOT7BlbOAnfkdeYUvYRhMe4KABWEFjXmuKHTTRHlqamEt8yqbFWMSQvM9ADYf4nk2LMYxzWLtz6cd7vK6sEunCoWxaF5Of4RdOG0ihjA9oaXQf4/Y2+TmafMlACqFbLnANj/L1JkpI/obzBlKIu6XbQM4YjmAoi/c0ldxuGcVJDISde09SWaxtvT7fRWOn+dxj4QWTd76OIXmHgQgf/Igm9pvMYBJTGJelEe35mMwW2moDlVU11nwV/biFsbbP2bSKuFs8ngvjEWCShcoqIyT3zZYNNMsN+pBj9I1u8RWTu6URPeiJ6I/kA+2WWfwVevPxX1Mq/QAXhE8oQMYvUQAAAABJRU5ErkJggg==';
end