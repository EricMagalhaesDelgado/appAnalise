function htmlContent = htmlCode_ThreadsInfo(specData, filteringSummary)

    htmlContent = {};

    for ii = 1:numel(specData)
        threadTag      = sprintf('%.3f - %.3f MHz', specData(ii).MetaData.FreqStart/1e+6, specData(ii).MetaData.FreqStop/1e+6);

        FilteredSweeps = '';
        if filteringSummary.RawSweeps(ii) ~= filteringSummary.FilteredSweeps(ii)
            if filteringSummary.FilteredSweeps(ii)
                fontColor = 'gray';
            else
                fontColor = 'red';
            end

            FilteredSweeps = sprintf('<br><font style="color: %s; font-size: 10px;">%d varreduras pós-filtragem</font>', fontColor, filteringSummary.FilteredSweeps(ii));
        end
    
        dataStruct(1)  = struct('group', 'TEMPO DE OBSERVAÇÃO', 'value', sprintf('%s - %s', datestr(specData(ii).Data{1}(1),   'dd/mm/yyyy HH:MM:SS'), datestr(specData(ii).Data{1}(end), 'dd/mm/yyyy HH:MM:SS')));
        dataStruct(2)  = struct('group', 'VARREDURAS',          'value', sprintf('%d >> %d', filteringSummary.RawSweeps(ii), filteringSummary.FilteredSweeps(ii)));
    
        htmlContent{end+1} = [sprintf('<p style="font-family: Helvetica, Arial, sans-serif; font-size: 16px; text-align: justify; line-height: 12px; margin: 5px; padding-top: 5px;"><b>%s</b><br>', threadTag) ...
                              sprintf('<font style="color: gray; font-size: 10px;">%s - %s</font><br>', datestr(specData(ii).Data{1}(1),   'dd/mm/yyyy HH:MM:SS'), datestr(specData(ii).Data{1}(end), 'dd/mm/yyyy HH:MM:SS')) ...
                              sprintf('<font style="color: gray; font-size: 10px;">%d varreduras inicias</font>%s</p>', filteringSummary.RawSweeps(ii), FilteredSweeps)];
    end

    htmlContent = strjoin(htmlContent);
end