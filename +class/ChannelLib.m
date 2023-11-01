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
        function obj = ChannelLib(RootFolder)

            channelTempLib = jsondecode(fileread(fullfile(RootFolder, 'Settings', 'ChannelLib.json')));

            obj.Channel    = struct2table(channelTempLib.Channel);
            obj.Exception  = struct2table(channelTempLib.Exception);
            obj.FindPeaks  = struct2table(channelTempLib.FindPeaks);

            obj.DefaultChannelStep = channelTempLib.DefaultChannelStep;
            obj.DefaultMinBandSpan = channelTempLib.DefaultMinBandSpan;
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
                        if emission_downLim > obj.Channel.Band{ii}(2) || emission_upLim < obj.Channel.Band{ii}(1)
                            continue
                        end

                        FreqStart   = specData.UserData.channelManual.FirstChannel(ii);
                        FreqStop    = specData.UserData.channelManual.LastChannel(ii);
                        StepWidth   = specData.UserData.channelManual.StepWidth(ii);
    
                        Channels = [Channels, FreqStart:StepWidth:FreqStop];
                    end
            end
        end
    end
end