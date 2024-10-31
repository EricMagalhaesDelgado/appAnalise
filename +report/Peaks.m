function peaksTable = Peaks(app, idxThreads, DetectionMode, exceptionList)
    peaksTable = [];
    for ii = idxThreads
        Peaks = report.ReportGenerator_Peaks(app, ii, DetectionMode);

        if ~isempty(Peaks)
            if isempty(peaksTable); peaksTable = Peaks;
            else;                   peaksTable = [peaksTable; Peaks];
            end
        end

        Peaks = Fcn_exceptionList(Peaks, exceptionList);
        app.specData(ii).UserData.reportPeaksTable = Peaks;
    end
end

%-------------------------------------------------------------------------%
function Peaks = Fcn_exceptionList(Peaks, exceptionList)
    if ~isempty(Peaks)
        % Itera em relação à lista de exceções...
        for ii = 1:height(exceptionList)
            Tag       = exceptionList.Tag{ii};
            Frequency = exceptionList.Frequency(ii);

            % Identifica registros das duas tabelas - peaksTable e exceptionList 
            % - que possuem a mesma "Tag" e a mesma "Frequency".    
            idx = find(strcmp(Peaks.Tag, Tag) & (abs(Peaks.Frequency-Frequency) <= class.Constants.floatDiffTolerance));

            if isscalar(idx)
                if Peaks.Description{idx} == "-"
                    Description = sprintf('<font style="color: #ff0000;">%s</font>', exceptionList.Description{ii});
                    Distance    = sprintf('<font style="color: #ff0000;">%s</font>', exceptionList.Distance{ii});
                else
                    Description = sprintf('<del>%s</del></p> <p class="Tabela_Texto_8" contenteditable="false" style="color: #ff0000;">%s', Peaks.Description{idx}, exceptionList.Description{ii});
                    Distance    = sprintf('<del>%s</del></p> <p class="Tabela_Texto_8" contenteditable="false" style="color: #ff0000;">%s', Peaks.Distance{idx},    exceptionList.Distance{ii});
                end
    
                Peaks(idx, 13:20)      = exceptionList(ii, 3:10);
                Peaks.Description{idx} = Description;
                Peaks.Distance{idx}    = Distance;
            end
        end

        % Itera em relação à lista de emissões, buscando aquelas que possuem
        % informações textuais complementares.
        emissionIndex = find(cellfun(@(x) isfield(jsondecode(x), 'Description'), Peaks.Detection))';
        for ii = emissionIndex
            emissionInfo = jsondecode(Peaks.Detection{ii});
            switch Peaks.Description{ii}
                case '-'
                    Peaks.Description{ii} = sprintf('<p class="Tabela_Texto_8" contenteditable="false" style="color: blue;">%s', strjoin(emissionInfo.Description, '<br>')); 
                otherwise
                    Peaks.Description{ii} = sprintf('%s <p class="Tabela_Texto_8" contenteditable="false" style="color: blue;">%s', Peaks.Description{ii}, strjoin(emissionInfo.Description, '<br>')); 
            end
        end
    end
end