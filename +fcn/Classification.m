function Peaks = Classification(app, SpecInfo, idx, Peaks)

    % CLASSIFICATION_ALGORITHM1 PeakClassification1
    % Trata-se de algoritmo de classificação de emissões, comparando-as com a base 
    % *anatelDB*.
    % 
    % Versão: *29/04/2022*
    

    global AnatelDB


    % Identifica as características da canalização primária do fluxo de
    % dados sob análise.
    findPeaks       = FindPeaksOfPrimaryBand(app.channelObj, SpecInfo(idx));


    % Informações relacionadas às emissões...
    Peaks.minLevel  = cellfun(@(x) sprintf('%.1f', x), num2cell(SpecInfo(idx).Data{3}(Peaks.idx,1)),                             'UniformOutput', false);
    Peaks.meanLevel = cellfun(@(x) sprintf('%.1f', x), num2cell(SpecInfo(idx).Data{3}(Peaks.idx,2)),                             'UniformOutput', false);
    Peaks.maxLevel  = cellfun(@(x) sprintf('%.1f', x), num2cell(SpecInfo(idx).Data{3}(Peaks.idx,3)),                             'UniformOutput', false);

    occIndex = SpecInfo(idx).UserData.occMethod.CacheIndex;
    Peaks.meanOCC   = cellfun(@(x) sprintf('%.1f', x), num2cell(SpecInfo(idx).UserData.occCache(occIndex).Data{3}(Peaks.idx,2)), 'UniformOutput', false);
    Peaks.maxOCC    = cellfun(@(x) sprintf('%.1f', x), num2cell(SpecInfo(idx).UserData.occCache(occIndex).Data{3}(Peaks.idx,3)), 'UniformOutput', false);
    

    % Valores iniciais da classificação de cada emissão...
    Peaks.Type(:)           = {'Pendente de identificação'};
    Peaks.Regulatory(:)     = {'Não licenciada'};
    Peaks.Service(:)        = int16(-1);
    Peaks.Station(:)        = int32(-1);
    Peaks.Description(:)    = {'-'};
    Peaks.Distance(:)       = {'-'};
    Peaks.Irregular(:)      = {'Sim'};
    Peaks.RiskLevel(:)      = {'Baixo'};
    Peaks.occMethod(:)      = {jsonencode(SpecInfo(idx).UserData.reportOCC)};
    Peaks.Classification(:) = {jsonencode(SpecInfo(idx).UserData.reportClassification)};






    % PRECISO AGORA TRUNCAR AS FREQUÊNCIAS... 
    % VERIFICAR OS NOMES DAS COLUNAS DE PEAKTABLE


    


    Peaks = Peaks(:,[1:7, 9:22, 8, 23]);
    Peaks = sortrows(Peaks, {'Tag', 'Frequency'});


    % Consulta à *base _offline_ da Agência* (Mosaico, Stel e SRD).    
    RuralContour    = SpecInfo(idx).UserData.reportClassification.Parameters.Contour;
    classMultiplier = SpecInfo(idx).UserData.reportClassification.Parameters.ClassMultiplier;
    bwFactors       = SpecInfo(idx).UserData.reportClassification.Parameters.bwFactors / 100;
        
    for ii = 1:height(Peaks)
        idx1 = find((abs(ExceptionGlobalList.Frequency-Peaks.Truncated(ii)) <= class.Constants.floatDiffTolerance), 1);
        
        if ~isempty(idx1)
            Service     = int16(-1);
            Station     = int32(-1);
            Description = ExceptionGlobalList.Description{idx1};
            Distance    = Inf;
                        
        else
            idx2        = find(abs(AnatelDB.Frequency-Peaks.Truncated(ii)) <= class.Constants.floatDiffTolerance);
            auxDistance = [];
            
            if ~isempty(idx2)
                auxDistance = geo_lldistkm_v2(struct('lat', SpecInfo(idx).gps.Latitude, 'lon', SpecInfo(idx).gps.Longitude), AnatelDB(idx2, 3:4));
            end

            BW = Peaks.BW(ii);

            while true
                classContour = [];
                
                [Distance, idx3] = min(auxDistance);
                if ~isempty(idx3)
                    Service     = AnatelDB.Service(idx2(idx3));
                    Station     = AnatelDB.Station(idx2(idx3));
                    Description = char(AnatelDB.Description(idx2(idx3)));

                    if AnatelDB.BW(idx2(idx3)) > 0
                        BW = AnatelDB.BW(idx2(idx3)) / 1e+3;
                    end

                else
                    break
                end
                
                switch findPeaks.Name{1}
                    %-----------------------------------------------------%
                    case 'FM'
                        if contains(Description, ["[SRD] RADCOM", "[SRD] 231"])
                            if Distance > classMultiplier * 2.2
                                idx2(idx3)        = [];
                                auxDistance(idx3) = [];
                                continue
                            else
                                classContour = 2.2;
                                break
                            end
                            
                        elseif contains(Description, "[MOS] FM") 
                            classStation = regexp(Description, '\[MOS\] [FMTV]{2}-C[0-9]{1,2}, (?<class>[ABCE]{1})', 'names');
                            if ~isempty(classStation)
                                classContour = FM_classCountour(classStation.class);
                                break
                            else
                                idx2(idx3)        = [];
                                auxDistance(idx3) = [];
                                continue
                            end

                        else
                            break
                        end
                    
                    %-----------------------------------------------------%
                    case 'TV'
                        if contains(Description, "[MOS] TV")
                            classStation = regexp(Description, '\[MOS\] [FMTV]{2}-C[0-9]{1,2}, (?<class>[ABCE]{1})', 'names');
                            if ~isempty(classStation)
                                classContour = TV_classCountour(classStation.class);
                                break
                            else
                                idx2(idx3)        = [];
                                auxDistance(idx3) = [];
                                continue
                            end
                        else
                            break
                        end

                    %-----------------------------------------------------%
                    otherwise
                        break
                end
            end
                
            if ~isempty(classContour)
                RuralContour = classMultiplier * classContour;
            end
                
            if (Distance > RuralContour) || (BW < (1-bwFactors(1)) * Peaks.BW(ii)) || (BW > (1+bwFactors(2)) * Peaks.BW(ii))
                Distance = [];
            end
        end
        

        if ~isempty(Distance)
            if ~isempty(idx1)
                Regulatory = 'Não passível de licenciamento';
                Irregular  = 'Não';
                RiskLevel  = '-';

            else
                if Service ~= -1
                    Regulatory = 'Licenciada';
                    Irregular  = 'Não';
                    RiskLevel  = '-';

                else
                    Regulatory = 'Não licenciada';
                    Irregular  = 'Sim';
                    RiskLevel  = 'Baixo';
                end
            end
            Peaks(ii,13:20) = {'Fundamental', Regulatory, Service, Station, Description, sprintf('%.1f', Distance), Irregular, RiskLevel};
        end
    end    
end


%-------------------------------------------------------------------------%
function classContour = FM_classCountour(classStation)
    switch classStation
        case 'C'; classContour =  7.5;
        case 'B'; classContour = 16.5;
        case 'A'; classContour = 38.5;
        case 'E'; classContour = 78.5;
    end
end


%-------------------------------------------------------------------------%
function classContour = TV_classCountour(classStation)
    switch classStation
        case 'C'; classContour = 20.2;
        case 'B'; classContour = 32.3;
        case 'A'; classContour = 47.9;
        case 'E'; classContour = 65.6;
    end
end