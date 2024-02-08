function Peaks = Classification(app, SpecInfo, idx, Peaks)

    % Trata-se de algoritmo de classificação de emissões, comparando-as com a base 
    % *anatelDB*.
    % Versão: 29/04/2022

    global RFDataHub

    % Trunca a frequência central da emissão, caso aplicável, possibilitando 
    % a sua classificação.
    Peaks.Truncated(:) = single(-1);
    for ii = 1:height(Peaks)
        if SpecInfo(idx).UserData.Emissions.isTruncated(ii)
            Peaks.Truncated(ii) = TruncatedFrequency(app.channelObj, SpecInfo(idx), ii);
        else
            Peaks.Truncated(ii) = SpecInfo(idx).UserData.Emissions.Frequency(ii);
        end
    end


    % Informações relacionadas à frequência central das emissões. Ou seja,
    % o nível mínimo ou máximo, por exemplo, não se refere à EMISSÃO ou ao
    % CANAL, mas ao BIN da emissão que corresponde à sua frequência central.
    Peaks.minLevel  = cellfun(@(x) sprintf('%.1f', x), num2cell(SpecInfo(idx).Data{3}(Peaks.Index,1)),                             'UniformOutput', false);
    Peaks.meanLevel = cellfun(@(x) sprintf('%.1f', x), num2cell(SpecInfo(idx).Data{3}(Peaks.Index,2)),                             'UniformOutput', false);
    Peaks.maxLevel  = cellfun(@(x) sprintf('%.1f', x), num2cell(SpecInfo(idx).Data{3}(Peaks.Index,3)),                             'UniformOutput', false);

    occIndex = SpecInfo(idx).UserData.occMethod.CacheIndex;
    Peaks.meanOCC   = cellfun(@(x) sprintf('%.1f', x), num2cell(SpecInfo(idx).UserData.occCache(occIndex).Data{3}(Peaks.Index,2)), 'UniformOutput', false);
    Peaks.maxOCC    = cellfun(@(x) sprintf('%.1f', x), num2cell(SpecInfo(idx).UserData.occCache(occIndex).Data{3}(Peaks.Index,3)), 'UniformOutput', false);
    

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


    % Organização da tabela, de forma que fique idêntica à app.peaksTable.
    % peaksTable    = table('Size', [0, 23],                                                                                                                                                                                                         ...
    %                       'VariableTypes', {'cell', 'single', 'single', 'uint16', 'double', 'single', 'double', 'cell', 'cell', 'cell', 'cell', 'cell', 'cell', 'cell', 'int16', 'int32', 'cell', 'cell', 'cell', 'cell', 'cell', 'cell', 'cell'}, ...
    %                       'VariableNames', {'Tag', 'Latitude', 'Longitude', 'Index', 'Frequency', 'Truncated', 'BW', 'minLevel', 'meanLevel', 'maxLevel', 'meanOCC', 'maxOCC', 'Type', 'Regulatory', 'Service', 'Station', 'Description', 'Distance', 'Irregular', 'RiskLevel', 'occMethod', 'Detection', 'Classification'});
    Peaks = Peaks(:,[1:5, 9, 6, 10:22, 23, 8, 24]);
    Peaks = sortrows(Peaks, {'Tag', 'Frequency'});


    % Informações que possibilitam a classificação de uma emissão:
    % (a) Identificas as características da canalização primária do fluxo de
    %     dados sob análise.
    % (b) Parâmetros relacionados ao algoritmo de classificação
    %     implementado - "Contour", "ClassMultiplier" e "bwFactors".
    findPeaks       = FindPeaksOfPrimaryBand(app.channelObj, SpecInfo(idx)); 
    RuralContour    = SpecInfo(idx).UserData.reportClassification.Parameters.Contour;
    classMultiplier = SpecInfo(idx).UserData.reportClassification.Parameters.ClassMultiplier;
    bwFactors       = SpecInfo(idx).UserData.reportClassification.Parameters.bwFactors / 100;


    % Classificação...        
    for ii = 1:height(Peaks)
        idx1 = find((abs(app.channelObj.Exception.FreqCenter - Peaks.Truncated(ii)) <= class.Constants.floatDiffTolerance), 1);
        
        if ~isempty(idx1)
            Service     = -1;
            Station     = -1;
            Description = app.channelObj.Exception.Description{idx1};
            Distance    = Inf;
                        
        else
            idx2        = find(abs(RFDataHub.Frequency-Peaks.Truncated(ii)) <= class.Constants.floatDiffTolerance);
            auxDistance = [];
            
            if ~isempty(idx2)
                auxDistance = fcn.gpsDistance(struct('lat', SpecInfo(idx).GPS.Latitude, 'lon', SpecInfo(idx).GPS.Longitude), RFDataHub(idx2, 6:7));
            end

            % Como referência de BW, usa-se a BW da própria emissão. Caso o
            % registro do anateldb possua a designação de emissão da estação, 
            % então é substituído esse valor pelo constante no anateldb.
            BW = Peaks.BW(ii);

            while true
                classContour = [];
                
                [Distance, idx3] = min(auxDistance);
                if ~isempty(idx3)
                    Service     = RFDataHub.Service(idx2(idx3));
                    Station     = RFDataHub.Station(idx2(idx3));
                    Description = class.RFDataHub.Description(RFDataHub, idx2(idx3));

                    if RFDataHub.BW(idx2(idx3)) > 0
                        BW = RFDataHub.BW(idx2(idx3));
                    end

                else
                    break
                end

                if isempty(findPeaks)
                    break
                else
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
                                
                            elseif contains(Description, "[MOSAICO-SRD] FM") 
                                classStation = regexp(Description, '\[MOSAICO-SRD\] [FMTV]{2}-C[0-9]{1,2}, (?<class>[ABCE]{1})', 'names');
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
                            if contains(Description, "[MOSAICO-SRD] TV")
                                classStation = regexp(Description, '\[MOSAICO-SRD\] [FMTV]{2}-C[0-9]{1,2}, (?<class>[ABCE]{1})', 'names');
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
            end
                
            if ~isempty(classContour)
                RuralContour = classMultiplier * classContour;
            end
                
            if (Distance > RuralContour) | (BW < (1-bwFactors(1))*Peaks.BW(ii)) | (BW > (1+bwFactors(2))*Peaks.BW(ii))
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