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
        function TruncatedList = TruncatedFrequency(obj, specData, FreqList)
        
            idx1 = FindBand(obj, specData);
            
            TruncatedList = [];
            for ii = numel(FreqList):-1:1
                if ~isempty(idx1) && FreqList(ii) >= obj.Channel.FreqStart(idx1)/1e+6 && FreqList(ii) <= obj.Channel.FreqStart(idx1)/1e+6
                    Channels  = obj.Channel.Channels{idx1};
        
                else
                    FreqStart = specData.MetaData.FreqStart ./ 1e+6;            % Hz >> MHz
                    FreqStop  = specData.MetaData.FreqStop  ./ 1e+6;            % Hz >> MHz
                    Channels  = FreqStart:obj.DefaultChannelStep:FreqStop;
                end
        
                [~, idx2] = min(abs(Channels - FreqList(ii)));
                TruncatedList(ii,1) = Channels(idx2);
            end
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
    end
end