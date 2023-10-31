function SpecInfo = TimeStampFilter(app, idx, TimeStamp)

    % Como app.specData é uma instância de uma classe cuja superclasse é
    % HANDLE, então é preciso fazer uma cópia da instância, caso se deseje
    % alterar alguma das suas propriedades. É o caso quando se filtra as
    % suas amostras.

    if TimeStamp.Status
        SpecInfo = copy(app.specData(idx), {});

        for ii = 1:numel(SpecInfo)
            % Filtram-se as amostras...
            auxIndex1 = SpecInfo(ii).Data{1} < TimeStamp.Observation(1);
            if any(auxIndex1)                
                SpecInfo(ii).Data{1}(auxIndex1)   = [];
                SpecInfo(ii).Data{2}(:,auxIndex1) = [];
            end
            
            auxIndex2 = SpecInfo(ii).Data{1} > TimeStamp.Observation(2);
            if any(auxIndex2)                
                SpecInfo(ii).Data{1}(auxIndex2)   = [];
                SpecInfo(ii).Data{2}(:,auxIndex2) = [];
            end
            
            if numel(SpecInfo(ii).Data{1}) <= 1
                error('Após aplicação do filtro de TimeStamp deve restar ao menos duas amostras.')
            end
            
            % Recalcula a estatística básica da matriz de níveis...
            SpecInfo(ii).Data{3} = [ min(SpecInfo(ii).Data{2}, [], 2), ...
                                    mean(SpecInfo(ii).Data{2},     2), ...
                                     max(SpecInfo(ii).Data{2}, [], 2)];

            % Ajusta a informação da propriedade "RelatedFiles", que armazena
            % o período de observação de cada arquivo, o número de amostras
            % e uma estimativa do tempo de revisita.
            HH = height(SpecInfo(ii).RelatedFiles);
            for jj = HH:-1:1
                auxIndex3 = find((SpecInfo(ii).Data{1} >= SpecInfo(ii).RelatedFiles.BeginTime(jj)) & (SpecInfo(ii).Data{1} <= SpecInfo(ii).RelatedFiles.EndTime(jj)));
                if isempty(auxIndex3)
                    SpecInfo(ii).RelatedFiles(jj,:) = [];
                else
                    BeginTime = SpecInfo(ii).Data{1}(auxIndex3(1));
                    EndTime   = SpecInfo(ii).Data{1}(auxIndex3(end));
                    Samples   = numel(auxIndex3);

                    SpecInfo(ii).RelatedFiles(jj,5:8) = {BeginTime, EndTime, Samples, seconds(EndTime-BeginTime)/(Samples-1)};
                end
            end
        end

    else
        SpecInfo = app.specData(idx);
    end
end