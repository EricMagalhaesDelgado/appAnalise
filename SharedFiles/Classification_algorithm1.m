function Peaks = Classification_algorithm1(Data, Peaks, RootFolder)
%% CLASSIFICATION_ALGORITHM1 PeakClassification1
% Trata-se de algoritmo de classificação de emissões, comparando-as com a base 
% *anatelDB*.
% 
% Versão: *29/04/2022*
    
    arguments
        Data       struct
        Peaks      table
        RootFolder char
    end
    global specData
    global AnatelDB
    global ExceptionGlobalList
    
    if isempty(Peaks)
        return
    end
    
    if isempty(AnatelDB)
        anateldb_Read(RootFolder)
    end
    
    if isempty(ExceptionGlobalList)
        Misc_ExceptionGlobalList(RootFolder)
    end
    Tolerance = 1e-5;
    [~, Band] = Misc_Band(Data);
    Tag = sprintf('%s\nThreadID %d: %.3f - %.3f MHz', Data.Node,                       ...
                                                      Data.ThreadID,                   ...
                                                      Data.MetaData.FreqStart ./ 1e+6, ...
                                                      Data.MetaData.FreqStop  ./ 1e+6);
 
    Peaks.Tag(:)       = {Tag};
    Peaks.Latitude(:)  = single(Data.gps.Latitude);
    Peaks.Longitude(:) = single(Data.gps.Longitude);
    
    Peaks = movevars(Peaks, {'Tag', 'Latitude', 'Longitude'}, 'Before', 1);
    
    Peaks.minLevel  = cellfun(@(x) sprintf('%.1f', x), num2cell(Data.statsData(Peaks.Index,1)),                           'UniformOutput', false);
    Peaks.meanLevel = cellfun(@(x) sprintf('%.1f', x), num2cell(Data.statsData(Peaks.Index,2)),                           'UniformOutput', false);
    Peaks.maxLevel  = cellfun(@(x) sprintf('%.1f', x), num2cell(Data.statsData(Peaks.Index,end)),                         'UniformOutput', false);
    Peaks.meanOCC   = cellfun(@(x) sprintf('%.1f', x), num2cell(specData(Data.reportOCC.Index).statsData(Peaks.Index,2)), 'UniformOutput', false);
    Peaks.maxOCC    = cellfun(@(x) sprintf('%.1f', x), num2cell(specData(Data.reportOCC.Index).statsData(Peaks.Index,3)), 'UniformOutput', false);
    
    Peaks.Type(:)           = {'Pendente de identificação'};
    Peaks.Regulatory(:)     = {'Não licenciada'};
    Peaks.Service(:)        = int16(-1);
    Peaks.Station(:)        = int32(-1);
    Peaks.Description(:)    = {'-'};
    Peaks.Distance(:)       = {'-'};
    Peaks.Irregular(:)      = {'Sim'};
    Peaks.RiskLevel(:)      = {'Baixo'};
    Peaks.occMethod(:)      = {sprintf('%s - %s', Data.reportOCC.Method, Data.reportOCC.Parameters)};
    Peaks.Classification(:) = {sprintf('%s - %s', Data.reportClassification.Algorithm, Data.reportClassification.Parameters)};
    Peaks = Peaks(:,[1:7, 9:22, 8, 23]);
    Peaks = sortrows(Peaks, {'Tag', 'Frequency'});
%% 
% Consulta à *base _offline_ da Agência* (Mosaico, Stel e SRD).
    Classification = jsondecode(Data.reportClassification.Parameters);
    
    RuralContour    = Classification.Contour;
    ClassMultiplier = Classification.ClassMultiplier;
    bwFactors       = Classification.bwFactors / 100;
        
    for ii = 1:height(Peaks)
        idx1 = find((abs(ExceptionGlobalList.Frequency-Peaks.Truncated(ii)) <= Tolerance), 1);
        BW   = Peaks.BW(ii);
        if ~isempty(idx1)
            Service     = int16(-1);
            Station     = int32(-1);
            Description = ExceptionGlobalList.Description{idx1};
            Distance    = Inf;
                        
        else
            idx2        = find(abs(AnatelDB.Frequency-Peaks.Truncated(ii)) <= Tolerance);
            auxDistance = [];
            if ~isempty(idx2)
                auxDistance = geo_lldistkm_v2(struct('lat', Data.gps.Latitude, 'lon', Data.gps.Longitude), AnatelDB(idx2, 3:4));
            end
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
                
                if Band == "FM"
                    if contains(Description, ["[SRD] RADCOM", "[SRD] 231"])
                        if Distance > ClassMultiplier * 2.2
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
                    
                elseif ismember(Band, ["TV_VHF1", "TV_VHF2", "TV_UHF"])
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
                else
                    break
                end
            end
                
            if ~isempty(classContour)
                RuralContour = ClassMultiplier * classContour;
            end
                
            if (Distance > RuralContour) | (BW < (1-bwFactors(1)) * Peaks.BW(ii)) | (BW > (1+bwFactors(2)) * Peaks.BW(ii))
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
%%
function classContour = FM_classCountour(classStation)
    switch classStation
        case 'C'; classContour =  7.5;
        case 'B'; classContour = 16.5;
        case 'A'; classContour = 38.5;
        case 'E'; classContour = 78.5;
    end
end
function classContour = TV_classCountour(classStation)
    switch classStation
        case 'C'; classContour = 20.2;
        case 'B'; classContour = 32.3;
        case 'A'; classContour = 47.9;
        case 'E'; classContour = 65.6;
    end
end