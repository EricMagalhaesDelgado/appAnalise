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
        function idx = FindBand(obj, specData)
        
            FreqStart  = specData.MetaData.FreqStart/1e+6;
            FreqStop   = specData.MetaData.FreqStop /1e+6;

            BandLimits = cell2mat(obj.Channel.Band);
            BandLimits = [BandLimits(1:2:end), BandLimits(2:2:end)]; 
        
            idx = find(((FreqStart >= BandLimits(:,1)) & (FreqStart <= BandLimits(:,2))) | ...
                       ((FreqStart <= BandLimits(:,1)) & (FreqStop  >= BandLimits(:,1))));
        end


        %-----------------------------------------------------------------%
        function Truncated = TruncatedFrequency(obj, specData, idxEmission)

            ChannelList = [];
            if ~isempty(specData.UserData.channelLibIndex) && ~isempty(specData.UserData.channelManual)
                ChannelList = TruncatedFrequency_channelLibIndex(obj, specData, 'Lib',    ChannelList, idxEmission);
                ChannelList = TruncatedFrequency_channelLibIndex(obj, specData, 'Custom', ChannelList, idxEmission);

            elseif ~isempty(specData.UserData.channelLibIndex)
                ChannelList = TruncatedFrequency_channelLibIndex(obj, specData, 'Lib',    ChannelList, idxEmission);

            elseif ~isempty(specData.UserData.channelManual)
                ChannelList = TruncatedFrequency_channelLibIndex(obj, specData, 'Custom', ChannelList, idxEmission);
            end

            if isempty(ChannelList)
                FreqStart   = round(specData.MetaData.FreqStart ./ 1e+6, 1);  % Hz >> MHz
                FreqStop    = specData.MetaData.FreqStop  ./ 1e+6;            % Hz >> MHz
                StepWidth   = obj.DefaultChannelStep;

                ChannelList = FreqStart:StepWidth:FreqStop;
            end
            ChannelList  = unique(ChannelList);

            [~, idxFind] = min(abs(ChannelList - specData.UserData.Emissions.FreqCenter(idxEmission)));
            Truncated    = ChannelList(idxFind);
        end


        %-----------------------------------------------------------------%
        function ChannelList = TruncatedFrequency_channelLibIndex(obj, specData, truncatedType, ChannelList, idxEmission)

            emission_downLim = specData.UserData.Emissions.FreqCenter(idxEmission) - specData.UserData.Emissions.BW(idxEmission)/2000;
            emission_upLim   = specData.UserData.Emissions.FreqCenter(idxEmission) + specData.UserData.Emissions.BW(idxEmission)/2000;

            switch truncatedType
                case 'Lib'
                    for ii = specData.UserData.channelLibIndex'
                        if emission_downLim > obj.Channel.Band{ii}(2) || emission_upLim < obj.Channel.Band{ii}(1)
                            continue
                        end

                        if ~isempty(obj.Channel.FreqList{ii})
                            ChannelList = [ChannelList, obj.Channel.FreqList{ii}];
    
                        else    
                            FreqStart   = obj.Channel.FirstChannel(ii);
                            FreqStop    = obj.Channel.LastChannel(ii);
                            StepWidth   = obj.Channel.StepWidth(ii);
        
                            ChannelList = [ChannelList, FreqStart:StepWidth:FreqStop];
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
    
                        ChannelList = [ChannelList, FreqStart:StepWidth:FreqStop];
                    end
            end
        end
    end
end