function htmlCode = metadataInfo(MetaDataInfo, InvalidValueStatus)

    arguments
        MetaDataInfo
        InvalidValueStatus = 'print -1'
    end
    
    htmlCode = '<p style="font-family: Helvetica; font-size: 10px; text-align: justify;">';
    for ii = 1:numel(MetaDataInfo)
        htmlCode = sprintf('%s<b>%s</b>', htmlCode, MetaDataInfo(ii).group);
        htmlCode = structParser(MetaDataInfo(ii).value, htmlCode, 1, InvalidValueStatus);
        htmlCode = sprintf('%s\n\n', htmlCode);
    end
    htmlCode = replace(sprintf('%s</p>', strtrim(htmlCode)), newline, '<br>');
end


%-------------------------------------------------------------------------%
function htmlCode = structParser(Data, htmlCode, Level, InvalidValueStatus)

    d = class.Constants.english2portuguese();

    structFields = fields(Data);
    for jj = 1:numel(structFields)
        Field = structFields{jj};
        Value = Data.(Field);

        try
            if isempty(Value)
                if strcmp(InvalidValueStatus, 'delete')
                    continue
                end
                Value = "-1";
    
            elseif isnumeric(Value) || islogical(Value)
                if (Value == -1) && strcmp(InvalidValueStatus, 'delete')
                    continue
                end
                Value = strjoin(string(double(Value)), ', ');
    
            elseif iscell(Value)
                Value = strjoin(Value, ', ');
    
            elseif Level == 1
                if isstruct(Value) || istable(Value)
                    Value = array2scalar(Value);
                    Value = structParser(Value, '', 2, InvalidValueStatus);
                elseif isJSON(Value)
                    Value = structParser(jsondecode(Value), '', 2, InvalidValueStatus);                
                end
    
            elseif Level == 2
                if isstruct(Value) || istable(Value)
                    Value = array2scalar(Value);
                    Value = structParser(Value, '', 3, InvalidValueStatus);
                end
            end
            
        catch
            continue
        end

        if isKey(d, Field)
            Field = d(Field);
        end
        
        switch Level
            case 1; htmlCode = sprintf('%s\n• <span style="color: #808080;">%s:</span> %s',     htmlCode, Field, Value);
            case 2; htmlCode = sprintf('%s\n  ○ <span style="color: #808080;">%s:</span> %s',   htmlCode, Field, Value);
            case 3; htmlCode = sprintf('%s\n    □ <span style="color: #808080;">%s:</span> %s', htmlCode, Field, Value);
        end
    end
end


%-------------------------------------------------------------------------%
function status = isJSON(value)
    status = false;

    try
        if isstruct(jsondecode(value))
            status = true;
        end
    catch        
    end
end


%-------------------------------------------------------------------------%
function editedValue = array2scalar(rawValue)
    if istable(rawValue)
        rawValue = table2struct(rawValue);
    end

    % Conversão aplicável apenas a estruturas não escalares que possuem 
    % dois campos.
    if numel(rawValue) > 1
        structFields = fields(rawValue);
        if numel(structFields) == 2
            for ii = 1:numel(rawValue)
                editedValue.(matlab.lang.makeValidName(rawValue(ii).(structFields{1}))) = rawValue(ii).(structFields{2});
            end
        else
            editedValue = -1;
        end
    else
        editedValue = rawValue;
    end
end