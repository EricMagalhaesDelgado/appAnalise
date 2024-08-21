classdef ChannelLib < handle

    properties
        %-----------------------------------------------------------------%
        Channel
        Exception
        DefaultChannelStep
        DefaultMinBandSpan
        FindPeaks
    end


    methods
        %-----------------------------------------------------------------%
        function obj = ChannelLib(appName, rootFolder)
            [projectFolder, ...
             programDataFolder] = appUtil.Path(appName, rootFolder);
            try
                channelTempLib  = jsondecode(fileread(fullfile(programDataFolder, 'ChannelLib.json')));
            catch
                channelTempLib  = jsondecode(fileread(fullfile(projectFolder,     'ChannelLib.json')));
            end

            obj.Channel    = struct2table(channelTempLib.Channel);
            obj.Exception  = struct2table(channelTempLib.Exception);
            obj.FindPeaks  = struct2table(channelTempLib.FindPeaks);

            obj.DefaultChannelStep = channelTempLib.DefaultChannelStep;
            obj.DefaultMinBandSpan = channelTempLib.DefaultMinBandSpan;
        end

        %-----------------------------------------------------------------%
        function Save(obj, appName, rootFolder)
            [~, ...
             programDataFolder] = appUtil.Path(appName, rootFolder);
            programDataFilePath = fullfile(programDataFolder, 'ChannelLib.json');

            try
                channelTempLib = struct(obj);
                writematrix(jsonencode(channelTempLib, 'PrettyPrint', true), programDataFilePath, "FileType", "text", "QuoteStrings", "none", "WriteMode", "overwrite")
            catch
            end
        end

        %-----------------------------------------------------------------%
        function bandsIndex = FindRelatedBands(obj, specData)        
            FreqStart  = specData.MetaData.FreqStart/1e+6;
            FreqStop   = specData.MetaData.FreqStop /1e+6;

            BandLimits = cell2mat(obj.Channel.Band);
            BandLimits = [BandLimits(1:2:end), BandLimits(2:2:end)]; 
        
            bandsIndex = find(((FreqStart >= BandLimits(:,1)) & (FreqStart < BandLimits(:,2))) | ...
                              ((FreqStart <= BandLimits(:,1)) & (FreqStop  > BandLimits(:,1))));
        end

        %-----------------------------------------------------------------%
        function findPeaks = FindPeaksOfPrimaryBand(obj, specData)
            findPeaks = [];

            % Concatena as canalizações - a automática, incluída automaticamente
            % pelo app a partir dos canais especificados em "ChannelLib.json", 
            % e a manual, inserida pelo fiscal no app.

            Channels = specData.UserData.channelManual;
            if ~isempty(specData.UserData.channelLibIndex)
                Channels = [Channels; obj.Channel(specData.UserData.channelLibIndex,:)];
            end

            % Identifica a canalização que apresenta maior sobreposição com
            % o fluxo espectral sob análise.

            commumSpan = [];
            for ii = 1:height(Channels)
                spanLim1 = max(Channels.Band{ii}(1), specData.MetaData.FreqStart/1e+6);
                spanLim2 = min(Channels.Band{ii}(2),  specData.MetaData.FreqStop/1e+6);

                commumSpan(ii) =  diff([spanLim1, spanLim2]);
            end
            [~, idx1] = max(commumSpan);
            
            if ~isempty(idx1)
                idx2  = find(strcmp(obj.FindPeaks.Name, Channels.FindPeaksName{idx1}), 1);
                findPeaks = obj.FindPeaks(idx2,:);
            end
        end

        %-----------------------------------------------------------------%
        function Truncated = TruncatedFrequency(obj, specData, idxEmission)

            Channels = [];
            if ~isempty(specData.UserData.channelLibIndex) && ~isempty(specData.UserData.channelManual)
                Channels = ChannelList(obj, specData, 'Lib',    Channels, idxEmission);
                Channels = ChannelList(obj, specData, 'Custom', Channels, idxEmission);

            elseif ~isempty(specData.UserData.channelLibIndex)
                Channels = ChannelList(obj, specData, 'Lib',    Channels, idxEmission);

            elseif ~isempty(specData.UserData.channelManual)
                Channels = ChannelList(obj, specData, 'Custom', Channels, idxEmission);
            end

            if isempty(Channels)
                FreqStart   = round(specData.MetaData.FreqStart ./ 1e+6, 1);  % Hz >> MHz
                FreqStop    = specData.MetaData.FreqStop  ./ 1e+6;            % Hz >> MHz
                StepWidth   = obj.DefaultChannelStep;

                Channels = FreqStart:StepWidth:FreqStop;
            end
            Channels  = unique(Channels);

            [~, idxFind] = min(abs(Channels - specData.UserData.Emissions.Frequency(idxEmission)));
            Truncated    = Channels(idxFind);
        end

        %-----------------------------------------------------------------%
        function channels2Add = openExternalFile(obj, fileFullPath)
            refFieldNames = obj.Channel.Properties.VariableNames';

            channels2Add  = jsondecode(fileread(fileFullPath));
            fieldNames    = fieldnames(channels2Add);
            if ~isequal(fieldNames, refFieldNames)
                error('ChannelLib:openExternalFile', 'O arquivo deve ser uma estrutura com os campos %s, dispostos nesta ordem.', textFormatGUI.cellstr2ListWithQuotes(refFieldNames))
            end

            for ii = 1:numel(channels2Add)
                channels2AddCell = struct2cell(channels2Add(ii));
                checkExternalFileData(obj, channels2AddCell{:})
            end

            channels2Add = struct2table(channels2Add);
        end
    end


    methods (Access = private)
        %-----------------------------------------------------------------%
        function Channels = ChannelList(obj, specData, truncatedType, Channels, idxEmission)
            emission_downLim = specData.UserData.Emissions.Frequency(idxEmission) - specData.UserData.Emissions.BW(idxEmission)/2000;
            emission_upLim   = specData.UserData.Emissions.Frequency(idxEmission) + specData.UserData.Emissions.BW(idxEmission)/2000;

            switch truncatedType
                case 'Lib'
                    for ii = specData.UserData.channelLibIndex'
                        if emission_downLim > obj.Channel.Band{ii}(2) || emission_upLim < obj.Channel.Band{ii}(1)
                            continue
                        end

                        if ~isempty(obj.Channel.FreqList{ii})
                            Channels = [Channels, obj.Channel.FreqList{ii}];
    
                        else    
                            FreqStart   = obj.Channel.FirstChannel(ii);
                            FreqStop    = obj.Channel.LastChannel(ii);
                            StepWidth   = obj.Channel.StepWidth(ii);
        
                            Channels = [Channels, FreqStart:StepWidth:FreqStop];
                        end
                    end

                case 'Custom'
                    for ii = 1:height(specData.UserData.channelManual)
                        if emission_downLim > specData.UserData.channelManual.Band{ii}(2) || emission_upLim < specData.UserData.channelManual.Band{ii}(1)
                            continue
                        end

                        FreqStart   = specData.UserData.channelManual.FirstChannel(ii);
                        FreqStop    = specData.UserData.channelManual.LastChannel(ii);
                        StepWidth   = specData.UserData.channelManual.StepWidth(ii);
    
                        Channels = [Channels, FreqStart:StepWidth:FreqStop];
                    end
            end
        end

        %-----------------------------------------------------------------%
        function checkExternalFileData(obj, Name, Band, FirstChannel, LastChannel, StepWidth, ChannelBW, FreqList, Reference, FindPeaksName)
            arguments
                obj
                Name           (1,:) char   {mustBeTextScalar}
                Band           (1,2) double {mustBeFinite, mustBeGreaterThanOrEqual(Band,         -1)}
                FirstChannel   (1,1) double {mustBeFinite, mustBeGreaterThanOrEqual(FirstChannel, -1)}
                LastChannel    (1,1) double {mustBeFinite, mustBeGreaterThanOrEqual(LastChannel,  -1)}
                StepWidth      (1,1) double {mustBeFinite, mustBeGreaterThanOrEqual(StepWidth,    -1)}
                ChannelBW      (1,1) double {mustBeFinite, mustBeGreaterThanOrEqual(ChannelBW,    -1)}
                FreqList             double {mustBeFinite, mustBeGreaterThanOrEqual(FreqList,     -1)}
                Reference      (1,:) char   {mustBeTextScalar}
                FindPeaksName  (1,:) char   {mustBeTextScalar}
            end

            refNames = obj.Channel.Name;
            if ismember(Name, refNames)
                error('ChannelLib:checkExternalFileData', 'O nome "%s" já consta na lista de canais de referência %s.', Name, textFormatGUI.cellstr2ListWithQuotes(refNames))
            end
            
            if ~issorted(Band, 'strictascend')
                error('ChannelLib:checkExternalFileData', 'Campo "Band" deve ser um vetor numérico 1x2 em que o segundo elemento é maior do que o primeiro.')
            end

            if isequal([FirstChannel, LastChannel], [-1,-1]) && isempty(FreqList)
                error('ChannelLib:checkExternalFileData', 'Campo "FreqList" deve ser um vetor numérico 1xn com a lista de frequências centrais dos canais, caso se trate de faixa cujos canais não sejam regularmente espaçados.')
            end

            refFindPeaksName = unique(obj.Channel.FindPeaksName);
            if ~ismember(FindPeaksName, refFindPeaksName)
                error('ChannelLib:checkExternalFileData', 'Campo "FindPeaksName" deve ser membro da lista %s.', textFormatGUI.cellstr2ListWithQuotes(refFindPeaksName))
            end
        end
    end
end