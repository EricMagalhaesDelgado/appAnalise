function Measures(specData, idxThread, idxEmission, orientation, varargin)

    arguments
        specData    model.SpecData
        idxThread   {mustBeInteger, mustBeNonnegative, mustBeFinite} =  1
        idxEmission {mustBeInteger, mustBeFinite} = -1
        orientation {mustBeMember(orientation, {'Band', 'Channel', 'Emission'})} = 'Band'
    end

    arguments (Repeating)
        varargin
    end

    switch orientation
        case 'Band'
            % BAND
            % (a) "Level"
            %      Mínimo, médio e máximo por bin, armazenando a informação em 
            %      specData(idxThread).Data{3}.
            % (b) "Occupancy"
            %     FCO por bin, armazenando a informaçãoem specData(idxThread).UserData.occCache 
            %     e specData(idxThread).UserData.occoccMethod.CacheIndex.
            %     FBO da banda.
            % (c) "BandWidth"
            %     Não aplicável.

        case 'Channel'
            channelObj = varargin{1};

            % CHANNEL: itera em todos os canais
            % (a) "Level"
            %      Potência do canal.         reportChannelTable    = []
                reportChannelAnalysis = []
            % (b) "Occupancy"
            %     Aferida ocupação por ponto de frequência, armazenando a informação
            %     em specData(idxThread).UserData.occCache e
            %     specData(idxThread).UserData.occoccMethod.CacheIndex
            % (c) "BandWidth"
            %     Não aplicável.
            chTable  = specData(idxThread).UserData.reportChannelTable;
            if isempty(chTable)
                chTable = ChannelTable2Plot(channelObj, specData(idxThread));
                specData(idxThread).UserData.reportChannelTable = chTable;
            end

        case 'Emission'
            bandFreqStart     = specData(idxThread).MetaData.FreqStart;
            bandFreqStop      = specData(idxThread).MetaData.FreqStop;
            bandDataPoints    = specData(idxThread).MetaData.DataPoints;

            % Inicialmente, identifica os índices que delimitam a emissão:
            emissionFreqStart = specData(idxThread).UserData.Emissions.Frequency(idxEmission) * 1e+6 - (specData(idxThread).UserData.Emissions.BW_kHz(idxEmission)/2) * 1e+3;
            emissionFreqStop  = specData(idxThread).UserData.Emissions.Frequency(idxEmission) * 1e+6 + (specData(idxThread).UserData.Emissions.BW_kHz(idxEmission)/2) * 1e+3;

            idxMatrixStart    = freq2idx(bandFreqStart, bandFreqStop, bandDataPoints, emissionFreqStart);
            idxMatrixStop     = freq2idx(bandFreqStart, bandFreqStop, bandDataPoints, emissionFreqStop);

            % E agora afere as medidas...
            Level(    specData, idxThread, idxEmission, emissionFreqStart, emissionFreqStop)
            Occupancy(specData, idxThread, idxEmission, idxMatrixStart, idxMatrixStop)
            BandWidth()
    end
end

%-------------------------------------------------------------------------%
function FrequencyIndex = freq2idx(FreqStart, FreqStop, DataPoints, FrequencyInHertz)
    aCoef = (FreqStop - FreqStart) ./ (DataPoints - 1);
    bCoef = FreqStart - aCoef;

    FrequencyIndex = round((FrequencyInHertz - bCoef)/aCoef);
    FrequencyIndex(FrequencyIndex < 1) = 1;
    FrequencyIndex(FrequencyIndex > DataPoints) = DataPoints;
end

%-------------------------------------------------------------------------%
function Level(specData, idxThread, idxEmission, emissionFreqStart, emissionFreqStop)
    idxMatrixCenter = specData(idxThread).UserData.Emissions.idxFrequency(idxEmission);
    emissionPower   = RF.ChannelPower(specData, idxThread, [emissionFreqStart, emissionFreqStop]);

    specData(idxThread).UserData.Emissions.Measures(idxEmission).Level = struct('FreqCenter_Min',  specData(idxThread).Data{3}(idxMatrixCenter, 1), ...
                                                                                'FreqCenter_Mean', specData(idxThread).Data{3}(idxMatrixCenter, 2), ...
                                                                                'FreqCenter_Max',  specData(idxThread).Data{3}(idxMatrixCenter, 3), ...
                                                                                'Channel_Min',     min(emissionPower),                              ...
                                                                                'Channel_Mean',    mean(emissionPower),                             ...
                                                                                'Channel_Max',     max(emissionPower));
end

%-------------------------------------------------------------------------%
function Occupancy(specData, idxThread, idxEmission, idxMatrixStart, idxMatrixStop)
    idxMatrixCenter = specData(idxThread).UserData.Emissions.idxFrequency(idxEmission);

    % INTEGRAÇÃO TEMPORAL INFINITA
    refInfMatrix    = specData(idxThread).UserData.occInfIntegration(idxMatrixStart:idxMatrixStop, :);
    FBOPerSweep     = 100 * sum(refInfMatrix)/(idxMatrixStop - idxMatrixStart + 1);
    FCOChannel      = 100 * sum(any(refInfMatrix)) / width(refInfMatrix);
    FCOFreqCenter   = 100 * sum(refInfMatrix(idxMatrixCenter-idxMatrixStart+1, :)) / width(refInfMatrix);

    % INTEGRAÇÃO TEMPORAL FINITA
    occIndex        = specData(idxThread).UserData.occMethod.CacheIndex;
    refFinMatrix    = specData(idxThread).UserData.occCache(occIndex).Data{3};

    % SAÍDA
    specData(idxThread).UserData.Emissions.Measures(idxEmission).FBO = struct('Min',   min(FBOPerSweep), ...
                                                                              'Mean', mean(FBOPerSweep), ...
                                                                              'Max',   max(FBOPerSweep));

    specData(idxThread).UserData.Emissions.Measures(idxEmission).FCO = struct('Channel_Infinite',       FCOChannel,                       ...
                                                                              'FreqCenter_Infinite',    FCOFreqCenter,                    ...                                                                             
                                                                              'FreqCenter_Finite_Min',  refFinMatrix(idxMatrixCenter, 1), ...
                                                                              'FreqCenter_Finite_Mean', refFinMatrix(idxMatrixCenter, 2), ...
                                                                              'FreqCenter_Finite_Max',  refFinMatrix(idxMatrixCenter, 3));
end

%-------------------------------------------------------------------------%
function BandWidth()
    % PENDENTE
end